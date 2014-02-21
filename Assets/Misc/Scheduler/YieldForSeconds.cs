using UnityEngine;

using System;
using System.Collections.Generic;

public class YieldForSeconds : IYieldInstruction
{
	private readonly float mTimeComplete;
	public float TimeComplete
	{
		get { return mTimeComplete; }
	}

	public YieldForSeconds (float seconds)
	{
		mTimeComplete = Time.time + seconds;
	}
	
	public bool Ready
	{
		get 
		{
			return Time.time >= mTimeComplete;
		}
	}

}

