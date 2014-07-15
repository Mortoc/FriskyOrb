using UnityEngine;

using System;
using System.Collections.Generic;

public class Bezier : ISpline
{
    public class BezierSegment : ISplineSegment
    {
        public Vector3 StartPoint
        {
            get { throw new NotImplementedException(); }
        }

        public Vector3 StartControlPoint
        {
            get { throw new NotImplementedException(); }
        }

        public Vector3 EndPoint
        {
            get { throw new NotImplementedException(); }
        }

        public Vector3 EndControlPoint
        {
            get { throw new NotImplementedException(); }
        }

        public Vector3 GetPoint(float t)
        {
            throw new NotImplementedException();
        }
    }

    public IEnumerable<ISplineSegment> Segments
    {
        get { throw new NotImplementedException(); }
    }

    public Vector3 GetPoint(float t)
    {
        throw new NotImplementedException();
    }

    public Vector3 GetPointAtLenfth(float distance)
    {
        throw new NotImplementedException();
    }
}
