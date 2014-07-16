using UnityEngine;
using System.Collections.Generic;

namespace Procedural
{
	public class BezierVisualizer : MonoBehaviour 
	{
		private Color _splineColor = Color.red;
		private Color _tangentColor = Color.Lerp(Color.red, Color.black, 0.75f);
		private Color _handleColor = Color.Lerp(Color.red, Color.black, 0.85f);
		
		private Bezier _bezier =Bezier.ConstructSmoothSpline(new Vector3[]{
			new Vector3(0.0f, 1.0f, 0.0f),
            new Vector3(1.0f, 0.0f, 0.0f),
            new Vector3(0.0f, -1.0f, 0.0f),
            new Vector3(-1.0f, 0.0f, 0.0f)
		}, true);
		

		void OnDrawGizmos()
		{
			Gizmos.color = _splineColor;
			Vector3 last = _bezier.ParametricSample(0.0f);
			for(float t = 0.0f; t < 1.0f; t += 0.005f)
			{
				Vector3 current = _bezier.ParametricSample(t);
				Gizmos.DrawLine(last, current);
				last = current;
			}


			Gizmos.color = _tangentColor;
			foreach(var cp in _bezier.ControlPoints)
			{
				Gizmos.DrawLine(cp.Point, cp.InTangent);
				Gizmos.DrawLine(cp.Point, cp.OutTangent);
			}
			
			Gizmos.color = _handleColor;
			foreach(var cp in _bezier.ControlPoints)
			{
				float pntRadius = 0.025f * (cp.InTangent - cp.OutTangent).magnitude;

				Gizmos.DrawSphere(cp.Point, pntRadius);
				Gizmos.DrawSphere(cp.InTangent, pntRadius * 0.75f);
				Gizmos.DrawSphere(cp.OutTangent, pntRadius * 0.75f);
			}
		}
	}
}