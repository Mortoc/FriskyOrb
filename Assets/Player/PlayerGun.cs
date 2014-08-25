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
			var dir = rigidbody.velocity.normalized;
			RaycastHit rh;
			if( Physics.SphereCast(rigidbody.position, 1.0f, dir, out rh, _maxRange, _layerMask) )
			{	
				var bullet = (GameObject)Instantiate(_bulletPrefab);
				bullet.rigidbody.position = rigidbody.position;
				bullet.rigidbody.AddForce(dir * _fireForce + rigidbody.velocity, ForceMode.Impulse);
				_nextShotTime = Time.time + _fireRate;
			}
		}
	}
}
