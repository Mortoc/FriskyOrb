using UnityEngine;
using System;
using System.Collections.Generic;

public class PlayerMovementController : IPlayerController
{
    private const float ACCELERATION = 850.0f;
    private const float STEER_SPEED = 120.0f;
    private const float COUNTER_STEER = -0.1f;
    private const float MAX_SPEED = 12.0f;

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

    private Vector3 _currentUpVector;
    private void FixedUpdate()
    {
        if (_player.IsGrounded)
        {
            _currentUpVector = Physics.gravity.normalized * -1.0f;
            _jumpAction.PlayerLanded();

            if( _player.rigidbody.velocity.sqrMagnitude < MAX_SPEED * MAX_SPEED )
                RollForward();

            Steer();
        }
    }

    private void RollForward()
    {
        Vector3 rollAxis = Vector3.Cross(_currentUpVector, _player.Heading);
        _player.rigidbody.AddTorque(rollAxis * Time.fixedDeltaTime, ForceMode.Impulse);

        float steerAmount = Mathf.Abs(_inputHandler.SteeringAmount());

        Vector3 accel = _player.Heading * ACCELERATION * Time.fixedDeltaTime;
        _player.rigidbody.AddForce(accel, ForceMode.Acceleration);

        float counterAccel = Mathf.Lerp(0.0f, COUNTER_STEER, steerAmount); // reduce accleration while turning hard
        _player.rigidbody.AddForce(accel * counterAccel, ForceMode.Impulse);
    }

    private void Steer()
    {
        float steerAmount = _inputHandler.SteeringAmount();
        Quaternion steerRot = Quaternion.AngleAxis(
            steerAmount * STEER_SPEED * Time.fixedDeltaTime,
            _currentUpVector
        );
        _player.Heading = steerRot * _player.Heading;
        Vector3 right = Vector3.Cross(_currentUpVector, _player.Heading) * steerAmount;
        _player.rigidbody.AddForce(right * Time.fixedDeltaTime * 100.0f, ForceMode.Impulse);
    }
}