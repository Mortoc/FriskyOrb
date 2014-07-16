using UnityEngine;
using System.Collections;

namespace Procedural
{
	public interface IModifier
	{
		// inline modifies the existing mesh object
		void Modify(Mesh mesh);
	}
}