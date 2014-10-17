using UnityEngine;
using System;


namespace Procedural
{
	public class NormVisualizer : MonoBehaviour 
	{
		public Color _color = Color.red;

		void OnDrawGizmos()
		{
			var meshFilter = GetComponent<MeshFilter>();
			Func<Vector3, Vector3> transformFunc = transform.TransformPoint;

			if( meshFilter && meshFilter.sharedMesh )
			{
				Gizmos.color = _color;
				var mesh = meshFilter.sharedMesh;

				for(int v = 0; v < mesh.vertexCount; ++v)
				{
					var vert = transformFunc(mesh.vertices[v]);
					var norm = mesh.normals[v];
					Gizmos.DrawLine(vert, vert + norm);
				}
			}
		}
	}
}