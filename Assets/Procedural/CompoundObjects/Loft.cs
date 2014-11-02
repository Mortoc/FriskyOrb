using UnityEngine;

using System;
using System.Collections.Generic;

using Procedural.MeshOperations;

namespace Procedural
{
    public interface ILoft
    {
        ISpline Path { get; }
        ISpline Shape { get; }
        ISpline Scale { get; }

        bool StartCap { get; }
        bool EndCap { get; }

        Vector3 SurfacePoint(float pathT, float shapeT);
    }

    public class Loft : ILoft
    {
        public ISpline Path { get; set; }
        public ISpline Shape { get; set; }

        public ISpline Scale { get; set; }

        public bool StartCap { get; set; }
        public bool EndCap { get; set; }

        // A spline that evaluates to y=1, z=1 for all values of x
        private static ISpline _flatScaleSpline = Bezier.ConstructSmoothSpline(new Vector3[]{
            new Vector3(0.0f, 1.0f, 1.0f),
            new Vector3(1.0f, 1.0f, 1.0f)
        });

        public static Mesh GenerateMesh(ISpline path, ISpline shape, int pathSegments, int shapeSegments)
        {
            return new Loft(path, shape).GenerateMesh(pathSegments, shapeSegments);
        }

        public Loft(ISpline path, ISpline shape)
        {
            if (path == null)
                throw new ArgumentNullException("path");
            if (shape == null)
                throw new ArgumentNullException("shape");

            Path = path;
            Shape = shape;
			Scale = _flatScaleSpline;
        }

        public Vector3 SurfacePoint(Vector2 t)
        {
            return SurfacePoint(t.x, t.y);
        }

        public Vector3 SurfacePoint(float pathT, float shapeT)
        {
            var pathPnt = Path.PositionSample(pathT);
            var pathRot = GetPathRotation(pathT);

            var shapePnt = Shape.PositionSample(shapeT);
            var shapePntRotated = pathRot * shapePnt;

            return pathPnt + shapePntRotated;
        }

        private Quaternion _upToForwardRotation = Quaternion.FromToRotation(Vector3.up, Vector3.forward);
		private Quaternion GetPathRotation(float pathT)
		{
			return GetPathRotation(pathT, Path.ForwardVector(pathT));
		}

        private Quaternion GetPathRotation(float pathT, Vector3 pathDir)
        {
            var pathUp = Path.UpVector(pathT);
            return Quaternion.LookRotation(pathDir, pathUp) * _upToForwardRotation;
        }

