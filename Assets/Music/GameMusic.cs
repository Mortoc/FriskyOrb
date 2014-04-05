using UnityEngine;
using System.Collections.Generic;

public class GameMusic : MonoBehaviour
{
    public AudioClip _music;

    [SerializeField]
    private float _startDelay = 5.0f;

    [SerializeField]
    private float _fadeInTime = 5.0f;

    [SerializeField]
    private float _volume = 1.0f;

    private System.Collections.IEnumerator Start()
    {
        transform.parent = Camera.main.transform;
        transform.localPosition = Vector3.zero;

        gameObject.AddComponent<AudioSource>();
        audio.loop = true;

        yield return new WaitForSeconds(_startDelay);

        audio.clip = _music;
        
        audio.Play();

        // Fade In
        audio.volume = 0.0f;
        float recipFadeTime = 1.0f / _fadeInTime;
        for (float time = 0.0f; time < _fadeInTime; time += Time.deltaTime)
        {
            yield return 0;
            audio.volume = Mathf.Lerp(0.0f, _volume, time * recipFadeTime);
        }
        audio.volume = _volume;
    }
}
