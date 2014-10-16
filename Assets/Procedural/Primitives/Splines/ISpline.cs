using UnityEngine;

using System;
using System.Collections.Generic;


public interface IControlPoint
{
    Vector3 Point { get; set; }
    Vector3 InTangent { get; set; }
    Vector3 OutTangent { get; set; }
    Vector3 Up { get; set; }
}

public interface ISpline : IEnumerable<IControlPoint>
{
	/// <summary>
	/// Gets the world-space point at the parametric value T
	/// </summary>
    Vector3 PositionSample(float t);
    
	/// <summary>
	/// Gets the approximate derivative at the parametric value T
	/// </summary>
	Vector3 ForwardVector(float t);
	
	/// <summary>
	/// Gets a smoothed up vector for the parametric value T
	/// </summary>
	Vector3 UpVector(float t);

	/// <summary>
	/// Gets the approximate length along the spline from the start to T
	/// </summary>
	float DistanceSample(float t);

	
	float ClosestT(Vector3 point);

    bool Closed { get; }

	/// Convenience function since first control point is commonly accessed
	IControlPoint LastControlPoint { get; }

	/// Convenience function since last control point is commonly accessed
	IControlPoint FirstControlPoint { get; }
}

