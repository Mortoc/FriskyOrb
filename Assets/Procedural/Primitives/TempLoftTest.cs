using UnityEngine;
using System.Collections;

using Procedural;

[ExecuteInEditMode]
public class TempLoftTest : GeneratedMeshObject 
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
    			new Vector3(-radius, 0.0f, 0.0f),
                new Vector3(0.0f, 0.0f, -radius),
    			new Vector3(radius, 0.0f, 0.0f),
                new Vector3(0.0f, 0.0f, radius)			
            },
    		true
    	);

		return new Loft(tubePath, tubeShape);
	}

	protected override void GenerateMesh() 
	{
		var loft = BuildTube(0.6f, 1.0f);
		loft.Scale = new Bezier(new Bezier.ControlPoint[]{
            new Bezier.ControlPoint(
                new Vector3(0.0f, 0.0f, 0.0f),
                new Vector3(0.0f, -0.25f, 0.0f),
                new Vector3(0.0f, 0.25f, 0.0f)
            ),
            new Bezier.ControlPoint(
                new Vector3(0.5f, 0.1f, 0.0f),
                new Vector3(0.25f, 0.5f, 0.0f),
                new Vector3(0.75f, 0.5f, 0.0f)
            ),
            new Bezier.ControlPoint(
                new Vector3(1.0f, 0.0f, 0.0f),
                new Vector3(1.0f, 0.25f, 0.0f),
                new Vector3(1.0f, -0.25f, 0.0f)
            )
        });

		var meshFilter = gameObject.GetComponent<MeshFilter>();
		if( meshFilter.sharedMesh )
			DestroyImmediate(meshFilter.sharedMesh);
		meshFilter.sharedMesh = loft.GenerateMesh(24, 24);

		if( !renderer )
			gameObject.AddComponent<MeshRenderer>();
	}

	public override int GetHashCode()
	{
		return 11;
	}
}
