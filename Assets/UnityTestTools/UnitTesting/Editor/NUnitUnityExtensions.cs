using System;
using UnityEngine;
using NUnit.Framework;

namespace UnityTest
{
	public static class UAssert
	{
		public static void Within(Vector4 pnt1, Vector4 pnt2, float dist)
		{
			var distSqr = dist * dist;
			var pntDistSqr = (pnt1 - pnt2).sqrMagnitude;
			Assert.LessOrEqual(pntDistSqr, distSqr, String.Format("The points {0} and {1} were more than {2} apart.", pnt1, pnt2, dist));
		}
	}
}
	