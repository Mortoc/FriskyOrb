using UnityEngine;
using UnityTest;
using NUnit.Framework;

using System;
using System.Collections.Generic;
using System.Linq;

namespace RtInfinity.Levels.Test
{
    [TestFixture]
    [Category("Gameplay")]
    internal class LevelTrack_Test
    {
        private Bezier _simpleArc = new Bezier(new Bezier.ControlPoint[]{
            new Bezier.ControlPoint(new Vector3(0.0f, 0.0f, 0.0f)),
            new Bezier.ControlPoint(new Vector3(0.5f, 1.0f, 0.0f), new Vector3(0.0f, 1.0f, 0.0f), new Vector3(1.0f, 1.0f, 0.0f)),
            new Bezier.ControlPoint(new Vector3(1.0f, 0.0f, 0.0f))
        });

        [Test]
        public void BeziersSampleThroughControlPoints()
        {
            var cpTStep = 1.0f / (float)(_simpleArc.ControlPoints.Count() - 1);
            var currentT = 0.0f;

            // Sample at each control point
            foreach (var cp in _simpleArc.ControlPoints)
            {
                UAssert.Near(_simpleArc.PositionSample(currentT), cp.Point, 0.0001f);
                currentT += cpTStep;
            }
        }
    }
}