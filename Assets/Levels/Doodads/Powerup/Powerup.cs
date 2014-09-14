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
            if (!bar.HealthFull())
            {
                StartCoroutine(AnimateCollection(player, bar));
                audio.pitch = Mathf.Lerp(0.75f, 1.25f, UnityEngine.Random.value);
            }
            else
            {
                StartCoroutine(BounceOffPlayer(player));
                audio.pitch = Mathf.Lerp(0.5f, 0.75f, UnityEngine.Random.value);
            }

			audio.Play();
        }
    }

    private System.Collections.IEnumerator BounceOffPlayer(Player player)
    {
        foreach(Renderer r in GetComponentsInChildren<Renderer>())
        {
            foreach(Material m in r.materials)
            {
                if (m.HasProperty("_Color"))
                    m.color = Color.Lerp(Color.black, m.color, 0.5f);

                if( m.HasProperty("_GlowStrength") )
                    m.SetFloat("_GlowStrength", 0.25f);
            }
        }

        yield return new WaitForFixedUpdate();
        gameObject.AddComponent<Rigidbody>();
        gameObject.GetComponent<SphereCollider>().isTrigger = false;
        gameObject.layer = 0;
        Vector3 dir = transform.position - player.rigidbody.position;
        dir.y = 0.0f;
        dir = dir.normalized;
        dir += Vector3.Lerp(-0.5f * Physics.gravity, -1.0f * Physics.gravity, UnityEngine.Random.value);
        
        rigidbody.mass = Mathf.Lerp(0.2f, 0.4f, UnityEngine.Random.value);
        rigidbody.AddForce
        (
            (player.rigidbody.velocity * 0.5f) + (dir * _bounceEffect), 
            ForceMode.Impulse
        );

        yield return new WaitForSeconds(0.1f);

        collider.isTrigger = false;
        gameObject.layer = LayerMask.NameToLayer("FX");

        Renderer childRenderer = GetComponentInChildren<Renderer>();

        while (childRenderer.isVisible)
            yield return 0;

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
        bool particlesFired = false;
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

            if (!particlesFired && t > _collectAnimateTime * 0.5f && 
                (transform.position - player.transform.position).sqrMagnitude < (player.transform.localScale.sqrMagnitude * 0.1f) )
            {
                particlesFired = true;
                particleSystem.Play();
            }
        }

        bar.CollectedPowerup();

        Score.Instance.RegisterEvent(Score.Event.StarCollect);

        yield return new WaitForSeconds(3.0f);
        GameObject.Destroy(this.gameObject);
    }
}
