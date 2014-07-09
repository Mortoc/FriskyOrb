using UnityEngine;
using System;
using System.Collections.Generic;

public class MobileInputHandler : InputHandler
{
    private float _steeringAdaptSpeed = 3.0f;
	private PadController _gamePad = null;

    private float _steering = 0.0f;
    private float _steeringAnchor;

	Vector2 firstPos = new Vector2();
	Vector2 lastPos = new Vector2();
	float firstTime = 0;
	float lastTime = 0;

    void Awake()
    {
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        Application.targetFrameRate = 60;

		// Android + GamePad Support
		_gamePad = gameObject.AddComponent<PadController>();
    }

    void Update()
    {
		//original
		//Scheme1 ();

		//tap to move, swipe to jump
		//Scheme2 ();

		//tap to move, tap center to jump
		Scheme3 ();

    }

	public void Scheme1()
	{
		if (Input.touchCount > 0 )
		{
			var touch = Input.touches[0];
			switch(touch.phase)
			{
				case TouchPhase.Began:
					EndJump();
					_steeringAnchor = touch.position.x;
					break;
				case TouchPhase.Moved:
				case TouchPhase.Stationary:
					// Steer
					float steerScale = 20.0f;
					if (Screen.orientation == ScreenOrientation.Landscape)
						steerScale *= 2.0f;
					
					_steering = ((touch.position.x - _steeringAnchor) / Screen.width) * steerScale;
					_steeringAnchor = Mathf.Lerp(_steeringAnchor, touch.position.x, Time.deltaTime * _steeringAdaptSpeed);
					break;
				case TouchPhase.Ended:
					_steering = 0.0f;
					Jump();
					break;	
			}
		}
		
		if (_gamePad.isDown(ControllerButtons.BUTA) || _gamePad.isDown(ControllerButtons.BUTX))
		{
			Jump();
		}
	}

	public void Scheme2()
	{
		if (Input.touchCount > 0 )
		{
			var touch = Input.touches[0];
			switch(touch.phase)
			{
				case TouchPhase.Began:
					firstPos = touch.position;
					firstTime = Time.time;
					//Debug.Log("In BEGAN: first pos: "+firstPos.ToString());
					//Debug.Log("IN BEGAN: first time "+firstTime);
					break;
				case TouchPhase.Moved:
				case TouchPhase.Stationary:
					if (touch.position.x > Screen.width / 2) 
					{
						_steering = 1;
					} 
					else 
					{
						_steering = -1;
					}
					break;
				case TouchPhase.Ended:
					_steering = 0.0f;
					lastPos = touch.position;
					lastTime = Time.time;
					//Debug.Log("IN ENDED: first time: " + firstTime);
					//Debug.Log("IN ENDED: last time " + lastTime);
					//Debug.Log("IN ENDED: first pos: " + firstPos);
					//Debug.Log("IN ENDED: last pos " + lastPos);
					if ((firstPos.y - lastPos.y) < -80 && lastTime - firstTime < 1 )
					{
						Jump();
					}
					break;
			}
		}
	}

	public void Scheme3()
	{
		if (Input.touchCount > 0 )
		{
			var touch = Input.touches[0];
            var recipWidth = 1.0f / Screen.width;
            var steeringButtonWidthPercent = 0.2f;
            var touchX = recipWidth * touch.position.x;

			switch(touch.phase)
			{
				case TouchPhase.Began:
				case TouchPhase.Moved:
				case TouchPhase.Stationary:
                    if (touchX < steeringButtonWidthPercent) 
					{
						_steering = -1.0f;
					} 
                    else if( touchX > (1.0f - steeringButtonWidthPercent))
                    {
                        _steering = 1.0f;
                    }
					else if(touch.phase == TouchPhase.Began)
					{
						_steering = 0.0f;
						Jump();
					}

					break;
				case TouchPhase.Ended:
					_steering = 0.0f;
					break;
			}
		}
	}


    public override float SteeringAmount()
    {
        float origSign = _steering < 0.0f ? -1.0f : 1.0f;
        return Mathf.Clamp01(_steering * _steering) * origSign;
    }
}
