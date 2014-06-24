using UnityEngine;

using System;
using System.Collections.Generic;


public class JumpAction : MonoBehaviour
{

    [SerializeField]
    private float _jumpStrength = 100.0f;

    private FX _jumpEffect;

    private Player _player;
    
    // Filter out any "landed" actions that happen immediately after the jump started
    private float _ignoreLandedFilterTime = 0.5f;
    private float _initialJumpTime = -1.0f;
    
	public bool JumpEnded { get; set; }
	private bool _landed = true;

    public void Setup(Player player)
    {
		JumpEnded = true;
        _player = player;
        _jumpEffect = _player.JumpFX;
        _player.OnGrounded += PlayerLanded;
    }

    private void PlayerLanded()
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
		
		_player.rigidbody.AddForce(Physics.gravity.normalized * 2.0f * _jumpStrength, ForceMode.Impulse);
        
		ApplyEndJump();
	}

	private void ApplyEndJump()
	{
		if (!JumpEnded)
		{
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

        _player.rigidbody.AddForce(Physics.gravity.normalized * -1.0f * _jumpStrength, ForceMode.Impulse);
        _jumpEffect.PerformFX();
    }




}
