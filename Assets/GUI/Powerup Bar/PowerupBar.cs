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
        if (PowerupReady)
            return;

        if (_currentPowerups >= _powerupsUntilFull)
        {
            PowerupReady = true;
        }
        else
        {
            _currentPowerups += 1.0f;
        }
    }

    private Rect _powerupBarGuiArea = new Rect();
    private Rect _powerupGooGuiArea = new Rect();
    

    [SerializeField]
    private float _powerupBarHeight = 0.5f;

    [SerializeField]
    private Texture _powerupBarBackground;

    [SerializeField]
    private Texture _powerupBarFullBackground;

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
        
//        if( PowerupReady )
//        {
//            _powerupButtonArea.width = Screen.height * _powerupButtonHeight;
//            _powerupButtonArea.height = _powerupButtonArea.width;
//            _powerupButtonArea.x = Screen.width - _powerupButtonArea.width;
//            _powerupButtonArea.y = Screen.height - (_powerupButtonArea.height - (_powerupBarGuiArea.width * 0.5f));
//
//            GUI.DrawTexture(_powerupGooGuiArea, _powerupBarBackground);
//            GUI.DrawTexture(_powerupBarGuiArea, _powerupBarForeground);
//            GUI.DrawTexture(_powerupBarGuiArea, _powerupBarFullBackground);
//
//            Color guiColor = GUI.color;
//            _tempGuiColor.r = guiColor.r;
//            _tempGuiColor.g = guiColor.g;
//            _tempGuiColor.b = guiColor.b;
//            _tempGuiColor.a = Mathf.Abs(Mathf.Sin(Time.time * _powerupBarFullPulseRate));
//            GUI.color = _tempGuiColor;
//            GUI.DrawTexture(_powerupButtonArea, _powerupButtonGlow);
//
//            _tempGuiColor.a = Mathf.Clamp01((Time.time - _powerupButtonFadeStart) * _powerupButtonFadeTimeRecip);
//            GUI.color = _tempGuiColor;
//
//            if( GUI.Button(_powerupButtonArea, "", _powerupButton) )
//            {
//                ExecutePowerup(GameObject.FindObjectOfType<Player>());
//            }
//            GUI.color = guiColor;
//        }
//        else
//        {
            _powerupGooGuiArea.width = _powerupBarGuiArea.width;
            _powerupGooGuiArea.height = _powerupBarGuiArea.height * PowerupPercent;
            _powerupGooGuiArea.x = _powerupBarGuiArea.x;
            _powerupGooGuiArea.y = Screen.height - _powerupGooGuiArea.height;

            GUI.DrawTexture(_powerupGooGuiArea, _powerupBarBackground);
            GUI.DrawTexture(_powerupBarGuiArea, _powerupBarForeground);
//        }
        
    }

    public float PowerupPercent
    {
        get { return Mathf.Clamp01(_currentPowerups * _fullRecip); }
    }

    public bool PowerupReady { get; private set; }

    public void ExecutePowerup(Player player)
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

        PowerupReady = false;
        _currentPowerups = 0.0f;
        player.AnimateColor(Color.white, 0.5f);
        player.Controller = powerupController;
        powerupController.PowerupEnded += () => {
            player.Controller = originalController;
            player.IsImmortal = false;
            player.rigidbody.isKinematic = false;
            
            player.AnimateColor(Palette.Instance.Orange, 2.5f);
        };
    }

    private void ResetPowerup()
    {
        _currentPowerups = 0.0f;

    }
}
