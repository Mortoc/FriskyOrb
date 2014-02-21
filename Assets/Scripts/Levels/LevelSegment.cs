using UnityEngine;
using System;
using System.Collections.Generic;

public class LevelSegment : MonoBehaviour 
{
    [SerializeField]
    private float _width = 2.0f;

    [SerializeField]
    private AnimationCurve _rightProfile = new AnimationCurve
    (
        new Keyframe(0.0f, 1.0f),
        new Keyframe(0.0f, 1.0f)
    );

    [SerializeField]
    private AnimationCurve _leftProfile = new AnimationCurve
    (
         new Keyframe(0.0f, 1.0f),
         new Keyframe(0.0f, 1.0f)
    );

	private Spline.Segment _path = null;

	private Transform GetChildNamed(string name)
	{
		foreach( Transform child in transform )
		{
			if( child.name == name )
				return child;
		}

		throw new ArgumentException("No child with specified name found");
	}

	private Spline.Segment BuildPath()
	{
		Spline.Segment segment = new Spline.Segment(){
			A = GetChildNamed("A"),
			A_CP = GetChildNamed ("A_CP"),
			B = GetChildNamed("B"),
			B_CP = GetChildNamed("B_CP")
		};
		return segment;
	}

    private struct PathSample
    {
        public Vector3 left { get; set; }
        public Vector3 right { get; set; }
        public Vector3 normal
        {
            get { return Vector3.Cross(left, right).normalized; }
        }

        public override string ToString()
        {
            return "";
        }
    }

    private PathSample GetBounds(float t)
    {
        Vector3 pathPnt = Path.GetPoint(t);
        Vector3 pathNorm = Path.GetNormal(t);

        float profileT = 1.0f - t;
        float leftProfileVal = _leftProfile.Evaluate(profileT);
        float rightProfileVal = _rightProfile.Evaluate(profileT);
        Vector3 left = pathPnt + (pathNorm * leftProfileVal);
        Vector3 right = pathPnt - (pathNorm * rightProfileVal);

        return new PathSample()
        {
            left = left,
            right = right
        };
    }

    private Mesh BuildMesh(int detail)
    {
        int[] tris = new int[detail * 6];
        int vertCount = (detail * 2) + 2;
        Vector3[] verts = new Vector3[vertCount];
        Vector3[] norms = new Vector3[vertCount];
        Vector2[] uvs = new Vector2[vertCount];

        float rSteps = 1.0f / (float) detail;
        float t = 0.0f;
        for (int i = 0, v = 0, tri = -6; i < detail + 1; ++i, v += 2, tri += 6)
        {
            PathSample thisSample = GetBounds(t);
            
            int v1 = v + 1;
            verts[v] = thisSample.left;
            verts[v1] = thisSample.right;
            norms[v] = thisSample.normal;
            norms[v1] = norms[v];
            uvs[v] = new Vector2(1.0f, t);
            uvs[v1] = new Vector2(0.0f, t);

            if (tri >= 0)
            {
                int vm2 = v - 2;
                int vm1 = v - 1;

                tris[tri] = vm2;
                tris[tri + 1] = vm1;
                tris[tri + 2] = v;
                tris[tri + 3] = v1;
                tris[tri + 4] = v;
                tris[tri + 5] = vm1;
            }

            t += rSteps;
            if (t > 1.0f)
                t = 1.0f; // make sure the last update is at the perfect end
        }

        Mesh result = new Mesh();
        result.vertices = verts;
        result.normals = norms;
        result.uv = uvs;
        result.triangles = tris;
        result.Optimize();

        return result;
    }
	
	public Spline.Segment Path
	{
		get
		{
			if( _path == null )
				_path = BuildPath();
			return _path;
		}
	}

    void Start()
    {
        Mesh mesh = BuildMesh(50);
        MeshFilter mf = gameObject.AddComponent<MeshFilter>();
        gameObject.AddComponent<MeshRenderer>();
        mf.sharedMesh = mesh;

        Mesh collisionMesh = BuildMesh(25);
        MeshCollider col = gameObject.AddComponent<MeshCollider>();
        col.sharedMesh = collisionMesh;
    }
    /*
	void OnDrawGizmos()
	{
		// Draw the handles and tangents
		Gizmos.color = Color.Lerp(Color.blue, Color.white, 0.5f);
		Gizmos.DrawLine(Path.A.position, Path.A_CP.position);
		Gizmos.DrawLine(Path.B.position, Path.B_CP.position);

		Color lineColor = Color.Lerp(Gizmos.color, Color.yellow, 0.5f);
		Color normColor = Color.Lerp(lineColor, Color.red, 0.5f);
		Color borderColor = Color.Lerp(lineColor, Color.red, 0.5f);

		float steps = 40.0f;
		float rSteps = 1.0f / steps;
		Vector3 lastPoint = Path.GetPoint(0.0f);
		for(float t = 0.0f; t < 1.0f; t += rSteps)
		{
			// Draw the Path
			Vector3 thisPoint = Path.GetPoint(t);
			Gizmos.color = lineColor;
			Gizmos.DrawLine(lastPoint, thisPoint);
			lastPoint = thisPoint;

			// Draw the Normals
			Vector3 normal = Path.GetNormal(t);
			Gizmos.color = normColor;
            float profileT = 1.0f - t;
            float leftProfileVal = _leftProfile.Evaluate(profileT);
            float rightProfileVal = _rightProfile.Evaluate(profileT);
			Gizmos.DrawLine(thisPoint - (normal * rightProfileVal), thisPoint + (normal * leftProfileVal));
		}
		
		Gizmos.color = lineColor;
		Gizmos.DrawLine(lastPoint, Path.GetPoint(1.0f));
	}
    */
}

