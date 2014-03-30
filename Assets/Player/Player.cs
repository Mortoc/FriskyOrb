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
    private float _fallToDeathThreshold = 10.0f;

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
        bool grounded = rigidbody.SweepTest(gravDir, out rh, 2.0f);
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
    }

    private void BecameGrounded()
    {
        _groundEffectParticles.enableEmission = true;
    }

    private void BecameUngrounded()
    {
        _groundEffectParticles.enableEmission = false;
    }

    void Update()
    {
        Vector3 playerToCameraDir = (Camera.main.transform.position - transform.position).normalized;
        _blackHoleSphere.position = transform.position + _blackHoleSphereOffset * playerToCameraDir;
    }

    void FixedUpdate()
    {
        OnFixedUpdate();

        if (CurrentSegment)
        {
            float approxT = CurrentSegment.Path.GetApproxT(rigidbody.position);
            Vector3 pointOnSegment;
            if (approxT > 0.999f)
            {
                float tOnNext = CurrentSegment.Next.Path.GetApproxT(rigidbody.position);
                pointOnSegment = CurrentSegment.Next.Path.GetPoint(tOnNext);

                LevelSegment oldSegment = CurrentSegment;
                CurrentSegment = CurrentSegment.Next;
                oldSegment.IsNoLongerCurrent();
            }
            else
            {
                pointOnSegment = CurrentSegment.Path.GetPoint(approxT);
            }

            if (pointOnSegment.y > rigidbody.position.y + _fallToDeathThreshold)
            {
                PlayerDied();
            }
        }

        AdjustGravity();

        _groundEffectParticles.transform.position = rigidbody.position - _initialGroundParticleOffset;
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
//            Debug.Log("Heading " + Heading + ", Right " + right + ", Up " + (-1.0f * gravDir));
            Debug.DrawLine(rigidbody.position, rigidbody.position + Heading, Color.red);
            Debug.DrawLine(rigidbody.position, rigidbody.position + right, Color.green);
            Debug.DrawLine(rigidbody.position, rigidbody.position + (gravDir * -1.0f), Color.blue);

            // Stick down a bit
            rigidbody.AddForce(Physics.gravity * Time.fixedDeltaTime * 0.5f, ForceMode.Impulse);
        }
    }

    private void PlayerDied()
    {
        if (OnDeath != null)
            OnDeath();

        DeathFX.transform.parent = null;
        DeathFX.PerformFX();
        Destroy(gameObject);

        if (!PlayerPrefs.HasKey("best_score") || PlayerPrefs.GetInt("best_score") < Level.SegmentCompletedCount)
        {
            PlayerPrefs.SetInt("best_score", Level.SegmentCompletedCount);
            PlayerPrefs.SetInt("best_score_level_seed", Level.Seed);
        }

        Level.GetComponent<EndOfLevelGui>().enabled = true;
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
