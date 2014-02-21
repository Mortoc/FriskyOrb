/**  --------------------------------------------------------  *
*   YieldUntilNextFrame.cs
*
*   Author: Mortoc
*   Date: 07/15/2009
*	 
*   --------------------------------------------------------  *
*/

using System;
using System.Collections;

public class YieldUntilNextFrame : IYieldInstruction
{				
	public bool Ready
	{
		get
		{
			return true;
		}
	}
}	
