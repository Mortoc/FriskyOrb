using UnityEngine;
using System.Collections;

using RtInfinity.Levels;

public class LevelGui : MonoBehaviour
{
    public GUISkin _skin;
    private GUISkin _scaledSkin;
    private GUISkin _originalSkin;
    private string _levelName;
    public Player Player { get; set; }
    public SweepInText _sweepInText;
    
    IEnumerator Start()
    {
        _originalSkin = Instantiate(_skin) as GUISkin;
        _scaledSkin = Instantiate(_skin) as GUISkin;
        _levelName = FindObjectOfType<Level>().Name;
        SetupFontSizes();

        _sweepInText.text = _levelName;

        yield return new WaitForSeconds(0.5f);
        _sweepInText.Display();
    }


    private float _cachedFontBasis = 0.0f;
    private void SetupFontSizes()
    {
        if( !Mathf.Approximately(_cachedFontBasis, Screen.height) )
        {
            // All the fonts were set up with a screen size of ~640px
            // Scale to the currentScreenSize
            float scale = Screen.height / 640.0f;
            
            IEnumerator skinEnumerator = _scaledSkin.GetEnumerator();
            foreach(GUIStyle originalStyle in _originalSkin)
            {
                skinEnumerator.MoveNext();
                GUIStyle newStyle = skinEnumerator.Current as GUIStyle;

                newStyle.fontSize = Mathf.FloorToInt((float)originalStyle.fontSize * scale);
            }

            _cachedFontBasis = Screen.height;
        }
    }


    void OnGUI()
    {
        SetupFontSizes();

        GUI.skin = _scaledSkin;

        Rect screenRect = new Rect(0.0f, 0.0f, Screen.width, Screen.height);

        float pauseButtonSize = Screen.height * 0.1f;
        float scoreButtonHeight = Screen.height * 0.125f;
        float scoreButtonWidth = scoreButtonHeight * 512.0f / 242.0f;

        GUILayout.BeginArea(screenRect);
        
        GUILayout.BeginHorizontal();

        // Can only pause when player is alive
        if (Player && GUILayout.Button(
            "", 
            _skin.FindStyle("PauseButton"), 
            GUILayout.Width(pauseButtonSize), 
            GUILayout.Height(pauseButtonSize)
            )) 
        {
            if( Time.timeScale < 0.0001f )
            {
                Time.timeScale = 1.0f;
            }
            else
            {
                Time.timeScale = 0.0f;
            }
        }

        GUILayout.EndHorizontal();
        GUILayout.EndArea();


        GUILayout.BeginArea
        (
            new Rect
            (
                Screen.width - scoreButtonWidth,
                0.0f,
                scoreButtonWidth,
                scoreButtonHeight
            ),
            GUI.skin.FindStyle("ScoreBackground")
        );
        
        GUILayout.Space(scoreButtonHeight * 0.2f);

        GUILayout.BeginHorizontal();
        GUILayout.Space(scoreButtonWidth * 0.3f);
        
        GUILayout.BeginVertical();
        GUILayout.Space(scoreButtonHeight * 0.05f);
        GUILayout.Label("Score", GUI.skin.FindStyle("ScoreLabel"));
        GUILayout.EndHorizontal();

        GUILayout.Space(scoreButtonWidth * 0.05f);
        DrawScore(scoreButtonWidth);
        GUILayout.Space(scoreButtonWidth * 0.0275f);
        GUILayout.EndHorizontal();

        GUILayout.EndArea();
    }

    private void DrawScore(float scoreButtonWidth)
    {
        int score = (int)Score.Instance.ScoreDisplayValue;
        
        if (score > 9999)
            score = 9999;

        string thousands = string.Format("{0:n0}", score / 1000);
        score = score % 1000;

        string hundreds = string.Format("{0:n0}", score / 100);
        score = score % 100;

        string tens = string.Format("{0:n0}", score / 10);
        score = score % 10;

        string ones = string.Format("{0:n0}", score );

        float space = scoreButtonWidth * 0.025f;
        GUIStyle scoreStyle = GUI.skin.FindStyle("ScoreValue");
        GUILayout.Label(thousands, scoreStyle);
        GUILayout.Space(space);
        GUILayout.Label(hundreds, scoreStyle);
        GUILayout.Space(space);
        GUILayout.Label(tens, scoreStyle);
        GUILayout.Space(space);
        GUILayout.Label(ones, scoreStyle);
    }
}
