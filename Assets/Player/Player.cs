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
    private float _hillClimbAssist = 0.5f;
    [SerializeField]
    private float _counterSteerAccel = -0.1f;

    public FX JumpFX;


    public Level Level { get; set; }
    public LevelSegment CurrentSegment { get; set; }
    public InputHandler InputHandler { get; set; }

    public IPlayerAction CurrentAction { get; set; }

    private int _lastGroundedCheck = 0;
    private bool _isGroundedCached = true;
    private Vector3 _headingSlopedCached = Vector3.zero;
    private void UpdateGroundData()
    {
        // Only calculate if we're grounded once per frame
        if (_lastGroundedCheck != Time.frameCount)
        {
            SphereCollider playerCollider = GetComponent<SphereCollider>();
            float avgScale = (transform.lossyScale.x + transform.lossyScale.y + transform.lossyScale.z) / 3.0f;
            float rayDistance = avgScale * playerCollider.radius * 1.1f;
            int groundLayerMask = 1 << LayerMask.NameToLayer("Level");

            RaycastHit underPlayerCastInfo;
            _isGroundedCached = Physics.Raycast(rigidbody.position, Vector3.down, out underPlayerCastInfo, rayDistance, groundLayerMask);

            if (_isGroundedCached)
            {
                Vector3 headingFlat = _heading;
                headingFlat.y = 0.0f;
                headingFlat.Normalize();

                float cosTheta = Vector3.Dot(headingFlat, underPlayerCastInfo.normal);

                Quaternion slopeRotation = Quaternion.AngleAxis(cosTheta * 90.0f, Vector3.Cross(Vector3.up, headingFlat));
                _headingSlopedCached = slopeRotation * _heading;
            }
            else
            {
                // If there is no ground here, just use heading
                _headingSlopedCached = _heading;
            }
            _lastGroundedCheck = Time.frameCount;
        }
    }

    public bool IsGrounded()
    {
        UpdateGroundData();
        return _isGroundedCached;
    }

    public Vector3 HeadingOverGroundSlope()
    {
        UpdateGroundData();
        return _headingSlopedCached;
    }

    private Vector3 _heading = Vector3.forward;
    private JumpAction _jumpAction;

    public Vector3 Heading
    {
        get { return _heading; }
    }


    void Start()
    {
        _jumpAction = new JumpAction(this);
        rigidbody.useConeFriction = true;
        InputHandler.OnAction += () =>
        {
            //if (CurrentAction != null)
            //    CurrentAction.PerformAction();
            _jumpAction.PerformAction();
        };
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
            if (approxT > 0.999f)
            {
                LevelSegment oldSegment = CurrentSegment;
                CurrentSegment = CurrentSegment.Next;
                oldSegment.IsNoLongerCurrent();
            }
        }
    }

    private void RollForward()
    {
        Vector3 rollAxis = Vector3.Cross(Vector3.up, _heading);
        rigidbody.AddTorque(rollAxis * Time.fixedDeltaTime, ForceMode.Impulse);

        float steerAmount = Mathf.Abs(InputHandler.SteeringAmount());
        float counterAccel = Mathf.Lerp(0.0f, _counterSteerAccel, steerAmount); // reduce accleration while turning hard

        float hillFactor = 1.0f + ((1.0f - Vector3.Dot(_heading, HeadingOverGroundSlope())) * _hillClimbAssist);

        Debug.DrawLine(rigidbody.position, rigidbody.position + (3.0f * _heading), Color.red);
        Debug.DrawLine(rigidbody.position, rigidbody.position + (3.0f * HeadingOverGroundSlope()), Color.blue);
        Vector3 accel = HeadingOverGroundSlope() * _acceleration * Time.fixedDeltaTime * hillFactor;
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
}
