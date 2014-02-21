/**  --------------------------------------------------------  *
 *   Scheduler.cs  
 *
 *   Author: Mortoc
 *   Date: 07/15/2009
 *	 
 *   --------------------------------------------------------  *
 */

using UnityEngine;

using System;
using System.Collections.Generic;

// Replacement for MonoBehaviour.StartCoroutine that adds a few pieces of functionality:
//  1. You can externally exit a coroutine by calling ITask.Exit
//  2. You can easily write custom yield instructions using the IYieldInstruction or IFixedYieldInstruction interface
//  3. You no longer have to include System.Collections since these are based on IEnumerator<IYieldInstruction>
//  4. There is no longer any .Net -> Native transition overhead

/*
 * Example Usage: (A hypothetical game character with a taunt ability)
 * 
 * private ITask mTauntTask = null; 
 * public void TauntEnemy(Enemy enemy) 
 * {
 *      if( mTauntTask != null )
 *          mTauntTask.Exit(); // Only taunt one enemy at a time
 *          
 *      mTauntTask = Scheduler.Run( TauntCoroutine(enemy) );
 *      
 *      // OnExit callback will be called no matter how the coroutine ends
 *      mTauntTask.OnExit(() =>
 *      {
 *          enemy.UnlockDirection();
 *          enemy.UnlockTarget();
 *      });
 * }
 * 
 * private IEnumerator<IYieldInstruction> TauntCoroutine(Enemy enemy)
 * {
 *      enemy.LockDirection( transform.position - enemy.transform.position );
 *      enemy.LockTarget( this );
 *      
 *      float startTime = Time.time;
 *      float tauntEndTime = startTime + this.tauntLength;
 *      
 *      yield return new YieldWhile( () => enemy.IsAlive() && Time.time < tauntEndTime );
 * 
 *      this.RefreshTauntAbility();
 *      enemy.TakeDamage( this.tauntEndDamage );
 * }
 * 
 * public void UnitSilenced()
 * {
 *      // We can control the coroutine from external events without having to add new code inside the coroutine
 *      if( mTauntTask != null )
 *          mTauntTask.Exit();
 * }
*/




public class Scheduler : MonoBehaviour
{
	private static Scheduler instance { get; set; }
	
	public static ITask Run(IEnumerator<IYieldInstruction> coroutine)
	{
		if( instance == null )
			throw new InvalidOperationException("Cannot start a coroutine before Scheduler.Awake");
		
		return instance.StartCoroutine(coroutine);
	}
	
	public static void Run(IYieldInstruction yieldInstruction, Action action)
	{
		Run(SingleInstructionCallback(yieldInstruction, action));
	}
	
	private static IEnumerator<IYieldInstruction> SingleInstructionCallback(IYieldInstruction yieldInstruction, Action action)
	{
		yield return yieldInstruction;
		action();
	}
	
	void Awake()
	{
		if( instance )
			Destroy(instance);
		
		instance = this;
	}
	
	// Represents a single task that is being run in this Scheduler
	private class SchedulerTask : ITask
	{
        private static readonly bool DEBUG_TASKS = false;

		private readonly Scheduler _owner;
		private IEnumerator<IYieldInstruction> _coroutine;
		private readonly string _startCoroutineStack;
		public string StartCoroutineStack
		{
			get { return _startCoroutineStack; }
		}
		
		public SchedulerTask(Scheduler owner, IEnumerator<IYieldInstruction> coroutine)
		{
			_owner = owner;
			_coroutine = coroutine;

            if (DEBUG_TASKS)
                _startCoroutineStack = Environment.StackTrace;
            else
                _startCoroutineStack = String.Empty;
		}
		
		// Returns false when the coroutine has completed
		public bool Step()
		{
            if (DEBUG_TASKS)
    			Profiler.BeginSample(_coroutine.ToString());

			bool result;
			try
			{
				result = _coroutine.MoveNext();
				if (!result)
				{
					_coroutine = null;
				}
			}
			finally
			{
                if (DEBUG_TASKS)
    				Profiler.EndSample();
			}
			
			return result;
		}
		
		public bool Ready
		{
			get
			{
				bool result = false;
                if (_coroutine != null && !_exited)
				{
					result = _coroutine.Current.Ready;
				}
				return result;
			}
		}
		
		private Action _onExit = null;
		public void AddOnExitAction(Action callback)
		{
			_onExit += callback;
		}

		public bool IsRunning
		{
			get { return _coroutine != null; }
		}

		private bool _exited = false;
		public void Exit()
		{
			if( !_exited )
			{
				if (_onExit != null)
					_onExit();

				_owner.TaskExited(this);
				_exited = true;
			}
		}
		
		public override string ToString()
		{
			string result = "SchedulerTask: NULL";
			
            if( _coroutine != null )
				result = String.Format("SchedulerTask: {0}", _coroutine.ToString());

			return result;
		}
	}
	
	private List<SchedulerTask> _pendingTasks = new List<SchedulerTask>(); 
	
	private void TaskExited(SchedulerTask task)
	{
		_pendingTasks.Remove(task);
	}
	
	public ITask StartCoroutine( IEnumerator<IYieldInstruction> task )
	{
		if( task == null )
			throw new ArgumentNullException("task");

		ITask result;

		// IEnumerators start 'before the first location', so calling this once here gets the task ready to execute
		if (task.MoveNext())
		{
			SchedulerTask schedulerTask = new SchedulerTask(this, task);
			result = schedulerTask;
            _pendingTasks.Add(schedulerTask);

		}
		else
		{
			// This coroutine never yielded, so it's execution is complete
			result = new EmptyTask();
		}

		return result;
	}

	private class EmptyTask : ITask
	{
		private Action _onExit = null;
		public bool IsRunning
		{
			get { return false; }
		}

		public void AddOnExitAction(Action onExit)
		{
			_onExit += onExit;
		}

		public void Exit()
		{
			if( _onExit != null )
			{
				_onExit();
			}
		}
	}

	public void Update()
	{
		List<SchedulerTask> completedTasks = new List<SchedulerTask>(); 

		for (int i = 0; i < _pendingTasks.Count; ++i)
		{		
			SchedulerTask coroutine = _pendingTasks[i];
			try
			{				
				// Run the coroutine.
                // Step() is what runs the next iteration of the coroutine and returns false when task completed.
				if( coroutine.Ready && !coroutine.Step() ) 
					completedTasks.Add(coroutine);
			}
			catch(Exception e)
			{
                // This step had an unhandled excception, exit the task and report it
                completedTasks.Add(coroutine);

                if (!String.IsNullOrEmpty(coroutine.StartCoroutineStack))
                {
                    UnityEngine.Debug.LogError
                    (
                        String.Format
                        (
                            "Unhandled exception during {0}:{1}\n\nStarted At:\n{2}",
                            coroutine,
                            e,
                            coroutine.StartCoroutineStack
                        )
                    );
                }
                else
                {
                    UnityEngine.Debug.LogError( String.Format("Unhandled exception during {0}:{1}", coroutine, e) );
                }
			}
		}

		foreach (SchedulerTask task in completedTasks)
		{
            try
            {
                task.Exit();
            }
            catch (System.Exception e)
            {
                string errorMessage = String.Format("Unhandled Exception during {0}.Exit(): {1}", task, e);
                UnityEngine.Debug.LogError(errorMessage);
            }
            finally
            {
                _pendingTasks.Remove(task);
            }
		}
	}
}

