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
}
