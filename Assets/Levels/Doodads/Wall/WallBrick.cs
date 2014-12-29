using UnityEngine;
using System.Collections;

public class WallBrick : ShootableDoodad 
{
	[SerializeField]
	private float _damage = 3.0f;

	public override void TakeDamage(float damage)
	{
		base.TakeDamage(damage);

		var damagePercent = Mathf.Clamp01(CurrentHitPoints / TotalHitPoints);
		GetComponent<Renderer>().material.color = Color.Lerp(Color.red, Color.white, damagePercent);
	}

	public void OnCollisionEnter(Collision collision)
	{
		if( collision.gameObject.layer == LayerMask.NameToLayer("Player") )
		{
			var powerupBar = FindObjectOfType<PowerupBar>();
			if( powerupBar )
			{
				powerupBar.TakeDamage(_damage);
			}
			DestroyDoodad();
		}
	}
}
