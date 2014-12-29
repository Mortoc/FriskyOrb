using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace Procedural
{
	public static class Print
	{
		public static void Log(params object[] objs)
		{
			var sb = new StringBuilder();
			foreach(var obj in objs) 
			{
				if( sb.Length != 0 )
					sb.Append(", ");

				if( obj is IEnumerable && !(obj is String) ) 
				{
					foreach(var subObj in obj as IEnumerable) 
					{
						sb.Append(subObj.ToString());
						sb.Append(", ");
					}
					sb.Remove(sb.Length - 2, 2);
				}
				else 
				{
					sb.Append(obj.ToString());
				}
			}
			Debug.Log(sb.ToString());
		}
	}
}