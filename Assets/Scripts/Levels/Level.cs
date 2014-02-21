using UnityEngine;
using System.Collections.Generic;

public class Level : MonoBehaviour 
{
    [SerializeField]
	private int _viewDistance = 3;

    [SerializeField]
    private Material _levelTrackMaterial;

    private List<LevelSegment> _segments;

	
	void Awake()
	{
        _segments = new List<LevelSegment>(_viewDistance);
		GenerateInitialLevel(1234567890);
	}

    private void GenerateInitialLevel(int seed)
	{
		MersenneTwister rand = new MersenneTwister(seed);

		
	}

}
