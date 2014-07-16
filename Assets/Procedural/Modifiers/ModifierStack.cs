using UnityEngine;
using System.Collections.Generic;

namespace Procedural
{
	public class ModifierStack : MonoBehaviour 
	{
		private List<IModifier> _modifierStack = new List<IModifier>();

		public void AddModifier(IModifier modifier)
		{
			_modifierStack.Add(modifier);
		}

		public void Collapse()
		{
			var mesh = GetComponent<MeshFilter>().mesh;
			foreach(var modifier in _modifierStack)
			{
				modifier.Modify(mesh);
			}
			mesh.Optimize();
			mesh.RecalculateBounds();
		}
	}
}