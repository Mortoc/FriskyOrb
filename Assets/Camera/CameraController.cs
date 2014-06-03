using UnityEngine;
using System;
using System.Collections.Generic;

public class CameraController : MonoBehaviour
{
    private Player _player = null;

    public Player Player 
    {
        get { return _player; }
        set 
        { 
            _player = value;
            _lastPlayerPosition = value.rigidbody.position;
        }
    }

    private Vector3 _followDistance = new Vector3(0.0f, 2.5f, -1.5f);
    private float _lookAheadDistance = 5.0f;

    private SmoothedVector _lookAtTarget = new SmoothedVector(0.33f);
    private SmoothedVector _currentPosition = new SmoothedVector(0.125f);
    private SmoothedVector _velocity = new SmoothedVector(1.0f);

    private Vector3 _lastPlayerPosition;

    void FixedUpdate()
    {
        if (Player)
        {
            Rigidbody playerRB = Player.rigidbody;

            Vector3 lookAtPos = playerRB.position + (Player.Heading * _lookAheadDistance);

            // If the player is falling off the bottom of the screen, look down a bit more
            Vector3 playerPosInView = camera.WorldToViewportPoint(playerRB.position);
            if (playerPosInView.y < 0.2f)
                _lookAtTarget.AddSample(lookAtPos + (Vector3.down * 0.5f));
            else
                _lookAtTarget.AddSample(lookAtPos);

            Quaternion viewRotation = Quaternion.FromToRotation(
                Vector3.forward,
                (lookAtPos - playerRB.position).normalized
            );
            _currentPosition.AddSample(playerRB.position + (viewRotation * _followDistance));

            _velocity.AddSample(_lastPlayerPosition - playerRB.position);
            _lastPlayerPosition = playerRB.position;
            
            transform.position = _currentPosition.GetSmoothedVector();

			var smoothedLookAtVector = _lookAtTarget.GetSmoothedVector();
			Vector3 lookAtPath;

			if( _player.CurrentSegment )
			{
				float t = _player.NearestPathT + 0.25f;
				Spline.Segment path = _player.CurrentSegment.Path;

				if( t > 1.0f ) 
				{
					t -= 1.0f;
					path = _player.CurrentSegment.Next.Path;
				}
				lookAtPath = path.GetPoint(t);
			}
			else
			{
				lookAtPath = smoothedLookAtVector;
			}

			transform.LookAt(Vector3.Lerp(smoothedLookAtVector, lookAtPath, 0.33f));
        }
        else if (_velocity.HasSamples && !rigidbody)
        {
            gameObject.AddComponent<Rigidbody>();
            rigidbody.velocity = _velocity.GetSmoothedVector();
        }
    }
}
