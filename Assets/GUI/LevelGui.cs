using UnityEngine;
using System.Collections;

public class LevelGui : MonoBehaviour
{
    public GUISkin _skin;
    private GUISkin _scaledSkin;
    private GUISkin _originalSkin;
    private string _levelName;
    public Player Player { get; set; }
    
    void Start()
    {
        _originalSkin = Instantiate(_skin) as GUISkin;
        _scaledSkin = Instantiate(_skin) as GUISkin;
        _levelName = FindObjectOfType<Level>().Name;
        SetupFontSizes();
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
    
    private float _levelNameDisplayTime = 5.0f;
        
    private void DrawLevelName()
    {
        Color originalColor = GUI.color;
        if (Time.timeSinceLevelLoad > _levelNameDisplayTime * 0.8f)
        {
            float t = (Time.time - (_levelNameDisplayTime * 0.8f)) * 5.0f;
            GUI.color = Color.Lerp(originalColor, new Color(0.0f, 0.0f, 0.0f, 0.0f), t);
        }

        GUILayout.BeginArea(new Rect(0.0f, 0.0f, Screen.width, Screen.height));
        GUILayout.FlexibleSpace();

        GUILayout.BeginHorizontal();
        GUILayout.FlexibleSpace();

        GUILayout.BeginVertical();
        GUILayout.Label("Attempting Track:", GUI.skin.FindStyle("YouDeadMessage"));
        GUILayout.Label(_levelName, GUI.skin.FindStyle("YouDeadMessage"));
        GUILayout.EndVertical();

        GUILayout.FlexibleSpace();
        GUILayout.EndHorizontal();

        GUILayout.FlexibleSpace();
        GUILayout.FlexibleSpace();
        GUILayout.EndArea();

        GUI.color = originalColor;
    }


    void OnGUI()
    {
        SetupFontSizes();

        GUI.skin = _scaledSkin;

        if (Time.timeSinceLevelLoad < _levelNameDisplayTime)
        {
            DrawLevelName();
        }

        Rect screenRect = new Rect(0.0f, 0.0f, Screen.width, Screen.height);
        float edgeMargin = Screen.height * 0.02f;
        float pauseButtonSize = Screen.height * 0.15f;
        float scoreButtonHeight = Screen.height * 0.2f;
        float scoreButtonWidth = scoreButtonHeight * 512.0f / 242.0f;

        GUILayout.BeginArea(screenRect);
        
        GUILayout.Space(edgeMargin);
        GUILayout.BeginHorizontal();
        GUILayout.Space(edgeMargin);

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
        int score = Score.Instance.ScoreDisplayValue;
        
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
