using UnityEngine;
using System;
using System.Collections.Generic;

public class PowerupBar : MonoBehaviour
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

    [SerializeField]
    private AudioClip _activateSound;
    [SerializeField]
    private AudioClip _deactivateSound;

    private InputHandler.CircleTouchRegion _touchRegion;


    void Start()
    {
        // Start the powerup bar on the edge of the screen
        float currentDepth = transform.localPosition.magnitude;
        Vector2 powerupCenter = new Vector2(Screen.width * 0.9f, Screen.height * 0.25f);
        transform.position = Camera.main.ScreenPointToRay(powerupCenter).GetPoint(currentDepth);

        InputHandler input = FindObjectOfType<InputHandler>();
        _touchRegion = new InputHandler.CircleTouchRegion(){
            Center = new Vector2(Screen.width * 0.8f, Screen.height * 0.2f),
            Radius = Mathf.Max(Screen.width, Screen.height) * 0.3f
        };

        input.RegisterTouchRegion(_touchRegion, e =>
        {
            if (this && PowerupReady)
            {
                PowerupReady = false;
                StartCoroutine(UsePowerup());
                e.Consumed = true;
            }
        });
        
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

        if (_currentPowerups >= _powerupsUntilFull && !_animatedToButton)
        {
            StartCoroutine(AnimateToActiveState());
            StartCoroutine(SpinButton());
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

    public bool PowerupReady { get; private set; }

    private System.Collections.IEnumerator SpinButton()
    {
        while (_animatedToButton)
        {
            transform.Rotate(Vector3.forward * 180.0f * Time.deltaTime);
            yield return 0;
        }
    }

    private System.Collections.IEnumerator AnimateToActiveState()
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

            yield return 0;
        }

        PowerupReady = true;
    }

    private System.Collections.IEnumerator UsePowerup()
    {
        _currentPowerups = 0.0f;
        Player player = (Player)GameObject.FindObjectOfType<Player>();
        player.IsImmortal = true;
        float animateTimeRecip = 1.0f / _animateToPlayerTime;
        for (float time = 0.0f; time < _animateToPlayerTime && player; time += Time.deltaTime)
        {
            float t = time * animateTimeRecip;
            float smoothT = Mathf.SmoothStep(0.0f, 1.0f, t);

            transform.position = Vector3.Lerp(transform.position, player.transform.position, smoothT);
            transform.localScale = _animateToPlayerScale.Evaluate(t) * _startScale;
            yield return 0;
        }

        gameObject.layer = _originalLayer;
        gameObject.renderer.enabled = false;

        ExecutePowerup(player);
    }

    private void ExecutePowerup(Player player)
    {
        if (!audio)
            gameObject.AddComponent<AudioSource>();
        audio.clip = _activateSound;
        audio.Play();

        var powerupController = new StarPowerupController(player);
        powerupController.BeforeEndSound = _deactivateSound;
        var originalController = player.Controller;
        
        if (originalController is StarPowerupController)
            throw new InvalidOperationException("Starting Powerup twice in a row");

        player.AnimateColor(Color.white, 0.5f);
        player.Controller = powerupController;
        powerupController.PowerupEnded += () => {
            player.Controller = originalController;
            player.IsImmortal = false;
            player.rigidbody.isKinematic = false;
            ResetPowerup();

            player.AnimateColor(Palette.Instance.Orange, 2.5f);
        };
    }

    private void ResetPowerup()
    {
        StopAllCoroutines();
        gameObject.layer = _originalLayer;
        gameObject.renderer.enabled = true;
        _animatedToButton = false;
        PowerupReady = false;

        SkinnedMeshRenderer smr = GetComponent<SkinnedMeshRenderer>();
        smr.SetBlendShapeWeight(2, 100.0f); // empty state
        smr.SetBlendShapeWeight(0, 0.0f);
        smr.SetBlendShapeWeight(1, 0.0f);

        transform.localPosition = _startPosition;
        transform.localRotation = _startRotation;
        transform.localScale = _startScale;
    }
}
