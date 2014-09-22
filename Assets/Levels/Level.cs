using UnityEngine;
using System;
using System.Collections.Generic;

public class Level : MonoBehaviour
{
    public static void Begin(int levelSeed)
    {
        PlayerPrefs.SetInt("next_level_seed", levelSeed);
        Application.LoadLevel("FriskyOrb");
    }

    public static void StartRandom()
    {
        var seed = UnityEngine.Random.Range(0, FindObjectOfType<LevelNameManager>().NameCount);
        Begin(seed);
    }

    public static void Replay()
    {
        Begin(PlayerPrefs.GetInt("next_level_seed"));
    }


    [SerializeField]
    private Player _playerPrefab;
    private Player _player;
    private CameraController _camera;

    private int _seed = 0;
    public int Seed
    {
        get { return _seed; }
    }
    private MersenneTwister _rand;

    [SerializeField]
    private GameObject _endGuiPrefab;

    public string Name { get; private set; }


    void Awake()
    {
        var levelNames = FindObjectOfType<LevelNameManager>();
        levelNames.ParseNames();

        var count = levelNames.NameCount;

        SetRandomSeed(count);

        // Generate Level
        _rand = new MersenneTwister(_seed);


        InputHandler.BuildInputHandler();

        // Setup Player
        GameObject playerObj = Instantiate(_playerPrefab.gameObject) as GameObject;
        _player = playerObj.GetComponent<Player>();
        //_player.transform.position = first.Path.GetPoint(0.1f) + Vector3.up;
        _player.gameObject.name = "Player";
        _player.OnDeath += () => Instantiate(_endGuiPrefab);

        // Setup Camera
        _camera = Camera.main.gameObject.GetComponent<CameraController>();
        _camera.Player = _player;
    }

    void Start()
    {
        Name = FindObjectOfType<LevelNameManager>().GetName(Seed);
    }

    private void SetRandomSeed(int maxSeed)
    {
        if (PlayerPrefs.HasKey("next_level_seed") &&
             PlayerPrefs.GetInt("next_level_seed") > 0 &&
             PlayerPrefs.GetInt("next_level_seed") < maxSeed)
            _seed = PlayerPrefs.GetInt("next_level_seed");
        else
            _seed = UnityEngine.Random.Range(0, maxSeed);
    }
    
    public void NewSegmentReached()
    {
        Score.Instance.RegisterEvent(Score.Event.SegmentComplete);
    }
}
