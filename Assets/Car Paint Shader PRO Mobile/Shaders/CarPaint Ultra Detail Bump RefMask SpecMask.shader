//same like HIGH + self shadow enabled

Shader "RedDotGames/Mobile/Car Paint Ultra Detail Bump RefMask SpecMask" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _Shininess ("Shininess", Range (0.01, 10)) = 1
	  _Gloss ("Gloss", Range (0.0, 10)) = 1
	  _MainTex ("Texture(RGB) Mask (A)", 2D) = "white" {} 
	  _BumpMap ("Normalmap", 2D) = "bump" {}
	  _Cube("Reflection Map", Cube) = "" {}
	  _Reflection("Reflection Power", Range (0.00, 1)) = 0
	  _FrezPow("Fresnel Power",Range(0,2)) = .25
	  _FrezFalloff("Fresnal Falloff",Range(0,10)) = 4	  
	  
	  _SparkleTex ("Sparkle Texture", 2D) = "white" {} 

	  _FlakeScale ("Flake Scale", float) = 1
	  _FlakePower ("Flake Alpha",Range(0,1)) = 0

	  _OuterFlakePower ("Flake Outer Power",Range(1,16)) = 2

	  _paintColor2 ("Outer Flake Color (RGB)", Color) = (1,1,1,1) 

	  
   }
SubShader {
   Tags { "QUEUE"="Geometry" "RenderType"="Opaque" " IgnoreProjector"="True"}	  
      Pass {  
      
         Tags { "LightMode" = "ForwardBase" } // pass for 
            // 4 vertex lights, ambient light & first pixel light
 
         Program "vp" {
// Vertex combos: 8
//   opengl - ALU: 35 to 40
//   d3d9 - ALU: 35 to 40
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 35 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c13.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c13.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c13.x
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((_Object2World * tmpvar_11).xyz);
  tmpvar_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_1;
  highp vec3 tmpvar_14;
  tmpvar_14 = (_Object2World * tmpvar_13).xyz;
  tmpvar_5 = tmpvar_14;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
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
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_2;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + ((paintColor * _FlakePower) * tmpvar_8.w));
  color = tmpvar_27;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_25 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((_Object2World * tmpvar_11).xyz);
  tmpvar_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_1;
  highp vec3 tmpvar_14;
  tmpvar_14 = (_Object2World * tmpvar_13).xyz;
  tmpvar_5 = tmpvar_14;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
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
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_2;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + ((paintColor * _FlakePower) * tmpvar_8.w));
  color = tmpvar_27;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_25 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 35 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c13.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c13.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c13.x
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((_Object2World * tmpvar_11).xyz);
  tmpvar_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_1;
  highp vec3 tmpvar_14;
  tmpvar_14 = (_Object2World * tmpvar_13).xyz;
  tmpvar_5 = tmpvar_14;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
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
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_2;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + ((paintColor * _FlakePower) * tmpvar_8.w));
  color = tmpvar_27;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_25 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((_Object2World * tmpvar_11).xyz);
  tmpvar_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_1;
  highp vec3 tmpvar_14;
  tmpvar_14 = (_Object2World * tmpvar_13).xyz;
  tmpvar_5 = tmpvar_14;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
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
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_2;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + ((paintColor * _FlakePower) * tmpvar_8.w));
  color = tmpvar_27;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_25 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 35 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c13.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c13.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c13.x
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((_Object2World * tmpvar_11).xyz);
  tmpvar_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_1;
  highp vec3 tmpvar_14;
  tmpvar_14 = (_Object2World * tmpvar_13).xyz;
  tmpvar_5 = tmpvar_14;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
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
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_2;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + ((paintColor * _FlakePower) * tmpvar_8.w));
  color = tmpvar_27;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_25 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((_Object2World * tmpvar_11).xyz);
  tmpvar_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_1;
  highp vec3 tmpvar_14;
  tmpvar_14 = (_Object2World * tmpvar_13).xyz;
  tmpvar_5 = tmpvar_14;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
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
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_2;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + ((paintColor * _FlakePower) * tmpvar_8.w));
  color = tmpvar_27;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_25 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 40 ALU
