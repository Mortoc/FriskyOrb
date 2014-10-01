using UnityEngine;
using System.Collections.Generic;

using Procedural;


namespace RtInfinity.Levels
{
	/// <summary>
	/// The atoms of levels. As the player progresses, new segments are generated and 
	/// streamed in and old ones are cleaned up. Each segment corresponds to 1 Loft.
	/// </summary>
	public class TrackSegment : MonoBehaviour
	{
		private const int PATH_SEGMENTS = 32;
		private const int SHAPE_SEGMENTS = 24;
		private const int COLLISION_PATH_SEGMENTS = 16;
		private const int COLLISION_SHAPE_SEGMENTS = 12;

		private TrackGenerator _generator;
		private Loft _loft;

		/// <summary>
		/// Gets the loft that defines the mesh of this segment
		/// </summary>
		public ILoft Loft
		{
			get { return _loft; }
		}

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

		public int Section { get; private set; }

		public TrackSegment Next { get; private set; }


		public void Init(TrackGenerator generator, TrackSegment lastSegment)
		{
			_generator = generator;
			gameObject.layer = LayerMask.NameToLayer("Level");
			Section = 0;
			if( lastSegment )
				lastSegment.Next = this;

			if( lastSegment == null )
				StartDist = 0.0f;
			else
				StartDist = lastSegment.EndDist;

			_loft = _generator.BuildSegmentLoft(lastSegment, Section);
			EndDist = StartDist + _loft.Path.DistanceSample(1.0f);
			GenerateMeshFromLoft();
		}

		private void GenerateMeshFromLoft()
		{
			var meshFilter = gameObject.GetOrAddComponent<MeshFilter>();
			meshFilter.sharedMesh = _loft.GenerateMesh(PATH_SEGMENTS, SHAPE_SEGMENTS);

			var meshRenderer = gameObject.GetOrAddComponent<MeshRenderer>();
			meshRenderer.sharedMaterial = _generator.GetTrackMaterial(this);

			var meshCollider = gameObject.GetOrAddComponent<MeshCollider>();
			meshCollider.sharedMesh = _loft.GenerateMesh(COLLISION_PATH_SEGMENTS, COLLISION_SHAPE_SEGMENTS);
		}
	}
}