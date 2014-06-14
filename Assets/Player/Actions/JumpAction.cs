using UnityEngine;

using System;
using System.Collections.Generic;


public class JumpAction : MonoBehaviour
{

    [SerializeField]
    private float _jumpStrength = 100.0f;

    private FX _jumpEffect;

    [SerializeField]
    private float _jumpStretchTime = 0.5f;
    [SerializeField]
    private AnimationCurve _jumpStretchCurve;


    [SerializeField]
    private float _downShootStretchTime = 0.5f;
    [SerializeField]
    private AnimationCurve _downShootStretchCurve;

    [SerializeField]
    private float _landStretchTime = 0.5f;
    [SerializeField]
    private AnimationCurve _landStretchCurve;

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
            if (!_landed)
            {
                _player.StartCoroutine(ApplyStretchAnimation(_landStretchTime, _landStretchCurve));
            }

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
        _player.StartCoroutine(ApplyStretchAnimation(_downShootStretchTime, _downShootStretchCurve));

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

        _player.StartCoroutine(ApplyStretchAnimation(_jumpStretchTime, _jumpStretchCurve));
    }




    private System.Collections.IEnumerator ApplyStretchAnimation(float time, AnimationCurve curve)
    {
        float recipTime = 1.0f / time;
        for (float t = 0.0f; t < time; t += Time.deltaTime)
        {            
            yield return 0;
            _player.Stretch = curve.Evaluate(t * recipTime);
        }

        _player.Stretch = 0.0f;
    }
}
