// Usage example of Google Universal Analytics.
//
// Copyright 2013 Jetro Lauha (Strobotnik Ltd)
// http://strobotnik.com
// http://jet.ro
//
// $Revision: 392 $
//
// File version history:
// 2013-09-01, 1.1.1 - Initial version
// 2013-09-25, 1.1.3 - Unity 3.5 support.
// 2013-12-17, 1.2.0 - Added warning for missing Analytics object and check
//                     for Analytics.gua.analyticsDisabled in custom Quit hit.

using UnityEngine;
using System.Collections;

public class AnalyticsExampleMainScreen : MonoBehaviour
{
    void OnGUI()
    {
        if (Analytics.Instance == null)
        {
            GUILayout.BeginVertical();
            GUILayout.Label(" ERROR! No Analytics object in scene!");
            GUILayout.Label(" Add Analytics script to an active game object.");
            GUILayout.EndVertical();
            return;
        }

        GUILayout.BeginHorizontal();
        GUILayout.Label("v");
        GUILayout.Label(Analytics.Instance.appVersion);

        GUILayout.BeginVertical();
        GUILayout.Label("- Google Universal Analytics for Unity");
        GUILayout.Label(" Current scene: " + Application.loadedLevelName);

        // Possibility to switch between scenes demonstrates the
        // automatic screen events sent by Analytics.OnLevelWasLoaded().
        //
        // For this test you need to add both AnalyticsExample and
        // AnalyticsExampleSecondaryScene scenes to the project
        // using File->Build Settings.
        //
        if (GUILayout.Button("Go to Secondary Scene (Opt-out menu)"))
            Application.LoadLevel("AnalyticsExampleSecondaryScene");

        GUILayout.Label("Imaginary hits to switch menu screens:");
        if (GUILayout.Button("Send \"Menuscreen A\" Hit"))
            Analytics.changeScreen("AnalyticsExample - Menuscreen A");
        if (GUILayout.Button("Send \"Menuscreen B\" Hit"))
            Analytics.changeScreen("AnalyticsExample - Menuscreen B");


        GUILayout.Label("Web Links:");
        // This is just an inspirational example. In reality you should
        // integrate official social SDKs and probably send the "Like"
        // type of analytics hit only when user actually does that
        // inside your application.
        if (GUILayout.Button("Strobotnik in Google+"))
        {
            Analytics.gua.sendSocialHit("GooglePlus", "plus", "StrobotnikGooglePlus");
            Application.OpenURL("http://plus.google.com/101873213646861422131");
        }
        if (GUILayout.Button("Strobotnik in Facebook"))
        {
            Analytics.gua.sendSocialHit("Facebook", "like", "StrobotnikFacebook");
            Application.OpenURL("http://facebook.com/strobotnik");
        }
        if (GUILayout.Button("Strobotnik in Twitter"))
        {
            Analytics.gua.sendSocialHit("Twitter", "follow", "StrobotnikTwitter");
            Application.OpenURL("http://twitter.com/strobotnik");
        }
        if (GUILayout.Button("Strobotnik Web Site"))
        {
            Analytics.gua.sendEventHit("OpenWebsite", "Strobotnik.com");
            Application.OpenURL("http://strobotnik.com");
        }

        GUILayout.Label("---");

        if (GUILayout.Button("Quit"))
        {
            // End session with custom built hit:
            if (!Analytics.gua.analyticsDisabled)
            {
                Analytics.gua.beginHit(GoogleUniversalAnalytics.HitType.Appview);
                Analytics.gua.addContentDescription("AnalyticsExample - Quit");
                Analytics.gua.addSessionControl(false); // end current session
                Analytics.gua.sendHit();
            }
            #if UNITY_3_5
            gameObject.active = false;
            #else
            gameObject.SetActive(false);
            #endif
            Application.Quit();
        }

        string networkReachability = "Network Reachability: none";
        if (Application.internetReachability == NetworkReachability.ReachableViaCarrierDataNetwork)
            networkReachability = "Network Reachability: via carrier data network";
        else if (Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork)
            networkReachability = "Network Reachability: via local area network";
        GUILayout.Label(networkReachability);

        GUILayout.EndVertical();
        GUILayout.EndHorizontal();
    }
}
