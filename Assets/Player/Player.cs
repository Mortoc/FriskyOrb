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


    [SerializeField]
    private ParticleSystem _groundEffectParticles;

    private Vector3 _initialGroundParticleOffset;

    [SerializeField]
    private float _fallToDeathThreshold = 30.0f;

    [SerializeField]
    private Transform _blackHoleSphere;
    private float _blackHoleSphereOffset;

    public FX JumpFX;
    public FX DeathFX;
    public FX PowerupFX;

    public Level Level { get; private set; }
    public LevelSegment CurrentSegment { get; set; }

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

    private int _groundMask;

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
        _groundMask = 1 << LayerMask.NameToLayer("Level");
         
        _initialGroundParticleOffset = transform.position - _groundEffectParticles.transform.position;
        _blackHoleSphereOffset = (_blackHoleSphere.position - transform.position).magnitude;

        GameObject.FindObjectOfType<LevelGui>().Player = this;

        CreateSpecks();
    }

    private void CreateSpecks()
    {
        // TODO: CombineChildren to reduce draw calls
        for (int i = 0; i < 7; ++i)
        {
            GameObject speck = GameObject.CreatePrimitive(PrimitiveType.Cube);
            
            speck.transform.localScale = Vector3.one * 0.015f;
            Collider.DestroyImmediate(speck.collider);
            speck.transform.position = _blackHoleSphere.position +
                UnityEngine.Random.onUnitSphere * 0.28f;
            speck.renderer.sharedMaterial = renderer.sharedMaterial;
            speck.transform.parent = _blackHoleSphere;
        }
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

    void Update()
    {
        Vector3 playerToCameraDir = (Camera.main.transform.position - transform.position).normalized;
        _blackHoleSphere.position = transform.position + _blackHoleSphereOffset * playerToCameraDir;
    }

	public Vector3 NearestPathPoint { get; set; }
	public float NearestPathT { get; set; }

    void FixedUpdate()
    {
        //Debug.Log("Time: " + Time.time.ToString("f2"));
        OnFixedUpdate();

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

        AdjustGravity();

        _groundEffectParticles.transform.position = rigidbody.position - _initialGroundParticleOffset;
    }

    public void AnimateColor(Color toColor, float time)
    {
        foreach(Material mat in renderer.materials)
            StartCoroutine(AnimateColorCoroutine(toColor, time, mat));
    }

    private System.Collections.IEnumerator AnimateColorCoroutine(Color toColor, float time, Material mat)
    {
        float recipTime = 1.0f / time;
        Color startColor = mat.color;

        Color startGlowColor = Color.black;
        
        if( mat.HasProperty("_GlowColor") )
            startGlowColor = mat.GetColor("_GlowColor");

        for( float t = 0; t < 1.0f; t += Time.deltaTime * recipTime )
        {
            yield return 0;

            mat.color = Color.Lerp(startColor, toColor, t);

            if (mat.HasProperty("_GlowColor"))
                mat.SetColor("_GlowColor", Color.Lerp(startGlowColor, toColor, t));
        }

    }

    // Look ahead a bit to see where gravity should be
    private const float GRAV_SAMPLE_DIST = 1.25f;
    private void AdjustGravity()
    {
        Vector3 gravDir = Physics.gravity.normalized;
        Vector3 samplePos = rigidbody.position +
            (Heading * GRAV_SAMPLE_DIST) +
            (-GRAV_SAMPLE_DIST * gravDir);

        RaycastHit rh;
        if (Physics.Raycast(samplePos, gravDir, out rh, 3.0f * GRAV_SAMPLE_DIST, _groundMask))
        {
            Physics.gravity = rh.normal * _startingGravityMag * -1.0f;

            // Adjust the heading so it's always perpendicular to gravity
            Vector3 right = Vector3.Cross(Heading, gravDir).normalized;
            Heading = Vector3.Cross(gravDir, right).normalized * Heading.magnitude;
        }
    }

    public bool IsImmortal { get; set; }

    private void PlayerDied()
    {
        if (IsImmortal)
            return;

        if (OnDeath != null)
            OnDeath();

        DeathFX.transform.parent = null;
        DeathFX.PerformFX();
        Destroy(gameObject);

        var powerupBar = FindObjectOfType<PowerupBar>();
        if( powerupBar )
            Destroy(powerupBar.gameObject);


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
