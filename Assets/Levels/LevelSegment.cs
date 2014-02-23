using UnityEngine;
using System;
using System.Collections.Generic;

public class LevelSegment : MonoBehaviour 
{
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
    }

    private PathSample GetPathSample(float t)
    {
        Vector3 pathPnt = transform.InverseTransformPoint(Path.GetPoint(t));
        Vector3 pathNorm = Path.GetNormal(t);

        float profileT = 1.0f - t;
        float leftProfileVal = _leftProfile.Evaluate(profileT) * 1.2f;
        float rightProfileVal = _rightProfile.Evaluate(profileT) * 1.2f;
        Vector3 left = pathPnt + (pathNorm * leftProfileVal);
        Vector3 right = pathPnt - (pathNorm * rightProfileVal);

        return new PathSample()
        {
            left = left,
            right = right
        };
    }

	private Mesh BuildCollisionMesh(int detail)
	{
		int[] tris = new int[detail * 12];
		int vertCount = (detail * 4) + 4;
		Vector3[] verts = new Vector3[vertCount];

		Vector3 offset = Previous.transform.position - transform.position;

		float rSteps = 1.0f / (float) detail;
		float t = 0.0f;
		int segmentCount = (detail * 2) + 1;
		for (int i = 0, v = 0, tri = -6; i < segmentCount; ++i, v += 2, tri += 6)
		{
			PathSample thisSample;
			if( t >= 1.0f )
			{
				thisSample = GetPathSample(t - 1.0f);
			}
			else
			{
				// Sample in to the next segment
				thisSample = Previous.GetPathSample(t);
				thisSample.left += offset;
				thisSample.right += offset;
			}
			
			int v1 = v + 1;
			verts[v] = thisSample.left;
			verts[v1] = thisSample.right;

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
		}
		
		Mesh result = new Mesh();
		result.vertices = verts;
		result.triangles = tris;
		return result;
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
			PathSample thisSample = GetPathSample(t);

            int v1 = v + 1;
            verts[v] = thisSample.left;
            verts[v1] = thisSample.right;
		    norms[v] = Vector3.up;
		    norms[v1] = Vector3.up;
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

	public Level Level { get; private set; }
	public LevelSegment Previous { get; set; }
	public LevelSegment Next { get; set; }

	public static LevelSegment Create(Level level, Vector3 pntA, Vector3 cpA, Vector3 pntB, Vector3 cpB, LevelSegment previous, AnimationCurve leftProfile, AnimationCurve rightProfile)
	{
		var levelSegment = new GameObject ("LevelSegment");
		levelSegment.layer = level.gameObject.layer;
		levelSegment.transform.position = (pntA + pntB) * 0.5f;
		levelSegment.transform.parent = level.transform;

		var a = new GameObject ("A");
		a.transform.position = pntA;
		a.transform.parent = levelSegment.transform;

		var aCP = new GameObject ("A_CP");
		aCP.transform.position = cpA;
		aCP.transform.parent = levelSegment.transform;

		var b = new GameObject ("B");
		b.transform.position = pntB;
		b.transform.parent = levelSegment.transform;

		var bCP = new GameObject ("B_CP");
		bCP.transform.position = cpB;
		bCP.transform.parent = levelSegment.transform;

		var segmentComponent = levelSegment.AddComponent<LevelSegment>();
		segmentComponent.Level = level;
		segmentComponent.Previous = previous;
		segmentComponent._leftProfile = leftProfile;
		segmentComponent._rightProfile = rightProfile;

		segmentComponent.SetupComponents();

		return segmentComponent;
	}

	private void SetupComponents()
	{	
		var mesh = BuildMesh(32);
		var mf = gameObject.AddComponent<MeshFilter>();
		mf.sharedMesh = mesh;
		
		if( Previous )
		{
			var collisionMesh = BuildCollisionMesh(16);
			var col = gameObject.AddComponent<MeshCollider>();
			col.sharedMesh = collisionMesh;
			col.enabled = false;
		}
		
		var meshRenderer = gameObject.AddComponent<MeshRenderer>();
		meshRenderer.sharedMaterial = Level.LevelTrackMaterial;
	}

	public event Action OnIsNoLongerCurrent;
	public void IsNoLongerCurrent()
	{
		if( collider )
		{
			collider.enabled = false;
			Next.collider.enabled = true;
		}
		Next.Previous = null; // Clear reference to this

		if( OnIsNoLongerCurrent != null )
			OnIsNoLongerCurrent();

		Scheduler.Run(new YieldForSeconds(1.0f), () => {
			Level.SegmentDestroyed();
			GameObject.Destroy(gameObject);
		});
	}


	void OnDrawGizmos()
	{
		// Draw the handles and tangents
		Gizmos.color = Color.Lerp(Color.blue, Color.white, 0.5f);
		Gizmos.DrawLine((Path.A.position), (Path.A_CP.position));
		Gizmos.DrawLine((Path.B.position), (Path.B_CP.position));
		Gizmos.DrawSphere((Path.A.position), 0.5f);
		Gizmos.DrawSphere((Path.B.position), 0.5f);
  		Gizmos.DrawSphere((Path.A_CP.position), 0.33f);
		Gizmos.DrawSphere((Path.B_CP.position), 0.33f);

		Gizmos.color = Color.Lerp(Gizmos.color, Color.yellow, 0.5f);

		float steps = 40.0f;
		float rSteps = 1.0f / steps;
		Vector3 lastPoint = (Path.GetPoint(0.0f));
		for(float t = rSteps; t < 1.0f; t += rSteps)
		{
			// Draw the Path
			Vector3 thisPoint = (Path.GetPoint(t));
			Gizmos.DrawLine(lastPoint, thisPoint);
			lastPoint = thisPoint;
		}

		Gizmos.DrawLine(lastPoint, (Path.GetPoint(1.0f)));
	}
}

