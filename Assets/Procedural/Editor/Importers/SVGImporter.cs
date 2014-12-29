using UnityEngine;
using UnityEditor;

using System.Collections.Generic;
using System.Xml;

namespace Procedural.Importers
{

	public class SVGImporter : AssetPostprocessor
	{
		private static IEnumerable<string> ParsePathData(string svgString) 
		{
			var result = new List<string>();
			
			XmlReader xmlReader = XmlReader.Create(new System.IO.StringReader(svgString));
			while (xmlReader.Read())
			{
				if (xmlReader.NodeType == XmlNodeType.Element && xmlReader.LocalName.ToLower() == "path")
					result.Add( xmlReader.GetAttribute("d").ToString().ToLower() );
			}

			return result;
		}

		public static IEnumerable<ISpline> SplinesFromSVG(string svgString) 
		{
			var result = new List<ISpline>();

			foreach(var pathData in ParsePathData(svgString)) 
			{
				
			}

			return result;
		}

		private static void OnPostprocessAllAssets ( string[] importedAssets,
			string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths) 
		{

//			foreach (var str in importedAssets)
//				Debug.Log("Reimported Asset: " + str);
//			
//			foreach (var str in deletedAssets)
//				Debug.Log("Deleted Asset: " + str);
//			
//			for (var i=0;i<movedAssets.Length;i++)
//				Debug.Log("Moved Asset: " + movedAssets[i] + " from: " + movedFromAssetPaths[i]);
//
		}
	}
}
