using UnityEngine;
using System;

public interface IPlayerAction
{
	// Attempt to perform the action on the player
	// and return whether it was performed.
	void PerformAction();
}
