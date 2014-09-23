using UnityEngine;
using System;
using System.Collections.Generic;

public class StarPowerupController : IPlayerController
{
    public event Action OnEnable;
    public event Action OnDisable;

    public event Action PowerupEnded;

    public const float POWERUP_DURATION = 2.0f; // seconds
    public const float PLAYER_SPEED = 1.0f; // segments/second

    private readonly Player _player;
    public AudioClip BeforeEndSound { get; set; }

    public StarPowerupController(Player player)
    {
        _player = player;    
    }

    public void Enable()
    {
        if (OnEnable != null)
            OnEnable();

        Score.Instance.RegisterEvent(Score.Event.ActivatePowerup);
        _player.PowerupFX.PerformFX();
        //_player.StartCoroutine(ExecutePowerup());
    }

    public void Disable()
    {
        if (OnDisable != null)
            OnDisable();
    }

}
