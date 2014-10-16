using UnityEngine;
using UnityTest;
using NUnit.Framework;

using System;
using System.Collections.Generic;


namespace RtInfinity.Levels.Test
{
	internal class MockTrackGenerator : TrackGenerator
	{
		private const string MOCK_SETTINGS_JSON = @"{
			section: {
				name: 'start',
				segment: {
					material: 'SpaceRace',
					profile: {
						type: 'rounded-rect',
						params: {
							width: 10.0,
							height: 3.0,
							roundness: 0.1
						}
					},
					scale: {
						min: 4.0,
						max: 5.0
					},
					length: {
						min: 30.0,
						max: 30.0
					},
					curviness: {
						min: 5.0,
						max: 5.0
					}
				}
			}
		}";

		private static MersenneTwister _rand = new MersenneTwister(123);

		public MockTrackGenerator()
			: base(_rand, MOCK_SETTINGS_JSON) {}
	}
}
