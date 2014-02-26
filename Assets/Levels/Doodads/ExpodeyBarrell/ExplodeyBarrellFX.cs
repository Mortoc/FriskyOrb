using UnityEngine;
using System.Collections.Generic;

public class ExplodeyBarrellFX : FX
{
    [SerializeField]
    private float _explosionForce = 100.0f;
    [SerializeField]
    private float _fragmentLife = 5.0f;

    public override void PerformFX()
    {
        particleSystem.Emit(100);
        var fragments = GetComponentsInChildren<Rigidbody>();
        foreach (var fragment in fragments)
        {
            fragment.AddForce(_explosionForce * UnityEngine.Random.onUnitSphere, ForceMode.Impulse);
        }

        Scheduler.Run(CleanupFragments(fragments));
    }

    private IEnumerator<IYieldInstruction> CleanupFragments(IEnumerable<Rigidbody> fragments)
    {
        yield return new YieldForSeconds(_fragmentLife);

        // Spread out the cleanup over a bunch of frames
        foreach(var fragment in fragments)
        {
            GameObject.Destroy(fragment.gameObject);
            yield return Yield.UntilNextFrame;
        }

        GameObject.Destroy(gameObject);
    }
}
