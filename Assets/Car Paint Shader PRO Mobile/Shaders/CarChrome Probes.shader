Shader "RedDotGames/Mobile/Light Probes Support/Car Chrome" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (0,0,0,1) 
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _Shininess ("Shininess", Range (0.01, 10)) = 1
	  _Gloss ("Gloss", Range (0.0, 10)) = 0
	  _MainTex ("Diffuse Texture", 2D) = "white" {} 
	  _Cube("Reflection Map", Cube) = "" {}
	  _Reflection("Reflection Power", Range (0.00, 1)) = 1
	  _SHLightingScale("LightProbe influence scale",Range(0,1)) = 1
	  
   }
SubShader {
   Tags { "QUEUE"="Geometry" "RenderType"="Opaque" " IgnoreProjector"="True"}	  
      Pass {  
      
         Tags { "LightMode" = "ForwardBase" } // pass for 
            // 4 vertex lights, ambient light & first pixel light
 
         Program "vp" {
// Vertex combos: 8
//   opengl - ALU: 37 to 101
//   d3d9 - ALU: 37 to 101
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Float 21 [_SHLightingScale]
"!!ARBvp1.0
# 37 ALU
PARAM c[22] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R0;
MUL R0.x, R2.y, R2.y;
MAD R0.x, R2, R2, -R0;
MUL R3.xyz, R0.x, c[20];
MOV R0.xyz, R2;
MOV R0.w, c[0].y;
DP4 R4.z, R0, c[16];
DP4 R4.y, R0, c[15];
DP4 R4.x, R0, c[14];
MUL R1, R2.xyzz, R2.yzzx;
DP4 R0.z, R1, c[19];
DP4 R0.x, R1, c[17];
DP4 R0.y, R1, c[18];
ADD R0.xyz, R4, R0;
ADD R0.xyz, R0, R3;
MUL result.texcoord[2].xyz, R0, c[21].x;
DP4 R0.x, vertex.position, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
ADD R1.xyz, R0, -c[13];
MOV result.texcoord[0], R0;
DP3 R0.x, R1, R1;
RSQ R0.x, R0.x;
MOV result.texcoord[1].xyz, R2;
MOV result.texcoord[3], vertex.texcoord[0];
MUL result.texcoord[4].xyz, R0.x, R1;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 37 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"vs_2_0
; 37 ALU
def c21, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c21.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
mul r0.x, r2.y, r2.y
mad r0.x, r2, r2, -r0
mul r3.xyz, r0.x, c19
mov r0.xyz, r2
mov r0.w, c21.y
dp4 r4.z, r0, c15
dp4 r4.y, r0, c14
dp4 r4.x, r0, c13
mul r1, r2.xyzz, r2.yzzx
dp4 r0.z, r1, c18
dp4 r0.x, r1, c16
dp4 r0.y, r1, c17
add r0.xyz, r4, r0
add r0.xyz, r0, r3
mul oT2.xyz, r0, c20.x
dp4 r0.x, v0, c4
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
add r1.xyz, r0, -c12
mov oT0, r0
dp3 r0.x, r1, r1
rsq r0.x, r0.x
mov oT1.xyz, r2
mov oT3, v2
mul oT4.xyz, r0.x, r1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_3;
  mediump vec3 tmpvar_13;
  mediump vec4 normal;
  normal = tmpvar_12;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal);
  x1.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal);
  x1.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal);
  x1.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC);
  x3 = tmpvar_22;
  tmpvar_13 = ((x1 + x2) + x3);
  shl = tmpvar_13;
  highp vec3 tmpvar_23;
  tmpvar_23 = (shl * _SHLightingScale);
  tmpvar_4 = tmpvar_23;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_3;
  mediump vec3 tmpvar_13;
  mediump vec4 normal;
  normal = tmpvar_12;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal);
  x1.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal);
  x1.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal);
  x1.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC);
  x3 = tmpvar_22;
  tmpvar_13 = ((x1 + x2) + x3);
  shl = tmpvar_13;
  highp vec3 tmpvar_23;
  tmpvar_23 = (shl * _SHLightingScale);
  tmpvar_4 = tmpvar_23;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"agal_vs
c21 0.0 1.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaabfaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c21.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaacaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r2.xyz, r0.w, r0.xyzz
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
adaaaaaaacaaaiacacaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r2.w, r2.x, r2.x
acaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r2.w, r0.x
adaaaaaaadaaahacaaaaaaaaacaaaaaabdaaaaoeabaaaaaa mul r3.xyz, r0.x, c19
aaaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, r2.xyzz
aaaaaaaaaaaaaiacbfaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c21.y
bdaaaaaaaeaaaeacaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r4.z, r0, c15
bdaaaaaaaeaaacacaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r4.y, r0, c14
bdaaaaaaaeaaabacaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r4.x, r0, c13
adaaaaaaabaaapacacaaaakeacaaaaaaacaaaacjacaaaaaa mul r1, r2.xyzz, r2.yzzx
bdaaaaaaaaaaaeacabaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r0.z, r1, c18
bdaaaaaaaaaaabacabaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r0.x, r1, c16
bdaaaaaaaaaaacacabaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r0.y, r1, c17
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r4.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakeacaaaaaa add r0.xyz, r0.xyzz, r3.xyzz
adaaaaaaacaaahaeaaaaaakeacaaaaaabeaaaaaaabaaaaaa mul v2.xyz, r0.xyzz, c20.x
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
acaaaaaaabaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r1.xyz, r0.xyzz, c12
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
aaaaaaaaabaaahaeacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xyz, r2.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
adaaaaaaaeaaahaeaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul v4.xyz, r0.x, r1.xyzz
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Float 21 [_SHLightingScale]
"!!ARBvp1.0
# 37 ALU
PARAM c[22] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R0;
MUL R0.x, R2.y, R2.y;
MAD R0.x, R2, R2, -R0;
MUL R3.xyz, R0.x, c[20];
MOV R0.xyz, R2;
MOV R0.w, c[0].y;
DP4 R4.z, R0, c[16];
DP4 R4.y, R0, c[15];
DP4 R4.x, R0, c[14];
MUL R1, R2.xyzz, R2.yzzx;
DP4 R0.z, R1, c[19];
DP4 R0.x, R1, c[17];
DP4 R0.y, R1, c[18];
ADD R0.xyz, R4, R0;
ADD R0.xyz, R0, R3;
MUL result.texcoord[2].xyz, R0, c[21].x;
DP4 R0.x, vertex.position, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
ADD R1.xyz, R0, -c[13];
MOV result.texcoord[0], R0;
DP3 R0.x, R1, R1;
RSQ R0.x, R0.x;
MOV result.texcoord[1].xyz, R2;
MOV result.texcoord[3], vertex.texcoord[0];
MUL result.texcoord[4].xyz, R0.x, R1;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 37 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"vs_2_0
; 37 ALU
def c21, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c21.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
mul r0.x, r2.y, r2.y
mad r0.x, r2, r2, -r0
mul r3.xyz, r0.x, c19
mov r0.xyz, r2
mov r0.w, c21.y
dp4 r4.z, r0, c15
dp4 r4.y, r0, c14
dp4 r4.x, r0, c13
mul r1, r2.xyzz, r2.yzzx
dp4 r0.z, r1, c18
dp4 r0.x, r1, c16
dp4 r0.y, r1, c17
add r0.xyz, r4, r0
add r0.xyz, r0, r3
mul oT2.xyz, r0, c20.x
dp4 r0.x, v0, c4
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
add r1.xyz, r0, -c12
mov oT0, r0
dp3 r0.x, r1, r1
rsq r0.x, r0.x
mov oT1.xyz, r2
mov oT3, v2
mul oT4.xyz, r0.x, r1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_3;
  mediump vec3 tmpvar_13;
  mediump vec4 normal;
  normal = tmpvar_12;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal);
  x1.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal);
  x1.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal);
  x1.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC);
  x3 = tmpvar_22;
  tmpvar_13 = ((x1 + x2) + x3);
  shl = tmpvar_13;
  highp vec3 tmpvar_23;
  tmpvar_23 = (shl * _SHLightingScale);
  tmpvar_4 = tmpvar_23;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_3;
  mediump vec3 tmpvar_13;
  mediump vec4 normal;
  normal = tmpvar_12;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal);
  x1.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal);
  x1.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal);
  x1.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC);
  x3 = tmpvar_22;
  tmpvar_13 = ((x1 + x2) + x3);
  shl = tmpvar_13;
  highp vec3 tmpvar_23;
  tmpvar_23 = (shl * _SHLightingScale);
  tmpvar_4 = tmpvar_23;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"agal_vs
c21 0.0 1.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaabfaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c21.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaacaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r2.xyz, r0.w, r0.xyzz
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
adaaaaaaacaaaiacacaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r2.w, r2.x, r2.x
acaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r2.w, r0.x
adaaaaaaadaaahacaaaaaaaaacaaaaaabdaaaaoeabaaaaaa mul r3.xyz, r0.x, c19
aaaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, r2.xyzz
aaaaaaaaaaaaaiacbfaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c21.y
bdaaaaaaaeaaaeacaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r4.z, r0, c15
bdaaaaaaaeaaacacaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r4.y, r0, c14
bdaaaaaaaeaaabacaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r4.x, r0, c13
adaaaaaaabaaapacacaaaakeacaaaaaaacaaaacjacaaaaaa mul r1, r2.xyzz, r2.yzzx
bdaaaaaaaaaaaeacabaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r0.z, r1, c18
bdaaaaaaaaaaabacabaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r0.x, r1, c16
bdaaaaaaaaaaacacabaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r0.y, r1, c17
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r4.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakeacaaaaaa add r0.xyz, r0.xyzz, r3.xyzz
adaaaaaaacaaahaeaaaaaakeacaaaaaabeaaaaaaabaaaaaa mul v2.xyz, r0.xyzz, c20.x
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
acaaaaaaabaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r1.xyz, r0.xyzz, c12
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
aaaaaaaaabaaahaeacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xyz, r2.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
adaaaaaaaeaaahaeaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul v4.xyz, r0.x, r1.xyzz
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Float 21 [_SHLightingScale]
"!!ARBvp1.0
# 37 ALU
PARAM c[22] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R0;
MUL R0.x, R2.y, R2.y;
MAD R0.x, R2, R2, -R0;
MUL R3.xyz, R0.x, c[20];
MOV R0.xyz, R2;
MOV R0.w, c[0].y;
DP4 R4.z, R0, c[16];
DP4 R4.y, R0, c[15];
DP4 R4.x, R0, c[14];
MUL R1, R2.xyzz, R2.yzzx;
DP4 R0.z, R1, c[19];
DP4 R0.x, R1, c[17];
DP4 R0.y, R1, c[18];
ADD R0.xyz, R4, R0;
ADD R0.xyz, R0, R3;
MUL result.texcoord[2].xyz, R0, c[21].x;
DP4 R0.x, vertex.position, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
ADD R1.xyz, R0, -c[13];
MOV result.texcoord[0], R0;
DP3 R0.x, R1, R1;
RSQ R0.x, R0.x;
MOV result.texcoord[1].xyz, R2;
MOV result.texcoord[3], vertex.texcoord[0];
MUL result.texcoord[4].xyz, R0.x, R1;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 37 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"vs_2_0
; 37 ALU
def c21, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c21.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
mul r0.x, r2.y, r2.y
mad r0.x, r2, r2, -r0
mul r3.xyz, r0.x, c19
mov r0.xyz, r2
mov r0.w, c21.y
dp4 r4.z, r0, c15
dp4 r4.y, r0, c14
dp4 r4.x, r0, c13
mul r1, r2.xyzz, r2.yzzx
dp4 r0.z, r1, c18
dp4 r0.x, r1, c16
dp4 r0.y, r1, c17
add r0.xyz, r4, r0
add r0.xyz, r0, r3
mul oT2.xyz, r0, c20.x
dp4 r0.x, v0, c4
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
add r1.xyz, r0, -c12
mov oT0, r0
dp3 r0.x, r1, r1
rsq r0.x, r0.x
mov oT1.xyz, r2
mov oT3, v2
mul oT4.xyz, r0.x, r1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_3;
  mediump vec3 tmpvar_13;
  mediump vec4 normal;
  normal = tmpvar_12;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal);
  x1.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal);
  x1.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal);
  x1.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC);
  x3 = tmpvar_22;
  tmpvar_13 = ((x1 + x2) + x3);
  shl = tmpvar_13;
  highp vec3 tmpvar_23;
  tmpvar_23 = (shl * _SHLightingScale);
  tmpvar_4 = tmpvar_23;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_3;
  mediump vec3 tmpvar_13;
  mediump vec4 normal;
  normal = tmpvar_12;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal);
  x1.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal);
  x1.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal);
  x1.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC);
  x3 = tmpvar_22;
  tmpvar_13 = ((x1 + x2) + x3);
  shl = tmpvar_13;
  highp vec3 tmpvar_23;
  tmpvar_23 = (shl * _SHLightingScale);
  tmpvar_4 = tmpvar_23;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"agal_vs
