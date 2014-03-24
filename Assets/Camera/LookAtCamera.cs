using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class LookAtCamera : MonoBehaviour 
{
	void Update () 
    {
        transform.LookAt(Camera.main.transform);
	}
}
