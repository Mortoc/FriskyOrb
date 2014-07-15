using UnityEngine;

using System;
using System.Collections.Generic;

public interface ISpline
{
    IEnumerable<ISplineSegment> Segments { get; }
    Vector3 GetPoint(float t);
    Vector3 GetPointAtLenfth(float distance);
}

public interface ISplineSegment
{
    Vector3 StartPoint { get; }
    Vector3 StartControlPoint { get; }
    
    Vector3 EndPoint { get; }
    Vector3 EndControlPoint { get; }

    Vector3 GetPoint(float t);
}
