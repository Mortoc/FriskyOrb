using UnityEngine;
using System;
using System.Collections.Generic;

public class PlayerMovementController : IPlayerController
{
    private const float FORWARD_POWER = 15000.0f;
    private const float TOP_SPEED = 50.0f;
    private const float PLAYER_RADIUS = 0.25f;
    private const float STEERING_SPEED = 150.0f;
    private const float TRACTION = 3.33f;

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
        _inputHandler.OnJump += _jumpAction.Jump;
		_inputHandler.OnEndJump += _jumpAction.EndJump;
        _player.OnFixedUpdate += FixedUpdate;
    }

    public void Disable()
    {
		_inputHandler.OnJump -= _jumpAction.Jump;
		_inputHandler.OnEndJump -= _jumpAction.EndJump;
        _player.OnFixedUpdate -= FixedUpdate;
    }

    private float CurrentPower(float speed)
    {
        return Mathf.Lerp(FORWARD_POWER, 0.0f, speed / TOP_SPEED);
    }

    private void FixedUpdate()
    {
        Vector3 velocity = _player.rigidbody.velocity;
        float speed = velocity.magnitude;
        float accel = CurrentPower(speed);
        Vector3 left = Vector3.Cross(Vector3.up, _player.Heading);
        _player.rigidbody.AddForce(_player.Heading * accel * Time.fixedDeltaTime);

        float steeringAmount = _inputHandler.SteeringAmount();
        float leftDotVel = Vector3.Dot(left, velocity);

        if (leftDotVel * steeringAmount < 0.0f)
        {
            steeringAmount *= TRACTION;
        }

        _player.rigidbody.AddForce(left * STEERING_SPEED * steeringAmount * Time.fixedDeltaTime, ForceMode.Impulse);
    }
}