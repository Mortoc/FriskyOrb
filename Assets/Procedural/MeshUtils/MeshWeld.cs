using UnityEngine;
using System;


namespace Procedural
{
	public static class MeshOperations
	{
		// Sets the norms and positions of near verts to be the same,
		// doesn't combine meshes
		public static void SoftWeld(Mesh mesh1, Mesh mesh2, float weldRadius)
		{
			Func<Vector3, Vector3> noTransform = v => v;
			SoftWeldImpl(mesh1, noTransform, mesh2, noTransform, weldRadius);
		}

		public static void SoftWeld(Mesh mesh1, Transform transform1, Mesh mesh2, Transform transform2, float weldRadius)
		{
			SoftWeldImpl(mesh1, transform1.TransformPoint, mesh2, transform2.TransformPoint, weldRadius);
		}

		private static void SoftWeldImpl(Mesh mesh1, Func<Vector3, Vector3> transformFunc1, Mesh mesh2, Func<Vector3, Vector3> transformFunc2, float weldRadius)
		{
			var weldRadSqr = weldRadius * weldRadius;
			var verts1 = mesh1.vertices;
			var verts2 = mesh2.vertices;
			var norms1 = mesh1.normals;
			var norms2 = mesh2.normals;

			for(int i = 0; i < mesh1.vertexCount; ++i)
			{
				for(int j = 0; j < mesh2.vertexCount; ++j)
				{
					if( (verts1[i] - verts2[j]).sqrMagnitude < weldRadSqr )
					{
						var newPos = Vector3.Lerp (mesh1.vertices[i], verts2[j], 0.5f);
						verts1[i] = newPos;
						verts2[j] = newPos;

						Debug.Log ("Old Norms: " + norms1[i] + ", " + norms2[j]);
						var newNorm = Vector3.Slerp(norms1[i], norms2[j], 0.5f);
						norms1[i] = newNorm;
						norms2[j] = newNorm;
						Debug.Log ("New Norm: " + newNorm);
					}
				}
			
			}

			mesh1.vertices = verts1;
			mesh2.vertices = verts2;

			mesh1.normals = norms1;
			mesh2.normals = norms2;

			mesh1.RecalculateBounds();
			mesh2.RecalculateBounds();
		}
	}
}