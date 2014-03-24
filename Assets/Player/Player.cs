using UnityEngine;
using System;
using System.Collections.Generic;

public class Player : MonoBehaviour
{
    [SerializeField]
    private float _acceleration = 1250.0f;
    [SerializeField]
    private float _steerSpeed = 100.0f;
    [SerializeField]
    private float _counterSteerAccel = -0.1f;
    [SerializeField]
    private ParticleSystem _groundEffectParticles = null;
    private Vector3 _initialGroundParticleOffset;

    [SerializeField]
    private float _fallToDeathThreshold = 10.0f;

    [SerializeField]
    private Transform _blackHoleSphere;
    private float _blackHoleSphereOffset;

    public FX JumpFX;
    public FX DeathFX;
    public FX PowerupFX;

    public Level Level { get; set; }
    public LevelSegment CurrentSegment { get; set; }
    public InputHandler InputHandler { get; set; }

    public IPlayerAction CurrentAction { get; set; }

    private Vector3 _headingSloped = Vector3.zero;
    private int _groundMask;

    private void BecameGrounded()
    {
        _groundEffectParticles.enableEmission = true;
    }

    private void BecameUngrounded()
    {
        _groundEffectParticles.enableEmission = false;
    }

    private int _frameForGrounded = -1;
    private bool _isGrounded = false;
    public bool IsGrounded()
    {
        if (Time.frameCount > _frameForGrounded)
        {
            bool grounded = Physics.Raycast(rigidbody.position, Vector3.down, ((SphereCollider)collider).radius, _groundMask);

            if (grounded && !_isGrounded)
                BecameGrounded();
            else if (!grounded && _isGrounded)
                BecameUngrounded();

            _frameForGrounded = Time.frameCount;
            _isGrounded = grounded;
        }
        return _isGrounded;
    }

    public Vector3 HeadingOverGroundSlope()
    {
        return _headingSloped;
    }

    private Vector3 _heading = Vector3.forward;
    public Vector3 Heading 
    { 
        get { return _heading;  } 
    }
    private JumpAction _jumpAction;

    private float _startingGravity = 0.0f;

    private Level _level;

    void Start()
    {
        _level = (Level)GameObject.FindObjectOfType<Level>();
        _startingGravity = Physics.gravity.magnitude;
        GameObject.FindObjectOfType<LevelGui>().Player = this;
        _groundMask = 1 << LayerMask.NameToLayer("Level");
        _jumpAction = new JumpAction(this);
        rigidbody.useConeFriction = true;
        InputHandler.OnAction += _jumpAction.PerformAction;
        
        _groundEffectParticles.transform.parent = null;
        _initialGroundParticleOffset = transform.position - _groundEffectParticles.transform.position;

        
        _blackHoleSphereOffset = (_blackHoleSphere.position - transform.position).magnitude;
    }

    void Update()
    {
        Vector3 playerToCameraDir = (Camera.main.transform.position - transform.position).normalized;
        _blackHoleSphere.position = transform.position + _blackHoleSphereOffset * playerToCameraDir;
    }

    void FixedUpdate()
    {
        if (IsGrounded())
        {
            _jumpAction.UserLanded();
            Steer();
            RollForward();
        }

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

        if (!PlayerPrefs.HasKey("best_score") || PlayerPrefs.GetInt("best_score") < _level.SegmentCompletedCount)
        {
            PlayerPrefs.SetInt("best_score", _level.SegmentCompletedCount);
            PlayerPrefs.SetInt("best_score_level_seed", _level.Seed);
        }

        _level.GetComponent<EndOfLevelGui>().enabled = true;
    }

    private void RollForward()
    {
        Vector3 rollAxis = Vector3.Cross(Vector3.up, _heading);
        rigidbody.AddTorque(rollAxis * Time.fixedDeltaTime, ForceMode.Impulse);

        float steerAmount = Mathf.Abs(InputHandler.SteeringAmount());
        float counterAccel = Mathf.Lerp(0.0f, _counterSteerAccel, steerAmount); // reduce accleration while turning hard

        Vector3 accel = HeadingOverGroundSlope() * _acceleration * Time.fixedDeltaTime;
        rigidbody.AddForce(accel, ForceMode.Acceleration);
        rigidbody.AddForce(accel * counterAccel, ForceMode.Impulse);    
    }

    private void Steer()
    {
        float steerAmount = InputHandler.SteeringAmount();
        Quaternion steerRot = Quaternion.AngleAxis(steerAmount * _steerSpeed * Time.fixedDeltaTime, Vector3.up);
        _heading = steerRot * _heading;
        Vector3 right = Vector3.Cross(Vector3.up, _heading) * steerAmount;
        rigidbody.AddForce(right * Time.fixedDeltaTime * 100.0f, ForceMode.Impulse);
    }

    public event Action<Collision> CollisionEntered;
    void OnCollisionEnter(Collision collision)
    {
        if (CollisionEntered != null)
            CollisionEntered(collision);
    }
    
    public event Action<Collision> CollisionExited;
    void OnCollisionExit(Collision collision)
    {
        if (CollisionExited != null)
            CollisionExited(collision);
    }

    void OnCollisionStay(Collision collision)
    {
        if (collision.gameObject.layer == LayerMask.NameToLayer("Level"))
        {
            Vector3 headingFlat = _heading;
            headingFlat.y = 0.0f;
            headingFlat.Normalize();

            Vector3 avgNormal = Vector3.zero;
            foreach (ContactPoint cp in collision.contacts)
                avgNormal += cp.normal;

            avgNormal /= (float)collision.contacts.Length;

            float cosTheta = Vector3.Dot(headingFlat, avgNormal);

            Quaternion slopeRotation = Quaternion.AngleAxis(cosTheta * 90.0f, Vector3.Cross(Vector3.up, headingFlat));
            _headingSloped = slopeRotation * _heading;

            Physics.gravity = avgNormal * _startingGravity * -1.0f;
        }
        else
        {
            // If there is no ground here, just use heading
            _headingSloped = _heading;
        }
    }
}
 