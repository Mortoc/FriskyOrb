using UnityEngine;
using System;
using System.Collections.Generic;

public class MobileInputHandler : InputHandler
{
    private float _steeringValue = 3.0f;

    void Awake()
    {
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        Application.targetFrameRate = 30;
    }

    void Update()
    {
        if (Input.touchCount > 0 && Input.touches[0].phase == TouchPhase.Began)
        {
            if (!ExecuteTouchAt(Input.touches[0].position))
                ExecuteAction();
        }
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
