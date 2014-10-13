using UnityEngine;
using UnityTest;
using NUnit.Framework;

using System;
using System.Collections.Generic;

namespace RtInfinity.Functional.Test
{
	[TestFixture]
	[Category("Misc")]
	internal class Functional_Zip_Test
	{
		[Test]
		public void ZipWorksOnEqualLengthSequences()
		{
			var enum1 = new string[]{"1", "2", "3", "4"};
			var enum2 = new int[]{1, 2, 3, 4};
			var zipped = new List<KeyValuePair<string, int>>(Functional.Zip (enum1, enum2));

			Assert.AreEqual(4, zipped.Count);

			foreach(var kvp in zipped)
			{
				Assert.AreEqual(int.Parse(kvp.Key), kvp.Value);
			}
		}

		[Test]
		public void ZipWorksWithDifferentLengthArrays()
		{
			var enum1 = new string[]{"1", "2", "3", "4", "5", "6"};
			var enum2 = new int[]{1, 2, 3, 4};
			var zipped = new List<KeyValuePair<string, int>>(Functional.Zip (enum1, enum2));
			
			Assert.AreEqual(4, zipped.Count);
			
			foreach(var kvp in zipped)
			{
				Assert.AreEqual(int.Parse(kvp.Key), kvp.Value);
			}
		}
	}
}