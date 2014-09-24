using UnityEngine;
using UnityTest;
using NUnit.Framework;

using System;
using System.Collections.Generic;
using System.Linq;

namespace Procedural.Test
{
	[TestFixture]
	[Category("Procedural")]
	internal class BezierOperations_Test
	{
		[Test]
		public void BezierControlPointScalingVerification()
		{
			var points = new Vector3[]{
				new Vector3(1.0f, 0.0f, 0.0f),
				new Vector3(0.0f, 1.0f, 0.0f),
				new Vector3(-1.0f, 0.0f, 0.0f),
				new Vector3(0.0f, -1.0f, 0.0f),
			};
			
			var bezier = Bezier.ConstructSmoothSpline(points);

			bezier.ScaleTangents(0.001f);

			foreach(var cp in bezier)
			{
				UAssert.Near(cp.Point, cp.InTangent, 0.01f);
				UAssert.Near(cp.Point, cp.OutTangent, 0.01f);
			}
		}
	}
}