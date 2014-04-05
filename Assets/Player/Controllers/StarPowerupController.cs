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

        Score.Instance.RegisterEvent(Score.Event.ActivatePowerup);
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
        YieldInstruction untilNextFixedUpdate = new WaitForFixedUpdate();
        Rigidbody playerRB = _player.rigidbody;
        playerRB.isKinematic = true;

        LevelSegment segment = _player.CurrentSegment;
        float startT = segment.Path.GetApproxT(playerRB.position);

        // Move back to track center
        Vector3 targetPosition = segment.Path.GetPoint(startT) + floatOffset;
        SmoothedVector headingDuringMoveBackToTrack = new SmoothedVector(1.0f);
        headingDuringMoveBackToTrack.AddSample(_player.Heading);

        float playerSpeed = 20.0f;
        float dist = 0.4f;
        do {
            Vector3 diff = targetPosition - playerRB.position;
            dist = diff.magnitude;
            Vector3 dir = diff / dist;

            playerRB.position = playerRB.position + (dir * playerSpeed * Time.fixedDeltaTime);
            headingDuringMoveBackToTrack.AddSample(dir);
            _player.Heading = headingDuringMoveBackToTrack.GetSmoothedVector();
            
            yield return untilNextFixedUpdate;
        } while( dist > 0.2f );

        // Run along the track
        float segmentsIn = 0.0f;
        float tInSegment = startT;
        for( float time = 0.0f; time < POWERUP_DURATION; time += Time.fixedDeltaTime )
        {
            float t = time / POWERUP_DURATION;
            tInSegment = startT + (t * POWERUP_DURATION * PLAYER_SPEED) - segmentsIn;

            if( tInSegment >= 0.99f )
            {
                segmentsIn += 1.0f;
                tInSegment -= 1.0f;
                segment = segment.Next;
            }

            targetPosition = segment.Path.GetPoint(tInSegment) + floatOffset;
            targetPositionSmoothed.AddSample(targetPosition);
            _player.Heading = (targetPosition - playerRB.position).normalized;
            playerRB.position = targetPositionSmoothed.GetSmoothedVector();
            yield return untilNextFixedUpdate;
        }

        // Return the player to rigidbody control and give her a kick
        float kick = 150.0f;
        playerRB.isKinematic = false;

        float lookAhead = tInSegment + (kick * 0.001f);
        if( lookAhead > 1.0f )
        {
            segment = segment.Next;
            lookAhead -= 1.0f;
        }
        Vector3 lookAheadPoint = segment.Path.GetPoint(lookAhead) + floatOffset;
        _player.Heading = (lookAheadPoint - playerRB.position).normalized;
        playerRB.AddForce(_player.Heading * kick, ForceMode.Impulse);

        // Fire off an explosion to clear any barrells the player might be dropped near
        float forceBubbleRadius = 12.5f;
        float forceStr = 50.0f;
        int doodadLayer = LayerMask.NameToLayer("Doodad");
        foreach(Collider collider in Physics.OverlapSphere(playerRB.position, forceBubbleRadius))
        {
            if (collider.gameObject.layer == doodadLayer)
            {
                var colliderDist = (collider.transform.position - playerRB.position).magnitude;
                var forceWithFalloff = Mathf.Lerp(forceStr, 0.0f, colliderDist / forceBubbleRadius);
                var explodeyBarrell = collider.GetComponent<ExplodeyBarrell>();
                if( explodeyBarrell ) 
                {
                    explodeyBarrell.ForcePush(_player, forceWithFalloff);
                }
                else if( collider.rigidbody )
                {
                    collider.rigidbody.AddForce((playerRB.position - collider.rigidbody.position).normalized * forceWithFalloff);
                }
            }
        }

        if (PowerupEnded != null)
            PowerupEnded();
    }
}
