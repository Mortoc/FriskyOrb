using UnityEngine;
using System;
using System.Collections.Generic;

public class PCInputHandler : InputHandler 
{
	void Update()
	{
		if( Input.GetKey(KeyCode.Space) )
			ExecuteAction();
	}

	#region implemented abstract members of InputHandler
	public override float SteeringAmount ()
	{
		return Input.GetAxis("Steering");
	}
	#endregion
}
