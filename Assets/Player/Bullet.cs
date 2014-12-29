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
		foreach(var mat in GetComponent<Renderer>().materials) 
			if( mat.HasProperty("_stretch") )
				mats.Add(mat);
		_stretchMaterials = mats.ToArray();

		_spawnPoint = transform.position;
	}
	
	void FixedUpdate()
	{
		var speed = GetComponent<Rigidbody>().velocity.magnitude;
		var dir = GetComponent<Rigidbody>().velocity / speed;

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
		foreach(var collider in Physics.OverlapSphere(GetComponent<Rigidbody>().position, _explosionRadius, _layerMask)) {
			if( collider.GetComponent<Rigidbody>() ) {
				var positionDiff = collider.GetComponent<Rigidbody>().position - GetComponent<Rigidbody>().position;
				var distance = positionDiff.magnitude;
				var direction = positionDiff / distance;
				var explosionForce = direction * _explosionForce;
				var velocityForce = GetComponent<Rigidbody>().velocity * 0.025f * _explosionForce;
				
				collider.GetComponent<Rigidbody>().useGravity = true;
				collider.GetComponent<Rigidbody>().AddForce((explosionForce + velocityForce) * Mathf.Lerp(0.5f, 1.0f, UnityEngine.Random.value), ForceMode.Impulse);
				collider.GetComponent<Rigidbody>().AddTorque(UnityEngine.Random.onUnitSphere * collider.GetComponent<Rigidbody>().mass * _explosionForce * 0.01f, ForceMode.Impulse);

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
