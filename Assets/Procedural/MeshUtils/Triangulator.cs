using UnityEngine;
using System.Collections.Generic;
 
namespace Procedural 
{
    public static class Triangulator
    { 
        private static Vector3[] ProjectPointsToXZ(Vector3[] points, Vector3 pointsNormHint)
        {
            var rotationToXZ = Quaternion.FromToRotation(pointsNormHint, Vector3.up);
            var result = new Vector3[points.Length];

            for(int i = 0; i < points.Length; ++i)
            {
				result[i] = rotationToXZ * MathExt.ProjectPointOnPlane(pointsNormHint, Vector3.zero, points[i]);
            }

            return result;
        }

        // Projects the points to an xz aligned plane and
        // triangulates in 2D
        public static int[] Triangulate(Vector3[] points)
        {
            return Triangulate(points, Vector3.up);
        }

        public static int[] Triangulate(Vector3[] points, Vector3 pointsNormHint)
        {
			int pointsCount = points.Length;
			if (pointsCount <= 3)
				return new int[]{0, 1, 2};

            points = ProjectPointsToXZ(points, pointsNormHint);

            List<int> indices = new List<int>();
            int[] unassignedVerts = new int[pointsCount];
            if (Area(points) > 0) 
            {
                for (int v = 0; v < pointsCount; v++)
                    unassignedVerts[v] = v;
            }
            else 
            {
                for (int v = 0; v < pointsCount; v++)
                    unassignedVerts[v] = (pointsCount - 1) - v;
            }
     
            int nv = pointsCount;
            int count = 2 * nv;
            for (int m = 0, v = nv - 1; nv > 0; ) {
                int u = v;
                if (nv <= u)
                    u = 0;

                v = u + 1;
                if (nv <= v)
                    v = 0;

                int w = v + 1;
                if (nv <= w)
                    w = 0;
     
                if (Snip(points, u, v, w, nv, unassignedVerts)) {
                    var a = unassignedVerts[u];
                    var b = unassignedVerts[v];
                    var c = unassignedVerts[w];
                    indices.Add(a);
                    indices.Add(b);
                    indices.Add(c);
                    m++;
                    for(int s = v, t = v + 1; t < nv; s++, t++)
                        unassignedVerts[s] = unassignedVerts[t];
                    nv--;
                    count = 2 * nv;
                }

				if ((count--) <= 0)
					return indices.ToArray();
			}
			
			indices.Reverse();
            return indices.ToArray();
        }
     
        private static float Area (Vector3[] points) {
            int n = points.Length;
            float A = 0.0f;
            for (int p = n - 1, q = 0; q < n; p = q++) {
                var pval = points[p];
                var qval = points[q];
                A += pval.x * qval.z - qval.x * pval.z;
            }
            return (A * 0.5f);
        }
     
        private static bool Snip (Vector3[] points, int u, int v, int w, int n, int[] V) {
            var A = points[V[u]];
            var B = points[V[v]];
            var C = points[V[w]];
            if (Mathf.Epsilon > ((B.x - A.x) * (C.z - A.z)) - ((B.z - A.z) * (C.x - A.x)))
                return false;

            for (int p = 0; p < n; p++) 
			{
                if ((p == u) || (p == v) || (p == w))
                    continue;

                var P = points[V[p]];

                if (InsideTriangle(A, B, C, P))
                    return false;
            }
            return true;
        }
     
        private static bool InsideTriangle (Vector3 A, Vector3 B, Vector3 C, Vector3 P) {
            float ax, ay, bx, by, cx, cy, apx, apy, bpx, bpy, cpx, cpy;
            float cCROSSap, bCROSScp, aCROSSbp;
     
            ax = C.x - B.x; ay = C.z - B.z;
            bx = A.x - C.x; by = A.z - C.z;
            cx = B.x - A.x; cy = B.z - A.z;
            apx = P.x - A.x; apy = P.z - A.z;
            bpx = P.x - B.x; bpy = P.z - B.z;
            cpx = P.x - C.x; cpy = P.z - C.z;
     
            aCROSSbp = ax * bpy - ay * bpx;
            cCROSSap = cx * apy - cy * apx;
            bCROSScp = bx * cpy - by * cpx;
            
            return (aCROSSbp >= 0.0f) && 
				   (bCROSScp >= 0.0f) && 
				   (cCROSSap >= 0.0f);
        }
    }
}