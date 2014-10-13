using UnityEngine;
using System.Collections;
using System.Text.RegularExpressions;

public class LODManager : MonoBehaviour 
{

    private Regex _getAndroidAPIRegex = new Regex("API-([0-9]+)");

	public GUISkin _skin;
	public bool _showFPS;
	public float _fpsUpdateRate = 1.0f;
	private float _fps = 0.0f;
	private float _lastFpsSampleTime = 0.0f;


	
	void Awake() 
    {
        switch (Application.platform)
        {
            case RuntimePlatform.Android:
                ApplyAndriodSettings();
                break;
            case RuntimePlatform.IPhonePlayer:
                ApplyIOSSettings();
                break;
            case RuntimePlatform.WP8Player:
                ApplyWindowsPhoneSettings();
                break;
            default:
                ApplyHighQualitySettings();
                break;
        }
	}

	void OnGUI()
	{
		if( _showFPS ) 
		{
			GUI.skin = _skin;
			if( _fpsUpdateRate + _lastFpsSampleTime < Time.time )
			{
				_fps = 1.0f / Time.smoothDeltaTime;
				_lastFpsSampleTime = Time.time;
			}

			GUILayout.Space (Screen.height * 0.9f);
			GUILayout.BeginHorizontal();
			GUILayout.Space (Screen.width * 0.01f);
			GUILayout.Label (_fps.ToString("f1"), GUILayout.Width(Screen.width * 0.99f));
			GUILayout.EndHorizontal();
		}
	}

    private void ApplyHighQualitySettings()
    {
		// Disabled until the portrait mode glow bug is fixed
        //_glow.enabled = true;
    }

    private void ApplyLowQualitySettings()
    {
		HalfRenderResolution();
    }

	private void HalfRenderResolution()
	{
		Screen.SetResolution(
			Screen.width / 2, 
			Screen.height / 2, 
			Screen.fullScreen
		);
	}

    private void ApplyAndriodSettings()
    {
        Match m = _getAndroidAPIRegex.Match(SystemInfo.operatingSystem);
        int apiNum = System.Convert.ToInt32(m.Groups[1].Value);

        if( apiNum < 16 )
        {
            ApplyLowQualitySettings();
        }
        else
        {
            ApplyHighQualitySettings();

			// Damn you super high-res android phones!
//			if( Screen.width > 1080 || Screen.height > 1080)
//				HalfRenderResolution();
        }
    }

    private void ApplyIOSSettings()
    {
#if UNITY_IPHONE
        switch(iPhone.generation)
        {
            case iPhoneGeneration.iPad1Gen:
            case iPhoneGeneration.iPadUnknown:
            case iPhoneGeneration.iPhone3G:
            case iPhoneGeneration.iPhone3GS:
            case iPhoneGeneration.iPhoneUnknown:
            case iPhoneGeneration.iPodTouch1Gen:
            case iPhoneGeneration.iPodTouch2Gen:
            case iPhoneGeneration.iPodTouchUnknown:
            case iPhoneGeneration.Unknown:
                ApplyLowQualitySettings();
                break;
            default:
                ApplyHighQualitySettings();
                break;
        }
#endif
    }

    private void ApplyWindowsPhoneSettings()
    {
        ApplyHighQualitySettings();
    }
}
