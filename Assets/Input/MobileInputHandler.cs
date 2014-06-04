using UnityEngine;
using System;
using System.Collections.Generic;

public class MobileInputHandler : InputHandler
{
    private float _steeringAdaptSpeed = 2.0f;
	private PadController _gamePad = null;

    private float _steeringAnchor;
    void Awake()
    {
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        Application.targetFrameRate = 60;

		// Android + GamePad Support
		_gamePad = gameObject.AddComponent<PadController>();
    }

    void OnGUI()
    {
        GUI.color = Color.white;
        GUI.Label(new Rect(Screen.width * 0.4f, Screen.height * 0.4f, Screen.width * 0.2f, Screen.height * 0.2f), "Steering: " + _steering);
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
                    _steering = ((touch.position.x - _steeringAnchor) / Screen.width) * 4.0f;
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

    private float _steering = 0.0f;

    #region implemented abstract members of InputHandler
    public override float SteeringAmount()
    {
        float origSign = _steering < 0.0f ? -1.0f : 1.0f;
        return Mathf.Clamp01(_steering * _steering) * origSign;

        //float steer = Input.acceleration.x;
        //float x = Input.acceleration.x;
        //float absX = Mathf.Abs(x);
        //float steer = (Mathf.Sqrt(absX) + absX) * 0.5f;

        //if (x < 0.0f)
        //    steer *= -1.0f;

        //return Mathf.Clamp(_steeringValue * steer, -1.0f, 1.0f);
    }
    #endregion
}