c21 0.0 1.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaabfaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c21.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaacaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r2.xyz, r0.w, r0.xyzz
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
adaaaaaaacaaaiacacaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r2.w, r2.x, r2.x
acaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r2.w, r0.x
adaaaaaaadaaahacaaaaaaaaacaaaaaabdaaaaoeabaaaaaa mul r3.xyz, r0.x, c19
aaaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, r2.xyzz
aaaaaaaaaaaaaiacbfaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c21.y
bdaaaaaaaeaaaeacaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r4.z, r0, c15
bdaaaaaaaeaaacacaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r4.y, r0, c14
bdaaaaaaaeaaabacaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r4.x, r0, c13
adaaaaaaabaaapacacaaaakeacaaaaaaacaaaacjacaaaaaa mul r1, r2.xyzz, r2.yzzx
bdaaaaaaaaaaaeacabaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r0.z, r1, c18
bdaaaaaaaaaaabacabaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r0.x, r1, c16
bdaaaaaaaaaaacacabaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r0.y, r1, c17
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r4.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakeacaaaaaa add r0.xyz, r0.xyzz, r3.xyzz
adaaaaaaacaaahaeaaaaaakeacaaaaaabeaaaaaaabaaaaaa mul v2.xyz, r0.xyzz, c20.x
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
acaaaaaaabaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r1.xyz, r0.xyzz, c12
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
aaaaaaaaabaaahaeacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xyz, r2.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
adaaaaaaaeaaahaeaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul v4.xyz, r0.x, r1.xyzz
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Float 21 [_SHLightingScale]
"!!ARBvp1.0
# 37 ALU
PARAM c[22] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R0;
MUL R0.x, R2.y, R2.y;
MAD R0.x, R2, R2, -R0;
MUL R3.xyz, R0.x, c[20];
MOV R0.xyz, R2;
MOV R0.w, c[0].y;
DP4 R4.z, R0, c[16];
DP4 R4.y, R0, c[15];
DP4 R4.x, R0, c[14];
MUL R1, R2.xyzz, R2.yzzx;
DP4 R0.z, R1, c[19];
DP4 R0.x, R1, c[17];
DP4 R0.y, R1, c[18];
ADD R0.xyz, R4, R0;
ADD R0.xyz, R0, R3;
MUL result.texcoord[2].xyz, R0, c[21].x;
DP4 R0.x, vertex.position, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
ADD R1.xyz, R0, -c[13];
MOV result.texcoord[0], R0;
DP3 R0.x, R1, R1;
RSQ R0.x, R0.x;
MOV result.texcoord[1].xyz, R2;
MOV result.texcoord[3], vertex.texcoord[0];
MUL result.texcoord[4].xyz, R0.x, R1;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 37 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"vs_2_0
; 37 ALU
def c21, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c21.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
mul r0.x, r2.y, r2.y
mad r0.x, r2, r2, -r0
mul r3.xyz, r0.x, c19
mov r0.xyz, r2
mov r0.w, c21.y
dp4 r4.z, r0, c15
dp4 r4.y, r0, c14
dp4 r4.x, r0, c13
mul r1, r2.xyzz, r2.yzzx
dp4 r0.z, r1, c18
dp4 r0.x, r1, c16
dp4 r0.y, r1, c17
add r0.xyz, r4, r0
add r0.xyz, r0, r3
mul oT2.xyz, r0, c20.x
dp4 r0.x, v0, c4
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
add r1.xyz, r0, -c12
mov oT0, r0
dp3 r0.x, r1, r1
rsq r0.x, r0.x
mov oT1.xyz, r2
mov oT3, v2
mul oT4.xyz, r0.x, r1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_3;
  mediump vec3 tmpvar_13;
  mediump vec4 normal;
  normal = tmpvar_12;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal);
  x1.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal);
  x1.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal);
  x1.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC);
  x3 = tmpvar_22;
  tmpvar_13 = ((x1 + x2) + x3);
  shl = tmpvar_13;
  highp vec3 tmpvar_23;
  tmpvar_23 = (shl * _SHLightingScale);
  tmpvar_4 = tmpvar_23;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_3;
  mediump vec3 tmpvar_13;
  mediump vec4 normal;
  normal = tmpvar_12;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal);
  x1.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal);
  x1.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal);
  x1.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC);
  x3 = tmpvar_22;
  tmpvar_13 = ((x1 + x2) + x3);
  shl = tmpvar_13;
  highp vec3 tmpvar_23;
  tmpvar_23 = (shl * _SHLightingScale);
  tmpvar_4 = tmpvar_23;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"agal_vs
c21 0.0 1.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaabfaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c21.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaacaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r2.xyz, r0.w, r0.xyzz
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
adaaaaaaacaaaiacacaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r2.w, r2.x, r2.x
acaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r2.w, r0.x
adaaaaaaadaaahacaaaaaaaaacaaaaaabdaaaaoeabaaaaaa mul r3.xyz, r0.x, c19
aaaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, r2.xyzz
aaaaaaaaaaaaaiacbfaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c21.y
bdaaaaaaaeaaaeacaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r4.z, r0, c15
bdaaaaaaaeaaacacaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r4.y, r0, c14
bdaaaaaaaeaaabacaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r4.x, r0, c13
adaaaaaaabaaapacacaaaakeacaaaaaaacaaaacjacaaaaaa mul r1, r2.xyzz, r2.yzzx
bdaaaaaaaaaaaeacabaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r0.z, r1, c18
bdaaaaaaaaaaabacabaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r0.x, r1, c16
bdaaaaaaaaaaacacabaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r0.y, r1, c17
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r4.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakeacaaaaaa add r0.xyz, r0.xyzz, r3.xyzz
adaaaaaaacaaahaeaaaaaakeacaaaaaabeaaaaaaabaaaaaa mul v2.xyz, r0.xyzz, c20.x
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
acaaaaaaabaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r1.xyz, r0.xyzz, c12
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
aaaaaaaaabaaahaeacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xyz, r2.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
adaaaaaaaeaaahaeaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul v4.xyz, r0.x, r1.xyzz
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Float 21 [_SHLightingScale]
"!!ARBvp1.0
# 37 ALU
PARAM c[22] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R0;
MUL R0.x, R2.y, R2.y;
MAD R0.x, R2, R2, -R0;
MUL R3.xyz, R0.x, c[20];
MOV R0.xyz, R2;
MOV R0.w, c[0].y;
DP4 R4.z, R0, c[16];
DP4 R4.y, R0, c[15];
DP4 R4.x, R0, c[14];
MUL R1, R2.xyzz, R2.yzzx;
DP4 R0.z, R1, c[19];
DP4 R0.x, R1, c[17];
DP4 R0.y, R1, c[18];
ADD R0.xyz, R4, R0;
ADD R0.xyz, R0, R3;
MUL result.texcoord[2].xyz, R0, c[21].x;
DP4 R0.x, vertex.position, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
ADD R1.xyz, R0, -c[13];
MOV result.texcoord[0], R0;
DP3 R0.x, R1, R1;
RSQ R0.x, R0.x;
MOV result.texcoord[1].xyz, R2;
MOV result.texcoord[3], vertex.texcoord[0];
MUL result.texcoord[4].xyz, R0.x, R1;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 37 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"vs_2_0
; 37 ALU
def c21, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c21.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
mul r0.x, r2.y, r2.y
mad r0.x, r2, r2, -r0
mul r3.xyz, r0.x, c19
mov r0.xyz, r2
mov r0.w, c21.y
dp4 r4.z, r0, c15
dp4 r4.y, r0, c14
dp4 r4.x, r0, c13
mul r1, r2.xyzz, r2.yzzx
dp4 r0.z, r1, c18
dp4 r0.x, r1, c16
dp4 r0.y, r1, c17
add r0.xyz, r4, r0
add r0.xyz, r0, r3
mul oT2.xyz, r0, c20.x
dp4 r0.x, v0, c4
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
add r1.xyz, r0, -c12
mov oT0, r0
dp3 r0.x, r1, r1
rsq r0.x, r0.x
mov oT1.xyz, r2
mov oT3, v2
mul oT4.xyz, r0.x, r1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_3;
  mediump vec3 tmpvar_13;
  mediump vec4 normal;
  normal = tmpvar_12;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal);
  x1.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal);
  x1.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal);
  x1.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC);
  x3 = tmpvar_22;
  tmpvar_13 = ((x1 + x2) + x3);
  shl = tmpvar_13;
  highp vec3 tmpvar_23;
  tmpvar_23 = (shl * _SHLightingScale);
  tmpvar_4 = tmpvar_23;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_3;
  mediump vec3 tmpvar_13;
  mediump vec4 normal;
  normal = tmpvar_12;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal);
  x1.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal);
  x1.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal);
  x1.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC);
  x3 = tmpvar_22;
  tmpvar_13 = ((x1 + x2) + x3);
  shl = tmpvar_13;
  highp vec3 tmpvar_23;
  tmpvar_23 = (shl * _SHLightingScale);
  tmpvar_4 = tmpvar_23;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"agal_vs
c21 0.0 1.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaabfaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c21.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaacaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r2.xyz, r0.w, r0.xyzz
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
adaaaaaaacaaaiacacaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r2.w, r2.x, r2.x
acaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r2.w, r0.x
adaaaaaaadaaahacaaaaaaaaacaaaaaabdaaaaoeabaaaaaa mul r3.xyz, r0.x, c19
aaaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, r2.xyzz
aaaaaaaaaaaaaiacbfaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c21.y
bdaaaaaaaeaaaeacaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r4.z, r0, c15
bdaaaaaaaeaaacacaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r4.y, r0, c14
bdaaaaaaaeaaabacaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r4.x, r0, c13
adaaaaaaabaaapacacaaaakeacaaaaaaacaaaacjacaaaaaa mul r1, r2.xyzz, r2.yzzx
bdaaaaaaaaaaaeacabaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r0.z, r1, c18
bdaaaaaaaaaaabacabaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r0.x, r1, c16
bdaaaaaaaaaaacacabaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r0.y, r1, c17
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r4.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakeacaaaaaa add r0.xyz, r0.xyzz, r3.xyzz
adaaaaaaacaaahaeaaaaaakeacaaaaaabeaaaaaaabaaaaaa mul v2.xyz, r0.xyzz, c20.x
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
acaaaaaaabaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r1.xyz, r0.xyzz, c12
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
aaaaaaaaabaaahaeacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xyz, r2.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
adaaaaaaaeaaahaeaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul v4.xyz, r0.x, r1.xyzz
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Float 21 [_SHLightingScale]
"!!ARBvp1.0
# 37 ALU
PARAM c[22] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R0;
MUL R0.x, R2.y, R2.y;
MAD R0.x, R2, R2, -R0;
MUL R3.xyz, R0.x, c[20];
MOV R0.xyz, R2;
MOV R0.w, c[0].y;
DP4 R4.z, R0, c[16];
DP4 R4.y, R0, c[15];
DP4 R4.x, R0, c[14];
MUL R1, R2.xyzz, R2.yzzx;
DP4 R0.z, R1, c[19];
DP4 R0.x, R1, c[17];
DP4 R0.y, R1, c[18];
ADD R0.xyz, R4, R0;
ADD R0.xyz, R0, R3;
MUL result.texcoord[2].xyz, R0, c[21].x;
DP4 R0.x, vertex.position, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
ADD R1.xyz, R0, -c[13];
MOV result.texcoord[0], R0;
DP3 R0.x, R1, R1;
RSQ R0.x, R0.x;
MOV result.texcoord[1].xyz, R2;
MOV result.texcoord[3], vertex.texcoord[0];
MUL result.texcoord[4].xyz, R0.x, R1;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 37 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"vs_2_0
; 37 ALU
def c21, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c21.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
mul r0.x, r2.y, r2.y
mad r0.x, r2, r2, -r0
mul r3.xyz, r0.x, c19
mov r0.xyz, r2
mov r0.w, c21.y
dp4 r4.z, r0, c15
dp4 r4.y, r0, c14
dp4 r4.x, r0, c13
mul r1, r2.xyzz, r2.yzzx
dp4 r0.z, r1, c18
dp4 r0.x, r1, c16
dp4 r0.y, r1, c17
add r0.xyz, r4, r0
add r0.xyz, r0, r3
mul oT2.xyz, r0, c20.x
dp4 r0.x, v0, c4
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
add r1.xyz, r0, -c12
mov oT0, r0
dp3 r0.x, r1, r1
rsq r0.x, r0.x
mov oT1.xyz, r2
mov oT3, v2
mul oT4.xyz, r0.x, r1
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_3;
  mediump vec3 tmpvar_13;
  mediump vec4 normal;
  normal = tmpvar_12;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal);
  x1.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal);
  x1.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal);
  x1.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC);
  x3 = tmpvar_22;
  tmpvar_13 = ((x1 + x2) + x3);
  shl = tmpvar_13;
  highp vec3 tmpvar_23;
  tmpvar_23 = (shl * _SHLightingScale);
  tmpvar_4 = tmpvar_23;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_3;
  mediump vec3 tmpvar_13;
  mediump vec4 normal;
  normal = tmpvar_12;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHAr, normal);
  x1.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHAg, normal);
  x1.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHAb, normal);
  x1.z = tmpvar_16;
  mediump vec4 tmpvar_17;
  tmpvar_17 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHBr, tmpvar_17);
  x2.x = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHBg, tmpvar_17);
  x2.y = tmpvar_19;
  highp float tmpvar_20;
  tmpvar_20 = dot (unity_SHBb, tmpvar_17);
  x2.z = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_21;
  highp vec3 tmpvar_22;
  tmpvar_22 = (unity_SHC.xyz * vC);
  x3 = tmpvar_22;
  tmpvar_13 = ((x1 + x2) + x3);
  shl = tmpvar_13;
  highp vec3 tmpvar_23;
  tmpvar_23 = (shl * _SHLightingScale);
  tmpvar_4 = tmpvar_23;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"agal_vs
