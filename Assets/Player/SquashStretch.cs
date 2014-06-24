using UnityEngine;
using System.Collections.Generic;

public class SquashStretch : MonoBehaviour 
{
	public IEnumerable<Renderer> Renderers { get; set; }

	private float _stretch;
	private Vector3 _axis;

	private Vector3 _lastPosition;
	private Vector3 _lastVelocity;
	private Vector3 _lastAcceleration;

	[SerializeField]
	private float _positiveImpulseThreshold = 1.05f;
	
	[SerializeField]
	private float _collisionMin = 3.5f;
	[SerializeField]
	private float _collisionMax = 20.0f;

	[SerializeField]
	private AnimationCurve _impulseCurve;

	[SerializeField]
	private AnimationCurve _negativeImpulseCurve;

	[SerializeField]
	private float _animTime = 0.5f;


	private List<float> _impulseSamples = new List<float>();
	private List<float> _accelerationSamples = new List<float>();
	private List<float> _velocitySamples = new List<float>();


	void Start()
	{
		_lastAcceleration = Vector3.zero;
		_lastVelocity = Vector3.zero;
		_lastPosition = transform.position;
	}

	void Update()
	{
		UpdateMaterials();
	}

	void FixedUpdate()
	{
		UpdatePhysics();
	}

	// Squash on strong collisions
	void OnCollisionEnter(Collision c)
	{
		if (c.gameObject.layer == LayerMask.NameToLayer("Level")) 
		{
			var avgContactNorm = MathExt.Average
			(
				Functional.Map<ContactPoint, Vector3>
				(
					c.contacts, 
					contact => contact.normal
				)
			);

			var relativeVelocityMag = c.relativeVelocity.magnitude;
			var relativeVelocityNorm = c.relativeVelocity / relativeVelocityMag;
			var hitStrength = Vector3.Dot(avgContactNorm, relativeVelocityNorm) * relativeVelocityMag;

			if( hitStrength > _collisionMin )
			{
				_axis = avgContactNorm;
				float scale = 1.0f + ((hitStrength - _collisionMin) / (_collisionMax - _collisionMin));
				StartCoroutine (ApplyStretchAnimation (_animTime, _negativeImpulseCurve, scale));
			}
		}
	}

	private void UpdatePhysics()
	{
		var velocity = rigidbody.position - _lastPosition;
		var acceleration = velocity - _lastVelocity;
		var impulse = acceleration - _lastAcceleration;
		var impulseMagnitude = impulse.magnitude;

		if( Vector3.Dot (velocity, _lastVelocity) > 0.0f && impulseMagnitude > _positiveImpulseThreshold )
		{
			_axis = impulse / impulseMagnitude; // impulse normalized
			StartCoroutine(ApplyStretchAnimation(_animTime, _impulseCurve, 1.0f));
		}

		_lastAcceleration = acceleration;
		_lastVelocity = velocity;
		_lastPosition = transform.position;
	}
	
	private void UpdateMaterials()
	{
		if (Renderers == null) 
			Renderers = GetComponentsInChildren<Renderer> ();

		_axis = rigidbody.velocity.normalized;
		foreach (Renderer r in Renderers)
		{
			foreach (Material mat in r.materials)
			{
				if( mat.HasProperty("_stretchEnd") )
					mat.SetVector("_stretchEnd", _axis);
							
				if( mat.HasProperty("_stretch") )
					mat.SetFloat("_stretch", _stretch);
			}
		}
	}

	private System.Collections.IEnumerator ApplyStretchAnimation(float time, AnimationCurve curve, float scale)
	{
		float recipTime = 1.0f / time;
		for (float t = 0.0f; t < time; t += Time.deltaTime)
		{
			yield return 0;
			_stretch = curve.Evaluate(t * recipTime) * scale;
		}
		
		_stretch = 0.0f;
	}

}