PARAM c[15] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[7].xy, R1, R1.z;
ADD R1.xyz, R0, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 40 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c15.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o8.xy, r1.z, c13.zwzw, r1
add r1.xyz, r0, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c15.x
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_6 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_5 = tmpvar_15;
  highp vec4 o_i0;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_16;
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16.x;
  tmpvar_17.y = (tmpvar_16.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_17 + tmpvar_16.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = o_i0;
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (((tmpvar_10.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (((tmpvar_10.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_14;
  };
  mediump vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_15;
  lowp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_2;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  lowp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_20;
  tmpvar_20 = (tmpvar_19 * tmpvar_19);
  mediump vec4 tmpvar_21;
  tmpvar_21 = (pow (tmpvar_20, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = (paintColor * tmpvar_10.x);
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (tmpvar_24.xyz * clamp (((_Reflection + tmpvar_27) * tmpvar_10.x), 0.0, 1.0));
  lowp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_28 + ((tmpvar_22 * _FlakePower) * tmpvar_8.w));
  color = tmpvar_29;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_27 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_6 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_5 = tmpvar_15;
  highp vec4 o_i0;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_16;
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16.x;
  tmpvar_17.y = (tmpvar_16.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_17 + tmpvar_16.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = o_i0;
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (((tmpvar_10.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (((tmpvar_10.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_14;
  };
  mediump vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_15;
  lowp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_2;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  lowp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_20;
  tmpvar_20 = (tmpvar_19 * tmpvar_19);
  mediump vec4 tmpvar_21;
  tmpvar_21 = (pow (tmpvar_20, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = (paintColor * tmpvar_10.x);
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (tmpvar_24.xyz * clamp (((_Reflection + tmpvar_27) * tmpvar_10.x), 0.0, 1.0));
  lowp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_28 + ((tmpvar_22 * _FlakePower) * tmpvar_8.w));
  color = tmpvar_29;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_27 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 40 ALU
PARAM c[15] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[7].xy, R1, R1.z;
ADD R1.xyz, R0, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 40 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c15.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o8.xy, r1.z, c13.zwzw, r1
add r1.xyz, r0, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c15.x
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_6 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_5 = tmpvar_15;
  highp vec4 o_i0;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_16;
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16.x;
  tmpvar_17.y = (tmpvar_16.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_17 + tmpvar_16.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = o_i0;
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (((tmpvar_10.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (((tmpvar_10.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_14;
  };
  mediump vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_15;
  lowp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_2;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  lowp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_20;
  tmpvar_20 = (tmpvar_19 * tmpvar_19);
  mediump vec4 tmpvar_21;
  tmpvar_21 = (pow (tmpvar_20, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = (paintColor * tmpvar_10.x);
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (tmpvar_24.xyz * clamp (((_Reflection + tmpvar_27) * tmpvar_10.x), 0.0, 1.0));
  lowp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_28 + ((tmpvar_22 * _FlakePower) * tmpvar_8.w));
  color = tmpvar_29;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_27 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_6 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_5 = tmpvar_15;
  highp vec4 o_i0;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_16;
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16.x;
  tmpvar_17.y = (tmpvar_16.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_17 + tmpvar_16.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = o_i0;
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (((tmpvar_10.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (((tmpvar_10.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_14;
  };
  mediump vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_15;
  lowp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_2;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  lowp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_20;
  tmpvar_20 = (tmpvar_19 * tmpvar_19);
  mediump vec4 tmpvar_21;
  tmpvar_21 = (pow (tmpvar_20, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = (paintColor * tmpvar_10.x);
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (tmpvar_24.xyz * clamp (((_Reflection + tmpvar_27) * tmpvar_10.x), 0.0, 1.0));
  lowp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_28 + ((tmpvar_22 * _FlakePower) * tmpvar_8.w));
  color = tmpvar_29;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_27 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 40 ALU
PARAM c[15] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[7].xy, R1, R1.z;
ADD R1.xyz, R0, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 40 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c15.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o8.xy, r1.z, c13.zwzw, r1
add r1.xyz, r0, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c15.x
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_6 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_5 = tmpvar_15;
  highp vec4 o_i0;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_16;
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16.x;
  tmpvar_17.y = (tmpvar_16.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_17 + tmpvar_16.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = o_i0;
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (((tmpvar_10.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (((tmpvar_10.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_14;
  };
  mediump vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_15;
  lowp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_2;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  lowp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_20;
  tmpvar_20 = (tmpvar_19 * tmpvar_19);
  mediump vec4 tmpvar_21;
  tmpvar_21 = (pow (tmpvar_20, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = (paintColor * tmpvar_10.x);
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (tmpvar_24.xyz * clamp (((_Reflection + tmpvar_27) * tmpvar_10.x), 0.0, 1.0));
  lowp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_28 + ((tmpvar_22 * _FlakePower) * tmpvar_8.w));
  color = tmpvar_29;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_27 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_6 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_5 = tmpvar_15;
  highp vec4 o_i0;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_16;
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16.x;
  tmpvar_17.y = (tmpvar_16.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_17 + tmpvar_16.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = o_i0;
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (((tmpvar_10.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (((tmpvar_10.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_14;
  };
  mediump vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_15;
  lowp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_2;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  lowp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_20;
  tmpvar_20 = (tmpvar_19 * tmpvar_19);
  mediump vec4 tmpvar_21;
  tmpvar_21 = (pow (tmpvar_20, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = (paintColor * tmpvar_10.x);
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (tmpvar_24.xyz * clamp (((_Reflection + tmpvar_27) * tmpvar_10.x), 0.0, 1.0));
  lowp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_28 + ((tmpvar_22 * _FlakePower) * tmpvar_8.w));
  color = tmpvar_29;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_27 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 35 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 35 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 35 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c13.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c13.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c13.x
mov r0.xyz, v1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c13.x
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((_Object2World * tmpvar_11).xyz);
  tmpvar_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_1;
  highp vec3 tmpvar_14;
  tmpvar_14 = (_Object2World * tmpvar_13).xyz;
  tmpvar_5 = tmpvar_14;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
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
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_2;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + ((paintColor * _FlakePower) * tmpvar_8.w));
  color = tmpvar_27;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_25 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
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

varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_10;
  tmpvar_10 = normalize (((_Object2World * _glesVertex) - tmpvar_9).xyz);
  tmpvar_4 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 0.0;
  tmpvar_11.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize ((_Object2World * tmpvar_11).xyz);
  tmpvar_6 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_1;
  highp vec3 tmpvar_14;
  tmpvar_14 = (_Object2World * tmpvar_13).xyz;
  tmpvar_5 = tmpvar_14;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
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
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_10;
  tmpvar_10 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_10;
  highp vec3 tmpvar_11;
  tmpvar_11 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_12 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_13;
    tmpvar_13 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = tmpvar_2;
  tmpvar_15[2] = xlv_TEXCOORD5;
  mat3 tmpvar_16;
  tmpvar_16[0].x = tmpvar_15[0].x;
  tmpvar_16[0].y = tmpvar_15[1].x;
  tmpvar_16[0].z = tmpvar_15[2].x;
  tmpvar_16[1].x = tmpvar_15[0].y;
  tmpvar_16[1].y = tmpvar_15[1].y;
  tmpvar_16[1].z = tmpvar_15[2].y;
  tmpvar_16[2].x = tmpvar_15[0].z;
  tmpvar_16[2].y = tmpvar_15[1].z;
  tmpvar_16[2].z = tmpvar_15[2].z;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  lowp float tmpvar_18;
  tmpvar_18 = clamp (dot (normalize ((tmpvar_17 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_19;
  tmpvar_19 = (tmpvar_18 * tmpvar_18);
  mediump vec4 tmpvar_20;
  tmpvar_20 = (pow (tmpvar_19, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_20;
  highp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + ((paintColor * _FlakePower) * tmpvar_8.w));
  color = tmpvar_27;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_25 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"3.0-!!ARBvp1.0
# 40 ALU
PARAM c[15] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
TEMP R2;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R1.y, R1, c[13].x;
ADD result.texcoord[7].xy, R1, R1.z;
ADD R1.xyz, R0, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
DP3 R1.w, R0, R0;
MUL result.texcoord[1].xyz, R0.w, R1;
RSQ R0.w, R1.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
END
# 40 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_3_0
; 40 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c15, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c15.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c15.y
mul r1.y, r1, c12.x
mad o8.xy, r1.z, c13.zwzw, r1
add r1.xyz, r0, c15.x
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
dp3 r0.w, r1, r1
rsq r0.w, r0.w
dp3 r1.w, r0, r0
mul o2.xyz, r0.w, r1
rsq r0.w, r1.w
mul o5.xyz, r0.w, r0
mov r0.w, c15.x
mov r0.xyz, v1
mov o0, r2
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c15.x
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_6 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_5 = tmpvar_15;
  highp vec4 o_i0;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_16;
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16.x;
  tmpvar_17.y = (tmpvar_16.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_17 + tmpvar_16.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = o_i0;
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (((tmpvar_10.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (((tmpvar_10.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_14;
  };
  mediump vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_15;
  lowp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_2;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  lowp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_20;
  tmpvar_20 = (tmpvar_19 * tmpvar_19);
  mediump vec4 tmpvar_21;
  tmpvar_21 = (pow (tmpvar_20, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = (paintColor * tmpvar_10.x);
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (tmpvar_24.xyz * clamp (((_Reflection + tmpvar_27) * tmpvar_10.x), 0.0, 1.0));
  lowp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_28 + ((tmpvar_22 * _FlakePower) * tmpvar_8.w));
  color = tmpvar_29;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_27 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  vec4 tmpvar_2;
  tmpvar_2.xyz = normalize (_glesTANGENT.xyz);
  tmpvar_2.w = _glesTANGENT.w;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = normalize ((tmpvar_7 * _World2Object).xyz);
  tmpvar_3 = tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_6 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_5 = tmpvar_15;
  highp vec4 o_i0;
  highp vec4 tmpvar_16;
  tmpvar_16 = (tmpvar_9 * 0.5);
  o_i0 = tmpvar_16;
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_16.x;
  tmpvar_17.y = (tmpvar_16.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_17 + tmpvar_16.w);
  o_i0.zw = tmpvar_9.zw;
  gl_Position = tmpvar_9;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = o_i0;
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform lowp float _Reflection;

uniform lowp vec4 _paintColor2;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform lowp vec4 _SpecColor;
uniform sampler2D _SparkleTex;
uniform mediump float _Shininess;
uniform sampler2D _ShadowMapTexture;
uniform mediump float _OuterFlakePower;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _Gloss;
uniform lowp float _FrezPow;
uniform mediump float _FrezFalloff;
uniform mediump float _FlakeScale;
uniform mediump float _FlakePower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform lowp vec4 _BumpMap_ST;
uniform sampler2D _BumpMap;
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp float SurfAngle;
  lowp vec4 reflTex;
  lowp vec3 reflectedDir;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  lowp vec3 diffuseReflection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  highp vec3 localCoords;
  lowp vec3 tmpvar_1;
  tmpvar_1.z = 0.0;
  tmpvar_1.xy = ((2.0 * texture2D (_BumpMap, ((_BumpMap_ST.xy * xlv_TEXCOORD3.xy) + _BumpMap_ST.zw)).wy) - vec2(1.0, 1.0));
  localCoords = tmpvar_1;
  localCoords.z = sqrt ((1.0 - dot (localCoords, localCoords)));
  lowp vec3 tmpvar_2;
  tmpvar_2 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  lowp mat3 tmpvar_3;
  tmpvar_3[0] = xlv_TEXCOORD6;
  tmpvar_3[1] = tmpvar_2;
  tmpvar_3[2] = xlv_TEXCOORD5;
  mat3 tmpvar_4;
  tmpvar_4[0].x = tmpvar_3[0].x;
  tmpvar_4[0].y = tmpvar_3[1].x;
  tmpvar_4[0].z = tmpvar_3[2].x;
  tmpvar_4[1].x = tmpvar_3[0].y;
  tmpvar_4[1].y = tmpvar_3[1].y;
  tmpvar_4[1].z = tmpvar_3[2].y;
  tmpvar_4[2].x = tmpvar_3[0].z;
  tmpvar_4[2].y = tmpvar_3[1].z;
  tmpvar_4[2].z = tmpvar_3[2].z;
  highp vec3 tmpvar_5;
  tmpvar_5 = normalize ((localCoords * tmpvar_4));
  highp vec3 tmpvar_6;
  tmpvar_6 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_6;
  mediump vec2 tmpvar_7;
  tmpvar_7 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_MainTex, tmpvar_7);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_9;
    tmpvar_9 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_9;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_11;
  tmpvar_11 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (((tmpvar_10.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_5, lightDirection)));
  diffuseReflection = tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = dot (tmpvar_5, lightDirection);
  if ((tmpvar_13 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    highp vec3 tmpvar_14;
    tmpvar_14 = (((tmpvar_10.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (max (0.0, dot (reflect (-(lightDirection), tmpvar_5), viewDirection)), _Shininess));
    specularReflection = tmpvar_14;
  };
  mediump vec3 tmpvar_15;
  tmpvar_15 = (specularReflection * (_Gloss * tmpvar_8.w));
  specularReflection = tmpvar_15;
  lowp mat3 tmpvar_16;
  tmpvar_16[0] = xlv_TEXCOORD6;
  tmpvar_16[1] = tmpvar_2;
  tmpvar_16[2] = xlv_TEXCOORD5;
  mat3 tmpvar_17;
  tmpvar_17[0].x = tmpvar_16[0].x;
  tmpvar_17[0].y = tmpvar_16[1].x;
  tmpvar_17[0].z = tmpvar_16[2].x;
  tmpvar_17[1].x = tmpvar_16[0].y;
  tmpvar_17[1].y = tmpvar_16[1].y;
  tmpvar_17[1].z = tmpvar_16[2].y;
  tmpvar_17[2].x = tmpvar_16[0].z;
  tmpvar_17[2].y = tmpvar_16[1].z;
  tmpvar_17[2].z = tmpvar_16[2].z;
  mat3 tmpvar_18;
  tmpvar_18[0].x = tmpvar_17[0].x;
  tmpvar_18[0].y = tmpvar_17[1].x;
  tmpvar_18[0].z = tmpvar_17[2].x;
  tmpvar_18[1].x = tmpvar_17[0].y;
  tmpvar_18[1].y = tmpvar_17[1].y;
  tmpvar_18[1].z = tmpvar_17[2].y;
  tmpvar_18[2].x = tmpvar_17[0].z;
  tmpvar_18[2].y = tmpvar_17[1].z;
  tmpvar_18[2].z = tmpvar_17[2].z;
  lowp float tmpvar_19;
  tmpvar_19 = clamp (dot (normalize ((tmpvar_18 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_20;
  tmpvar_20 = (tmpvar_19 * tmpvar_19);
  mediump vec4 tmpvar_21;
  tmpvar_21 = (pow (tmpvar_20, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = (paintColor * tmpvar_10.x);
  paintColor = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = reflect (xlv_TEXCOORD4, tmpvar_5);
  reflectedDir = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = textureCube (_Cube, reflectedDir);
  reflTex = tmpvar_24;
  highp float tmpvar_25;
  tmpvar_25 = clamp (abs (dot (reflectedDir, tmpvar_5)), 0.0, 1.0);
  SurfAngle = tmpvar_25;
  mediump float tmpvar_26;
  tmpvar_26 = pow ((1.0 - SurfAngle), _FrezFalloff);
  frez = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = (frez * _FrezPow);
  frez = tmpvar_27;
  reflTex.xyz = (tmpvar_24.xyz * clamp (((_Reflection + tmpvar_27) * tmpvar_10.x), 0.0, 1.0));
  lowp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((tmpvar_8.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + diffuseReflection), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_29;
  tmpvar_29 = (tmpvar_28 + ((tmpvar_22 * _FlakePower) * tmpvar_8.w));
  color = tmpvar_29;
  color = ((color + (reflTex * tmpvar_8.w)) + ((tmpvar_27 * reflTex) * tmpvar_8.w));
  color.w = 1.0;
  gl_FragData[0] = color;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 102 to 105, TEX: 4 to 5
//   d3d9 - ALU: 103 to 104, TEX: 4 to 5
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 102 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
		{ 1, 2, 0, 20 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MOV R2.xyz, fragment.texcoord[6];
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R1.yw, R0, texture[0], 2D;
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MUL R1.xy, R1.wyzw, c[16].y;
DP3 R2.w, c[2], c[2];
MAD R0.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
ADD R1.xy, R1, -c[16].x;
MOV R1.z, c[16];
DP3 R0.w, R1, R1;
MUL R2.xyz, R1.y, R0;
MAD R1.xyz, R1.x, fragment.texcoord[6], R2;
ADD R2.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
RSQ R2.w, R2.w;
ADD R0.w, -R0, c[16].x;
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
MAD R1.xyz, R0.w, fragment.texcoord[5], R1;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
ABS R1.w, -c[2];
CMP R1.w, -R1, c[16].z, c[16].x;
ABS R1.w, R1;
MUL R1.xyz, R0.w, R1;
MUL R3.xyz, R2.w, c[2];
CMP R1.w, -R1, c[16].z, c[16].x;
CMP R2.xyz, -R1.w, R2, R3;
DP3 R1.w, R1, R2;
SLT R0.w, R1, c[16].z;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
DP3 R2.w, R1, -R2;
MUL R3.xyz, R1, R2.w;
ABS R0.w, R0;
MAD R2.xyz, -R3, c[16].y, -R2;
MUL R4.xyz, R3.w, R4;
DP3 R2.x, R2, R4;
MAX R2.w, R2.x, c[16].z;
MOV R2.xyz, c[6];
POW R2.w, R2.w, c[7].x;
MUL R2.xyz, R2, c[15];
MUL R2.xyz, R2, R2.w;
CMP R0.w, -R0, c[16].z, c[16].x;
CMP R3.xyz, -R0.w, R2, c[16].z;
MOV R2.y, R0.z;
MUL R2.zw, fragment.texcoord[3].xyxy, c[9].x;
MUL R2.zw, R2, c[16].w;
TEX R4.xyz, R2.zwzw, texture[2], 2D;
MOV R0.zw, c[17].xyxy;
MAD R5.xyz, R4, c[16].y, R0.zzww;
MOV R4.y, R0;
MOV R2.x, fragment.texcoord[6].z;
MOV R2.z, fragment.texcoord[5];
DP3 R2.z, R2, -R5;
MOV R4.z, fragment.texcoord[5].y;
MOV R4.x, fragment.texcoord[6].y;
DP3 R2.y, -R5, R4;
MOV R4.y, R0.x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MOV R4.z, fragment.texcoord[5].x;
MOV R4.x, fragment.texcoord[6];
DP3 R2.x, -R5, R4;
DP3 R2.w, R2, R2;
MUL R3.w, R0, c[8].x;
MUL R5.xyz, R3, R3.w;
MOV R3.xyz, c[4];
MUL R4.xyz, R3, c[15];
MAX R1.w, R1, c[16].z;
MUL R4.xyz, R4, R1.w;
MAD R3.xyz, R3, c[0], fragment.texcoord[2];
ADD_SAT R3.xyz, R3, R4;
DP3 R1.w, R1, fragment.texcoord[4];
MAD R0.xyz, R0, R3, R5;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R2;
DP3 R2.x, fragment.texcoord[4], fragment.texcoord[4];
RSQ R2.w, R2.x;
MUL R2.xyz, R1, R1.w;
MUL R4.xyz, R2.w, fragment.texcoord[4];
MAD R2.xyz, -R2, c[16].y, fragment.texcoord[4];
DP3 R1.x, R2, R1;
DP3_SAT R1.w, R3, R4;
MUL R1.y, R1.w, R1.w;
ABS_SAT R1.x, R1;
ADD R1.w, -R1.x, c[16].x;
POW R1.y, R1.y, c[11].x;
MUL R1.xyz, R1.y, c[12];
POW R1.w, R1.w, c[14].x;
MUL R1.w, R1, c[13].x;
MUL R1.xyz, R1, c[10].x;
MAD R1.xyz, R0.w, R1, R0;
ADD_SAT R2.w, R1, c[5].x;
TEX R0.xyz, R2, texture[3], CUBE;
MUL R0.xyz, R0, R2.w;
MAD R1.xyz, R0, R0.w, R1;
MUL R0.xyz, R1.w, R0;
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[16].x;
END
# 102 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 103 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c16, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c17, 20.00000000, 2.00000000, -1.00000000, 3.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
mad_pp r0.xy, v3, c3, c3.zwzw
texld r0.yw, r0, s0
mov_pp r1.xyz, v6
mul_pp r2.xyz, v1.zxyw, r1.yzxw
mul_pp r0.xy, r0.wyzw, c16.x
mov_pp r1.xyz, v6
mad_pp r1.xyz, v1.yzxw, r1.zxyw, -r2
add r0.xy, r0, c16.y
mul r2.xyz, r0.y, r1
mov r0.z, c16
dp3 r0.z, r0, r0
add r0.z, -r0, c16.w
rsq r0.y, r0.z
mad r2.xyz, r0.x, v6, r2
rcp r0.x, r0.y
mad r2.xyz, r0.x, v5, r2
add r0.xyz, -v0, c2
dp3_pp r1.w, r0, r0
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul r2.xyz, r0.w, r2
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r1.w, r0
dp3_pp r0.w, c2, c2
rsq_pp r0.x, r0.w
add r4.xyz, -v0, c1
dp3 r1.w, r4, r4
rsq r1.w, r1.w
mul r4.xyz, r1.w, r4
abs_pp r0.w, -c2
mul_pp r0.xyz, r0.x, c2
cmp_pp r0.xyz, -r0.w, r0, r3
dp3_pp r0.w, r2, -r0
mul_pp r3.xyz, r2, r0.w
mad_pp r3.xyz, -r3, c16.x, -r0
dp3_pp r0.w, r3, r4
mov_pp r3.xyz, c15
mov_pp r4.xyz, c15
dp3 r1.w, r2, r0
max_pp r2.w, r0, c16.z
pow_pp r0, r2.w, c7.x
cmp r0.y, r1.w, c16.z, c16.w
abs_pp r2.w, r0.y
mov_pp r3.w, r0.x
mul_pp r3.xyz, c6, r3
mul_pp r3.xyz, r3, r3.w
texld r0, v3, s1
cmp_pp r3.xyz, -r2.w, r3, c16.z
mul_pp r3.w, r0, c8.x
mul_pp r5.xyz, r3, r3.w
mov_pp r3.xyz, c0
max r1.w, r1, c16.z
mul_pp r4.xyz, c4, r4
mul r4.xyz, r4, r1.w
mad_pp r3.xyz, c4, r3, v2
add_pp_sat r3.xyz, r3, r4
mul_pp r4.xy, v3, c9.x
mul_pp r4.xy, r4, c17.x
dp3_pp r1.w, r2, v4
mad_pp r3.xyz, r0, r3, r5
mul_pp r0.xyz, r2, r1.w
mad_pp r0.xyz, -r0, c16.x, v4
dp3_pp r1.w, r0, r2
texld r2.xyz, r4, s2
mad_pp r2.xyz, r2, c17.y, c17.zzww
mov r4.y, r1.z
mov r4.x, v6.z
mov r4.z, v5
dp3_pp r1.z, r4, -r2
mov r4.y, r1
mov r4.z, v5.y
mov r4.x, v6.y
dp3_pp r1.y, -r2, r4
mov r4.y, r1.x
mov r4.z, v5.x
mov r4.x, v6
dp3_pp r1.x, -r2, r4
dp3_pp r2.x, r1, r1
rsq_pp r2.w, r2.x
dp3_pp r2.y, v4, v4
rsq_pp r2.y, r2.y
mul_pp r1.xyz, r2.w, r1
mul_pp r2.xyz, r2.y, v4
dp3_pp_sat r1.y, r1, r2
abs_pp_sat r1.x, r1.w
mul_pp r2.x, r1.y, r1.y
add_pp r3.w, -r1.x, c16
pow_pp r1, r2.x, c11.x
pow_pp r2, r3.w, c14.x
mov_pp r1.w, r2.x
mul_pp r1.w, r1, c13.x
mul_pp r1.xyz, r1.x, c12
mul_pp r1.xyz, r1, c10.x
mad_pp r1.xyz, r0.w, r1, r3
add_pp_sat r2.x, r1.w, c5
texld r0.xyz, r0, s3
mul_pp r0.xyz, r0, r2.x
mad_pp r1.xyz, r0, r0.w, r1
mul_pp r0.xyz, r1.w, r0
mad_pp oC0.xyz, r0, r0.w, r1
mov_pp oC0.w, c16
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
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 102 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
		{ 1, 2, 0, 20 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MOV R2.xyz, fragment.texcoord[6];
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R1.yw, R0, texture[0], 2D;
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MUL R1.xy, R1.wyzw, c[16].y;
DP3 R2.w, c[2], c[2];
MAD R0.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
ADD R1.xy, R1, -c[16].x;
MOV R1.z, c[16];
DP3 R0.w, R1, R1;
MUL R2.xyz, R1.y, R0;
MAD R1.xyz, R1.x, fragment.texcoord[6], R2;
ADD R2.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
RSQ R2.w, R2.w;
ADD R0.w, -R0, c[16].x;
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
MAD R1.xyz, R0.w, fragment.texcoord[5], R1;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
ABS R1.w, -c[2];
CMP R1.w, -R1, c[16].z, c[16].x;
ABS R1.w, R1;
MUL R1.xyz, R0.w, R1;
MUL R3.xyz, R2.w, c[2];
CMP R1.w, -R1, c[16].z, c[16].x;
CMP R2.xyz, -R1.w, R2, R3;
DP3 R1.w, R1, R2;
SLT R0.w, R1, c[16].z;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
DP3 R2.w, R1, -R2;
MUL R3.xyz, R1, R2.w;
ABS R0.w, R0;
MAD R2.xyz, -R3, c[16].y, -R2;
MUL R4.xyz, R3.w, R4;
DP3 R2.x, R2, R4;
MAX R2.w, R2.x, c[16].z;
MOV R2.xyz, c[6];
POW R2.w, R2.w, c[7].x;
MUL R2.xyz, R2, c[15];
MUL R2.xyz, R2, R2.w;
CMP R0.w, -R0, c[16].z, c[16].x;
CMP R3.xyz, -R0.w, R2, c[16].z;
MOV R2.y, R0.z;
MUL R2.zw, fragment.texcoord[3].xyxy, c[9].x;
MUL R2.zw, R2, c[16].w;
TEX R4.xyz, R2.zwzw, texture[2], 2D;
MOV R0.zw, c[17].xyxy;
MAD R5.xyz, R4, c[16].y, R0.zzww;
MOV R4.y, R0;
MOV R2.x, fragment.texcoord[6].z;
MOV R2.z, fragment.texcoord[5];
DP3 R2.z, R2, -R5;
MOV R4.z, fragment.texcoord[5].y;
MOV R4.x, fragment.texcoord[6].y;
DP3 R2.y, -R5, R4;
MOV R4.y, R0.x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MOV R4.z, fragment.texcoord[5].x;
MOV R4.x, fragment.texcoord[6];
DP3 R2.x, -R5, R4;
DP3 R2.w, R2, R2;
MUL R3.w, R0, c[8].x;
MUL R5.xyz, R3, R3.w;
MOV R3.xyz, c[4];
MUL R4.xyz, R3, c[15];
MAX R1.w, R1, c[16].z;
MUL R4.xyz, R4, R1.w;
MAD R3.xyz, R3, c[0], fragment.texcoord[2];
ADD_SAT R3.xyz, R3, R4;
DP3 R1.w, R1, fragment.texcoord[4];
MAD R0.xyz, R0, R3, R5;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R2;
DP3 R2.x, fragment.texcoord[4], fragment.texcoord[4];
RSQ R2.w, R2.x;
MUL R2.xyz, R1, R1.w;
MUL R4.xyz, R2.w, fragment.texcoord[4];
MAD R2.xyz, -R2, c[16].y, fragment.texcoord[4];
DP3 R1.x, R2, R1;
DP3_SAT R1.w, R3, R4;
MUL R1.y, R1.w, R1.w;
ABS_SAT R1.x, R1;
ADD R1.w, -R1.x, c[16].x;
POW R1.y, R1.y, c[11].x;
MUL R1.xyz, R1.y, c[12];
POW R1.w, R1.w, c[14].x;
MUL R1.w, R1, c[13].x;
MUL R1.xyz, R1, c[10].x;
MAD R1.xyz, R0.w, R1, R0;
ADD_SAT R2.w, R1, c[5].x;
TEX R0.xyz, R2, texture[3], CUBE;
MUL R0.xyz, R0, R2.w;
MAD R1.xyz, R0, R0.w, R1;
MUL R0.xyz, R1.w, R0;
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[16].x;
END
# 102 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 103 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c16, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c17, 20.00000000, 2.00000000, -1.00000000, 3.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
mad_pp r0.xy, v3, c3, c3.zwzw
texld r0.yw, r0, s0
mov_pp r1.xyz, v6
mul_pp r2.xyz, v1.zxyw, r1.yzxw
mul_pp r0.xy, r0.wyzw, c16.x
mov_pp r1.xyz, v6
mad_pp r1.xyz, v1.yzxw, r1.zxyw, -r2
add r0.xy, r0, c16.y
mul r2.xyz, r0.y, r1
mov r0.z, c16
dp3 r0.z, r0, r0
add r0.z, -r0, c16.w
rsq r0.y, r0.z
mad r2.xyz, r0.x, v6, r2
rcp r0.x, r0.y
mad r2.xyz, r0.x, v5, r2
add r0.xyz, -v0, c2
dp3_pp r1.w, r0, r0
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul r2.xyz, r0.w, r2
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r1.w, r0
dp3_pp r0.w, c2, c2
rsq_pp r0.x, r0.w
add r4.xyz, -v0, c1
dp3 r1.w, r4, r4
rsq r1.w, r1.w
mul r4.xyz, r1.w, r4
abs_pp r0.w, -c2
mul_pp r0.xyz, r0.x, c2
cmp_pp r0.xyz, -r0.w, r0, r3
dp3_pp r0.w, r2, -r0
mul_pp r3.xyz, r2, r0.w
mad_pp r3.xyz, -r3, c16.x, -r0
dp3_pp r0.w, r3, r4
mov_pp r3.xyz, c15
mov_pp r4.xyz, c15
dp3 r1.w, r2, r0
max_pp r2.w, r0, c16.z
pow_pp r0, r2.w, c7.x
cmp r0.y, r1.w, c16.z, c16.w
abs_pp r2.w, r0.y
mov_pp r3.w, r0.x
mul_pp r3.xyz, c6, r3
mul_pp r3.xyz, r3, r3.w
texld r0, v3, s1
cmp_pp r3.xyz, -r2.w, r3, c16.z
mul_pp r3.w, r0, c8.x
mul_pp r5.xyz, r3, r3.w
mov_pp r3.xyz, c0
max r1.w, r1, c16.z
mul_pp r4.xyz, c4, r4
mul r4.xyz, r4, r1.w
mad_pp r3.xyz, c4, r3, v2
add_pp_sat r3.xyz, r3, r4
mul_pp r4.xy, v3, c9.x
mul_pp r4.xy, r4, c17.x
dp3_pp r1.w, r2, v4
mad_pp r3.xyz, r0, r3, r5
mul_pp r0.xyz, r2, r1.w
mad_pp r0.xyz, -r0, c16.x, v4
dp3_pp r1.w, r0, r2
texld r2.xyz, r4, s2
mad_pp r2.xyz, r2, c17.y, c17.zzww
mov r4.y, r1.z
mov r4.x, v6.z
mov r4.z, v5
dp3_pp r1.z, r4, -r2
mov r4.y, r1
mov r4.z, v5.y
mov r4.x, v6.y
dp3_pp r1.y, -r2, r4
mov r4.y, r1.x
mov r4.z, v5.x
mov r4.x, v6
dp3_pp r1.x, -r2, r4
dp3_pp r2.x, r1, r1
rsq_pp r2.w, r2.x
dp3_pp r2.y, v4, v4
rsq_pp r2.y, r2.y
mul_pp r1.xyz, r2.w, r1
mul_pp r2.xyz, r2.y, v4
dp3_pp_sat r1.y, r1, r2
abs_pp_sat r1.x, r1.w
mul_pp r2.x, r1.y, r1.y
add_pp r3.w, -r1.x, c16
pow_pp r1, r2.x, c11.x
pow_pp r2, r3.w, c14.x
mov_pp r1.w, r2.x
mul_pp r1.w, r1, c13.x
mul_pp r1.xyz, r1.x, c12
mul_pp r1.xyz, r1, c10.x
mad_pp r1.xyz, r0.w, r1, r3
add_pp_sat r2.x, r1.w, c5
texld r0.xyz, r0, s3
mul_pp r0.xyz, r0, r2.x
mad_pp r1.xyz, r0, r0.w, r1
mul_pp r0.xyz, r1.w, r0
mad_pp oC0.xyz, r0, r0.w, r1
mov_pp oC0.w, c16
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
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 102 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
		{ 1, 2, 0, 20 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MOV R2.xyz, fragment.texcoord[6];
MAD R0.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R1.yw, R0, texture[0], 2D;
MUL R3.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MUL R1.xy, R1.wyzw, c[16].y;
DP3 R2.w, c[2], c[2];
MAD R0.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R3;
ADD R1.xy, R1, -c[16].x;
MOV R1.z, c[16];
DP3 R0.w, R1, R1;
MUL R2.xyz, R1.y, R0;
MAD R1.xyz, R1.x, fragment.texcoord[6], R2;
ADD R2.xyz, -fragment.texcoord[0], c[2];
DP3 R1.w, R2, R2;
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, R2;
RSQ R2.w, R2.w;
ADD R0.w, -R0, c[16].x;
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
MAD R1.xyz, R0.w, fragment.texcoord[5], R1;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
ABS R1.w, -c[2];
CMP R1.w, -R1, c[16].z, c[16].x;
ABS R1.w, R1;
MUL R1.xyz, R0.w, R1;
MUL R3.xyz, R2.w, c[2];
CMP R1.w, -R1, c[16].z, c[16].x;
CMP R2.xyz, -R1.w, R2, R3;
DP3 R1.w, R1, R2;
SLT R0.w, R1, c[16].z;
ADD R4.xyz, -fragment.texcoord[0], c[1];
DP3 R3.x, R4, R4;
RSQ R3.w, R3.x;
DP3 R2.w, R1, -R2;
MUL R3.xyz, R1, R2.w;
ABS R0.w, R0;
MAD R2.xyz, -R3, c[16].y, -R2;
MUL R4.xyz, R3.w, R4;
DP3 R2.x, R2, R4;
MAX R2.w, R2.x, c[16].z;
MOV R2.xyz, c[6];
POW R2.w, R2.w, c[7].x;
MUL R2.xyz, R2, c[15];
MUL R2.xyz, R2, R2.w;
CMP R0.w, -R0, c[16].z, c[16].x;
CMP R3.xyz, -R0.w, R2, c[16].z;
MOV R2.y, R0.z;
MUL R2.zw, fragment.texcoord[3].xyxy, c[9].x;
MUL R2.zw, R2, c[16].w;
TEX R4.xyz, R2.zwzw, texture[2], 2D;
MOV R0.zw, c[17].xyxy;
MAD R5.xyz, R4, c[16].y, R0.zzww;
MOV R4.y, R0;
MOV R2.x, fragment.texcoord[6].z;
MOV R2.z, fragment.texcoord[5];
DP3 R2.z, R2, -R5;
MOV R4.z, fragment.texcoord[5].y;
MOV R4.x, fragment.texcoord[6].y;
DP3 R2.y, -R5, R4;
MOV R4.y, R0.x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MOV R4.z, fragment.texcoord[5].x;
MOV R4.x, fragment.texcoord[6];
DP3 R2.x, -R5, R4;
DP3 R2.w, R2, R2;
MUL R3.w, R0, c[8].x;
MUL R5.xyz, R3, R3.w;
MOV R3.xyz, c[4];
MUL R4.xyz, R3, c[15];
MAX R1.w, R1, c[16].z;
MUL R4.xyz, R4, R1.w;
MAD R3.xyz, R3, c[0], fragment.texcoord[2];
ADD_SAT R3.xyz, R3, R4;
DP3 R1.w, R1, fragment.texcoord[4];
MAD R0.xyz, R0, R3, R5;
RSQ R2.w, R2.w;
MUL R3.xyz, R2.w, R2;
DP3 R2.x, fragment.texcoord[4], fragment.texcoord[4];
RSQ R2.w, R2.x;
MUL R2.xyz, R1, R1.w;
MUL R4.xyz, R2.w, fragment.texcoord[4];
MAD R2.xyz, -R2, c[16].y, fragment.texcoord[4];
DP3 R1.x, R2, R1;
DP3_SAT R1.w, R3, R4;
MUL R1.y, R1.w, R1.w;
ABS_SAT R1.x, R1;
ADD R1.w, -R1.x, c[16].x;
POW R1.y, R1.y, c[11].x;
MUL R1.xyz, R1.y, c[12];
POW R1.w, R1.w, c[14].x;
MUL R1.w, R1, c[13].x;
MUL R1.xyz, R1, c[10].x;
MAD R1.xyz, R0.w, R1, R0;
ADD_SAT R2.w, R1, c[5].x;
TEX R0.xyz, R2, texture[3], CUBE;
MUL R0.xyz, R0, R2.w;
MAD R1.xyz, R0, R0.w, R1;
MUL R0.xyz, R1.w, R0;
MAD result.color.xyz, R0, R0.w, R1;
MOV result.color.w, c[16].x;
END
# 102 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 103 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c16, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c17, 20.00000000, 2.00000000, -1.00000000, 3.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
mad_pp r0.xy, v3, c3, c3.zwzw
texld r0.yw, r0, s0
mov_pp r1.xyz, v6
mul_pp r2.xyz, v1.zxyw, r1.yzxw
mul_pp r0.xy, r0.wyzw, c16.x
mov_pp r1.xyz, v6
mad_pp r1.xyz, v1.yzxw, r1.zxyw, -r2
add r0.xy, r0, c16.y
mul r2.xyz, r0.y, r1
mov r0.z, c16
dp3 r0.z, r0, r0
add r0.z, -r0, c16.w
rsq r0.y, r0.z
mad r2.xyz, r0.x, v6, r2
rcp r0.x, r0.y
mad r2.xyz, r0.x, v5, r2
add r0.xyz, -v0, c2
dp3_pp r1.w, r0, r0
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul r2.xyz, r0.w, r2
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r1.w, r0
dp3_pp r0.w, c2, c2
rsq_pp r0.x, r0.w
add r4.xyz, -v0, c1
dp3 r1.w, r4, r4
rsq r1.w, r1.w
mul r4.xyz, r1.w, r4
abs_pp r0.w, -c2
mul_pp r0.xyz, r0.x, c2
cmp_pp r0.xyz, -r0.w, r0, r3
dp3_pp r0.w, r2, -r0
mul_pp r3.xyz, r2, r0.w
mad_pp r3.xyz, -r3, c16.x, -r0
dp3_pp r0.w, r3, r4
mov_pp r3.xyz, c15
mov_pp r4.xyz, c15
dp3 r1.w, r2, r0
max_pp r2.w, r0, c16.z
pow_pp r0, r2.w, c7.x
cmp r0.y, r1.w, c16.z, c16.w
abs_pp r2.w, r0.y
mov_pp r3.w, r0.x
mul_pp r3.xyz, c6, r3
mul_pp r3.xyz, r3, r3.w
texld r0, v3, s1
cmp_pp r3.xyz, -r2.w, r3, c16.z
mul_pp r3.w, r0, c8.x
mul_pp r5.xyz, r3, r3.w
mov_pp r3.xyz, c0
max r1.w, r1, c16.z
mul_pp r4.xyz, c4, r4
mul r4.xyz, r4, r1.w
mad_pp r3.xyz, c4, r3, v2
add_pp_sat r3.xyz, r3, r4
mul_pp r4.xy, v3, c9.x
mul_pp r4.xy, r4, c17.x
dp3_pp r1.w, r2, v4
mad_pp r3.xyz, r0, r3, r5
mul_pp r0.xyz, r2, r1.w
mad_pp r0.xyz, -r0, c16.x, v4
dp3_pp r1.w, r0, r2
texld r2.xyz, r4, s2
mad_pp r2.xyz, r2, c17.y, c17.zzww
mov r4.y, r1.z
mov r4.x, v6.z
mov r4.z, v5
dp3_pp r1.z, r4, -r2
mov r4.y, r1
mov r4.z, v5.y
mov r4.x, v6.y
dp3_pp r1.y, -r2, r4
mov r4.y, r1.x
mov r4.z, v5.x
mov r4.x, v6
dp3_pp r1.x, -r2, r4
dp3_pp r2.x, r1, r1
rsq_pp r2.w, r2.x
dp3_pp r2.y, v4, v4
rsq_pp r2.y, r2.y
mul_pp r1.xyz, r2.w, r1
mul_pp r2.xyz, r2.y, v4
dp3_pp_sat r1.y, r1, r2
abs_pp_sat r1.x, r1.w
mul_pp r2.x, r1.y, r1.y
add_pp r3.w, -r1.x, c16
pow_pp r1, r2.x, c11.x
pow_pp r2, r3.w, c14.x
mov_pp r1.w, r2.x
mul_pp r1.w, r1, c13.x
mul_pp r1.xyz, r1.x, c12
mul_pp r1.xyz, r1, c10.x
mad_pp r1.xyz, r0.w, r1, r3
add_pp_sat r2.x, r1.w, c5
texld r0.xyz, r0, s3
mul_pp r0.xyz, r0, r2.x
mad_pp r1.xyz, r0, r0.w, r1
mul_pp r0.xyz, r1.w, r0
mad_pp oC0.xyz, r0, r0.w, r1
mov_pp oC0.w, c16
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
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 105 ALU, 5 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
		{ 1, 2, 0, 20 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
MOV R2.xyz, fragment.texcoord[6];
MUL R0.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R0;
MAD R1.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R1.yw, R1, texture[0], 2D;
MUL R1.xy, R1.wyzw, c[16].y;
ADD R2.xy, R1, -c[16].x;
MUL R1.xyz, R2.y, R0;
MOV R2.z, c[16];
DP3 R0.w, R2, R2;
MAD R1.xyz, R2.x, fragment.texcoord[6], R1;
ADD R0.w, -R0, c[16].x;
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
MAD R1.xyz, R0.w, fragment.texcoord[5], R1;
ADD R2.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
DP3 R2.w, R1, R1;
RSQ R0.w, R2.w;
MUL R2.xyz, R1.w, R2;
ABS R2.w, -c[2];
DP3 R1.w, c[2], c[2];
RSQ R1.w, R1.w;
CMP R2.w, -R2, c[16].z, c[16].x;
MUL R1.xyz, R0.w, R1;
MUL R3.xyz, R1.w, c[2];
ABS R2.w, R2;
CMP R1.w, -R2, c[16].z, c[16].x;
CMP R2.xyz, -R1.w, R2, R3;
DP3 R1.w, R1, R2;
SLT R0.w, R1, c[16].z;
DP3 R3.w, R1, -R2;
MUL R4.xyz, R1, R3.w;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
ABS R0.w, R0;
MAD R2.xyz, -R4, c[16].y, -R2;
MUL R3.xyz, R2.w, R3;
DP3 R2.x, R2, R3;
MAX R2.w, R2.x, c[16].z;
TXP R5.x, fragment.texcoord[7], texture[2], 2D;
MUL R2.xyz, R5.x, c[15];
MUL R3.xyz, R2, c[6];
POW R2.w, R2.w, c[7].x;
MUL R3.xyz, R3, R2.w;
CMP R0.w, -R0, c[16].z, c[16].x;
CMP R4.xyz, -R0.w, R3, c[16].z;
MOV R3.y, R0.z;
MUL R3.zw, fragment.texcoord[3].xyxy, c[9].x;
MUL R3.zw, R3, c[16].w;
TEX R6.xyz, R3.zwzw, texture[3], 2D;
MOV R0.zw, c[17].xyxy;
MAD R5.yzw, R6.xxyz, c[16].y, R0.xzzw;
MOV R6.y, R0;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R3.z, R3, -R5.yzww;
MOV R6.z, fragment.texcoord[5].y;
MOV R6.x, fragment.texcoord[6].y;
DP3 R3.y, -R5.yzww, R6;
MOV R6.y, R0.x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MUL R2.w, R0, c[8].x;
MUL R4.xyz, R4, R2.w;
MOV R6.z, fragment.texcoord[5].x;
MOV R6.x, fragment.texcoord[6];
DP3 R3.x, -R5.yzww, R6;
DP3 R3.w, R3, R3;
RSQ R2.w, R3.w;
MOV R5.yzw, c[4].xxyz;
MAX R1.w, R1, c[16].z;
MUL R2.xyz, R2, c[4];
MUL R2.xyz, R2, R1.w;
MAD R6.xyz, R5.yzww, c[0], fragment.texcoord[2];
ADD_SAT R2.xyz, R6, R2;
MAD R0.xyz, R0, R2, R4;
DP3 R2.x, R1, fragment.texcoord[4];
MUL R2.xyz, R1, R2.x;
MAD R2.xyz, -R2, c[16].y, fragment.texcoord[4];
DP3 R1.y, R2, R1;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R3.xyz, R2.w, R3;
MUL R4.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R3, R4;
MUL R1.x, R1.w, R1.w;
ABS_SAT R1.y, R1;
ADD R1.w, -R1.y, c[16].x;
POW R1.x, R1.x, c[11].x;
MUL R1.xyz, R1.x, c[12];
POW R1.w, R1.w, c[14].x;
MUL R1.w, R1, c[13].x;
MUL R1.xyz, R5.x, R1;
MUL R1.xyz, R1, c[10].x;
MAD R0.xyz, R0.w, R1, R0;
ADD R2.w, R1, c[5].x;
MUL_SAT R2.w, R2, R5.x;
TEX R1.xyz, R2, texture[4], CUBE;
MUL R1.xyz, R1, R2.w;
MAD R0.xyz, R1, R0.w, R0;
MUL R1.xyz, R1.w, R1;
MAD result.color.xyz, R1, R0.w, R0;
MOV result.color.w, c[16].x;
END
# 105 instructions, 7 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 104 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c16, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c17, 20.00000000, 2.00000000, -1.00000000, 3.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
mad_pp r0.xy, v3, c3, c3.zwzw
texld r0.yw, r0, s0
mul_pp r0.xy, r0.wyzw, c16.x
mov_pp r1.xyz, v6
add r0.xy, r0, c16.y
mov r0.z, c16
dp3 r0.z, r0, r0
add r0.z, -r0, c16.w
rsq r0.w, r0.z
mul_pp r1.xyz, v1.zxyw, r1.yzxw
mov_pp r2.xyz, v6
mad_pp r2.xyz, v1.yzxw, r2.zxyw, -r1
mul r1.xyz, r0.y, r2
mad r0.xyz, r0.x, v6, r1
rcp r0.w, r0.w
mad r1.xyz, r0.w, v5, r0
dp3 r0.w, r1, r1
rsq r1.w, r0.w
mul r1.xyz, r1.w, r1
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r0
dp3_pp r1.w, c2, c2
rsq_pp r0.w, r1.w
mul_pp r4.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp_pp r3.xyz, -r0.w, r4, r3
dp3_pp r1.w, r1, -r3
mul_pp r4.xyz, r1, r1.w
add r0.xyz, -v0, c1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad_pp r4.xyz, -r4, c16.x, -r3
dp3 r1.w, r1, r3
mul r0.xyz, r0.w, r0
dp3_pp r0.x, r4, r0
max_pp r2.w, r0.x, c16.z
cmp r3.x, r1.w, c16.z, c16.w
pow_pp r0, r2.w, c7.x
texldp r4.x, v7, s2
mov_pp r3.w, r0.x
mov_pp r4.yzw, c0.xxyz
texld r0, v3, s1
abs_pp r2.w, r3.x
mul_pp r5.xyz, r4.x, c15
mul_pp r3.xyz, r5, c6
mul_pp r3.xyz, r3, r3.w
cmp_pp r3.xyz, -r2.w, r3, c16.z
mul_pp r3.w, r0, c8.x
mul_pp r3.xyz, r3, r3.w
max r1.w, r1, c16.z
mul_pp r5.xyz, r5, c4
mul r5.xyz, r5, r1.w
mad_pp r4.yzw, c4.xxyz, r4, v2.xxyz
add_pp_sat r5.xyz, r4.yzww, r5
dp3_pp r1.w, r1, v4
mad_pp r3.xyz, r0, r5, r3
mul_pp r0.xyz, r1, r1.w
mad_pp r0.xyz, -r0, c16.x, v4
dp3_pp r1.w, r0, r1
mov r1.y, r2.z
mov r2.z, r2.y
mul_pp r4.zw, v3.xyxy, c9.x
mul_pp r5.xy, r4.zwzw, c17.x
texld r5.xyz, r5, s3
mad_pp r5.xyz, r5, c17.y, c17.zzww
mov r1.x, v6.z
mov r1.z, v5
dp3_pp r1.z, r1, -r5
mov r2.w, v5.y
mov r2.y, v6
dp3_pp r1.y, -r5, r2.yzww
mov r2.y, r2.x
mov r2.z, v5.x
mov r2.x, v6
dp3_pp r1.x, -r5, r2
dp3_pp r2.y, r1, r1
rsq_pp r2.w, r2.y
dp3_pp r2.x, v4, v4
rsq_pp r2.x, r2.x
mul_pp r1.xyz, r2.w, r1
mul_pp r2.xyz, r2.x, v4
dp3_pp_sat r1.x, r1, r2
abs_pp_sat r1.y, r1.w
mul_pp r2.x, r1, r1
add_pp r3.w, -r1.y, c16
pow_pp r1, r2.x, c11.x
pow_pp r2, r3.w, c14.x
mov_pp r1.w, r2.x
mul_pp r1.w, r1, c13.x
mul_pp r1.xyz, r1.x, c12
mul_pp r1.xyz, r4.x, r1
add_pp r2.x, r1.w, c5
mul_pp r1.xyz, r1, c10.x
mad_pp r1.xyz, r0.w, r1, r3
mul_pp_sat r2.x, r2, r4
texld r0.xyz, r0, s4
mul_pp r0.xyz, r0, r2.x
mad_pp r1.xyz, r0, r0.w, r1
mul_pp r0.xyz, r1.w, r0
mad_pp oC0.xyz, r0, r0.w, r1
mov_pp oC0.w, c16
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
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 105 ALU, 5 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
		{ 1, 2, 0, 20 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
MOV R2.xyz, fragment.texcoord[6];
MUL R0.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R0;
MAD R1.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R1.yw, R1, texture[0], 2D;
MUL R1.xy, R1.wyzw, c[16].y;
ADD R2.xy, R1, -c[16].x;
MUL R1.xyz, R2.y, R0;
MOV R2.z, c[16];
DP3 R0.w, R2, R2;
MAD R1.xyz, R2.x, fragment.texcoord[6], R1;
ADD R0.w, -R0, c[16].x;
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
MAD R1.xyz, R0.w, fragment.texcoord[5], R1;
ADD R2.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
DP3 R2.w, R1, R1;
RSQ R0.w, R2.w;
MUL R2.xyz, R1.w, R2;
ABS R2.w, -c[2];
DP3 R1.w, c[2], c[2];
RSQ R1.w, R1.w;
CMP R2.w, -R2, c[16].z, c[16].x;
MUL R1.xyz, R0.w, R1;
MUL R3.xyz, R1.w, c[2];
ABS R2.w, R2;
CMP R1.w, -R2, c[16].z, c[16].x;
CMP R2.xyz, -R1.w, R2, R3;
DP3 R1.w, R1, R2;
SLT R0.w, R1, c[16].z;
DP3 R3.w, R1, -R2;
MUL R4.xyz, R1, R3.w;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
ABS R0.w, R0;
MAD R2.xyz, -R4, c[16].y, -R2;
MUL R3.xyz, R2.w, R3;
DP3 R2.x, R2, R3;
MAX R2.w, R2.x, c[16].z;
TXP R5.x, fragment.texcoord[7], texture[2], 2D;
MUL R2.xyz, R5.x, c[15];
MUL R3.xyz, R2, c[6];
POW R2.w, R2.w, c[7].x;
MUL R3.xyz, R3, R2.w;
CMP R0.w, -R0, c[16].z, c[16].x;
CMP R4.xyz, -R0.w, R3, c[16].z;
MOV R3.y, R0.z;
MUL R3.zw, fragment.texcoord[3].xyxy, c[9].x;
MUL R3.zw, R3, c[16].w;
TEX R6.xyz, R3.zwzw, texture[3], 2D;
MOV R0.zw, c[17].xyxy;
MAD R5.yzw, R6.xxyz, c[16].y, R0.xzzw;
MOV R6.y, R0;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R3.z, R3, -R5.yzww;
MOV R6.z, fragment.texcoord[5].y;
MOV R6.x, fragment.texcoord[6].y;
DP3 R3.y, -R5.yzww, R6;
MOV R6.y, R0.x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MUL R2.w, R0, c[8].x;
MUL R4.xyz, R4, R2.w;
MOV R6.z, fragment.texcoord[5].x;
MOV R6.x, fragment.texcoord[6];
DP3 R3.x, -R5.yzww, R6;
DP3 R3.w, R3, R3;
RSQ R2.w, R3.w;
MOV R5.yzw, c[4].xxyz;
MAX R1.w, R1, c[16].z;
MUL R2.xyz, R2, c[4];
MUL R2.xyz, R2, R1.w;
MAD R6.xyz, R5.yzww, c[0], fragment.texcoord[2];
ADD_SAT R2.xyz, R6, R2;
MAD R0.xyz, R0, R2, R4;
DP3 R2.x, R1, fragment.texcoord[4];
MUL R2.xyz, R1, R2.x;
MAD R2.xyz, -R2, c[16].y, fragment.texcoord[4];
DP3 R1.y, R2, R1;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R3.xyz, R2.w, R3;
MUL R4.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R3, R4;
MUL R1.x, R1.w, R1.w;
ABS_SAT R1.y, R1;
ADD R1.w, -R1.y, c[16].x;
POW R1.x, R1.x, c[11].x;
MUL R1.xyz, R1.x, c[12];
POW R1.w, R1.w, c[14].x;
MUL R1.w, R1, c[13].x;
MUL R1.xyz, R5.x, R1;
MUL R1.xyz, R1, c[10].x;
MAD R0.xyz, R0.w, R1, R0;
ADD R2.w, R1, c[5].x;
MUL_SAT R2.w, R2, R5.x;
TEX R1.xyz, R2, texture[4], CUBE;
MUL R1.xyz, R1, R2.w;
MAD R0.xyz, R1, R0.w, R0;
MUL R1.xyz, R1.w, R1;
MAD result.color.xyz, R1, R0.w, R0;
MOV result.color.w, c[16].x;
END
# 105 instructions, 7 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 104 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c16, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c17, 20.00000000, 2.00000000, -1.00000000, 3.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
mad_pp r0.xy, v3, c3, c3.zwzw
texld r0.yw, r0, s0
mul_pp r0.xy, r0.wyzw, c16.x
mov_pp r1.xyz, v6
add r0.xy, r0, c16.y
mov r0.z, c16
dp3 r0.z, r0, r0
add r0.z, -r0, c16.w
rsq r0.w, r0.z
mul_pp r1.xyz, v1.zxyw, r1.yzxw
mov_pp r2.xyz, v6
mad_pp r2.xyz, v1.yzxw, r2.zxyw, -r1
mul r1.xyz, r0.y, r2
mad r0.xyz, r0.x, v6, r1
rcp r0.w, r0.w
mad r1.xyz, r0.w, v5, r0
dp3 r0.w, r1, r1
rsq r1.w, r0.w
mul r1.xyz, r1.w, r1
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r0
dp3_pp r1.w, c2, c2
rsq_pp r0.w, r1.w
mul_pp r4.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp_pp r3.xyz, -r0.w, r4, r3
dp3_pp r1.w, r1, -r3
mul_pp r4.xyz, r1, r1.w
add r0.xyz, -v0, c1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad_pp r4.xyz, -r4, c16.x, -r3
dp3 r1.w, r1, r3
mul r0.xyz, r0.w, r0
dp3_pp r0.x, r4, r0
max_pp r2.w, r0.x, c16.z
cmp r3.x, r1.w, c16.z, c16.w
pow_pp r0, r2.w, c7.x
texldp r4.x, v7, s2
mov_pp r3.w, r0.x
mov_pp r4.yzw, c0.xxyz
texld r0, v3, s1
abs_pp r2.w, r3.x
mul_pp r5.xyz, r4.x, c15
mul_pp r3.xyz, r5, c6
mul_pp r3.xyz, r3, r3.w
cmp_pp r3.xyz, -r2.w, r3, c16.z
mul_pp r3.w, r0, c8.x
mul_pp r3.xyz, r3, r3.w
max r1.w, r1, c16.z
mul_pp r5.xyz, r5, c4
mul r5.xyz, r5, r1.w
mad_pp r4.yzw, c4.xxyz, r4, v2.xxyz
add_pp_sat r5.xyz, r4.yzww, r5
dp3_pp r1.w, r1, v4
mad_pp r3.xyz, r0, r5, r3
mul_pp r0.xyz, r1, r1.w
mad_pp r0.xyz, -r0, c16.x, v4
dp3_pp r1.w, r0, r1
mov r1.y, r2.z
mov r2.z, r2.y
mul_pp r4.zw, v3.xyxy, c9.x
mul_pp r5.xy, r4.zwzw, c17.x
texld r5.xyz, r5, s3
mad_pp r5.xyz, r5, c17.y, c17.zzww
mov r1.x, v6.z
mov r1.z, v5
dp3_pp r1.z, r1, -r5
mov r2.w, v5.y
mov r2.y, v6
dp3_pp r1.y, -r5, r2.yzww
mov r2.y, r2.x
mov r2.z, v5.x
mov r2.x, v6
dp3_pp r1.x, -r5, r2
dp3_pp r2.y, r1, r1
rsq_pp r2.w, r2.y
dp3_pp r2.x, v4, v4
rsq_pp r2.x, r2.x
mul_pp r1.xyz, r2.w, r1
mul_pp r2.xyz, r2.x, v4
dp3_pp_sat r1.x, r1, r2
abs_pp_sat r1.y, r1.w
mul_pp r2.x, r1, r1
add_pp r3.w, -r1.y, c16
pow_pp r1, r2.x, c11.x
pow_pp r2, r3.w, c14.x
mov_pp r1.w, r2.x
mul_pp r1.w, r1, c13.x
mul_pp r1.xyz, r1.x, c12
mul_pp r1.xyz, r4.x, r1
add_pp r2.x, r1.w, c5
mul_pp r1.xyz, r1, c10.x
mad_pp r1.xyz, r0.w, r1, r3
mul_pp_sat r2.x, r2, r4
texld r0.xyz, r0, s4
mul_pp r0.xyz, r0, r2.x
mad_pp r1.xyz, r0, r0.w, r1
mul_pp r0.xyz, r1.w, r0
mad_pp oC0.xyz, r0, r0.w, r1
mov_pp oC0.w, c16
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
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 105 ALU, 5 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
		{ 1, 2, 0, 20 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
TEMP R6;
MOV R2.xyz, fragment.texcoord[6];
MUL R0.xyz, fragment.texcoord[1].zxyw, R2.yzxw;
MAD R0.xyz, fragment.texcoord[1].yzxw, R2.zxyw, -R0;
MAD R1.xy, fragment.texcoord[3], c[3], c[3].zwzw;
TEX R1.yw, R1, texture[0], 2D;
MUL R1.xy, R1.wyzw, c[16].y;
ADD R2.xy, R1, -c[16].x;
MUL R1.xyz, R2.y, R0;
MOV R2.z, c[16];
DP3 R0.w, R2, R2;
MAD R1.xyz, R2.x, fragment.texcoord[6], R1;
ADD R0.w, -R0, c[16].x;
RSQ R0.w, R0.w;
RCP R0.w, R0.w;
MAD R1.xyz, R0.w, fragment.texcoord[5], R1;
ADD R2.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
DP3 R2.w, R1, R1;
RSQ R0.w, R2.w;
MUL R2.xyz, R1.w, R2;
ABS R2.w, -c[2];
DP3 R1.w, c[2], c[2];
RSQ R1.w, R1.w;
CMP R2.w, -R2, c[16].z, c[16].x;
MUL R1.xyz, R0.w, R1;
MUL R3.xyz, R1.w, c[2];
ABS R2.w, R2;
CMP R1.w, -R2, c[16].z, c[16].x;
CMP R2.xyz, -R1.w, R2, R3;
DP3 R1.w, R1, R2;
SLT R0.w, R1, c[16].z;
DP3 R3.w, R1, -R2;
MUL R4.xyz, R1, R3.w;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R2.w, R3, R3;
RSQ R2.w, R2.w;
ABS R0.w, R0;
MAD R2.xyz, -R4, c[16].y, -R2;
MUL R3.xyz, R2.w, R3;
DP3 R2.x, R2, R3;
MAX R2.w, R2.x, c[16].z;
TXP R5.x, fragment.texcoord[7], texture[2], 2D;
MUL R2.xyz, R5.x, c[15];
MUL R3.xyz, R2, c[6];
POW R2.w, R2.w, c[7].x;
MUL R3.xyz, R3, R2.w;
CMP R0.w, -R0, c[16].z, c[16].x;
CMP R4.xyz, -R0.w, R3, c[16].z;
MOV R3.y, R0.z;
MUL R3.zw, fragment.texcoord[3].xyxy, c[9].x;
MUL R3.zw, R3, c[16].w;
TEX R6.xyz, R3.zwzw, texture[3], 2D;
MOV R0.zw, c[17].xyxy;
MAD R5.yzw, R6.xxyz, c[16].y, R0.xzzw;
MOV R6.y, R0;
MOV R3.x, fragment.texcoord[6].z;
MOV R3.z, fragment.texcoord[5];
DP3 R3.z, R3, -R5.yzww;
MOV R6.z, fragment.texcoord[5].y;
MOV R6.x, fragment.texcoord[6].y;
DP3 R3.y, -R5.yzww, R6;
MOV R6.y, R0.x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
MUL R2.w, R0, c[8].x;
MUL R4.xyz, R4, R2.w;
MOV R6.z, fragment.texcoord[5].x;
MOV R6.x, fragment.texcoord[6];
DP3 R3.x, -R5.yzww, R6;
DP3 R3.w, R3, R3;
RSQ R2.w, R3.w;
MOV R5.yzw, c[4].xxyz;
MAX R1.w, R1, c[16].z;
MUL R2.xyz, R2, c[4];
MUL R2.xyz, R2, R1.w;
MAD R6.xyz, R5.yzww, c[0], fragment.texcoord[2];
ADD_SAT R2.xyz, R6, R2;
MAD R0.xyz, R0, R2, R4;
DP3 R2.x, R1, fragment.texcoord[4];
MUL R2.xyz, R1, R2.x;
MAD R2.xyz, -R2, c[16].y, fragment.texcoord[4];
DP3 R1.y, R2, R1;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R3.xyz, R2.w, R3;
MUL R4.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.w, R3, R4;
MUL R1.x, R1.w, R1.w;
ABS_SAT R1.y, R1;
ADD R1.w, -R1.y, c[16].x;
POW R1.x, R1.x, c[11].x;
MUL R1.xyz, R1.x, c[12];
POW R1.w, R1.w, c[14].x;
MUL R1.w, R1, c[13].x;
MUL R1.xyz, R5.x, R1;
MUL R1.xyz, R1, c[10].x;
MAD R0.xyz, R0.w, R1, R0;
ADD R2.w, R1, c[5].x;
MUL_SAT R2.w, R2, R5.x;
TEX R1.xyz, R2, texture[4], CUBE;
MUL R1.xyz, R1, R2.w;
MAD R0.xyz, R1, R0.w, R0;
MUL R1.xyz, R1.w, R1;
MAD result.color.xyz, R1, R0.w, R0;
MOV result.color.w, c[16].x;
END
# 105 instructions, 7 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Vector 0 [glstate_lightmodel_ambient]
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_BumpMap_ST]
Vector 4 [_Color]
Float 5 [_Reflection]
Vector 6 [_SpecColor]
Float 7 [_Shininess]
Float 8 [_Gloss]
Float 9 [_FlakeScale]
Float 10 [_FlakePower]
Float 11 [_OuterFlakePower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_BumpMap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 104 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c16, 2.00000000, -1.00000000, 0.00000000, 1.00000000
def c17, 20.00000000, 2.00000000, -1.00000000, 3.00000000
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
mad_pp r0.xy, v3, c3, c3.zwzw
texld r0.yw, r0, s0
mul_pp r0.xy, r0.wyzw, c16.x
mov_pp r1.xyz, v6
add r0.xy, r0, c16.y
mov r0.z, c16
dp3 r0.z, r0, r0
add r0.z, -r0, c16.w
rsq r0.w, r0.z
mul_pp r1.xyz, v1.zxyw, r1.yzxw
mov_pp r2.xyz, v6
mad_pp r2.xyz, v1.yzxw, r2.zxyw, -r1
mul r1.xyz, r0.y, r2
mad r0.xyz, r0.x, v6, r1
rcp r0.w, r0.w
mad r1.xyz, r0.w, v5, r0
dp3 r0.w, r1, r1
rsq r1.w, r0.w
mul r1.xyz, r1.w, r1
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r0.w, r0.w
mul_pp r3.xyz, r0.w, r0
dp3_pp r1.w, c2, c2
rsq_pp r0.w, r1.w
mul_pp r4.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp_pp r3.xyz, -r0.w, r4, r3
dp3_pp r1.w, r1, -r3
mul_pp r4.xyz, r1, r1.w
add r0.xyz, -v0, c1
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mad_pp r4.xyz, -r4, c16.x, -r3
dp3 r1.w, r1, r3
mul r0.xyz, r0.w, r0
dp3_pp r0.x, r4, r0
max_pp r2.w, r0.x, c16.z
cmp r3.x, r1.w, c16.z, c16.w
pow_pp r0, r2.w, c7.x
texldp r4.x, v7, s2
mov_pp r3.w, r0.x
mov_pp r4.yzw, c0.xxyz
texld r0, v3, s1
abs_pp r2.w, r3.x
mul_pp r5.xyz, r4.x, c15
mul_pp r3.xyz, r5, c6
mul_pp r3.xyz, r3, r3.w
cmp_pp r3.xyz, -r2.w, r3, c16.z
mul_pp r3.w, r0, c8.x
mul_pp r3.xyz, r3, r3.w
max r1.w, r1, c16.z
mul_pp r5.xyz, r5, c4
mul r5.xyz, r5, r1.w
mad_pp r4.yzw, c4.xxyz, r4, v2.xxyz
add_pp_sat r5.xyz, r4.yzww, r5
dp3_pp r1.w, r1, v4
mad_pp r3.xyz, r0, r5, r3
mul_pp r0.xyz, r1, r1.w
mad_pp r0.xyz, -r0, c16.x, v4
dp3_pp r1.w, r0, r1
mov r1.y, r2.z
mov r2.z, r2.y
mul_pp r4.zw, v3.xyxy, c9.x
mul_pp r5.xy, r4.zwzw, c17.x
texld r5.xyz, r5, s3
mad_pp r5.xyz, r5, c17.y, c17.zzww
mov r1.x, v6.z
mov r1.z, v5
dp3_pp r1.z, r1, -r5
mov r2.w, v5.y
mov r2.y, v6
dp3_pp r1.y, -r5, r2.yzww
mov r2.y, r2.x
mov r2.z, v5.x
mov r2.x, v6
dp3_pp r1.x, -r5, r2
dp3_pp r2.y, r1, r1
rsq_pp r2.w, r2.y
dp3_pp r2.x, v4, v4
rsq_pp r2.x, r2.x
mul_pp r1.xyz, r2.w, r1
mul_pp r2.xyz, r2.x, v4
dp3_pp_sat r1.x, r1, r2
abs_pp_sat r1.y, r1.w
mul_pp r2.x, r1, r1
add_pp r3.w, -r1.y, c16
pow_pp r1, r2.x, c11.x
pow_pp r2, r3.w, c14.x
mov_pp r1.w, r2.x
mul_pp r1.w, r1, c13.x
mul_pp r1.xyz, r1.x, c12
mul_pp r1.xyz, r4.x, r1
add_pp r2.x, r1.w, c5
mul_pp r1.xyz, r1, c10.x
mad_pp r1.xyz, r0.w, r1, r3
mul_pp_sat r2.x, r2, r4
texld r0.xyz, r0, s4
mul_pp r0.xyz, r0, r2.x
mad_pp r1.xyz, r0, r0.w, r1
mul_pp r0.xyz, r1.w, r0
mad_pp oC0.xyz, r0, r0.w, r1
mov_pp oC0.w, c16
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

#LINE 287

      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "VertexLit"
}