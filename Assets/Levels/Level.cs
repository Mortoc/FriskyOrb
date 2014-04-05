using UnityEngine;
using System;
using System.Collections.Generic;

public class Level : MonoBehaviour
{
    public static void Start(int levelSeed)
    {
        PlayerPrefs.SetInt("next_level_seed", levelSeed);
        Application.LoadLevel("FriskyOrb");
    }

    public static void StartRandom()
    {
        var seed = UnityEngine.Random.Range(int.MinValue, int.MaxValue);
        Start(seed);
    }

    public static void Replay()
    {
        Start(PlayerPrefs.GetInt("next_level_seed"));
    }

    [Serializable]
    private class SegmentProfile
    {
        public string Name = "";
        public bool AllowsDoodads = true;
        public float Difficulty = 1.0f;
        public AnimationCurve Left = new AnimationCurve();
        public AnimationCurve Right = new AnimationCurve();
    }

    [Serializable]
    private class GeneratorVariables
    {
        public string Name = "";
        public int StartSegment = 0;
        public float ApproxSegmentLength = 20.0f;
        public float SegmentLengthJitter = 5.0f;
        public float Curviness = 15.0f;
        public float MinHeightDifference = 0.0f;
        public float MaxHeightDifference = 0.0f;
        public bool AscendOnly = false;
        public float ChanceOfDoodad = 1.0f; // values over 1 will have a chance for multiple doodads
        public float MaxDoodadDifficulty = 1.0f;
        public float MaxDifficulty = 1.0f;

        public float ChanceOfPowerupString = 0.25f;
        public float PowerupStringAvgLength = 4.0f;
        public float PowerupStringLengthJitter = 1.0f;

        public override string ToString()
        {
            return Name + " [StartSegment: " + StartSegment + "]";
        }
    }

    [SerializeField]
    private Powerup _powerupPrefab;

    [Serializable]
    private class Doodad
    {
        public string Name = "";
        public GameObject Prefab = null;
        public float Difficulty = 1.0f;
    }

    [SerializeField]
    private Doodad[] _doodads;

    [SerializeField]
    private GeneratorVariables[] _tweakables;

    [SerializeField]
    private SegmentProfile[] _segmentProfiles;

    [SerializeField]
    private int _viewDistance = 3;

    [SerializeField]
    private Material _levelTrackMaterial;
    public Material LevelTrackMaterial
    {
        get { return _levelTrackMaterial; }
    }

    [SerializeField]
    private Player _playerPrefab;
    private Player _player;
    private CameraController _camera;

    private int _segmentNumber = 0;
    private int _seed = 2;
    public int Seed
    {
        get { return _seed; }
    }
    private MersenneTwister _rand;

    private LevelSegment _lastSegment;

    [SerializeField]
    private GameObject _endGuiPrefab;

    void Awake()
    {
        if (PlayerPrefs.HasKey("next_level_seed"))
            _seed = PlayerPrefs.GetInt("next_level_seed");
        else
            _seed = UnityEngine.Random.Range(-10000, 10000);

        // Generate Level
        _rand = new MersenneTwister(_seed);

        LevelSegment first = null;
        LevelSegment previous = null;
        for (int i = 0; i < _viewDistance; ++i)
        {
            previous = GenerateNextSegment(previous, true);
            if (first == null)
                first = previous;
        }
        // Since the first segment has no collider, mark it
        // no longer current when the 2nd element gets marked.
        first.Next.OnIsNoLongerCurrent += () =>
        {
            first.IsNoLongerCurrent();
        };
        first.Next.collider.enabled = true;

        InputHandler.BuildInputHandler();

        // Setup Player
        GameObject playerObj = Instantiate(_playerPrefab.gameObject) as GameObject;
        _player = playerObj.GetComponent<Player>();
        _player.transform.position = first.Path.GetPoint(0.1f) + Vector3.up;
        _player.gameObject.name = "Player";
        _player.CurrentSegment = first.Next;
        _player.OnDeath += () => Instantiate(_endGuiPrefab);

        // Setup Camera
        _camera = Camera.main.gameObject.AddComponent<CameraController>();
        _camera.Player = _player;

        SegmentCompletedCount = 1;
    }

