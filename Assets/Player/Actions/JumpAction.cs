using UnityEngine;

using System;
using System.Collections.Generic;


public class JumpAction : IPlayerAction
{
    private const float JUMP_STEER_STRENGTH = 50.0f;
    private const float JUMP_STRENGTH = 60.0f;
    private FX _jumpEffect;

    private Player _player;
    private float _playerDrag = 1.0f;
    private int _jumpCount = 2;
    private int _availablejumpCount;

    // Filter out any "landed" actions that happen immediately after the jump started
    private float _ignoreLandedFilterTime = 0.5f;
    private float _ignoreLandedStartTime = -1.0f;
    private bool _hasJumped = false;

    public JumpAction(Player player)
    {
        _player = player;
        _jumpEffect = _player.JumpFX;
        _availablejumpCount = _jumpCount;
        _playerDrag = player.rigidbody.drag;
    }

    public void UserLanded()
    {
        if (_hasJumped && Time.time - _ignoreLandedFilterTime > _ignoreLandedStartTime)
        {
            _hasJumped = false;
            _player.rigidbody.drag = _playerDrag;
            _availablejumpCount = _jumpCount;
        }
    }

    public bool PerformAction()
    {
        // Have we done all the jumps available
        // before landing again?
        if (_availablejumpCount > 0)
        {
            // Cost another jump if the user wasn't grounded
            // when doing this jump
            if (!_hasJumped && !_player.IsGrounded())
                _availablejumpCount--;

            _hasJumped = true;
            _ignoreLandedStartTime = Time.time;
            _availablejumpCount--;

            ApplyJump();

            // If this isn't our first jump, allow
            // the user to steer a bit in the air
            if( _availablejumpCount < _jumpCount )
            {
                SteerDuringJump();
            }
            return true;
        }
        return false;
    }

    private void ApplyJump()
    {
        _player.rigidbody.drag = 0.0f;
        _player.rigidbody.AddForce(Vector3.up * JUMP_STRENGTH, ForceMode.Impulse);

        _jumpEffect.PerformFX();
    }

    private void SteerDuringJump()
    {
        float steerAmount = _player.InputHandler.SteeringAmount();
        Quaternion steerRot = Quaternion.AngleAxis(steerAmount * 2.0f * Mathf.PI * Time.fixedDeltaTime, Vector3.up);

        Vector3 heading = _player.rigidbody.velocity;
        heading.y = 0.0f;
        heading.Normalize();
        Vector3 newHeading = steerRot * heading;

        Vector3 right = Vector3.Cross(Vector3.up, newHeading) * steerAmount;
        _player.rigidbody.AddForce(right * JUMP_STEER_STRENGTH, ForceMode.Impulse);
    }
}
