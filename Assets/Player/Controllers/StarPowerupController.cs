using UnityEngine;
using System;
using System.Collections.Generic;

public class StarPowerupController : IPlayerController
{
    public event Action OnEnable;
    public event Action OnDisable;

    private const float POWERUP_DURATION = 2.0f; // seconds
    private const float PLAYER_SPEED = 30.0f; // units/second

    private readonly Player _player;

    public StarPowerupController(Player player)
    {
        _player = player;
    }

    public void Enable()
    {
        if (OnEnable != null)
            OnEnable();

        Scheduler.Run(ExecutePowerup());
    }

    public void Disable()
    {
        if (OnDisable != null)
            OnDisable();
    }

    private IEnumerator<IYieldInstruction> ExecutePowerup()
    {
        for( float time = 0.0f; time < POWERUP_DURATION; time += Time.fixedDeltaTime )
        {
            yield return Yield.UntilNextFixedUpdate;
            Debug.Log("stack");
        }
    }
}
