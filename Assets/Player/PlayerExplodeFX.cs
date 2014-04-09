using UnityEngine;
using System.Collections.Generic;

public class PlayerExplodeFX : FX
{
    [SerializeField]
    private float _explodeForce = 10.0f;
    [SerializeField]
    private float _rotateForce = 30.0f;
	[SerializeField]
	private AudioClip _clip;

    public override void PerformFX()
    {
		if (_clip)
			AudioSource.PlayClipAtPoint(_clip, transform.position);

        foreach (Transform fragment in transform)
        {
            fragment.gameObject.SetActive(true);
            fragment.rigidbody.AddForce(UnityEngine.Random.onUnitSphere * _explodeForce, ForceMode.Impulse);
            fragment.rigidbody.AddTorque(UnityEngine.Random.onUnitSphere * _rotateForce, ForceMode.Impulse);
        }
    }
}
