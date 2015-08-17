using UnityEngine;

using System;
using System.Collections.Generic;

public class LevelSegment : MonoBehaviour
{
    private const float PATH_WIDTH = 3.5f;
    private const float PATH_THICKNESS = 0.5f;
    private const int SEGMENT_DETAIL = 30;
    private const int COLLISION_DETAIL_DENOMINATOR = 2;

    //private int _id = 0;

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
        foreach (Transform child in transform)
        {
            if (child.name == name)
                return child;
        }

        throw new ArgumentException("No child with specified name found");
    }

    private Spline.Segment BuildPath()
    {
        Spline.Segment segment = new Spline.Segment()
        {
            A = GetChildNamed("A"),
            A_CP = GetChildNamed("A_CP"),
            B = GetChildNamed("B"),
            B_CP = GetChildNamed("B_CP")
        };
        return segment;
    }

    public struct PathSample
    {
        public Vector3 Left { get; set; }
        public Vector3 Right { get; set; }
        public Vector3 Center { get; set; }
        public bool HasSurface { get; set; }
    }

    public PathSample GetPathSample(float t)
    {
        if (t > 1.0f && Next)
            return Next.GetPathSample(t - 1.0f);
        else if (t < 0.0f && Previous)
            return Previous.GetPathSample(t + 1.0f);

        Vector3 pathPnt = transform.InverseTransformPoint(Path.GetPoint(t));
        Vector3 pathNorm = Path.GetNormal(t);

        float profileT = 1.0f - t;
        float leftProfileVal = _leftProfile.Evaluate(profileT) * PATH_WIDTH;
        float rightProfileVal = _rightProfile.Evaluate(profileT) * PATH_WIDTH;
        bool hasSurface = leftProfileVal + rightProfileVal > Mathf.Epsilon;
        Vector3 left = pathPnt + (pathNorm * leftProfileVal);
        Vector3 right = pathPnt - (pathNorm * rightProfileVal);

        return new PathSample()
        {
            Left = left,
            Right = right,
            Center = pathPnt,
            HasSurface = hasSurface
        };
    }

    private Mesh BuildCollisionMesh(int detail)
    {
        List<int> tris = new List<int>();
        int vertCount = (detail * 4) + 4;
        Vector3[] verts = new Vector3[vertCount];

        Vector3 offset = Previous.transform.position - transform.position;

        float rSteps = 1.0f / (float)detail;
        float t = 0.0f;
        int segmentCount = (detail * 2) + 1;
        for (int i = 0, v = 0; i < segmentCount; ++i, v += 2)
        {
            PathSample thisSample;
            if (t >= 1.0f)
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
        result.SetTriangles(tris.ToArray(), 0);
        result.Optimize();
        return result;
    }

    private Mesh BuildMesh(int detail)
    {
        Vector3 pathOffset = Vector3.up * PATH_THICKNESS;
        List<int> quads = new List<int>();
        int vertCount = (detail + 1) * 8;
        Vector3[] verts = new Vector3[vertCount];
        Vector3[] norms = new Vector3[vertCount];
        Vector4[] tangents = new Vector4[vertCount];
        Vector2[] uvs = new Vector2[vertCount];

        float rSteps = 1.0f / (float)detail;
        float t = 0.0f;

        for (int i = 0, v = 0; i < detail + 1; ++i, v += 8)
        {
            PathSample thisSample = GetPathSample(t);

            float tanSampleDist = 0.01f;
            float tanSample = t + tanSampleDist;
            Vector3 tangent;
            if (tanSample < 1.0f)
                tangent = (thisSample.Center - Path.GetPoint(tanSample)).normalized;
            else
                tangent = (Path.GetPoint(t - (2.0f * tanSampleDist)) - thisSample.Center).normalized;

            for (int tan = v; tan < 8; ++tan)
                tangents[tan] = new Vector4(tangent.x, tangent.y, tangent.z, 1.0f);

            int v1 = v + 1;
            int v2 = v + 2;
            int v3 = v + 3;
            int v4 = v + 4;
            int v5 = v + 5;
            int v6 = v + 6;
            int v7 = v + 7;

            // Position Top Face
            verts[v] = thisSample.Left;
            verts[v1] = thisSample.Right;

            // Position Right Face
            verts[v2] = verts[v1];
            verts[v3] = thisSample.Right - pathOffset;

            // Position Bottom Face
            verts[v4] = verts[v3];
            verts[v5] = thisSample.Left - pathOffset;

            // Position Left Face
            verts[v6] = verts[v];
            verts[v7] = verts[v5];

            // Normals Top Face
            norms[v] = Vector3.up;
            norms[v1] = Vector3.up;

            // Normals Right Face
            Vector3 rightNorm = (thisSample.Right - thisSample.Center).normalized;
            norms[v2] = rightNorm;
            norms[v3] = rightNorm;

            // Normals Bottom Face
            norms[v4] = Vector3.down;
            norms[v5] = Vector3.down;

            // Normals Left Face
            Vector3 leftNorm = (thisSample.Center - thisSample.Left).normalized;
            norms[v6] = leftNorm;
            norms[v7] = leftNorm;


            float topU = 0.5f;
            float rightU = 0.6f;
            float bottomU = 0.9f;
            float leftU = 1.0f;

            // UVs top face
            uvs[v] = new Vector2(0.0f, t);
            uvs[v1] = new Vector2(topU, t);

            // UVs right face
            uvs[v2] = uvs[v1];
            uvs[v3] = new Vector2(rightU, t);

            // UVs bottom face
            uvs[v4] = uvs[v3];
            uvs[v5] = new Vector2(bottomU, t);

            // UVs bottom face
            uvs[v6] = uvs[v5];
            uvs[v7] = new Vector2(leftU, t);

            if (i > 0 && thisSample.HasSurface)
            {
                int vm1 = v - 1; // last v7
                int vm2 = v - 2; // last v6
                int vm3 = v - 3; // last v5
                int vm4 = v - 4; // last v4
                int vm5 = v - 5; // last v3
                int vm6 = v - 6; // last v2
                int vm7 = v - 7; // last v1
                int vm8 = v - 8; // last v

                // Top Face
                quads.Add(v);
                quads.Add(vm8);
                quads.Add(vm7);
                quads.Add(v1);

                // Right Face
                quads.Add(v2);
                quads.Add(vm6);
                quads.Add(vm5);
                quads.Add(v3);

                // Bottom Face
                quads.Add(v4);
                quads.Add(vm4);
                quads.Add(vm3);
                quads.Add(v5);

                // Left Face
                quads.Add(v6);
                quads.Add(v7);
                quads.Add(vm1);
                quads.Add(vm2);
            }

            t += rSteps;
            if (t > 1.0f)
                t = 1.0f; // make sure the last update is at the perfect end
        }

        verts[0] -= Vector3.up * 0.025f;
        verts[1] -= Vector3.up * 0.025f;

        Mesh result = new Mesh();
        result.vertices = verts;
        result.normals = norms;
        result.uv = uvs;
        result.tangents = tangents;
        result.SetIndices(quads.ToArray(), MeshTopology.Quads, 0);
        result.Optimize();

        return result;
    }

    public Spline.Segment Path
    {
        get
        {
            if (_path == null)
                _path = BuildPath();
            return _path;
        }
    }

    public Level Level { get; private set; }
    public LevelSegment Previous { get; set; }
    public LevelSegment Next { get; set; }

    public class CreationInfo
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
    }

    public static LevelSegment Create(CreationInfo options)
    {
        var levelSegment = new GameObject("LevelSegment");
        levelSegment.layer = options.level.gameObject.layer;
        levelSegment.transform.position = (options.pntA + options.pntB) * 0.5f;
        levelSegment.transform.parent = options.level.transform;

        var a = new GameObject("A");
        a.transform.position = options.pntA;
        a.transform.parent = levelSegment.transform;

        var aCP = new GameObject("A_CP");
        aCP.transform.position = options.cpA;
        aCP.transform.parent = levelSegment.transform;

        var b = new GameObject("B");
        b.transform.position = options.pntB;
        b.transform.parent = levelSegment.transform;

        var bCP = new GameObject("B_CP");
        bCP.transform.position = options.cpB;
        bCP.transform.parent = levelSegment.transform;

        var segmentComponent = levelSegment.AddComponent<LevelSegment>();
        segmentComponent.Level = options.level;
        segmentComponent.Previous = options.previous;
        if (options.leftProfile != null)
            segmentComponent._leftProfile = options.leftProfile;
        if (options.rightProfile != null)
            segmentComponent._rightProfile = options.rightProfile;

        //segmentComponent._id = options.id;
        segmentComponent.SetupComponents();

        return segmentComponent;
    }

    private void SetupComponents()
    {
        // Don't generate a collision mesh for the first segment
        if (Previous)
        {
            var collisionMesh = BuildCollisionMesh(SEGMENT_DETAIL / COLLISION_DETAIL_DENOMINATOR);

            var col = gameObject.AddComponent<MeshCollider>();
            col.sharedMesh = collisionMesh;
            col.enabled = false;
        }

        var mesh = BuildMesh(SEGMENT_DETAIL);
        var mf = gameObject.AddComponent<MeshFilter>();
        mf.sharedMesh = mesh;

        var meshRenderer = gameObject.AddComponent<MeshRenderer>();
        meshRenderer.sharedMaterial = Level.LevelTrackMaterial;
    }

    public event Action OnIsNoLongerCurrent;
    public void IsNoLongerCurrent()
    {
        if (GetComponent<Collider>())
        {
            GetComponent<Collider>().enabled = false;
            Next.GetComponent<Collider>().enabled = true;
            foreach(Doodad childDoodad in GetComponentsInChildren<Doodad>())
            {
                if (childDoodad.GetComponent<Rigidbody>())
                    childDoodad.GetComponent<Rigidbody>().useGravity = true;
            }
        }
        Next.Previous = null; // Clear reference to this

        if (OnIsNoLongerCurrent != null)
            OnIsNoLongerCurrent();

        Level.NewSegmentReached();

        Level.SegmentDestroyed();
        StartCoroutine(DelayThenCleanup());
    }
    
    private System.Collections.IEnumerator DelayThenCleanup()
    {
        yield return new WaitForSeconds(5.0f);
        GameObject.Destroy(gameObject);
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
        for (float t = rSteps; t < 1.0f; t += rSteps)
        {
            // Draw the Path
            Vector3 thisPoint = (Path.GetPoint(t));
            Gizmos.DrawLine(lastPoint, thisPoint);
            lastPoint = thisPoint;
        }

        Gizmos.DrawLine(lastPoint, (Path.GetPoint(1.0f)));
    }
}

