using UnityEngine;
using System;
using System.Collections.Generic;

public class MobileInputHandler : InputHandler
{
    private float _steeringAdaptSpeed = 2.0f;
	private PadController _gamePad = null;

    private float _steering = 0.0f;
    private float _steeringAnchor;

    void Awake()
    {
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        Application.targetFrameRate = 60;

		// Android + GamePad Support
		_gamePad = gameObject.AddComponent<PadController>();
    }

    void Update()
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
                    float steerScale = 8.0f;
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

    public override float SteeringAmount()
    {
        float origSign = _steering < 0.0f ? -1.0f : 1.0f;
        return Mathf.Clamp01(_steering * _steering) * origSign;
    }
}
