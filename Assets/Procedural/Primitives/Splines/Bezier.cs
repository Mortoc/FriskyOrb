using UnityEngine;

using System;
using System.Collections.Generic;

using System.Linq;

public class Bezier : ISpline
{
	public struct ControlPoint
    {
		public Vector3 Point { get; set; }
		public Vector3 InTangent { get; set; }
		public Vector3 OutTangent { get; set; }

		public ControlPoint(Vector3 point)
			: this(point, point, point) {}

		public ControlPoint(Vector3 point, Vector3 tangent)
			: this(point, tangent, point + (point - tangent)) {}

		public ControlPoint(Vector3 point, Vector3 inTangent, Vector3 outTangent)
		{
			this.Point = point;
			this.InTangent = inTangent;
			this.OutTangent = outTangent;
		}
    }

    private ControlPoint[] _controlPoints;

    private static Vector3 NextPoint(Vector3[] points, int currentIdx, bool closed)
    {
        var nextIdx = currentIdx + 1;
        if( nextIdx >= points.Length )
        {
            if( closed )
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
        if( lastIdx < 0 )
        {
            if( closed )
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

    	for(int i = 0; i < pointsArray.Length; ++i)
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

        if(closed)
            ctrlPts.Add(ctrlPts.First());

    	return new Bezier(ctrlPts);
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

	public Bezier(IEnumerable<ControlPoint> controlPoints)
	{
		UpdateControlPoints(controlPoints);
	}

	public IEnumerable<ControlPoint> ControlPoints
    {
    	get { return _controlPoints; }
    }

	private void UpdateControlPoints(IEnumerable<ControlPoint> controlPoints)
	{
		var cpList = new List<ControlPoint>(controlPoints);
		if( cpList.Count < 2 )
			throw new ArgumentException("A Bezier requires at least 2 controlPoints");
		
		_controlPoints = cpList.ToArray();
	}

    public Vector3 PositionSample(float t)
    {
    	float cpCount = _controlPoints.Length - 1.0f;
    	float segmentSpaceT = Mathf.Clamp01(t) * cpCount;
    	int startSegment = Mathf.FloorToInt(segmentSpaceT);
    	float tInSegment = segmentSpaceT - Mathf.Floor(segmentSpaceT);

    	if( tInSegment <= 0.0f )
    		return _controlPoints[startSegment].Point;
    	if( tInSegment >= 1.0f )
    		return _controlPoints[startSegment + 1].Point;

		float pntBFactor = tInSegment;
		float pntAFactor = 1.0f - pntBFactor;

    	Vector3 pntA = _controlPoints[startSegment].Point;
    	Vector3 cpA = _controlPoints[startSegment].OutTangent;
    	Vector3 pntB = _controlPoints[startSegment + 1].Point;
    	Vector3 cpB = _controlPoints[startSegment + 1].InTangent;

		float a2 = pntAFactor * pntAFactor;
		float a3 = a2 * pntAFactor;
		float b2 = pntBFactor * pntBFactor;
		float b3 = b2 * pntBFactor;

		return pntA * a3 +
			   cpA * 3.0f * a2 * pntBFactor + 
			   cpB * 3.0f * pntAFactor * b2 +
			   pntB * b3;
	}

    public Vector3 ForwardSample(float t)
    {
        if( t < 0.001f )
        {
            return (_controlPoints[0].OutTangent - _controlPoints[0].Point).normalized;
        }
        else if( t > 0.999f )
        {
            int lastIdx = _controlPoints.Length - 1;
            return (_controlPoints[lastIdx].OutTangent - _controlPoints[lastIdx].Point).normalized;
        }

        float recipCpCount = 1.0f / (float)_controlPoints.Length;
        var beforeSample = PositionSample(Mathf.Clamp01(t - (0.01f * recipCpCount)));
        var afterSample = PositionSample(Mathf.Clamp01(t + (0.01f * recipCpCount)));

        return (afterSample - beforeSample).normalized;
    }
}
