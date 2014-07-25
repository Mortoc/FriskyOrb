using UnityEngine;
using UnityEditor;

using System.Collections;

using Procedural;

[CustomEditor(typeof(BezierComponent), true)]
public class BezierComponentEditor : Editor 
{
	void OnInspectorGUI() 
	{
		//DrawDefaultInspector();

		if( GUILayout.Button("Update") )
		{
			((BezierComponent)target).UpdateBezier();
		}
	}
}