    public int SegmentCompletedCount { get; private set; }
    // Called when a segment cleans itself up after the user has passed it
    public void SegmentDestroyed()
    {
        GenerateNextSegment(_lastSegment, false);
    }

    public void NewSegmentReached()
    {
        SegmentCompletedCount++;
        Score.Instance.RegisterEvent(Score.Event.SegmentComplete);
    }

    private LevelSegment GenerateNextSegment(LevelSegment previous, bool initialSegments)
    {
        _segmentNumber++;

        GeneratorVariables tweakables = _tweakables[0];
        foreach (var possibleTweakables in _tweakables)
        {
            if (possibleTweakables.StartSegment >= _segmentNumber)
                break;

            tweakables = possibleTweakables;
        }

        // Generate the control points
        float thisSegmentLength = Mathf.Lerp
        (
            tweakables.ApproxSegmentLength - tweakables.SegmentLengthJitter,
            tweakables.ApproxSegmentLength + tweakables.SegmentLengthJitter,
            _rand.NextSinglePositive()
        );
        float halfSegLength = thisSegmentLength * 0.5f;
        Vector3 a;
        Vector3 aCP;
        Vector3 forwardDirection = Vector3.forward;
        float previousHeight = 0.0f;
        if (previous == null)
        {
            // starting from zero
            a = Vector3.zero;
            aCP = a + Vector3.forward * halfSegLength;
        }
        else
        {
            // starting from the previous position
            // Lerp a back slightly to avoid visual cracks in the meshes
            a = Vector3.Lerp(previous.Path.B.position, previous.Path.B_CP.position, 0.01f);
            previousHeight = previous.Path.B.position.y;
            Vector3 prevBcpDiff = a - previous.Path.B_CP.position;
            aCP = a + prevBcpDiff;
        }

        float rotationRandom = Mathf.Lerp(-1.0f, 1.0f, _rand.NextSingle());
        Quaternion segmentRotation = Quaternion.AngleAxis(tweakables.Curviness * rotationRandom * 2.0f, Vector3.up);
        Vector3 b = a + segmentRotation * (forwardDirection * thisSegmentLength);

        float rotationCPRandom = Mathf.Lerp(-1.0f, 1.0f, _rand.NextSingle());
        Quaternion curveBRotation = Quaternion.AngleAxis(tweakables.Curviness * rotationCPRandom, Vector3.up);
        Vector3 bCP = b - curveBRotation * (forwardDirection * halfSegLength);

        // Prevent creases (if the CPs overlap on any axes, you can get some weird creases in the geometry)
        float halfSegLengthSqr = halfSegLength * halfSegLength;
        if ((a - aCP).sqrMagnitude > halfSegLengthSqr)
        {
            aCP = aCP - a;
            aCP = MathExt.SetVectorLength(aCP, halfSegLength);
            aCP += a;
        }

        if( (b - bCP).sqrMagnitude > halfSegLengthSqr )
        {
            bCP = bCP - b;
            bCP = MathExt.SetVectorLength(bCP, halfSegLength);
            bCP += b;
        }

        // Set Path height
        float elevationChange = Mathf.Lerp
        (
            tweakables.MinHeightDifference, 
            tweakables.MaxHeightDifference, 
            _rand.NextSingle()
        );

        if( !tweakables.AscendOnly && _rand.NextSingle() > 0.5f )
            elevationChange *= -1.0f;
        
        a.y = previousHeight;
        aCP.y = previousHeight;
        b.y = previousHeight + elevationChange;
        bCP.y = previousHeight + elevationChange;

        // Figure out which Profile to use
        uint highestProfile;
        for 
        (
            highestProfile = 0;
            
            highestProfile < _segmentProfiles.Length && 
            _segmentProfiles[highestProfile].Difficulty < tweakables.MaxDifficulty; 

            ++highestProfile
        );

        SegmentProfile profile;

        if (highestProfile > 0)
            profile = _segmentProfiles[(int)(_rand.NextUInt32() % highestProfile)];
        else
            profile = _segmentProfiles[0];

        // Generate the level segment
        LevelSegment.CreationInfo options = new LevelSegment.CreationInfo()
        {
            id = _segmentNumber,
            level = this,
            pntA = a,
            cpA = aCP,
            pntB = b,
            cpB = bCP,
            leftProfile = profile.Left,
            rightProfile = profile.Right,
            previous = previous,
        };
        LevelSegment nextSegment = LevelSegment.Create(options);

        PlaceDoodads(nextSegment, tweakables, profile, thisSegmentLength);
        
        if (previous != null)
            previous.Next = nextSegment;

        _lastSegment = nextSegment;
        return nextSegment;
    }

