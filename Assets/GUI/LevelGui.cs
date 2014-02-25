using UnityEngine;
using System.Collections;

public class LevelGui : MonoBehaviour 
{
	private Level _level;
	public GUISkin _skin;

	void Start()
	{
		_level = GetComponent<Level> ();

		if( !_level )
			throw new System.Exception("LevelGui needs to be on the same object as Level");
	}
	void OnGUI()
	{
		GUI.skin = _skin;
		GUILayout.BeginArea (new Rect (0.0f, 0.0f, Screen.width, Screen.height));
		GUILayout.Space (5.0f);
		GUILayout.BeginHorizontal ();
		GUILayout.Space (5.0f);
		if( GUILayout.Button ("Reset", GUILayout.Width(Screen.width * .15f), GUILayout.Height (Screen.height * 0.075f)) )
		{
			Application.LoadLevel(0);
		}

		GUILayout.FlexibleSpace ();

		GUILayout.Label ("Score: " + _level.SegmentCompletedCount, GUILayout.Width(Screen.width * .15f), GUILayout.Height (Screen.height * 0.075f));
		GUILayout.Space (5.0f);
		GUILayout.EndHorizontal ();
		GUILayout.EndArea ();
	}
}
