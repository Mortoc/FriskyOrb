using UnityEngine;

using System.Collections.Generic;

public class SmoothedVector
{
	private struct Sample
	{
		public Vector3 Position { get; set; }
		public float Time { get; set; }
	}

	private float _interval;
	private List<Sample> _samples;

	public SmoothedVector (float interval)
	{
		// Initialize the list to our best guess for the number of samples
		_samples = new List<Sample>();
		_interval = interval;
	}

	public void AddSample(Vector3 position)
	{
		_samples.Add (new Sample (){ Position = position, Time = Time.time });

		float sampleTimeout = Time.time - _interval;
		for(; _samples[0].Time < sampleTimeout;)
		{
			_samples.RemoveAt(0);
		}
	}

	public Vector3 GetSmoothedPosition()
	{
		float recpCount = 1.0f / (float)_samples.Count;
		Vector3 avg = Vector3.zero;
		foreach(Sample sample in _samples)
			avg += sample.Position;

		return avg * recpCount;
	}
}

