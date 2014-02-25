using UnityEngine;
using System;
using System.Collections.Generic;

public class Player : MonoBehaviour 
{
	private float _acceleration = 1250.0f;
	private float _steerSpeed = 100.0f;

	public Level Level { get; set; }
	public LevelSegment CurrentSegment { get; set; }
	public InputHandler InputHandler { get; set; }

	public IPlayerAction CurrentAction { get; set; }

	private int _lastGroundedCheck = 0;
	private bool _isGroundedCached = true;
	public bool IsGrounded()
	{
		// Only calculate if we're grounded once per frame
		if( _lastGroundedCheck != Time.frameCount )
		{
			SphereCollider playerCollider = GetComponent<SphereCollider> ();
			float avgScale = (transform.lossyScale.x + transform.lossyScale.y + transform.lossyScale.z) / 3.0f;
			float rayDistance = avgScale * playerCollider.radius * 1.1f;
			int groundLayerMask = 1 << LayerMask.NameToLayer("Level");
			
			_isGroundedCached = Physics.Raycast(rigidbody.position, Vector3.down, rayDistance, groundLayerMask);
			_lastGroundedCheck = Time.frameCount;
		}

		return _isGroundedCached;
	}

	private Vector3 _heading = Vector3.forward;

	public Vector3 Heading
	{
		get { return _heading; }
	}


	void Start()
	{
		CurrentAction = new JumpAction();
		rigidbody.useConeFriction = true;
		InputHandler.OnAction += () => CurrentAction.PerformAction(this);
	}
	
	void FixedUpdate()
	{
		if( IsGrounded() )
		{
			Steer ();
			RollForward();
		}

		if( CurrentSegment )
		{
			float approxT = CurrentSegment.Path.GetApproxT( rigidbody.position );
			if( approxT > 0.999f )
			{
				LevelSegment oldSegment = CurrentSegment;
				CurrentSegment = CurrentSegment.Next;
				oldSegment.IsNoLongerCurrent();
			}
		}
	}

	private void RollForward()
	{
		//Vector3 rollAxis = Vector3.Cross (Vector3.up, _heading);
		//rigidbody.AddTorque (rollAxis * Time.fixedDeltaTime, ForceMode.Impulse);

		float steerAmount = Mathf.Abs(InputHandler.SteeringAmount());
		float counterAccel = Mathf.Lerp (0.0f, -0.1f, steerAmount); // reduce accleration while turning hard

		Vector3 accel = _heading * _acceleration * Time.fixedDeltaTime;
		rigidbody.AddForce(accel, ForceMode.Acceleration);
		rigidbody.AddForce(accel * counterAccel, ForceMode.Impulse);
	}

	private void Steer()
	{
		float steerAmount = InputHandler.SteeringAmount();
		Quaternion steerRot = Quaternion.AngleAxis (steerAmount * _steerSpeed * Time.fixedDeltaTime, Vector3.up);
		_heading = steerRot * _heading;
		Vector3 right = Vector3.Cross (Vector3.up, _heading) * steerAmount;
		rigidbody.AddForce (right * Time.fixedDeltaTime * 100.0f, ForceMode.Impulse);
	}

	public event Action<Collision> CollisionEntered;
	void OnCollisionEnter(Collision collision)
	{
		if( CollisionEntered != null )
			CollisionEntered(collision);
	}
}