c21 0.0 1.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaabfaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c21.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaacaaahacaaaaaappacaaaaaaaaaaaakeacaaaaaa mul r2.xyz, r0.w, r0.xyzz
adaaaaaaaaaaabacacaaaaffacaaaaaaacaaaaffacaaaaaa mul r0.x, r2.y, r2.y
adaaaaaaacaaaiacacaaaaaaacaaaaaaacaaaaaaacaaaaaa mul r2.w, r2.x, r2.x
acaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaacaaaaaa sub r0.x, r2.w, r0.x
adaaaaaaadaaahacaaaaaaaaacaaaaaabdaaaaoeabaaaaaa mul r3.xyz, r0.x, c19
aaaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, r2.xyzz
aaaaaaaaaaaaaiacbfaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c21.y
bdaaaaaaaeaaaeacaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r4.z, r0, c15
bdaaaaaaaeaaacacaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r4.y, r0, c14
bdaaaaaaaeaaabacaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 r4.x, r0, c13
adaaaaaaabaaapacacaaaakeacaaaaaaacaaaacjacaaaaaa mul r1, r2.xyzz, r2.yzzx
bdaaaaaaaaaaaeacabaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r0.z, r1, c18
bdaaaaaaaaaaabacabaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r0.x, r1, c16
bdaaaaaaaaaaacacabaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r0.y, r1, c17
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r4.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaadaaaakeacaaaaaa add r0.xyz, r0.xyzz, r3.xyzz
adaaaaaaacaaahaeaaaaaakeacaaaaaabeaaaaaaabaaaaaa mul v2.xyz, r0.xyzz, c20.x
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
acaaaaaaabaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r1.xyz, r0.xyzz, c12
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
bcaaaaaaaaaaabacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r1.xyzz, r1.xyzz
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
aaaaaaaaabaaahaeacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xyz, r2.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
adaaaaaaaeaaahaeaaaaaaaaacaaaaaaabaaaakeacaaaaaa mul v4.xyz, r0.x, r1.xyzz
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 17 [unity_4LightAtten0]
Vector 18 [unity_LightColor0]
Vector 19 [unity_LightColor1]
Vector 20 [unity_LightColor2]
Vector 21 [unity_LightColor3]
Vector 22 [unity_SHAr]
Vector 23 [unity_SHAg]
Vector 24 [unity_SHAb]
Vector 25 [unity_SHBr]
Vector 26 [unity_SHBg]
Vector 27 [unity_SHBb]
Vector 28 [unity_SHC]
Float 29 [_SHLightingScale]
Vector 30 [_Color]
"!!ARBvp1.0
# 101 ALU
PARAM c[31] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..30] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R1.xyz, vertex.normal.z, c[11], R0;
ADD R1.xyz, R1, c[0].x;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, R1;
DP4 R2.z, vertex.position, c[7];
DP4 R2.y, vertex.position, c[6];
DP4 R2.x, vertex.position, c[5];
MOV R0.x, c[14].z;
MOV R0.z, c[16];
MOV R0.y, c[15].z;
ADD R0.xyz, -R2, R0;
DP3 R1.w, R0, R0;
RSQ R2.w, R1.w;
MUL R0.xyz, R2.w, R0;
DP3 R0.y, R3, R0;
MUL R0.x, R1.w, c[17].z;
ADD R0.w, R0.x, c[0].y;
MAX R2.w, R0.y, c[0].x;
RCP R1.x, R0.w;
MUL R1.xyz, R1.x, c[20];
MUL R1.xyz, R1, c[30];
MUL R4.xyz, R1, R2.w;
MOV R0.x, c[14].y;
MOV R0.z, c[16].y;
MOV R0.y, c[15];
ADD R0.xyz, -R2, R0;
DP3 R0.w, R0, R0;
RSQ R1.w, R0.w;
MUL R0.xyz, R1.w, R0;
DP3 R0.y, R3, R0;
MAX R1.w, R0.y, c[0].x;
MUL R0.w, R0, c[17].y;
ADD R0.x, R0.w, c[0].y;
RCP R0.w, R0.x;
MUL R1.xyz, R0.w, c[19];
MUL R1.xyz, R1, c[30];
MUL R1.xyz, R1, R1.w;
MOV R0.x, c[14];
MOV R0.z, c[16].x;
MOV R0.y, c[15].x;
ADD R0.xyz, -R2, R0;
DP3 R0.w, R0, R0;
RSQ R2.w, R0.w;
MUL R1.w, R0, c[17].x;
MUL R0.xyz, R2.w, R0;
ADD R0.w, R1, c[0].y;
DP3 R1.w, R3, R0;
RCP R0.w, R0.w;
MUL R0.xyz, R0.w, c[18];
MAX R0.w, R1, c[0].x;
MUL R0.xyz, R0, c[30];
MUL R0.xyz, R0, R0.w;
ADD R0.xyz, R0, R1;
ADD R4.xyz, R0, R4;
MOV R0.xyz, R3;
MOV R0.w, c[0].y;
DP4 R5.z, R0, c[24];
DP4 R5.y, R0, c[23];
DP4 R5.x, R0, c[22];
MUL R1, R3.xyzz, R3.yzzx;
MUL R2.w, R3.y, R3.y;
MAD R0.w, R3.x, R3.x, -R2;
DP4 R2.w, vertex.position, c[8];
DP4 R0.z, R1, c[27];
DP4 R0.x, R1, c[25];
DP4 R0.y, R1, c[26];
ADD R1.xyz, R5, R0;
MUL R5.xyz, R0.w, c[28];
ADD R1.xyz, R1, R5;
MOV R0.x, c[14].w;
MOV R0.z, c[16].w;
MOV R0.y, c[15].w;
ADD R0.xyz, -R2, R0;
DP3 R0.w, R0, R0;
MUL R1.w, R0, c[17];
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
ADD R1.w, R1, c[0].y;
RCP R0.w, R1.w;
DP3 R1.w, R3, R0;
MUL R0.xyz, R0.w, c[21];
MAX R0.w, R1, c[0].x;
MUL R0.xyz, R0, c[30];
MUL R0.xyz, R0, R0.w;
ADD R0.xyz, R4, R0;
MUL R1.xyz, R1, c[29].x;
ADD result.texcoord[2].xyz, R0, R1;
ADD R0.xyz, R2, -c[13];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MOV result.texcoord[0], R2;
MOV result.texcoord[1].xyz, R3;
MOV result.texcoord[3], vertex.texcoord[0];
MUL result.texcoord[4].xyz, R0.w, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 101 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_4LightPosX0]
Vector 14 [unity_4LightPosY0]
Vector 15 [unity_4LightPosZ0]
Vector 16 [unity_4LightAtten0]
Vector 17 [unity_LightColor0]
Vector 18 [unity_LightColor1]
Vector 19 [unity_LightColor2]
Vector 20 [unity_LightColor3]
Vector 21 [unity_SHAr]
Vector 22 [unity_SHAg]
Vector 23 [unity_SHAb]
Vector 24 [unity_SHBr]
Vector 25 [unity_SHBg]
Vector 26 [unity_SHBb]
Vector 27 [unity_SHC]
Float 28 [_SHLightingScale]
Vector 29 [_Color]
"vs_2_0
; 101 ALU
def c30, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r1.xyz, v1.z, c10, r0
add r1.xyz, r1, c30.x
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r3.xyz, r0.w, r1
dp4 r2.z, v0, c6
dp4 r2.y, v0, c5
dp4 r2.x, v0, c4
mov r0.x, c13.z
mov r0.z, c15
mov r0.y, c14.z
add r0.xyz, -r2, r0
dp3 r1.w, r0, r0
rsq r2.w, r1.w
mul r0.xyz, r2.w, r0
dp3 r0.y, r3, r0
mul r0.x, r1.w, c16.z
add r0.w, r0.x, c30.y
max r2.w, r0.y, c30.x
rcp r1.x, r0.w
mul r1.xyz, r1.x, c19
mul r1.xyz, r1, c29
mul r4.xyz, r1, r2.w
mov r0.x, c13.y
mov r0.z, c15.y
mov r0.y, c14
add r0.xyz, -r2, r0
dp3 r0.w, r0, r0
rsq r1.w, r0.w
mul r0.xyz, r1.w, r0
dp3 r0.y, r3, r0
max r1.w, r0.y, c30.x
mul r0.w, r0, c16.y
add r0.x, r0.w, c30.y
rcp r0.w, r0.x
mul r1.xyz, r0.w, c18
mul r1.xyz, r1, c29
mul r1.xyz, r1, r1.w
mov r0.x, c13
mov r0.z, c15.x
mov r0.y, c14.x
add r0.xyz, -r2, r0
dp3 r0.w, r0, r0
rsq r2.w, r0.w
mul r1.w, r0, c16.x
mul r0.xyz, r2.w, r0
add r0.w, r1, c30.y
dp3 r1.w, r3, r0
rcp r0.w, r0.w
mul r0.xyz, r0.w, c17
max r0.w, r1, c30.x
mul r0.xyz, r0, c29
mul r0.xyz, r0, r0.w
add r0.xyz, r0, r1
add r4.xyz, r0, r4
mov r0.xyz, r3
mov r0.w, c30.y
dp4 r5.z, r0, c23
dp4 r5.y, r0, c22
dp4 r5.x, r0, c21
mul r1, r3.xyzz, r3.yzzx
mul r2.w, r3.y, r3.y
dp4 r0.z, r1, c26
dp4 r0.x, r1, c24
dp4 r0.y, r1, c25
add r1.xyz, r5, r0
mad r0.w, r3.x, r3.x, -r2
mul r5.xyz, r0.w, c27
add r1.xyz, r1, r5
mov r0.x, c13.w
mov r0.z, c15.w
mov r0.y, c14.w
add r0.xyz, -r2, r0
dp3 r0.w, r0, r0
rsq r2.w, r0.w
mul r1.w, r0, c16
mul r0.xyz, r2.w, r0
add r0.w, r1, c30.y
dp4 r2.w, v0, c7
rcp r0.w, r0.w
dp3 r1.w, r3, r0
mul r0.xyz, r0.w, c20
max r0.w, r1, c30.x
mul r0.xyz, r0, c29
mul r0.xyz, r0, r0.w
add r0.xyz, r4, r0
mul r1.xyz, r1, c28.x
add oT2.xyz, r0, r1
add r0.xyz, r2, -c12
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mov oT0, r2
mov oT1.xyz, r3
mov oT3, v2
mul oT4.xyz, r0.w, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec3 diffuseReflection;
  lowp float attenuation;
  lowp vec4 lightPosition;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.x;
  tmpvar_12.y = unity_4LightPosY0.x;
  tmpvar_12.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_14;
  tmpvar_14 = dot (tmpvar_13, tmpvar_13);
  highp float tmpvar_15;
  tmpvar_15 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_14))));
  attenuation = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = max (0.0, dot (tmpvar_3, normalize (tmpvar_13)));
  highp vec3 tmpvar_17;
  tmpvar_17 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_16);
  diffuseReflection = tmpvar_17;
  tmpvar_4 = diffuseReflection;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.x = unity_4LightPosX0.y;
  tmpvar_18.y = unity_4LightPosY0.y;
  tmpvar_18.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_18;
  lowp vec3 tmpvar_19;
  tmpvar_19 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_19, tmpvar_19);
  highp float tmpvar_21;
  tmpvar_21 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_20))));
  attenuation = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = max (0.0, dot (tmpvar_3, normalize (tmpvar_19)));
  highp vec3 tmpvar_23;
  tmpvar_23 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_22);
  diffuseReflection = tmpvar_23;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.x = unity_4LightPosX0.z;
  tmpvar_24.y = unity_4LightPosY0.z;
  tmpvar_24.z = unity_4LightPosZ0.z;
  lightPosition = tmpvar_24;
  lowp vec3 tmpvar_25;
  tmpvar_25 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, tmpvar_25);
  highp float tmpvar_27;
  tmpvar_27 = (1.0/((1.0 + (unity_4LightAtten0.z * tmpvar_26))));
  attenuation = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = max (0.0, dot (tmpvar_3, normalize (tmpvar_25)));
  highp vec3 tmpvar_29;
  tmpvar_29 = (((attenuation * unity_LightColor[2].xyz) * _Color.xyz) * tmpvar_28);
  diffuseReflection = tmpvar_29;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.x = unity_4LightPosX0.w;
  tmpvar_30.y = unity_4LightPosY0.w;
  tmpvar_30.z = unity_4LightPosZ0.w;
  lightPosition = tmpvar_30;
  lowp vec3 tmpvar_31;
  tmpvar_31 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_32;
  tmpvar_32 = dot (tmpvar_31, tmpvar_31);
  highp float tmpvar_33;
  tmpvar_33 = (1.0/((1.0 + (unity_4LightAtten0.w * tmpvar_32))));
  attenuation = tmpvar_33;
  lowp float tmpvar_34;
  tmpvar_34 = max (0.0, dot (tmpvar_3, normalize (tmpvar_31)));
  highp vec3 tmpvar_35;
  tmpvar_35 = (((attenuation * unity_LightColor[3].xyz) * _Color.xyz) * tmpvar_34);
  diffuseReflection = tmpvar_35;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  lowp vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = tmpvar_3;
  mediump vec3 tmpvar_37;
  mediump vec4 normal;
  normal = tmpvar_36;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_38;
  tmpvar_38 = dot (unity_SHAr, normal);
  x1.x = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = dot (unity_SHAg, normal);
  x1.y = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = dot (unity_SHAb, normal);
  x1.z = tmpvar_40;
  mediump vec4 tmpvar_41;
  tmpvar_41 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_42;
  tmpvar_42 = dot (unity_SHBr, tmpvar_41);
  x2.x = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = dot (unity_SHBg, tmpvar_41);
  x2.y = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = dot (unity_SHBb, tmpvar_41);
  x2.z = tmpvar_44;
  mediump float tmpvar_45;
  tmpvar_45 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_45;
  highp vec3 tmpvar_46;
  tmpvar_46 = (unity_SHC.xyz * vC);
  x3 = tmpvar_46;
  tmpvar_37 = ((x1 + x2) + x3);
  shl = tmpvar_37;
  highp vec3 tmpvar_47;
  tmpvar_47 = (tmpvar_4 + (shl * _SHLightingScale));
  tmpvar_4 = tmpvar_47;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec3 diffuseReflection;
  lowp float attenuation;
  lowp vec4 lightPosition;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.x;
  tmpvar_12.y = unity_4LightPosY0.x;
  tmpvar_12.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_14;
  tmpvar_14 = dot (tmpvar_13, tmpvar_13);
  highp float tmpvar_15;
  tmpvar_15 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_14))));
  attenuation = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = max (0.0, dot (tmpvar_3, normalize (tmpvar_13)));
  highp vec3 tmpvar_17;
  tmpvar_17 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_16);
  diffuseReflection = tmpvar_17;
  tmpvar_4 = diffuseReflection;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.x = unity_4LightPosX0.y;
  tmpvar_18.y = unity_4LightPosY0.y;
  tmpvar_18.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_18;
  lowp vec3 tmpvar_19;
  tmpvar_19 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_19, tmpvar_19);
  highp float tmpvar_21;
  tmpvar_21 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_20))));
  attenuation = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = max (0.0, dot (tmpvar_3, normalize (tmpvar_19)));
  highp vec3 tmpvar_23;
  tmpvar_23 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_22);
  diffuseReflection = tmpvar_23;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.x = unity_4LightPosX0.z;
  tmpvar_24.y = unity_4LightPosY0.z;
  tmpvar_24.z = unity_4LightPosZ0.z;
  lightPosition = tmpvar_24;
  lowp vec3 tmpvar_25;
  tmpvar_25 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, tmpvar_25);
  highp float tmpvar_27;
  tmpvar_27 = (1.0/((1.0 + (unity_4LightAtten0.z * tmpvar_26))));
  attenuation = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = max (0.0, dot (tmpvar_3, normalize (tmpvar_25)));
  highp vec3 tmpvar_29;
  tmpvar_29 = (((attenuation * unity_LightColor[2].xyz) * _Color.xyz) * tmpvar_28);
  diffuseReflection = tmpvar_29;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.x = unity_4LightPosX0.w;
  tmpvar_30.y = unity_4LightPosY0.w;
  tmpvar_30.z = unity_4LightPosZ0.w;
  lightPosition = tmpvar_30;
  lowp vec3 tmpvar_31;
  tmpvar_31 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_32;
  tmpvar_32 = dot (tmpvar_31, tmpvar_31);
  highp float tmpvar_33;
  tmpvar_33 = (1.0/((1.0 + (unity_4LightAtten0.w * tmpvar_32))));
  attenuation = tmpvar_33;
  lowp float tmpvar_34;
  tmpvar_34 = max (0.0, dot (tmpvar_3, normalize (tmpvar_31)));
  highp vec3 tmpvar_35;
  tmpvar_35 = (((attenuation * unity_LightColor[3].xyz) * _Color.xyz) * tmpvar_34);
  diffuseReflection = tmpvar_35;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  lowp vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = tmpvar_3;
  mediump vec3 tmpvar_37;
  mediump vec4 normal;
  normal = tmpvar_36;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_38;
  tmpvar_38 = dot (unity_SHAr, normal);
  x1.x = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = dot (unity_SHAg, normal);
  x1.y = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = dot (unity_SHAb, normal);
  x1.z = tmpvar_40;
  mediump vec4 tmpvar_41;
  tmpvar_41 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_42;
  tmpvar_42 = dot (unity_SHBr, tmpvar_41);
  x2.x = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = dot (unity_SHBg, tmpvar_41);
  x2.y = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = dot (unity_SHBb, tmpvar_41);
  x2.z = tmpvar_44;
  mediump float tmpvar_45;
  tmpvar_45 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_45;
  highp vec3 tmpvar_46;
  tmpvar_46 = (unity_SHC.xyz * vC);
  x3 = tmpvar_46;
  tmpvar_37 = ((x1 + x2) + x3);
  shl = tmpvar_37;
  highp vec3 tmpvar_47;
  tmpvar_47 = (tmpvar_4 + (shl * _SHLightingScale));
  tmpvar_4 = tmpvar_47;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_4LightPosX0]
