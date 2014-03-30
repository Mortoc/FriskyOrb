using UnityEngine;
using System.Collections;

public class Spin : MonoBehaviour 
{
    public Vector3 axis = Vector3.up;
    public float speed = 180.0f;

    void Start()
    {
        axis = axis.normalized;
    }

	void Update () 
    {
        transform.Rotate(axis * speed * Time.deltaTime);
	}
}
