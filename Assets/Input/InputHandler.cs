using UnityEngine;
using System;
using System.Collections.Generic;

public abstract class InputHandler : MonoBehaviour
{
    public static InputHandler BuildInputHandler()
    {
        GameObject inputObj = new GameObject("Input Handler");

        InputHandler result = null;

        switch (Application.platform)
        {
            case RuntimePlatform.Android:
            case RuntimePlatform.BB10Player:
            case RuntimePlatform.IPhonePlayer:
            case RuntimePlatform.MetroPlayerARM:
            case RuntimePlatform.WP8Player:
                result = inputObj.AddComponent<MobileInputHandler>();
                break;
            default:
                result = inputObj.AddComponent<PCInputHandler>();
                break;
        }

        return result;
    }

    // Returns a float in the range [0..1]
    public abstract float SteeringAmount();

    // User has activated their current action (default jump)
    public event Action OnAction;

    protected void ExecuteAction()
    {
        if (OnAction != null)
            OnAction();
    }

    // Returns true when the touch event should be consumed
    protected bool ExecuteTouchAt(Vector3 screenPos)
    {
        Ray touchRay = Camera.main.ScreenPointToRay(screenPos);

        //Debug.DrawRay(touchRay.origin, touchRay.direction * 1000.0f, Color.red);
        //Debug.Break();

        foreach (RaycastHit rh in Physics.RaycastAll(touchRay, Mathf.Infinity, 1 << LayerMask.NameToLayer("Touchable")))
        {
            TappableObject tappable = rh.collider.GetComponent<TappableObject>();
            if (tappable)
                tappable.Tapped();
        }
        return false;
    }
}