    private void PlaceDoodads(LevelSegment segment, GeneratorVariables tweakables, SegmentProfile profile, float segmentGeneratedLength)
    {

        // Create the Powerups
        if (_rand.NextSingle() < tweakables.ChanceOfPowerupString)
        {
            float powerupHeight = 0.3f;
            float spacingT = 1.25f;
            float spacingThisSegmentT = spacingT / segmentGeneratedLength;
            float jitter = tweakables.PowerupStringLengthJitter * Mathf.Lerp(-1.0f, 1.0f, _rand.NextSingle());
            int powerupCount = Mathf.FloorToInt(tweakables.PowerupStringAvgLength + jitter);
            float overallLengthT = (float)powerupCount * spacingThisSegmentT;

            float startOffsetT = _rand.NextSingle();
            float endOffsetT = startOffsetT + overallLengthT;

            float offsetWidth = Mathf.Lerp(0.2f, 0.8f, _rand.NextSingle());
            float step = 1.0f / powerupCount;
            float lerpVal = 0.0f;

            for (int i = 0; i < powerupCount; ++i)
            {
                float pathT = Mathf.Lerp(startOffsetT, endOffsetT, lerpVal);
                if (pathT != Mathf.Clamp01(pathT))
                    break;

                var pathSample = segment.GetPathSample(pathT);
                
                lerpVal += step;

                var powerupPosition = Vector3.Lerp(pathSample.Left, pathSample.Right, offsetWidth) + Vector3.up * powerupHeight;
                var powerup = (Powerup)Instantiate(_powerupPrefab);
                powerup.transform.parent = segment.transform;
                powerup.transform.localPosition = powerupPosition;
            }
        }

        // No doodads? Good, we're done here...
        if (!profile.AllowsDoodads)
            return;

        // Get all tweakables that can be used in this segment
        int startIdx = 0;
        int endIdx = 0;
        for (; endIdx < _doodads.Length && _doodads[endIdx].Difficulty <= tweakables.MaxDoodadDifficulty; ++endIdx);

        // There are no doodads usable on this segment, we're done
        if (endIdx == 0)
            return;

        // How many doodads are we using?
        float doodadCountRand = tweakables.ChanceOfDoodad;
        float doodadRemaineder = doodadCountRand - Mathf.Floor(doodadCountRand);
        int doodadCount = Mathf.FloorToInt(doodadCountRand);
        if (_rand.NextSingle() < doodadRemaineder)
            doodadCount++;

        // Create the doodads
        float recpDoodadCount = 1.0f / (float)doodadCount;
        for(int i = 0; i < doodadCount; ++i)
        {
            Doodad doodad = _doodads[_rand.Next(startIdx, endIdx)];
            float doodadT = ((float)i + 1.0f) * recpDoodadCount * _rand.NextSingle();

            LevelSegment.PathSample pathSample = segment.GetPathSample(doodadT);
            if (pathSample.HasSurface)
            {
                bool segmentColliderWasEnabled = segment.collider.enabled;
                Vector3 doodadPosition = Vector3.Lerp(pathSample.Left, pathSample.Right, Mathf.Lerp(0.2f, 0.8f, _rand.NextSingle()));
                RaycastHit rh;
                Ray ray = new Ray(segment.transform.TransformPoint(doodadPosition) + Vector3.up, Vector3.down * 2.0f);
                segment.collider.enabled = true;
                if (Physics.Raycast(ray, out rh, 2.0f))
                {
                    GameObject doodadObj = Instantiate(doodad.Prefab) as GameObject;
                    doodadObj.transform.parent = segment.transform;
                    doodadObj.transform.localPosition = doodadPosition;
                    doodadObj.transform.up = rh.normal;
                    foreach (var doodadRigidbody in doodadObj.GetComponentsInChildren<Rigidbody>())
                    {
                        doodadRigidbody.useGravity = false;
                        doodadRigidbody.Sleep();
                    }
                }
                segment.collider.enabled = segmentColliderWasEnabled;
            }
        }
    }
}
