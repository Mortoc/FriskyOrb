using UnityEngine;
using System;
using System.Collections.Generic;

public class PowerupBar : MonoBehaviour
{
    [SerializeField]
    private float _powerupsUntilFull = 100.0f;
    private float _fullRecip;
    private float _currentPowerups = 0.0f;
	
    [SerializeField]
    private AudioClip _activateSound;

	[SerializeField]
    private AudioClip _deactivateSound;

    void Start()
    {
        input.RegisterTouchRegion(_touchRegion, e =>
        {
            if (this && PowerupReady)
            {
                PowerupReady = false;
                StartCoroutine(UsePowerup());
                e.Consumed = true;
            }
        });
        
		_fullRecip = 1.0f / _powerupsUntilFull;
		
		PowerupReady = false;
    }

    public void CollectedPowerup()
    {
        _currentPowerups += 1.0f;

        if (_currentPowerups >= _powerupsUntilFull)
        {
            StartCoroutine(AnimateToActiveState());
            StartCoroutine(SpinButton());
        }
    }

    public float PowerupPercent
    {
        get { return Mathf.Clamp01(_currentPowerups * _fullRecip); }
    }

    public bool PowerupReady { get; private set; }

    private void ExecutePowerup(Player player)
    {
        if (!audio)
            gameObject.AddComponent<AudioSource>();
        audio.clip = _activateSound;
        audio.Play();

        var powerupController = new StarPowerupController(player);
        powerupController.BeforeEndSound = _deactivateSound;
        var originalController = player.Controller;
        
        if (originalController is StarPowerupController)
            throw new InvalidOperationException("Starting Powerup twice in a row");

        player.AnimateColor(Color.white, 0.5f);
        player.Controller = powerupController;
        powerupController.PowerupEnded += () => {
            player.Controller = originalController;
            player.IsImmortal = false;
            player.rigidbody.isKinematic = false;
            ResetPowerup();

            player.AnimateColor(Palette.Instance.Orange, 2.5f);
        };
    }
}
