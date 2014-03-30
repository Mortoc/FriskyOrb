using UnityEngine;
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

    private void Explode(GameObject playerObj)
    {
        _explodeFX.SetActive(true);
        _explodeFX.transform.parent = null;
        ExplodeyBarrellFX explosionFX = _explodeFX.GetComponent<ExplodeyBarrellFX>();
        explosionFX.PerformFX();
        Destroy(gameObject);
    }
}
