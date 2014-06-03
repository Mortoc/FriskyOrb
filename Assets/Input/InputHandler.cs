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
    public event Action OnJump;
	public event Action OnEndJump;

    protected void Jump()
    {
        if (OnJump != null)
            OnJump();
    }

	protected void EndJump()
	{
		if (OnEndJump != null)
			OnEndJump ();
	}

    public interface ITouchRegion
    {
        bool Contains(Vector3 cursorPos);
    }

    public class TouchEvent
    {
        public Vector3 CursorPosition { get; set; }
        public bool Consumed { get; set; }
    }

    public class CircleTouchRegion : ITouchRegion
    {
        public Vector3 Center { get; set; }
        public float Radius { get; set; }

        public bool Contains(Vector3 cursorPos)
        {
            return (Center - cursorPos).sqrMagnitude < (Radius * Radius);
        }
    }

    public class RectTouchRegion : ITouchRegion
    {
        public Rect Rect;

        public bool Contains(Vector3 cursorPos)
        {
            return Rect.Contains(cursorPos);
        }
    }

    private Dictionary<ITouchRegion, Action<TouchEvent>> _touchRegions = new Dictionary<ITouchRegion, Action<TouchEvent>>();

    public void RegisterTouchRegion(ITouchRegion touchRegion, Action<TouchEvent> callback)
    {
        _touchRegions.Add(touchRegion, callback);
    }

    public void RemoveTouchRegion(ITouchRegion touchRegion)
    {
        _touchRegions.Remove(touchRegion);
    }

    // Returns true when the touch event was consumed
    protected bool ExecuteTouchAt(Vector3 screenPos)
    {
        TouchEvent tEvent = new TouchEvent() { CursorPosition = screenPos, Consumed = false };

        foreach(var kvp in _touchRegions)
        {
            if( kvp.Key.Contains(screenPos) )
            {
                kvp.Value(tEvent);

                if (tEvent.Consumed)
                    return true;
            }
        }

        return false;
    }
}
