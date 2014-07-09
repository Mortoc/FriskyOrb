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
	private float _impulseAnimTime = 0.5f;

    [SerializeField]
    private float _negativeImpulseTime = 0.5f;


    //private List<float> _impulseSamples = new List<float>();
    //private List<float> _accelerationSamples = new List<float>();
    //private List<float> _velocitySamples = new List<float>();


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
            foreach(var cp in c.contacts)
            {
                Debug.DrawLine(cp.point, cp.point + cp.normal, Color.cyan, 5.0f);
            }

            var avgContactPos = MathExt.Average
            (
                Functional.Map<ContactPoint, Vector3>
                (
                    c.contacts,
                    contact => contact.point
                )
            );


			var avgContactNorm = MathExt.Average
			(
				Functional.Map<ContactPoint, Vector3>
				(
					c.contacts, 
					contact => contact.normal
				)
			);

            Debug.DrawLine(avgContactPos, avgContactPos + avgContactNorm, Color.blue, 5.0f);


			var relativeVelocityMag = c.relativeVelocity.magnitude;
			var relativeVelocityNorm = c.relativeVelocity / relativeVelocityMag;
			var hitStrength = Vector3.Dot(avgContactNorm, relativeVelocityNorm) * relativeVelocityMag;

			if( hitStrength > _collisionMin )
			{
                Vector3 collisionRight = Vector3.Cross(_lastVelocity.normalized, avgContactNorm);
                _axis = Quaternion.Euler(collisionRight * 90.0f) * avgContactNorm;
				float scale = 1.0f + ((hitStrength - _collisionMin) / (_collisionMax - _collisionMin));
                StartCoroutine(ApplyStretchAnimation(_negativeImpulseTime, _negativeImpulseCurve, scale));
			}
		}
	}

	private void UpdatePhysics()
	{
		var velocity = rigidbody.position - _lastPosition;
		var acceleration = velocity - _lastVelocity;
		var impulse = acceleration - _lastAcceleration;
		var impulseMagnitude = impulse.magnitude;

		if( impulseMagnitude > _positiveImpulseThreshold )
		{
			_axis = impulse / impulseMagnitude; // impulse normalized
			StartCoroutine(ApplyStretchAnimation(_impulseAnimTime, _impulseCurve, 1.0f));
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

    private int _animationId = 0;
	private System.Collections.IEnumerator ApplyStretchAnimation(float time, AnimationCurve curve, float scale)
	{
        var animationId = ++_animationId;
        Debug.Log(_animationId + " " + animationId);
		var recipTime = 1.0f / time;
		for (var t = 0.0f; t < time; t += Time.deltaTime)
		{
			yield return 0;

            // If another animation started after this one, end this one
            if (_animationId != animationId)
                yield break;

			_stretch = curve.Evaluate(t * recipTime) * scale;
		}
		
		_stretch = 0.0f;
	}

}
