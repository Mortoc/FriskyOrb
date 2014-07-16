using UnityEngine;

using System;
using System.Collections.Generic;

using System.Linq;

public class Bezier : ISpline
{
	public struct ControlPoint
    {
		public Vector3 Point { get; set; }
		public Vector3 InTangent { get; set; }
		public Vector3 OutTangent { get; set; }

		public ControlPoint(Vector3 point)
			: this(point, point, point) {}

		public ControlPoint(Vector3 point, Vector3 tangent)
			: this(point, tangent, point + (point - tangent)) {}

		public ControlPoint(Vector3 point, Vector3 inTangent, Vector3 outTangent)
		{
			this.Point = point;
			this.InTangent = inTangent;
			this.OutTangent = outTangent;
		}
    }

    private ControlPoint[] _controlPoints;
    
    public static Bezier ConstructSmoothSpline(IEnumerable<Vector3> points)
    {
    	var pointsArray = new List<Vector3>(points).ToArray();
    	var ctrlPts = new List<ControlPoint>();

    	for(int i = 0; i < pointsArray.Length; ++i)
    	{
    		var pnt = pointsArray[i];
    		var lastPnt = i > 1 ? pointsArray[i - 1] : pnt;
    		var nextPnt = i < pointsArray.Length - 1 ? pointsArray[i + 1] : pnt;

    		var betweenLastAndPnt = Vector3.Lerp(pnt, lastPnt, 0.5f);
    		var lastToPntOvershoot = (betweenLastAndPnt - lastPnt) + pnt;
    		
    		var betweenNextAndPnt = Vector3.Lerp(pnt, nextPnt, 0.5f);
    		var nextToPntOvershoot = (betweenNextAndPnt - nextPnt) + pnt;

    		var outTangent = Vector3.Lerp(lastToPntOvershoot, betweenNextAndPnt, 0.5f);
    		var inTangent = Vector3.Lerp(nextToPntOvershoot, betweenLastAndPnt, 0.5f);

    		var cp = new ControlPoint(pnt, inTangent, outTangent);

    		ctrlPts.Add(cp);
    	}

    	return new Bezier(ctrlPts);
    }

	public Bezier(IEnumerable<ControlPoint> controlPoints)
	{
		UpdateControlPoints(controlPoints);
	}

	public IEnumerable<ControlPoint> ControlPoints
    {
    	get { return _controlPoints; }
    }

	private void UpdateControlPoints(IEnumerable<ControlPoint> controlPoints)
	{
		var cpList = new List<ControlPoint>(controlPoints);
		if( cpList.Count < 2 )
			throw new ArgumentException("A Bezier requires at least 2 controlPoints");
		
		_controlPoints = cpList.ToArray();
	}

    public Vector3 ParametricSample(float t)
    {
    	float cpCount = _controlPoints.Length - 1.0f;
    	float segmentSpaceT = Mathf.Clamp01(t) * cpCount;

    	int startSegment = Mathf.FloorToInt(segmentSpaceT);
    	float tInSegment = segmentSpaceT - Mathf.Floor(segmentSpaceT);

    	if( tInSegment <= 0.0f )
    		return _controlPoints[startSegment].Point;
    	if( tInSegment >= 1.0f )
    		return _controlPoints[startSegment + 1].Point;

		float pntBFactor = tInSegment;
		float pntAFactor = 1.0f - pntBFactor;

    	Vector3 pntA = _controlPoints[startSegment].Point;
    	Vector3 cpA = _controlPoints[startSegment].OutTangent;
    	Vector3 pntB = _controlPoints[startSegment + 1].Point;
    	Vector3 cpB = _controlPoints[startSegment + 1].InTangent;

		float a2 = pntAFactor * pntAFactor;
		float a3 = a2 * pntAFactor;
		float b2 = pntBFactor * pntBFactor;
		float b3 = b2 * pntBFactor;

		return pntA * a3 +
			   cpA * 3.0f * a2 * pntBFactor + 
			   cpB * 3.0f * pntAFactor * b2 +
			   pntB * b3;
	}
}
