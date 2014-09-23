using UnityEngine;
using System.Collections.Generic;


namespace RtInfinity.Levels
{
	/// <summary>
	/// The track generator is a strategy object that is responsible for creating 
	/// and cleaning up track segments.
	/// </summary>
    public interface ITrackGenerator
    {
		/// <summary>
		/// Gets all of the currently active track segments
		/// </summary>
		IEnumerable<TrackSegment> TrackSegments { get; }

		void BuildNextSegment(System.Random generator);

		void PlayerHasPassedSegment(TrackSegment segment);
    }
}
