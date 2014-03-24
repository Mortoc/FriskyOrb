using UnityEngine;
using System;
using System.Collections.Generic;

public class PowerupBar : TappableObject
{
    [SerializeField]
    private float _powerupsUntilFull = 100.0f;
    private float _fullRecip;
    private float _currentPowerups = 0.0f;

    [SerializeField]
    private float _animateToButtonTime = 1.0f;
    [SerializeField]
    private Vector3 _buttonPosition = Vector3.zero;
    private Vector3 _startPosition;
    private Vector3 _startScale;
    private Quaternion _startRotation;
    private bool _animatedToButton = false;

    [SerializeField]
    private float _animateToPlayerTime = 1.0f;
    [SerializeField]
    private AnimationCurve _animateToPlayerScale;
    private int _originalLayer;

    void Start()
    {
        _originalLayer = gameObject.layer;
        _startPosition = transform.localPosition;
        _startScale = transform.localScale;
        _startRotation = transform.localRotation;
        _fullRecip = 1.0f / _powerupsUntilFull;

        ResetPowerup();
    }

    public void CollectedPowerup()
    {
        _currentPowerups += 1.0f;

        if (PowerupReady && !_animatedToButton)
        {
            Scheduler.Run(AnimateToActiveState());
            Scheduler.Run(SpinButton());
        }
        else if (!_animatedToButton)
        {
            float fullPercent = Mathf.Clamp01(_currentPowerups * _fullRecip) * 100.0f;

            SkinnedMeshRenderer smr = GetComponent<SkinnedMeshRenderer>();
            smr.SetBlendShapeWeight(2, 100.0f - fullPercent); // empty state
            smr.SetBlendShapeWeight(1, fullPercent); // full state
        }
    }

    public float PowerupPercent
    {
        get { return Mathf.Clamp01(_currentPowerups / _powerupsUntilFull); }
    }

    public override void Tapped()
    {
        if( PowerupReady )
            Scheduler.Run(UsePowerup());
    }

    private bool PowerupReady
    {
        get
        {
            return _currentPowerups >= _powerupsUntilFull;
        }
    }

    private IEnumerator<IYieldInstruction> SpinButton()
    {
        while (_animatedToButton)
        {
            transform.Rotate(Vector3.forward * 180.0f * Time.deltaTime);
            yield return Yield.UntilNextFrame;
        }
    }

    private IEnumerator<IYieldInstruction> AnimateToActiveState()
    {
        _animatedToButton = true;
        SkinnedMeshRenderer smr = GetComponent<SkinnedMeshRenderer>();
        
        float recipAnimTime = 1.0f / _animateToButtonTime;
        for (float time = 0.0f; time < _animateToButtonTime; time += Time.deltaTime)
        {
            float t = time * recipAnimTime;
            float percentT = t * 100.0f;
            float smoothT = Mathf.SmoothStep(0.0f, 1.0f, t);
            transform.localPosition = Vector3.Lerp(_startPosition, _buttonPosition, smoothT);

            
            smr.SetBlendShapeWeight(1, 100.0f - percentT); // full state
            smr.SetBlendShapeWeight(0, percentT); // button state

            yield return Yield.UntilNextFrame;
        }

        gameObject.layer = LayerMask.NameToLayer("Touchable");
    }

    private IEnumerator<IYieldInstruction> UsePowerup()
    {
        _currentPowerups = 0.0f;
        Player player = (Player)GameObject.FindObjectOfType<Player>();
        float animateTimeRecip = 1.0f / _animateToPlayerTime;
        for (float time = 0.0f; time < _animateToPlayerTime; time += Time.deltaTime )
        {
            float t = time * animateTimeRecip;
            float smoothT = Mathf.SmoothStep(0.0f, 1.0f, t);

            transform.position = Vector3.Lerp(transform.position, player.transform.position, smoothT);
            transform.localScale = _animateToPlayerScale.Evaluate(t) * _startScale;
            yield return Yield.UntilNextFrame;
        }

        gameObject.layer = _originalLayer;
        gameObject.renderer.enabled = false;

        Scheduler.Run(ExecutePowerup());
    }

    private IEnumerator<IYieldInstruction> ExecutePowerup()
    {
        yield return Yield.UntilNextFrame;

        ResetPowerup();
    }

    private void ResetPowerup()
    {
        gameObject.layer = _originalLayer;
        gameObject.renderer.enabled = true;
        _animatedToButton = false;

        SkinnedMeshRenderer smr = GetComponent<SkinnedMeshRenderer>();
        smr.SetBlendShapeWeight(2, 100.0f); // empty state
        smr.SetBlendShapeWeight(0, 0.0f);
        smr.SetBlendShapeWeight(1, 0.0f);

        transform.localPosition = _startPosition;
        transform.localRotation = _startRotation;
        transform.localScale = _startScale;
    }
}
