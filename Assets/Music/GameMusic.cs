using UnityEngine;
using System.Collections.Generic;

public class GameMusic : MonoBehaviour
{
    [SerializeField]
    private float _startDelay = 5.0f;

    [SerializeField]
    private float _fadeInTime = 5.0f;

    [SerializeField]
    private float _volume = 1.0f;

    private System.Collections.IEnumerator Start()
    {
        DontDestroyOnLoad(gameObject);

        yield return new WaitForSeconds(_startDelay);

        GetComponent<AudioSource>().volume = 0.0f;
        GetComponent<AudioSource>().Play();

        // Fade In
        float recipFadeTime = 1.0f / _fadeInTime;
        for (float time = 0.0f; time < _fadeInTime; time += Time.deltaTime)
        {
            yield return 0;
            GetComponent<AudioSource>().volume = Mathf.Lerp(0.0f, _volume, time * recipFadeTime);
        }
        GetComponent<AudioSource>().volume = _volume;

        while (gameObject)
        {
            transform.position = Camera.main.transform.position;
            yield return 0;
        }
    }
}
