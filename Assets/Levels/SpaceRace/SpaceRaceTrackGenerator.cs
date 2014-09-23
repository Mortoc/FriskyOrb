using UnityEngine;
using System.Collections;


namespace RtInfinity.Levels.SpaceRace
{
	public class SpaceRaceTrackGenerator : ITrackGenerator
	{
		public void BuildNextSegment (System.Random generator)
		{
			throw new System.NotImplementedException ();
		}

		public void PlayerHasPassedSegment (TrackSegment segment)
		{
			throw new System.NotImplementedException ();
		}

		public System.Collections.Generic.IEnumerable<TrackSegment> TrackSegments {
			get {
				throw new System.NotImplementedException ();
			}
		}

	}
}