using UnityEngine;
using System.Collections;

public class GroundPlane : MonoBehaviour
{
    private Vector3 _lastCameraPosition;
    private Vector3 _initialCameraOffset;
    private Vector2 _textureOffset = Vector2.zero;

    [SerializeField]
    private float _animateSpeed = 1.0f;

    [SerializeField]
    private string[] _textureNames;
    private Quaternion _initialRotation;

    private SmoothedVector _up = new SmoothedVector(0.5f);

    void Start()
    {
        _lastCameraPosition = Camera.main.transform.position;
        _initialCameraOffset = transform.position - Camera.main.transform.position;
        _initialRotation = transform.rotation;
    }

    void Update()
    {
        if( Input.acceleration.sqrMagnitude > Mathf.Epsilon )
        {
            _up.AddSample(Input.acceleration * -1.0f);

            transform.rotation = Quaternion.Slerp
            (
                _initialRotation,
                Quaternion.LookRotation
                (
                    _up.GetSmoothedVector()
                ),
                0.1f
            );
        }
        

        Vector3 cameraPosition = Camera.main.transform.position;
        Vector3 animDir = _lastCameraPosition - cameraPosition;
        Vector2 uvAnim = new Vector2(animDir.x, animDir.z) * _animateSpeed * Time.deltaTime;
        _textureOffset += uvAnim;
        Material mat = GetComponent<Renderer>().material;
        foreach (string textureName in _textureNames)
        {
            mat.SetTextureOffset(textureName, _textureOffset);
        }


        _lastCameraPosition = cameraPosition;

        transform.position = cameraPosition + _initialCameraOffset;
    }

}
