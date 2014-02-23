using UnityEngine;

using System;
using System.Collections.Generic;

public class LevelSegment : MonoBehaviour 
{
	private int _id = 0;

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
        public Vector3 Left { get; set; }
        public Vector3 Right { get; set; }
		public bool HasSurface { get; set; }
    }

    private PathSample GetPathSample(float t)
    {
        Vector3 pathPnt = transform.InverseTransformPoint(Path.GetPoint(t));
        Vector3 pathNorm = Path.GetNormal(t);

        float profileT = 1.0f - t;
        float leftProfileVal = _leftProfile.Evaluate(profileT) * 1.75f;
        float rightProfileVal = _rightProfile.Evaluate(profileT) * 1.75f;
		bool hasSurface = leftProfileVal + rightProfileVal > Mathf.Epsilon;
        Vector3 left = pathPnt + (pathNorm * leftProfileVal);
        Vector3 right = pathPnt - (pathNorm * rightProfileVal);

        return new PathSample()
        {
            Left = left,
            Right = right,
			HasSurface = hasSurface
        };
    }

	private Mesh BuildCollisionMesh(int detail)
	{
		List<int> tris = new List<int>();
		int vertCount = (detail * 4) + 4;
		Vector3[] verts = new Vector3[vertCount];

		Vector3 offset = Previous.transform.position - transform.position;

		float rSteps = 1.0f / (float) detail;
		float t = 0.0f;
		int segmentCount = (detail * 2) + 1;
		for (int i = 0, v = 0; i < segmentCount; ++i, v += 2)
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
				thisSample.Left += offset;
				thisSample.Right += offset;
			}
			
			int v1 = v + 1;
			verts[v] = thisSample.Left;
			verts[v1] = thisSample.Right;

			if (i > 0 && thisSample.HasSurface)
			{
				int vm2 = v - 2;
				int vm1 = v - 1;

				tris.Add(vm2);
				tris.Add(vm1);
				tris.Add(v);
				tris.Add(v1);
				tris.Add(v);
				tris.Add(vm1);
			}
			
			t += rSteps;
		}
		
		Mesh result = new Mesh();
		result.vertices = verts;
		result.triangles = tris.ToArray();
		return result;
	}

    private Mesh BuildMesh(int detail)
    {
        List<int> tris = new List<int>();
        int vertCount = (detail * 2) + 2;
        Vector3[] verts = new Vector3[vertCount];
		Vector3[] norms = new Vector3[vertCount];
		Vector2[] uvs = new Vector2[vertCount];

        float rSteps = 1.0f / (float) detail;
        float t = 0.0f;
        for (int i = 0, v = 0; i < detail + 1; ++i, v += 2)
        {
			PathSample thisSample = GetPathSample(t);

            int v1 = v + 1;
            verts[v] = thisSample.Left;
            verts[v1] = thisSample.Right;
		    norms[v] = Vector3.up;
		    norms[v1] = Vector3.up;
		    uvs[v] = new Vector2(1.0f, t);
		    uvs[v1] = new Vector2(0.0f, t);

            if (i > 0 && thisSample.HasSurface)
            {
                int vm2 = v - 2;
                int vm1 = v - 1;

				tris.Add(vm2);
				tris.Add(vm1);
				tris.Add(v);
				tris.Add(v1);
				tris.Add(v);
				tris.Add(vm1);
            }

            t += rSteps;
            if (t > 1.0f)
                t = 1.0f; // make sure the last update is at the perfect end
        }

        Mesh result = new Mesh();
        result.vertices = verts;
        result.normals = norms;
        result.uv = uvs;
        result.triangles = tris.ToArray();
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

	public class CreateInfo
	{
		public int id = 0;
		public Level level = null;
		public Vector3 pntA;
		public Vector3 cpA;
		public Vector3 pntB;
		public Vector3 cpB;
		public LevelSegment previous = null;
		public AnimationCurve leftProfile = null;
		public AnimationCurve rightProfile = null;
		public bool async = true;

	}
	public static LevelSegment Create(CreateInfo options)
	{
		var levelSegment = new GameObject ("LevelSegment");
		levelSegment.layer = options.level.gameObject.layer;
		levelSegment.transform.position = (options.pntA + options.pntB) * 0.5f;
		levelSegment.transform.parent = options.level.transform;

		var a = new GameObject ("A");
		a.transform.position = options.pntA;
		a.transform.parent = levelSegment.transform;

		var aCP = new GameObject ("A_CP");
		aCP.transform.position = options.cpA;
		aCP.transform.parent = levelSegment.transform;

		var b = new GameObject ("B");
		b.transform.position = options.pntB;
		b.transform.parent = levelSegment.transform;

		var bCP = new GameObject ("B_CP");
		bCP.transform.position = options.cpB;
		bCP.transform.parent = levelSegment.transform;

		var segmentComponent = levelSegment.AddComponent<LevelSegment>();
		segmentComponent.Level = options.level;
		segmentComponent.Previous = options.previous;
		if( options.leftProfile != null )
			segmentComponent._leftProfile = options.leftProfile;
		if( options.rightProfile != null )
			segmentComponent._rightProfile = options.rightProfile;

		segmentComponent._id = options.id;
		segmentComponent.SetupComponents(options.async);

		return segmentComponent;
	}

	private void SetupComponents(bool async)
	{
		if( async )
		{
			Scheduler.Run( SetupComponentsCoroutine() );
		}
		else
		{
			IEnumerator<IYieldInstruction> setup = SetupComponentsCoroutine();
			while( setup.MoveNext() );
		}
	}

	// Spread out setting up the components of this segment over a few frames
	private IEnumerator<IYieldInstruction> SetupComponentsCoroutine()
	{
		var mesh = BuildMesh(48);
		yield return Yield.UntilNextFrame;

		var mf = gameObject.AddComponent<MeshFilter>();
		mf.sharedMesh = mesh;
		yield return Yield.UntilNextFrame;

		if( Previous )
		{
			var collisionMesh = BuildCollisionMesh(24);
			yield return Yield.UntilNextFrame;

			var col = gameObject.AddComponent<MeshCollider>();
			col.sharedMesh = collisionMesh;
			col.enabled = false;
			yield return Yield.UntilNextFrame;
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

