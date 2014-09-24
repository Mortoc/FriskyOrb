using UnityEngine;
using UnityTest;
using NUnit.Framework;

using System;
using System.Collections.Generic;
using System.Linq;

namespace RtInfinity.Levels.Test
{
	internal class MockTrackGenerator : TrackGenerator
	{
		private const string MOCK_SETTINGS_JSON = @"{
			section: {
				name: 'test',
				segment: {
					scale: {
						min: 4.0,
						max: 5.0
					},
					length: {
						min: 10.0,
						max: 10.0
					},
					curviness: {
						min: 1.0,
						max: 2.0
					}
				}
			}
		}";

		private static MersenneTwister _rand = new MersenneTwister(123);

		public MockTrackGenerator()
			: base(_rand, MOCK_SETTINGS_JSON) {}
	}

	
	[TestFixture]
	[Category("Gameplay")]
	internal class TrackGenerator_Test : IDisposable
	{
		private GameObject _fixtureGameObject = new GameObject("TestTrack");
		private TrackGenerator _generator = new MockTrackGenerator();
		
		public void Dispose ()
		{
			GameObject.DestroyImmediate(_fixtureGameObject);
		}

		[Test]
		public void TrackGeneratorsBuildMultipleSegments()
		{
			var 
		}
	}
}
