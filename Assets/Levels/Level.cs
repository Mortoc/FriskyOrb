﻿using UnityEngine;
using System;
using System.Collections.Generic;

public class Level : MonoBehaviour
{
	[Serializable]
	private class SegmentProfile
	{
		public string Name = "";
		public float Difficulty = 1.0f;
		public AnimationCurve Left = new AnimationCurve();
		public AnimationCurve Right = new AnimationCurve();
	}

	[Serializable]
	private class TrackObstacle
	{
		public float Difficulty = 1.0f;
		public GameObject Prefab = null;
	}

	[Serializable]
	private class GeneratorVariables
	{
		public int StartSegment = 0;
		public float ApproxSegmentLength = 20.0f;
		public float SegmentLengthJitter = 5.0f;
		public float Curviness = 15.0f;
		public float MaxHeightDifference = 0.0f;
		public float MaxDifficulty = 1.0f;

		public override string ToString()
		{
			return "Tweakables [StartSegment: " + StartSegment + "]";
		}
	}

	[SerializeField]
	private GeneratorVariables[] _tweakables;

	[SerializeField]
	private SegmentProfile[] _segmentProfiles;

	[SerializeField]
	private int _viewDistance = 3;

	[SerializeField]
	private Material _levelTrackMaterial;
	public Material LevelTrackMaterial 
	{
		get { return _levelTrackMaterial; }
	}

	[SerializeField]
	private Player _playerPrefab;
	private Player _player;
	private CameraController _camera;
	private InputHandler _inputHandler;

	private int _segmentNumber = 0;
	private int _seed = 2;
	private MersenneTwister _rand;

	private LevelSegment _lastSegment;

	void Awake ()
	{
		_seed = Mathf.FloorToInt (UnityEngine.Random.value * 1000000.0f);
		// Generate Level
		_rand = new MersenneTwister(_seed);

		LevelSegment first = null;
		LevelSegment previous = null;
		for( int i = 0; i < _viewDistance; ++i ) 
		{
			previous = GenerateNextSegment(previous, true);
			if( first == null )
				first = previous;
		}
		// Since the first segment has no collider, mark it
		// no longer current when the 2nd element gets marked.
		first.Next.OnIsNoLongerCurrent += first.IsNoLongerCurrent;
		first.Next.collider.enabled = true;

		// Setup Input
		_inputHandler = InputHandler.BuildInputHandler();

		// Setup Player
		GameObject playerObj = Instantiate (_playerPrefab.gameObject) as GameObject;
		_player = playerObj.GetComponent<Player> ();
		_player.InputHandler = _inputHandler;
		_player.transform.position = first.Path.GetPoint(0.1f) + Vector3.up;
		_player.gameObject.name = "Player";
		_player.Level = this;
		_player.CurrentSegment = first.Next;
		_player.rigidbody.Sleep();

		// Setup Camera
		_camera = Camera.main.gameObject.AddComponent<CameraController> ();
		_camera.Player = _player;

		Scheduler.Run (WakePlayer(first));
	}

	private IEnumerator<IYieldInstruction> WakePlayer(LevelSegment first)
	{
		yield return new YieldForSeconds (1.0f);
		_player.rigidbody.WakeUp ();
		first.Next.collider.enabled = true;
	}

	// Called when a segment cleans itself up after the user has passed it
	public void SegmentDestroyed()
	{
		GenerateNextSegment(_lastSegment, false);
	}

	private LevelSegment GenerateNextSegment(LevelSegment previous, bool initialSegments)
	{
		_segmentNumber++;

		GeneratorVariables tweakables = _tweakables[0];
		foreach( var possibleTweakables in _tweakables )
		{
			if( possibleTweakables.StartSegment >= _segmentNumber )
				break;

			tweakables = possibleTweakables;
		}

		// Generate the control points
		float thisSegmentLength = Mathf.Lerp
		(
			tweakables.ApproxSegmentLength - tweakables.SegmentLengthJitter,
			tweakables.ApproxSegmentLength + tweakables.SegmentLengthJitter,
			_rand.NextSinglePositive ()
		);
		float halfSegLength = thisSegmentLength * 0.5f;
		Vector3 a;
		Vector3 aCP;
		Vector3 forwardDirection = Vector3.forward;
		float previousHeight = 0.0f;
		if( previous == null )
		{
			// starting from zero
			a = Vector3.zero;
			aCP = a + Vector3.forward * halfSegLength;
		}
		else
		{
			// starting from the previous position
			// Lerp a back slightly to avoid visual cracks in the meshes
			a = Vector3.Lerp(previous.Path.B.position, previous.Path.B_CP.position, 0.01f);
			previousHeight = previous.Path.B.position.y;
			Vector3 prevBcpDiff = a - previous.Path.B_CP.position;
			aCP = a + prevBcpDiff;

			forwardDirection = prevBcpDiff.normalized;
		}

		float rotationRandom = Mathf.Lerp (-1.0f, 1.0f, _rand.NextSingle());
		Quaternion segmentRotation = Quaternion.AngleAxis (tweakables.Curviness * rotationRandom * 2.0f, Vector3.up);
		Vector3 b = a + segmentRotation * (forwardDirection * thisSegmentLength);

		float rotationCPRandom = Mathf.Lerp (-1.0f, 1.0f, _rand.NextSingle());
		Quaternion curveBRotation = Quaternion.AngleAxis(tweakables.Curviness * rotationCPRandom, Vector3.up);
		Vector3 bCP = b - curveBRotation * (forwardDirection * halfSegLength);

		// Set Path height
		float elevationChange = 1.0f - (_rand.NextSingle () * 2.0f);
		elevationChange *= tweakables.MaxHeightDifference;
		a.y = previousHeight;
		aCP.y = previousHeight;
		b.y = previousHeight + elevationChange;
		bCP.y = previousHeight + elevationChange;

		// Figure out which Profile to use
		uint highestProfile;
		for(highestProfile = 0; highestProfile < _segmentProfiles.Length && _segmentProfiles[highestProfile].Difficulty < tweakables.MaxDifficulty; ++highestProfile);
	
		SegmentProfile profile;

		if( highestProfile > 0 )
			profile = _segmentProfiles[(int)(_rand.NextUInt32() % highestProfile)];
		else
			profile = _segmentProfiles[0];

		// Generate the level segment
		LevelSegment.CreateInfo options = new LevelSegment.CreateInfo ()
		{
			id = _segmentNumber,
			level = this,
			pntA = a,
			cpA = aCP,
			pntB = b,
			cpB = bCP,
			leftProfile = profile.Left,
			rightProfile = profile.Right,
			previous = previous,
			async = !initialSegments
		};
		LevelSegment nextSegment = LevelSegment.Create(options);

		if( previous != null )
			previous.Next = nextSegment;

		_lastSegment = nextSegment;
		return nextSegment;
	}

}
