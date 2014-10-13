Shader "RedDotGames/Mobile/Car Glass Doublesided" {
Properties {
	_Color ("Main Color (RGB)", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color (RGB)", Color) = (1,1,1,0.5)
	_Cube ("Reflection Cubemap (CUBE)", Cube) = "_Skybox" { TexGen CubeReflect }
	_FresnelPower ("Fresnel Power", Range(0.05,5.0)) = 0.75
}
SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	
	Cull Front	
	
CGPROGRAM
#pragma surface surf Lambert alpha
#pragma target 2.0
#pragma exclude_renderers d3d11 xbox360 ps3 d3d11_9x flash
samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;

half _FresnelPower;

struct Input {
	fixed3 worldRefl;
	fixed3 viewDir;
	INTERNAL_DATA
};

void surf (Input IN, inout SurfaceOutput o) 
{
	half4 c = _Color;
	
	half3 worldReflVec = -WorldReflectionVector(IN, o.Normal);	
	half4 reflcol = texCUBE(_Cube, worldReflVec);
	
	fixed fcbias = 0.20373;
	fixed facing = saturate(1.0 - max(dot( normalize(IN.viewDir.xyz), normalize(-o.Normal)), 0.0));
	fixed refl2Refr = max(fcbias + (1.0-fcbias) * pow(facing, _FresnelPower), 0);			
	
	o.Albedo =  reflcol.rgb * _ReflectColor.rgb + c.rgb;
	o.Emission = o.Albedo * 0.25;
	o.Alpha = refl2Refr; 
	
}
ENDCG

	Cull Back	
	
CGPROGRAM
#pragma surface surf Lambert alpha
#pragma target 2.0

samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;

half _FresnelPower;

struct Input {
	fixed3 worldRefl;
	fixed3 viewDir;
	INTERNAL_DATA
};

void surf (Input IN, inout SurfaceOutput o) 
{
	half4 c = _Color;
	
	half3 worldReflVec = WorldReflectionVector(IN, o.Normal);	
	half4 reflcol = texCUBE(_Cube, worldReflVec);
	
	fixed fcbias = 0.20373;
	fixed facing = saturate(1.0 - max(dot( normalize(IN.viewDir.xyz), normalize(o.Normal)), 0.0));
	fixed refl2Refr = max(fcbias + (1.0-fcbias) * pow(facing, _FresnelPower), 0);			
	
	o.Albedo =  reflcol.rgb * _ReflectColor.rgb + c.rgb;
	o.Emission = o.Albedo * 0.25;
	o.Alpha = refl2Refr; 
	
}
ENDCG

}
	
FallBack "Reflective/VertexLit"
} 

