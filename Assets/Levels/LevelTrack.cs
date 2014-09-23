using UnityEngine;

using System;
using System.Collections.Generic;

namespace RtInfinity.Levels
{
    public interface ILevelTrack
    {
        /// <summary>
        /// Strategy object that is responsible for generating the mesh of a level
        /// </summary>
        Vector3 GetSurfacePoint(float travelDist, float x);
        void UpdatePlayerPosition(float travelDist);
    }

	public class LevelTrack : ILevelTrack
	{
		private List<TrackSegment> _segments;
		private ITrackGenerator _generator;

		public LevelTrack(ITrackGenerator generator)
		{
			_generator = generator;
			_segments = new List<TrackSegment>();
		}

		public IEnumerable<TrackSegment> Generate()
		{
			return _segments;
		}

		public Vector3 GetSurfacePoint (float travelDist, float x)
		{
			throw new NotImplementedException();
		}

		public void UpdatePlayerPosition (float travelDist)
		{
			throw new NotImplementedException();
		}
	}
}
