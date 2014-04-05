using UnityEngine;
using System;
using System.Collections.Generic;

public class StarPowerupController : IPlayerController
{
    public event Action OnEnable;
    public event Action OnDisable;

    public event Action PowerupEnded;

    public const float POWERUP_DURATION = 2.0f; // seconds
    public const float PLAYER_SPEED = 1.0f; // segments/second

    private readonly Player _player;

    public StarPowerupController(Player player)
    {
        _player = player;    
    }

    public void Enable()
    {
        if (OnEnable != null)
            OnEnable();

        _player.PowerupFX.PerformFX();
        _player.StartCoroutine(ExecutePowerup());
    }

    public void Disable()
    {
        if (OnDisable != null)
            OnDisable();
    }

    private System.Collections.IEnumerator ExecutePowerup()
    {
        Vector3 floatOffset = Vector3.up;
        SmoothedVector targetPositionSmoothed = new SmoothedVector(0.33f);
        YieldInstruction nextFixedUpdate = new WaitForFixedUpdate();
        Rigidbody playerRB = _player.rigidbody;
        playerRB.isKinematic = true;

        LevelSegment segment = _player.CurrentSegment;
        float startT = segment.Path.GetApproxT(playerRB.position);
        float segmentsIn = 0.0f;
        for( float time = 0.0f; time < POWERUP_DURATION; time += Time.fixedDeltaTime )
        {
            float t = time / POWERUP_DURATION;
            float tInSegment = startT + (t * POWERUP_DURATION * PLAYER_SPEED) - segmentsIn;

            if( tInSegment >= 0.99f )
            {
                segmentsIn += 1.0f;
                tInSegment -= 1.0f;
                segment = segment.Next;
            }

            Vector3 targetPosition = segment.Path.GetPoint(tInSegment) + floatOffset;
            targetPositionSmoothed.AddSample(targetPosition);
            playerRB.position = targetPositionSmoothed.GetSmoothedVector();
            yield return nextFixedUpdate;
        }

        playerRB.isKinematic = false;
        if (PowerupEnded != null)
            PowerupEnded();
    }
}
