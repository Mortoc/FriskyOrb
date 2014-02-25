Shader "RedDotGames/Mobile/Scrolled Environment/Car Paint Medium Detail" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _Shininess ("Shininess", Range (0.01, 10)) = 1
	  _Gloss ("Gloss", Range (0.0, 10)) = 1
	  _MainTex ("Diffuse Texture", 2D) = "white" {} 
	  _EnvSide ("Env Side Texture", 2D) = "black" {} 
	  _EnvTop ("Env Top Texture", 2D) = "black" {} 
	  //_EnvInt ("Env Intensity", float) = 1
	  _EnvTimer ("Env Timer", float) = 1
	  
	  _Cube("Reflection Map", Cube) = "" {}
	  _Reflection("Reflection Power", Range (0.00, 1)) = 0
	  _FrezPow("Fresnel Power",Range(0,2)) = .25
	  _FrezFalloff("Fresnal Falloff",Range(0,10)) = 4	  
  
   }
SubShader {
   Tags { "QUEUE"="Geometry" "RenderType"="Opaque" " IgnoreProjector"="True"}	  
      Pass {  
      
         Tags { "LightMode" = "ForwardBase" } // pass for 
            // 4 vertex lights, ambient light & first pixel light
 
         Program "vp" {
// Vertex combos: 8
//   opengl - ALU: 35 to 66
//   d3d9 - ALU: 35 to 66
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Float 14 [_EnvTimer]
Vector 15 [_EnvSide_ST]
Vector 16 [_EnvTop_ST]
"!!ARBvp1.0
# 35 ALU
PARAM c[17] = { { 0, 0.26789999 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R1.xyz, R0, c[0].x;
ABS R2.xyz, vertex.normal;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
ADD R0.xyz, R0, -c[13];
MUL result.texcoord[1].xyz, R0.w, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
ADD R2.xyz, R2, -c[0].y;
MAX R1.xyz, R2, c[0].x;
ADD R1.w, R1.x, R1.y;
ADD R1.w, R1.z, R1;
RCP R1.w, R1.w;
MOV R0.y, c[0].x;
MOV R0.x, c[14];
ADD R0.zw, vertex.position.xyzx, R0.xyxy;
ADD R0.xy, vertex.position.zyzw, R0;
MUL result.texcoord[6].xyz, R1, R1.w;
MOV result.texcoord[2].xyz, c[0].x;
MOV result.texcoord[3].xy, vertex.texcoord[0];
MAD result.texcoord[5].zw, R0, c[16].xyxy, c[16];
MAD result.texcoord[5].xy, R0, c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 3 R-regs
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
Float 13 [_EnvTimer]
Vector 14 [_EnvSide_ST]
Vector 15 [_EnvTop_ST]
"vs_2_0
; 35 ALU
def c16, -0.26789999, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r1.xyz, r0, c16.y
abs r2.xyz, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov oT0, r0
dp3 r0.w, r1, r1
rsq r0.w, r0.w
add r0.xyz, r0, -c12
mul oT1.xyz, r0.w, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT4.xyz, r0.w, r0
add r2.xyz, r2, c16.x
max r1.xyz, r2, c16.y
add r1.w, r1.x, r1.y
add r1.w, r1.z, r1
rcp r1.w, r1.w
mov r0.y, c16
mov r0.x, c13
add r0.zw, v0.xyzx, r0.xyxy
add r0.xy, v0.zyzw, r0
mul oT6.xyz, r1, r1.w
mov oT2.xyz, c16.y
mov oT3.xy, v2
mad oT5.zw, r0, c15.xyxy, c15
mad oT5.xy, r0, c14, c14.zwzw
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  mediump vec2 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_2 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = abs (tmpvar_1);
  blend_weights = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 / vec3(((tmpvar_12.x + tmpvar_12.y) + tmpvar_12.z)));
  blend_weights = tmpvar_13;
  tmpvar_5 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.y = 0.0;
  tmpvar_14.x = _EnvTimer;
  highp vec2 tmpvar_15;
  tmpvar_15 = (_glesVertex.zy + tmpvar_14);
  tmpvar_4.xy = tmpvar_15;
  tmpvar_4.xy = ((tmpvar_4.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zx + tmpvar_16);
  tmpvar_4.zw = tmpvar_17;
  tmpvar_4.zw = ((tmpvar_4.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = tmpvar_6;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  mediump vec2 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_2 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = abs (tmpvar_1);
  blend_weights = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 / vec3(((tmpvar_12.x + tmpvar_12.y) + tmpvar_12.z)));
  blend_weights = tmpvar_13;
  tmpvar_5 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.y = 0.0;
  tmpvar_14.x = _EnvTimer;
  highp vec2 tmpvar_15;
  tmpvar_15 = (_glesVertex.zy + tmpvar_14);
  tmpvar_4.xy = tmpvar_15;
  tmpvar_4.xy = ((tmpvar_4.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zx + tmpvar_16);
  tmpvar_4.zw = tmpvar_17;
  tmpvar_4.zw = ((tmpvar_4.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = tmpvar_6;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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
Float 13 [_EnvTimer]
Vector 14 [_EnvSide_ST]
Vector 15 [_EnvTop_ST]
"agal_vs
c16 -0.2679 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaabaaahacaaaaaakeacaaaaaabaaaaaffabaaaaaa add r1.xyz, r0.xyzz, c16.y
beaaaaaaacaaahacabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa abs r2.xyz, a1
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
bcaaaaaaaaaaaiacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.w, r1.xyzz, r1.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
acaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r0.xyz, r0.xyzz, c12
adaaaaaaabaaahaeaaaaaappacaaaaaaabaaaakeacaaaaaa mul v1.xyz, r0.w, r1.xyzz
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaaeaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v4.xyz, r0.w, r0.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaabaaaaaaaabaaaaaa add r2.xyz, r2.xyzz, c16.x
ahaaaaaaabaaahacacaaaakeacaaaaaabaaaaaffabaaaaaa max r1.xyz, r2.xyzz, c16.y
abaaaaaaabaaaiacabaaaaaaacaaaaaaabaaaaffacaaaaaa add r1.w, r1.x, r1.y
abaaaaaaabaaaiacabaaaakkacaaaaaaabaaaappacaaaaaa add r1.w, r1.z, r1.w
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
aaaaaaaaaaaaacacbaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c16
aaaaaaaaaaaaabacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13
abaaaaaaaaaaamacaaaaaaceaaaaaaaaaaaaaaefacaaaaaa add r0.zw, a0.xyzx, r0.yyxy
abaaaaaaaaaaadacaaaaaaogaaaaaaaaaaaaaafeacaaaaaa add r0.xy, a0.zyzw, r0.xyyy
adaaaaaaagaaahaeabaaaakeacaaaaaaabaaaappacaaaaaa mul v6.xyz, r1.xyzz, r1.w
aaaaaaaaacaaahaebaaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, c16.y
aaaaaaaaadaaadaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3.xy, a3
adaaaaaaabaaamacaaaaaaopacaaaaaaapaaaaeeabaaaaaa mul r1.zw, r0.wwzw, c15.xyxy
abaaaaaaafaaamaeabaaaaopacaaaaaaapaaaaoeabaaaaaa add v5.zw, r1.wwzw, c15
adaaaaaaaaaaadacaaaaaafeacaaaaaaaoaaaaoeabaaaaaa mul r0.xy, r0.xyyy, c14
abaaaaaaafaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v5.xy, r0.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaagaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v6.w, c0
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
Float 14 [_EnvTimer]
Vector 15 [_EnvSide_ST]
Vector 16 [_EnvTop_ST]
"!!ARBvp1.0
# 35 ALU
PARAM c[17] = { { 0, 0.26789999 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R1.xyz, R0, c[0].x;
ABS R2.xyz, vertex.normal;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
ADD R0.xyz, R0, -c[13];
MUL result.texcoord[1].xyz, R0.w, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
ADD R2.xyz, R2, -c[0].y;
MAX R1.xyz, R2, c[0].x;
ADD R1.w, R1.x, R1.y;
ADD R1.w, R1.z, R1;
RCP R1.w, R1.w;
MOV R0.y, c[0].x;
MOV R0.x, c[14];
ADD R0.zw, vertex.position.xyzx, R0.xyxy;
ADD R0.xy, vertex.position.zyzw, R0;
MUL result.texcoord[6].xyz, R1, R1.w;
MOV result.texcoord[2].xyz, c[0].x;
MOV result.texcoord[3].xy, vertex.texcoord[0];
MAD result.texcoord[5].zw, R0, c[16].xyxy, c[16];
MAD result.texcoord[5].xy, R0, c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 3 R-regs
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
Float 13 [_EnvTimer]
Vector 14 [_EnvSide_ST]
Vector 15 [_EnvTop_ST]
"vs_2_0
; 35 ALU
def c16, -0.26789999, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r1.xyz, r0, c16.y
abs r2.xyz, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov oT0, r0
dp3 r0.w, r1, r1
rsq r0.w, r0.w
add r0.xyz, r0, -c12
mul oT1.xyz, r0.w, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT4.xyz, r0.w, r0
add r2.xyz, r2, c16.x
max r1.xyz, r2, c16.y
add r1.w, r1.x, r1.y
add r1.w, r1.z, r1
rcp r1.w, r1.w
mov r0.y, c16
mov r0.x, c13
add r0.zw, v0.xyzx, r0.xyxy
add r0.xy, v0.zyzw, r0
mul oT6.xyz, r1, r1.w
mov oT2.xyz, c16.y
mov oT3.xy, v2
mad oT5.zw, r0, c15.xyxy, c15
mad oT5.xy, r0, c14, c14.zwzw
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  mediump vec2 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_2 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = abs (tmpvar_1);
  blend_weights = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 / vec3(((tmpvar_12.x + tmpvar_12.y) + tmpvar_12.z)));
  blend_weights = tmpvar_13;
  tmpvar_5 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.y = 0.0;
  tmpvar_14.x = _EnvTimer;
  highp vec2 tmpvar_15;
  tmpvar_15 = (_glesVertex.zy + tmpvar_14);
  tmpvar_4.xy = tmpvar_15;
  tmpvar_4.xy = ((tmpvar_4.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zx + tmpvar_16);
  tmpvar_4.zw = tmpvar_17;
  tmpvar_4.zw = ((tmpvar_4.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = tmpvar_6;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  mediump vec2 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_2 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = abs (tmpvar_1);
  blend_weights = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 / vec3(((tmpvar_12.x + tmpvar_12.y) + tmpvar_12.z)));
  blend_weights = tmpvar_13;
  tmpvar_5 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.y = 0.0;
  tmpvar_14.x = _EnvTimer;
  highp vec2 tmpvar_15;
  tmpvar_15 = (_glesVertex.zy + tmpvar_14);
  tmpvar_4.xy = tmpvar_15;
  tmpvar_4.xy = ((tmpvar_4.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zx + tmpvar_16);
  tmpvar_4.zw = tmpvar_17;
  tmpvar_4.zw = ((tmpvar_4.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = tmpvar_6;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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
Float 13 [_EnvTimer]
Vector 14 [_EnvSide_ST]
Vector 15 [_EnvTop_ST]
"agal_vs
c16 -0.2679 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaabaaahacaaaaaakeacaaaaaabaaaaaffabaaaaaa add r1.xyz, r0.xyzz, c16.y
beaaaaaaacaaahacabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa abs r2.xyz, a1
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
bcaaaaaaaaaaaiacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.w, r1.xyzz, r1.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
acaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r0.xyz, r0.xyzz, c12
adaaaaaaabaaahaeaaaaaappacaaaaaaabaaaakeacaaaaaa mul v1.xyz, r0.w, r1.xyzz
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaaeaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v4.xyz, r0.w, r0.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaabaaaaaaaabaaaaaa add r2.xyz, r2.xyzz, c16.x
ahaaaaaaabaaahacacaaaakeacaaaaaabaaaaaffabaaaaaa max r1.xyz, r2.xyzz, c16.y
abaaaaaaabaaaiacabaaaaaaacaaaaaaabaaaaffacaaaaaa add r1.w, r1.x, r1.y
abaaaaaaabaaaiacabaaaakkacaaaaaaabaaaappacaaaaaa add r1.w, r1.z, r1.w
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
aaaaaaaaaaaaacacbaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c16
aaaaaaaaaaaaabacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13
abaaaaaaaaaaamacaaaaaaceaaaaaaaaaaaaaaefacaaaaaa add r0.zw, a0.xyzx, r0.yyxy
abaaaaaaaaaaadacaaaaaaogaaaaaaaaaaaaaafeacaaaaaa add r0.xy, a0.zyzw, r0.xyyy
adaaaaaaagaaahaeabaaaakeacaaaaaaabaaaappacaaaaaa mul v6.xyz, r1.xyzz, r1.w
aaaaaaaaacaaahaebaaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, c16.y
aaaaaaaaadaaadaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3.xy, a3
adaaaaaaabaaamacaaaaaaopacaaaaaaapaaaaeeabaaaaaa mul r1.zw, r0.wwzw, c15.xyxy
abaaaaaaafaaamaeabaaaaopacaaaaaaapaaaaoeabaaaaaa add v5.zw, r1.wwzw, c15
adaaaaaaaaaaadacaaaaaafeacaaaaaaaoaaaaoeabaaaaaa mul r0.xy, r0.xyyy, c14
abaaaaaaafaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v5.xy, r0.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaagaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v6.w, c0
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
Float 14 [_EnvTimer]
Vector 15 [_EnvSide_ST]
Vector 16 [_EnvTop_ST]
"!!ARBvp1.0
# 35 ALU
PARAM c[17] = { { 0, 0.26789999 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R1.xyz, R0, c[0].x;
ABS R2.xyz, vertex.normal;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
ADD R0.xyz, R0, -c[13];
MUL result.texcoord[1].xyz, R0.w, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
ADD R2.xyz, R2, -c[0].y;
MAX R1.xyz, R2, c[0].x;
ADD R1.w, R1.x, R1.y;
ADD R1.w, R1.z, R1;
RCP R1.w, R1.w;
MOV R0.y, c[0].x;
MOV R0.x, c[14];
ADD R0.zw, vertex.position.xyzx, R0.xyxy;
ADD R0.xy, vertex.position.zyzw, R0;
MUL result.texcoord[6].xyz, R1, R1.w;
MOV result.texcoord[2].xyz, c[0].x;
MOV result.texcoord[3].xy, vertex.texcoord[0];
MAD result.texcoord[5].zw, R0, c[16].xyxy, c[16];
MAD result.texcoord[5].xy, R0, c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 3 R-regs
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
Float 13 [_EnvTimer]
Vector 14 [_EnvSide_ST]
Vector 15 [_EnvTop_ST]
"vs_2_0
; 35 ALU
def c16, -0.26789999, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r1.xyz, r0, c16.y
abs r2.xyz, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov oT0, r0
dp3 r0.w, r1, r1
rsq r0.w, r0.w
add r0.xyz, r0, -c12
mul oT1.xyz, r0.w, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT4.xyz, r0.w, r0
add r2.xyz, r2, c16.x
max r1.xyz, r2, c16.y
add r1.w, r1.x, r1.y
add r1.w, r1.z, r1
rcp r1.w, r1.w
mov r0.y, c16
mov r0.x, c13
add r0.zw, v0.xyzx, r0.xyxy
add r0.xy, v0.zyzw, r0
mul oT6.xyz, r1, r1.w
mov oT2.xyz, c16.y
mov oT3.xy, v2
mad oT5.zw, r0, c15.xyxy, c15
mad oT5.xy, r0, c14, c14.zwzw
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  mediump vec2 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_2 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = abs (tmpvar_1);
  blend_weights = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 / vec3(((tmpvar_12.x + tmpvar_12.y) + tmpvar_12.z)));
  blend_weights = tmpvar_13;
  tmpvar_5 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.y = 0.0;
  tmpvar_14.x = _EnvTimer;
  highp vec2 tmpvar_15;
  tmpvar_15 = (_glesVertex.zy + tmpvar_14);
  tmpvar_4.xy = tmpvar_15;
  tmpvar_4.xy = ((tmpvar_4.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zx + tmpvar_16);
  tmpvar_4.zw = tmpvar_17;
  tmpvar_4.zw = ((tmpvar_4.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = tmpvar_6;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  mediump vec2 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_2 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = abs (tmpvar_1);
  blend_weights = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 / vec3(((tmpvar_12.x + tmpvar_12.y) + tmpvar_12.z)));
  blend_weights = tmpvar_13;
  tmpvar_5 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.y = 0.0;
  tmpvar_14.x = _EnvTimer;
  highp vec2 tmpvar_15;
  tmpvar_15 = (_glesVertex.zy + tmpvar_14);
  tmpvar_4.xy = tmpvar_15;
  tmpvar_4.xy = ((tmpvar_4.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zx + tmpvar_16);
  tmpvar_4.zw = tmpvar_17;
  tmpvar_4.zw = ((tmpvar_4.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = tmpvar_6;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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
Float 13 [_EnvTimer]
Vector 14 [_EnvSide_ST]
Vector 15 [_EnvTop_ST]
"agal_vs
c16 -0.2679 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaabaaahacaaaaaakeacaaaaaabaaaaaffabaaaaaa add r1.xyz, r0.xyzz, c16.y
beaaaaaaacaaahacabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa abs r2.xyz, a1
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
bcaaaaaaaaaaaiacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.w, r1.xyzz, r1.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
acaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r0.xyz, r0.xyzz, c12
adaaaaaaabaaahaeaaaaaappacaaaaaaabaaaakeacaaaaaa mul v1.xyz, r0.w, r1.xyzz
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaaeaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v4.xyz, r0.w, r0.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaabaaaaaaaabaaaaaa add r2.xyz, r2.xyzz, c16.x
ahaaaaaaabaaahacacaaaakeacaaaaaabaaaaaffabaaaaaa max r1.xyz, r2.xyzz, c16.y
abaaaaaaabaaaiacabaaaaaaacaaaaaaabaaaaffacaaaaaa add r1.w, r1.x, r1.y
abaaaaaaabaaaiacabaaaakkacaaaaaaabaaaappacaaaaaa add r1.w, r1.z, r1.w
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
aaaaaaaaaaaaacacbaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c16
aaaaaaaaaaaaabacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13
abaaaaaaaaaaamacaaaaaaceaaaaaaaaaaaaaaefacaaaaaa add r0.zw, a0.xyzx, r0.yyxy
abaaaaaaaaaaadacaaaaaaogaaaaaaaaaaaaaafeacaaaaaa add r0.xy, a0.zyzw, r0.xyyy
adaaaaaaagaaahaeabaaaakeacaaaaaaabaaaappacaaaaaa mul v6.xyz, r1.xyzz, r1.w
aaaaaaaaacaaahaebaaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, c16.y
aaaaaaaaadaaadaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3.xy, a3
adaaaaaaabaaamacaaaaaaopacaaaaaaapaaaaeeabaaaaaa mul r1.zw, r0.wwzw, c15.xyxy
abaaaaaaafaaamaeabaaaaopacaaaaaaapaaaaoeabaaaaaa add v5.zw, r1.wwzw, c15
adaaaaaaaaaaadacaaaaaafeacaaaaaaaoaaaaoeabaaaaaa mul r0.xy, r0.xyyy, c14
abaaaaaaafaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v5.xy, r0.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaagaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v6.w, c0
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
Float 14 [_EnvTimer]
Vector 15 [_EnvSide_ST]
Vector 16 [_EnvTop_ST]
"!!ARBvp1.0
# 35 ALU
PARAM c[17] = { { 0, 0.26789999 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R1.xyz, R0, c[0].x;
ABS R2.xyz, vertex.normal;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
ADD R0.xyz, R0, -c[13];
MUL result.texcoord[1].xyz, R0.w, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
ADD R2.xyz, R2, -c[0].y;
MAX R1.xyz, R2, c[0].x;
ADD R1.w, R1.x, R1.y;
ADD R1.w, R1.z, R1;
RCP R1.w, R1.w;
MOV R0.y, c[0].x;
MOV R0.x, c[14];
ADD R0.zw, vertex.position.xyzx, R0.xyxy;
ADD R0.xy, vertex.position.zyzw, R0;
MUL result.texcoord[6].xyz, R1, R1.w;
MOV result.texcoord[2].xyz, c[0].x;
MOV result.texcoord[3].xy, vertex.texcoord[0];
MAD result.texcoord[5].zw, R0, c[16].xyxy, c[16];
MAD result.texcoord[5].xy, R0, c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 3 R-regs
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
Float 13 [_EnvTimer]
Vector 14 [_EnvSide_ST]
Vector 15 [_EnvTop_ST]
"vs_2_0
; 35 ALU
def c16, -0.26789999, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r1.xyz, r0, c16.y
abs r2.xyz, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov oT0, r0
dp3 r0.w, r1, r1
rsq r0.w, r0.w
add r0.xyz, r0, -c12
mul oT1.xyz, r0.w, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT4.xyz, r0.w, r0
add r2.xyz, r2, c16.x
max r1.xyz, r2, c16.y
add r1.w, r1.x, r1.y
add r1.w, r1.z, r1
rcp r1.w, r1.w
mov r0.y, c16
mov r0.x, c13
add r0.zw, v0.xyzx, r0.xyxy
add r0.xy, v0.zyzw, r0
mul oT6.xyz, r1, r1.w
mov oT2.xyz, c16.y
mov oT3.xy, v2
mad oT5.zw, r0, c15.xyxy, c15
mad oT5.xy, r0, c14, c14.zwzw
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  mediump vec2 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_2 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = abs (tmpvar_1);
  blend_weights = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 / vec3(((tmpvar_12.x + tmpvar_12.y) + tmpvar_12.z)));
  blend_weights = tmpvar_13;
  tmpvar_5 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.y = 0.0;
  tmpvar_14.x = _EnvTimer;
  highp vec2 tmpvar_15;
  tmpvar_15 = (_glesVertex.zy + tmpvar_14);
  tmpvar_4.xy = tmpvar_15;
  tmpvar_4.xy = ((tmpvar_4.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zx + tmpvar_16);
  tmpvar_4.zw = tmpvar_17;
  tmpvar_4.zw = ((tmpvar_4.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = tmpvar_6;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  mediump vec2 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_2 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = abs (tmpvar_1);
  blend_weights = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 / vec3(((tmpvar_12.x + tmpvar_12.y) + tmpvar_12.z)));
  blend_weights = tmpvar_13;
  tmpvar_5 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.y = 0.0;
  tmpvar_14.x = _EnvTimer;
  highp vec2 tmpvar_15;
  tmpvar_15 = (_glesVertex.zy + tmpvar_14);
  tmpvar_4.xy = tmpvar_15;
  tmpvar_4.xy = ((tmpvar_4.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zx + tmpvar_16);
  tmpvar_4.zw = tmpvar_17;
  tmpvar_4.zw = ((tmpvar_4.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = tmpvar_6;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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
Float 13 [_EnvTimer]
Vector 14 [_EnvSide_ST]
Vector 15 [_EnvTop_ST]
"agal_vs
c16 -0.2679 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaabaaahacaaaaaakeacaaaaaabaaaaaffabaaaaaa add r1.xyz, r0.xyzz, c16.y
beaaaaaaacaaahacabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa abs r2.xyz, a1
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
bcaaaaaaaaaaaiacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.w, r1.xyzz, r1.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
acaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r0.xyz, r0.xyzz, c12
adaaaaaaabaaahaeaaaaaappacaaaaaaabaaaakeacaaaaaa mul v1.xyz, r0.w, r1.xyzz
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaaeaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v4.xyz, r0.w, r0.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaabaaaaaaaabaaaaaa add r2.xyz, r2.xyzz, c16.x
ahaaaaaaabaaahacacaaaakeacaaaaaabaaaaaffabaaaaaa max r1.xyz, r2.xyzz, c16.y
abaaaaaaabaaaiacabaaaaaaacaaaaaaabaaaaffacaaaaaa add r1.w, r1.x, r1.y
abaaaaaaabaaaiacabaaaakkacaaaaaaabaaaappacaaaaaa add r1.w, r1.z, r1.w
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
aaaaaaaaaaaaacacbaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c16
aaaaaaaaaaaaabacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13
abaaaaaaaaaaamacaaaaaaceaaaaaaaaaaaaaaefacaaaaaa add r0.zw, a0.xyzx, r0.yyxy
abaaaaaaaaaaadacaaaaaaogaaaaaaaaaaaaaafeacaaaaaa add r0.xy, a0.zyzw, r0.xyyy
adaaaaaaagaaahaeabaaaakeacaaaaaaabaaaappacaaaaaa mul v6.xyz, r1.xyzz, r1.w
aaaaaaaaacaaahaebaaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, c16.y
aaaaaaaaadaaadaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3.xy, a3
adaaaaaaabaaamacaaaaaaopacaaaaaaapaaaaeeabaaaaaa mul r1.zw, r0.wwzw, c15.xyxy
abaaaaaaafaaamaeabaaaaopacaaaaaaapaaaaoeabaaaaaa add v5.zw, r1.wwzw, c15
adaaaaaaaaaaadacaaaaaafeacaaaaaaaoaaaaoeabaaaaaa mul r0.xy, r0.xyyy, c14
abaaaaaaafaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v5.xy, r0.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaagaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v6.w, c0
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
Float 14 [_EnvTimer]
Vector 15 [_EnvSide_ST]
Vector 16 [_EnvTop_ST]
"!!ARBvp1.0
# 35 ALU
PARAM c[17] = { { 0, 0.26789999 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R1.xyz, R0, c[0].x;
ABS R2.xyz, vertex.normal;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
ADD R0.xyz, R0, -c[13];
MUL result.texcoord[1].xyz, R0.w, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
ADD R2.xyz, R2, -c[0].y;
MAX R1.xyz, R2, c[0].x;
ADD R1.w, R1.x, R1.y;
ADD R1.w, R1.z, R1;
RCP R1.w, R1.w;
MOV R0.y, c[0].x;
MOV R0.x, c[14];
ADD R0.zw, vertex.position.xyzx, R0.xyxy;
ADD R0.xy, vertex.position.zyzw, R0;
MUL result.texcoord[6].xyz, R1, R1.w;
MOV result.texcoord[2].xyz, c[0].x;
MOV result.texcoord[3].xy, vertex.texcoord[0];
MAD result.texcoord[5].zw, R0, c[16].xyxy, c[16];
MAD result.texcoord[5].xy, R0, c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 3 R-regs
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
Float 13 [_EnvTimer]
Vector 14 [_EnvSide_ST]
Vector 15 [_EnvTop_ST]
"vs_2_0
; 35 ALU
def c16, -0.26789999, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r1.xyz, r0, c16.y
abs r2.xyz, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov oT0, r0
dp3 r0.w, r1, r1
rsq r0.w, r0.w
add r0.xyz, r0, -c12
mul oT1.xyz, r0.w, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT4.xyz, r0.w, r0
add r2.xyz, r2, c16.x
max r1.xyz, r2, c16.y
add r1.w, r1.x, r1.y
add r1.w, r1.z, r1
rcp r1.w, r1.w
mov r0.y, c16
mov r0.x, c13
add r0.zw, v0.xyzx, r0.xyxy
add r0.xy, v0.zyzw, r0
mul oT6.xyz, r1, r1.w
mov oT2.xyz, c16.y
mov oT3.xy, v2
mad oT5.zw, r0, c15.xyxy, c15
mad oT5.xy, r0, c14, c14.zwzw
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  mediump vec2 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_2 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = abs (tmpvar_1);
  blend_weights = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 / vec3(((tmpvar_12.x + tmpvar_12.y) + tmpvar_12.z)));
  blend_weights = tmpvar_13;
  tmpvar_5 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.y = 0.0;
  tmpvar_14.x = _EnvTimer;
  highp vec2 tmpvar_15;
  tmpvar_15 = (_glesVertex.zy + tmpvar_14);
  tmpvar_4.xy = tmpvar_15;
  tmpvar_4.xy = ((tmpvar_4.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zx + tmpvar_16);
  tmpvar_4.zw = tmpvar_17;
  tmpvar_4.zw = ((tmpvar_4.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = tmpvar_6;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  mediump vec2 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_2 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = abs (tmpvar_1);
  blend_weights = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 / vec3(((tmpvar_12.x + tmpvar_12.y) + tmpvar_12.z)));
  blend_weights = tmpvar_13;
  tmpvar_5 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.y = 0.0;
  tmpvar_14.x = _EnvTimer;
  highp vec2 tmpvar_15;
  tmpvar_15 = (_glesVertex.zy + tmpvar_14);
  tmpvar_4.xy = tmpvar_15;
  tmpvar_4.xy = ((tmpvar_4.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zx + tmpvar_16);
  tmpvar_4.zw = tmpvar_17;
  tmpvar_4.zw = ((tmpvar_4.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = tmpvar_6;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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
Float 13 [_EnvTimer]
Vector 14 [_EnvSide_ST]
Vector 15 [_EnvTop_ST]
"agal_vs
c16 -0.2679 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaabaaahacaaaaaakeacaaaaaabaaaaaffabaaaaaa add r1.xyz, r0.xyzz, c16.y
beaaaaaaacaaahacabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa abs r2.xyz, a1
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
bcaaaaaaaaaaaiacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.w, r1.xyzz, r1.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
acaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r0.xyz, r0.xyzz, c12
adaaaaaaabaaahaeaaaaaappacaaaaaaabaaaakeacaaaaaa mul v1.xyz, r0.w, r1.xyzz
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaaeaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v4.xyz, r0.w, r0.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaabaaaaaaaabaaaaaa add r2.xyz, r2.xyzz, c16.x
ahaaaaaaabaaahacacaaaakeacaaaaaabaaaaaffabaaaaaa max r1.xyz, r2.xyzz, c16.y
abaaaaaaabaaaiacabaaaaaaacaaaaaaabaaaaffacaaaaaa add r1.w, r1.x, r1.y
abaaaaaaabaaaiacabaaaakkacaaaaaaabaaaappacaaaaaa add r1.w, r1.z, r1.w
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
aaaaaaaaaaaaacacbaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c16
aaaaaaaaaaaaabacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13
abaaaaaaaaaaamacaaaaaaceaaaaaaaaaaaaaaefacaaaaaa add r0.zw, a0.xyzx, r0.yyxy
abaaaaaaaaaaadacaaaaaaogaaaaaaaaaaaaaafeacaaaaaa add r0.xy, a0.zyzw, r0.xyyy
adaaaaaaagaaahaeabaaaakeacaaaaaaabaaaappacaaaaaa mul v6.xyz, r1.xyzz, r1.w
aaaaaaaaacaaahaebaaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, c16.y
aaaaaaaaadaaadaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3.xy, a3
adaaaaaaabaaamacaaaaaaopacaaaaaaapaaaaeeabaaaaaa mul r1.zw, r0.wwzw, c15.xyxy
abaaaaaaafaaamaeabaaaaopacaaaaaaapaaaaoeabaaaaaa add v5.zw, r1.wwzw, c15
adaaaaaaaaaaadacaaaaaafeacaaaaaaaoaaaaoeabaaaaaa mul r0.xy, r0.xyyy, c14
abaaaaaaafaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v5.xy, r0.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaagaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v6.w, c0
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
Float 14 [_EnvTimer]
Vector 15 [_EnvSide_ST]
Vector 16 [_EnvTop_ST]
"!!ARBvp1.0
# 35 ALU
PARAM c[17] = { { 0, 0.26789999 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R1.xyz, R0, c[0].x;
ABS R2.xyz, vertex.normal;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
ADD R0.xyz, R0, -c[13];
MUL result.texcoord[1].xyz, R0.w, R1;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
ADD R2.xyz, R2, -c[0].y;
MAX R1.xyz, R2, c[0].x;
ADD R1.w, R1.x, R1.y;
ADD R1.w, R1.z, R1;
RCP R1.w, R1.w;
MOV R0.y, c[0].x;
MOV R0.x, c[14];
ADD R0.zw, vertex.position.xyzx, R0.xyxy;
ADD R0.xy, vertex.position.zyzw, R0;
MUL result.texcoord[6].xyz, R1, R1.w;
MOV result.texcoord[2].xyz, c[0].x;
MOV result.texcoord[3].xy, vertex.texcoord[0];
MAD result.texcoord[5].zw, R0, c[16].xyxy, c[16];
MAD result.texcoord[5].xy, R0, c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 3 R-regs
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
Float 13 [_EnvTimer]
Vector 14 [_EnvSide_ST]
Vector 15 [_EnvTop_ST]
"vs_2_0
; 35 ALU
def c16, -0.26789999, 0.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r1.xyz, r0, c16.y
abs r2.xyz, v1
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov oT0, r0
dp3 r0.w, r1, r1
rsq r0.w, r0.w
add r0.xyz, r0, -c12
mul oT1.xyz, r0.w, r1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT4.xyz, r0.w, r0
add r2.xyz, r2, c16.x
max r1.xyz, r2, c16.y
add r1.w, r1.x, r1.y
add r1.w, r1.z, r1
rcp r1.w, r1.w
mov r0.y, c16
mov r0.x, c13
add r0.zw, v0.xyzx, r0.xyxy
add r0.xy, v0.zyzw, r0
mul oT6.xyz, r1, r1.w
mov oT2.xyz, c16.y
mov oT3.xy, v2
mad oT5.zw, r0, c15.xyxy, c15
mad oT5.xy, r0, c14, c14.zwzw
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  mediump vec2 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_2 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = abs (tmpvar_1);
  blend_weights = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 / vec3(((tmpvar_12.x + tmpvar_12.y) + tmpvar_12.z)));
  blend_weights = tmpvar_13;
  tmpvar_5 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.y = 0.0;
  tmpvar_14.x = _EnvTimer;
  highp vec2 tmpvar_15;
  tmpvar_15 = (_glesVertex.zy + tmpvar_14);
  tmpvar_4.xy = tmpvar_15;
  tmpvar_4.xy = ((tmpvar_4.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zx + tmpvar_16);
  tmpvar_4.zw = tmpvar_17;
  tmpvar_4.zw = ((tmpvar_4.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = tmpvar_6;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  mediump vec2 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_2 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_3 = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = abs (tmpvar_1);
  blend_weights = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_12 / vec3(((tmpvar_12.x + tmpvar_12.y) + tmpvar_12.z)));
  blend_weights = tmpvar_13;
  tmpvar_5 = tmpvar_13;
  highp vec2 tmpvar_14;
  tmpvar_14.y = 0.0;
  tmpvar_14.x = _EnvTimer;
  highp vec2 tmpvar_15;
  tmpvar_15 = (_glesVertex.zy + tmpvar_14);
  tmpvar_4.xy = tmpvar_15;
  tmpvar_4.xy = ((tmpvar_4.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zx + tmpvar_16);
  tmpvar_4.zw = tmpvar_17;
  tmpvar_4.zw = ((tmpvar_4.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = tmpvar_6;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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
Float 13 [_EnvTimer]
Vector 14 [_EnvSide_ST]
Vector 15 [_EnvTop_ST]
"agal_vs
c16 -0.2679 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r2.xyzz, r0.xyzz
abaaaaaaabaaahacaaaaaakeacaaaaaabaaaaaffabaaaaaa add r1.xyz, r0.xyzz, c16.y
beaaaaaaacaaahacabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa abs r2.xyz, a1
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
bcaaaaaaaaaaaiacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.w, r1.xyzz, r1.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
acaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r0.xyz, r0.xyzz, c12
adaaaaaaabaaahaeaaaaaappacaaaaaaabaaaakeacaaaaaa mul v1.xyz, r0.w, r1.xyzz
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaaeaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v4.xyz, r0.w, r0.xyzz
abaaaaaaacaaahacacaaaakeacaaaaaabaaaaaaaabaaaaaa add r2.xyz, r2.xyzz, c16.x
ahaaaaaaabaaahacacaaaakeacaaaaaabaaaaaffabaaaaaa max r1.xyz, r2.xyzz, c16.y
abaaaaaaabaaaiacabaaaaaaacaaaaaaabaaaaffacaaaaaa add r1.w, r1.x, r1.y
abaaaaaaabaaaiacabaaaakkacaaaaaaabaaaappacaaaaaa add r1.w, r1.z, r1.w
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
aaaaaaaaaaaaacacbaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c16
aaaaaaaaaaaaabacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c13
abaaaaaaaaaaamacaaaaaaceaaaaaaaaaaaaaaefacaaaaaa add r0.zw, a0.xyzx, r0.yyxy
abaaaaaaaaaaadacaaaaaaogaaaaaaaaaaaaaafeacaaaaaa add r0.xy, a0.zyzw, r0.xyyy
adaaaaaaagaaahaeabaaaakeacaaaaaaabaaaappacaaaaaa mul v6.xyz, r1.xyzz, r1.w
aaaaaaaaacaaahaebaaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, c16.y
aaaaaaaaadaaadaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3.xy, a3
adaaaaaaabaaamacaaaaaaopacaaaaaaapaaaaeeabaaaaaa mul r1.zw, r0.wwzw, c15.xyxy
abaaaaaaafaaamaeabaaaaopacaaaaaaapaaaaoeabaaaaaa add v5.zw, r1.wwzw, c15
adaaaaaaaaaaadacaaaaaafeacaaaaaaaoaaaaoeabaaaaaa mul r0.xy, r0.xyyy, c14
abaaaaaaafaaadaeaaaaaafeacaaaaaaaoaaaaooabaaaaaa add v5.xy, r0.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaagaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v6.w, c0
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
Vector 20 [_Color]
Float 21 [_EnvTimer]
Vector 22 [_EnvSide_ST]
Vector 23 [_EnvTop_ST]
"!!ARBvp1.0
# 66 ALU
PARAM c[24] = { { 0, 0.26789999, 1 },
		state.matrix.mvp,
		program.local[5..23] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R0;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
MOV R2.x, c[14].y;
MOV R2.z, c[16].y;
MOV R2.y, c[15];
ADD R2.xyz, -R0, R2;
DP3 R0.w, R2, R2;
RSQ R2.w, R0.w;
MUL R2.xyz, R2.w, R2;
DP3 R2.x, R1, R2;
MUL R0.w, R0, c[17].y;
ADD R1.w, R0, c[0].z;
MAX R0.w, R2.x, c[0].x;
RCP R1.w, R1.w;
MOV R2.x, c[14];
MOV R2.z, c[16].x;
MOV R2.y, c[15].x;
ADD R3.xyz, -R0, R2;
MUL R2.xyz, R1.w, c[19];
MUL R2.xyz, R2, c[20];
MUL R2.xyz, R2, R0.w;
DP3 R1.w, R3, R3;
MUL R0.w, R1, c[17].x;
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, R3;
ADD R0.w, R0, c[0].z;
DP3 R1.w, R1, R3;
RCP R0.w, R0.w;
MUL R3.xyz, R0.w, c[18];
MAX R0.w, R1, c[0].x;
MUL R3.xyz, R3, c[20];
MUL R3.xyz, R3, R0.w;
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
ADD result.texcoord[2].xyz, R3, R2;
ABS R2.xyz, vertex.normal;
MOV R0.y, c[0].x;
MOV R0.x, c[21];
ADD R0.zw, vertex.position.xyzx, R0.xyxy;
ADD R0.xy, vertex.position.zyzw, R0;
ADD R2.xyz, R2, -c[0].y;
MOV result.texcoord[1].xyz, R1;
MAX R1.xyz, R2, c[0].x;
ADD R1.w, R1.x, R1.y;
ADD R1.w, R1.z, R1;
RCP R1.w, R1.w;
MUL result.texcoord[6].xyz, R1, R1.w;
MOV result.texcoord[3].xy, vertex.texcoord[0];
MAD result.texcoord[5].zw, R0, c[23].xyxy, c[23];
MAD result.texcoord[5].xy, R0, c[22], c[22].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 66 instructions, 4 R-regs
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
Vector 19 [_Color]
Float 20 [_EnvTimer]
Vector 21 [_EnvSide_ST]
Vector 22 [_EnvTop_ST]
"vs_2_0
; 66 ALU
def c23, -0.26789999, 0.00000000, 1.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r0
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c23.y
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r2.x, c13.y
mov r2.z, c15.y
mov r2.y, c14
add r2.xyz, -r0, r2
dp3 r0.w, r2, r2
rsq r2.w, r0.w
mul r2.xyz, r2.w, r2
dp3 r1.w, r1, r2
mul r0.w, r0, c16.y
add r0.w, r0, c23.z
rcp r0.w, r0.w
mul r3.xyz, r0.w, c18
max r1.w, r1, c23.y
mul r3.xyz, r3, c19
mul r3.xyz, r3, r1.w
mov r2.x, c13
mov r2.z, c15.x
mov r2.y, c14.x
add r2.xyz, -r0, r2
dp3 r0.w, r2, r2
rsq r2.w, r0.w
mul r1.w, r0, c16.x
add r0.w, r1, c23.z
mul r2.xyz, r2.w, r2
dp3 r1.w, r1, r2
rcp r0.w, r0.w
mul r2.xyz, r0.w, c17
max r0.w, r1, c23.y
mul r2.xyz, r2, c19
mul r2.xyz, r2, r0.w
dp4 r0.w, v0, c7
mov oT0, r0
add r0.xyz, r0, -c12
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT4.xyz, r0.w, r0
add oT2.xyz, r2, r3
abs r2.xyz, v1
mov r0.y, c23
mov r0.x, c20
add r0.zw, v0.xyzx, r0.xyxy
add r0.xy, v0.zyzw, r0
add r2.xyz, r2, c23.x
mov oT1.xyz, r1
max r1.xyz, r2, c23.y
add r1.w, r1.x, r1.y
add r1.w, r1.z, r1
rcp r1.w, r1.w
mul oT6.xyz, r1, r1.w
mov oT3.xy, v2
mad oT5.zw, r0, c22.xyxy, c22
mad oT5.xy, r0, c21, c21.zwzw
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 diffuseReflection;
  lowp float attenuation;
  lowp vec3 vertexToLightSource;
  lowp vec4 lightPosition;
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  mediump vec2 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (_Object2World * _glesVertex);
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * _World2Object).xyz);
  tmpvar_2 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((_Object2World * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = abs (tmpvar_1);
  blend_weights = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 / vec3(((tmpvar_14.x + tmpvar_14.y) + tmpvar_14.z)));
  blend_weights = tmpvar_15;
  tmpvar_6 = tmpvar_15;
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zy + tmpvar_16);
  tmpvar_5.xy = tmpvar_17;
  tmpvar_5.xy = ((tmpvar_5.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_18;
  tmpvar_18.y = 0.0;
  tmpvar_18.x = _EnvTimer;
  highp vec2 tmpvar_19;
  tmpvar_19 = (_glesVertex.zx + tmpvar_18);
  tmpvar_5.zw = tmpvar_19;
  tmpvar_5.zw = ((tmpvar_5.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.x = unity_4LightPosX0.x;
  tmpvar_20.y = unity_4LightPosY0.x;
  tmpvar_20.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (lightPosition - tmpvar_8).xyz;
  vertexToLightSource = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_23;
  tmpvar_23 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_22))));
  attenuation = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = max (0.0, dot (tmpvar_2, normalize (vertexToLightSource)));
  highp vec3 tmpvar_25;
  tmpvar_25 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_24);
  diffuseReflection = tmpvar_25;
  tmpvar_3 = diffuseReflection;
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.x = unity_4LightPosX0.y;
  tmpvar_26.y = unity_4LightPosY0.y;
  tmpvar_26.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (lightPosition - tmpvar_8).xyz;
  vertexToLightSource = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_29;
  tmpvar_29 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_28))));
  attenuation = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = max (0.0, dot (tmpvar_2, normalize (vertexToLightSource)));
  highp vec3 tmpvar_31;
  tmpvar_31 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_30);
  diffuseReflection = tmpvar_31;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_8;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = tmpvar_7;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 diffuseReflection;
  lowp float attenuation;
  lowp vec3 vertexToLightSource;
  lowp vec4 lightPosition;
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  mediump vec2 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (_Object2World * _glesVertex);
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * _World2Object).xyz);
  tmpvar_2 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((_Object2World * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = abs (tmpvar_1);
  blend_weights = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 / vec3(((tmpvar_14.x + tmpvar_14.y) + tmpvar_14.z)));
  blend_weights = tmpvar_15;
  tmpvar_6 = tmpvar_15;
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zy + tmpvar_16);
  tmpvar_5.xy = tmpvar_17;
  tmpvar_5.xy = ((tmpvar_5.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_18;
  tmpvar_18.y = 0.0;
  tmpvar_18.x = _EnvTimer;
  highp vec2 tmpvar_19;
  tmpvar_19 = (_glesVertex.zx + tmpvar_18);
  tmpvar_5.zw = tmpvar_19;
  tmpvar_5.zw = ((tmpvar_5.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.x = unity_4LightPosX0.x;
  tmpvar_20.y = unity_4LightPosY0.x;
  tmpvar_20.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (lightPosition - tmpvar_8).xyz;
  vertexToLightSource = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_23;
  tmpvar_23 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_22))));
  attenuation = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = max (0.0, dot (tmpvar_2, normalize (vertexToLightSource)));
  highp vec3 tmpvar_25;
  tmpvar_25 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_24);
  diffuseReflection = tmpvar_25;
  tmpvar_3 = diffuseReflection;
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.x = unity_4LightPosX0.y;
  tmpvar_26.y = unity_4LightPosY0.y;
  tmpvar_26.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (lightPosition - tmpvar_8).xyz;
  vertexToLightSource = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_29;
  tmpvar_29 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_28))));
  attenuation = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = max (0.0, dot (tmpvar_2, normalize (vertexToLightSource)));
  highp vec3 tmpvar_31;
  tmpvar_31 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_30);
  diffuseReflection = tmpvar_31;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_8;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = tmpvar_7;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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
Vector 19 [_Color]
Float 20 [_EnvTimer]
Vector 21 [_EnvSide_ST]
Vector 22 [_EnvTop_ST]
"agal_vs
c23 -0.2679 0.0 1.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaabaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r2.xyzz, r1.xyzz
abaaaaaaabaaahacabaaaakeacaaaaaabhaaaaffabaaaaaa add r1.xyz, r1.xyzz, c23.y
bcaaaaaaabaaaiacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r1.w, r1.xyzz, r1.xyzz
akaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r1.w
adaaaaaaabaaahacabaaaappacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r1.w, r1.xyzz
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
aaaaaaaaacaaabacanaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r2.x, c13.y
aaaaaaaaacaaaeacapaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r2.z, c15.y
aaaaaaaaacaaacacaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.y, c14
bfaaaaaaadaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r3.xyz, r0.xyzz
abaaaaaaacaaahacadaaaakeacaaaaaaacaaaakeacaaaaaa add r2.xyz, r3.xyzz, r2.xyzz
bcaaaaaaaaaaaiacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r0.w, r2.xyzz, r2.xyzz
akaaaaaaacaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r0.w
adaaaaaaacaaahacacaaaappacaaaaaaacaaaakeacaaaaaa mul r2.xyz, r2.w, r2.xyzz
bcaaaaaaabaaaiacabaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r1.w, r1.xyzz, r2.xyzz
adaaaaaaaaaaaiacaaaaaappacaaaaaabaaaaaffabaaaaaa mul r0.w, r0.w, c16.y
abaaaaaaaaaaaiacaaaaaappacaaaaaabhaaaakkabaaaaaa add r0.w, r0.w, c23.z
afaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.w, r0.w
adaaaaaaadaaahacaaaaaappacaaaaaabcaaaaoeabaaaaaa mul r3.xyz, r0.w, c18
ahaaaaaaabaaaiacabaaaappacaaaaaabhaaaaffabaaaaaa max r1.w, r1.w, c23.y
adaaaaaaadaaahacadaaaakeacaaaaaabdaaaaoeabaaaaaa mul r3.xyz, r3.xyzz, c19
adaaaaaaadaaahacadaaaakeacaaaaaaabaaaappacaaaaaa mul r3.xyz, r3.xyzz, r1.w
aaaaaaaaacaaabacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.x, c13
aaaaaaaaacaaaeacapaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r2.z, c15.x
aaaaaaaaacaaacacaoaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r2.y, c14.x
bfaaaaaaaeaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r0.xyzz
abaaaaaaacaaahacaeaaaakeacaaaaaaacaaaakeacaaaaaa add r2.xyz, r4.xyzz, r2.xyzz
bcaaaaaaaaaaaiacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r0.w, r2.xyzz, r2.xyzz
akaaaaaaacaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r0.w
adaaaaaaabaaaiacaaaaaappacaaaaaabaaaaaaaabaaaaaa mul r1.w, r0.w, c16.x
abaaaaaaaaaaaiacabaaaappacaaaaaabhaaaakkabaaaaaa add r0.w, r1.w, c23.z
adaaaaaaacaaahacacaaaappacaaaaaaacaaaakeacaaaaaa mul r2.xyz, r2.w, r2.xyzz
bcaaaaaaabaaaiacabaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r1.w, r1.xyzz, r2.xyzz
afaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.w, r0.w
adaaaaaaacaaahacaaaaaappacaaaaaabbaaaaoeabaaaaaa mul r2.xyz, r0.w, c17
ahaaaaaaaaaaaiacabaaaappacaaaaaabhaaaaffabaaaaaa max r0.w, r1.w, c23.y
adaaaaaaacaaahacacaaaakeacaaaaaabdaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c19
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaappacaaaaaa mul r2.xyz, r2.xyzz, r0.w
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
acaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r0.xyz, r0.xyzz, c12
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaaeaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v4.xyz, r0.w, r0.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaaadaaaakeacaaaaaa add v2.xyz, r2.xyzz, r3.xyzz
beaaaaaaacaaahacabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa abs r2.xyz, a1
aaaaaaaaaaaaacacbhaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c23
aaaaaaaaaaaaabacbeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c20
abaaaaaaaaaaamacaaaaaaceaaaaaaaaaaaaaaefacaaaaaa add r0.zw, a0.xyzx, r0.yyxy
abaaaaaaaaaaadacaaaaaaogaaaaaaaaaaaaaafeacaaaaaa add r0.xy, a0.zyzw, r0.xyyy
abaaaaaaacaaahacacaaaakeacaaaaaabhaaaaaaabaaaaaa add r2.xyz, r2.xyzz, c23.x
aaaaaaaaabaaahaeabaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xyz, r1.xyzz
ahaaaaaaabaaahacacaaaakeacaaaaaabhaaaaffabaaaaaa max r1.xyz, r2.xyzz, c23.y
abaaaaaaabaaaiacabaaaaaaacaaaaaaabaaaaffacaaaaaa add r1.w, r1.x, r1.y
abaaaaaaabaaaiacabaaaakkacaaaaaaabaaaappacaaaaaa add r1.w, r1.z, r1.w
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
adaaaaaaagaaahaeabaaaakeacaaaaaaabaaaappacaaaaaa mul v6.xyz, r1.xyzz, r1.w
aaaaaaaaadaaadaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3.xy, a3
adaaaaaaaeaaamacaaaaaaopacaaaaaabgaaaaeeabaaaaaa mul r4.zw, r0.wwzw, c22.xyxy
abaaaaaaafaaamaeaeaaaaopacaaaaaabgaaaaoeabaaaaaa add v5.zw, r4.wwzw, c22
adaaaaaaaeaaadacaaaaaafeacaaaaaabfaaaaoeabaaaaaa mul r4.xy, r0.xyyy, c21
abaaaaaaafaaadaeaeaaaafeacaaaaaabfaaaaooabaaaaaa add v5.xy, r4.xyyy, c21.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaagaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v6.w, c0
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
Vector 20 [_Color]
Float 21 [_EnvTimer]
Vector 22 [_EnvSide_ST]
Vector 23 [_EnvTop_ST]
"!!ARBvp1.0
# 66 ALU
PARAM c[24] = { { 0, 0.26789999, 1 },
		state.matrix.mvp,
		program.local[5..23] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R0;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
MUL R1.xyz, R1.w, R1;
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
MOV R2.x, c[14].y;
MOV R2.z, c[16].y;
MOV R2.y, c[15];
ADD R2.xyz, -R0, R2;
DP3 R0.w, R2, R2;
RSQ R2.w, R0.w;
MUL R2.xyz, R2.w, R2;
DP3 R2.x, R1, R2;
MUL R0.w, R0, c[17].y;
ADD R1.w, R0, c[0].z;
MAX R0.w, R2.x, c[0].x;
RCP R1.w, R1.w;
MOV R2.x, c[14];
MOV R2.z, c[16].x;
MOV R2.y, c[15].x;
ADD R3.xyz, -R0, R2;
MUL R2.xyz, R1.w, c[19];
MUL R2.xyz, R2, c[20];
MUL R2.xyz, R2, R0.w;
DP3 R1.w, R3, R3;
MUL R0.w, R1, c[17].x;
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, R3;
ADD R0.w, R0, c[0].z;
DP3 R1.w, R1, R3;
RCP R0.w, R0.w;
MUL R3.xyz, R0.w, c[18];
MAX R0.w, R1, c[0].x;
MUL R3.xyz, R3, c[20];
MUL R3.xyz, R3, R0.w;
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
ADD result.texcoord[2].xyz, R3, R2;
ABS R2.xyz, vertex.normal;
MOV R0.y, c[0].x;
MOV R0.x, c[21];
ADD R0.zw, vertex.position.xyzx, R0.xyxy;
ADD R0.xy, vertex.position.zyzw, R0;
ADD R2.xyz, R2, -c[0].y;
MOV result.texcoord[1].xyz, R1;
MAX R1.xyz, R2, c[0].x;
ADD R1.w, R1.x, R1.y;
ADD R1.w, R1.z, R1;
RCP R1.w, R1.w;
MUL result.texcoord[6].xyz, R1, R1.w;
MOV result.texcoord[3].xy, vertex.texcoord[0];
MAD result.texcoord[5].zw, R0, c[23].xyxy, c[23];
MAD result.texcoord[5].xy, R0, c[22], c[22].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 66 instructions, 4 R-regs
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
Vector 19 [_Color]
Float 20 [_EnvTimer]
Vector 21 [_EnvSide_ST]
Vector 22 [_EnvTop_ST]
"vs_2_0
; 66 ALU
def c23, -0.26789999, 0.00000000, 1.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r0
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c23.y
dp3 r1.w, r1, r1
rsq r1.w, r1.w
mul r1.xyz, r1.w, r1
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r2.x, c13.y
mov r2.z, c15.y
mov r2.y, c14
add r2.xyz, -r0, r2
dp3 r0.w, r2, r2
rsq r2.w, r0.w
mul r2.xyz, r2.w, r2
dp3 r1.w, r1, r2
mul r0.w, r0, c16.y
add r0.w, r0, c23.z
rcp r0.w, r0.w
mul r3.xyz, r0.w, c18
max r1.w, r1, c23.y
mul r3.xyz, r3, c19
mul r3.xyz, r3, r1.w
mov r2.x, c13
mov r2.z, c15.x
mov r2.y, c14.x
add r2.xyz, -r0, r2
dp3 r0.w, r2, r2
rsq r2.w, r0.w
mul r1.w, r0, c16.x
add r0.w, r1, c23.z
mul r2.xyz, r2.w, r2
dp3 r1.w, r1, r2
rcp r0.w, r0.w
mul r2.xyz, r0.w, c17
max r0.w, r1, c23.y
mul r2.xyz, r2, c19
mul r2.xyz, r2, r0.w
dp4 r0.w, v0, c7
mov oT0, r0
add r0.xyz, r0, -c12
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT4.xyz, r0.w, r0
add oT2.xyz, r2, r3
abs r2.xyz, v1
mov r0.y, c23
mov r0.x, c20
add r0.zw, v0.xyzx, r0.xyxy
add r0.xy, v0.zyzw, r0
add r2.xyz, r2, c23.x
mov oT1.xyz, r1
max r1.xyz, r2, c23.y
add r1.w, r1.x, r1.y
add r1.w, r1.z, r1
rcp r1.w, r1.w
mul oT6.xyz, r1, r1.w
mov oT3.xy, v2
mad oT5.zw, r0, c22.xyxy, c22
mad oT5.xy, r0, c21, c21.zwzw
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 diffuseReflection;
  lowp float attenuation;
  lowp vec3 vertexToLightSource;
  lowp vec4 lightPosition;
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  mediump vec2 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (_Object2World * _glesVertex);
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * _World2Object).xyz);
  tmpvar_2 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((_Object2World * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = abs (tmpvar_1);
  blend_weights = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 / vec3(((tmpvar_14.x + tmpvar_14.y) + tmpvar_14.z)));
  blend_weights = tmpvar_15;
  tmpvar_6 = tmpvar_15;
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zy + tmpvar_16);
  tmpvar_5.xy = tmpvar_17;
  tmpvar_5.xy = ((tmpvar_5.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_18;
  tmpvar_18.y = 0.0;
  tmpvar_18.x = _EnvTimer;
  highp vec2 tmpvar_19;
  tmpvar_19 = (_glesVertex.zx + tmpvar_18);
  tmpvar_5.zw = tmpvar_19;
  tmpvar_5.zw = ((tmpvar_5.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.x = unity_4LightPosX0.x;
  tmpvar_20.y = unity_4LightPosY0.x;
  tmpvar_20.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (lightPosition - tmpvar_8).xyz;
  vertexToLightSource = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_23;
  tmpvar_23 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_22))));
  attenuation = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = max (0.0, dot (tmpvar_2, normalize (vertexToLightSource)));
  highp vec3 tmpvar_25;
  tmpvar_25 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_24);
  diffuseReflection = tmpvar_25;
  tmpvar_3 = diffuseReflection;
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.x = unity_4LightPosX0.y;
  tmpvar_26.y = unity_4LightPosY0.y;
  tmpvar_26.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (lightPosition - tmpvar_8).xyz;
  vertexToLightSource = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_29;
  tmpvar_29 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_28))));
  attenuation = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = max (0.0, dot (tmpvar_2, normalize (vertexToLightSource)));
  highp vec3 tmpvar_31;
  tmpvar_31 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_30);
  diffuseReflection = tmpvar_31;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_8;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = tmpvar_7;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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

varying mediump vec2 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform lowp vec4 _EnvTop_ST;
uniform highp float _EnvTimer;
uniform lowp vec4 _EnvSide_ST;
uniform lowp vec4 _Color;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  lowp vec3 diffuseReflection;
  lowp float attenuation;
  lowp vec3 vertexToLightSource;
  lowp vec4 lightPosition;
  highp vec3 blend_weights;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  mediump vec2 tmpvar_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (_Object2World * _glesVertex);
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * _World2Object).xyz);
  tmpvar_2 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((_Object2World * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  lowp vec3 tmpvar_13;
  tmpvar_13 = abs (tmpvar_1);
  blend_weights = tmpvar_13;
  highp vec3 tmpvar_14;
  tmpvar_14 = max ((blend_weights - 0.2679), vec3(0.0, 0.0, 0.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = (tmpvar_14 / vec3(((tmpvar_14.x + tmpvar_14.y) + tmpvar_14.z)));
  blend_weights = tmpvar_15;
  tmpvar_6 = tmpvar_15;
  highp vec2 tmpvar_16;
  tmpvar_16.y = 0.0;
  tmpvar_16.x = _EnvTimer;
  highp vec2 tmpvar_17;
  tmpvar_17 = (_glesVertex.zy + tmpvar_16);
  tmpvar_5.xy = tmpvar_17;
  tmpvar_5.xy = ((tmpvar_5.xy * _EnvSide_ST.xy) + _EnvSide_ST.zw);
  highp vec2 tmpvar_18;
  tmpvar_18.y = 0.0;
  tmpvar_18.x = _EnvTimer;
  highp vec2 tmpvar_19;
  tmpvar_19 = (_glesVertex.zx + tmpvar_18);
  tmpvar_5.zw = tmpvar_19;
  tmpvar_5.zw = ((tmpvar_5.zw * _EnvTop_ST.xy) + _EnvTop_ST.zw);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.x = unity_4LightPosX0.x;
  tmpvar_20.y = unity_4LightPosY0.x;
  tmpvar_20.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = (lightPosition - tmpvar_8).xyz;
  vertexToLightSource = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_23;
  tmpvar_23 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_22))));
  attenuation = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = max (0.0, dot (tmpvar_2, normalize (vertexToLightSource)));
  highp vec3 tmpvar_25;
  tmpvar_25 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_24);
  diffuseReflection = tmpvar_25;
  tmpvar_3 = diffuseReflection;
  highp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.x = unity_4LightPosX0.y;
  tmpvar_26.y = unity_4LightPosY0.y;
  tmpvar_26.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_26;
  highp vec3 tmpvar_27;
  tmpvar_27 = (lightPosition - tmpvar_8).xyz;
  vertexToLightSource = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_29;
  tmpvar_29 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_28))));
  attenuation = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = max (0.0, dot (tmpvar_2, normalize (vertexToLightSource)));
  highp vec3 tmpvar_31;
  tmpvar_31 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_30);
  diffuseReflection = tmpvar_31;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_8;
  xlv_TEXCOORD1 = tmpvar_2;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0.xy;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = tmpvar_7;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec4 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec2 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform mediump float _Shininess;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform sampler2D _EnvTop;
uniform sampler2D _EnvSide;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp float attenuation;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_2;
  tmpvar_2 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, xlv_TEXCOORD3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_4;
    tmpvar_4 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_4;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
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
    lowp float tmpvar_8;
    tmpvar_8 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_9;
    tmpvar_9 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_8, _Shininess));
    specularReflection = tmpvar_9;
  };
  mediump vec3 tmpvar_10;
  tmpvar_10 = (specularReflection * _Gloss);
  specularReflection = tmpvar_10;
  lowp vec3 tmpvar_11;
  tmpvar_11 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_12;
  tmpvar_12 = textureCube (_Cube, tmpvar_11);
  reflTex = tmpvar_12;
  lowp float tmpvar_13;
  tmpvar_13 = clamp (abs (dot (tmpvar_11, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_14;
  tmpvar_14 = pow ((1.0 - tmpvar_13), _FrezFalloff);
  frez = tmpvar_14;
  lowp float tmpvar_15;
  tmpvar_15 = (frez * _FrezPow);
  frez = tmpvar_15;
  reflTex.xyz = (tmpvar_12.xyz * clamp ((_Reflection + tmpvar_15), 0.0, 1.0));
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = ((tmpvar_3.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_6), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = (((tmpvar_16 + reflTex) + (tmpvar_15 * reflTex)) + ((texture2D (_EnvSide, xlv_TEXCOORD5.xy) * xlv_TEXCOORD6.xxxx) + (texture2D (_EnvTop, xlv_TEXCOORD5.zw) * xlv_TEXCOORD6.yyyy)));
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
Vector 19 [_Color]
Float 20 [_EnvTimer]
Vector 21 [_EnvSide_ST]
Vector 22 [_EnvTop_ST]
"agal_vs
c23 -0.2679 0.0 1.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r2.xyz, a1.z, c10
abaaaaaaabaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r2.xyzz, r1.xyzz
abaaaaaaabaaahacabaaaakeacaaaaaabhaaaaffabaaaaaa add r1.xyz, r1.xyzz, c23.y
bcaaaaaaabaaaiacabaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r1.w, r1.xyzz, r1.xyzz
akaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r1.w, r1.w
adaaaaaaabaaahacabaaaappacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r1.w, r1.xyzz
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
aaaaaaaaacaaabacanaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r2.x, c13.y
aaaaaaaaacaaaeacapaaaaffabaaaaaaaaaaaaaaaaaaaaaa mov r2.z, c15.y
aaaaaaaaacaaacacaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.y, c14
bfaaaaaaadaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r3.xyz, r0.xyzz
abaaaaaaacaaahacadaaaakeacaaaaaaacaaaakeacaaaaaa add r2.xyz, r3.xyzz, r2.xyzz
bcaaaaaaaaaaaiacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r0.w, r2.xyzz, r2.xyzz
akaaaaaaacaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r0.w
adaaaaaaacaaahacacaaaappacaaaaaaacaaaakeacaaaaaa mul r2.xyz, r2.w, r2.xyzz
bcaaaaaaabaaaiacabaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r1.w, r1.xyzz, r2.xyzz
adaaaaaaaaaaaiacaaaaaappacaaaaaabaaaaaffabaaaaaa mul r0.w, r0.w, c16.y
abaaaaaaaaaaaiacaaaaaappacaaaaaabhaaaakkabaaaaaa add r0.w, r0.w, c23.z
afaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.w, r0.w
adaaaaaaadaaahacaaaaaappacaaaaaabcaaaaoeabaaaaaa mul r3.xyz, r0.w, c18
ahaaaaaaabaaaiacabaaaappacaaaaaabhaaaaffabaaaaaa max r1.w, r1.w, c23.y
adaaaaaaadaaahacadaaaakeacaaaaaabdaaaaoeabaaaaaa mul r3.xyz, r3.xyzz, c19
adaaaaaaadaaahacadaaaakeacaaaaaaabaaaappacaaaaaa mul r3.xyz, r3.xyzz, r1.w
aaaaaaaaacaaabacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.x, c13
aaaaaaaaacaaaeacapaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r2.z, c15.x
aaaaaaaaacaaacacaoaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r2.y, c14.x
bfaaaaaaaeaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r0.xyzz
abaaaaaaacaaahacaeaaaakeacaaaaaaacaaaakeacaaaaaa add r2.xyz, r4.xyzz, r2.xyzz
bcaaaaaaaaaaaiacacaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r0.w, r2.xyzz, r2.xyzz
akaaaaaaacaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r0.w
adaaaaaaabaaaiacaaaaaappacaaaaaabaaaaaaaabaaaaaa mul r1.w, r0.w, c16.x
abaaaaaaaaaaaiacabaaaappacaaaaaabhaaaakkabaaaaaa add r0.w, r1.w, c23.z
adaaaaaaacaaahacacaaaappacaaaaaaacaaaakeacaaaaaa mul r2.xyz, r2.w, r2.xyzz
bcaaaaaaabaaaiacabaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r1.w, r1.xyzz, r2.xyzz
afaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r0.w, r0.w
adaaaaaaacaaahacaaaaaappacaaaaaabbaaaaoeabaaaaaa mul r2.xyz, r0.w, c17
ahaaaaaaaaaaaiacabaaaappacaaaaaabhaaaaffabaaaaaa max r0.w, r1.w, c23.y
adaaaaaaacaaahacacaaaakeacaaaaaabdaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c19
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaappacaaaaaa mul r2.xyz, r2.xyzz, r0.w
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
aaaaaaaaaaaaapaeaaaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov v0, r0
acaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaoeabaaaaaa sub r0.xyz, r0.xyzz, c12
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaaeaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v4.xyz, r0.w, r0.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaaadaaaakeacaaaaaa add v2.xyz, r2.xyzz, r3.xyzz
beaaaaaaacaaahacabaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa abs r2.xyz, a1
aaaaaaaaaaaaacacbhaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.y, c23
aaaaaaaaaaaaabacbeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c20
abaaaaaaaaaaamacaaaaaaceaaaaaaaaaaaaaaefacaaaaaa add r0.zw, a0.xyzx, r0.yyxy
abaaaaaaaaaaadacaaaaaaogaaaaaaaaaaaaaafeacaaaaaa add r0.xy, a0.zyzw, r0.xyyy
abaaaaaaacaaahacacaaaakeacaaaaaabhaaaaaaabaaaaaa add r2.xyz, r2.xyzz, c23.x
aaaaaaaaabaaahaeabaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v1.xyz, r1.xyzz
ahaaaaaaabaaahacacaaaakeacaaaaaabhaaaaffabaaaaaa max r1.xyz, r2.xyzz, c23.y
abaaaaaaabaaaiacabaaaaaaacaaaaaaabaaaaffacaaaaaa add r1.w, r1.x, r1.y
abaaaaaaabaaaiacabaaaakkacaaaaaaabaaaappacaaaaaa add r1.w, r1.z, r1.w
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
adaaaaaaagaaahaeabaaaakeacaaaaaaabaaaappacaaaaaa mul v6.xyz, r1.xyzz, r1.w
aaaaaaaaadaaadaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3.xy, a3
adaaaaaaaeaaamacaaaaaaopacaaaaaabgaaaaeeabaaaaaa mul r4.zw, r0.wwzw, c22.xyxy
abaaaaaaafaaamaeaeaaaaopacaaaaaabgaaaaoeabaaaaaa add v5.zw, r4.wwzw, c22
adaaaaaaaeaaadacaaaaaafeacaaaaaabfaaaaoeabaaaaaa mul r4.xy, r0.xyyy, c21
abaaaaaaafaaadaeaeaaaafeacaaaaaabfaaaaooabaaaaaa add v5.xy, r4.xyyy, c21.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.zw, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaagaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v6.w, c0
"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 60 to 60, TEX: 4 to 4
//   d3d9 - ALU: 64 to 64, TEX: 4 to 4
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_FrezPow]
Float 9 [_FrezFalloff]
Vector 10 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_EnvSide] 2D
SetTexture 3 [_EnvTop] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 60 ALU, 4 TEX
PARAM c[12] = { state.lightmodel.ambient,
		program.local[1..10],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEX R2, fragment.texcoord[5].zwzw, texture[3], 2D;
TEX R1, fragment.texcoord[5], texture[2], 2D;
TEX R3.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R6.xyz, -fragment.texcoord[0], c[2];
DP3 R3.w, R6, R6;
RSQ R4.w, R3.w;
ADD R8.xyz, -fragment.texcoord[0], c[1];
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R4, fragment.texcoord[4];
MUL R0.xyz, R4, R0.x;
MAD R5.xyz, -R0, c[11].x, fragment.texcoord[4];
ABS R3.w, -c[2];
DP3 R5.w, c[2], c[2];
RSQ R5.w, R5.w;
CMP R3.w, -R3, c[11].z, c[11].y;
DP3 R6.w, R8, R8;
MUL R2, fragment.texcoord[6].y, R2;
MUL R7.xyz, R5.w, c[2];
ABS R3.w, R3;
CMP R5.w, -R3, c[11].z, c[11].y;
MUL R6.xyz, R4.w, R6;
CMP R6.xyz, -R5.w, R6, R7;
DP3 R3.w, R4, R6;
MUL R4.xyz, R4, -R3.w;
RSQ R6.w, R6.w;
MAD R4.xyz, -R4, c[11].x, -R6;
MUL R7.xyz, R6.w, R8;
DP3 R4.x, R4, R7;
MAX R4.x, R4, c[11].z;
POW R6.w, R4.x, c[6].x;
CMP R4.x, -R5.w, R4.w, c[11].y;
SLT R4.w, R3, c[11].z;
MUL R4.xyz, R4.x, c[10];
MUL R6.xyz, R4, c[5];
ABS R4.w, R4;
CMP R5.w, -R4, c[11].z, c[11].y;
DP3 R4.w, R5, fragment.texcoord[1];
ABS_SAT R4.w, R4;
ADD R4.w, -R4, c[11].y;
POW R4.w, R4.w, c[9].x;
MUL R6.xyz, R6, R6.w;
MAX R3.w, R3, c[11].z;
MUL R4.w, R4, c[8].x;
MUL R4.xyz, R4, c[3];
MAD R1, R1, fragment.texcoord[6].x, R2;
TEX R0, R5, texture[1], CUBE;
CMP R5.xyz, -R5.w, R6, c[11].z;
MUL R6.xyz, R5, c[7].x;
MOV R5.xyz, c[3];
MAD R5.xyz, R5, c[0], fragment.texcoord[2];
MAD_SAT R4.xyz, R4, R3.w, R5;
ADD_SAT R3.w, R4, c[4].x;
MUL R0.xyz, R0, R3.w;
MAD R3.xyz, R3, R4, R6;
MOV R3.w, c[11].y;
ADD R3, R0, R3;
MAD R0, R4.w, R0, R3;
ADD result.color, R0, R1;
END
# 60 instructions, 9 R-regs
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
Float 8 [_FrezPow]
Float 9 [_FrezFalloff]
Vector 10 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_EnvSide] 2D
SetTexture 3 [_EnvTop] 2D
"ps_2_0
; 64 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c11, 2.00000000, 1.00000000, 0.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4.xyz
dcl t5
dcl t6.xy
texld r5, t5, s2
texld r7, t3, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r9.xyz, r0.x, t1
dp3_pp r0.x, r9, t4
mul_pp r0.xyz, r9, r0.x
mad_pp r8.xyz, -r0, c11.x, t4
add r2.xyz, -t0, c2
add r10.xyz, -t0, c1
mov r0.y, t5.w
mov r0.x, t5.z
texld r4, r0, s3
texld r6, r8, s1
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r3.xyz, r1.x, r2
dp3_pp r2.x, c2, c2
rsq_pp r2.x, r2.x
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c11.y, c11.z
mul_pp r11.xyz, r2.x, c2
abs_pp r2.x, r0
cmp_pp r11.xyz, -r2.x, r3, r11
dp3_pp r0.x, r9, r11
mul_pp r9.xyz, r9, -r0.x
dp3 r3.x, r10, r10
rsq r3.x, r3.x
mul r3.xyz, r3.x, r10
cmp_pp r1.x, -r2, r1, c11.y
mul_pp r10.xyz, r1.x, c10
mad_pp r9.xyz, -r9, c11.x, -r11
dp3_pp r3.x, r9, r3
max_pp r3.x, r3, c11.z
pow_pp r9.w, r3.x, c6.x
mov_pp r1.x, r9.w
mul_pp r2.xyz, r10, c5
mul_pp r9.xyz, r2, r1.x
cmp_pp r1.x, r0, c11.z, c11.y
dp3_pp r2.x, r8, t1
abs_pp r3.x, r1
abs_pp_sat r1.x, r2
cmp_pp r2.xyz, -r3.x, r9, c11.z
mul_pp r3.xyz, r2, c7.x
add_pp r1.x, -r1, c11.y
pow_pp r2.w, r1.x, c9.x
max_pp r1.x, r0, c11.z
mov_pp r0.x, r2.w
mov_pp r8.xyz, c0
mad_pp r2.xyz, c3, r8, t2
mul_pp r8.xyz, r10, c3
mad_pp_sat r1.xyz, r8, r1.x, r2
mad_pp r2.xyz, r7, r1, r3
mul_pp r0.x, r0, c8
add_pp_sat r1.x, r0, c4
mul_pp r3, t6.y, r4
mul_pp r1.xyz, r6, r1.x
mov_pp r1.w, r6
mov_pp r2.w, c11.y
add_pp r2, r1, r2
mad_pp r3, r5, t6.x, r3
mad_pp r0, r0.x, r1, r2
add_pp r0, r0, r3
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
Float 8 [_FrezPow]
Float 9 [_FrezFalloff]
Vector 10 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_EnvSide] 2D
SetTexture 3 [_EnvTop] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 60 ALU, 4 TEX
PARAM c[12] = { state.lightmodel.ambient,
		program.local[1..10],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEX R2, fragment.texcoord[5].zwzw, texture[3], 2D;
TEX R1, fragment.texcoord[5], texture[2], 2D;
TEX R3.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R6.xyz, -fragment.texcoord[0], c[2];
DP3 R3.w, R6, R6;
RSQ R4.w, R3.w;
ADD R8.xyz, -fragment.texcoord[0], c[1];
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R4, fragment.texcoord[4];
MUL R0.xyz, R4, R0.x;
MAD R5.xyz, -R0, c[11].x, fragment.texcoord[4];
ABS R3.w, -c[2];
DP3 R5.w, c[2], c[2];
RSQ R5.w, R5.w;
CMP R3.w, -R3, c[11].z, c[11].y;
DP3 R6.w, R8, R8;
MUL R2, fragment.texcoord[6].y, R2;
MUL R7.xyz, R5.w, c[2];
ABS R3.w, R3;
CMP R5.w, -R3, c[11].z, c[11].y;
MUL R6.xyz, R4.w, R6;
CMP R6.xyz, -R5.w, R6, R7;
DP3 R3.w, R4, R6;
MUL R4.xyz, R4, -R3.w;
RSQ R6.w, R6.w;
MAD R4.xyz, -R4, c[11].x, -R6;
MUL R7.xyz, R6.w, R8;
DP3 R4.x, R4, R7;
MAX R4.x, R4, c[11].z;
POW R6.w, R4.x, c[6].x;
CMP R4.x, -R5.w, R4.w, c[11].y;
SLT R4.w, R3, c[11].z;
MUL R4.xyz, R4.x, c[10];
MUL R6.xyz, R4, c[5];
ABS R4.w, R4;
CMP R5.w, -R4, c[11].z, c[11].y;
DP3 R4.w, R5, fragment.texcoord[1];
ABS_SAT R4.w, R4;
ADD R4.w, -R4, c[11].y;
POW R4.w, R4.w, c[9].x;
MUL R6.xyz, R6, R6.w;
MAX R3.w, R3, c[11].z;
MUL R4.w, R4, c[8].x;
MUL R4.xyz, R4, c[3];
MAD R1, R1, fragment.texcoord[6].x, R2;
TEX R0, R5, texture[1], CUBE;
CMP R5.xyz, -R5.w, R6, c[11].z;
MUL R6.xyz, R5, c[7].x;
MOV R5.xyz, c[3];
MAD R5.xyz, R5, c[0], fragment.texcoord[2];
MAD_SAT R4.xyz, R4, R3.w, R5;
ADD_SAT R3.w, R4, c[4].x;
MUL R0.xyz, R0, R3.w;
MAD R3.xyz, R3, R4, R6;
MOV R3.w, c[11].y;
ADD R3, R0, R3;
MAD R0, R4.w, R0, R3;
ADD result.color, R0, R1;
END
# 60 instructions, 9 R-regs
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
Float 8 [_FrezPow]
Float 9 [_FrezFalloff]
Vector 10 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_EnvSide] 2D
SetTexture 3 [_EnvTop] 2D
"ps_2_0
; 64 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c11, 2.00000000, 1.00000000, 0.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4.xyz
dcl t5
dcl t6.xy
texld r5, t5, s2
texld r7, t3, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r9.xyz, r0.x, t1
dp3_pp r0.x, r9, t4
mul_pp r0.xyz, r9, r0.x
mad_pp r8.xyz, -r0, c11.x, t4
add r2.xyz, -t0, c2
add r10.xyz, -t0, c1
mov r0.y, t5.w
mov r0.x, t5.z
texld r4, r0, s3
texld r6, r8, s1
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r3.xyz, r1.x, r2
dp3_pp r2.x, c2, c2
rsq_pp r2.x, r2.x
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c11.y, c11.z
mul_pp r11.xyz, r2.x, c2
abs_pp r2.x, r0
cmp_pp r11.xyz, -r2.x, r3, r11
dp3_pp r0.x, r9, r11
mul_pp r9.xyz, r9, -r0.x
dp3 r3.x, r10, r10
rsq r3.x, r3.x
mul r3.xyz, r3.x, r10
cmp_pp r1.x, -r2, r1, c11.y
mul_pp r10.xyz, r1.x, c10
mad_pp r9.xyz, -r9, c11.x, -r11
dp3_pp r3.x, r9, r3
max_pp r3.x, r3, c11.z
pow_pp r9.w, r3.x, c6.x
mov_pp r1.x, r9.w
mul_pp r2.xyz, r10, c5
mul_pp r9.xyz, r2, r1.x
cmp_pp r1.x, r0, c11.z, c11.y
dp3_pp r2.x, r8, t1
abs_pp r3.x, r1
abs_pp_sat r1.x, r2
cmp_pp r2.xyz, -r3.x, r9, c11.z
mul_pp r3.xyz, r2, c7.x
add_pp r1.x, -r1, c11.y
pow_pp r2.w, r1.x, c9.x
max_pp r1.x, r0, c11.z
mov_pp r0.x, r2.w
mov_pp r8.xyz, c0
mad_pp r2.xyz, c3, r8, t2
mul_pp r8.xyz, r10, c3
mad_pp_sat r1.xyz, r8, r1.x, r2
mad_pp r2.xyz, r7, r1, r3
mul_pp r0.x, r0, c8
add_pp_sat r1.x, r0, c4
mul_pp r3, t6.y, r4
mul_pp r1.xyz, r6, r1.x
mov_pp r1.w, r6
mov_pp r2.w, c11.y
add_pp r2, r1, r2
mad_pp r3, r5, t6.x, r3
mad_pp r0, r0.x, r1, r2
add_pp r0, r0, r3
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
Float 8 [_FrezPow]
Float 9 [_FrezFalloff]
Vector 10 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_EnvSide] 2D
SetTexture 3 [_EnvTop] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 60 ALU, 4 TEX
PARAM c[12] = { state.lightmodel.ambient,
		program.local[1..10],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEX R2, fragment.texcoord[5].zwzw, texture[3], 2D;
TEX R1, fragment.texcoord[5], texture[2], 2D;
TEX R3.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R6.xyz, -fragment.texcoord[0], c[2];
DP3 R3.w, R6, R6;
RSQ R4.w, R3.w;
ADD R8.xyz, -fragment.texcoord[0], c[1];
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R4, fragment.texcoord[4];
MUL R0.xyz, R4, R0.x;
MAD R5.xyz, -R0, c[11].x, fragment.texcoord[4];
ABS R3.w, -c[2];
DP3 R5.w, c[2], c[2];
RSQ R5.w, R5.w;
CMP R3.w, -R3, c[11].z, c[11].y;
DP3 R6.w, R8, R8;
MUL R2, fragment.texcoord[6].y, R2;
MUL R7.xyz, R5.w, c[2];
ABS R3.w, R3;
CMP R5.w, -R3, c[11].z, c[11].y;
MUL R6.xyz, R4.w, R6;
CMP R6.xyz, -R5.w, R6, R7;
DP3 R3.w, R4, R6;
MUL R4.xyz, R4, -R3.w;
RSQ R6.w, R6.w;
MAD R4.xyz, -R4, c[11].x, -R6;
MUL R7.xyz, R6.w, R8;
DP3 R4.x, R4, R7;
MAX R4.x, R4, c[11].z;
POW R6.w, R4.x, c[6].x;
CMP R4.x, -R5.w, R4.w, c[11].y;
SLT R4.w, R3, c[11].z;
MUL R4.xyz, R4.x, c[10];
MUL R6.xyz, R4, c[5];
ABS R4.w, R4;
CMP R5.w, -R4, c[11].z, c[11].y;
DP3 R4.w, R5, fragment.texcoord[1];
ABS_SAT R4.w, R4;
ADD R4.w, -R4, c[11].y;
POW R4.w, R4.w, c[9].x;
MUL R6.xyz, R6, R6.w;
MAX R3.w, R3, c[11].z;
MUL R4.w, R4, c[8].x;
MUL R4.xyz, R4, c[3];
MAD R1, R1, fragment.texcoord[6].x, R2;
TEX R0, R5, texture[1], CUBE;
CMP R5.xyz, -R5.w, R6, c[11].z;
MUL R6.xyz, R5, c[7].x;
MOV R5.xyz, c[3];
MAD R5.xyz, R5, c[0], fragment.texcoord[2];
MAD_SAT R4.xyz, R4, R3.w, R5;
ADD_SAT R3.w, R4, c[4].x;
MUL R0.xyz, R0, R3.w;
MAD R3.xyz, R3, R4, R6;
MOV R3.w, c[11].y;
ADD R3, R0, R3;
MAD R0, R4.w, R0, R3;
ADD result.color, R0, R1;
END
# 60 instructions, 9 R-regs
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
Float 8 [_FrezPow]
Float 9 [_FrezFalloff]
Vector 10 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_EnvSide] 2D
SetTexture 3 [_EnvTop] 2D
"ps_2_0
; 64 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c11, 2.00000000, 1.00000000, 0.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4.xyz
dcl t5
dcl t6.xy
texld r5, t5, s2
texld r7, t3, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r9.xyz, r0.x, t1
dp3_pp r0.x, r9, t4
mul_pp r0.xyz, r9, r0.x
mad_pp r8.xyz, -r0, c11.x, t4
add r2.xyz, -t0, c2
add r10.xyz, -t0, c1
mov r0.y, t5.w
mov r0.x, t5.z
texld r4, r0, s3
texld r6, r8, s1
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r3.xyz, r1.x, r2
dp3_pp r2.x, c2, c2
rsq_pp r2.x, r2.x
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c11.y, c11.z
mul_pp r11.xyz, r2.x, c2
abs_pp r2.x, r0
cmp_pp r11.xyz, -r2.x, r3, r11
dp3_pp r0.x, r9, r11
mul_pp r9.xyz, r9, -r0.x
dp3 r3.x, r10, r10
rsq r3.x, r3.x
mul r3.xyz, r3.x, r10
cmp_pp r1.x, -r2, r1, c11.y
mul_pp r10.xyz, r1.x, c10
mad_pp r9.xyz, -r9, c11.x, -r11
dp3_pp r3.x, r9, r3
max_pp r3.x, r3, c11.z
pow_pp r9.w, r3.x, c6.x
mov_pp r1.x, r9.w
mul_pp r2.xyz, r10, c5
mul_pp r9.xyz, r2, r1.x
cmp_pp r1.x, r0, c11.z, c11.y
dp3_pp r2.x, r8, t1
abs_pp r3.x, r1
abs_pp_sat r1.x, r2
cmp_pp r2.xyz, -r3.x, r9, c11.z
mul_pp r3.xyz, r2, c7.x
add_pp r1.x, -r1, c11.y
pow_pp r2.w, r1.x, c9.x
max_pp r1.x, r0, c11.z
mov_pp r0.x, r2.w
mov_pp r8.xyz, c0
mad_pp r2.xyz, c3, r8, t2
mul_pp r8.xyz, r10, c3
mad_pp_sat r1.xyz, r8, r1.x, r2
mad_pp r2.xyz, r7, r1, r3
mul_pp r0.x, r0, c8
add_pp_sat r1.x, r0, c4
mul_pp r3, t6.y, r4
mul_pp r1.xyz, r6, r1.x
mov_pp r1.w, r6
mov_pp r2.w, c11.y
add_pp r2, r1, r2
mad_pp r3, r5, t6.x, r3
mad_pp r0, r0.x, r1, r2
add_pp r0, r0, r3
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
Float 8 [_FrezPow]
Float 9 [_FrezFalloff]
Vector 10 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_EnvSide] 2D
SetTexture 3 [_EnvTop] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 60 ALU, 4 TEX
PARAM c[12] = { state.lightmodel.ambient,
		program.local[1..10],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEX R2, fragment.texcoord[5].zwzw, texture[3], 2D;
TEX R1, fragment.texcoord[5], texture[2], 2D;
TEX R3.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R6.xyz, -fragment.texcoord[0], c[2];
DP3 R3.w, R6, R6;
RSQ R4.w, R3.w;
ADD R8.xyz, -fragment.texcoord[0], c[1];
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R4, fragment.texcoord[4];
MUL R0.xyz, R4, R0.x;
MAD R5.xyz, -R0, c[11].x, fragment.texcoord[4];
ABS R3.w, -c[2];
DP3 R5.w, c[2], c[2];
RSQ R5.w, R5.w;
CMP R3.w, -R3, c[11].z, c[11].y;
DP3 R6.w, R8, R8;
MUL R2, fragment.texcoord[6].y, R2;
MUL R7.xyz, R5.w, c[2];
ABS R3.w, R3;
CMP R5.w, -R3, c[11].z, c[11].y;
MUL R6.xyz, R4.w, R6;
CMP R6.xyz, -R5.w, R6, R7;
DP3 R3.w, R4, R6;
MUL R4.xyz, R4, -R3.w;
RSQ R6.w, R6.w;
MAD R4.xyz, -R4, c[11].x, -R6;
MUL R7.xyz, R6.w, R8;
DP3 R4.x, R4, R7;
MAX R4.x, R4, c[11].z;
POW R6.w, R4.x, c[6].x;
CMP R4.x, -R5.w, R4.w, c[11].y;
SLT R4.w, R3, c[11].z;
MUL R4.xyz, R4.x, c[10];
MUL R6.xyz, R4, c[5];
ABS R4.w, R4;
CMP R5.w, -R4, c[11].z, c[11].y;
DP3 R4.w, R5, fragment.texcoord[1];
ABS_SAT R4.w, R4;
ADD R4.w, -R4, c[11].y;
POW R4.w, R4.w, c[9].x;
MUL R6.xyz, R6, R6.w;
MAX R3.w, R3, c[11].z;
MUL R4.w, R4, c[8].x;
MUL R4.xyz, R4, c[3];
MAD R1, R1, fragment.texcoord[6].x, R2;
TEX R0, R5, texture[1], CUBE;
CMP R5.xyz, -R5.w, R6, c[11].z;
MUL R6.xyz, R5, c[7].x;
MOV R5.xyz, c[3];
MAD R5.xyz, R5, c[0], fragment.texcoord[2];
MAD_SAT R4.xyz, R4, R3.w, R5;
ADD_SAT R3.w, R4, c[4].x;
MUL R0.xyz, R0, R3.w;
MAD R3.xyz, R3, R4, R6;
MOV R3.w, c[11].y;
ADD R3, R0, R3;
MAD R0, R4.w, R0, R3;
ADD result.color, R0, R1;
END
# 60 instructions, 9 R-regs
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
Float 8 [_FrezPow]
Float 9 [_FrezFalloff]
Vector 10 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_EnvSide] 2D
SetTexture 3 [_EnvTop] 2D
"ps_2_0
; 64 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c11, 2.00000000, 1.00000000, 0.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4.xyz
dcl t5
dcl t6.xy
texld r5, t5, s2
texld r7, t3, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r9.xyz, r0.x, t1
dp3_pp r0.x, r9, t4
mul_pp r0.xyz, r9, r0.x
mad_pp r8.xyz, -r0, c11.x, t4
add r2.xyz, -t0, c2
add r10.xyz, -t0, c1
mov r0.y, t5.w
mov r0.x, t5.z
texld r4, r0, s3
texld r6, r8, s1
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r3.xyz, r1.x, r2
dp3_pp r2.x, c2, c2
rsq_pp r2.x, r2.x
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c11.y, c11.z
mul_pp r11.xyz, r2.x, c2
abs_pp r2.x, r0
cmp_pp r11.xyz, -r2.x, r3, r11
dp3_pp r0.x, r9, r11
mul_pp r9.xyz, r9, -r0.x
dp3 r3.x, r10, r10
rsq r3.x, r3.x
mul r3.xyz, r3.x, r10
cmp_pp r1.x, -r2, r1, c11.y
mul_pp r10.xyz, r1.x, c10
mad_pp r9.xyz, -r9, c11.x, -r11
dp3_pp r3.x, r9, r3
max_pp r3.x, r3, c11.z
pow_pp r9.w, r3.x, c6.x
mov_pp r1.x, r9.w
mul_pp r2.xyz, r10, c5
mul_pp r9.xyz, r2, r1.x
cmp_pp r1.x, r0, c11.z, c11.y
dp3_pp r2.x, r8, t1
abs_pp r3.x, r1
abs_pp_sat r1.x, r2
cmp_pp r2.xyz, -r3.x, r9, c11.z
mul_pp r3.xyz, r2, c7.x
add_pp r1.x, -r1, c11.y
pow_pp r2.w, r1.x, c9.x
max_pp r1.x, r0, c11.z
mov_pp r0.x, r2.w
mov_pp r8.xyz, c0
mad_pp r2.xyz, c3, r8, t2
mul_pp r8.xyz, r10, c3
mad_pp_sat r1.xyz, r8, r1.x, r2
mad_pp r2.xyz, r7, r1, r3
mul_pp r0.x, r0, c8
add_pp_sat r1.x, r0, c4
mul_pp r3, t6.y, r4
mul_pp r1.xyz, r6, r1.x
mov_pp r1.w, r6
mov_pp r2.w, c11.y
add_pp r2, r1, r2
mad_pp r3, r5, t6.x, r3
mad_pp r0, r0.x, r1, r2
add_pp r0, r0, r3
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
Float 8 [_FrezPow]
Float 9 [_FrezFalloff]
Vector 10 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_EnvSide] 2D
SetTexture 3 [_EnvTop] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 60 ALU, 4 TEX
PARAM c[12] = { state.lightmodel.ambient,
		program.local[1..10],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEX R2, fragment.texcoord[5].zwzw, texture[3], 2D;
TEX R1, fragment.texcoord[5], texture[2], 2D;
TEX R3.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R6.xyz, -fragment.texcoord[0], c[2];
DP3 R3.w, R6, R6;
RSQ R4.w, R3.w;
ADD R8.xyz, -fragment.texcoord[0], c[1];
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R4, fragment.texcoord[4];
MUL R0.xyz, R4, R0.x;
MAD R5.xyz, -R0, c[11].x, fragment.texcoord[4];
ABS R3.w, -c[2];
DP3 R5.w, c[2], c[2];
RSQ R5.w, R5.w;
CMP R3.w, -R3, c[11].z, c[11].y;
DP3 R6.w, R8, R8;
MUL R2, fragment.texcoord[6].y, R2;
MUL R7.xyz, R5.w, c[2];
ABS R3.w, R3;
CMP R5.w, -R3, c[11].z, c[11].y;
MUL R6.xyz, R4.w, R6;
CMP R6.xyz, -R5.w, R6, R7;
DP3 R3.w, R4, R6;
MUL R4.xyz, R4, -R3.w;
RSQ R6.w, R6.w;
MAD R4.xyz, -R4, c[11].x, -R6;
MUL R7.xyz, R6.w, R8;
DP3 R4.x, R4, R7;
MAX R4.x, R4, c[11].z;
POW R6.w, R4.x, c[6].x;
CMP R4.x, -R5.w, R4.w, c[11].y;
SLT R4.w, R3, c[11].z;
MUL R4.xyz, R4.x, c[10];
MUL R6.xyz, R4, c[5];
ABS R4.w, R4;
CMP R5.w, -R4, c[11].z, c[11].y;
DP3 R4.w, R5, fragment.texcoord[1];
ABS_SAT R4.w, R4;
ADD R4.w, -R4, c[11].y;
POW R4.w, R4.w, c[9].x;
MUL R6.xyz, R6, R6.w;
MAX R3.w, R3, c[11].z;
MUL R4.w, R4, c[8].x;
MUL R4.xyz, R4, c[3];
MAD R1, R1, fragment.texcoord[6].x, R2;
TEX R0, R5, texture[1], CUBE;
CMP R5.xyz, -R5.w, R6, c[11].z;
MUL R6.xyz, R5, c[7].x;
MOV R5.xyz, c[3];
MAD R5.xyz, R5, c[0], fragment.texcoord[2];
MAD_SAT R4.xyz, R4, R3.w, R5;
ADD_SAT R3.w, R4, c[4].x;
MUL R0.xyz, R0, R3.w;
MAD R3.xyz, R3, R4, R6;
MOV R3.w, c[11].y;
ADD R3, R0, R3;
MAD R0, R4.w, R0, R3;
ADD result.color, R0, R1;
END
# 60 instructions, 9 R-regs
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
Float 8 [_FrezPow]
Float 9 [_FrezFalloff]
Vector 10 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_EnvSide] 2D
SetTexture 3 [_EnvTop] 2D
"ps_2_0
; 64 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c11, 2.00000000, 1.00000000, 0.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4.xyz
dcl t5
dcl t6.xy
texld r5, t5, s2
texld r7, t3, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r9.xyz, r0.x, t1
dp3_pp r0.x, r9, t4
mul_pp r0.xyz, r9, r0.x
mad_pp r8.xyz, -r0, c11.x, t4
add r2.xyz, -t0, c2
add r10.xyz, -t0, c1
mov r0.y, t5.w
mov r0.x, t5.z
texld r4, r0, s3
texld r6, r8, s1
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r3.xyz, r1.x, r2
dp3_pp r2.x, c2, c2
rsq_pp r2.x, r2.x
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c11.y, c11.z
mul_pp r11.xyz, r2.x, c2
abs_pp r2.x, r0
cmp_pp r11.xyz, -r2.x, r3, r11
dp3_pp r0.x, r9, r11
mul_pp r9.xyz, r9, -r0.x
dp3 r3.x, r10, r10
rsq r3.x, r3.x
mul r3.xyz, r3.x, r10
cmp_pp r1.x, -r2, r1, c11.y
mul_pp r10.xyz, r1.x, c10
mad_pp r9.xyz, -r9, c11.x, -r11
dp3_pp r3.x, r9, r3
max_pp r3.x, r3, c11.z
pow_pp r9.w, r3.x, c6.x
mov_pp r1.x, r9.w
mul_pp r2.xyz, r10, c5
mul_pp r9.xyz, r2, r1.x
cmp_pp r1.x, r0, c11.z, c11.y
dp3_pp r2.x, r8, t1
abs_pp r3.x, r1
abs_pp_sat r1.x, r2
cmp_pp r2.xyz, -r3.x, r9, c11.z
mul_pp r3.xyz, r2, c7.x
add_pp r1.x, -r1, c11.y
pow_pp r2.w, r1.x, c9.x
max_pp r1.x, r0, c11.z
mov_pp r0.x, r2.w
mov_pp r8.xyz, c0
mad_pp r2.xyz, c3, r8, t2
mul_pp r8.xyz, r10, c3
mad_pp_sat r1.xyz, r8, r1.x, r2
mad_pp r2.xyz, r7, r1, r3
mul_pp r0.x, r0, c8
add_pp_sat r1.x, r0, c4
mul_pp r3, t6.y, r4
mul_pp r1.xyz, r6, r1.x
mov_pp r1.w, r6
mov_pp r2.w, c11.y
add_pp r2, r1, r2
mad_pp r3, r5, t6.x, r3
mad_pp r0, r0.x, r1, r2
add_pp r0, r0, r3
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
Float 8 [_FrezPow]
Float 9 [_FrezFalloff]
Vector 10 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_EnvSide] 2D
SetTexture 3 [_EnvTop] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 60 ALU, 4 TEX
PARAM c[12] = { state.lightmodel.ambient,
		program.local[1..10],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
TEMP R7;
TEMP R8;
TEX R2, fragment.texcoord[5].zwzw, texture[3], 2D;
TEX R1, fragment.texcoord[5], texture[2], 2D;
TEX R3.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R6.xyz, -fragment.texcoord[0], c[2];
DP3 R3.w, R6, R6;
RSQ R4.w, R3.w;
ADD R8.xyz, -fragment.texcoord[0], c[1];
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R4.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R4, fragment.texcoord[4];
MUL R0.xyz, R4, R0.x;
MAD R5.xyz, -R0, c[11].x, fragment.texcoord[4];
ABS R3.w, -c[2];
DP3 R5.w, c[2], c[2];
RSQ R5.w, R5.w;
CMP R3.w, -R3, c[11].z, c[11].y;
DP3 R6.w, R8, R8;
MUL R2, fragment.texcoord[6].y, R2;
MUL R7.xyz, R5.w, c[2];
ABS R3.w, R3;
CMP R5.w, -R3, c[11].z, c[11].y;
MUL R6.xyz, R4.w, R6;
CMP R6.xyz, -R5.w, R6, R7;
DP3 R3.w, R4, R6;
MUL R4.xyz, R4, -R3.w;
RSQ R6.w, R6.w;
MAD R4.xyz, -R4, c[11].x, -R6;
MUL R7.xyz, R6.w, R8;
DP3 R4.x, R4, R7;
MAX R4.x, R4, c[11].z;
POW R6.w, R4.x, c[6].x;
CMP R4.x, -R5.w, R4.w, c[11].y;
SLT R4.w, R3, c[11].z;
MUL R4.xyz, R4.x, c[10];
MUL R6.xyz, R4, c[5];
ABS R4.w, R4;
CMP R5.w, -R4, c[11].z, c[11].y;
DP3 R4.w, R5, fragment.texcoord[1];
ABS_SAT R4.w, R4;
ADD R4.w, -R4, c[11].y;
POW R4.w, R4.w, c[9].x;
MUL R6.xyz, R6, R6.w;
MAX R3.w, R3, c[11].z;
MUL R4.w, R4, c[8].x;
MUL R4.xyz, R4, c[3];
MAD R1, R1, fragment.texcoord[6].x, R2;
TEX R0, R5, texture[1], CUBE;
CMP R5.xyz, -R5.w, R6, c[11].z;
MUL R6.xyz, R5, c[7].x;
MOV R5.xyz, c[3];
MAD R5.xyz, R5, c[0], fragment.texcoord[2];
MAD_SAT R4.xyz, R4, R3.w, R5;
ADD_SAT R3.w, R4, c[4].x;
MUL R0.xyz, R0, R3.w;
MAD R3.xyz, R3, R4, R6;
MOV R3.w, c[11].y;
ADD R3, R0, R3;
MAD R0, R4.w, R0, R3;
ADD result.color, R0, R1;
END
# 60 instructions, 9 R-regs
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
Float 8 [_FrezPow]
Float 9 [_FrezFalloff]
Vector 10 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_EnvSide] 2D
SetTexture 3 [_EnvTop] 2D
"ps_2_0
; 64 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c11, 2.00000000, 1.00000000, 0.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xy
dcl t4.xyz
dcl t5
dcl t6.xy
texld r5, t5, s2
texld r7, t3, s0
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r9.xyz, r0.x, t1
dp3_pp r0.x, r9, t4
mul_pp r0.xyz, r9, r0.x
mad_pp r8.xyz, -r0, c11.x, t4
add r2.xyz, -t0, c2
add r10.xyz, -t0, c1
mov r0.y, t5.w
mov r0.x, t5.z
texld r4, r0, s3
texld r6, r8, s1
dp3_pp r0.x, r2, r2
rsq_pp r1.x, r0.x
mul_pp r3.xyz, r1.x, r2
dp3_pp r2.x, c2, c2
rsq_pp r2.x, r2.x
abs_pp r0.x, -c2.w
cmp_pp r0.x, -r0, c11.y, c11.z
mul_pp r11.xyz, r2.x, c2
abs_pp r2.x, r0
cmp_pp r11.xyz, -r2.x, r3, r11
dp3_pp r0.x, r9, r11
mul_pp r9.xyz, r9, -r0.x
dp3 r3.x, r10, r10
rsq r3.x, r3.x
mul r3.xyz, r3.x, r10
cmp_pp r1.x, -r2, r1, c11.y
mul_pp r10.xyz, r1.x, c10
mad_pp r9.xyz, -r9, c11.x, -r11
dp3_pp r3.x, r9, r3
max_pp r3.x, r3, c11.z
pow_pp r9.w, r3.x, c6.x
mov_pp r1.x, r9.w
mul_pp r2.xyz, r10, c5
mul_pp r9.xyz, r2, r1.x
cmp_pp r1.x, r0, c11.z, c11.y
dp3_pp r2.x, r8, t1
abs_pp r3.x, r1
abs_pp_sat r1.x, r2
cmp_pp r2.xyz, -r3.x, r9, c11.z
mul_pp r3.xyz, r2, c7.x
add_pp r1.x, -r1, c11.y
pow_pp r2.w, r1.x, c9.x
max_pp r1.x, r0, c11.z
mov_pp r0.x, r2.w
mov_pp r8.xyz, c0
mad_pp r2.xyz, c3, r8, t2
mul_pp r8.xyz, r10, c3
mad_pp_sat r1.xyz, r8, r1.x, r2
mad_pp r2.xyz, r7, r1, r3
mul_pp r0.x, r0, c8
add_pp_sat r1.x, r0, c4
mul_pp r3, t6.y, r4
mul_pp r1.xyz, r6, r1.x
mov_pp r1.w, r6
mov_pp r2.w, c11.y
add_pp r2, r1, r2
mad_pp r3, r5, t6.x, r3
mad_pp r0, r0.x, r1, r2
add_pp r0, r0, r3
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

#LINE 249

      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Mobile/Diffuse"
}