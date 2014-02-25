using UnityEngine;
using System;
using System.Collections.Generic;

public class CameraController : MonoBehaviour 
{
	public Player Player { get; set; }

	private Vector3 _followDistance = new Vector3
	(
		0.0f, 1.5f, -2.0f
	);
	private float _lookAheadDistance = 5.0f;

	private SmoothedVector _lookAtTarget = new SmoothedVector(0.25f);
	private SmoothedVector _currentPosition = new SmoothedVector(0.25f);
	
	void FixedUpdate()
	{
		if( Player && Player.CurrentSegment )
		{
			Vector3 lookAtPos = Player.rigidbody.position + (Player.Heading * _lookAheadDistance);

			_lookAtTarget.AddSample(lookAtPos);

			Quaternion viewRotation = Quaternion.FromToRotation (Vector3.forward, (lookAtPos - Player.rigidbody.position).normalized); 
			_currentPosition.AddSample( Player.transform.position + (viewRotation * _followDistance) );

			transform.position = _currentPosition.GetSmoothedPosition();
			transform.LookAt( _lookAtTarget.GetSmoothedPosition() );
		}
	}
}
