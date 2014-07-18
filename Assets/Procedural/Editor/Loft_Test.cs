using UnityEngine;
using UnityTest;
using NUnit.Framework;

using System;
using System.Collections.Generic;
using System.Linq;


namespace Procedural.Test
{
    [TestFixture]
    internal class Loft_Test
    {

		public Loft BuildTube(float length, float radius)
		{
			var tubePath = Bezier.ConstructSmoothSpline(
	    		new Vector3[]{
	    			Vector3.zero,
	    			new Vector3(0.0f, length, 0.0f)
	    		}
	    	);

	    	var tubeShape = Bezier.ConstructSmoothSpline(
	    		new Vector3[]{
	    			new Vector3(0.0f, 0.0f, radius),
	    			new Vector3(radius, 0.0f, 0.0f),
	    			new Vector3(0.0f, 0.0f, -radius),
	    			new Vector3(-radius, 0.0f, 0.0f)
	    		},
	    		true
	    	);

			return new Loft(tubePath, tubeShape);
		}

		public Loft BuildTorus(float radius, float thickness)
		{
			var torusPath = Bezier.ConstructSmoothSpline(
	    		new Vector3[]{
	    			new Vector3(0.0f, radius, 0.0f),
	    			new Vector3(radius, 0.0f, 0.0f),
	    			new Vector3(0.0f, -radius, 0.0f),
	    			new Vector3(-radius, 0.0f, 0.0f)
	    		}
	    	);

	    	var torusShape = Bezier.ConstructSmoothSpline(
	    		new Vector3[]{
	    			new Vector3(0.0f, 0.0f, radius),
	    			new Vector3(radius, 0.0f, 0.0f),
	    			new Vector3(0.0f, 0.0f, -radius),
	    			new Vector3(-radius, 0.0f, 0.0f)
	    		},
	    		true
	    	);

			return new Loft(torusPath, torusShape);
		}

		
        [Test]
        public void LoftMeshGenerationVerification()
        {
        	var tube = BuildTube(10.0f, 1.0f);

        	Mesh loftMesh = tube.GenerateMesh(10, 16);

        	// Vert and Tri counts are expected values
        	Assert.AreEqual(16*11, loftMesh.vertexCount);
        	Assert.AreEqual(16*10*2, loftMesh.triangles.Length/3);

        	for(int tri = 0; tri < loftMesh.triangles.Length; tri += 3)
        	{
        		// All triangles' face normals point away from the shape
        		var center = loftMesh.FaceCenter(tri);
        		var normal = loftMesh.FaceNorm(tri);
        		center.y = 0.0f;
        		UAssert.Near(Vector3.Dot(-center.normalized, normal), 1.0f, 0.01f);

        		// All the triangles' verts are in different locations
				var v1 = loftMesh.vertices[loftMesh.triangles[tri]];
				var v2 = loftMesh.vertices[loftMesh.triangles[tri + 1]];
				var v3 = loftMesh.vertices[loftMesh.triangles[tri + 2]];

				UAssert.NotNear(v1, v2, 0.0001f);
				UAssert.NotNear(v1, v3, 0.0001f);
				UAssert.NotNear(v2, v3, 0.0001f);
        	}

        	Mesh.DestroyImmediate(loftMesh);
        }

        [Test]
        public void LoftAlignsShapeToPathDirection()
        {
        	var torus = BuildTorus(1.0f, 0.25f);
        	var shapeSamples = 16u;
        	var pathSamples = 16u;
        	Mesh loftMesh = torus.GenerateMesh(pathSamples, shapeSamples);

        	for(int p = 0; p < pathSamples; ++p)
        	{
        		var pathT = (float)p / (float)pathSamples;
        		var pathDir = torus.Path.ForwardSample(pathT);
        		var pathPos = torus.Path.PositionSample(pathT);
        		for(int s = 0; s < shapeSamples - 1; ++s)
        		{
        			var vertIdx = (pathSamples*p) + s;
        			var vert = loftMesh.vertices[vertIdx];
        			var nextVertIdx = vertIdx + 1;
        			var nextVert = loftMesh.vertices[nextVertIdx];
        			var vertsCrossCenter = Vector3.Cross(vert - pathPos, nextVert - pathPos);
        			
        			UAssert.Near(pathDir, vertsCrossCenter.normalized, 0.05f);
        		}
        	}
        	Mesh.DestroyImmediate(loftMesh);
        }

		[Test]
        public void LoftGenerateProperNormals()
        {
        	var tube = BuildTube(10.0f, 1.0f);
        	Mesh loftMesh = tube.GenerateMesh(10, 16);
        	
        	for(int tri = 0; tri < loftMesh.triangles.Length; tri += 3)
        	{
				var n1 = loftMesh.normals[loftMesh.triangles[tri]];
				var n2 = loftMesh.normals[loftMesh.triangles[tri + 1]];
				var n3 = loftMesh.normals[loftMesh.triangles[tri + 2]];
				
				// Have any normals
				UAssert.Near(1.0f, n1.sqrMagnitude, 0.001f);
				UAssert.Near(1.0f, n2.sqrMagnitude, 0.001f);
				UAssert.Near(1.0f, n3.sqrMagnitude, 0.001f);
        	}

        	Mesh.DestroyImmediate(loftMesh);
        }
    }
}