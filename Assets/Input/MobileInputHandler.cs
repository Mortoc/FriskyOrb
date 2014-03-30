using UnityEngine;
using System;
using System.Collections.Generic;

public class MobileInputHandler : InputHandler
{
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
        return Mathf.Clamp(3.5f * Input.acceleration.x, -1.0f, 1.0f);
    }
    #endregion
}
