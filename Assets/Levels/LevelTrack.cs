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
		private int _activeTrackSegments = 10;

		private List<TrackSegment> _segments;
		private TrackGenerator _generator;

		public LevelTrack Init(TrackGenerator generator, int activeTrackSegments)
		{
			_generator = generator;
			_segments = new List<TrackSegment>();
			_activeTrackSegments = activeTrackSegments;
			return this;
		}

		public IEnumerable<TrackSegment> ActiveSegments
		{
			get { return _segments; }
		}

		public IEnumerable<TrackSegment> Generate()
		{
			TrackSegment lastSegment = null;
			for(int i = 0; i < _activeTrackSegments; ++i)
			{
				lastSegment = BuildSegment(lastSegment);
			}
			return _segments;
		}

		private TrackSegment BuildSegment(TrackSegment lastSegment)
		{
			var trackObj = new GameObject("TrackSegment");
			trackObj.transform.parent = transform;
			
			var trackSeg = trackObj.GetOrAddComponent<TrackSegment>();
			trackSeg.Init(_generator, lastSegment);
			_segments.Add(trackSeg);

			return trackSeg;
		}

		public Vector3 GetSurfacePoint(float travelDist, float x)
		{
			TrackSegment track = _segments[0];
			while(track.EndDist < travelDist)
				track = track.Next;

			var distInSeg = travelDist - track.StartDist;
			var pathT = distInSeg / (track.EndDist - track.StartDist);

			var shapeLength = track.Loft.Shape.DistanceSample(1.0f);
			var distOnShape = x % shapeLength;
			var shapeT = distOnShape / shapeLength;

			return track.Loft.SurfacePoint(pathT, shapeT);
		}

		public void UpdatePlayerPosition(float travelDist)
		{
			if( travelDist > _segments[0].EndDist )
			{
				GameObject.DestroyImmediate(_segments[0].gameObject);
				_segments.RemoveAt(0);
				_segments.Add(BuildSegment(_segments[_segments.Count - 1]));
			}
		}
	}
}
