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
// 2013-12-17, 1.2.0 - Added user opt-out from analytics toggle.

using UnityEngine;
using System.Collections;

public class AnalyticsExampleSecondaryScreen : MonoBehaviour
{
    void OnGUI()
    {
        GUILayout.BeginVertical();
        GUILayout.Label(" Current scene: " + Application.loadedLevelName);
        GUILayout.Label(" ");
        GUILayout.Label(" This scene demonstrates automatic screen switch\n" +
                        " events sent by the analytics example, and is an\n" +
                        " example of options screen allowing user to\n" +
                        " opt-out from analytics.");
        GUILayout.Label(" ");

        GUILayout.Label(" This app sends anonymous usage statistics over internet.");
        bool disableAnalyticsByUserOptOut = Analytics.gua.analyticsDisabled;
        bool newValue = GUILayout.Toggle(disableAnalyticsByUserOptOut, "Opt-out from anonymous statistics.");
        if (disableAnalyticsByUserOptOut != newValue)
            Analytics.setPlayerPref_disableAnalyticsByUserOptOut(newValue);

        GUILayout.Label(disableAnalyticsByUserOptOut ? " :-(\n" : " \n");

        if (GUILayout.Button("Back to Main"))
            Application.LoadLevel("AnalyticsExample");
        GUILayout.EndVertical();
    }
}
