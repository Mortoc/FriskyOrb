using UnityEngine;

using System;
using System.Collections.Generic;

public static class Functional
{
	public static IEnumerable<To_T> Map<From_T, To_T>(IEnumerable<From_T> sequence, Func<From_T, To_T> iter)
	{
		foreach (From_T elem in sequence) 
		{
			yield return iter(elem);
		}
	}

	public static T First<T>(this IEnumerable<T> sequence) // replacement for the LINQ First func
	{
		var enumerator = sequence.GetEnumerator();
		enumerator.MoveNext();
		return enumerator.Current;
	}
}
