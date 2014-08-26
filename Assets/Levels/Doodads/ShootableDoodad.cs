using UnityEngine;
using System.Collections.Generic;

public class ShootableDoodad : Doodad
{
	[SerializeField]
	private float _hitpoints = 100.0f;
	private float _currentHitpoints;

	public float TotalHitPoints 
	{ 
		get { return _hitpoints; }
	}

	public float CurrentHitPoints
	{
		get { return _currentHitpoints; }
	}

	[SerializeField]
	private FX _destroyEffect;

	protected virtual void Awake()
	{
		gameObject.layer = LayerMask.NameToLayer("Shootable-Doodad");
		_currentHitpoints = _hitpoints;
	}

	public virtual void TakeDamage(float damage)
	{
		_currentHitpoints -= damage;

		if( _currentHitpoints <= 0.0f )
		{
			if( _destroyEffect )
				_destroyEffect.PerformFX();

			Destroy(gameObject);
		}
	}
}
