﻿using UnityEngine;
using System;
using System.Collections.Generic;

public class PCInputHandler : InputHandler 
{
	void Update()
    {
        if (Input.GetKeyDown(KeyCode.Mouse0))
        {
            ExecuteTouchAt(Input.mousePosition);
        }

		if( Input.GetKeyDown(KeyCode.Space) )
        {
            ExecuteAction();
        }
	}

	#region implemented abstract members of InputHandler
	public override float SteeringAmount ()
	{
		return Input.GetAxis("Steering");
	}
	#endregion

}


// Download the paid version of the game for free until April 30th at: www.mortoc.com/bombed.html