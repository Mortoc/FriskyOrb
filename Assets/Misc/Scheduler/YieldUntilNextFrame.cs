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


public class YieldUntilNextFrame : IUpdateYield
{				
	public bool Ready
	{
		get{ return true; }
	}
}

public class YieldUntilNextFixedUpdate : IFixedUpdateYield
{
    public bool Ready
    {
        get { return true; }
    }
}	

