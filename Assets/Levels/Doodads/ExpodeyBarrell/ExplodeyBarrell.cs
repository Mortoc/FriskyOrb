using UnityEngine;
using System.Collections.Generic;

public class ExplodeyBarrell : MonoBehaviour
{
    [SerializeField]
    private float _playerForce = 100.0f;
    [SerializeField]
    private GameObject _explodeFXPrefab;

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
        GameObject explosion = Instantiate(_explodeFXPrefab) as GameObject;
        explosion.transform.position = transform.position;
        ExplodeyBarrellFX explosionFX = explosion.GetComponent<ExplodeyBarrellFX>();
        explosionFX.PerformFX();

        Destroy(gameObject);
    }
}
