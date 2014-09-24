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

	public class LevelTrack : MonoBehaviour, ILevelTrack
	{
		private const int ACTIVE_TRACK_SEGMENTS = 8;

		private List<TrackSegment> _segments;
		private TrackGenerator _generator;

		public void Init(TrackGenerator generator)
		{
			_generator = generator;
			_segments = new List<TrackSegment>();
		}

		public IEnumerable<TrackSegment> Generate()
		{
			TrackSegment lastSegment = null;
			for(int i = 0; i < ACTIVE_TRACK_SEGMENTS; ++i)
			{
				var trackObj = new GameObject("TrackSegment");
				trackObj.transform.parent = transform;

				var trackSeg = trackObj.GetOrAddComponent<TrackSegment>();
				trackSeg.Init(_generator, lastSegment);
				_segments.Add(trackSeg);

				lastSegment = trackSeg;
			}
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
