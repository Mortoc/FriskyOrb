Shader "RtInfinity/Player"
{
	Properties 
	{
		_vertexColor("Color", Color) = (1,1,1,1)
		_rimPower("Rim Power", Range(-1,10) ) = 0.5
		_rimColor("Rim Color", Color) = (1,1,1,1)
		
		_stretch("Stretch", Range(-5,5) ) = 1
		_stretchStart("Stretch Start", Vector ) = (0.0, 0.0, 0.0, 1.0)
		_stretchEnd("Stretch End", Vector ) = (0.0, 1.0, 0.0, 1.0)
	}
	
	SubShader 
	{
		Tags
		{
			"Queue"="Geometry"
			"IgnoreProjector"="False"
			"RenderType"="Opaque"
		}

		Cull Back
		ZWrite On
		ZTest LEqual

		CGPROGRAM
		#pragma surface surf BlinnPhongEditor  exclude_path:prepass fullforwardshadows vertex:vert
		#pragma target 2.0

		float4 _vertexColor;
		float _rimPower;
		float4 _rimColor;
		float _stretch;
		float4 _stretchStart;
		float4 _stretchEnd;

		struct EditorSurfaceOutput {
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half3 Gloss;
			half Specular;
			half Alpha;
		};
		
		inline half4 LightingBlinnPhongEditor_PrePass (EditorSurfaceOutput s, half4 light)
		{
			half3 spec = light.a * s.Gloss;
			half4 c;
			c.rgb = (s.Albedo * light.rgb + light.rgb * spec);
			c.a = s.Alpha;
			return c;
		}

		inline half4 LightingBlinnPhongEditor (EditorSurfaceOutput s, half3 lightDir, half3 viewDir, half atten)
		{
			half3 h = normalize (lightDir + viewDir);
			
			half diff = max(0, dot ( lightDir, s.Normal ));
			
			float nh = max(0, dot (s.Normal, h));
			float spec = pow(nh, s.Specular * 128.0);
			
			half4 res;
			res.rgb = _LightColor0.rgb * diff;
			res.w = spec * Luminance(_LightColor0.rgb);
			res *= atten * 2.0;

			return LightingBlinnPhongEditor_PrePass( s, res );
		}
		
		struct Input {
			float3 viewDir;
			float4 color : COLOR;
		};

		void vert (inout appdata_full v, out Input o) {	
			float effectiveStretch = 0;
			if( _stretch < 0 )
				effectiveStretch = -1 / ((_stretch * 0.5) - 1);
			else
				effectiveStretch = _stretch + 1;

	 		float3 pos = v.vertex.xyz;
	 		float3 axis = normalize(mul(_World2Object, _stretchEnd).xyz - mul(_World2Object, _stretchStart).xyz);
	 		float axisT = dot(pos, axis);
			float3 axisPos = axisT * axis;
			float3 axisToVert = pos - axisPos;
			
	 		float3 stretchedAxisPos = effectiveStretch * axisPos;
						
			float squeeze = smoothstep(0, 1, 2 * abs(axisT/2));
			float centerScale = 1.0 / effectiveStretch;
			float minorAxisScale = lerp(centerScale, 1, squeeze);

	 		pos = stretchedAxisPos + (axisToVert * minorAxisScale);
	 		
	 		v.vertex.xyz = pos;
			o.color = v.color;
		}
		
		void surf (Input IN, inout EditorSurfaceOutput o) {
			o.Normal = float3(0.0,0.0,1.0);
			o.Alpha = 1.0;
			o.Albedo = 0.0;
			o.Emission = 0.0;
			o.Gloss = 0.0;
			o.Specular = 0.0;

			float fresnel = 1.0 - dot(normalize(IN.viewDir.xyz), float3(0,0,1));
			float4 rimPower = pow(fresnel, _rimPower).xxxx;
			float4 lightColor = rimPower * _rimColor;
			float4 surfColor =_vertexColor * IN.color;
			o.Emission = lightColor + surfColor;
		}
		
		ENDCG
	}
}