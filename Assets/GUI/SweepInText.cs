using UnityEngine;
using System.Collections;

public class SweepInText : MonoBehaviour
{
    public GUISkin _skin;
    public string text { get; set; }
    public float _sweepInTime = 0.2f;
    public float _sweepOutTime = 0.2f;
    public float _displayTime = 3.0f;

    private float _offset;
    private bool _showing = false;

    public void Display()
    {
        StopAllCoroutines();
        StartCoroutine(DisplayTextCoroutine());
    }

    private IEnumerator DisplayTextCoroutine()
    {
        _showing = true;
        float recipSweepInTime = 1.0f / _sweepInTime;
        float recipSweepOutTime = 1.0f / _sweepOutTime;
        _offset = Screen.width * -1.0f;

        for (float time = 0.0f; time < _sweepInTime; time += Time.deltaTime)
        {
            yield return 0;
            float t = MathExt.Berp(1.0f, 0.0f, time * recipSweepInTime);
            _offset = Screen.width * -1.0f * t;
        }

        _offset = 0.0f;
        yield return new WaitForSeconds(_displayTime);

        for (float time = 0.0f; time < _sweepOutTime; time += Time.deltaTime)
        {
            yield return 0;
            float t = Mathf.SmoothStep(0.0f, 1.0f, time * recipSweepOutTime);
            _offset = Screen.width * t;
        }

        _offset = Screen.width;
        _showing = false;
    }

    void OnGUI()
    {
        if (_showing)
        {
            GUI.skin = _skin;
            Color originalColor = GUI.color;

            GUILayout.BeginArea(new Rect(_offset, 0.0f, Screen.width, Screen.height));
            GUILayout.FlexibleSpace();

            GUILayout.BeginHorizontal();
            GUILayout.FlexibleSpace();

            GUILayout.BeginVertical();
            GUILayout.Label("Attempting Track:", GUI.skin.FindStyle("YouDeadMessage"));
            GUILayout.Label(text, GUI.skin.FindStyle("YouDeadMessage"));
            GUILayout.EndVertical();

            GUILayout.FlexibleSpace();
            GUILayout.EndHorizontal();

            GUILayout.FlexibleSpace();
            GUILayout.FlexibleSpace();
            GUILayout.EndArea();

            GUI.color = originalColor;
        }
    }
}
