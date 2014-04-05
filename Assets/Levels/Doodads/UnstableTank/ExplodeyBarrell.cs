﻿using UnityEngine;
using System.Collections.Generic;

public class ExplodeyBarrell : Doodad
{
    [SerializeField]
    private float _playerForce = 100.0f;
    [SerializeField]
    private GameObject _explodeFX;

    void Start()
    {
        rigidbody.Sleep();
    }

    void OnCollisionEnter(Collision collision)
    {
        if (collision.collider.gameObject.layer == LayerMask.NameToLayer("Player"))
        {
            Explode(collision.collider.gameObject);

            Vector3 forceDir = (collision.rigidbody.position - rigidbody.position + Vector3.up).normalized;
            collision.rigidbody.AddForce(forceDir * _playerForce, ForceMode.Impulse);
        }
    }
    
    public void ForcePush(Player player, float strength)
    {
        StartCoroutine(ForcePushCoroutine(player, strength));
    }

    private System.Collections.IEnumerator ForcePushCoroutine(Player player, float strength)
    {
        gameObject.layer = LayerMask.NameToLayer("FX");

        float fuseTime = 1.0f;

        Vector3 playerDir = (rigidbody.position - player.rigidbody.position).normalized;
        rigidbody.AddForce(playerDir * strength, ForceMode.Impulse);
        rigidbody.AddTorque(strength * UnityEngine.Random.onUnitSphere, ForceMode.Impulse);

        yield return new WaitForSeconds(fuseTime);

        Explode(player.gameObject);
    }

    private void Explode(GameObject playerObj)
    {
        _explodeFX.SetActive(true);
        _explodeFX.transform.parent = null;
        ExplodeyBarrellFX explosionFX = _explodeFX.GetComponent<ExplodeyBarrellFX>();
        explosionFX.PerformFX();
        Destroy(gameObject);

        Score.Instance.RegisterEvent(Score.Event.ExplodeBarrell);
    }
}
