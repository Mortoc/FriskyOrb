using UnityEngine;
using System.Collections;
using System.Text.RegularExpressions;

public class LODManager : MonoBehaviour 
{
    [SerializeField]
    private Glow11.Glow11 _glow;

    private Regex _getAndroidAPIRegex = new Regex("API-([0-9]+)");
	
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

    private void ApplyHighQualitySettings()
    {
		// Disabled until the portrait mode glow bug is fixed
        //_glow.enabled = true;
    }

    private void ApplyLowQualitySettings()
    {
        _glow.enabled = false;
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
