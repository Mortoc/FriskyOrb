using UnityEngine;
using System;
using System.Collections.Generic;

public class MobileInputHandler : InputHandler
{
    private const float MIN_STEERING_VAL = 2.0f;
    private const float MAX_STEERING_VAL = 3.5f;
    private float _steeringValue = 3.0f;

    void Awake()
    {
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
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
        return Mathf.Clamp(_steeringValue * Input.acceleration.x, -1.0f, 1.0f);
    }
    #endregion
}
