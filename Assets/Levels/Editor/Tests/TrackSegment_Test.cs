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
		private TrackGenerator _generator = new MockTrackGenerator();
		
		public void Dispose ()
		{
			GameObject.DestroyImmediate(_fixtureGameObject);
		}
		
		[Test]
		public void InitVerification()
		{
			var segment = _fixtureGameObject.AddComponent<TrackSegment>();
			segment.Init(_generator, null);
			
			UAssert.Near(segment.StartDist, 0.0f, 0.00001f);
			Assert.Greater(segment.EndDist, segment.StartDist);
		}

		[Test]
		public void TracksStartAtThePreviousEndDistance()
		{
			var prevSegment = _fixtureGameObject.AddComponent<TrackSegment>();
			prevSegment.Init (_generator, null);
			Assert.Greater(prevSegment.EndDist, 0.0f);

			var segment = _fixtureGameObject.AddComponent<TrackSegment>();
			segment.Init(_generator, prevSegment);
			Assert.AreEqual(segment.StartDist, prevSegment.EndDist);
		}

		[Test]
		public void TrackSegmentsGenerateTheRequiredComponentsDuringInit()
		{
			var segment = _fixtureGameObject.AddComponent<TrackSegment>();
			segment.Init (_generator, null);

			Assert.IsTrue(segment.GetComponent<MeshFilter>());
			Assert.IsTrue(segment.GetComponent<MeshFilter>().sharedMesh);
			Assert.IsTrue(segment.GetComponent<MeshRenderer>());
			Assert.IsTrue(segment.renderer.sharedMaterial);
			Assert.IsTrue(segment.GetComponent<MeshCollider>());
		}

		[Test]
		public void TrackSegmentsAreOnLevelLayer()
		{
			var segment = _fixtureGameObject.AddComponent<TrackSegment>();
			segment.Init (_generator, null);

			Assert.AreEqual(segment.gameObject.layer, LayerMask.NameToLayer("Level"));
		}

	}
}