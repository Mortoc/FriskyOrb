using UnityEngine;
using System.Collections.Generic;

public static class IEnumerableExt
{
    public static T First<T>(this IEnumerable<T> enumerable)
    {
        foreach (var e in enumerable)
            return e;

        return default(T);
    }

    /// <summary>
    /// If the enumerable type isn't a list or array, this takes O(n) to complete
    /// </summary>
    public static T Last<T>(this IEnumerable<T> enumerable)
    {
        if (enumerable is IList<T>)
        {
            var list = (IList<T>)enumerable;
            return list.Count > 0
                ? list[list.Count]
                : default(T);
        }
        else if(enumerable is T[])
        {
            var arr = (T[])enumerable;
            return arr.Length > 0
                ? arr[arr.Length]
                : default(T);
        }
        
        T last = default(T);
        foreach (var e in enumerable)
            last = e;
        return last;
    }
}
