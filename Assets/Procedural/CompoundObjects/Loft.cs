using UnityEngine;

using System;
using System.Collections.Generic;
using System.Linq;

namespace Procedural
{
    public class Loft
    {
        public ISpline Path { get; set; }
        public ISpline Shape { get; set; }

        public ISpline Scale { get; set; }

        public bool StartCap { get; set; }
        public bool EndCap { get; set; }

        public float Banking { get; set; }

        // A spline that evaluates to y=1, z=1 for all values of x
        private static ISpline _identitySpline = Bezier.ConstructSmoothSpline(new Vector3[]{
            new Vector3(0.0f, 1.0f, 1.0f),
            new Vector3(1.0f, 1.0f, 1.0f)
        });

        public static Mesh GenerateMesh(ISpline path, ISpline shape, uint pathSegments, uint shapeSegments)
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
            Scale = _identitySpline;
        }

        public Mesh GenerateMesh(uint pathSegments, uint shapeSegments)
        {
            if( pathSegments < 1 )
                throw new ArgumentException("pathSegments must be at least 1");
            if( shapeSegments < 2 )
                throw new ArgumentException("shapeSegments must be at least 2");

            Mesh mesh = new Mesh();

            var vertCount = (pathSegments+1) * (shapeSegments+1);

            Vector3[] verts = new Vector3[vertCount];
            Vector4[] tangents = new Vector4[vertCount];
            Vector3[] norms = new Vector3[vertCount];
            Vector2[] uvs = new Vector2[vertCount];

            Func<uint, uint, int> uvToVertIdx = (shapeSegment, pathSegment) => {
                return (int)((pathSegment * shapeSegments) + shapeSegment);
            };

            var triangleCount = pathSegments * shapeSegments * 6;
            int[] tris = new int[triangleCount];

            float pathStep = 1.0f / (float)pathSegments;
            float shapeStep = 1.0f / (float)(shapeSegments-1);

            for(uint pathSeg = 0; pathSeg < pathSegments+1; ++pathSeg)
            {
                var pathT = pathStep * (float)pathSeg;
                var pathPnt = Path.PositionSample(pathT);
                var pathDir = Path.ForwardSample(pathT);
                var pathRot = Quaternion.FromToRotation(Vector3.up, pathDir);

                if( pathDir == -Vector3.up )
                {
                    // Compensate for the gimbal lock when 
                    // pathDir is polar opposite to up
                    pathRot *= Quaternion.AngleAxis(180.0f, Vector3.up);
                }
                
                for(uint shapeSeg = 0; shapeSeg < shapeSegments+1; ++shapeSeg)
                {
                    var shapeT = shapeStep * (float)shapeSeg;
                    var shapePnt = Shape.PositionSample(shapeT) * Scale.PositionSample(pathT).y;
                    var shapeForward = Shape.ForwardSample(shapeT);
                    var vertIdx = uvToVertIdx(shapeSeg, pathSeg);
                    var shapePntRotated = pathRot * shapePnt;
                    
                    verts[vertIdx] = pathPnt + shapePntRotated;
                    
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
            for(uint pathSeg = 0; pathSeg < pathSegments; ++pathSeg)
            {
                for(uint shapeSeg = 0; shapeSeg < shapeSegments; ++shapeSeg)
                {
                    var nextShapeSeg = (shapeSeg + 1) % shapeSegments;
                    var vert1 = uvToVertIdx(shapeSeg, pathSeg);
                    var vert2 = uvToVertIdx(shapeSeg, pathSeg + 1);
                    var vert3 = uvToVertIdx(nextShapeSeg, pathSeg);
                    var vert4 = vert3;
                    var vert5 = vert2;
                    var vert6 = uvToVertIdx(nextShapeSeg, pathSeg + 1);

                    var highestVert = MathExt.Max(vert1, vert2, vert3, vert4, vert5, vert6);
                    if( highestVert > highestVertIdx )
                        highestVertIdx = highestVert;

                    tris[triIdx++] = vert1;
                    tris[triIdx++] = vert2;
                    tris[triIdx++] = vert3;
                    tris[triIdx++] = vert4;
                    tris[triIdx++] = vert5;
                    tris[triIdx++] = vert6;

                    Vector3 faceNormal1 = Vector3.Cross(verts[vert1] - verts[vert2], verts[vert1] - verts[vert3]).normalized; 
                    Vector3 faceNormal2 = Vector3.Cross(verts[vert4] - verts[vert5], verts[vert4] - verts[vert6]).normalized; 

                    norms[vert1] += faceNormal1;
                    norms[vert2] += faceNormal1;
                    norms[vert3] += faceNormal1;
                    norms[vert4] += faceNormal2;
                    norms[vert5] += faceNormal2;
                    norms[vert6] += faceNormal2;
                }
            }

            //Debug.Log("Highest Vert in a Tri: " + highestVertIdx);
            //Debug.Log("Total Verts: " + vertCount);

            // If the path is closed, make sure there is no normal crease at the loop
            if (Path.Closed)
            {
                var lastPathShapeBaseIdx = shapeSegments * pathSegments;
                var firstSegmentNorms = new Vector3[shapeSegments];
                Array.Copy(norms, firstSegmentNorms, shapeSegments);

                for (var shapeSeg = 0u; shapeSeg < shapeSegments; ++shapeSeg)
                {
                    norms[shapeSeg] += norms[lastPathShapeBaseIdx + shapeSeg];
                    norms[lastPathShapeBaseIdx + shapeSeg] += firstSegmentNorms[shapeSeg];
                }
            }

            // If the shape is closed, make sure there is no normal crease at the loop
            if(Shape.Closed)
            {
                var firstSegmentNorms = new Vector3[pathSegments];
                Array.Copy(norms, firstSegmentNorms, pathSegments);

                for (var pathSeg = 0u; pathSeg < pathSegments+1; ++pathSeg)
                {
                    var shapeVertsStart = pathSeg * shapeSegments;
                    var shapeVertsEnd = shapeVertsStart + shapeSegments - 1;
                    var startNorm = norms[shapeVertsStart];
                    norms[shapeVertsStart] += norms[shapeVertsEnd];
                    norms[shapeVertsEnd] += startNorm;
                }
            }

            for(int n = 0; n < norms.Length; ++n)
            {
                norms[n] = norms[n].normalized;
            }

            mesh.vertices = verts;
            mesh.uv = uvs;
            mesh.uv2 = uvs;
            mesh.uv2 = uvs;
            mesh.normals = norms;
            mesh.tangents = tangents;
            mesh.triangles = tris;

            if( StartCap || EndCap )
            {
                var combineMeshes = new List<CombineInstance>();

                combineMeshes.Add(new CombineInstance(){mesh = mesh});

                var capVertCount = (int)shapeSegments - 1;

                if( StartCap )
                {
                    var startCapInstance = AddCrossSection(mesh, capVertCount, 0, Path.ForwardSample(0.0f) * -1.0f);
                    combineMeshes.Add(startCapInstance);
                }

                if( EndCap )
                {
                    var endCapInstance = AddCrossSection(mesh, capVertCount, highestVertIdx - capVertCount, Path.ForwardSample(1.0f));
                    combineMeshes.Add(endCapInstance);
                }

                mesh = new Mesh();
                mesh.CombineMeshes(combineMeshes.ToArray(), true, false);
                combineMeshes.ForEach(ci => Mesh.DestroyImmediate(ci.mesh));
            }

            return mesh;
        }

        private int[] FlipTris(int[] tris)
        {
            for(int t = 0; t < tris.Length; t += 3)
            {
                var swap = tris[t];
                tris[t] = tris[t + 2];
                tris[t + 2] = swap;
            }

            return tris;
        }


        private CombineInstance AddCrossSection(Mesh mesh, int vertCount, int startVert, Vector3 norm)
        {
            var verts = new Vector3[vertCount];
            var norms = new Vector3[vertCount];
            var uvs = new Vector2[vertCount];
            var tangents = new Vector4[vertCount];

            Array.Copy(mesh.vertices, startVert, verts, 0, vertCount);
            Array.Copy(mesh.uv, startVert, uvs, 0, vertCount);
            Array.Copy(mesh.tangents, startVert, tangents, 0, vertCount);

            for(var i = 0; i < vertCount; ++i)
                norms[i] = norm;

            var sliceMesh = new Mesh();
            sliceMesh.vertices = verts;
            sliceMesh.normals = norms;
            sliceMesh.uv = uvs;
            sliceMesh.tangents = tangents;

            int[] tris;
            if( vertCount == 4 ) // 3 shape segments
            {
                tris = new int[]{0, 1, 2};
            }
            else
            {
                tris = Triangulator.Triangulate(verts, norm);

                var v1 = verts[tris[0]];
                var v2 = verts[tris[1]];
                var v3 = verts[tris[2]];
                if( Vector3.Dot(Vector3.Cross(v2 - v3, v2 - v1).normalized, norm) < 0.0f )
                    tris = FlipTris(tris);
            }

            sliceMesh.triangles = tris;

            return new CombineInstance(){mesh = sliceMesh};
        }   
    }
}