using UnityEngine;

using System;
using System.Collections.Generic;

namespace RtInfinity.Functional
{
	public static class Functional
	{
		public static IEnumerable<To_T> Map<From_T, To_T>(IEnumerable<From_T> sequence, Func<From_T, To_T> iter)
		{
			foreach (From_T elem in sequence) 
			{
				yield return iter(elem);
			}
		}

		public static IEnumerable<KeyValuePair<T, U>> Zip<T, U>(IEnumerable<T> seq1, IEnumerable<U> seq2)
		{
			var enum1 = seq1.GetEnumerator();
			var enum2 = seq2.GetEnumerator();

			var enum1Live = enum1.MoveNext();
			var enum2Live = enum2.MoveNext();
			while( enum1Live && enum2Live )
			{
				yield return new KeyValuePair<T, U>(enum1.Current, enum2.Current);
				
				enum1Live = enum1.MoveNext();
				enum2Live = enum2.MoveNext();
			}
		}
	}
}