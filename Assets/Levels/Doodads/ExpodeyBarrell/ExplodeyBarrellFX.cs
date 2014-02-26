using UnityEngine;
using System.Collections.Generic;

public class ExplodeyBarrellFX : FX
{
    [SerializeField]
    private float _explosionForce = 100.0f;
    [SerializeField]
    private float _explosionRadius = 1.0f;
    [SerializeField]
    private float _fragmentLife = 5.0f;

    public override void PerformFX()
    {
        var fragmentCount = 0.0f;
        var fragPositionAccum = Vector3.zero;
        var fragments = GetComponentsInChildren<Rigidbody>();

        foreach (var fragment in fragments)
        {
            fragmentCount += 1.0f;
            fragPositionAccum += fragment.position;
        }

        Vector3 avgPosition = fragPositionAccum / fragmentCount;

        foreach (var fragment in fragments)
        {
            fragment.AddExplosionForce(_explosionForce, avgPosition, _explosionRadius);
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
    }
}