        public Mesh GenerateMesh(int pathSegments, int shapeSegments)
        {
            float genMeshStartTime = Time.realtimeSinceStartup;
            if (pathSegments < 1)
                throw new ArgumentException("pathSegments must be at least 1");
            if (shapeSegments < 2)
                throw new ArgumentException("shapeSegments must be at least 2");

            Mesh mesh = new Mesh();

            var vertCount = (pathSegments + 1) * (shapeSegments + 1);

            Vector3[] verts = new Vector3[vertCount];
            Vector4[] tangents = new Vector4[vertCount];
            Vector3[] norms = new Vector3[vertCount];
            Vector2[] uvs = new Vector2[vertCount];

            Func<int, int, int> uvToVertIdx = (shapeSegment, pathSegment) =>
            {
                return (int)((pathSegment * shapeSegments) + shapeSegment);
            };

            var triangleCount = pathSegments * shapeSegments * 6;
            int[] tris = new int[triangleCount];

            float pathStep = 1.0f / (float)pathSegments;
            float shapeStep = 1.0f / (float)shapeSegments;

            for (int pathSeg = 0; pathSeg < pathSegments + 1; ++pathSeg)
            {
                var pathT = pathStep * (float)pathSeg;
				
				var pathPnt = Path.PositionSample(pathT);
				var pathDir = Path.ForwardVector(pathT);
                var pathRot = GetPathRotation(pathT, pathDir);
				var pathTScale = Scale.PositionSample(pathT).y;

                for (int shapeSeg = 0; shapeSeg < shapeSegments + 1; ++shapeSeg)
                {
                    var shapeT = shapeStep * (float)shapeSeg;

					var shapePnt = Shape.PositionSample(shapeT) * pathTScale;
                    var shapePntRotated = pathRot * shapePnt;
					var vertIdx = uvToVertIdx(shapeSeg, pathSeg);

                    verts[vertIdx] = pathPnt + shapePntRotated;

					var shapeForward = Shape.ForwardVector(shapeT);
                    tangents[vertIdx].x = shapeForward.x;
                    tangents[vertIdx].y = shapeForward.y;
                    tangents[vertIdx].z = shapeForward.z;
                    tangents[vertIdx].w = 1.0f;

                    uvs[vertIdx].x = shapeT;
                    uvs[vertIdx].y = pathT;
                }
            }

            var highestVertIdx = -1;
            var triIdx = 0;
			var lastPathIdx = pathSegments - 1;
            for (int pathSeg = 0; pathSeg < pathSegments; ++pathSeg)
            {
                for (int shapeSeg = 0; shapeSeg < shapeSegments; ++shapeSeg)
                {
                    var nextShapeSeg = (shapeSeg + 1) % shapeSegments;
                    var vert1 = uvToVertIdx(shapeSeg, pathSeg);
                    var vert2 = uvToVertIdx(shapeSeg, pathSeg + 1);
                    var vert3 = uvToVertIdx(nextShapeSeg, pathSeg);
                    var vert4 = vert3;
                    var vert5 = vert2;
                    var vert6 = uvToVertIdx(nextShapeSeg, pathSeg + 1);

                    var highestVert = MathExt.Max(vert1, vert2, vert3, vert4, vert5, vert6);
                    if (highestVert > highestVertIdx)
                        highestVertIdx = highestVert;

                    tris[triIdx++] = vert1;
                    tris[triIdx++] = vert2;
                    tris[triIdx++] = vert3;
                    tris[triIdx++] = vert4;
                    tris[triIdx++] = vert5;
                    tris[triIdx++] = vert6;

					var faceNormA = Vector3.Cross(verts[vert2] - verts[vert3], verts[vert2] - verts[vert1]).normalized;
					var faceNormB = Vector3.Cross(verts[vert5] - verts[vert6], verts[vert5] - verts[vert4]).normalized;

					var avgNorm = (faceNormA + faceNormB) * 0.5f;

					norms[vert1] += faceNormA;
					norms[vert2] += avgNorm;
					norms[vert3] += avgNorm;
					norms[vert4] += avgNorm;
					norms[vert5] += avgNorm;
					norms[vert6] += faceNormB;

					// Open Path objects need extra samples at the ends
					if(!Path.Closed && pathSeg == 0)
					{
						var startNorm = Path.ForwardVector(0.0f);

						var reflectedFaceNormA = MathExt.ProjectVectorOnPlane(startNorm, faceNormA) - faceNormA;
						var reflectedFaceNormB = MathExt.ProjectVectorOnPlane(startNorm, faceNormB) - faceNormB;
						var avgReflectedNorm = (reflectedFaceNormA + reflectedFaceNormB) * 0.5f;

						norms[vert2] += reflectedFaceNormA;
						norms[vert5] += reflectedFaceNormA;
						norms[vert6] += avgReflectedNorm;
					}
					else if(!Path.Closed && pathSeg == lastPathIdx)
					{
						var startNorm = Path.ForwardVector(0.0f);
						
						var reflectedFaceNormA = MathExt.ProjectVectorOnPlane(startNorm, faceNormA) - faceNormA;
						var reflectedFaceNormB = MathExt.ProjectVectorOnPlane(startNorm, faceNormB) - faceNormB;
						var avgReflectedNorm = (reflectedFaceNormA + reflectedFaceNormB) * 0.5f;
						
						norms[vert2] += reflectedFaceNormB;
						norms[vert6] += avgReflectedNorm;
					}
                }
            }

            //Debug.Log("Highest Vert in a Tri: " + highestVertIdx);
            //Debug.Log("Total Verts: " + vertCount);
            	
			
			for(int i = 0; i < norms.Length; ++i)
				norms[i] = norms[i].normalized;


            mesh.vertices = verts;
            mesh.uv = uvs;
            mesh.uv1 = uvs;
            mesh.uv2 = uvs;
            mesh.normals = norms;
            mesh.tangents = tangents;
            mesh.triangles = tris;

            // If the loft is closed, make sure there is no normal crease at the loops
            if (Path.Closed || Shape.Closed)
            {
                float weldStartTime = Time.realtimeSinceStartup;
                var weld = new Weld(mesh, mesh);
                weld.SoftWeld(0.001f);
                Debug.Log("Weld Time: " + (Time.realtimeSinceStartup - weldStartTime));
            }

            if (StartCap || EndCap)
            {
                var combineMeshes = new List<CombineInstance>();

                combineMeshes.Add(new CombineInstance() { mesh = mesh });

                if (StartCap)
                {
					var startCapInstance = AddCrossSection(0.0f, shapeSegments, true);
					combineMeshes.Add(startCapInstance);
                }

                if (EndCap)
                {
					var endCapInstance = AddCrossSection(1.0f, shapeSegments);
                    combineMeshes.Add(endCapInstance);
                }

                mesh = new Mesh();
                mesh.CombineMeshes(combineMeshes.ToArray(), true, false);
                combineMeshes.ForEach(ci => Mesh.DestroyImmediate(ci.mesh));
            }

            Debug.Log("Total Time: " + (Time.realtimeSinceStartup - genMeshStartTime));
            return mesh;
        }

        private int[] FlipTris(int[] tris)
        {
            for (int t = 0; t < tris.Length; t += 3)
            {
                var swap = tris[t];
                tris[t] = tris[t + 2];
                tris[t + 2] = swap;
            }

            return tris;
        }


		private CombineInstance AddCrossSection(float pathT, int shapeSegments, bool flip = false)
        {
			var vertCount = shapeSegments;

            var verts = new Vector3[vertCount];
            var uvs = new Vector2[vertCount];

			var tangentSample = Path.UpVector(pathT);
			var tangent = new Vector4(tangentSample.x, tangentSample.y, tangentSample.z, 1.0f);
            var tangents = new Vector4[vertCount];

			var norm = Path.ForwardVector(pathT);
			var norms = new Vector3[vertCount];

			float stepT = 1.0f / (float)shapeSegments;
			float shapeT = 0.0f;
			for(var i = 0; i < vertCount; ++i)
			{
				verts[i] = SurfacePoint(pathT, shapeT);
				uvs[i] = new Vector2(pathT, shapeT);
				norms[i] = norm * -1.0f;
				tangents[i] = tangentSample;

				shapeT += stepT;
			}


            var sliceMesh = new Mesh();
            sliceMesh.vertices = verts;
            
            sliceMesh.uv = uvs;
            sliceMesh.tangents = tangents;

			if( flip )
			{
				for(int i = 0; i < norms.Length; ++i)
					norms[i] = norms[i] * -1.0f;

				sliceMesh.normals = norms;	
				sliceMesh.triangles = FlipTris(Triangulator.Triangulate(verts, norm));
			}
			else
			{
				sliceMesh.normals = norms;
				sliceMesh.triangles = Triangulator.Triangulate(verts, norm);
			}


            return new CombineInstance() { mesh = sliceMesh };
        }
    }
}