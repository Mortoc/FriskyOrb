using UnityEngine;

using System.Collections.Generic;


namespace Procedural
{
	public static class BezierOperations
	{
		public static Bezier ScaleTangents(this Bezier bezier, float percent)
		{
			bezier.PerformControlPointOperation(cp => cp.ScaleTangents(percent));
			return bezier;
		}
	}
}