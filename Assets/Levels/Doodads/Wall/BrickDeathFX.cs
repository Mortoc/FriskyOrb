using UnityEngine;
using System.Collections;

public class BrickDeathFX : FX 
{
	private static IEnumerator AnimateBrickDeath(GameObject brickDeath)
	{
		yield return new WaitForSeconds(UnityEngine.Random.value * 0.2f);
		brickDeath.GetComponent<ParticleSystem>().Emit(2);
		yield return new WaitForSeconds(10.0f);
		Destroy(brickDeath);
	}

	public GameObject _brickDeathPrefab;

	public override void PerformFX()
	{	
		var brickDeath = (GameObject)Instantiate(_brickDeathPrefab);
		brickDeath.transform.position = transform.position;
		brickDeath.transform.rotation = transform.rotation;
		var coroutineContext = brickDeath.AddComponent<CoroutineContext>();
		coroutineContext.StartCoroutine(AnimateBrickDeath(brickDeath));
	}
}
