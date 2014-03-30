/**  --------------------------------------------------------  *
 *   YieldWhile.cs
 *
 *   Author: Mortoc
 *   Date: 07/22/2009
 *	 
 *   --------------------------------------------------------  *
 */

using System;
using System.Collections.Generic;


// Designed for simple lamdba coroutines to make yield statements more convenient and readable. 
// Example:
// 		yield return new YieldWhile( () => (transform.position - otherPosition).magnitude > 2.0f );

public class YieldWhile : IUpdateYield
{
	private readonly Func<bool> _condition;

    public YieldWhile(Func<bool> condition)
	{
		if( condition == null )
			throw new ArgumentNullException("condition");

        _condition = condition;
	}
	
	public bool Ready
	{
        get { return !_condition(); }
	}
}
