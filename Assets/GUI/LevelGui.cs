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
        GUILayout.Space(Screen.height * 0.015f);
        GUILayout.BeginHorizontal();
       
        GUILayout.FlexibleSpace();

        GUILayout.Label
        (
            string.Format("Score: {0:n0}", Score.Instance.ScoreDisplayValue), 
            GUILayout.Width(Screen.width * .15f), 
            GUILayout.Height(Screen.height * 0.075f)
        );

        GUILayout.Space(5.0f);
        GUILayout.EndHorizontal();
        GUILayout.EndArea();
    }
}
