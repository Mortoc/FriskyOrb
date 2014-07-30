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

        public BezierComponent Scale;

        public int pathSegments = 10;
        public int shapeSegments = 16;

        public bool startCap = false;
        public bool endCap = false;

        private Loft _loft;

        public override int GetHashCode()
        {
        	if( Path == null || Shape == null )
        		return 0;
        		
            var pathHash = Path.PointsHash() + pathSegments;
            var shapeHash = Shape.PointsHash() + shapeSegments;

            var result = pathHash ^ shapeHash;

            if(Scale) 
                result ^= Scale.PointsHash();

            if(startCap)
                result += 1;

            if(endCap)
                result += 2;

            return (int)result;
        }
        
        protected override void GenerateMesh()
        {
            if( _loft == null )
                _loft = new Loft(Path, Shape);

            if( Scale != null )
                _loft.Scale = Scale;       

            _loft.StartCap = startCap;
            _loft.EndCap = endCap;
                
            var meshFilter = GetComponent<MeshFilter>();
            
            if( meshFilter.sharedMesh )
                DestroyImmediate(meshFilter.sharedMesh);

            meshFilter.sharedMesh = _loft.GenerateMesh((uint)pathSegments, (uint)shapeSegments);
        }
    }
}