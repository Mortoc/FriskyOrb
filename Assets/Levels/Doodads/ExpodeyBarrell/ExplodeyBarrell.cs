using UnityEngine;
using System.Collections.Generic;

public class ExplodeyBarrell : MonoBehaviour
{
    [SerializeField]
    private GameObject _explodeFXPrefab;

    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.layer == LayerMask.NameToLayer("Player"))
        {
            Explode(collision.gameObject);
        }
    }

    private void Explode(GameObject playerObj)
    {
        GameObject explosion = Instantiate(_explodeFXPrefab) as GameObject;
        ExplodeyBarrellFX explosionFX = explosion.GetComponent<ExplodeyBarrellFX>();
        explosionFX.PerformFX();

        Destroy(gameObject);
    }
}
