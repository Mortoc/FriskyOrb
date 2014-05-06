using UnityEngine;
using System.Collections.Generic;

public class Powerup : Doodad
{
    [SerializeField]
    private float _collectAnimateTime = 1.0f;
    [SerializeField]
    private float _collectAnimationRandomOffsetAmount = 1.0f;

    [SerializeField]
    private float _spinRate = 200.0f;
	[SerializeField]
	private Transform _spinObj;
    [SerializeField]
    private float _bounceEffect = 0.02f;


    void Start()
    {
        transform.Rotate(Vector3.up * UnityEngine.Random.value * 180.0f);
    }

    void Update()
    {
		_spinObj.Rotate(Vector3.up * _spinRate * Time.deltaTime);
    }

    private bool _collected = false;
    void OnTriggerEnter(Collider otherCollider)
    {
        Player player = otherCollider.gameObject.GetComponent<Player>();
        if (player && !_collected)
        {
            _collected = true;

            PowerupBar bar = GameObject.FindObjectOfType<PowerupBar>();

            if (!audio)
                gameObject.AddComponent<AudioSource>();


            transform.parent = null;
            if (!bar.PowerupReady)
            {
                StartCoroutine(AnimateCollection(player, bar));
                audio.pitch = Mathf.Lerp(0.75f, 1.25f, UnityEngine.Random.value);
            }
            else
            {
                StartCoroutine(BounceOffPlayer(player));
                audio.pitch = Mathf.Lerp(0.25f, 0.66f, UnityEngine.Random.value);
            }

			audio.Play();
        }
    }

    private System.Collections.IEnumerator BounceOffPlayer(Player player)
    {
        yield return new WaitForFixedUpdate();
        gameObject.AddComponent<Rigidbody>();
        Vector3 dir = (transform.position - player.rigidbody.position).normalized;
        rigidbody.mass = 0.05f;
        rigidbody.AddForce(dir * player.rigidbody.velocity.magnitude * _bounceEffect, ForceMode.Impulse);

        yield return new WaitForSeconds(0.1f);

        collider.isTrigger = false;

        Renderer childRenderer = GetComponentInChildren<Renderer>();

        while (childRenderer.isVisible)
            yield return new WaitForFixedUpdate();

        GameObject.Destroy(this.gameObject);
    }

    private System.Collections.IEnumerator AnimateCollection(Player player, PowerupBar bar)
    {
        Destroy(collider);
        Vector3 startPosition = transform.position;
        Vector3 startScale = transform.localScale;
        Vector3 randOffset = UnityEngine.Random.onUnitSphere * _collectAnimationRandomOffsetAmount;
        randOffset.y = Mathf.Abs(randOffset.y);
        float recprAnimateTime = 1.0f / _collectAnimateTime;

        for (float t = 0.0f; t < _collectAnimateTime; t += Time.deltaTime)
        {
            if (!player)
                yield break;

            float animPercent = t * recprAnimateTime;
            float influence1T = Mathf.SmoothStep(0.0f, 1.0f, animPercent * 2.0f);
            Vector3 influence1 = Vector3.Lerp(startPosition, randOffset + player.transform.position, influence1T);
            float influence2T = (animPercent - 0.5f) * 2.0f;
            Vector3 influence2 = Vector3.Lerp(transform.position, player.transform.position, influence2T);

            transform.position = Vector3.Lerp(influence1, influence2, animPercent);
            transform.localScale = Vector3.Lerp(startScale, Vector3.zero, animPercent);

            yield return 0;
        }

        bar.CollectedPowerup();

        Score.Instance.RegisterEvent(Score.Event.StarCollect);
        GameObject.Destroy(this.gameObject);
    }
}
