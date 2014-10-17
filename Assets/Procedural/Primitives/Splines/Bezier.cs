using UnityEngine;

using System;
using System.Collections.Generic;

namespace Procedural
{
    public class Bezier : ISpline
    {
        public struct ControlPoint : IControlPoint
        {
            public Vector3 Point { get; set; }
            public Vector3 InTangent { get; set; }
            public Vector3 OutTangent { get; set; }
            public Vector3 Up { get; set; }

            public ControlPoint(Vector3 point)
                : this(point, point, point) { }

            public ControlPoint(Vector3 point, Vector3 tangent)
                : this(point, tangent, point + (point - tangent)) { }

            public ControlPoint(Vector3 point, Vector3 inTangent, Vector3 outTangent)
                : this(point, inTangent, outTangent, Vector3.zero)
            {
                var inTanRelative = inTangent - point;
                var outTanRelative = outTangent - point;
                var possibleUp = Vector3.Cross(inTanRelative, outTanRelative);
                var upMag = possibleUp.magnitude;

                // if point, in and out tangents are linear, build an approx up
                if (Mathf.Approximately(upMag, 0.0f))
                {
                    var right = Vector3.Cross(inTanRelative, Vector3.up);
                    Up = Vector3.Cross(right, inTanRelative).normalized;
                }
                else
                {
                    // normalize upvector
                    Up = possibleUp / upMag;
                }
            }

            public ControlPoint(Vector3 point, Vector3 inTangent, Vector3 outTangent, Vector3 upVector)
            {
                this.Point = point;
                this.InTangent = inTangent;
                this.OutTangent = outTangent;
                this.Up = upVector;
            }

            public ControlPoint ScaleTangents(float percent)
            {
                var inTanDiff = InTangent - Point;
                InTangent = (inTanDiff * percent) + Point;

                var outTanDiff = OutTangent - Point;
                OutTangent = (outTanDiff * percent) + Point;

                return this;
            }
        }

        private ControlPoint[] _controlPoints;
        private float _recipControlPntCount;

		public IControlPoint LastControlPoint
		{
			get { return _controlPoints[_controlPoints.Length - 1]; }
		}
		
		public IControlPoint FirstControlPoint
		{
			get { return _controlPoints[0]; }
		}

        private static Vector3 NextPoint(Vector3[] points, int currentIdx, bool closed)
        {
            var nextIdx = currentIdx + 1;
            if (nextIdx >= points.Length)
            {
                if (closed)
                {
                    nextIdx = 0;
                }
                else
                {
                    nextIdx = currentIdx;
                }
            }
            return points[nextIdx];
        }

        private static Vector3 LastPoint(Vector3[] points, int currentIdx, bool closed)
        {
            var lastIdx = currentIdx - 1;
            if (lastIdx < 0)
            {
                if (closed)
                {
                    lastIdx = points.Length - 1;
                }
                else
                {
                    lastIdx = currentIdx;
                }
            }
            return points[lastIdx];
        }

        public static Bezier ConstructSmoothSpline(IEnumerable<Vector3> points, bool closed = false)
        {
            var pointsArray = new List<Vector3>(points).ToArray();
            var ctrlPts = new List<ControlPoint>();

            for (int i = 0; i < pointsArray.Length; ++i)
            {
                var pnt = pointsArray[i];

                var lastPnt = LastPoint(pointsArray, i, closed);
                var nextPnt = NextPoint(pointsArray, i, closed);

                var lastToPntOvershoot = (pnt - lastPnt) + pnt;
                var nextToPntOvershoot = (pnt - nextPnt) + pnt;

                var inTangent = Vector3.Lerp(lastPnt, nextToPntOvershoot, 0.5f);
                var outTangent = Vector3.Lerp(nextPnt, lastToPntOvershoot, 0.5f);

                inTangent = Vector3.Lerp(pnt, inTangent, 0.5f);
                outTangent = Vector3.Lerp(pnt, outTangent, 0.5f);

                var cp = new ControlPoint(pnt, inTangent, outTangent);

                ctrlPts.Add(cp);
            }

            if (closed)
                ctrlPts.Add(ctrlPts[0]);

            return new Bezier(ctrlPts);
        }

