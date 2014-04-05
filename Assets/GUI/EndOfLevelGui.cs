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
        GUILayout.Label( "You dead", _skin.FindStyle("Header"), GUILayout.ExpandWidth(true), GUILayout.Height(Screen.height * 0.1f));
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        GUILayout.FlexibleSpace();

        GUILayout.BeginHorizontal();

        GUILayout.FlexibleSpace();

        if (GUILayout.Button("Main Menu", GUILayout.Width(Screen.width * .2f), GUILayout.Height(Screen.height * 0.1f)))
        {
            Application.LoadLevel("MainMenu");
        }

        GUILayout.FlexibleSpace();

        if (GUILayout.Button("New Level", GUILayout.Width(Screen.width * .2f), GUILayout.Height(Screen.height * 0.1f)))
        {
            Level.StartRandom();
        }

        GUILayout.FlexibleSpace();

        if (GUILayout.Button("Play Again", GUILayout.Width(Screen.width * .2f), GUILayout.Height(Screen.height * 0.1f)))
        {
            Level.Replay();
        }

        GUILayout.FlexibleSpace();

        GUILayout.EndHorizontal();

        GUILayout.FlexibleSpace();

        GUILayout.EndVertical();

        GUILayout.FlexibleSpace();

        GUILayout.EndHorizontal();

        GUILayout.EndArea();
    }
}
