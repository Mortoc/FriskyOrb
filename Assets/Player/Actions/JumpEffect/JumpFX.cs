using UnityEngine;
using System.Collections.Generic;

public class JumpFX : FX
{
    public override void PerformFX()
    {
        transform.forward = Vector3.down;

        particleSystem.Emit(Mathf.FloorToInt(particleSystem.emissionRate * particleSystem.duration));
        Scheduler.Run(AnimateLight());
    }

    private IEnumerator<IYieldInstruction> AnimateLight()
    {
        float initialIntensity = light.intensity;
        light.enabled = true;

        yield return Yield.UntilNextFrame;

        for (float step = 1.0f / particleSystem.duration, t = 0.0f; t < 1.0f; t += step)
        {
            light.intensity = Mathf.SmoothStep(initialIntensity, 0.0f, t);
            yield return Yield.UntilNextFrame;
        }

        light.enabled = false;
    }
}
