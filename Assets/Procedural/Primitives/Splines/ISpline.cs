using UnityEngine;

using System;
using System.Collections.Generic;

public interface ISpline
{
    Vector3 ParametricSample(float t);
}

