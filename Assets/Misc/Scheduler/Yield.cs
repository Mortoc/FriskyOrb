using UnityEngine;
using System.Collections.Generic;

public static class Yield
{
	public static readonly IYieldInstruction UntilNextFrame = new YieldUntilNextFrame();
}
