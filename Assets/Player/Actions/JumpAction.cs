using UnityEngine;

using System;
using System.Collections.Generic;


public class JumpAction
{
    private const float JUMP_STRENGTH = 100.0f;
    private FX _jumpEffect;

    private Player _player;
    private float _playerDrag = 1.0f;
    
    // Filter out any "landed" actions that happen immediately after the jump started
    private float _ignoreLandedFilterTime = 0.5f;
    private float _initialJumpTime = -1.0f;
    
	public bool JumpEnded { get; set; }
	private bool _landed = true;

    public JumpAction(Player player)
    {
		JumpEnded = true;
        _player = player;
        _jumpEffect = _player.JumpFX;
        _playerDrag = player.rigidbody.drag;
    }

    public void PlayerLanded()
    {
		if( Time.time - _ignoreLandedFilterTime > _initialJumpTime ) 
		{
			_landed = true;
			if ( !JumpEnded )
	        {
				ApplyEndJump();
	        }
		}
    }

    public void Jump()
    {
		if( JumpEnded && _landed )
		{
			_landed = false;
			JumpEnded = false;
			_jumpEffect.SendMessage("FirstJump", true);
			_initialJumpTime = Time.time;
			ApplyJump();
		}
    }

	public void EndJump()
	{
		if (JumpEnded)
			return;
		
		_player.rigidbody.AddForce(Physics.gravity.normalized * JUMP_STRENGTH, ForceMode.Impulse);
		ApplyEndJump();
	}

	private void ApplyEndJump()
	{
		if (!JumpEnded)
		{
			_player.rigidbody.drag = _playerDrag;
			JumpEnded = true;
		}
	}

    private void ApplyJump()
    {
        if (!_player)
            return;

        if( _player.rigidbody.velocity.y < 0.0f )
        {
            Vector3 vel = _player.rigidbody.velocity;
            vel.y = 0.0f;
            _player.rigidbody.velocity = vel;
        }

        _player.rigidbody.AddForce(Physics.gravity.normalized * -1.0f * JUMP_STRENGTH, ForceMode.Impulse);
        _jumpEffect.PerformFX();
    }

}
