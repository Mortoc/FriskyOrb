﻿using UnityEngine;
using System;
using System.Collections.Generic;

public class Player : MonoBehaviour 
{
	private float _acceleration = 35.0f;
	private float _maxSpeed = 10.0f;
	private float _steerSpeed = 150.0f;

	public Level Level { get; set; }
	public LevelSegment CurrentSegment { get; set; }
	public InputHandler InputHandler { get; set; }

	private bool _segmentTIsDirty = true;
	private float _segmentT = 0.0f;

	// Get the approximate T-Value for the player along the CurrentSegment
	public float SegmentT
	{
		get 
		{
			if( !CurrentSegment )
				throw new Exception("CurrentSegment got null somehow");

			if( _segmentTIsDirty )
			{
				_segmentT = CurrentSegment.Path.GetApproxT( transform.position );

				if( _segmentT >= 1.0f - Mathf.Epsilon )
				{
					CurrentSegment.IsNoLongerCurrent();
					CurrentSegment = CurrentSegment.Next;
					_segmentT = CurrentSegment.Path.GetApproxT( transform.position );
				}
				_segmentTIsDirty = false;
			}

			return _segmentT;
		}
	}

	void Start()
	{
		rigidbody.useConeFriction = true;
	}
	
	void FixedUpdate()
	{
		_segmentTIsDirty = true;

		if( CurrentSegment )
		{
			Steer ();
			AddForwardForce();
		}
	}

	private void Steer()
	{
		Quaternion steer = Quaternion.AngleAxis(InputHandler.SteeringAmount() * _steerSpeed, Vector3.up);
		Vector3 curDir = rigidbody.velocity.normalized;
		Vector3 steerDir = steer * curDir;

		// Steal some of the forward momentum and put it in the new steering direction
		rigidbody.AddForce (-1.0f * curDir * Time.deltaTime * _steerSpeed, ForceMode.Impulse);
		rigidbody.AddForce (steerDir * Time.deltaTime * _steerSpeed, ForceMode.Impulse);
	}

	void AddForwardForce()
	{
		float lookAheadT = SegmentT + 0.05f;
		Vector3 pointOnPath = CurrentSegment.Path.GetPoint(SegmentT);
		Vector3 aheadOnPath = lookAheadT > 1.0f ?
			CurrentSegment.Next.Path.GetPoint( lookAheadT - 1.0f ) : 
			CurrentSegment.Path.GetPoint( lookAheadT );

		Vector3 forwardOnPath = aheadOnPath - pointOnPath;
		forwardOnPath.y = 0.0f;
		forwardOnPath.Normalize();
		rigidbody.AddForce (forwardOnPath * _acceleration * rigidbody.mass * Time.fixedDeltaTime, ForceMode.Impulse);

		if( rigidbody.velocity.sqrMagnitude > _maxSpeed * _maxSpeed )
		{
			rigidbody.velocity = MathExt.SetVectorLength(rigidbody.velocity, _maxSpeed);
		}
	}

	void OnDrawGizmos()
	{
		if( CurrentSegment )
		{
			Gizmos.color = Color.Lerp( Color.red, Color.white, 0.25f );
			Vector3 pathPoint = CurrentSegment.Path.GetPoint( SegmentT );
			Gizmos.DrawLine( transform.position, pathPoint );
			Gizmos.DrawSphere( pathPoint, 0.1f );
		}
	}
}
