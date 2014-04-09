using UnityEngine;
using System;
using System.Text;

public class MainGui : MonoBehaviour
{
    private string _personalBest = null;
    void Start()
    {
        if (PlayerPrefs.HasKey("best_score"))
        {
            var levelNameManager = GetComponent<LevelNameManager>();
            levelNameManager.ParseNames();

            var seed = Math.Abs(PlayerPrefs.GetInt("best_score_level_seed") % levelNameManager.NameCount);
            _personalBest = String.Format
            (
                "Your Best {0:n0}:\n\"{1}\"", 
                PlayerPrefs.GetInt("best_score"), 
                levelNameManager.GetName(seed)
            );
        }
    }
    
    public GUISkin _skin;
    void OnGUI()
    {
        GUI.skin = _skin;
        GUILayout.BeginArea(new Rect(0.0f, 0.0f, Screen.width, Screen.height));
        GUILayout.Space(10.0f);
        GUILayout.BeginHorizontal();
        GUILayout.Space(10.0f);
        GUILayout.Label("STARBOMB", _skin.FindStyle("Header"));
        GUILayout.FlexibleSpace();

        GUILayout.FlexibleSpace();

        GUILayout.BeginVertical();
        GUILayout.FlexibleSpace();
        float buttonWidth = Screen.width / 3.0f;
        float buttonHeight = Screen.height * 0.1f;
        if (GUILayout.Button("New Track", GUILayout.Width(buttonWidth), GUILayout.Height(buttonHeight)))
        {
            Level.StartRandom();
        }

        GUILayout.FlexibleSpace();

        if( !String.IsNullOrEmpty(_personalBest) )
        {
            GUILayout.Label(_personalBest);
            if (GUILayout.Button("Replay", GUILayout.Width(buttonWidth), GUILayout.Height(buttonHeight)))
            {
                Level.Start(PlayerPrefs.GetInt("best_score_level_seed"));
            }
        }
        GUILayout.FlexibleSpace();
        GUILayout.EndVertical();
        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();
        GUILayout.EndArea();
    }
}
