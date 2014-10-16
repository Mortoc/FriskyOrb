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

		private struct TrackProfileSettings
		{
			public string Type { get; set; }
			public Dictionary<string, float> Params;
		}
		
		[Serializable]
		private struct TrackSegmentSettings
		{
			public TrackProfileSettings Profile { get; set; }
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
					Min = segmentJson["curviness"]["min"].AsFloat,
					Max = segmentJson["curviness"]["max"].AsFloat
				},
				Profile = new TrackProfileSettings(){
					Type = segmentJson["profile"]["type"],
					Params = GetSettingParams(segmentJson["profile"])
				},
				Material = material
			};
		}

		private Dictionary<string, float> GetSettingParams(JSONNode setting)
		{
			var result = new Dictionary<string, float>();
			foreach(KeyValuePair<string, JSONNode> param in setting["params"] as JSONClass)
				result[param.Key] = param.Value.AsFloat;

			return result;
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
			ISpline result;
			var profileSettings = settings.Segment.Profile;
			switch(profileSettings.Type) 
			{
			case "rounded-rect":
				result = BuildRoundedRect(prevSegment, settings);
				break;
			case "halfpipe":
				result = BuildHalfpipe(prevSegment, settings);
				break;
			default:
				result = BuildRoundedRect(prevSegment, settings);
				break;
			}

			return result;
		}

		private ISpline BuildHalfpipe(TrackSegment prevSegment, SettingsSection settings)
		{
			var inner = settings.Segment.Profile.Params["innerDiameter"];
			var outer = settings.Segment.Profile.Params["outerDiameter"];
			var wideBottom = settings.Segment.Profile.Params["wideBottom"];

			var shape = Bezier.ConstructSmoothSpline(new Vector3[]{
				new Vector3(0.0f, 0.0f, inner),
				new Vector3(inner, 0.0f, 0.0f),
				new Vector3(outer, 0.0f, 0.0f),
				new Vector3(0.0f, 0.0f, outer),
				new Vector3(-outer, 0.0f, 0.0f),
				new Vector3(-inner, 0.0f, 0.0f)
			}, true);

			shape[2].InTangent = new Vector3(-outer * wideBottom, 0.0f, outer);
			shape[2].OutTangent = new Vector3(outer * wideBottom, 0.0f, outer);
			
			shape[5].InTangent = new Vector3(inner * wideBottom, 0.0f, inner);
			shape[5].OutTangent = new Vector3(-inner * wideBottom, 0.0f, inner);



			return shape;
		}

		private ISpline BuildRoundedRect(TrackSegment prevSegment, SettingsSection settings)
		{
			var width = settings.Segment.Profile.Params["width"];
			var height = settings.Segment.Profile.Params["height"];
			var roundness = settings.Segment.Profile.Params["roundness"];
			
			var left = width * -0.5f;
			var right = width * 0.5f;
			var bottom = 0.0f;
			var top = height;
			
			var shape = Bezier.ConstructSmoothSpline(new Vector3[]{
				new Vector3(left, 0.0f, bottom),
				new Vector3(right, 0.0f, bottom),
				new Vector3(right, 0.0f, top),
				new Vector3(left, 0.0f, top)
			}, true);
			
			shape.ScaleTangents(roundness);
			
			return shape;
		}

		private ISpline BuildPath(TrackSegment prevSegment, SettingsSection settings)
		{
			var pathStart = Vector3.zero;
            var pathStartDir = prevSegment
                ? prevSegment.Loft.Path.ForwardVector(1.0f)
                : Vector3.forward;

			var pathStartTan = prevSegment
				? prevSegment.Loft.Path.LastControlPoint.OutTangent - prevSegment.Loft.Path.LastControlPoint.Point 
				: Vector3.forward * settings.Segment.Curviness.Random(_rand);

			var pathLength = settings.Segment.Length.Random(_rand);

			var pathEnd = pathStart + (pathStartDir * pathLength);

			var newDir = Vector3.Slerp (_rand.NextUnitVector(), pathStartDir, 0.9f); // limit the curivness and the end tangent
			var pathEndOutTangent = Vector3.Lerp(pathStart, pathEnd, 1.0f - (1.0f/pathLength)) + 
				(settings.Segment.Curviness.Random(_rand) * newDir);

			var pathEndInTangent = (-1.0f * (pathEndOutTangent - pathEnd)) + pathEnd;

            var lastPathEndUp = prevSegment
                ? prevSegment.Loft.Path.Last().Up
                : Vector3.up;

            return new Bezier(new Bezier.ControlPoint[]{
                new Bezier.ControlPoint(pathStart, pathStart + (pathStartDir * -1.0f), pathStart + pathStartDir, lastPathEndUp),
                new Bezier.ControlPoint(pathEnd, pathEndInTangent, pathEndOutTangent, Vector3.up)
            });
		}

		public Material GetTrackMaterial(TrackSegment segment)
		{
			return _settings[segment.Section].Segment.Material;
		}
	}
}