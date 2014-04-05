using UnityEngine;
using System.Collections.Generic;

public class PowerupFX : FX
{
    [SerializeField]
    private int _orbiterCount = 10;

    [SerializeField]
    private float _orbiterSpeed = 360.0f;

    [SerializeField]
    private float _orbiterRadius = 2.0f;

    [SerializeField]
    private GameObject _orbiterPrefab;
    
    public override void PerformFX()
    {
        StartCoroutine(SpawnOrbiters());
    }

    private System.Collections.IEnumerator SpawnOrbiters()
    {
        var orbiters = new List<GameObject>();

        for( int i = 0; i < _orbiterCount; ++i )
        {
            var orbiter = Instantiate(_orbiterPrefab) as GameObject;

            var orbiterFx = orbiter.GetComponent<PowerupOrbiterFX>();
            orbiterFx.OrbitObj = transform;
            orbiterFx.OrbitRadius = _orbiterRadius;
            orbiterFx.OrbitSpeed = _orbiterSpeed;

            orbiters.Add(orbiter);
            yield return 0;
        }

        yield return new WaitForSeconds(StarPowerupController.POWERUP_DURATION);

        foreach (var orbiter in orbiters)
        {
            orbiter.AddComponent<Rigidbody>();
            
            orbiter.rigidbody.AddForce((transform.position - orbiter.transform.position) * UnityEngine.Random.value * 50.0f, ForceMode.Impulse);
            Destroy(orbiter.GetComponent<PowerupOrbiterFX>());
            orbiter.transform.parent = null;
        }

        yield return new WaitForSeconds(Mathf.Lerp(3.0f, 5.0f, UnityEngine.Random.value));
        orbiters.ForEach(Destroy);
    }
}
