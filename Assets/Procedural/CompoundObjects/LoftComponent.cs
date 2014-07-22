using UnityEngine;
using System;
using System.Collections.Generic;

namespace Procedural
{
    [ExecuteInEditMode]
    public class LoftComponent : MonoBehaviour
    {
        public BezierComponent Path;
        private long _pathHash = 0;
        public BezierComponent Shape;
        private long _shapeHash = 0;

        public int pathSegments = 10;
        public int shapeSegments = 16;

        private Loft _loft;

        void Awake()
        {
            GenerateMesh();
        }

        private void GenerateMesh()
        {
            var pathHash = Path.PointsHash() + pathSegments;
            var shapeHash = Shape.PointsHash() + shapeSegments;

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
        }

        void Update()
        {
           GenerateMesh();
        }
    }
}