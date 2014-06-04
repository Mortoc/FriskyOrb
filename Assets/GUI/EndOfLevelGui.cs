using UnityEngine;
using System;


public class EndOfLevelGui : MonoBehaviour
{
    public GUISkin _skin;

    void OnGUI()
    {
        GUI.skin = _skin;

        GUILayout.BeginArea(new Rect(0.0f, 0.0f, Screen.width, Screen.height));

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();

        GUILayout.BeginVertical();
        GUILayout.FlexibleSpace();

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        GUILayout.Label( "You dead", GUI.skin.FindStyle("YouDeadMessage"), GUILayout.ExpandWidth(true), GUILayout.Height(Screen.height * 0.1f));
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        GUILayout.FlexibleSpace();

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();
        float newLevelButtonHeight = Screen.height * 0.15f;
        float newLevelButtonWidth = newLevelButtonHeight * 512.0f / 304.0f;
        if (GUILayout.Button("", GUI.skin.FindStyle("NewLevelButton"), GUILayout.Width(newLevelButtonWidth), GUILayout.Height(newLevelButtonHeight)))
		{
            if (Analytics.gua != null)
				Analytics.gua.sendEventHit("ReplayingLevel", "NewLevel", "Score", (int)Score.Instance.ActualScore);
			
			Level.StartRandom();
		
        }
        GUILayout.FlexibleSpace();

        GUILayout.BeginVertical();
        GUILayout.Space(Screen.height * 0.0255f);
        float replayButtonHeight = Screen.height * 0.115f;
        float replayButtonWidth = replayButtonHeight * 512.0f / 266.0f;
        if (GUILayout.Button("", GUI.skin.FindStyle("ReplayButton"), GUILayout.Width(replayButtonWidth), GUILayout.Height(replayButtonHeight)))
        {
            if( Analytics.gua != null )
            	Analytics.gua.sendEventHit("ReplayingLevel", "SameLevel", "Score", (int)Score.Instance.ActualScore);
			
        	Level.Replay();
        }
        GUILayout.EndVertical();

        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
        GUILayout.FlexibleSpace();
        GUILayout.EndVertical();
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
        GUILayout.EndArea();
    }
}
