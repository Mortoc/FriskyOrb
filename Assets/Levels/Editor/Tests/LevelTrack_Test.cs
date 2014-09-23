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
    internal class LevelTrack_Test : IDisposable
    {
		private GameObject _fixtureGameObject = new GameObject("TestTrack");
		private ITrackGenerator _generator = new RtInfinity.Levels.SpaceRace.SpaceRaceTrackGenerator();
		
		public void Dispose ()
		{
			GameObject.DestroyImmediate (_fixtureGameObject);
		}

        [Test]
        public void LevelTracksGenerateTrackSegments()
        {
			var track = new LevelTrack(_generator);
			var segments = track.Generate();
			Assert.IsNotNull(segments);
			Assert.IsNotNull(segments.First());
        }
    }
}