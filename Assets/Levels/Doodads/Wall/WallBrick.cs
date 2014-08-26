using UnityEngine;
using System.Collections;

public class WallBrick : ShootableDoodad 
{
	public override void TakeDamage(float damage)
	{
		base.TakeDamage(damage);

		var damagePercent = Mathf.Clamp01(CurrentHitPoints / TotalHitPoints);
		renderer.material.color = Color.Lerp(Color.red, Color.white, damagePercent);
	}
}
