using System;
using UnityEngine;
using NUnit.Framework;

namespace UnityTest
{
	public static class UAssert
	{

		public static void Near(float val1, float val2, float dist)
		{
			var valDiff = val1 - val2;
			Assert.LessOrEqual(valDiff, dist, 
				String.Format("The values {0} and {1} were more than {2} apart.", val1, val2, dist));
		}

		public static void Near(Vector3 pnt1, Vector3 pnt2, float dist)
		{
			var distSqr = dist * dist;
			var pntDistSqr = (pnt1 - pnt2).sqrMagnitude;

			Assert.LessOrEqual(pntDistSqr, distSqr,
				String.Format("The points {0} and {1} were more than {2} apart.", pnt1, pnt2, dist));
		}

		public static void NotNear(Vector3 pnt1, Vector3 pnt2, float dist)
		{
			var distSqr = dist * dist;
			var pntDistSqr = (pnt1 - pnt2).sqrMagnitude;
			Assert.Greater(pntDistSqr, distSqr, 
				String.Format("The points {0} and {1} were less than {2} apart.", pnt1, pnt2, dist));
		}

		public static void NearLineSegment(Vector3 lineEndA, Vector3 lineEndB, Vector3 pnt, float dist)
		{
			var pntProj = MathExt.ProjectPointOnLineSegment(lineEndA, lineEndB, pnt);
			Assert.LessOrEqual((pntProj - pnt).sqrMagnitude, dist * dist, 
				String.Format("The point {0} was more than {1} from the line segment [{2} - {3}].", 
						pnt, dist, lineEndA, lineEndB));
		}
	}
}
	