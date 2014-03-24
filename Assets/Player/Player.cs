using UnityEngine;
using System;
using System.Collections.Generic;

public class Player : MonoBehaviour
{
    public event Action OnFixedUpdate;
    public event Action OnGrounded;
    public event Action OnUngrounded;

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
            if( _controller != null ) 
                _controller.Disable();
            
            _controller = value;
            _controller.Enable();
        } 
    }

    private Vector3 _headingSloped = Vector3.zero;
    private int _groundMask;

    public bool IsGrounded { get; private set; }

    private void UpdateIsGrounded()
    {
        bool grounded = Physics.Raycast(rigidbody.position, Vector3.down, ((SphereCollider)collider).radius, _groundMask);

        if (grounded && !IsGrounded)
            OnGrounded();
        else if (!grounded && IsGrounded)
            OnUngrounded();

        IsGrounded = grounded;
    }

    public Vector3 HeadingOverGroundSlope()
    {
        return _headingSloped;
    }

    public Vector3 Heading { get; set; }

    private float _startingGravity = 0.0f;

    void Start()
    {
        Heading = Vector3.forward;
        OnFixedUpdate += UpdateIsGrounded;
        Controller = new PlayerMovementController(this);

        OnGrounded += BecameGrounded;
        OnUngrounded += BecameUngrounded;

        Level = GameObject.FindObjectOfType<Level>();
        _startingGravity = Physics.gravity.magnitude;
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
            if( approxT > 0.999f)
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

            if( pointOnSegment.y > rigidbody.position.y + _fallToDeathThreshold)
            {
                PlayerDied();
            }
        }

        _groundEffectParticles.transform.position = rigidbody.position - _initialGroundParticleOffset;
    }

    private void PlayerDied()
    {
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
        if (collision.gameObject.layer == LayerMask.NameToLayer("Level"))
        {
            Vector3 headingFlat = Heading;
            headingFlat.y = 0.0f;
            headingFlat.Normalize();

            Vector3 avgNormal = Vector3.zero;
            foreach (ContactPoint cp in collision.contacts)
                avgNormal += cp.normal;

            avgNormal /= (float)collision.contacts.Length;

            float cosTheta = Vector3.Dot(headingFlat, avgNormal);

            Quaternion slopeRotation = Quaternion.AngleAxis(cosTheta * 90.0f, Vector3.Cross(Vector3.up, headingFlat));
            _headingSloped = slopeRotation * Heading;

            Physics.gravity = avgNormal * _startingGravity * -1.0f;
        }

        if (CollisionStay != null)
            CollisionStay(collision);
    }
}
 