        public static Bezier Circle(float radius)
        {
            return Bezier.ConstructSmoothSpline(
                new Vector3[]
				{
                    new Vector3(-radius, 0.0f, 0.0f),
                    new Vector3(0.0f, 0.0f, -radius),
                    new Vector3(radius, 0.0f, 0.0f),
                    new Vector3(0.0f, 0.0f, radius)
                },
                true
            );
        }

        public bool Closed
        {
            get
            {
                var firstCp = _controlPoints[0];
                var lastCp = _controlPoints[_controlPoints.Length - 1];

                return (firstCp.Point - lastCp.Point).sqrMagnitude < 0.0001f;
            }
        }

        internal void PerformControlPointOperation(Func<ControlPoint, ControlPoint> op)
        {
            for (int i = 0; i < _controlPoints.Length; ++i)
                _controlPoints[i] = op(_controlPoints[i]);
        }

        public Bezier(IEnumerable<ControlPoint> controlPoints)
        {
            UpdateControlPoints(controlPoints);
        }

        public IControlPoint this[int index]
        {
            get
            {
                return _controlPoints[index];
            }
        }

        public int ControlPointCount
        {
            get { return _controlPoints.Length; }
        }

        public IEnumerator<ControlPoint> GetEnumerator()
        {
            foreach (var cp in _controlPoints)
                yield return cp;
        }

        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator()
        {
            return _controlPoints.GetEnumerator();
        }

        private void UpdateControlPoints(IEnumerable<ControlPoint> controlPoints)
        {
            var cpList = new List<ControlPoint>(controlPoints);
            if (cpList.Count < 2)
                throw new ArgumentException("A Bezier requires at least 2 controlPoints");

            _controlPoints = cpList.ToArray();
            _recipControlPntCount = 1.0f / (float)_controlPoints.Length;
        }

        private IEnumerable<Vector3> IterateControlPointElements()
        {
            foreach (var cp in _controlPoints)
            {
                yield return cp.InTangent;
                yield return cp.Point;
                yield return cp.OutTangent;
            }
        }

		// Converts T values to the (0 - 1) range
		private float ClampT(float t)
		{
			if( Closed )
				return t % 1.0f;
			else
				return Mathf.Clamp01 (t);
		}

        private struct CPSample
        {
            public int segmentIdx { get; set; }
            public float t { get; set; }
        }

        private CPSample GetCPSample(float splineT)
        {
            float cpCount = _controlPoints.Length - 1.0f;
			float segmentSpaceT = Mathf.Clamp01(splineT) * cpCount;
            int startSegment = Mathf.FloorToInt(segmentSpaceT);
            float tInSegment = segmentSpaceT - Mathf.Floor(segmentSpaceT);

            return new CPSample()
            {
                segmentIdx = startSegment,
				t = ClampT(tInSegment)
            };
        }

        public Vector3 PositionSample(float t)
        {
            var cpSample = GetCPSample(t);

            if (cpSample.t <= 0.0f)
                return _controlPoints[cpSample.segmentIdx].Point;
            if (cpSample.t >= 1.0f)
                return _controlPoints[cpSample.segmentIdx + 1].Point;

            float pntBFactor = cpSample.t;
            float pntAFactor = 1.0f - pntBFactor;

            Vector3 pntA = _controlPoints[cpSample.segmentIdx].Point;
            Vector3 cpA = _controlPoints[cpSample.segmentIdx].OutTangent;
            Vector3 pntB = _controlPoints[cpSample.segmentIdx + 1].Point;
            Vector3 cpB = _controlPoints[cpSample.segmentIdx + 1].InTangent;

            float a2 = pntAFactor * pntAFactor;
            float a3 = a2 * pntAFactor;
            float b2 = pntBFactor * pntBFactor;
            float b3 = b2 * pntBFactor;

            return pntA * a3 +
                   cpA * 3.0f * a2 * pntBFactor +
                   cpB * 3.0f * pntAFactor * b2 +
                   pntB * b3;
        }

        public Vector3 RightVector(float t)
        {
            var up = UpVector(t);
            var forward = ForwardVector(t);
            return Vector3.Cross(up, forward);
        }

