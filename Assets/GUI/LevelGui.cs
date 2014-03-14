using UnityEngine;
using System.Collections;

public class LevelGui : MonoBehaviour
{
    private Level _level;
    public GUISkin _skin;
    public Player Player { get; set; }
    
    void Start()
    {
        _level = GetComponent<Level>();

        if (!_level)
            throw new System.Exception("LevelGui needs to be on the same object as Level");
    }
    void OnGUI()
    {
        GUI.skin = _skin;
        GUILayout.BeginArea(new Rect(0.0f, 0.0f, Screen.width, Screen.height));
        GUILayout.Space(5.0f);
        GUILayout.BeginHorizontal();
        GUILayout.Space(5.0f);
        if (GUILayout.Button("Reset", GUILayout.Width(Screen.width * .15f), GUILayout.Height(Screen.height * 0.075f)))
        {

            if (!PlayerPrefs.HasKey("best_score") || PlayerPrefs.GetInt("best_score") < _level.SegmentCompletedCount)
            {
                PlayerPrefs.SetInt("best_score", _level.SegmentCompletedCount);
                PlayerPrefs.SetInt("best_score_level_seed", _level.Seed);
            }
            Application.LoadLevel("MainMenu");
        }

        GUILayout.FlexibleSpace();

        GUILayout.Label("Score: " + _level.SegmentCompletedCount, GUILayout.Width(Screen.width * .15f), GUILayout.Height(Screen.height * 0.075f));
        GUILayout.Space(5.0f);
        GUILayout.EndHorizontal();
        GUILayout.EndArea();

        DrawPowerupBar();
    }

    private void DrawPowerupBar()
    {
        float height = 0.25f;
        float powerupPercent = Player.PowerupPercent;
        GUILayout.BeginArea(new Rect(0.0f, 0.0f, Screen.width, Screen.height));
        GUILayout.FlexibleSpace();
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();

        GUILayout.Label("", GUI.skin.GetStyle("Powerup Bar Background"), GUILayout.Width(Screen.width * 0.05f), GUILayout.Height(Screen.height * height));

        GUILayout.EndHorizontal();
        GUILayout.FlexibleSpace();
        GUILayout.EndArea();

        GUILayout.BeginArea(new Rect(0.0f, 0.0f, Screen.width, Screen.height));
        GUILayout.FlexibleSpace();
        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();

        GUILayout.Label("", GUI.skin.GetStyle("Powerup Bar"), GUILayout.Width(Screen.width * 0.05f), GUILayout.Height(Screen.height * height * powerupPercent));

        GUILayout.EndHorizontal();
        GUILayout.FlexibleSpace();
        GUILayout.EndArea();
    }
}
