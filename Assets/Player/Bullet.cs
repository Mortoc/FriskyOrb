using UnityEngine;
using System.Collections;

public class Bullet : MonoBehaviour 
{
	[SerializeField]
	private float _explosionRadius = 1.0f;

	[SerializeField]
	private float _explosionForce = 10.0f;

	private int _layerMask;

	void Start()
	{
		_layerMask = LayerMask.GetMask("Shootable-Doodad");
	}
	

	void OnCollisionEnter(Collision collision)
	{
		Debug.Log("Entered collision: " + collision.gameObject.name);
		foreach(var collider in Physics.OverlapSphere(rigidbody.position, _explosionRadius, _layerMask)) {
			if( collider.rigidbody ) {
				var explosionForce = (rigidbody.position - collider.rigidbody.position).normalized * _explosionForce;
				var velocityForce = rigidbody.velocity;
				collider.rigidbody.AddForce(explosionForce + velocityForce, ForceMode.Impulse);
			}
		}

		Destroy(gameObject);
	}
}
