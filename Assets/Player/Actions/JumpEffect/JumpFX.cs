using UnityEngine;
using System.Collections.Generic;

public class JumpFX : FX
{
    public override void PerformFX()
    {
        transform.forward = Vector3.down;

        particleSystem.Emit(
            Mathf.FloorToInt(particleSystem.emissionRate * particleSystem.duration)
        );
    }
}
