﻿using UnityEngine;
using System;
using System.Collections.Generic;

using RtInfinity.Players;

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

    private Vector3 _followDistance = new Vector3(0.0f, 3.5f, -6.0f);
    private float _lookAheadDistance = 5.0f;


    private void PlayerDied()
    {
        gameObject.AddComponent<Rigidbody>();
        GetComponent<Rigidbody>().velocity = _player.GetComponent<Rigidbody>().velocity;
    }

    void OnPreRender()
    {
        if (Player)
        {
            Rigidbody playerRB = Player.GetComponent<Rigidbody>();

            Vector3 lookAtPos = playerRB.position + (Player.Heading * _lookAheadDistance);

            Quaternion viewRotation = Quaternion.FromToRotation(
                Vector3.forward,
                (lookAtPos - playerRB.position).normalized
            );
            transform.position = playerRB.position + (viewRotation * _followDistance);

            Vector3 lookAtPath;

            lookAtPath = lookAtPos;
            transform.LookAt(Vector3.Lerp(lookAtPos, lookAtPath, 0.1f));
        }
    }
}
