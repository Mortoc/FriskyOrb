using UnityEngine;
using System.Collections.Generic;

public class GameMusic : MonoBehaviour
{
    private static GameMusic _instance = null;

    public AudioClip _music;

    void Awake()
    {
        if (_instance)
        {
            Destroy(gameObject);
        }
        else
        {
            GameObject.DontDestroyOnLoad(gameObject);
            _instance = this;

            gameObject.AddComponent<AudioSource>();
            audio.clip = _music;
            audio.Play();

            transform.parent = Camera.main.transform;
            transform.position = Vector3.zero;
        }
    }
}
