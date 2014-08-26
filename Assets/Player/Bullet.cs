using UnityEngine;
using System.Collections.Generic;

public class Bullet : MonoBehaviour 
{
	[SerializeField]
	private float _damage = 50.0f;

	[SerializeField]
	private float _explosionRadius = 1.0f;

	[SerializeField]
	private float _explosionForce = 10.0f;

	[SerializeField]
	private float _maxDistance = 30.0f;
	private Vector3 _spawnPoint;

	[SerializeField]
	private float _stretchiness = 0.1f;

	private int _layerMask;
	private Material[] _stretchMaterials;

	void Start()
	{
		_layerMask = LayerMask.GetMask("Shootable-Doodad");

		var mats = new List<Material>();
		foreach(var mat in renderer.materials) 
			if( mat.HasProperty("_stretch") )
				mats.Add(mat);
		_stretchMaterials = mats.ToArray();

		_spawnPoint = transform.position;
	}
	
	void FixedUpdate()
	{
		var speed = rigidbody.velocity.magnitude;
		var dir = rigidbody.velocity / speed;

		if( speed < 0.01f ) 
		{
			speed = 0.0f;
			dir = Vector3.up;
		}

		foreach(var mat in _stretchMaterials)
		{
			transform.forward = dir;
			mat.SetVector("_stretchEnd", dir);
			mat.SetFloat("_stretch", speed * _stretchiness);
		}

		if( _maxDistance * _maxDistance < (transform.position - _spawnPoint).sqrMagnitude )
			Explode();
	}

	void OnTriggerEnter(Collider collider)
	{
		if( collider.gameObject.layer != LayerMask.NameToLayer("Shootable-Doodad") )
			return;

		Explode();
	}

	public void Explode()
	{
		foreach(var collider in Physics.OverlapSphere(rigidbody.position, _explosionRadius, _layerMask)) {
			if( collider.rigidbody ) {
				var positionDiff = collider.rigidbody.position - rigidbody.position;
				var distance = positionDiff.magnitude;
				var direction = positionDiff / distance;
				var explosionForce = direction * _explosionForce;
				var velocityForce = rigidbody.velocity * 0.025f * _explosionForce;
				
				collider.rigidbody.useGravity = true;
				collider.rigidbody.AddForce((explosionForce + velocityForce) * Mathf.Lerp(0.5f, 1.0f, UnityEngine.Random.value), ForceMode.Impulse);
				collider.rigidbody.AddTorque(UnityEngine.Random.onUnitSphere * collider.rigidbody.mass * _explosionForce * 0.01f, ForceMode.Impulse);

				var shootableDoodad = collider.GetComponent<ShootableDoodad>();
				if( shootableDoodad ) 
				{
					var damagePercent = Mathf.Lerp(1.0f, 0.1f, distance / _explosionRadius);
					shootableDoodad.TakeDamage(_damage * damagePercent);
				}
			}
		}

		Destroy(gameObject);
	}
}
