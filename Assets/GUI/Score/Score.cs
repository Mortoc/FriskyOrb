using UnityEngine;
using System.Collections;

public class Score : MonoBehaviour
{
    public static Score Instance { get; private set; }

    public enum Event
    {
        SegmentComplete,
        StarCollect,
        ExplodeBarrell,
        ActivatePowerup,
        Jump
    }

    [SerializeField]
    private float _pointsAnimateSpeed = 150.0f; // points per second
    public float ActualScore { get; private set; }
    public float ScoreDisplayValue { get; private set; }


    [SerializeField]
    private int SegmentCompleteValue = 10000;

    [SerializeField]
    private int StarCollectValue = 100;

    [SerializeField]
    private int ExplodeBarrellValue = 2000;

    [SerializeField]
    private int ActivatePowerupValue = 7500;

    [SerializeField]
    private int JumpValue = 100;

    void Awake()
    {
        Instance = this;
    }

    public void RegisterEvent(Event e)
    {
        StopAllCoroutines();
        StartCoroutine(AddPoints(GetPointsForEvent(e)));
    }

    private IEnumerator AddPoints(int points)
    {
        ActualScore += (float)points;

        while( ScoreDisplayValue < ActualScore )
        {
            ScoreDisplayValue += Time.deltaTime * _pointsAnimateSpeed;

            if (ScoreDisplayValue > ActualScore)
                ScoreDisplayValue = ActualScore;

            yield return 0;
        }
    }

    private int GetPointsForEvent(Event e)
    {
        switch(e)
        {
            case Event.SegmentComplete:
                return SegmentCompleteValue;
            case Event.StarCollect:
                return StarCollectValue;
            case Event.ExplodeBarrell:
                return ExplodeBarrellValue;
            case Event.ActivatePowerup:
                return ActivatePowerupValue;
            case Event.Jump:
                return JumpValue;
            default:
                throw new System.NotImplementedException("Unexpected Score Event");
        }
    }

}
