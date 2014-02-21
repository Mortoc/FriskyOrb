using UnityEngine;


// 3D Cubic B-Spline
public class Spline
{
	public class Segment
	{
		public Transform A, A_CP, B, B_CP;

		public Vector3 GetPoint(float t)
		{
			float a = Mathf.Clamp01(t);
			float b = 1.0f - t;

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
	}
}
