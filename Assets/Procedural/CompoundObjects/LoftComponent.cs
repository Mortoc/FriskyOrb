using UnityEngine;
using System;
using System.Collections.Generic;

namespace Procedural
{
    [ExecuteInEditMode]
    public class LoftComponent : GeneratedMeshObject, ILoft
    {
        public BezierComponent PathObj;
        public BezierComponent ShapeObj;

        public BezierComponent ScaleObj;

        public int pathSegments = 10;
        public int shapeSegments = 16;

        public bool startCap = false;
        public bool endCap = false;

        private Loft _loft;

		#region ILoft implementation

		public Vector3 SurfacePoint (float pathT, float shapeT)
		{
			return _loft.SurfacePoint(pathT, shapeT);
		}

		public ISpline Path 
		{
			get { return _loft.Path; }
		}

		public ISpline Shape 
		{
			get { return _loft.Shape; }
		}

		public ISpline Scale 
		{
			get { return _loft.Scale; }
		}

		public bool StartCap 
		{
			get { return _loft.StartCap; }
		}

		public bool EndCap 
		{
			get { return _loft.EndCap; }
		}

		#endregion

        public override int GetHashCode()
        {
        	if( PathObj || ShapeObj )
        		return 0;
        		
            var pathHash = PathObj.PointsHash() + pathSegments;
            var shapeHash = ShapeObj.PointsHash() + shapeSegments;

            var result = pathHash ^ shapeHash;

            if(ScaleObj) 
                result ^= ScaleObj.PointsHash();

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