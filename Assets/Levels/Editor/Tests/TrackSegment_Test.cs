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
	internal class TrackSegment_Test : IDisposable
	{
		private GameObject _fixtureGameObject = new GameObject("TestTrack");
		private ITrackGenerator _generator = new RtInfinity.Levels.SpaceRace.SpaceRaceTrackGenerator();
		
		public void Dispose ()
		{
			GameObject.DestroyImmediate (_fixtureGameObject);
		}
		
		[Test]
		public void InitVerification()
		{
			var segment = _fixtureGameObject.AddComponent<TrackSegment>();
			segment.Init(_generator, null);
			
			UAssert.Near(segment.StartDist, 0.0f, 0.00001f);
			Assert.Greater(segment.EndDist, segment.StartDist);
		}
	}
}