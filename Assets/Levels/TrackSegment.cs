using UnityEngine;
using System.Collections.Generic;

using Procedural;


namespace RtInfinity.Levels
{
	public class TrackSegment : MonoBehaviour 
	{
		private ITrackGenerator _generator;

		/// <summary>
		/// Gets the distance the player must travel from the beginning 
		/// of the level to get to the beginning of this segment.
		/// </summary>
		public float StartDist { get; private set; }

		
		/// <summary>
		/// Gets the distance the player must travel from the beginning 
		/// of the level to get to the end of this segment.
		/// </summary>
		public float EndDist { get; private set; }


		public void Init(ITrackGenerator generator, TrackSegment lastSegment)
		{
			_generator = generator;

			if( lastSegment == null )
			{
				StartDist = 0.0f;
			}
			else
			{
				StartDist = lastSegment.EndDist;
			}


		}
	}
}