Vector 14 [unity_4LightPosY0]
Vector 15 [unity_4LightPosZ0]
Vector 16 [unity_4LightAtten0]
Vector 17 [unity_LightColor0]
Vector 18 [unity_LightColor1]
Vector 19 [unity_LightColor2]
Vector 20 [unity_LightColor3]
Vector 21 [unity_SHAr]
Vector 22 [unity_SHAg]
Vector 23 [unity_SHAb]
Vector 24 [unity_SHBr]
Vector 25 [unity_SHBg]
Vector 26 [unity_SHBb]
Vector 27 [unity_SHC]
Float 28 [_SHLightingScale]
Vector 29 [_Color]
"agal_vs
c30 0.0 1.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r1.xyz, a1.z, c10
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
abaaaaaaabaaahacabaaaakeacaaaaaaboaaaaaaabaaaaaa add r1.xyz, r1.xyzz, c30.x
bcaaaaaaaaaaaiacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.w, r1.xyzz, r1.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaadaaahacaaaaaappacaaaaaaabaaaakeacaaaaaa mul r3.xyz, r0.w, r1.xyzz
bdaaaaaaacaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r2.z, a0, c6
bdaaaaaaacaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r2.y, a0, c5
bdaaaaaaacaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r2.x, a0, c4
aaaaaaaaaaaaabacanaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13.z
aaaaaaaaaaaaaeacapaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.z, c15
aaaaaaaaaaaaacacaoaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c14.z
bfaaaaaaaeaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r2.xyzz
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r4.xyzz, r0.xyzz
bcaaaaaaabaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r1.w, r0.xyzz, r0.xyzz
akaaaaaaacaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r1.w
adaaaaaaaaaaahacacaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r2.w, r0.xyzz
bcaaaaaaaaaaacacadaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.y, r3.xyzz, r0.xyzz
adaaaaaaaaaaabacabaaaappacaaaaaabaaaaakkabaaaaaa mul r0.x, r1.w, c16.z
abaaaaaaaaaaaiacaaaaaaaaacaaaaaaboaaaaffabaaaaaa add r0.w, r0.x, c30.y
ahaaaaaaacaaaiacaaaaaaffacaaaaaaboaaaaaaabaaaaaa max r2.w, r0.y, c30.x
afaaaaaaabaaabacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r0.w
adaaaaaaabaaahacabaaaaaaacaaaaaabdaaaaoeabaaaaaa mul r1.xyz, r1.x, c19
adaaaaaaabaaahacabaaaakeacaaaaaabnaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c29
adaaaaaaaeaaahacabaaaakeacaaaaaaacaaaappacaaaaaa mul r4.xyz, r1.xyzz, r2.w
aaaaaaaaaaaaabacanaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13.y
aaaaaaaaaaaaaeacapaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.z, c15.y
aaaaaaaaaaaaacacaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c14
bfaaaaaaafaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r2.xyzz
abaaaaaaaaaaahacafaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r5.xyzz, r0.xyzz
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaabaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r0.w
adaaaaaaaaaaahacabaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.w, r0.xyzz
bcaaaaaaaaaaacacadaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.y, r3.xyzz, r0.xyzz
ahaaaaaaabaaaiacaaaaaaffacaaaaaaboaaaaaaabaaaaaa max r1.w, r0.y, c30.x
adaaaaaaaaaaaiacaaaaaappacaaaaaabaaaaaffabaaaaaa mul r0.w, r0.w, c16.y
abaaaaaaaaaaabacaaaaaappacaaaaaaboaaaaffabaaaaaa add r0.x, r0.w, c30.y
afaaaaaaaaaaaiacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.w, r0.x
adaaaaaaabaaahacaaaaaappacaaaaaabcaaaaoeabaaaaaa mul r1.xyz, r0.w, c18
adaaaaaaabaaahacabaaaakeacaaaaaabnaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c29
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaappacaaaaaa mul r1.xyz, r1.xyzz, r1.w
aaaaaaaaaaaaabacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13
aaaaaaaaaaaaaeacapaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.z, c15.x
aaaaaaaaaaaaacacaoaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c14.x
bfaaaaaaagaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyz, r2.xyzz
abaaaaaaaaaaahacagaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r6.xyzz, r0.xyzz
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaacaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r0.w
adaaaaaaabaaaiacaaaaaappacaaaaaabaaaaaaaabaaaaaa mul r1.w, r0.w, c16.x
adaaaaaaaaaaahacacaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r2.w, r0.xyzz
abaaaaaaaaaaaiacabaaaappacaaaaaaboaaaaffabaaaaaa add r0.w, r1.w, c30.y
bcaaaaaaabaaaiacadaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r1.w, r3.xyzz, r0.xyzz
afaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.w, r0.w
adaaaaaaaaaaahacaaaaaappacaaaaaabbaaaaoeabaaaaaa mul r0.xyz, r0.w, c17
ahaaaaaaaaaaaiacabaaaappacaaaaaaboaaaaaaabaaaaaa max r0.w, r1.w, c30.x
adaaaaaaaaaaahacaaaaaakeacaaaaaabnaaaaoeabaaaaaa mul r0.xyz, r0.xyzz, c29
adaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaappacaaaaaa mul r0.xyz, r0.xyzz, r0.w
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
abaaaaaaaeaaahacaaaaaakeacaaaaaaaeaaaakeacaaaaaa add r4.xyz, r0.xyzz, r4.xyzz
aaaaaaaaaaaaahacadaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, r3.xyzz
aaaaaaaaaaaaaiacboaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c30.y
bdaaaaaaafaaaeacaaaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r5.z, r0, c23
bdaaaaaaafaaacacaaaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r5.y, r0, c22
bdaaaaaaafaaabacaaaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r5.x, r0, c21
adaaaaaaabaaapacadaaaakeacaaaaaaadaaaacjacaaaaaa mul r1, r3.xyzz, r3.yzzx
adaaaaaaacaaaiacadaaaaffacaaaaaaadaaaaffacaaaaaa mul r2.w, r3.y, r3.y
bdaaaaaaaaaaaeacabaaaaoeacaaaaaabkaaaaoeabaaaaaa dp4 r0.z, r1, c26
bdaaaaaaaaaaabacabaaaaoeacaaaaaabiaaaaoeabaaaaaa dp4 r0.x, r1, c24
bdaaaaaaaaaaacacabaaaaoeacaaaaaabjaaaaoeabaaaaaa dp4 r0.y, r1, c25
abaaaaaaabaaahacafaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r5.xyzz, r0.xyzz
adaaaaaaagaaaiacadaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r6.w, r3.x, r3.x
acaaaaaaaaaaaiacagaaaappacaaaaaaacaaaappacaaaaaa sub r0.w, r6.w, r2.w
adaaaaaaafaaahacaaaaaappacaaaaaablaaaaoeabaaaaaa mul r5.xyz, r0.w, c27
abaaaaaaabaaahacabaaaakeacaaaaaaafaaaakeacaaaaaa add r1.xyz, r1.xyzz, r5.xyzz
aaaaaaaaaaaaabacanaaaappabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13.w
aaaaaaaaaaaaaeacapaaaappabaaaaaaaaaaaaaaaaaaaaaa mov r0.z, c15.w
aaaaaaaaaaaaacacaoaaaappabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c14.w
bfaaaaaaagaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyz, r2.xyzz
abaaaaaaaaaaahacagaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r6.xyzz, r0.xyzz
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaacaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r0.w
adaaaaaaabaaaiacaaaaaappacaaaaaabaaaaaoeabaaaaaa mul r1.w, r0.w, c16
adaaaaaaaaaaahacacaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r2.w, r0.xyzz
abaaaaaaaaaaaiacabaaaappacaaaaaaboaaaaffabaaaaaa add r0.w, r1.w, c30.y
bdaaaaaaacaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r2.w, a0, c7
afaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.w, r0.w
bcaaaaaaabaaaiacadaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r1.w, r3.xyzz, r0.xyzz
adaaaaaaaaaaahacaaaaaappacaaaaaabeaaaaoeabaaaaaa mul r0.xyz, r0.w, c20
ahaaaaaaaaaaaiacabaaaappacaaaaaaboaaaaaaabaaaaaa max r0.w, r1.w, c30.x
adaaaaaaaaaaahacaaaaaakeacaaaaaabnaaaaoeabaaaaaa mul r0.xyz, r0.xyzz, c29
adaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaappacaaaaaa mul r0.xyz, r0.xyzz, r0.w
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r4.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaabmaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c28.x
abaaaaaaacaaahaeaaaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r0.xyzz, r1.xyzz
acaaaaaaaaaaahacacaaaakeacaaaaaaamaaaaoeabaaaaaa sub r0.xyz, r2.xyzz, c12
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
aaaaaaaaaaaaapaeacaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r2
aaaaaaaaabaaahaeadaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xyz, r3.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
adaaaaaaaeaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v4.xyz, r0.w, r0.xyzz
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_4LightPosX0]
Vector 15 [unity_4LightPosY0]
Vector 16 [unity_4LightPosZ0]
Vector 17 [unity_4LightAtten0]
Vector 18 [unity_LightColor0]
Vector 19 [unity_LightColor1]
Vector 20 [unity_LightColor2]
Vector 21 [unity_LightColor3]
Vector 22 [unity_SHAr]
Vector 23 [unity_SHAg]
Vector 24 [unity_SHAb]
Vector 25 [unity_SHBr]
Vector 26 [unity_SHBg]
Vector 27 [unity_SHBb]
Vector 28 [unity_SHC]
Float 29 [_SHLightingScale]
Vector 30 [_Color]
"!!ARBvp1.0
# 101 ALU
PARAM c[31] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..30] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R1.xyz, vertex.normal.z, c[11], R0;
ADD R1.xyz, R1, c[0].x;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
MUL R3.xyz, R0.w, R1;
DP4 R2.z, vertex.position, c[7];
DP4 R2.y, vertex.position, c[6];
DP4 R2.x, vertex.position, c[5];
MOV R0.x, c[14].z;
MOV R0.z, c[16];
MOV R0.y, c[15].z;
ADD R0.xyz, -R2, R0;
DP3 R1.w, R0, R0;
RSQ R2.w, R1.w;
MUL R0.xyz, R2.w, R0;
DP3 R0.y, R3, R0;
MUL R0.x, R1.w, c[17].z;
ADD R0.w, R0.x, c[0].y;
MAX R2.w, R0.y, c[0].x;
RCP R1.x, R0.w;
MUL R1.xyz, R1.x, c[20];
MUL R1.xyz, R1, c[30];
MUL R4.xyz, R1, R2.w;
MOV R0.x, c[14].y;
MOV R0.z, c[16].y;
MOV R0.y, c[15];
ADD R0.xyz, -R2, R0;
DP3 R0.w, R0, R0;
RSQ R1.w, R0.w;
MUL R0.xyz, R1.w, R0;
DP3 R0.y, R3, R0;
MAX R1.w, R0.y, c[0].x;
MUL R0.w, R0, c[17].y;
ADD R0.x, R0.w, c[0].y;
RCP R0.w, R0.x;
MUL R1.xyz, R0.w, c[19];
MUL R1.xyz, R1, c[30];
MUL R1.xyz, R1, R1.w;
MOV R0.x, c[14];
MOV R0.z, c[16].x;
MOV R0.y, c[15].x;
ADD R0.xyz, -R2, R0;
DP3 R0.w, R0, R0;
RSQ R2.w, R0.w;
MUL R1.w, R0, c[17].x;
MUL R0.xyz, R2.w, R0;
ADD R0.w, R1, c[0].y;
DP3 R1.w, R3, R0;
RCP R0.w, R0.w;
MUL R0.xyz, R0.w, c[18];
MAX R0.w, R1, c[0].x;
MUL R0.xyz, R0, c[30];
MUL R0.xyz, R0, R0.w;
ADD R0.xyz, R0, R1;
ADD R4.xyz, R0, R4;
MOV R0.xyz, R3;
MOV R0.w, c[0].y;
DP4 R5.z, R0, c[24];
DP4 R5.y, R0, c[23];
DP4 R5.x, R0, c[22];
MUL R1, R3.xyzz, R3.yzzx;
MUL R2.w, R3.y, R3.y;
MAD R0.w, R3.x, R3.x, -R2;
DP4 R2.w, vertex.position, c[8];
DP4 R0.z, R1, c[27];
DP4 R0.x, R1, c[25];
DP4 R0.y, R1, c[26];
ADD R1.xyz, R5, R0;
MUL R5.xyz, R0.w, c[28];
ADD R1.xyz, R1, R5;
MOV R0.x, c[14].w;
MOV R0.z, c[16].w;
MOV R0.y, c[15].w;
ADD R0.xyz, -R2, R0;
DP3 R0.w, R0, R0;
MUL R1.w, R0, c[17];
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, R0;
ADD R1.w, R1, c[0].y;
RCP R0.w, R1.w;
DP3 R1.w, R3, R0;
MUL R0.xyz, R0.w, c[21];
MAX R0.w, R1, c[0].x;
MUL R0.xyz, R0, c[30];
MUL R0.xyz, R0, R0.w;
ADD R0.xyz, R4, R0;
MUL R1.xyz, R1, c[29].x;
ADD result.texcoord[2].xyz, R0, R1;
ADD R0.xyz, R2, -c[13];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MOV result.texcoord[0], R2;
MOV result.texcoord[1].xyz, R3;
MOV result.texcoord[3], vertex.texcoord[0];
MUL result.texcoord[4].xyz, R0.w, R0;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 101 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_4LightPosX0]
Vector 14 [unity_4LightPosY0]
Vector 15 [unity_4LightPosZ0]
Vector 16 [unity_4LightAtten0]
Vector 17 [unity_LightColor0]
Vector 18 [unity_LightColor1]
Vector 19 [unity_LightColor2]
Vector 20 [unity_LightColor3]
Vector 21 [unity_SHAr]
Vector 22 [unity_SHAg]
Vector 23 [unity_SHAb]
Vector 24 [unity_SHBr]
Vector 25 [unity_SHBg]
Vector 26 [unity_SHBb]
Vector 27 [unity_SHC]
Float 28 [_SHLightingScale]
Vector 29 [_Color]
"vs_2_0
; 101 ALU
def c30, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r1.xyz, v1.z, c10, r0
add r1.xyz, r1, c30.x
dp3 r0.w, r1, r1
rsq r0.w, r0.w
mul r3.xyz, r0.w, r1
dp4 r2.z, v0, c6
dp4 r2.y, v0, c5
dp4 r2.x, v0, c4
mov r0.x, c13.z
mov r0.z, c15
mov r0.y, c14.z
add r0.xyz, -r2, r0
dp3 r1.w, r0, r0
rsq r2.w, r1.w
mul r0.xyz, r2.w, r0
dp3 r0.y, r3, r0
mul r0.x, r1.w, c16.z
add r0.w, r0.x, c30.y
max r2.w, r0.y, c30.x
rcp r1.x, r0.w
mul r1.xyz, r1.x, c19
mul r1.xyz, r1, c29
mul r4.xyz, r1, r2.w
mov r0.x, c13.y
mov r0.z, c15.y
mov r0.y, c14
add r0.xyz, -r2, r0
dp3 r0.w, r0, r0
rsq r1.w, r0.w
mul r0.xyz, r1.w, r0
dp3 r0.y, r3, r0
max r1.w, r0.y, c30.x
mul r0.w, r0, c16.y
add r0.x, r0.w, c30.y
rcp r0.w, r0.x
mul r1.xyz, r0.w, c18
mul r1.xyz, r1, c29
mul r1.xyz, r1, r1.w
mov r0.x, c13
mov r0.z, c15.x
mov r0.y, c14.x
add r0.xyz, -r2, r0
dp3 r0.w, r0, r0
rsq r2.w, r0.w
mul r1.w, r0, c16.x
mul r0.xyz, r2.w, r0
add r0.w, r1, c30.y
dp3 r1.w, r3, r0
rcp r0.w, r0.w
mul r0.xyz, r0.w, c17
max r0.w, r1, c30.x
mul r0.xyz, r0, c29
mul r0.xyz, r0, r0.w
add r0.xyz, r0, r1
add r4.xyz, r0, r4
mov r0.xyz, r3
mov r0.w, c30.y
dp4 r5.z, r0, c23
dp4 r5.y, r0, c22
dp4 r5.x, r0, c21
mul r1, r3.xyzz, r3.yzzx
mul r2.w, r3.y, r3.y
dp4 r0.z, r1, c26
dp4 r0.x, r1, c24
dp4 r0.y, r1, c25
add r1.xyz, r5, r0
mad r0.w, r3.x, r3.x, -r2
mul r5.xyz, r0.w, c27
add r1.xyz, r1, r5
mov r0.x, c13.w
mov r0.z, c15.w
mov r0.y, c14.w
add r0.xyz, -r2, r0
dp3 r0.w, r0, r0
rsq r2.w, r0.w
mul r1.w, r0, c16
mul r0.xyz, r2.w, r0
add r0.w, r1, c30.y
dp4 r2.w, v0, c7
rcp r0.w, r0.w
dp3 r1.w, r3, r0
mul r0.xyz, r0.w, c20
max r0.w, r1, c30.x
mul r0.xyz, r0, c29
mul r0.xyz, r0, r0.w
add r0.xyz, r4, r0
mul r1.xyz, r1, c28.x
add oT2.xyz, r0, r1
add r0.xyz, r2, -c12
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mov oT0, r2
mov oT1.xyz, r3
mov oT3, v2
mul oT4.xyz, r0.w, r0
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec3 diffuseReflection;
  lowp float attenuation;
  lowp vec4 lightPosition;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.x;
  tmpvar_12.y = unity_4LightPosY0.x;
  tmpvar_12.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_14;
  tmpvar_14 = dot (tmpvar_13, tmpvar_13);
  highp float tmpvar_15;
  tmpvar_15 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_14))));
  attenuation = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = max (0.0, dot (tmpvar_3, normalize (tmpvar_13)));
  highp vec3 tmpvar_17;
  tmpvar_17 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_16);
  diffuseReflection = tmpvar_17;
  tmpvar_4 = diffuseReflection;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.x = unity_4LightPosX0.y;
  tmpvar_18.y = unity_4LightPosY0.y;
  tmpvar_18.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_18;
  lowp vec3 tmpvar_19;
  tmpvar_19 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_19, tmpvar_19);
  highp float tmpvar_21;
  tmpvar_21 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_20))));
  attenuation = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = max (0.0, dot (tmpvar_3, normalize (tmpvar_19)));
  highp vec3 tmpvar_23;
  tmpvar_23 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_22);
  diffuseReflection = tmpvar_23;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.x = unity_4LightPosX0.z;
  tmpvar_24.y = unity_4LightPosY0.z;
  tmpvar_24.z = unity_4LightPosZ0.z;
  lightPosition = tmpvar_24;
  lowp vec3 tmpvar_25;
  tmpvar_25 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, tmpvar_25);
  highp float tmpvar_27;
  tmpvar_27 = (1.0/((1.0 + (unity_4LightAtten0.z * tmpvar_26))));
  attenuation = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = max (0.0, dot (tmpvar_3, normalize (tmpvar_25)));
  highp vec3 tmpvar_29;
  tmpvar_29 = (((attenuation * unity_LightColor[2].xyz) * _Color.xyz) * tmpvar_28);
  diffuseReflection = tmpvar_29;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.x = unity_4LightPosX0.w;
  tmpvar_30.y = unity_4LightPosY0.w;
  tmpvar_30.z = unity_4LightPosZ0.w;
  lightPosition = tmpvar_30;
  lowp vec3 tmpvar_31;
  tmpvar_31 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_32;
  tmpvar_32 = dot (tmpvar_31, tmpvar_31);
  highp float tmpvar_33;
  tmpvar_33 = (1.0/((1.0 + (unity_4LightAtten0.w * tmpvar_32))));
  attenuation = tmpvar_33;
  lowp float tmpvar_34;
  tmpvar_34 = max (0.0, dot (tmpvar_3, normalize (tmpvar_31)));
  highp vec3 tmpvar_35;
  tmpvar_35 = (((attenuation * unity_LightColor[3].xyz) * _Color.xyz) * tmpvar_34);
  diffuseReflection = tmpvar_35;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  lowp vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = tmpvar_3;
  mediump vec3 tmpvar_37;
  mediump vec4 normal;
  normal = tmpvar_36;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_38;
  tmpvar_38 = dot (unity_SHAr, normal);
  x1.x = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = dot (unity_SHAg, normal);
  x1.y = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = dot (unity_SHAb, normal);
  x1.z = tmpvar_40;
  mediump vec4 tmpvar_41;
  tmpvar_41 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_42;
  tmpvar_42 = dot (unity_SHBr, tmpvar_41);
  x2.x = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = dot (unity_SHBg, tmpvar_41);
  x2.y = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = dot (unity_SHBb, tmpvar_41);
  x2.z = tmpvar_44;
  mediump float tmpvar_45;
  tmpvar_45 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_45;
  highp vec3 tmpvar_46;
  tmpvar_46 = (unity_SHC.xyz * vC);
  x3 = tmpvar_46;
  tmpvar_37 = ((x1 + x2) + x3);
  shl = tmpvar_37;
  highp vec3 tmpvar_47;
  tmpvar_47 = (tmpvar_4 + (shl * _SHLightingScale));
  tmpvar_4 = tmpvar_47;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform lowp float _SHLightingScale;
