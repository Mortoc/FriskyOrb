using UnityEngine;

using System;
using System.Collections.Generic;

using SimpleJSON;

using Procedural;

namespace RtInfinity.Levels
{
	public class TrackGenerator
	{
		[Serializable]
		private struct MinMaxVal
		{
			public float Min { get; set; }
			public float Max { get; set; }
			public float Random(MersenneTwister rand)
			{
				return Mathf.Lerp (Min, Max, rand.NextSingle());
			}
			public override string ToString ()
			{
				return string.Format ("[MinMaxVal: Min={0}, Max={1}]", Min, Max);
			}
		}
		
		[Serializable]
		private struct TrackSegmentSettings
		{
			public MinMaxVal Scale { get; set; }
			public MinMaxVal Length { get; set; }
			public MinMaxVal Curviness { get; set; }
			public Material Material { get; set; }
			public override string ToString ()
			{
				return string.Format ("[TrackSegmentSettings: Scale={0}, Length={1}, Curviness={2}, Material={3}]", Scale, Length, Curviness, Material);
			}
		}

		[Serializable]
		private struct SettingsSection
		{
			public string Name { get; set; }
			public TrackSegmentSettings Segment { get; set; }
			public override string ToString ()
			{
				return string.Format ("[SettingsSection: Name={0}, Segment={1}]", Name, Segment);
			}
		}

		private SettingsSection[] _settings;
		private MersenneTwister _rand;

		public TrackGenerator(MersenneTwister rand, string settingsJson)
		{
			_rand = rand;
			LoadSettings(settingsJson);
		}

		private TrackSegmentSettings LoadSegment(JSONNode segmentJson)
		{
			var material = (Material)Resources.Load(segmentJson["material"]);
			if( !material )
				material = new Material(Shader.Find("Mobile/Diffuse"));

			return new TrackSegmentSettings(){
				Scale = new MinMaxVal(){ 
					Min = segmentJson["scale"]["min"].AsFloat,
					Max = segmentJson["scale"]["max"].AsFloat
				},
				Length = new MinMaxVal(){ 
					Min = segmentJson["length"]["min"].AsFloat,
					Max = segmentJson["length"]["max"].AsFloat
				},
				Curviness = new MinMaxVal(){ 
					Min = segmentJson["curivness"]["min"].AsFloat,
					Max = segmentJson["curivness"]["max"].AsFloat
				},
				Material = material
			};
		}

		private void LoadSettings(string settingsJson)
		{
			var parsedJson = JSON.Parse(settingsJson);
			_settings = new SettingsSection[parsedJson.Count];

			var i = 0;
			foreach(var sectionJson in parsedJson.Childs)
			{
				_settings[i].Name = sectionJson["name"].Value;
				_settings[i].Segment = LoadSegment(sectionJson["segment"]);
				i++;
			}
		}

		public Loft BuildSegmentLoft(TrackSegment prevSegment, int section)
		{
			var path = BuildPath(prevSegment, _settings[section]);
			var shape = BulidShape(prevSegment, _settings[section]);

			return new Loft(path, shape);
		}

		private ISpline BulidShape(TrackSegment prevSegment, SettingsSection settings)
		{
			var width = 1.0f;
			var height = 0.5f;
			var cornerRadius = 0.025f;

			var left = width * -0.5f;
			var right = width * 0.5f;
			var bottom = 0.0f;
			var top = height;

			var shape = new Bezier(new Bezier.ControlPoint[]{
				new Bezier.ControlPoint(new Vector3(66.0462f, 0.0f, -18.3079f), new Vector3(102.181f, 0.0f, 20.3476f), new Vector3(164.366f, 0.0f, 12.7845f)),
				new Bezier.ControlPoint(new Vector3(226.55f, 0.0f, 5.2215f), new Vector3(224.87f, 0.0f, 16.9862f), new Vector3(229.912f, 0.0f, 40.5156f)),
				new Bezier.ControlPoint(new Vector3(234.954f, 0.0f, 64.045f), new Vector3(110.584f, 0.0f, 57.3223f), new Vector3(110.584f, 0.0f, 57.3223f)),
				new Bezier.ControlPoint(new Vector3(66.0462f, 0.0f, -18.3079f), new Vector3(102.181f, 0.0f, 20.3476f), new Vector3(164.366f, 0.0f, 12.7845f))
			});

//			var shape = Bezier.ConstructSmoothSpline(new Vector3[]{
//				new Vector3(left + cornerRadius, 0.0f, bottom),
//				new Vector3(left, 0.0f, bottom + cornerRadius),
//				new Vector3(left, 0.0f, top - cornerRadius),
//				new Vector3(left + cornerRadius, 0.0f, top),
//				new Vector3(right - cornerRadius, 0.0f, top),
//				new Vector3(right, 0.0f, top - cornerRadius),
//				new Vector3(right, 0.0f, bottom + cornerRadius),
//				new Vector3(right - cornerRadius, 0.0f, bottom)
//			}, true);

			return shape;
		}

		private ISpline BuildPath(TrackSegment prevSegment, SettingsSection settings)
		{
			var pathStart = Vector3.zero;
			var pathStartDir = Vector3.forward;

			if( prevSegment )
			{
				var prevPath = prevSegment.Loft.Path;
				pathStart = prevPath.PositionSample(1.0f);
				pathStartDir = (pathStart - prevPath.PositionSample(0.99f)).normalized;
			}

			var pathLength = settings.Segment.Length.Random(_rand);
			var pathMid = pathStart + (pathStartDir * pathLength * 0.5f);
			var pathEnd = pathStart + (pathStartDir * pathLength);

			return Bezier.ConstructSmoothSpline(new Vector3[]{
				pathStart,
				pathMid,
				pathEnd
			});
		}

		public Material GetTrackMaterial(TrackSegment segment)
		{
			return _settings[segment.Section].Segment.Material;
		}
	}
}