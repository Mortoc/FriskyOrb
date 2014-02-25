using UnityEngine;

using System;
using System.Collections.Generic;


public class JumpAction : IPlayerAction
{
	private const float JUMP_STRENGTH = 40.0f;


	#region IPlayerAction implementation

	public bool PerformAction(Player player)
	{
		if( player.IsGrounded() )
		{
			player.rigidbody.AddForce (Vector3.up * JUMP_STRENGTH, ForceMode.Impulse);
			return true;
		}
		return false;
	}

	#endregion


}
