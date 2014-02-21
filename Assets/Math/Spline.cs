using UnityEngine;


// 3D Cubic B-Spline
public class Spline
{
	public class Segment
	{
		public Transform A, A_CP, B, B_CP;

		public Vector3 GetPoint(float t)
		{
			float b = Mathf.Clamp01(t);
			float a = 1.0f - t;

			float a2 = a * a;
			float a3 = a2 * a;
			float b2 = b * b;
			float b3 = b2 * b;

			return A.position * a3 +
				   A_CP.position * 3.0f * a2 * b + 
				   B_CP.position * 3.0f * a * b2 +
				   B.position * b3;
		}

		public Vector3 GetNormal(float t)
		{
			float epsilon = 0.01f;
			float tPe = t + epsilon;
			if( tPe > 1.0f )
			{
				t = 1.0f - epsilon;
				tPe = 1.0f;
			}

			Vector3 forward = GetPoint(tPe) - GetPoint(t);
			return Vector3.Cross(Vector3.up, forward).normalized;
		}

		// Samples a few line segments across the spline and finds the closest point
		// in them.
		public float GetApproxT(Vector3 position, int resolution = 15)
		{
			Vector3 prevSample = GetPoint(0.0f);
			float bestMatch = 0.0f;
			float bestMatchMagSqr = (position - prevSample).sqrMagnitude;
			float step = 1.0f / (float)resolution;
			bool done = false;
			for(float t = step; !done; t += step)
			{
				if( t >= 1.0f )
				{
					// Make sure the last sample is at 1.0 to avoid gaps
					t = 1.0f;
					done = true;
				}

				Vector3 sample = GetPoint(t);
				Vector3 projection = MathExt.ProjectPointOnLineSegment(prevSample, sample, position);
				float thisMatchMagSqr = (position - projection).sqrMagnitude;
				if( thisMatchMagSqr < bestMatchMagSqr )
				{
					bestMatchMagSqr = thisMatchMagSqr;

					// Found a new best match, calculate the intermediate t value
					float sampleDist = (sample - prevSample).magnitude;
					float projectionDist = (sample - projection).magnitude;
					bestMatch = Mathf.Lerp(t, t - step, projectionDist / sampleDist);
				}

				prevSample = sample;
			}

			return bestMatch;
		}
	}
}
