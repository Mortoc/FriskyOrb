using UnityEngine;

using System;
using System.Collections.Generic;

public interface ISpline
{
	/// <summary>
	/// Gets the world-space point at the parametric value T
	/// </summary>
    Vector3 PositionSample(float t);
    
	/// <summary>
	/// Gets the approximate derivative at the parametric value T
	/// </summary>
	Vector3 ForwardSample(float t);

	/// <summary>
	/// Gets the approximate length along the spline from the start to T
	/// </summary>
	float DistanceSample(float t);

    bool Closed { get; }
}

