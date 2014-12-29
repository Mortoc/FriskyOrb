using UnityEngine;
using UnityTest;
using NUnit.Framework;

using System;
using System.Xml;
using System.Collections.Generic;
using System.Linq;


namespace Procedural.Importers.Test
{				
	[TestFixture]
	[Category("Importers")]
	internal class SVGImporter_Test
	{
		private const string SVG_FIXTURE = 
			@"
				  <svg width='190px' height='160px' version='1.1' xmlns='http://www.w3.org/2000/svg'>
					<!-- this is a bunch of cubic paths from the MDN SVG example page -->
					<path d='M10 10 C 20 20, 40 20, 50 10' stroke='black' fill='transparent'/>
					<path d='M70 10 C 70 20, 120 20, 120 10' stroke='black' fill='transparent'/>
					<path d='M130 10 C 120 20, 180 20, 170 10' stroke='black' fill='transparent'/>
					<path d='M10 60 C 20 80, 40 80, 50 60' stroke='black' fill='transparent'/>
					<path d='M70 60 C 70 80, 110 80, 110 60' stroke='black' fill='transparent'/>
					<path d='M130 60 C 120 80, 180 80, 170 60' stroke='black' fill='transparent'/>
					<path d='M10 110 C 20 140, 40 140, 50 110' stroke='black' fill='transparent'/>
					<path d='M70 110 C 70 140, 110 140, 110 110' stroke='black' fill='transparent'/>
					<path d='M130 110 C 120 140, 180 140, 170 110' stroke='black' fill='transparent'/>

					<!-- this last one uses the S syntax that we want to support as well -->
					<path d='M190 10 C 40 10, 65 10, 95 80 S 150 150, 180 80' stroke='black' fill='transparent'/>
				</svg>";

		
		[Test]
		public void ImporterCanParsePathsFromSVG()
		{	
			var splines = SVGImporter.SplinesFromSVG(SVG_FIXTURE);
			Assert.AreEqual(splines.Count(), 10);
		}

		
	}
}
