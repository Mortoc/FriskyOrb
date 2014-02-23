using UnityEngine;

using System;
using System.Collections.Generic;


public class JumpAction : IPlayerAction
{
	private const float JUMP_STRENGTH = 20.0f;


	#region IPlayerAction implementation

	public bool PerformAction(Player player)
	{
		if( player.IsGrounded() )
		{
			Vector3 playerHeading = player.rigidbody.velocity.normalized;
			Vector3 jumpDirection = (playerHeading + (Vector3.up * 2.0f)) / 3.0f;
			player.rigidbody.AddForce (jumpDirection * JUMP_STRENGTH, ForceMode.Impulse);

			return true;
		}
		return false;
	}

	#endregion


}
