using System;
using System.Collections.Generic;

public interface IReceipt
{
	void Exit();
}	

public interface ITask : IReceipt
{
	bool IsRunning { get; }
	void AddOnExitAction(Action onExit);
}

public class Receipt : IReceipt
{
	private readonly Action _exitCallback;

	public Receipt(Action onExit)
	{
		if( onExit == null )
			onExit = delegate() {};
		
		_exitCallback = onExit;
	}
	
	public void Exit()
	{
		_exitCallback();
	}
}	

