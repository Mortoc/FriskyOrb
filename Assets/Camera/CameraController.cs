using UnityEngine;
using System;
using System.Collections.Generic;

public class CameraController : MonoBehaviour
{
    public Player Player { get; set; }

    private Vector3 _followDistance = new Vector3
    (
        0.0f, 1.5f, -2.0f
    );
    private float _lookAheadDistance = 5.0f;

    private SmoothedVector _lookAtTarget = new SmoothedVector(0.25f);
    private SmoothedVector _currentPosition = new SmoothedVector(0.25f);
    private SmoothedVector _velocity = new SmoothedVector(1.0f);

    void FixedUpdate()
    {
        if (Player)
        {
            Vector3 lookAtPos = Player.rigidbody.position + (Player.Heading * _lookAheadDistance);

            // If the player is falling off the bottom of the screen, look down a bit more
            Vector3 playerPosInView = camera.WorldToViewportPoint(Player.transform.position);
            if (playerPosInView.y < 0.2f)        
                _lookAtTarget.AddSample(lookAtPos + (Vector3.down * 0.5f));
            else
                _lookAtTarget.AddSample(lookAtPos);

            Quaternion viewRotation = Quaternion.FromToRotation(Vector3.forward, (lookAtPos - Player.rigidbody.position).normalized);
            _currentPosition.AddSample(Player.transform.position + (viewRotation * _followDistance));

            _velocity.AddSample(Player.rigidbody.velocity);
            transform.position = _currentPosition.GetSmoothedVector();
            transform.LookAt(_lookAtTarget.GetSmoothedVector());
        }
        else if( _velocity.HasSamples && !rigidbody)
        {
            gameObject.AddComponent<Rigidbody>();
            rigidbody.velocity = _velocity.GetSmoothedVector();
        }
    }
}
