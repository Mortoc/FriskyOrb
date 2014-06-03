using UnityEngine;
using System;
using System.Collections.Generic;

public class PCInputHandler : InputHandler 
{
	private bool _isJumping = false;

	void Update()
    {
        if (Input.GetKeyDown(KeyCode.Mouse0))
        {
            ExecuteTouchAt(Input.mousePosition);
        }

		bool spacePressed = Input.GetKey (KeyCode.Space);
		if( spacePressed && !_isJumping )
		{
            Jump();
			_isJumping = true;
        }
		else if( !spacePressed && _isJumping )
		{
			EndJump();
			_isJumping = false;
		}
	}

	#region implemented abstract members of InputHandler
	public override float SteeringAmount()
	{
		return Input.GetAxis("Steering");
	}
	#endregion

}
