using UnityEngine;
using System.Collections;

public class PlayerGun : MonoBehaviour 
{
	[SerializeField]
	private float _maxRange = 10.0f;

	[SerializeField]
	private float _fireRate = 0.66f;

	[SerializeField]
	private float _fireForce = 100.0f;

	[SerializeField]
	private GameObject _bulletPrefab;

	[SerializeField]
	private float _bulletEmitJitter = 1.0f;

	private float _nextShotTime = 0.0f;

	private int _layerMask;

	void Start()
	{
		_layerMask = LayerMask.GetMask("Shootable-Doodad");
	}

	void FixedUpdate()
	{
		if( Time.time > _nextShotTime )
		{
			var dir = GetComponent<Rigidbody>().velocity.normalized;
			RaycastHit rh;
			if( Physics.SphereCast(GetComponent<Rigidbody>().position, 1.0f, dir, out rh, _maxRange, _layerMask) )
			{	
				var bullet = (GameObject)Instantiate(_bulletPrefab);
				bullet.GetComponent<Rigidbody>().position = GetComponent<Rigidbody>().position + (UnityEngine.Random.onUnitSphere * _bulletEmitJitter);
				bullet.GetComponent<Rigidbody>().AddForce(dir * _fireForce + GetComponent<Rigidbody>().velocity, ForceMode.Impulse);
				_nextShotTime = Time.time + _fireRate;
			}
		}
	}
}
