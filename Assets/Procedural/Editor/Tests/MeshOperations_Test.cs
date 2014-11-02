using UnityEngine;
using UnityTest;
using NUnit.Framework;

using System;
using System.Collections.Generic;
using System.Linq;


namespace Procedural.MeshOperations.Test
{
	[TestFixture]
	internal class MeshOperations_Test
	{
		private Mesh _mesh1;
		private Mesh _mesh2;
		
		[SetUp]
		public void Setup()
		{
			_mesh1 = new Mesh();

			_mesh1.vertices = new Vector3[]{
				new Vector3(0.0f, 0.0f, 0.0f),
				new Vector3(1.0f, 0.0f, 0.0f),
				new Vector3(1.0f, 0.0f, 1.0f),
				new Vector3(0.0f, 0.0f, 1.0f),
				new Vector3(0.0f, 0.0f, 1.0f)
			};
			
			_mesh1.normals = new Vector3[]{
				new Vector3(0.0f, 1.0f, 0.0f),
				new Vector3(0.0f, 1.0f, 0.0f),
				new Vector3(0.0f, 1.0f, 0.0f),
				new Vector3(0.0f, 1.0f, 0.0f),
				new Vector3(0.0f, 0.0f, 1.0f)
			};

			var quads1 = new int[]{
				0, 1, 2, 3
			};

			_mesh1.SetIndices(quads1, MeshTopology.Quads, 0);
			
			_mesh2 = new Mesh();
			
			_mesh2.vertices = new Vector3[]{
				new Vector3(0.0f, 0.0f, 0.0f),
				new Vector3(1.25f, 0.0f, 0.0f),
				new Vector3(1.0f, 0.0f, -1.0f),
				new Vector3(0.0f, 0.0f, -1.0f)
			};
			
			_mesh2.normals = new Vector3[]{
				new Vector3(0.0f, 1.0f, 0.0f),
				(new Vector3(1.0f, 1.0f, 0.0f)).normalized,
				(new Vector3(1.0f, 1.0f, 0.0f)).normalized,
				new Vector3(0.0f, 1.0f, 0.0f)
			};
			
			var quads2 = new int[]{
				3, 2, 1, 0
			};
			
			_mesh2.SetIndices(quads2, MeshTopology.Quads, 0);
		}
		
		[TearDown]
		public void Teardown()
		{
			Mesh.DestroyImmediate(_mesh1);
			Mesh.DestroyImmediate(_mesh2);
		}
		
		[Test]
		public void SoftWeldWorksOn2Meshes()
		{
			UAssert.NotNear(_mesh1.vertices[1], _mesh2.vertices[1], 0.00001f);
			UAssert.NotNear(_mesh1.normals[1], _mesh2.normals[1], 0.00001f);
			UAssert.NotNear(_mesh1.normals[2], _mesh2.normals[2], 0.00001f);

            var weld = new Weld(_mesh1, _mesh2);
			weld.SoftWeld(0.3333f);

			UAssert.Near(_mesh1.vertices[1], _mesh2.vertices[1], 0.00001f);
			UAssert.Near(_mesh1.normals[1], _mesh2.normals[1], 0.00001f);
			UAssert.NotNear(_mesh1.normals[2], _mesh2.normals[2], 0.00001f);

			UAssert.Near(_mesh1.normals[1], _mesh1.normals[1].normalized, 0.00001f);
			UAssert.Near(_mesh1.normals[2], _mesh1.normals[2].normalized, 0.00001f);
		}

		
		[Test]
		public void SoftWeldWorksOnTheSameMeshTwice()
		{
			UAssert.NotNear(_mesh1.normals[3], _mesh1.normals[4], 0.00001f);

            var weld = new Weld(_mesh1, _mesh1);
            weld.SoftWeld(0.3333f);
			
			UAssert.Near(_mesh1.normals[3], _mesh1.normals[4], 0.00001f);
			UAssert.Near(_mesh1.normals[3], _mesh1.normals[3].normalized, 0.00001f);
		}

		[Test]
		public void SoftWeldTakesInToAccountTransforms()
		{
            var gameObject1 = new GameObject("one");
            var gameObject2 = new GameObject("two");

            try
            {
                gameObject1.transform.position = Vector3.up;
                var verts1 = _mesh1.vertices;
                for (var i = 0; i < verts1.Length; ++i)
                    verts1[i] = verts1[i] - Vector3.up;
                _mesh1.vertices = verts1;

                var weld = new Weld(_mesh1, gameObject1.transform, _mesh2, gameObject2.transform);
                weld.SoftWeld(0.3333f);

                UAssert.Near(_mesh1.vertices[1], _mesh2.vertices[1], 0.00001f);
                UAssert.Near(_mesh1.normals[1], _mesh2.normals[1], 0.00001f);
                UAssert.NotNear(_mesh1.normals[2], _mesh2.normals[2], 0.00001f);

                UAssert.Near(_mesh1.normals[1], _mesh1.normals[1].normalized, 0.00001f);
                UAssert.Near(_mesh1.normals[2], _mesh1.normals[2].normalized, 0.00001f);
            }
            finally
            {
                GameObject.DestroyImmediate(gameObject1);
                GameObject.DestroyImmediate(gameObject2);
            }
		}
	}
}