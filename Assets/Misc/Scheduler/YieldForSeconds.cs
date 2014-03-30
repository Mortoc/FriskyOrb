using UnityEngine;

using System;
using System.Collections.Generic;

public class YieldForSeconds : IUpdateYield
{
	private readonly float _timeComplete;
	public float TimeComplete
	{
		get { return _timeComplete; }
	}

	public YieldForSeconds (float seconds)
	{
		_timeComplete = Time.time + seconds;
	}
	
	public bool Ready
	{
		get 
		{
			return Time.time >= _timeComplete;
		}
	}

}