        public Vector3 UpVector(float t)
        {
            var cpSample = GetCPSample(t);

            if (cpSample.t <= 0.0f)
			{
                return _controlPoints[cpSample.segmentIdx].Up;
			}
            if (cpSample.t >= 1.0f)
			{
                return _controlPoints[cpSample.segmentIdx + 1].Up;
			}

            var cpUp = Vector3.Lerp(
                _controlPoints[cpSample.segmentIdx].Up,
                _controlPoints[cpSample.segmentIdx + 1].Up,
                cpSample.t
            );

            // Project the cpUp to the plane defined by the forward vector
            return MathExt.ProjectPointOnPlane(ForwardVector(t), Vector3.zero, cpUp).normalized;
        }

        public Vector3 ForwardVector(float t)
        {
			var offset = 0.01f * _recipControlPntCount;


			Vector3 beforeSample;
			Vector3 afterSample;
			
			beforeSample = PositionSample(ClampT(t - offset));
			afterSample = PositionSample(ClampT(t + offset));

			return (beforeSample - afterSample).normalized;
        }

        public float DistanceSample(float t)
        {
            t = Mathf.Clamp01(t);
            if (t == 0.0f)
                return 0.0f;

            // for now, do a dumb approximation until I get more time
            // to math this properly
            var sampleCount = 12;

            var dist = 0.0f;
            var step = 1.0f / (float)sampleCount;
            var current = step;
            var lastSample = PositionSample(0.0f);
            for (var i = 0; i < sampleCount; ++i)
            {
                var sample = PositionSample(current);
                dist += (sample - lastSample).magnitude;
                lastSample = sample;
                current += step;
            }

            return dist * t;
        }

		public float ClosestT(Vector3 point)
		{
			// initial samples: one on each CP and each CP midpoint
			// This makes sure if the path is loopy, we find the
			// actual nearest segment without bailing out too early.
			var initialSamples = (_controlPoints.Length * 2) - 1;

			var step = 1.0f / (float)initialSamples;
			var t = 0.0f;
			var closest = PositionSample(t);
			var closestSqrMag = (point - closest).sqrMagnitude;
			var closestT = 0.0f;

			for(int i = 1; i < initialSamples; ++i)
			{
				t += step;
				var sample = PositionSample(t);
				var sampleSqrMag = (point - sample).sqrMagnitude;
				if( sampleSqrMag < closestSqrMag )
				{
					closest = sample;
					closestT = t;
					closestSqrMag = sampleSqrMag;
				}
			}

			// Now that we have the rough segment to search, do a more fine grained search
			var start = Mathf.Clamp01 (t - (step * 0.5f));
			var end = Mathf.Clamp01(t + (step * 0.5f));
			var smallStep = step * 0.1f;
			for(t = start; t < end; t += smallStep)
			{
				var sample = PositionSample(t);
				var sampleSqrMag = (point - sample).sqrMagnitude;

				if( sampleSqrMag < closestSqrMag )
				{
					closest = sample;
					closestT = t;
					closestSqrMag = sampleSqrMag;
				}
			}
			return closestT;
		}

        public Mesh Triangulate(uint samples)
        {
            return Triangulate(samples, Vector3.zero);
        }

        public Mesh Triangulate(uint samples, Vector3 offset)
        {
            if (!Closed)
                throw new InvalidOperationException("Only Closed Beziers can be Triangulated");

            var center = Vector3.zero;
            var cpCount = 0.0f;
            foreach (var cp in _controlPoints)
            {
                center += cp.Point;
                cpCount += 1.0f;
            }
            center /= cpCount;

            var dirStart = ForwardVector(0.0f);
            var pntStart = PositionSample(0.0f);

            var up = Vector3.Cross(dirStart, pntStart - center);

            var mesh = new Mesh();
            var verts = new Vector3[samples];
            var norms = new Vector3[samples];

            float step = 1.0f / (float)samples;
            float t = 0.0f;
            for (uint i = 0; i < samples; ++i)
            {
                verts[i] = PositionSample(t) + offset;
                t += step;
                norms[i] = up;
            }

            mesh.vertices = verts;
            mesh.normals = norms;
            mesh.triangles = Triangulator.Triangulate(verts, up);

            return mesh;
        }

        IEnumerator<IControlPoint> IEnumerable<IControlPoint>.GetEnumerator()
        {
            foreach (var cp in _controlPoints)
                yield return cp;
        }
    }
}