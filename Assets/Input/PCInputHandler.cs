using UnityEngine;
using System;
using System.Collections.Generic;

public class PCInputHandler : InputHandler 
{
	void Update()
	{
		if( Input.GetKeyDown(KeyCode.Space) )
        {
            ExecuteAction();
        }
		
        if( Input.GetMouseButtonDown(0) )
        {
            ExecuteTouchAt(Input.mousePosition);
        }
	}

	#region implemented abstract members of InputHandler
	public override float SteeringAmount ()
	{
		return Input.GetAxis("Steering");
	}
	#endregion

}