uniform highp mat4 _Object2World;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  highp vec3 shl;
  lowp vec3 diffuseReflection;
  lowp float attenuation;
  lowp vec4 lightPosition;
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (_Object2World * _glesVertex);
  tmpvar_2 = tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  tmpvar_1 = tmpvar_9;
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.x = unity_4LightPosX0.x;
  tmpvar_12.y = unity_4LightPosY0.x;
  tmpvar_12.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_14;
  tmpvar_14 = dot (tmpvar_13, tmpvar_13);
  highp float tmpvar_15;
  tmpvar_15 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_14))));
  attenuation = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = max (0.0, dot (tmpvar_3, normalize (tmpvar_13)));
  highp vec3 tmpvar_17;
  tmpvar_17 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_16);
  diffuseReflection = tmpvar_17;
  tmpvar_4 = diffuseReflection;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.x = unity_4LightPosX0.y;
  tmpvar_18.y = unity_4LightPosY0.y;
  tmpvar_18.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_18;
  lowp vec3 tmpvar_19;
  tmpvar_19 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_20;
  tmpvar_20 = dot (tmpvar_19, tmpvar_19);
  highp float tmpvar_21;
  tmpvar_21 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_20))));
  attenuation = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = max (0.0, dot (tmpvar_3, normalize (tmpvar_19)));
  highp vec3 tmpvar_23;
  tmpvar_23 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_22);
  diffuseReflection = tmpvar_23;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.x = unity_4LightPosX0.z;
  tmpvar_24.y = unity_4LightPosY0.z;
  tmpvar_24.z = unity_4LightPosZ0.z;
  lightPosition = tmpvar_24;
  lowp vec3 tmpvar_25;
  tmpvar_25 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_26;
  tmpvar_26 = dot (tmpvar_25, tmpvar_25);
  highp float tmpvar_27;
  tmpvar_27 = (1.0/((1.0 + (unity_4LightAtten0.z * tmpvar_26))));
  attenuation = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = max (0.0, dot (tmpvar_3, normalize (tmpvar_25)));
  highp vec3 tmpvar_29;
  tmpvar_29 = (((attenuation * unity_LightColor[2].xyz) * _Color.xyz) * tmpvar_28);
  diffuseReflection = tmpvar_29;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.x = unity_4LightPosX0.w;
  tmpvar_30.y = unity_4LightPosY0.w;
  tmpvar_30.z = unity_4LightPosZ0.w;
  lightPosition = tmpvar_30;
  lowp vec3 tmpvar_31;
  tmpvar_31 = (lightPosition - tmpvar_2).xyz;
  lowp float tmpvar_32;
  tmpvar_32 = dot (tmpvar_31, tmpvar_31);
  highp float tmpvar_33;
  tmpvar_33 = (1.0/((1.0 + (unity_4LightAtten0.w * tmpvar_32))));
  attenuation = tmpvar_33;
  lowp float tmpvar_34;
  tmpvar_34 = max (0.0, dot (tmpvar_3, normalize (tmpvar_31)));
  highp vec3 tmpvar_35;
  tmpvar_35 = (((attenuation * unity_LightColor[3].xyz) * _Color.xyz) * tmpvar_34);
  diffuseReflection = tmpvar_35;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  lowp vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = tmpvar_3;
  mediump vec3 tmpvar_37;
  mediump vec4 normal;
  normal = tmpvar_36;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_38;
  tmpvar_38 = dot (unity_SHAr, normal);
  x1.x = tmpvar_38;
  highp float tmpvar_39;
  tmpvar_39 = dot (unity_SHAg, normal);
  x1.y = tmpvar_39;
  highp float tmpvar_40;
  tmpvar_40 = dot (unity_SHAb, normal);
  x1.z = tmpvar_40;
  mediump vec4 tmpvar_41;
  tmpvar_41 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_42;
  tmpvar_42 = dot (unity_SHBr, tmpvar_41);
  x2.x = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = dot (unity_SHBg, tmpvar_41);
  x2.y = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = dot (unity_SHBb, tmpvar_41);
  x2.z = tmpvar_44;
  mediump float tmpvar_45;
  tmpvar_45 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_45;
  highp vec3 tmpvar_46;
  tmpvar_46 = (unity_SHC.xyz * vC);
  x3 = tmpvar_46;
  tmpvar_37 = ((x1 + x2) + x3);
  shl = tmpvar_37;
  highp vec3 tmpvar_47;
  tmpvar_47 = (tmpvar_4 + (shl * _SHLightingScale));
  tmpvar_4 = tmpvar_47;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT
