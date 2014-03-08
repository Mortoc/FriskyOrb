using UnityEngine;
using System.Collections.Generic;

public class ExplodeyBarrellFX : FX
{
    [SerializeField]
    private float _explosionForce = 100.0f;
    [SerializeField]
    private float _fragmentLife = 5.0f;
    [SerializeField]
    private ParticleSystem _particleSystem;

    public override void PerformFX()
    {
        _particleSystem.Emit(100);
        var fragments = GetComponentsInChildren<Rigidbody>();
        foreach (var fragment in fragments)
        {
            Vector3 randomDir = UnityEngine.Random.onUnitSphere;
            randomDir.y = Mathf.Max(0.0f, randomDir.y);
            fragment.AddForce(_explosionForce * randomDir, ForceMode.Impulse);
        }

        Scheduler.Run(CleanupFragments(fragments));
    }

    private IEnumerator<IYieldInstruction> CleanupFragments(IEnumerable<Rigidbody> fragments)
    {
        yield return new YieldForSeconds(_fragmentLife);

        // Spread out the cleanup over a bunch of frames
        foreach (var fragment in fragments)
        {
            GameObject.Destroy(fragment.gameObject);
            yield return Yield.UntilNextFrame;
        }

        GameObject.Destroy(gameObject);
    }
}
