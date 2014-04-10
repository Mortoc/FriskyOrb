using UnityEngine;
using System.Collections.Generic;

public class JumpFX : FX
{
	[SerializeField]
	private AudioClip _firstJump;
	[SerializeField]
	private AudioClip _otherJumps;

    public override void PerformFX()
    {
        transform.forward = Physics.gravity.normalized;

        particleSystem.Emit(
            Mathf.FloorToInt(particleSystem.emissionRate * particleSystem.duration)
        );
    }

	public void FirstJump(bool first)
	{
		AudioSource.PlayClipAtPoint(first ? _firstJump : _otherJumps, transform.position);
	}
}