#define unity_LightColor0 _glesLightSource[0].diffuse
#define unity_LightColor1 _glesLightSource[1].diffuse
#define unity_LightColor2 _glesLightSource[2].diffuse
#define unity_LightColor3 _glesLightSource[3].diffuse
#define unity_LightPosition0 _glesLightSource[0].position
#define unity_LightPosition1 _glesLightSource[1].position
#define unity_LightPosition2 _glesLightSource[2].position
#define unity_LightPosition3 _glesLightSource[3].position
#define glstate_light0_spotDirection _glesLightSource[0].spotDirection
#define glstate_light1_spotDirection _glesLightSource[1].spotDirection
#define glstate_light2_spotDirection _glesLightSource[2].spotDirection
#define glstate_light3_spotDirection _glesLightSource[3].spotDirection
#define unity_LightAtten0 _glesLightSource[0].atten
#define unity_LightAtten1 _glesLightSource[1].atten
#define unity_LightAtten2 _glesLightSource[2].atten
#define unity_LightAtten3 _glesLightSource[3].atten
#define glstate_lightmodel_ambient _glesLightModel.ambient
#define gl_LightSource _glesLightSource
#define gl_LightSourceParameters _glesLightSourceParameters
struct _glesLightSourceParameters {
  vec4 diffuse;
  vec4 position;
  vec3 spotDirection;
  vec4 atten;
};
uniform _glesLightSourceParameters _glesLightSource[4];
#define gl_LightModel _glesLightModel
#define gl_LightModelParameters _glesLightModelParameters
struct _glesLightModelParameters {
  vec4 ambient;
};
uniform _glesLightModelParameters _glesLightModel;
#define gl_FrontMaterial _glesFrontMaterial
#define gl_BackMaterial _glesFrontMaterial
#define gl_MaterialParameters _glesMaterialParameters
struct _glesMaterialParameters {
  vec4 emission;
  vec4 ambient;
  vec4 diffuse;
  vec4 specular;
  float shininess;
};
uniform _glesMaterialParameters _glesFrontMaterial;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying lowp vec4 xlv_TEXCOORD0;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform lowp float _Shininess;
uniform lowp float _Reflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    lowp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    attenuation = (1.0/(length (tmpvar_4)));
    lightDirection = normalize (tmpvar_4);
  };
  highp vec3 tmpvar_5;
  tmpvar_5 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_5;
  lowp vec3 tmpvar_6;
  tmpvar_6 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_7;
  tmpvar_7 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_7 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    specularReflection = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection)), _Shininess));
  };
  mediump vec3 tmpvar_8;
  tmpvar_8 = (specularReflection * _Gloss);
  specularReflection = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9 = textureCube (_Cube, reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1)));
  reflTex = tmpvar_9;
  reflTex.xyz = (tmpvar_9.xyz * _Reflection);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (tmpvar_10 + reflTex);
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_4LightPosX0]
Vector 14 [unity_4LightPosY0]
Vector 15 [unity_4LightPosZ0]
Vector 16 [unity_4LightAtten0]
Vector 17 [unity_LightColor0]
Vector 18 [unity_LightColor1]
Vector 19 [unity_LightColor2]
Vector 20 [unity_LightColor3]
Vector 21 [unity_SHAr]
Vector 22 [unity_SHAg]
Vector 23 [unity_SHAb]
Vector 24 [unity_SHBr]
Vector 25 [unity_SHBg]
Vector 26 [unity_SHBb]
Vector 27 [unity_SHC]
Float 28 [_SHLightingScale]
Vector 29 [_Color]
"agal_vs
c30 0.0 1.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r1.xyz, a1.z, c10
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
abaaaaaaabaaahacabaaaakeacaaaaaaboaaaaaaabaaaaaa add r1.xyz, r1.xyzz, c30.x
bcaaaaaaaaaaaiacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.w, r1.xyzz, r1.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaadaaahacaaaaaappacaaaaaaabaaaakeacaaaaaa mul r3.xyz, r0.w, r1.xyzz
bdaaaaaaacaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r2.z, a0, c6
bdaaaaaaacaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r2.y, a0, c5
bdaaaaaaacaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r2.x, a0, c4
aaaaaaaaaaaaabacanaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13.z
aaaaaaaaaaaaaeacapaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.z, c15
aaaaaaaaaaaaacacaoaaaakkabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c14.z
bfaaaaaaaeaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r2.xyzz
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r4.xyzz, r0.xyzz
bcaaaaaaabaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r1.w, r0.xyzz, r0.xyzz
akaaaaaaacaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r1.w
adaaaaaaaaaaahacacaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r2.w, r0.xyzz
bcaaaaaaaaaaacacadaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.y, r3.xyzz, r0.xyzz
adaaaaaaaaaaabacabaaaappacaaaaaabaaaaakkabaaaaaa mul r0.x, r1.w, c16.z
abaaaaaaaaaaaiacaaaaaaaaacaaaaaaboaaaaffabaaaaaa add r0.w, r0.x, c30.y
ahaaaaaaacaaaiacaaaaaaffacaaaaaaboaaaaaaabaaaaaa max r2.w, r0.y, c30.x
afaaaaaaabaaabacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r0.w
adaaaaaaabaaahacabaaaaaaacaaaaaabdaaaaoeabaaaaaa mul r1.xyz, r1.x, c19
adaaaaaaabaaahacabaaaakeacaaaaaabnaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c29
adaaaaaaaeaaahacabaaaakeacaaaaaaacaaaappacaaaaaa mul r4.xyz, r1.xyzz, r2.w
aaaaaaaaaaaaabacanaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13.y
aaaaaaaaaaaaaeacapaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.z, c15.y
aaaaaaaaaaaaacacaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c14
bfaaaaaaafaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r2.xyzz
abaaaaaaaaaaahacafaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r5.xyzz, r0.xyzz
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaabaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r0.w
adaaaaaaaaaaahacabaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r1.w, r0.xyzz
bcaaaaaaaaaaacacadaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.y, r3.xyzz, r0.xyzz
ahaaaaaaabaaaiacaaaaaaffacaaaaaaboaaaaaaabaaaaaa max r1.w, r0.y, c30.x
adaaaaaaaaaaaiacaaaaaappacaaaaaabaaaaaffabaaaaaa mul r0.w, r0.w, c16.y
abaaaaaaaaaaabacaaaaaappacaaaaaaboaaaaffabaaaaaa add r0.x, r0.w, c30.y
afaaaaaaaaaaaiacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r0.w, r0.x
adaaaaaaabaaahacaaaaaappacaaaaaabcaaaaoeabaaaaaa mul r1.xyz, r0.w, c18
adaaaaaaabaaahacabaaaakeacaaaaaabnaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c29
adaaaaaaabaaahacabaaaakeacaaaaaaabaaaappacaaaaaa mul r1.xyz, r1.xyzz, r1.w
aaaaaaaaaaaaabacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13
aaaaaaaaaaaaaeacapaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.z, c15.x
aaaaaaaaaaaaacacaoaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c14.x
bfaaaaaaagaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyz, r2.xyzz
abaaaaaaaaaaahacagaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r6.xyzz, r0.xyzz
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaacaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r0.w
adaaaaaaabaaaiacaaaaaappacaaaaaabaaaaaaaabaaaaaa mul r1.w, r0.w, c16.x
adaaaaaaaaaaahacacaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r2.w, r0.xyzz
abaaaaaaaaaaaiacabaaaappacaaaaaaboaaaaffabaaaaaa add r0.w, r1.w, c30.y
bcaaaaaaabaaaiacadaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r1.w, r3.xyzz, r0.xyzz
afaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.w, r0.w
adaaaaaaaaaaahacaaaaaappacaaaaaabbaaaaoeabaaaaaa mul r0.xyz, r0.w, c17
ahaaaaaaaaaaaiacabaaaappacaaaaaaboaaaaaaabaaaaaa max r0.w, r1.w, c30.x
adaaaaaaaaaaahacaaaaaakeacaaaaaabnaaaaoeabaaaaaa mul r0.xyz, r0.xyzz, c29
adaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaappacaaaaaa mul r0.xyz, r0.xyzz, r0.w
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
abaaaaaaaeaaahacaaaaaakeacaaaaaaaeaaaakeacaaaaaa add r4.xyz, r0.xyzz, r4.xyzz
aaaaaaaaaaaaahacadaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, r3.xyzz
aaaaaaaaaaaaaiacboaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c30.y
bdaaaaaaafaaaeacaaaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r5.z, r0, c23
bdaaaaaaafaaacacaaaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r5.y, r0, c22
bdaaaaaaafaaabacaaaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r5.x, r0, c21
adaaaaaaabaaapacadaaaakeacaaaaaaadaaaacjacaaaaaa mul r1, r3.xyzz, r3.yzzx
adaaaaaaacaaaiacadaaaaffacaaaaaaadaaaaffacaaaaaa mul r2.w, r3.y, r3.y
bdaaaaaaaaaaaeacabaaaaoeacaaaaaabkaaaaoeabaaaaaa dp4 r0.z, r1, c26
bdaaaaaaaaaaabacabaaaaoeacaaaaaabiaaaaoeabaaaaaa dp4 r0.x, r1, c24
bdaaaaaaaaaaacacabaaaaoeacaaaaaabjaaaaoeabaaaaaa dp4 r0.y, r1, c25
abaaaaaaabaaahacafaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r5.xyzz, r0.xyzz
adaaaaaaagaaaiacadaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r6.w, r3.x, r3.x
acaaaaaaaaaaaiacagaaaappacaaaaaaacaaaappacaaaaaa sub r0.w, r6.w, r2.w
adaaaaaaafaaahacaaaaaappacaaaaaablaaaaoeabaaaaaa mul r5.xyz, r0.w, c27
abaaaaaaabaaahacabaaaakeacaaaaaaafaaaakeacaaaaaa add r1.xyz, r1.xyzz, r5.xyzz
aaaaaaaaaaaaabacanaaaappabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13.w
aaaaaaaaaaaaaeacapaaaappabaaaaaaaaaaaaaaaaaaaaaa mov r0.z, c15.w
aaaaaaaaaaaaacacaoaaaappabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c14.w
bfaaaaaaagaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyz, r2.xyzz
abaaaaaaaaaaahacagaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r6.xyzz, r0.xyzz
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaacaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r0.w
adaaaaaaabaaaiacaaaaaappacaaaaaabaaaaaoeabaaaaaa mul r1.w, r0.w, c16
adaaaaaaaaaaahacacaaaappacaaaaaaaaaaaakeacaaaaaa mul r0.xyz, r2.w, r0.xyzz
abaaaaaaaaaaaiacabaaaappacaaaaaaboaaaaffabaaaaaa add r0.w, r1.w, c30.y
bdaaaaaaacaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r2.w, a0, c7
afaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.w, r0.w
bcaaaaaaabaaaiacadaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r1.w, r3.xyzz, r0.xyzz
adaaaaaaaaaaahacaaaaaappacaaaaaabeaaaaoeabaaaaaa mul r0.xyz, r0.w, c20
ahaaaaaaaaaaaiacabaaaappacaaaaaaboaaaaaaabaaaaaa max r0.w, r1.w, c30.x
adaaaaaaaaaaahacaaaaaakeacaaaaaabnaaaaoeabaaaaaa mul r0.xyz, r0.xyzz, c29
adaaaaaaaaaaahacaaaaaakeacaaaaaaaaaaaappacaaaaaa mul r0.xyz, r0.xyzz, r0.w
abaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r4.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaabmaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c28.x
abaaaaaaacaaahaeaaaaaakeacaaaaaaabaaaakeacaaaaaa add v2.xyz, r0.xyzz, r1.xyzz
acaaaaaaaaaaahacacaaaakeacaaaaaaamaaaaoeabaaaaaa sub r0.xyz, r2.xyzz, c12
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
aaaaaaaaaaaaapaeacaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r2
aaaaaaaaabaaahaeadaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xyz, r3.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
adaaaaaaaeaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v4.xyz, r0.w, r0.xyzz
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 48 to 48, TEX: 2 to 2
//   d3d9 - ALU: 49 to 49, TEX: 2 to 2
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Vector 8 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 48 ALU, 2 TEX
PARAM c[10] = { state.lightmodel.ambient,
		program.local[1..8],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEX R1.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R3.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R3, R3;
RSQ R3.w, R1.w;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R2, fragment.texcoord[4];
MUL R0.xyz, R2, R0.x;
MAD R0.xyz, -R0, c[9].z, fragment.texcoord[4];
ABS R1.w, -c[2];
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
CMP R1.w, -R1, c[9].y, c[9].x;
MUL R4.xyz, R2.w, c[2];
ABS R1.w, R1;
CMP R2.w, -R1, c[9].y, c[9].x;
MUL R3.xyz, R3.w, R3;
CMP R3.xyz, -R2.w, R3, R4;
DP3 R1.w, R2, R3;
ADD R5.xyz, -fragment.texcoord[0], c[1];
MUL R2.xyz, -R1.w, R2;
DP3 R4.x, R5, R5;
RSQ R4.x, R4.x;
MAD R2.xyz, -R2, c[9].z, -R3;
MUL R4.xyz, R4.x, R5;
DP3 R2.x, R2, R4;
SLT R2.y, R1.w, c[9];
MAX R2.x, R2, c[9].y;
POW R4.x, R2.x, c[6].x;
CMP R2.x, -R2.w, R3.w, c[9];
ABS R2.w, R2.y;
MUL R3.xyz, R2.x, c[8];
MUL R2.xyz, R3, c[5];
MUL R2.xyz, R2, R4.x;
CMP R2.w, -R2, c[9].y, c[9].x;
CMP R2.xyz, -R2.w, R2, c[9].y;
MUL R4.xyz, R2, c[7].x;
MOV R2.xyz, c[3];
MAX R1.w, R1, c[9].y;
MAD R2.xyz, R2, c[0], fragment.texcoord[2];
MUL R3.xyz, R3, c[3];
MAD_SAT R2.xyz, R3, R1.w, R2;
MAD R1.xyz, R1, R2, R4;
MOV R1.w, c[9].x;
TEX R0, R0, texture[1], CUBE;
MUL R0.xyz, R0, c[4].x;
ADD result.color, R1, R0;
END
# 48 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Vector 8 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"ps_2_0
; 49 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c9, 1.00000000, 0.00000000, 2.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4.xyz
texld r5, t3, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r6.xyz, r0.x, t1
dp3_pp r0.x, r6, t4
mul_pp r0.xyz, r6, r0.x
mad_pp r0.xyz, -r0, c9.z, t4
add_pp r2.xyz, -t0, c2
add r7.xyz, -t0, c1
mov_pp r0.w, c9.x
texld r4, r0, s1
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r3.xyz, r1.x, r2
dp3_pp r2.x, c2, c2
rsq_pp r2.x, r2.x
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c9, c9.y
mul_pp r8.xyz, r2.x, c2
abs_pp r2.x, r0
cmp_pp r8.xyz, -r2.x, r3, r8
dp3_pp r0.x, r6, r8
mul_pp r6.xyz, r6, -r0.x
dp3 r3.x, r7, r7
rsq r3.x, r3.x
mul r3.xyz, r3.x, r7
mad_pp r6.xyz, -r6, c9.z, -r8
dp3_pp r3.x, r6, r3
max_pp r3.x, r3, c9.y
pow_pp r6.w, r3.x, c6.x
cmp_pp r1.x, -r2, r1, c9
mul_pp r3.xyz, r1.x, c8
cmp_pp r1.x, r0, c9.y, c9
mov_pp r2.x, r6.w
mul_pp r6.xyz, r3, c5
mul_pp r2.xyz, r6, r2.x
abs_pp r1.x, r1
cmp_pp r1.xyz, -r1.x, r2, c9.y
mul_pp r2.xyz, r1, c7.x
mov_pp r1.xyz, c0
mad_pp r1.xyz, c3, r1, t2
max_pp r0.x, r0, c9.y
mul_pp r3.xyz, r3, c3
mad_pp_sat r0.xyz, r3, r0.x, r1
mad_pp r0.xyz, r5, r0, r2
mul_pp r1.xyz, r4, c4.x
mov_pp r1.w, r4
add_pp r0, r0, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Vector 8 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 48 ALU, 2 TEX
PARAM c[10] = { state.lightmodel.ambient,
		program.local[1..8],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEX R1.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R3.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R3, R3;
RSQ R3.w, R1.w;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R2, fragment.texcoord[4];
MUL R0.xyz, R2, R0.x;
MAD R0.xyz, -R0, c[9].z, fragment.texcoord[4];
ABS R1.w, -c[2];
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
CMP R1.w, -R1, c[9].y, c[9].x;
MUL R4.xyz, R2.w, c[2];
ABS R1.w, R1;
CMP R2.w, -R1, c[9].y, c[9].x;
MUL R3.xyz, R3.w, R3;
CMP R3.xyz, -R2.w, R3, R4;
DP3 R1.w, R2, R3;
ADD R5.xyz, -fragment.texcoord[0], c[1];
MUL R2.xyz, -R1.w, R2;
DP3 R4.x, R5, R5;
RSQ R4.x, R4.x;
MAD R2.xyz, -R2, c[9].z, -R3;
MUL R4.xyz, R4.x, R5;
DP3 R2.x, R2, R4;
SLT R2.y, R1.w, c[9];
MAX R2.x, R2, c[9].y;
POW R4.x, R2.x, c[6].x;
CMP R2.x, -R2.w, R3.w, c[9];
ABS R2.w, R2.y;
MUL R3.xyz, R2.x, c[8];
MUL R2.xyz, R3, c[5];
MUL R2.xyz, R2, R4.x;
CMP R2.w, -R2, c[9].y, c[9].x;
CMP R2.xyz, -R2.w, R2, c[9].y;
MUL R4.xyz, R2, c[7].x;
MOV R2.xyz, c[3];
MAX R1.w, R1, c[9].y;
MAD R2.xyz, R2, c[0], fragment.texcoord[2];
MUL R3.xyz, R3, c[3];
MAD_SAT R2.xyz, R3, R1.w, R2;
MAD R1.xyz, R1, R2, R4;
MOV R1.w, c[9].x;
TEX R0, R0, texture[1], CUBE;
MUL R0.xyz, R0, c[4].x;
ADD result.color, R1, R0;
END
# 48 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Vector 8 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"ps_2_0
; 49 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c9, 1.00000000, 0.00000000, 2.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4.xyz
texld r5, t3, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r6.xyz, r0.x, t1
dp3_pp r0.x, r6, t4
mul_pp r0.xyz, r6, r0.x
mad_pp r0.xyz, -r0, c9.z, t4
add_pp r2.xyz, -t0, c2
add r7.xyz, -t0, c1
mov_pp r0.w, c9.x
texld r4, r0, s1
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r3.xyz, r1.x, r2
dp3_pp r2.x, c2, c2
rsq_pp r2.x, r2.x
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c9, c9.y
mul_pp r8.xyz, r2.x, c2
abs_pp r2.x, r0
cmp_pp r8.xyz, -r2.x, r3, r8
dp3_pp r0.x, r6, r8
mul_pp r6.xyz, r6, -r0.x
dp3 r3.x, r7, r7
rsq r3.x, r3.x
mul r3.xyz, r3.x, r7
mad_pp r6.xyz, -r6, c9.z, -r8
dp3_pp r3.x, r6, r3
max_pp r3.x, r3, c9.y
pow_pp r6.w, r3.x, c6.x
cmp_pp r1.x, -r2, r1, c9
mul_pp r3.xyz, r1.x, c8
cmp_pp r1.x, r0, c9.y, c9
mov_pp r2.x, r6.w
mul_pp r6.xyz, r3, c5
mul_pp r2.xyz, r6, r2.x
abs_pp r1.x, r1
cmp_pp r1.xyz, -r1.x, r2, c9.y
mul_pp r2.xyz, r1, c7.x
mov_pp r1.xyz, c0
mad_pp r1.xyz, c3, r1, t2
max_pp r0.x, r0, c9.y
mul_pp r3.xyz, r3, c3
mad_pp_sat r0.xyz, r3, r0.x, r1
mad_pp r0.xyz, r5, r0, r2
mul_pp r1.xyz, r4, c4.x
mov_pp r1.w, r4
add_pp r0, r0, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Vector 8 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 48 ALU, 2 TEX
PARAM c[10] = { state.lightmodel.ambient,
		program.local[1..8],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEX R1.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R3.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R3, R3;
RSQ R3.w, R1.w;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R2, fragment.texcoord[4];
MUL R0.xyz, R2, R0.x;
MAD R0.xyz, -R0, c[9].z, fragment.texcoord[4];
ABS R1.w, -c[2];
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
CMP R1.w, -R1, c[9].y, c[9].x;
MUL R4.xyz, R2.w, c[2];
ABS R1.w, R1;
CMP R2.w, -R1, c[9].y, c[9].x;
MUL R3.xyz, R3.w, R3;
CMP R3.xyz, -R2.w, R3, R4;
DP3 R1.w, R2, R3;
ADD R5.xyz, -fragment.texcoord[0], c[1];
MUL R2.xyz, -R1.w, R2;
DP3 R4.x, R5, R5;
RSQ R4.x, R4.x;
MAD R2.xyz, -R2, c[9].z, -R3;
MUL R4.xyz, R4.x, R5;
DP3 R2.x, R2, R4;
SLT R2.y, R1.w, c[9];
MAX R2.x, R2, c[9].y;
POW R4.x, R2.x, c[6].x;
CMP R2.x, -R2.w, R3.w, c[9];
ABS R2.w, R2.y;
MUL R3.xyz, R2.x, c[8];
MUL R2.xyz, R3, c[5];
MUL R2.xyz, R2, R4.x;
CMP R2.w, -R2, c[9].y, c[9].x;
CMP R2.xyz, -R2.w, R2, c[9].y;
MUL R4.xyz, R2, c[7].x;
MOV R2.xyz, c[3];
MAX R1.w, R1, c[9].y;
MAD R2.xyz, R2, c[0], fragment.texcoord[2];
MUL R3.xyz, R3, c[3];
MAD_SAT R2.xyz, R3, R1.w, R2;
MAD R1.xyz, R1, R2, R4;
MOV R1.w, c[9].x;
TEX R0, R0, texture[1], CUBE;
MUL R0.xyz, R0, c[4].x;
ADD result.color, R1, R0;
END
# 48 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Vector 8 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"ps_2_0
; 49 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c9, 1.00000000, 0.00000000, 2.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4.xyz
texld r5, t3, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r6.xyz, r0.x, t1
dp3_pp r0.x, r6, t4
mul_pp r0.xyz, r6, r0.x
mad_pp r0.xyz, -r0, c9.z, t4
add_pp r2.xyz, -t0, c2
add r7.xyz, -t0, c1
mov_pp r0.w, c9.x
texld r4, r0, s1
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r3.xyz, r1.x, r2
dp3_pp r2.x, c2, c2
rsq_pp r2.x, r2.x
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c9, c9.y
mul_pp r8.xyz, r2.x, c2
abs_pp r2.x, r0
cmp_pp r8.xyz, -r2.x, r3, r8
dp3_pp r0.x, r6, r8
mul_pp r6.xyz, r6, -r0.x
dp3 r3.x, r7, r7
rsq r3.x, r3.x
mul r3.xyz, r3.x, r7
mad_pp r6.xyz, -r6, c9.z, -r8
dp3_pp r3.x, r6, r3
max_pp r3.x, r3, c9.y
pow_pp r6.w, r3.x, c6.x
cmp_pp r1.x, -r2, r1, c9
mul_pp r3.xyz, r1.x, c8
cmp_pp r1.x, r0, c9.y, c9
mov_pp r2.x, r6.w
mul_pp r6.xyz, r3, c5
mul_pp r2.xyz, r6, r2.x
abs_pp r1.x, r1
cmp_pp r1.xyz, -r1.x, r2, c9.y
mul_pp r2.xyz, r1, c7.x
mov_pp r1.xyz, c0
mad_pp r1.xyz, c3, r1, t2
max_pp r0.x, r0, c9.y
mul_pp r3.xyz, r3, c3
mad_pp_sat r0.xyz, r3, r0.x, r1
mad_pp r0.xyz, r5, r0, r2
mul_pp r1.xyz, r4, c4.x
mov_pp r1.w, r4
add_pp r0, r0, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Vector 8 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 48 ALU, 2 TEX
PARAM c[10] = { state.lightmodel.ambient,
		program.local[1..8],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEX R1.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R3.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R3, R3;
RSQ R3.w, R1.w;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R2, fragment.texcoord[4];
MUL R0.xyz, R2, R0.x;
MAD R0.xyz, -R0, c[9].z, fragment.texcoord[4];
ABS R1.w, -c[2];
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
CMP R1.w, -R1, c[9].y, c[9].x;
MUL R4.xyz, R2.w, c[2];
ABS R1.w, R1;
CMP R2.w, -R1, c[9].y, c[9].x;
MUL R3.xyz, R3.w, R3;
CMP R3.xyz, -R2.w, R3, R4;
DP3 R1.w, R2, R3;
ADD R5.xyz, -fragment.texcoord[0], c[1];
MUL R2.xyz, -R1.w, R2;
DP3 R4.x, R5, R5;
RSQ R4.x, R4.x;
MAD R2.xyz, -R2, c[9].z, -R3;
MUL R4.xyz, R4.x, R5;
DP3 R2.x, R2, R4;
SLT R2.y, R1.w, c[9];
MAX R2.x, R2, c[9].y;
POW R4.x, R2.x, c[6].x;
CMP R2.x, -R2.w, R3.w, c[9];
ABS R2.w, R2.y;
MUL R3.xyz, R2.x, c[8];
MUL R2.xyz, R3, c[5];
MUL R2.xyz, R2, R4.x;
CMP R2.w, -R2, c[9].y, c[9].x;
CMP R2.xyz, -R2.w, R2, c[9].y;
MUL R4.xyz, R2, c[7].x;
MOV R2.xyz, c[3];
MAX R1.w, R1, c[9].y;
MAD R2.xyz, R2, c[0], fragment.texcoord[2];
MUL R3.xyz, R3, c[3];
MAD_SAT R2.xyz, R3, R1.w, R2;
MAD R1.xyz, R1, R2, R4;
MOV R1.w, c[9].x;
TEX R0, R0, texture[1], CUBE;
MUL R0.xyz, R0, c[4].x;
ADD result.color, R1, R0;
END
# 48 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Vector 8 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"ps_2_0
; 49 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c9, 1.00000000, 0.00000000, 2.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4.xyz
texld r5, t3, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r6.xyz, r0.x, t1
dp3_pp r0.x, r6, t4
mul_pp r0.xyz, r6, r0.x
mad_pp r0.xyz, -r0, c9.z, t4
add_pp r2.xyz, -t0, c2
add r7.xyz, -t0, c1
mov_pp r0.w, c9.x
texld r4, r0, s1
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r3.xyz, r1.x, r2
dp3_pp r2.x, c2, c2
rsq_pp r2.x, r2.x
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c9, c9.y
mul_pp r8.xyz, r2.x, c2
abs_pp r2.x, r0
cmp_pp r8.xyz, -r2.x, r3, r8
dp3_pp r0.x, r6, r8
mul_pp r6.xyz, r6, -r0.x
dp3 r3.x, r7, r7
rsq r3.x, r3.x
mul r3.xyz, r3.x, r7
mad_pp r6.xyz, -r6, c9.z, -r8
dp3_pp r3.x, r6, r3
max_pp r3.x, r3, c9.y
pow_pp r6.w, r3.x, c6.x
cmp_pp r1.x, -r2, r1, c9
mul_pp r3.xyz, r1.x, c8
cmp_pp r1.x, r0, c9.y, c9
mov_pp r2.x, r6.w
mul_pp r6.xyz, r3, c5
mul_pp r2.xyz, r6, r2.x
abs_pp r1.x, r1
cmp_pp r1.xyz, -r1.x, r2, c9.y
mul_pp r2.xyz, r1, c7.x
mov_pp r1.xyz, c0
mad_pp r1.xyz, c3, r1, t2
max_pp r0.x, r0, c9.y
mul_pp r3.xyz, r3, c3
mad_pp_sat r0.xyz, r3, r0.x, r1
mad_pp r0.xyz, r5, r0, r2
mul_pp r1.xyz, r4, c4.x
mov_pp r1.w, r4
add_pp r0, r0, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Vector 8 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 48 ALU, 2 TEX
PARAM c[10] = { state.lightmodel.ambient,
		program.local[1..8],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEX R1.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R3.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R3, R3;
RSQ R3.w, R1.w;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R2, fragment.texcoord[4];
MUL R0.xyz, R2, R0.x;
MAD R0.xyz, -R0, c[9].z, fragment.texcoord[4];
ABS R1.w, -c[2];
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
CMP R1.w, -R1, c[9].y, c[9].x;
MUL R4.xyz, R2.w, c[2];
ABS R1.w, R1;
CMP R2.w, -R1, c[9].y, c[9].x;
MUL R3.xyz, R3.w, R3;
CMP R3.xyz, -R2.w, R3, R4;
DP3 R1.w, R2, R3;
ADD R5.xyz, -fragment.texcoord[0], c[1];
MUL R2.xyz, -R1.w, R2;
DP3 R4.x, R5, R5;
RSQ R4.x, R4.x;
MAD R2.xyz, -R2, c[9].z, -R3;
MUL R4.xyz, R4.x, R5;
DP3 R2.x, R2, R4;
SLT R2.y, R1.w, c[9];
MAX R2.x, R2, c[9].y;
POW R4.x, R2.x, c[6].x;
CMP R2.x, -R2.w, R3.w, c[9];
ABS R2.w, R2.y;
MUL R3.xyz, R2.x, c[8];
MUL R2.xyz, R3, c[5];
MUL R2.xyz, R2, R4.x;
CMP R2.w, -R2, c[9].y, c[9].x;
CMP R2.xyz, -R2.w, R2, c[9].y;
MUL R4.xyz, R2, c[7].x;
MOV R2.xyz, c[3];
MAX R1.w, R1, c[9].y;
MAD R2.xyz, R2, c[0], fragment.texcoord[2];
MUL R3.xyz, R3, c[3];
MAD_SAT R2.xyz, R3, R1.w, R2;
MAD R1.xyz, R1, R2, R4;
MOV R1.w, c[9].x;
TEX R0, R0, texture[1], CUBE;
MUL R0.xyz, R0, c[4].x;
ADD result.color, R1, R0;
END
# 48 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Vector 8 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"ps_2_0
; 49 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c9, 1.00000000, 0.00000000, 2.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4.xyz
texld r5, t3, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r6.xyz, r0.x, t1
dp3_pp r0.x, r6, t4
mul_pp r0.xyz, r6, r0.x
mad_pp r0.xyz, -r0, c9.z, t4
add_pp r2.xyz, -t0, c2
add r7.xyz, -t0, c1
mov_pp r0.w, c9.x
texld r4, r0, s1
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r3.xyz, r1.x, r2
dp3_pp r2.x, c2, c2
rsq_pp r2.x, r2.x
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c9, c9.y
mul_pp r8.xyz, r2.x, c2
abs_pp r2.x, r0
cmp_pp r8.xyz, -r2.x, r3, r8
dp3_pp r0.x, r6, r8
mul_pp r6.xyz, r6, -r0.x
dp3 r3.x, r7, r7
rsq r3.x, r3.x
mul r3.xyz, r3.x, r7
mad_pp r6.xyz, -r6, c9.z, -r8
dp3_pp r3.x, r6, r3
max_pp r3.x, r3, c9.y
pow_pp r6.w, r3.x, c6.x
cmp_pp r1.x, -r2, r1, c9
mul_pp r3.xyz, r1.x, c8
cmp_pp r1.x, r0, c9.y, c9
mov_pp r2.x, r6.w
mul_pp r6.xyz, r3, c5
mul_pp r2.xyz, r6, r2.x
abs_pp r1.x, r1
cmp_pp r1.xyz, -r1.x, r2, c9.y
mul_pp r2.xyz, r1, c7.x
mov_pp r1.xyz, c0
mad_pp r1.xyz, c3, r1, t2
max_pp r0.x, r0, c9.y
mul_pp r3.xyz, r3, c3
mad_pp_sat r0.xyz, r3, r0.x, r1
mad_pp r0.xyz, r5, r0, r2
mul_pp r1.xyz, r4, c4.x
mov_pp r1.w, r4
add_pp r0, r0, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Vector 8 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 48 ALU, 2 TEX
PARAM c[10] = { state.lightmodel.ambient,
		program.local[1..8],
		{ 1, 0, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEX R1.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R3.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R3, R3;
RSQ R3.w, R1.w;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R2, fragment.texcoord[4];
MUL R0.xyz, R2, R0.x;
MAD R0.xyz, -R0, c[9].z, fragment.texcoord[4];
ABS R1.w, -c[2];
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
CMP R1.w, -R1, c[9].y, c[9].x;
MUL R4.xyz, R2.w, c[2];
ABS R1.w, R1;
CMP R2.w, -R1, c[9].y, c[9].x;
MUL R3.xyz, R3.w, R3;
CMP R3.xyz, -R2.w, R3, R4;
DP3 R1.w, R2, R3;
ADD R5.xyz, -fragment.texcoord[0], c[1];
MUL R2.xyz, -R1.w, R2;
DP3 R4.x, R5, R5;
RSQ R4.x, R4.x;
MAD R2.xyz, -R2, c[9].z, -R3;
MUL R4.xyz, R4.x, R5;
DP3 R2.x, R2, R4;
SLT R2.y, R1.w, c[9];
MAX R2.x, R2, c[9].y;
POW R4.x, R2.x, c[6].x;
CMP R2.x, -R2.w, R3.w, c[9];
ABS R2.w, R2.y;
MUL R3.xyz, R2.x, c[8];
MUL R2.xyz, R3, c[5];
MUL R2.xyz, R2, R4.x;
CMP R2.w, -R2, c[9].y, c[9].x;
CMP R2.xyz, -R2.w, R2, c[9].y;
MUL R4.xyz, R2, c[7].x;
MOV R2.xyz, c[3];
MAX R1.w, R1, c[9].y;
MAD R2.xyz, R2, c[0], fragment.texcoord[2];
MUL R3.xyz, R3, c[3];
MAD_SAT R2.xyz, R3, R1.w, R2;
MAD R1.xyz, R1, R2, R4;
MOV R1.w, c[9].x;
TEX R0, R0, texture[1], CUBE;
MUL R0.xyz, R0, c[4].x;
ADD result.color, R1, R0;
END
# 48 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Vector 8 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"ps_2_0
; 49 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c9, 1.00000000, 0.00000000, 2.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4.xyz
texld r5, t3, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r6.xyz, r0.x, t1
dp3_pp r0.x, r6, t4
mul_pp r0.xyz, r6, r0.x
mad_pp r0.xyz, -r0, c9.z, t4
add_pp r2.xyz, -t0, c2
add r7.xyz, -t0, c1
mov_pp r0.w, c9.x
texld r4, r0, s1
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r3.xyz, r1.x, r2
dp3_pp r2.x, c2, c2
rsq_pp r2.x, r2.x
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c9, c9.y
mul_pp r8.xyz, r2.x, c2
abs_pp r2.x, r0
cmp_pp r8.xyz, -r2.x, r3, r8
dp3_pp r0.x, r6, r8
mul_pp r6.xyz, r6, -r0.x
dp3 r3.x, r7, r7
rsq r3.x, r3.x
mul r3.xyz, r3.x, r7
mad_pp r6.xyz, -r6, c9.z, -r8
dp3_pp r3.x, r6, r3
max_pp r3.x, r3, c9.y
pow_pp r6.w, r3.x, c6.x
cmp_pp r1.x, -r2, r1, c9
mul_pp r3.xyz, r1.x, c8
cmp_pp r1.x, r0, c9.y, c9
mov_pp r2.x, r6.w
mul_pp r6.xyz, r3, c5
mul_pp r2.xyz, r6, r2.x
abs_pp r1.x, r1
cmp_pp r1.xyz, -r1.x, r2, c9.y
mul_pp r2.xyz, r1, c7.x
mov_pp r1.xyz, c0
mad_pp r1.xyz, c3, r1, t2
max_pp r0.x, r0, c9.y
mul_pp r3.xyz, r3, c3
mad_pp_sat r0.xyz, r3, r0.x, r1
mad_pp r0.xyz, r5, r0, r2
mul_pp r1.xyz, r4, c4.x
mov_pp r1.w, r4
add_pp r0, r0, r1
mov_pp oC0, r0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
"!!GLES"
}

}

#LINE 218

      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Mobile/Diffuse"
}