using UnityEngine;
using System.Collections.Generic;

public class Powerup : MonoBehaviour
{
    [SerializeField]
    private float _collectAnimateTime = 1.0f;
    [SerializeField]
    private float _collectAnimationRandomOffsetAmount = 1.0f;

    [SerializeField]
    private float _spinRate = 200.0f;

    void Start()
    {
        transform.Rotate(Vector3.up * UnityEngine.Random.value * 180.0f);
    }

    void Update()
    {
        transform.Rotate(Vector3.up * _spinRate * Time.deltaTime);
    }

    private bool _collected = false;
    void OnTriggerEnter(Collider otherCollider)
    {
        Player player = otherCollider.gameObject.GetComponent<Player>();
        if (player && !_collected)
        {
            _collected = true;
            Destroy(collider);

            transform.parent = null;
            StartCoroutine(AnimateCollection(player));
        }
    }

    private System.Collections.IEnumerator AnimateCollection(Player player)
    {

        Vector3 startPosition = transform.position;
        Vector3 startScale = transform.localScale;
        Vector3 randOffset = UnityEngine.Random.onUnitSphere * _collectAnimationRandomOffsetAmount;
        randOffset.y = Mathf.Abs(randOffset.y);
        float recprAnimateTime = 1.0f / _collectAnimateTime;

        for (float t = 0.0f; t < _collectAnimateTime; t += Time.deltaTime)
        {
            float animPercent = t * recprAnimateTime;
            float influence1T = Mathf.SmoothStep(0.0f, 1.0f, animPercent * 2.0f);
            Vector3 influence1 = Vector3.Lerp(startPosition, randOffset + player.transform.position, influence1T);
            float influence2T = (animPercent - 0.5f) * 2.0f;
            Vector3 influence2 = Vector3.Lerp(transform.position, player.transform.position, influence2T);

            transform.position = Vector3.Lerp(influence1, influence2, animPercent);
            transform.localScale = Vector3.Lerp(startScale, Vector3.zero, animPercent);

            yield return 0;
        }

        GameObject.FindObjectOfType<PowerupBar>().CollectedPowerup();
        GameObject.Destroy(this.gameObject);
    }
}
