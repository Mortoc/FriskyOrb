using UnityEngine;
using System;
using System.Collections.Generic;

public class Player : MonoBehaviour 
{
	private float _acceleration = 35.0f;
	private float _maxSpeed = 15.0f;
	private float _steerSpeed = 250.0f;

	public LevelSegment CurrentSegment;
	public InputHandler InputHandler;

	private bool _segmentTIsDirty = true;
	private float _segmentT = 0.0f;

	// Get the approximate T-Value for the player along the CurrentSegment
	public float SegmentT
	{
		get 
		{
			if( !CurrentSegment )
				return 0.0f;

			if( _segmentTIsDirty )
			{
				_segmentT = CurrentSegment.Path.GetApproxT( transform.position );
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

	void OnCollisionStay(Collision collision)
	{
		// Keep track of the current LevelSegment we're on
		if( collision.collider.gameObject.layer == LayerMask.NameToLayer("Level") )
		{
			LevelSegment onSegment = collision.collider.gameObject.GetComponent<LevelSegment>();
			if( onSegment != CurrentSegment )
			{
				_segmentTIsDirty = true;
				
				if( CurrentSegment )
					CurrentSegment.IsNoLongerCurrent();

				CurrentSegment = onSegment;
			}
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
