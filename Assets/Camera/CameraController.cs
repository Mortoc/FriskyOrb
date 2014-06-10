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
            _player.OnDeath += PlayerDied;
        }
    }

    private Vector3 _followDistance = new Vector3(0.0f, 3.5f, -4.5f);
    private float _lookAheadDistance = 5.0f;


    private void PlayerDied()
    {
        gameObject.AddComponent<Rigidbody>();
        rigidbody.velocity = _player.rigidbody.velocity;
    }

    void OnPreRender()
    {
        if (Player)
        {
            Rigidbody playerRB = Player.rigidbody;

            Vector3 lookAtPos = playerRB.position + (Player.Heading * _lookAheadDistance);

            Quaternion viewRotation = Quaternion.FromToRotation(
                Vector3.forward,
                (lookAtPos - playerRB.position).normalized
            );
            transform.position = playerRB.position + (viewRotation * _followDistance);

			Vector3 lookAtPath;

			if( _player.CurrentSegment )
			{
				float t = _player.NearestPathT + 0.8f;
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
                lookAtPath = lookAtPos;
			}

            transform.LookAt(Vector3.Lerp(lookAtPos, lookAtPath, 0.1f));
        }
    }
}
