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

		
        [Test]
        public void LoftMeshGenerationVerification()
        {
        	var tube = BuildTube(10.0f, 1.0f);

        	Mesh loftMesh = tube.GenerateMesh(10, 16);

        	// Vert and Tri counts are expected values
        	Assert.AreEqual(16*10, loftMesh.vertexCount);
        	Assert.AreEqual(15*9*2, loftMesh.triangles.Length/3);

        	for(int tri = 0; tri < loftMesh.triangles.Length; tri += 3)
        	{
        		// All triangles' face normals point away from the shape
        		var center = loftMesh.FaceCenter(tri);
        		var normal = loftMesh.FaceNorm(tri);
        		center.y = 0.0f;
        		UAssert.Near(center.normalized, normal, 0.001f);

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

    }
}