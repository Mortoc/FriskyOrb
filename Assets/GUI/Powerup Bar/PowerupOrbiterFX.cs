using UnityEngine;
using System.Collections;

public class PowerupOrbiterFX : MonoBehaviour
{
    public Transform OrbitObj { get; set; }
    public float OrbitRadius { get; set; }
    public float OrbitSpeed { get; set; }

    private SmoothedVector _orbitAxis = new SmoothedVector(1.0f);

    void Start()
    {
        transform.parent = OrbitObj;
        transform.localPosition = UnityEngine.Random.onUnitSphere * OrbitRadius;
    }

    void Update()
    {
        _orbitAxis.AddSample(UnityEngine.Random.onUnitSphere);
        transform.RotateAround(OrbitObj.position, _orbitAxis.GetSmoothedVector(), OrbitSpeed * Time.deltaTime);
    }
}
