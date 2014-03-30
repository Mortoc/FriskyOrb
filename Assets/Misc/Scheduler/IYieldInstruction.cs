/**  --------------------------------------------------------  *
 *   IYieldInstruction.cs  
 *
 *   Author: Mortoc
 *   Date: 06/10/2009
 *	 
 *   --------------------------------------------------------  *
 */


using System;

public interface IYieldInstruction
{
	bool Ready { get; }
}

public interface IUpdateYield : IYieldInstruction {}

public interface ILateUpdateYield : IYieldInstruction {}

public interface IFixedUpdateYield : IYieldInstruction {}
