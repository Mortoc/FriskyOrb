﻿using UnityEngine;
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
		private TrackGenerator _generator = new MockTrackGenerator();
		
		public void Dispose ()
		{
			GameObject.DestroyImmediate(_fixtureGameObject);
		}

		[Test]
		public void LevelTracksGenerateMultipleTrackSegments()
		{
			var track =  _fixtureGameObject.GetOrAddComponent<LevelTrack>();
			track.Init (_generator, 8);
			
			var segments = track.Generate();

			Assert.AreEqual(8, segments.Count());

			foreach( var seg in segments )
				Assert.IsNotNull(seg);
		}

		[Test]
		public void GetSurfacePointDoesntBreakAcrossBoundaries()
		{
			var track =  _fixtureGameObject.GetOrAddComponent<LevelTrack>();
			track.Init (_generator, 2);
			var segments = new List<TrackSegment>(track.Generate());

			var segment0 = segments[0];
			var segment1 = segments[1];

			var seg0Pnt = track.GetSurfacePoint(segment0.EndDist * 0.9999f, 0.25f);
			var seg1Pnt = track.GetSurfacePoint(segment1.StartDist * 1.0001f, 0.25f);

			UAssert.Near(seg0Pnt, seg1Pnt, 0.01f);
			UAssert.NotNear(Vector3.zero, seg0Pnt, 0.1f);
		}

		[Test]
		public void UpdatingPlayerDistanceMakesNewTracksAndCleansUpOldOnes()
		{
			var track =  _fixtureGameObject.GetOrAddComponent<LevelTrack>();
			track.Init(_generator, 4);
			
			var initialSegments = new List<TrackSegment>(track.Generate());
			
			track.UpdatePlayerPosition(initialSegments[0].EndDist * 1.001f);

			var updatedSegments = new List<TrackSegment>(track.ActiveSegments);
			for(int i = 1; i < 3; ++i)
				Assert.AreSame(updatedSegments[i - 1], initialSegments[i]);

			Assert.IsFalse(initialSegments[0], "The first segment is destroyed in Unity");
			Assert.IsTrue(updatedSegments[3], "The newest segment was created");
		}
    }
}
