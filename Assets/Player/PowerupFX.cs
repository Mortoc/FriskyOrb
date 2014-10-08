using UnityEngine;
using System.Collections.Generic;

using RtInfinity.Players;

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

    private bool _powerupCompleted = false;

    private System.Collections.IEnumerator SpawnOrbiters()
    {
        var player = FindObjectOfType<Player>();
        var controller = player.Controller as StarPowerupController;

        if (controller == null)
            throw new System.InvalidOperationException("Cannot perform PowerupFX while the player isn't being controlled by StarPowerupController");

        controller.OnDisable += () => _powerupCompleted = true;

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

        while( !_powerupCompleted )
            yield return 0;
        
        foreach (var orbiter in orbiters)
        {
            orbiter.AddComponent<Rigidbody>();
            
            orbiter.rigidbody.AddForce((transform.position - orbiter.transform.position) * UnityEngine.Random.value * 50.0f, ForceMode.Impulse);
            Destroy(orbiter.GetComponent<PowerupOrbiterFX>());
            orbiter.transform.parent = null;
        }
        
        _powerupCompleted = false;

        yield return new WaitForSeconds(Mathf.Lerp(3.0f, 5.0f, UnityEngine.Random.value));
        orbiters.ForEach(Destroy);
    }
}
