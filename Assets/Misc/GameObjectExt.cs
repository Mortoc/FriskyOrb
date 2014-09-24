using UnityEngine;

using System;
using System.Collections.Generic;

namespace RtInfinity
{
	public static class GameObjectExt
	{
		public static T GetOrAddComponent<T>(this GameObject gameObject) where T: Component
		{
			var result = gameObject.GetComponent<T>();
			if( !result )
				result = gameObject.AddComponent<T>();
			return result;
		}
	}
}