using UnityEngine;
using System;
using System.Collections.Generic;

public class MobileInputHandler : InputHandler 
{
	void Update()
	{
		if( Input.touchCount > 0 )
			ExecuteAction();
	}

	#region implemented abstract members of InputHandler
	public override float SteeringAmount ()
	{
		return Input.acceleration.x;
	}
	#endregion
}
