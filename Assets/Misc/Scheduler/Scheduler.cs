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
 * private ITask _tauntTask = null; 
 * public void TauntEnemy(Enemy enemy) 
 * {
 *      if( _tauntTask != null )
 *          _tauntTask.Exit(); // Only taunt one enemy at a time
 *          
 *      _tauntTask = Scheduler.Run( TauntCoroutine(enemy) );
 *      
 *      // OnExit callback will be called no matter how the coroutine ends
 *      _tauntTask.OnExit(() =>
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
 *      if( _tauntTask != null )
 *          _tauntTask.Exit();
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
	
	private static IEnumerator<IYieldInstruction> SingleInstructionCallback(IYieldInstruction yieldInstruction, Action callback)
	{
		yield return yieldInstruction;
        callback();
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
		private readonly Scheduler _owner;
        public IEnumerator<IYieldInstruction> Coroutine { get; private set; }
		private readonly string _startCoroutineStack;
		
		public SchedulerTask(Scheduler owner, IEnumerator<IYieldInstruction> coroutine)
		{
			_owner = owner;
			Coroutine = coroutine;
		}
		
		// Returns false when the coroutine has completed
		public bool Step()
		{
    		Profiler.BeginSample(Coroutine.ToString());

			bool result;
			try
			{
				result = Coroutine.MoveNext();
				if (!result)
				{
					Coroutine = null;
				}
			}
			finally
			{
    			Profiler.EndSample();
			}
			
			return result;
		}
		
		public bool Ready
		{
			get
			{
				bool result = false;
                if (Coroutine != null && !_exited)
				{
					result = Coroutine.Current.Ready;
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
			get { return Coroutine != null; }
		}

		private bool _exited = false;
		public void Exit()
		{
			if( !_exited )
			{
				if (_onExit != null)
					_onExit();

                _owner.RemoveTask(this);
				_exited = true;
			}
		}
		
		public override string ToString()
		{
			string result = "SchedulerTask: NULL";
			
            if( Coroutine != null )
				result = String.Format("SchedulerTask: {0}", Coroutine.ToString());

			return result;
		}
	}

    private class PendingTask
    {
        public SchedulerTask Task { get; set; }
        public PendingTask Next { get; set; }
        public PendingTask Prev { get; set; }

        public PendingTask GetTail()
        {
            PendingTask itr = this;

            while (itr.Next != null)
                itr = itr.Next;

            return itr;
        }

    }

    private PendingTask _pendingTaskHead = null;
	
	private void RemoveTask(SchedulerTask task)
	{
        for (PendingTask itr = _pendingTaskHead; itr.Next != null; itr = itr.Next )
        {
            if( itr.Task == task )
            {
                if (itr == _pendingTaskHead)
                    _pendingTaskHead = _pendingTaskHead.Next;

                itr.Prev = itr.Next;
    
                if( itr.Next != null )
                    itr.Next.Prev = itr.Prev;

                itr.Task = null;
                itr.Prev = null;
                itr.Next = null;
                return;
            }
        }
	}

    private void AddTask(SchedulerTask task)
    {
        PendingTask newTask = new PendingTask(){Task = task};

        if (_pendingTaskHead == null)
        {
            _pendingTaskHead = newTask;
            return;
        }

        // get tail
        PendingTask tail = _pendingTaskHead.GetTail();

        tail.Next = newTask;
        newTask.Prev = tail;
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
            AddTask(schedulerTask);
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
				_onExit();
		}
	}

    private void ProcessPendingTasks<T>()
    {
        Action<SchedulerTask> taskEnded = task =>
        {
            try
            {
                if( task != null )
                    task.Exit();
            }
            catch (System.Exception e)
            {
                string errorMessage = String.Format("Unhandled Exception during {0}.Exit(): {1}", task, e);
                UnityEngine.Debug.LogError(errorMessage);
            }
            finally
            {
                RemoveTask(task);
            }
        };

        for (PendingTask itr = _pendingTaskHead; itr != null; )
        {
            PendingTask current = itr;
            SchedulerTask task = itr.Task;
            itr = itr.Next;

            try
            {
                if ( task == null || task.Coroutine == null)
                {
                    taskEnded(task);
                }
                // Only run the coroutines of the requested type
                else if (task.Coroutine.Current is T)
                {
                    // Step() is what runs the next iteration of the coroutine 
                    // and returns false when task completed.
                    if (task.Ready && !task.Step())
                       taskEnded(current.Task);
                }
            }
            catch (Exception e)
            {
                UnityEngine.Debug.LogError(String.Format("Unhandled exception during {0}:{1}", task, e));
                taskEnded(current.Task);
            }
        }
    }

    #region MonoBehavior Hooks

    void Update()
    {
        ProcessPendingTasks<IUpdateYield>();
    }

    void LateUpdate()
    {
        ProcessPendingTasks<ILateUpdateYield>();
    }

    void FixedUpdate()
    {
        ProcessPendingTasks<IFixedUpdateYield>();
    }

    #endregion
}

