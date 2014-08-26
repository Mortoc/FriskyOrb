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
        _currentPowerups = _powerupsUntilFull;
    }

    public void CollectedPowerup()
    {
        if( _currentPowerups <= _powerupsUntilFull )
        {
            _currentPowerups += 1.0f;
        }
    }

    public bool HealthFull()
    {
        return _currentPowerups >= _powerupsUntilFull;
    }

    public void TakeDamage(float damage)
    {
        _currentPowerups -= damage;
        
        var player = FindObjectOfType<Player>();
        player.AnimateColor(Color.red, 0.25f, true);

        if(_currentPowerups <= 0.0f) 
        {
            _currentPowerups = 0.0f;

            player.PlayerDied();

            Destroy(gameObject);
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

    private void ResetPowerup()
    {
        _currentPowerups = 0.0f;

    }
}
