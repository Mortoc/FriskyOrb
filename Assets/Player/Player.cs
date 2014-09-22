using UnityEngine;
using System;
using System.Collections.Generic;

public class Player : MonoBehaviour
{
    public event Action OnFixedUpdate;
    public event Action OnGrounded;
    public event Action OnUngrounded;
    public event Action OnDeath;

    public event Action<Collision> CollisionEntered;
    public event Action<Collision> CollisionExited;
    public event Action<Collision> CollisionStay;

    public float Stretch { get; set; }


    [SerializeField]
    private ParticleSystem _groundEffectParticles;

    private Vector3 _initialGroundParticleOffset;

    [SerializeField]
    private float _fallToDeathThreshold = 30.0f;

    public FX JumpFX;
    public FX DeathFX;
    public FX PowerupFX;

    public Level Level { get; private set; }
    
    private IPlayerController _controller;
    public IPlayerController Controller
    {
        get { return _controller; }
        set
        {
            if (_controller != null)
                _controller.Disable();
            
            _controller = value;
            _controller.Enable();
        }
    }

    public bool IsGrounded { get; private set; }

    private void UpdateIsGrounded()
    {
        SphereCollider sphereCol = this.collider as SphereCollider;
        Vector3 gravDir = Physics.gravity / _startingGravityMag;
        float distCheck = transform.localScale.magnitude * sphereCol.radius * 2.0f;
        Vector3 offset = gravDir * -0.5f * distCheck;

        RaycastHit rh;

        rigidbody.position = rigidbody.position + offset;
        //bool grounded = Physics.Raycast(rigidbody.position, Vector3.down, ((SphereCollider)collider).radius, _groundMask);
        bool grounded = rigidbody.SweepTest(gravDir, out rh, 1.0f);
        rigidbody.position = rigidbody.position - offset;

        if (grounded && !IsGrounded)
            OnGrounded();
        else if (!grounded && IsGrounded)
            OnUngrounded();

        IsGrounded = grounded;
    }

    public Vector3 Heading { get; set; }

    private float _startingGravityMag = 0.0f;

    void Start()
    {
        Heading = Vector3.forward;
        OnFixedUpdate += UpdateIsGrounded;
        Controller = new PlayerMovementController(this);

        OnGrounded += BecameGrounded;
        OnUngrounded += BecameUngrounded;

        Level = GameObject.FindObjectOfType<Level>();
        _startingGravityMag = Physics.gravity.magnitude;
         
        _initialGroundParticleOffset = transform.position - _groundEffectParticles.transform.position;
     
        GameObject.FindObjectOfType<LevelGui>().Player = this;
		GetComponentInChildren<PlayerExplodeFX> ().Player = this;
    }

    private void BecameGrounded()
    {
        _groundEffectParticles.enableEmission = true;
		audio.Play();
    }

    private void BecameUngrounded()
    {
        _groundEffectParticles.enableEmission = false;
		audio.Stop();
    }

	public Vector3 NearestPathPoint { get; set; }
	public float NearestPathT { get; set; }

    void FixedUpdate()
    {
        if (CurrentSegment)
        {
			NearestPathT = CurrentSegment.Path.GetApproxT(rigidbody.position);

			if (NearestPathT > 0.999f)
            {
				NearestPathT = CurrentSegment.Next.Path.GetApproxT(rigidbody.position);
				NearestPathPoint = CurrentSegment.Next.Path.GetPoint(NearestPathT);

                LevelSegment oldSegment = CurrentSegment;
                CurrentSegment = CurrentSegment.Next;
                oldSegment.IsNoLongerCurrent();
            }
            else
            {
				NearestPathPoint = CurrentSegment.Path.GetPoint(NearestPathT);
            }

			if (NearestPathPoint.y > rigidbody.position.y + _fallToDeathThreshold)
            {
                PlayerDied();
            }
        }

        _groundEffectParticles.transform.position = rigidbody.position - _initialGroundParticleOffset;

        OnFixedUpdate();
    }


    private IEnumerable<Renderer> PlayerRenderers()
    {
        foreach(Renderer r in GetComponentsInChildren<Renderer>())
        {
            if( r.gameObject.layer == gameObject.layer )
            {
                yield return r;
            }
        }
    }

    

    public void AnimateColor(Color toColor, float time, bool thenReturnColor)
    {
        foreach(Renderer r in PlayerRenderers())
            foreach(Material mat in r.materials)
                StartCoroutine(AnimateColorCoroutine(toColor, time, mat, thenReturnColor));
    }

    private System.Collections.IEnumerator AnimateColorCoroutine(Color toColor, float time, Material mat, bool thenReturnColor)
    {
        float recipTime = 1.0f / time;
        Color startColor;

        if (mat.HasProperty("_rimColor"))
            startColor = mat.GetColor("_rimColor");
        else if (mat.HasProperty("_Color"))
            startColor = mat.color;
        else
            yield break;

        for (float t = 0; t < time; t += Time.deltaTime)
        {
            yield return 0;
            var color = Color.Lerp(startColor, toColor, t * recipTime);
            if( mat.HasProperty("_rimColor"))
                mat.SetColor("_rimColor", color);
            else if(mat.HasProperty("_Color"))
                mat.color = color;
        }
        if( mat.HasProperty("_rimColor"))
            mat.SetColor("_rimColor", toColor);
        else if(mat.HasProperty("_Color"))
            mat.color = toColor;
        

        if( thenReturnColor ) 
        {
            StartCoroutine(AnimateColorCoroutine(startColor, time, mat, false));
        }
    }

    public void PlayerDied()
    {
       if (OnDeath != null)
            OnDeath();

        DeathFX.transform.parent = null;
        DeathFX.PerformFX();
        Destroy(gameObject);
        
		try
		{
	        if (!PlayerPrefs.HasKey("best_score") || PlayerPrefs.GetInt("best_score") < Score.Instance.ActualScore)
	        {
	            PlayerPrefs.SetInt("best_score", (int)Score.Instance.ActualScore);
	            PlayerPrefs.SetInt("best_score_level_seed", Level.Seed);

	            Analytics.gua.sendEventHit("Player", "Death", "WasBestScore", (int)Score.Instance.ActualScore);
	        }
	        else
	        {
	            Analytics.gua.sendEventHit("Player", "Death", "WasNotBestScore", (int)Score.Instance.ActualScore);
	        }
		}
		catch(System.NullReferenceException) { }

    }

    void OnCollisionEnter(Collision collision)
    {
        if (CollisionEntered != null)
            CollisionEntered(collision);
    }

    void OnCollisionExit(Collision collision)
    {
        if (CollisionExited != null)
            CollisionExited(collision);
    }

    void OnCollisionStay(Collision collision)
    {
        if (CollisionStay != null)
            CollisionStay(collision);
    }
}
