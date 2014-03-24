using UnityEngine;
using System;
using System.Collections.Generic;

public class PlayerMovementController : IPlayerController
{
    private const float _acceleration = 1250.0f;
    private const float _steerSpeed = 100.0f;
    private const float _counterSteerAccel = -0.1f;

    private readonly Player _player;
    private readonly JumpAction _jumpAction;
    private readonly InputHandler _inputHandler;

    public PlayerMovementController(Player player)
    {
    	_player = player;
        _jumpAction = new JumpAction(_player);
        _inputHandler = GameObject.FindObjectOfType<InputHandler>();
    }

    public void Enable()
    {
        _inputHandler.OnAction += _jumpAction.PerformAction;
        _player.OnFixedUpdate += FixedUpdate;
    }

    public void Disable()
    {
    	_inputHandler.OnAction -= _jumpAction.PerformAction;
    	_player.OnFixedUpdate -= FixedUpdate;
    }

    private void FixedUpdate()
    {
    	if( _player.IsGrounded )
    	{
            _jumpAction.PlayerLanded();
	    	RollForward();
	    	Steer();
    	}
    }

    private void RollForward()
    {
        Vector3 rollAxis = Vector3.Cross(Vector3.up, _player.Heading);
        _player.rigidbody.AddTorque(rollAxis * Time.fixedDeltaTime, ForceMode.Impulse);

        float steerAmount = Mathf.Abs(_inputHandler.SteeringAmount());
        float counterAccel = Mathf.Lerp(0.0f, _counterSteerAccel, steerAmount); // reduce accleration while turning hard

        Vector3 accel = _player.HeadingOverGroundSlope() * _acceleration * Time.fixedDeltaTime;
        _player.rigidbody.AddForce(accel, ForceMode.Acceleration);
        _player.rigidbody.AddForce(accel * counterAccel, ForceMode.Impulse);    
    }

    private void Steer()
    {
        float steerAmount = _inputHandler.SteeringAmount();
        Quaternion steerRot = Quaternion.AngleAxis(steerAmount * _steerSpeed * Time.fixedDeltaTime, Vector3.up);
        _player.Heading = steerRot * _player.Heading;
        Vector3 right = Vector3.Cross(Vector3.up, _player.Heading) * steerAmount;
        _player.rigidbody.AddForce(right * Time.fixedDeltaTime * 100.0f, ForceMode.Impulse);
    }
}