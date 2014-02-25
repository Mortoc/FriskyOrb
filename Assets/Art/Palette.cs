using UnityEngine;
using System.Collections;

public class Palette : MonoBehaviour 
{
	public static Palette Instance { get; private set; }

	public Color Background;
	public Color DarkBlue;
	public Color Pink;
	public Color Orange;
	public Color Yellow;
	public Color Green;
	public Color Blue;

	void Awake()
	{
		Instance = this;
	}
}
