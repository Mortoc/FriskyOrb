using UnityEngine;
using System;
using System.Collections.Generic;

namespace Procedural.MeshOperations
{
	internal static class MeshOpConstants
	{
        public readonly static Func<Vector3, Vector3> NoTransform = v => v;
        public readonly static Func<int, bool> NoFilter = v => true;
    }

    public class Weld
    {
        public Func<int, bool> VertSelectionFunc1 { get; set; }
        public Func<int, bool> VertSelectionFunc2 { get; set; }

        public Mesh Mesh1 { get; private set; }
        public Mesh Mesh2 { get; private set; }

        private Func<Vector3, Vector3> _transformMesh1;
        private Func<Vector3, Vector3> _transformMesh2;

        private Func<Vector3, Vector3> _inverseTransformMesh1;
        private Func<Vector3, Vector3> _inverseTransformMesh2;
            
        public Transform Transform1 
        {
            set
            {
                _transformMesh1 = value.TransformPoint;
                _inverseTransformMesh1 = value.InverseTransformPoint;
            }
        }

        public Transform Transform2
        {
            set
            {
                _transformMesh2 = value.TransformPoint;
                _inverseTransformMesh2 = value.InverseTransformPoint;
            }
        }

        public Weld(Mesh mesh1, Mesh mesh2)
        {
            Mesh1 = mesh1;
            Mesh2 = mesh2;

            VertSelectionFunc1 = MeshOpConstants.NoFilter;
            VertSelectionFunc2 = MeshOpConstants.NoFilter;

            _transformMesh1 = MeshOpConstants.NoTransform;
            _inverseTransformMesh1 = MeshOpConstants.NoTransform;

            _transformMesh2 = MeshOpConstants.NoTransform;
            _inverseTransformMesh2 = MeshOpConstants.NoTransform;
        }

        public Weld(Mesh mesh1, Transform transform1, Mesh mesh2, Transform transform2)
            : this(mesh1, mesh2)
        {
            Transform1 = transform1;
            Transform2 = transform2;
        }

        /// <summary>
        /// SoftWeld only affects the given meshes inline 
        /// and doesn't generate a new mesh.
        /// </summary>
        public void SoftWeld(float radius)
        {
            var weldRadSqr = radius * radius;
            var verts1 = Mesh1.vertices;
            var verts2 = Mesh2.vertices;

            var norms1 = Mesh1.normals;
            var norms2 = Mesh2.normals;

            for (int i = 0; i < Mesh1.vertexCount; ++i)
            {
                //var vert1 = _transformMesh1(Mesh1.vertices[i]);
                //if (!VertSelectionFunc1(i))
                //    continue;

                for (int j = 0; j < Mesh2.vertexCount; ++j)
                {
                    //var vert2 = _transformMesh2(Mesh2.vertices[j]);
                    //if (!VertSelectionFunc2(j))
                    //    continue;

                    //if ((vert1 - vert2).sqrMagnitude < weldRadSqr)
                    {
                        //var newPos = Vector3.Lerp(Mesh1.vertices[i], verts2[j], 0.5f);
                        //verts1[i] = _inverseTransformMesh1(newPos);
                        //verts2[j] = _inverseTransformMesh2(newPos);

                        //var norm1 = _transformMesh1(norms1[i]);
                        //var norm2 = _transformMesh2(norms2[j]);
                        //var newNorm = Vector3.Slerp(norm1, norm2, 0.5f);
                        //norms1[i] = _inverseTransformMesh1(newNorm);
                        //norms2[j] = _inverseTransformMesh2(newNorm);
                    }
                }
            }

            Mesh1.vertices = verts1;
            Mesh2.vertices = verts2;

            Mesh1.normals = norms1;
            Mesh2.normals = norms2;

            Mesh1.RecalculateBounds();
            Mesh2.RecalculateBounds();
        }
    }
}