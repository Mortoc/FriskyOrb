using UnityEngine;
using System.Collections;

public class TestGraphicsController : MonoBehaviour 
{
    private float[] _fpsSamples = new float[10];
    private float _fps = 30.0f;

    public float _cameraMotion = 1.0f;
    private SmoothedVector _cameraOffsetGoal = new SmoothedVector(2.0f);

    void Start()
    {
        var startingFramerate = 1.0f / Time.deltaTime;
        for(int i = 0; i < _fpsSamples.Length; ++i)
        {
            _fpsSamples[i] = startingFramerate;
        }
    }

    void Update()
    {
        for(int i = 0; i < _fpsSamples.Length - 1; ++i)
        {
            _fpsSamples[i + 1] = _fpsSamples[i];
        }
        _fpsSamples[0] = 1.0f / Time.deltaTime;

        _fps = MathExt.Average(_fpsSamples);

        _cameraOffsetGoal.AddSample(_cameraMotion * Random.onUnitSphere * Time.deltaTime);

        if (Time.time > 2.0f )
            transform.position += _cameraOffsetGoal.GetSmoothedVector();
    }

    void OnGUI()
    {
        GUI.color = Color.white;
        GUILayout.Space(4.0f);
        GUILayout.BeginHorizontal();
        GUILayout.Space(4.0f);
        GUILayout.Label(_fps.ToString("f1") + " fps");
        GUILayout.EndHorizontal();
    }
}
