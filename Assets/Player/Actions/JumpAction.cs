using UnityEngine;
using System;
using System.Collections.Generic;

using RtInfinity.Players;

public class JumpAction : MonoBehaviour
{
    [SerializeField]
    private float _jumpStrength = 100.0f;

    private FX _jumpEffect;

    private Player _player;
    
	public bool JumpEnded { get; set; }

    public void Setup(Player player)
    {
		JumpEnded = true;
        _player = player;
        _jumpEffect = _player.JumpFX;
        _player.OnGrounded += PlayerLanded;
    }

    private void PlayerLanded(RaycastHit rh)
    {
		if ( !JumpEnded )
	    {
            JumpEnded = true;
	    }
    }

    public void Jump()
    {
        if (JumpEnded)
		{
			JumpEnded = false;
			_jumpEffect.SendMessage("FirstJump", true);
			ApplyJump();
		}
        else
        {
            EndJump();
        }
    }

	public void EndJump()
	{
		if (JumpEnded || !_player)
			return;

		_player.rigidbody.AddForce(Physics.gravity.normalized * 2.0f * _jumpStrength, ForceMode.Impulse);
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
