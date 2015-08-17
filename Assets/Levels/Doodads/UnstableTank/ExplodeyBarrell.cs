using UnityEngine;
using System.Collections.Generic;

public class ExplodeyBarrell : ShootableDoodad
{
    [SerializeField]
    private float _damage = 75.0f;

    [SerializeField]
    private float _playerForce = 100.0f;
    [SerializeField]
    private GameObject _explodeFX;

    void Start()
    {
        GetComponent<Rigidbody>().Sleep();
    }

    void OnCollisionEnter(Collision collision)
    {
        if (collision.collider.gameObject.layer == LayerMask.NameToLayer("Player"))
        {
            Explode(collision.collider.gameObject);

            Vector3 forceDir = (collision.rigidbody.position - GetComponent<Rigidbody>().position + (Vector3.up * 0.25f)).normalized;
            collision.rigidbody.AddForce(forceDir * _playerForce, ForceMode.Impulse);

            var powerupBar = FindObjectOfType<PowerupBar>();
            powerupBar.TakeDamage(_damage);
        }
    }
    
    public void ForcePush(Player player, float strength)
    {
        StartCoroutine(ForcePushCoroutine(player, strength));
    }

    private System.Collections.IEnumerator ForcePushCoroutine(Player player, float strength)
    {
        gameObject.layer = LayerMask.NameToLayer("FX");

        float fuseTime = 0.66f;

        Vector3 playerDir = (GetComponent<Rigidbody>().position - player.GetComponent<Rigidbody>().position).normalized;
        GetComponent<Rigidbody>().AddForce(playerDir * strength, ForceMode.Impulse);
        GetComponent<Rigidbody>().AddTorque(strength * UnityEngine.Random.onUnitSphere, ForceMode.Impulse);

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
