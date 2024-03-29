﻿using UnityEngine;
using System.Collections.Generic;

public class ExplodeyBarrellFX : FX
{
    [SerializeField]
    private float _explosionForce = 300.0f;
    [SerializeField]
    private float _fragmentLife = 5.0f;
    [SerializeField]
    private ParticleSystem _particleSystem;
    [SerializeField]
    private AudioClip[] _explosionSounds;

    public override void PerformFX()
    {
        _particleSystem.Emit(100);
        var fragments = GetComponentsInChildren<Rigidbody>();
        foreach (var fragment in fragments)
        {
            Vector3 randomDir = UnityEngine.Random.onUnitSphere;
            float force = UnityEngine.Random.value * _explosionForce * 2.0f;
            randomDir.y = Mathf.Max(0.0f, randomDir.y);
            fragment.AddForce(force * randomDir, ForceMode.Impulse);
        }

        if (_explosionSounds.Length > 0)
        {
            if( !GetComponent<AudioSource>() )
                gameObject.AddComponent<AudioSource>();

            GetComponent<AudioSource>().clip = _explosionSounds[UnityEngine.Random.Range(0, _explosionSounds.Length)];
            GetComponent<AudioSource>().loop = false;
            GetComponent<AudioSource>().volume = 1.0f;
            GetComponent<AudioSource>().Play();
        }

        StartCoroutine(CleanupFragments(fragments));
    }

    private System.Collections.IEnumerator CleanupFragments(IEnumerable<Rigidbody> fragments)
    {
        yield return new WaitForSeconds(_fragmentLife);

        // Spread out the cleanup over a bunch of frames
        foreach (var fragment in fragments)
        {
            GameObject.Destroy(fragment.gameObject);
            yield return 0;
        }

        GameObject.Destroy(gameObject);
    }
}
