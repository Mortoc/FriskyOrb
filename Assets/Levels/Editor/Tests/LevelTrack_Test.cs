using UnityEngine;
using UnityTest;
using NUnit.Framework;

using System;
using System.Collections.Generic;
using System.Linq;

namespace RtInfinity.Levels.Test
{
    [TestFixture]
    [Category("Gameplay")]
    internal class LevelTrack_Test : IDisposable
    {
		private TrackGenerator _generator = new MockTrackGenerator();
		private GameObject _fixtureGameObject = new GameObject("TestTrack");

		
		public void Dispose ()
		{
			GameObject.DestroyImmediate(_fixtureGameObject);
		}

        [Test]
        public void LevelTrackPivotsAreAtPathStart()
        {
            var track = _fixtureGameObject.GetOrAddComponent<LevelTrack>();
            track.Init(_generator, 4);

            var segments = track.Generate();

            foreach (var seg in segments)
            {
                UAssert.Near(seg.Loft.Path.PositionSample(0.0f), Vector3.zero, 0.01f);
            }
        }

        [Test]
        public void LevelTracksArePlacedEndToEnd()
        {
            var track = _fixtureGameObject.GetOrAddComponent<LevelTrack>();
            track.Init(_generator, 4);

            var segments = track.Generate();
            var prevEnd = Vector3.zero;
            foreach (var seg in segments)
            {
                var segmentStart = seg.transform.TransformPoint(
                    seg.Loft.Path.PositionSample(0.0f)
                );
                
                UAssert.Near(segmentStart, prevEnd, 0.01f);

                prevEnd = seg.transform.TransformPoint(
                    seg.Loft.Path.PositionSample(1.0f)
                );
            }
        }

		[Test]
		public void GetSurfacePointDoesntBreakAcrossBoundaries()
		{
			var track =  _fixtureGameObject.GetOrAddComponent<LevelTrack>();
			track.Init (_generator, 2);
			var segments = new List<TrackSegment>(track.Generate());

			var segment0 = segments[0];
			var segment1 = segments[1];

			var seg0Pnt = track.GetSurfacePoint(segment0.EndDist, 0.25f);
			var seg1Pnt = track.GetSurfacePoint(segment1.StartDist, 0.25f);

			UAssert.Near(seg0Pnt, seg1Pnt, 0.01f);
			UAssert.NotNear(Vector3.zero, seg0Pnt, 0.1f);
		}

		[Test]
		public void TrackSegmentsAreSeamless()
		{
			var track = _fixtureGameObject.GetOrAddComponent<LevelTrack>();
			track.Init (_generator, 2);
			var segments = new List<TrackSegment>(track.Generate());
			var segment0 = segments[0];
			var segment1 = segments[1];

			var pathSeamPoint = segment0.transform.TransformPoint(
				segment0.Loft.Path.PositionSample(1.0f)
			);
			var pathSeamDir = segment0.Loft.Path.ForwardVector(1.0f);

			// Make sure the SurfacePoints match on the seam
			for(float x = 0.0f; x < 1.0f; x += 0.1f) 
			{
				UAssert.Near
				(
					segment0.transform.TransformPoint(segment0.Loft.SurfacePoint(1.0f, x)),
					segment1.transform.TransformPoint(segment1.Loft.SurfacePoint(0.0f, x)),
					0.001f
				);
			}

			// make sure all the verts on the seam match properly
			var segment0Mesh = segment0.GetComponent<MeshFilter>().sharedMesh;
			var segment1Mesh = segment1.GetComponent<MeshFilter>().sharedMesh;
			var seg0SeamVertIndices = VertIndicesOnSeam(segment0Mesh, segment0.transform, pathSeamDir, pathSeamPoint);
			var seg1SeamVertIndices = VertIndicesOnSeam(segment1Mesh, segment1.transform, pathSeamDir, pathSeamPoint);

			Assert.Greater(seg0SeamVertIndices.Count, 0);
			Assert.Greater(seg1SeamVertIndices.Count, 0);
			Assert.AreEqual(seg0SeamVertIndices.Count, seg1SeamVertIndices.Count);

			// Each of the verts in seg0 should have a pair in seg1
			var verticesPaired = new Tuple<int, int>[seg0SeamVertIndices.Count];
			for(int i = 0; i < seg0SeamVertIndices.Count; ++i) 
			{
				int? positionPair = null;
				var seg0Pos = segment0Mesh.vertices[seg0SeamVertIndices[i]];

				for(int j = 0; j < seg1SeamVertIndices.Count; ++j)
				{
					var seg1Pos = segment1Mesh.vertices[seg1SeamVertIndices[j]];

					if( (segment0.transform.TransformPoint(seg0Pos) - segment1.transform.TransformPoint(seg1Pos)).magnitude < 0.0001f )
						positionPair = j;
				}

				Assert.IsNotNull(positionPair, "No pair for vert at " + seg0Pos);
				verticesPaired[i] = Tuple.New(i, (int)positionPair);
			}

			// Each of the verts should have the same normal, color, tangent, etc. UVs should loop
			foreach( var vertPair in verticesPaired )
			{
				var norm1 = segment0Mesh.normals[vertPair.First];
				var norm2 = segment0Mesh.normals[vertPair.Second];
				UAssert.Near(norm1, norm2, 0.0001f);
				
				var color1 = segment0Mesh.colors[vertPair.First];
				var color2 = segment0Mesh.colors[vertPair.Second];
				UAssert.Near(color1.ToVector3(), color2.ToVector3(), 0.0001f);
				
				var tangent1 = segment0Mesh.tangents[vertPair.First];
				var tangent2 = segment0Mesh.tangents[vertPair.Second];
				UAssert.Near(tangent1, tangent2, 0.0001f);
			}
		}

		private List<int> VertIndicesOnSeam(Mesh mesh, Transform transform, Vector3 seamNormal, Vector3 seamPoint)
		{
			var result = new List<int>();
			for(int i = 0; i < mesh.vertexCount; ++i) 
			{
				var vertWorldPos = transform.TransformPoint(mesh.vertices[i]);

				var vertDistToPlane = MathExt.SignedDistancePlanePoint
				(
					seamNormal, 
					seamPoint,
					vertWorldPos
				);

				if( Mathf.Abs(vertDistToPlane) < 0.00001f )
					result.Add(i);
			}
			return result;
		}

		[Test]
		public void UpdatingPlayerDistanceMakesNewTracksAndCleansUpOldOnes()
		{
			var track =  _fixtureGameObject.GetOrAddComponent<LevelTrack>();
			track.Init(_generator, 4);
			
			var initialSegments = new List<TrackSegment>(track.Generate());
			
			track.UpdatePlayerPosition(initialSegments[0].EndDist * 1.001f);

			var updatedSegments = new List<TrackSegment>(track.ActiveSegments);
			for(int i = 1; i < 3; ++i)
				Assert.AreSame(updatedSegments[i - 1], initialSegments[i]);

			Assert.IsFalse(initialSegments[0], "The first segment is destroyed in Unity");
			Assert.IsTrue(updatedSegments[3], "The newest segment was created");
		}
    }
}
