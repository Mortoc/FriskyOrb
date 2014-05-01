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
		_fullRecip = 1.0f / _powerupsUntilFull;
		PowerupReady = false;
    }

	public void UsePowerup()
	{
		if (this && PowerupReady)
		{
			PowerupReady = false;
			ExecutePowerup(GameObject.FindObjectOfType<Player>());
		}
	}

    public void CollectedPowerup()
    {
        _currentPowerups += 1.0f;
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
            
            player.AnimateColor(Palette.Instance.Orange, 2.5f);
        };
    }
}
