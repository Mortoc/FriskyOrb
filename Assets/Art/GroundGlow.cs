using UnityEngine;
using System;

public class GroundGlow : MonoBehaviour
{
    private Projector _projector;
    private Vector3 _initialOffset;
    private int _groundLayerMask;

    [SerializeField]
    private float _falloff = 2.0f;
    private float _falloffRecip;
    [SerializeField]
    private Color _initialColor;

    void Start()
    {
        Setup();
    }

    void OnEnable()
    {
        Setup();
    }

    private void Setup()
    {
        _projector = GetComponent<Projector>();
        if (!_projector)
            throw new Exception("No Projector Found");

        _initialOffset = transform.position - transform.parent.position;
        _groundLayerMask = 1 << LayerMask.NameToLayer("Level");

        _falloffRecip = 1.0f / _falloff;
    }

    void Update()
    {
        // always look "down"
        transform.forward = Physics.gravity.normalized;
        transform.position = transform.parent.position + _initialOffset;
        
        RaycastHit rh;
        Debug.DrawLine
        (
            transform.position, 
            transform.position + Physics.gravity.normalized,
            Color.magenta
        );

        if (Physics.Raycast(transform.position, Physics.gravity.normalized, out rh, _falloff, _groundLayerMask))
        {
            _projector.enabled = true;

            _projector.material.color = Color.Lerp
            (
                _initialColor,
                Color.black,
                rh.distance * _falloffRecip
            );
        }
        else
        {
            _projector.enabled = false;
        }
    }
}
