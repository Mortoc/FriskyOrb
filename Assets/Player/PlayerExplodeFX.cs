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

	public Player Player { get; set; }

    public override void PerformFX()
    {
		GetComponent<AudioSource>().Play ();
        foreach (Transform fragment in transform)
        {
            fragment.gameObject.SetActive(true);
			fragment.GetComponent<Rigidbody>().velocity = Player.GetComponent<Rigidbody>().velocity;
            fragment.GetComponent<Rigidbody>().AddForce(UnityEngine.Random.onUnitSphere * _explodeForce, ForceMode.Impulse);
            fragment.GetComponent<Rigidbody>().AddTorque(UnityEngine.Random.onUnitSphere * _rotateForce, ForceMode.Impulse);
        }
    }
}
