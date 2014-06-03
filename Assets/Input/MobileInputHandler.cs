using UnityEngine;
using System;
using System.Collections.Generic;

public class MobileInputHandler : InputHandler
{
    private float _steeringValue = 3.0f;
	private PadController _gamePad = null;
    void Awake()
    {
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        Application.targetFrameRate = 30;

		// SHIELD
		//_gamePad = gameObject.AddComponent<PadController>();
    }

    void Update()
    {
        if (Input.touchCount > 0 && Input.touches[0].phase == TouchPhase.Began)
        {
            Vector3 touchPos = Input.touches[0].position;
            if (!ExecuteTouchAt(touchPos) && (touchPos.x > Screen.height * .15f || touchPos.y > Screen.height * .85f))
            {
                Jump();
            }
                
        }

		if( _gamePad && _gamePad.isDown(ControllerButtons.BUTA) )
			Jump();
		else if( _gamePad && _gamePad.isDown (ControllerButtons.BUTX) )
		   ExecuteTouchAt (new Vector3(Screen.width * 0.5f, Screen.height * 0.5f, 0.0f));
		

    }

    #region implemented abstract members of InputHandler
    public override float SteeringAmount()
    {
        float steer = Input.acceleration.x;
        //float x = Input.acceleration.x;
        //float absX = Mathf.Abs(x);
        //float steer = (Mathf.Sqrt(absX) + absX) * 0.5f;

        //if (x < 0.0f)
        //    steer *= -1.0f;

        return Mathf.Clamp(_steeringValue * steer, -1.0f, 1.0f);
    }
    #endregion
}
