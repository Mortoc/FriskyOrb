using UnityEngine;
using System;
using System.Collections.Generic;

public class PlayerMovementController : IPlayerController
{
    private const float SPEED = 20.0f;

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

    private void FixedUpdate()
    {
		float t = _player.NearestPathT + 0.25f;
		Spline.Segment path = _player.CurrentSegment.Path;

		if( t > 1.0f ) 
		{
			t -= 1.0f;
			path = _player.CurrentSegment.Next.Path;
		}
		    
        Vector3 dir = (path.GetPoint(t) - _player.NearestPathPoint).normalized;

        _player.rigidbody.AddForce(dir * SPEED * Time.fixedDeltaTime, ForceMode.VelocityChange);
        

    }
}