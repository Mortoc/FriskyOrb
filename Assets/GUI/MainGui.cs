using UnityEngine;
using System;
using System.Text;

public class MainGui : MonoBehaviour
{
    public ParticleSystem _particles;
    private string _personalBest = null;
    private string _personalBestLevel = null;
    void Start()
    {
        if (PlayerPrefs.HasKey("best_score"))
        {
            var levelNameManager = GetComponent<LevelNameManager>();
            levelNameManager.ParseNames();

            var seed = Math.Abs(PlayerPrefs.GetInt("best_score_level_seed") % levelNameManager.NameCount);
            _personalBest = String.Format
            (
                "{0:n0}", 
                PlayerPrefs.GetInt("best_score")
            );
            _personalBestLevel = String.Format("\"{0}\"", levelNameManager.GetName(seed));
        }
    }

    private SmoothedVector _particleUp = new SmoothedVector(1.0f);
    void Update()
    {
        if( Input.acceleration.sqrMagnitude > Mathf.Epsilon )
        {
            _particleUp.AddSample(Input.acceleration);
            _particles.transform.up = _particleUp.GetSmoothedVector();
        }
    }

    public GUISkin _skin;
    void OnGUI()
    {
        GUI.skin = _skin;
        
        GUILayout.BeginArea(new Rect(0.0f, 0.0f, Screen.width, Screen.height));

		GUILayout.BeginVertical();
		GUILayout.Space (Screen.height * 0.1f);

		GUILayout.BeginHorizontal();
		GUILayout.FlexibleSpace();
        
        float newLevelButtonHeight = Screen.height * 0.2f;
        float newLevelButtonWidth = newLevelButtonHeight * 512.0f / 304.0f;

        if (GUILayout.Button("", GUI.skin.FindStyle("NewLevelButton"), GUILayout.Width(newLevelButtonWidth), GUILayout.Height(newLevelButtonHeight)))
        {

            Analytics.gua.sendEventHit("MainManu", "PressedNewLevelButton");
            Level.StartRandom();
        }

        GUILayout.Space(Screen.width * 0.05f);

        GUILayout.EndHorizontal();

        GUILayout.FlexibleSpace();
        GUILayout.FlexibleSpace();
        GUILayout.EndVertical();

        GUILayout.FlexibleSpace();
        GUILayout.EndArea();

        if (!String.IsNullOrEmpty(_personalBest))
        {
            GUILayout.BeginArea(new Rect(Screen.width * 0.05f, Screen.height * 0.5f, Screen.width * 0.9f, Screen.height * 0.65f), GUI.skin.box);

            float replayButtonHeight = Screen.height * 0.15f;
            float replayButtonWidth = replayButtonHeight * 512.0f / 266.0f;

            GUILayout.BeginHorizontal();

            GUILayout.BeginVertical();
            GUILayout.FlexibleSpace();
            GUILayout.BeginHorizontal();
            GUILayout.Label("Your Best Score:", GUI.skin.FindStyle("YourBestLabel"));
            GUILayout.Space(Screen.width * 0.01f);
            GUILayout.Label(_personalBest, GUI.skin.FindStyle("YourBestData"));
            GUILayout.EndHorizontal();

            GUILayout.FlexibleSpace();

            GUILayout.Label(_personalBestLevel, GUI.skin.FindStyle("YourBestData"), GUILayout.Width(Screen.width * 0.1f));

            GUILayout.FlexibleSpace();
			GUILayout.BeginHorizontal();
			GUILayout.FlexibleSpace();
            if (GUILayout.Button("", GUI.skin.FindStyle("ReplayButton"), GUILayout.Width(replayButtonWidth), GUILayout.Height(replayButtonHeight)))
            {
                Analytics.gua.sendEventHit("MainManu", "ReplayedBestLevel", "LevelSeed", PlayerPrefs.GetInt("best_score_level_seed"));
                Level.Start(PlayerPrefs.GetInt("best_score_level_seed"));
            }
			
			GUILayout.FlexibleSpace();
			GUILayout.EndHorizontal();
            GUILayout.FlexibleSpace();
            GUILayout.EndVertical();

            GUILayout.EndHorizontal();
            GUILayout.Space(Screen.height * 0.05f);
            GUILayout.EndArea();
        }

    }
}
