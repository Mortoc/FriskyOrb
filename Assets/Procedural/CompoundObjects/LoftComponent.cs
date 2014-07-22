using UnityEngine;
using System;
using System.Collections.Generic;

namespace Procedural
{
    [ExecuteInEditMode]
    public class LoftComponent : GeneratedMeshObject
    {
        public BezierComponent Path;
        public BezierComponent Shape;

        public int pathSegments = 10;
        public int shapeSegments = 16;

        private Loft _loft;


        public override int GetHashCode()
        {
            var pathHash = Path.PointsHash() + pathSegments;
            var shapeHash = Shape.PointsHash() + shapeSegments;

<<<<<<< HEAD
            return (int)(pathHash ^ shapeHash);
=======
            if( pathHash != _pathHash || shapeHash != _shapeHash)
            {
                _pathHash = pathHash;
                _shapeHash = shapeHash;
                
                if( _loft == null )
                    _loft = new Loft(Path, Shape);            
                    
                var meshFilter = GetComponent<MeshFilter>();
                
                if( !meshFilter )
                    meshFilter = gameObject.AddComponent<MeshFilter>();
                
                if( meshFilter.sharedMesh )
                    DestroyImmediate(meshFilter.sharedMesh);
                    
                if( pathSegments > 1 && shapeSegments > 2 )
                    meshFilter.sharedMesh = _loft.GenerateMesh((uint)pathSegments, (uint)shapeSegments);
            }
>>>>>>> FETCH_HEAD
        }

        protected override void GenerateMesh()
        {
            if( _loft == null )
                _loft = new Loft(Path, Shape);            
                
            var meshFilter = GetComponent<MeshFilter>();
            
            if( meshFilter.sharedMesh )
                DestroyImmediate(meshFilter.sharedMesh);

            meshFilter.sharedMesh = _loft.GenerateMesh((uint)pathSegments, (uint)shapeSegments);
        }
    }
}