using UnityEngine;

using System;
using System.Collections.Generic;


namespace Procedural
{
	[ExecuteInEditMode]
	public class LayeredPlateau : GeneratedMeshObject 
	{
		public int randomSeed = 0;
		public int layerCount = 3;
		public int radiusSegments = 24;
		public int heightSegments = 2;

		protected override void GenerateMesh()
		{
			foreach(Transform child in transform)
				DestroyImmediate(child.gameObject);

	        var rand = new MersenneTwister(randomSeed);

	        var totalHeight = 0.0f;
		    var scaleDown = 1.0f;
		    var combineMeshInstances = new CombineInstance[layerCount];
	        for(int i = 0; i < layerCount; ++i)
	        {
	        	var baseRadius = Mathf.Lerp(8.0f, 10.0f, rand.NextSinglePositive()) * scaleDown;
		        var baseBezier = Bezier.Circle(baseRadius * scaleDown);

		        var previousTotalHeight = totalHeight;
		        totalHeight += Mathf.Lerp(0.9f, 1.1f, rand.NextSinglePositive()) * scaleDown;
		        var heightBezier = Bezier.ConstructSmoothSpline(
		        	new Vector3[]{
		        		Vector3.up * previousTotalHeight, 
		        		Vector3.up * totalHeight
		        	}
		        );

		        combineMeshInstances[i].mesh = Loft.GenerateMesh(
		        	heightBezier, 
		        	baseBezier, 
		        	(uint)heightSegments, 
		        	(uint)(radiusSegments * scaleDown)
		        );

		        scaleDown *= Mathf.Lerp(0.75f, 0.9f, rand.NextSinglePositive());
	        }

	        var meshFilter = GetComponent<MeshFilter>();
	        if( meshFilter.sharedMesh )
	        	DestroyImmediate(meshFilter.sharedMesh);

	        meshFilter.sharedMesh = new Mesh();
	        meshFilter.sharedMesh.CombineMeshes(combineMeshInstances, true, false);

	        foreach(var combineInstance in combineMeshInstances)
	        	DestroyImmediate(combineInstance.mesh);
		}

		public override int GetHashCode()
		{
			return layerCount + randomSeed + radiusSegments + heightSegments;
		}
	}
}