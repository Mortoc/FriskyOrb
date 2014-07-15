using UnityEngine;

using System;
using System.Threading;
using NUnit.Framework;

namespace Procedural.Test
{
    [TestFixture]
    [Category("Procedural")]
    internal class Bezier_Test
    {
        [Test]
        public void BeziersAreConstructable()
        {
            Assert.IsNotNull(new Bezier());
        }
    }
}