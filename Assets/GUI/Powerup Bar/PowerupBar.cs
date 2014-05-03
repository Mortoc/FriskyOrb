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


    public void CollectedPowerup()
    {
        _currentPowerups += 1.0f;
        if (_currentPowerups >= _powerupsUntilFull)
        {

        }
    }


    private Rect _powerupBarGuiArea = new Rect();
    private Rect _powerupGooGuiArea = new Rect();
    

    [SerializeField]
    private float _powerupBarHeight = 0.5f;

    [SerializeField]
    private Texture _powerupBarBackground;
    [SerializeField]
    private Texture _powerupBarForeground;
    
    void OnGUI()
    {
        float aspectRatio = 51.0f / 512.0f;
        float height = Screen.height * _powerupBarHeight;
        float width = aspectRatio * height;
        _powerupBarGuiArea.x = Screen.width - width;
        _powerupBarGuiArea.y = Screen.height - height;
        _powerupBarGuiArea.width = Screen.width - _powerupBarGuiArea.x;
        _powerupBarGuiArea.height = Screen.height - _powerupBarGuiArea.y;
        
        _powerupGooGuiArea.width = _powerupBarGuiArea.width;
        _powerupGooGuiArea.height = _powerupBarGuiArea.height * PowerupPercent;
        _powerupGooGuiArea.x = _powerupBarGuiArea.x;
        _powerupGooGuiArea.y = Screen.height - _powerupGooGuiArea.height;


        GUI.DrawTexture(_powerupGooGuiArea, _powerupBarBackground);

        GUI.DrawTexture(_powerupBarGuiArea, _powerupBarForeground);
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

    private void ResetPowerup()
    {
        _currentPowerups = 0.0f;

    }
}
