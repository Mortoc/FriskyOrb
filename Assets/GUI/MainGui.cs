using UnityEngine;
using System;
using System.Text;

public class MainGui : MonoBehaviour
{
    private string EncodeLevelSeedToName(int seed)
    {
        string str = seed.ToString();
        byte[] bytes = new byte[str.Length * sizeof(char)];
        System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
        return Convert.ToBase64String(bytes).Substring(0, 8);
    }

    private string _personalBest = null;
    void Start()
    {
        if (PlayerPrefs.HasKey("best_score"))
            _personalBest = "Your Best " + PlayerPrefs.GetInt("best_score") + " : " + 
                EncodeLevelSeedToName( PlayerPrefs.GetInt("best_score_level_seed") );
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
            if (GUILayout.Button(_personalBest, GUILayout.Width(buttonWidth), GUILayout.Height(buttonHeight)))
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
