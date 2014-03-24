Shader "FriskyOrb/Player" {
    Properties {
		_GlowTex ("Glow", 2D) = "" {}
		_GlowColor ("Glow Color", Color)  = (1,1,1,1)	
		_GlowStrength ("Glow Strength", Float) = 1.0
		_BumpMap ("Bumpmap", 2D) = "bump" {}
		_RimColor ("Rim Color", Color) = (0.26,0.19,0.16,0.0)
		_RimPower ("Rim Power", Range(0.5,8.0)) = 3.0
    }
    SubShader {
		Tags { "RenderEffect"="Glow11" "RenderType"="Glow11" }
		CGPROGRAM
		#pragma surface surf Lambert
		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
			float3 viewDir;
		};
		sampler2D _BumpMap;
		float4 _RimColor;
		float _RimPower;
		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = _RimColor;
			o.Normal = UnpackNormal (tex2D (_BumpMap, IN.uv_BumpMap));
			half rim = 1.0 - saturate(dot (normalize(IN.viewDir), o.Normal));
			o.Emission = _RimColor.rgb * pow (rim, _RimPower);
		}
		ENDCG
    } 
    Fallback "Diffuse"
	CustomEditor "GlowMatInspector" 
  }