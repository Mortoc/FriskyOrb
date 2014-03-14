using UnityEngine;
using System.Collections;

public class MainGui : MonoBehaviour
{
    private void StartLevel(int seed)
    {
        Application.LoadLevel("FriskyOrb");
    }

    public GUISkin _skin;
    void OnGUI()
    {
        GUI.skin = _skin;
        GUILayout.BeginArea(new Rect(0.0f, 0.0f, Screen.width, Screen.height));
        GUILayout.Space(10.0f);
        GUILayout.BeginHorizontal();
        GUILayout.Space(10.0f);
        GUILayout.Label("FriskyFuckingOrb", _skin.FindStyle("Header"));
        GUILayout.FlexibleSpace();

        GUILayout.FlexibleSpace();

        GUILayout.BeginVertical();
        GUILayout.FlexibleSpace();
        float buttonWidth = Screen.width / 3.0f;
        float buttonHeight = Screen.height * 0.1f;
        if (GUILayout.Button("New Track", GUILayout.Width(buttonWidth), GUILayout.Height(buttonHeight)))
        {
            StartLevel(Random.Range(int.MinValue, int.MaxValue));
        }

        GUILayout.FlexibleSpace();

        if( PlayerPrefs.HasKey("best_score") )
        {
            if (GUILayout.Button("Your Best " + PlayerPrefs.GetInt("best_score"), GUILayout.Width(buttonWidth), GUILayout.Height(buttonHeight)))
            {
                StartLevel(PlayerPrefs.GetInt("best_score_level_seed"));
            }
        }
        GUILayout.FlexibleSpace();
        GUILayout.EndVertical();
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
        GUILayout.EndArea();
    }
}
