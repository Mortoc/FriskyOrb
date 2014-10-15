using System;


public struct Tuple<T1, T2>
{
	public T1 First { get; private set; }
	public T2 Second { get; private set; }
	internal Tuple(T1 first, T2 second)
	{
		First = first;
		Second = second;
	}
}

// New is in a static class to enable type inference, ex:
// var aTuple = Tuple.New(1, "Steve");
public static class Tuple
{
	public static Tuple<T1, T2> New<T1, T2>(T1 first, T2 second)
	{
		return new Tuple<T1, T2>(first, second);
	}
}