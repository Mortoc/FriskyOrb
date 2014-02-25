Shader "RedDotGames/Mobile/Light Probes Support/Car Paint High Detail" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _Shininess ("Shininess", Range (0.01, 10)) = 1
	  _Gloss ("Gloss", Range (0.0, 10)) = 1
	  _MainTex ("Diffuse Texture", 2D) = "white" {} 
	  _Cube("Reflection Map", Cube) = "" {}
	  _Reflection("Reflection Power", Range (0.00, 1)) = 0
	  _FrezPow("Fresnel Power",Range(0,2)) = .25
	  _FrezFalloff("Fresnal Falloff",Range(0,10)) = 4	  
	  
	  _SparkleTex ("Sparkle Texture", 2D) = "white" {} 

	  _FlakeScale ("Flake Scale", float) = 1
	  _FlakePower ("Flake Alpha",Range(0,1)) = 0

	  _OuterFlakePower ("Flake Outer Power",Range(1,16)) = 2

	  _paintColor2 ("Outer Flake Color (RGB)", Color) = (1,1,1,1) 
	  _SHLightingScale("LightProbe influence scale",Range(0,1)) = 1
	  
   }
SubShader {
   Tags { "QUEUE"="Geometry" "RenderType"="Opaque" " IgnoreProjector"="True"}	  
      Pass {  
      
         Tags { "LightMode" = "ForwardBase" } // pass for 
            // 4 vertex lights, ambient light & first pixel light
 
         Program "vp" {
// Vertex combos: 8
//   opengl - ALU: 53 to 117
//   d3d9 - ALU: 53 to 117
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
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
"3.0-!!ARBvp1.0
# 53 ALU
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
MUL R1.xyz, R0.w, R0;
MOV R0.xyz, R1;
MOV R0.w, c[0].y;
DP4 R3.z, R0, c[16];
DP4 R3.y, R0, c[15];
DP4 R3.x, R0, c[14];
MUL R2, R1.xyzz, R1.yzzx;
DP4 R0.z, R2, c[19];
DP4 R0.x, R2, c[17];
DP4 R0.y, R2, c[18];
ADD R4.xyz, R3, R0;
MOV R0.xyz, vertex.attrib[14];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[7];
DP4 R2.x, R0, c[5];
DP4 R2.y, R0, c[6];
DP3 R0.x, R2, R2;
MUL R0.y, R1, R1;
MAD R0.w, R1.x, R1.x, -R0.y;
MUL R3.xyz, R0.w, c[20];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, R2;
MUL R2.xyz, R1.zxyw, R0.yzxw;
ADD R3.xyz, R4, R3;
MAD result.texcoord[7].xyz, R1.yzxw, R0.zxyw, -R2;
MOV result.texcoord[6].xyz, R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[2].xyz, R3, c[21].x;
MOV result.texcoord[1].xyz, R1;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 53 instructions, 5 R-regs
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
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"vs_3_0
; 53 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c21, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c21.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mov r0.xyz, r1
mov r0.w, c21.y
dp4 r3.z, r0, c15
dp4 r3.y, r0, c14
dp4 r3.x, r0, c13
mul r2, r1.xyzz, r1.yzzx
dp4 r0.z, r2, c18
dp4 r0.x, r2, c16
dp4 r0.y, r2, c17
add r4.xyz, r3, r0
mov r0.xyz, v3
mov r0.w, c21.x
dp4 r2.z, r0, c6
dp4 r2.x, r0, c4
dp4 r2.y, r0, c5
dp3 r0.x, r2, r2
mul r0.y, r1, r1
mad r0.w, r1.x, r1.x, -r0.y
mul r3.xyz, r0.w, c19
rsq r0.x, r0.x
mul r0.xyz, r0.x, r2
mul r2.xyz, r1.zxyw, r0.yzxw
add r3.xyz, r4, r3
mad o8.xyz, r1.yzxw, r0.zxyw, -r2
mov o7.xyz, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o1, r0
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.w, c21.x
mov r0.xyz, v1
mul o3.xyz, r3, c20.x
mov o2.xyz, r1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * tmpvar_7).xyz;
  tmpvar_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  lowp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((modelMatrix * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((modelMatrix * tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  mediump vec3 tmpvar_16;
  mediump vec4 normal;
  normal = tmpvar_15;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAr, normal);
  x1.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAg, normal);
  x1.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAb, normal);
  x1.z = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBr, tmpvar_20);
  x2.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBg, tmpvar_20);
  x2.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBb, tmpvar_20);
  x2.z = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (unity_SHC.xyz * vC);
  x3 = tmpvar_25;
  tmpvar_16 = ((x1 + x2) + x3);
  shl = tmpvar_16;
  highp vec3 tmpvar_26;
  tmpvar_26 = (shl * _SHLightingScale);
  tmpvar_3 = tmpvar_26;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_10;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_10, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * tmpvar_7).xyz;
  tmpvar_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  lowp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((modelMatrix * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((modelMatrix * tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  mediump vec3 tmpvar_16;
  mediump vec4 normal;
  normal = tmpvar_15;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAr, normal);
  x1.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAg, normal);
  x1.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAb, normal);
  x1.z = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBr, tmpvar_20);
  x2.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBg, tmpvar_20);
  x2.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBb, tmpvar_20);
  x2.z = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (unity_SHC.xyz * vC);
  x3 = tmpvar_25;
  tmpvar_16 = ((x1 + x2) + x3);
  shl = tmpvar_16;
  highp vec3 tmpvar_26;
  tmpvar_26 = (shl * _SHLightingScale);
  tmpvar_3 = tmpvar_26;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_10;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_10, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
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
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Float 21 [_SHLightingScale]
"3.0-!!ARBvp1.0
# 53 ALU
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
MUL R1.xyz, R0.w, R0;
MOV R0.xyz, R1;
MOV R0.w, c[0].y;
DP4 R3.z, R0, c[16];
DP4 R3.y, R0, c[15];
DP4 R3.x, R0, c[14];
MUL R2, R1.xyzz, R1.yzzx;
DP4 R0.z, R2, c[19];
DP4 R0.x, R2, c[17];
DP4 R0.y, R2, c[18];
ADD R4.xyz, R3, R0;
MOV R0.xyz, vertex.attrib[14];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[7];
DP4 R2.x, R0, c[5];
DP4 R2.y, R0, c[6];
DP3 R0.x, R2, R2;
MUL R0.y, R1, R1;
MAD R0.w, R1.x, R1.x, -R0.y;
MUL R3.xyz, R0.w, c[20];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, R2;
MUL R2.xyz, R1.zxyw, R0.yzxw;
ADD R3.xyz, R4, R3;
MAD result.texcoord[7].xyz, R1.yzxw, R0.zxyw, -R2;
MOV result.texcoord[6].xyz, R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[2].xyz, R3, c[21].x;
MOV result.texcoord[1].xyz, R1;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 53 instructions, 5 R-regs
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
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"vs_3_0
; 53 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c21, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c21.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mov r0.xyz, r1
mov r0.w, c21.y
dp4 r3.z, r0, c15
dp4 r3.y, r0, c14
dp4 r3.x, r0, c13
mul r2, r1.xyzz, r1.yzzx
dp4 r0.z, r2, c18
dp4 r0.x, r2, c16
dp4 r0.y, r2, c17
add r4.xyz, r3, r0
mov r0.xyz, v3
mov r0.w, c21.x
dp4 r2.z, r0, c6
dp4 r2.x, r0, c4
dp4 r2.y, r0, c5
dp3 r0.x, r2, r2
mul r0.y, r1, r1
mad r0.w, r1.x, r1.x, -r0.y
mul r3.xyz, r0.w, c19
rsq r0.x, r0.x
mul r0.xyz, r0.x, r2
mul r2.xyz, r1.zxyw, r0.yzxw
add r3.xyz, r4, r3
mad o8.xyz, r1.yzxw, r0.zxyw, -r2
mov o7.xyz, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o1, r0
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.w, c21.x
mov r0.xyz, v1
mul o3.xyz, r3, c20.x
mov o2.xyz, r1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * tmpvar_7).xyz;
  tmpvar_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  lowp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((modelMatrix * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((modelMatrix * tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  mediump vec3 tmpvar_16;
  mediump vec4 normal;
  normal = tmpvar_15;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAr, normal);
  x1.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAg, normal);
  x1.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAb, normal);
  x1.z = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBr, tmpvar_20);
  x2.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBg, tmpvar_20);
  x2.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBb, tmpvar_20);
  x2.z = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (unity_SHC.xyz * vC);
  x3 = tmpvar_25;
  tmpvar_16 = ((x1 + x2) + x3);
  shl = tmpvar_16;
  highp vec3 tmpvar_26;
  tmpvar_26 = (shl * _SHLightingScale);
  tmpvar_3 = tmpvar_26;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_10;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_10, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * tmpvar_7).xyz;
  tmpvar_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  lowp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((modelMatrix * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((modelMatrix * tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  mediump vec3 tmpvar_16;
  mediump vec4 normal;
  normal = tmpvar_15;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAr, normal);
  x1.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAg, normal);
  x1.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAb, normal);
  x1.z = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBr, tmpvar_20);
  x2.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBg, tmpvar_20);
  x2.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBb, tmpvar_20);
  x2.z = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (unity_SHC.xyz * vC);
  x3 = tmpvar_25;
  tmpvar_16 = ((x1 + x2) + x3);
  shl = tmpvar_16;
  highp vec3 tmpvar_26;
  tmpvar_26 = (shl * _SHLightingScale);
  tmpvar_3 = tmpvar_26;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_10;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_10, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
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
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Float 21 [_SHLightingScale]
"3.0-!!ARBvp1.0
# 53 ALU
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
MUL R1.xyz, R0.w, R0;
MOV R0.xyz, R1;
MOV R0.w, c[0].y;
DP4 R3.z, R0, c[16];
DP4 R3.y, R0, c[15];
DP4 R3.x, R0, c[14];
MUL R2, R1.xyzz, R1.yzzx;
DP4 R0.z, R2, c[19];
DP4 R0.x, R2, c[17];
DP4 R0.y, R2, c[18];
ADD R4.xyz, R3, R0;
MOV R0.xyz, vertex.attrib[14];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[7];
DP4 R2.x, R0, c[5];
DP4 R2.y, R0, c[6];
DP3 R0.x, R2, R2;
MUL R0.y, R1, R1;
MAD R0.w, R1.x, R1.x, -R0.y;
MUL R3.xyz, R0.w, c[20];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, R2;
MUL R2.xyz, R1.zxyw, R0.yzxw;
ADD R3.xyz, R4, R3;
MAD result.texcoord[7].xyz, R1.yzxw, R0.zxyw, -R2;
MOV result.texcoord[6].xyz, R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[2].xyz, R3, c[21].x;
MOV result.texcoord[1].xyz, R1;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 53 instructions, 5 R-regs
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
Vector 13 [unity_SHAr]
Vector 14 [unity_SHAg]
Vector 15 [unity_SHAb]
Vector 16 [unity_SHBr]
Vector 17 [unity_SHBg]
Vector 18 [unity_SHBb]
Vector 19 [unity_SHC]
Float 20 [_SHLightingScale]
"vs_3_0
; 53 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c21, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c21.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mov r0.xyz, r1
mov r0.w, c21.y
dp4 r3.z, r0, c15
dp4 r3.y, r0, c14
dp4 r3.x, r0, c13
mul r2, r1.xyzz, r1.yzzx
dp4 r0.z, r2, c18
dp4 r0.x, r2, c16
dp4 r0.y, r2, c17
add r4.xyz, r3, r0
mov r0.xyz, v3
mov r0.w, c21.x
dp4 r2.z, r0, c6
dp4 r2.x, r0, c4
dp4 r2.y, r0, c5
dp3 r0.x, r2, r2
mul r0.y, r1, r1
mad r0.w, r1.x, r1.x, -r0.y
mul r3.xyz, r0.w, c19
rsq r0.x, r0.x
mul r0.xyz, r0.x, r2
mul r2.xyz, r1.zxyw, r0.yzxw
add r3.xyz, r4, r3
mad o8.xyz, r1.yzxw, r0.zxyw, -r2
mov o7.xyz, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o1, r0
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.w, c21.x
mov r0.xyz, v1
mul o3.xyz, r3, c20.x
mov o2.xyz, r1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * tmpvar_7).xyz;
  tmpvar_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  lowp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((modelMatrix * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((modelMatrix * tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  mediump vec3 tmpvar_16;
  mediump vec4 normal;
  normal = tmpvar_15;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAr, normal);
  x1.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAg, normal);
  x1.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAb, normal);
  x1.z = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBr, tmpvar_20);
  x2.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBg, tmpvar_20);
  x2.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBb, tmpvar_20);
  x2.z = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (unity_SHC.xyz * vC);
  x3 = tmpvar_25;
  tmpvar_16 = ((x1 + x2) + x3);
  shl = tmpvar_16;
  highp vec3 tmpvar_26;
  tmpvar_26 = (shl * _SHLightingScale);
  tmpvar_3 = tmpvar_26;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_10;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_10, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * tmpvar_7).xyz;
  tmpvar_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  lowp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((modelMatrix * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((modelMatrix * tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  mediump vec3 tmpvar_16;
  mediump vec4 normal;
  normal = tmpvar_15;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAr, normal);
  x1.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAg, normal);
  x1.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAb, normal);
  x1.z = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBr, tmpvar_20);
  x2.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBg, tmpvar_20);
  x2.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBb, tmpvar_20);
  x2.z = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (unity_SHC.xyz * vC);
  x3 = tmpvar_25;
  tmpvar_16 = ((x1 + x2) + x3);
  shl = tmpvar_16;
  highp vec3 tmpvar_26;
  tmpvar_26 = (shl * _SHLightingScale);
  tmpvar_3 = tmpvar_26;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_10;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_10, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
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
"3.0-!!ARBvp1.0
# 53 ALU
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
MUL R1.xyz, R0.w, R0;
MOV R0.xyz, R1;
MOV R0.w, c[0].y;
DP4 R3.z, R0, c[16];
DP4 R3.y, R0, c[15];
DP4 R3.x, R0, c[14];
MUL R2, R1.xyzz, R1.yzzx;
DP4 R0.z, R2, c[19];
DP4 R0.x, R2, c[17];
DP4 R0.y, R2, c[18];
ADD R4.xyz, R3, R0;
MOV R0.xyz, vertex.attrib[14];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[7];
DP4 R2.x, R0, c[5];
DP4 R2.y, R0, c[6];
DP3 R0.x, R2, R2;
MUL R0.y, R1, R1;
MAD R0.w, R1.x, R1.x, -R0.y;
MUL R3.xyz, R0.w, c[20];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, R2;
MUL R2.xyz, R1.zxyw, R0.yzxw;
ADD R3.xyz, R4, R3;
MAD result.texcoord[7].xyz, R1.yzxw, R0.zxyw, -R2;
MOV result.texcoord[6].xyz, R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[2].xyz, R3, c[21].x;
MOV result.texcoord[1].xyz, R1;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 53 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
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
"vs_3_0
; 53 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c21, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c21.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mov r0.xyz, r1
mov r0.w, c21.y
dp4 r3.z, r0, c15
dp4 r3.y, r0, c14
dp4 r3.x, r0, c13
mul r2, r1.xyzz, r1.yzzx
dp4 r0.z, r2, c18
dp4 r0.x, r2, c16
dp4 r0.y, r2, c17
add r4.xyz, r3, r0
mov r0.xyz, v3
mov r0.w, c21.x
dp4 r2.z, r0, c6
dp4 r2.x, r0, c4
dp4 r2.y, r0, c5
dp3 r0.x, r2, r2
mul r0.y, r1, r1
mad r0.w, r1.x, r1.x, -r0.y
mul r3.xyz, r0.w, c19
rsq r0.x, r0.x
mul r0.xyz, r0.x, r2
mul r2.xyz, r1.zxyw, r0.yzxw
add r3.xyz, r4, r3
mad o8.xyz, r1.yzxw, r0.zxyw, -r2
mov o7.xyz, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o1, r0
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.w, c21.x
mov r0.xyz, v1
mul o3.xyz, r3, c20.x
mov o2.xyz, r1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * tmpvar_7).xyz;
  tmpvar_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  lowp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((modelMatrix * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((modelMatrix * tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  mediump vec3 tmpvar_16;
  mediump vec4 normal;
  normal = tmpvar_15;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAr, normal);
  x1.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAg, normal);
  x1.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAb, normal);
  x1.z = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBr, tmpvar_20);
  x2.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBg, tmpvar_20);
  x2.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBb, tmpvar_20);
  x2.z = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (unity_SHC.xyz * vC);
  x3 = tmpvar_25;
  tmpvar_16 = ((x1 + x2) + x3);
  shl = tmpvar_16;
  highp vec3 tmpvar_26;
  tmpvar_26 = (shl * _SHLightingScale);
  tmpvar_3 = tmpvar_26;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_10;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_10, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * tmpvar_7).xyz;
  tmpvar_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  lowp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((modelMatrix * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((modelMatrix * tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  mediump vec3 tmpvar_16;
  mediump vec4 normal;
  normal = tmpvar_15;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAr, normal);
  x1.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAg, normal);
  x1.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAb, normal);
  x1.z = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBr, tmpvar_20);
  x2.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBg, tmpvar_20);
  x2.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBb, tmpvar_20);
  x2.z = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (unity_SHC.xyz * vC);
  x3 = tmpvar_25;
  tmpvar_16 = ((x1 + x2) + x3);
  shl = tmpvar_16;
  highp vec3 tmpvar_26;
  tmpvar_26 = (shl * _SHLightingScale);
  tmpvar_3 = tmpvar_26;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_10;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_10, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
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
"3.0-!!ARBvp1.0
# 53 ALU
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
MUL R1.xyz, R0.w, R0;
MOV R0.xyz, R1;
MOV R0.w, c[0].y;
DP4 R3.z, R0, c[16];
DP4 R3.y, R0, c[15];
DP4 R3.x, R0, c[14];
MUL R2, R1.xyzz, R1.yzzx;
DP4 R0.z, R2, c[19];
DP4 R0.x, R2, c[17];
DP4 R0.y, R2, c[18];
ADD R4.xyz, R3, R0;
MOV R0.xyz, vertex.attrib[14];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[7];
DP4 R2.x, R0, c[5];
DP4 R2.y, R0, c[6];
DP3 R0.x, R2, R2;
MUL R0.y, R1, R1;
MAD R0.w, R1.x, R1.x, -R0.y;
MUL R3.xyz, R0.w, c[20];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, R2;
MUL R2.xyz, R1.zxyw, R0.yzxw;
ADD R3.xyz, R4, R3;
MAD result.texcoord[7].xyz, R1.yzxw, R0.zxyw, -R2;
MOV result.texcoord[6].xyz, R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[2].xyz, R3, c[21].x;
MOV result.texcoord[1].xyz, R1;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 53 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
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
"vs_3_0
; 53 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c21, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c21.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mov r0.xyz, r1
mov r0.w, c21.y
dp4 r3.z, r0, c15
dp4 r3.y, r0, c14
dp4 r3.x, r0, c13
mul r2, r1.xyzz, r1.yzzx
dp4 r0.z, r2, c18
dp4 r0.x, r2, c16
dp4 r0.y, r2, c17
add r4.xyz, r3, r0
mov r0.xyz, v3
mov r0.w, c21.x
dp4 r2.z, r0, c6
dp4 r2.x, r0, c4
dp4 r2.y, r0, c5
dp3 r0.x, r2, r2
mul r0.y, r1, r1
mad r0.w, r1.x, r1.x, -r0.y
mul r3.xyz, r0.w, c19
rsq r0.x, r0.x
mul r0.xyz, r0.x, r2
mul r2.xyz, r1.zxyw, r0.yzxw
add r3.xyz, r4, r3
mad o8.xyz, r1.yzxw, r0.zxyw, -r2
mov o7.xyz, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o1, r0
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.w, c21.x
mov r0.xyz, v1
mul o3.xyz, r3, c20.x
mov o2.xyz, r1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * tmpvar_7).xyz;
  tmpvar_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  lowp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((modelMatrix * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((modelMatrix * tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  mediump vec3 tmpvar_16;
  mediump vec4 normal;
  normal = tmpvar_15;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAr, normal);
  x1.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAg, normal);
  x1.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAb, normal);
  x1.z = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBr, tmpvar_20);
  x2.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBg, tmpvar_20);
  x2.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBb, tmpvar_20);
  x2.z = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (unity_SHC.xyz * vC);
  x3 = tmpvar_25;
  tmpvar_16 = ((x1 + x2) + x3);
  shl = tmpvar_16;
  highp vec3 tmpvar_26;
  tmpvar_26 = (shl * _SHLightingScale);
  tmpvar_3 = tmpvar_26;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_10;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_10, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * tmpvar_7).xyz;
  tmpvar_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  lowp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((modelMatrix * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((modelMatrix * tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  mediump vec3 tmpvar_16;
  mediump vec4 normal;
  normal = tmpvar_15;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAr, normal);
  x1.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAg, normal);
  x1.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAb, normal);
  x1.z = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBr, tmpvar_20);
  x2.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBg, tmpvar_20);
  x2.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBb, tmpvar_20);
  x2.z = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (unity_SHC.xyz * vC);
  x3 = tmpvar_25;
  tmpvar_16 = ((x1 + x2) + x3);
  shl = tmpvar_16;
  highp vec3 tmpvar_26;
  tmpvar_26 = (shl * _SHLightingScale);
  tmpvar_3 = tmpvar_26;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_10;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_10, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
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
"3.0-!!ARBvp1.0
# 53 ALU
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
MUL R1.xyz, R0.w, R0;
MOV R0.xyz, R1;
MOV R0.w, c[0].y;
DP4 R3.z, R0, c[16];
DP4 R3.y, R0, c[15];
DP4 R3.x, R0, c[14];
MUL R2, R1.xyzz, R1.yzzx;
DP4 R0.z, R2, c[19];
DP4 R0.x, R2, c[17];
DP4 R0.y, R2, c[18];
ADD R4.xyz, R3, R0;
MOV R0.xyz, vertex.attrib[14];
MOV R0.w, c[0].x;
DP4 R2.z, R0, c[7];
DP4 R2.x, R0, c[5];
DP4 R2.y, R0, c[6];
DP3 R0.x, R2, R2;
MUL R0.y, R1, R1;
MAD R0.w, R1.x, R1.x, -R0.y;
MUL R3.xyz, R0.w, c[20];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, R2;
MUL R2.xyz, R1.zxyw, R0.yzxw;
ADD R3.xyz, R4, R3;
MAD result.texcoord[7].xyz, R1.yzxw, R0.zxyw, -R2;
MOV result.texcoord[6].xyz, R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[2].xyz, R3, c[21].x;
MOV result.texcoord[1].xyz, R1;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 53 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
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
"vs_3_0
; 53 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c21, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c21.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mov r0.xyz, r1
mov r0.w, c21.y
dp4 r3.z, r0, c15
dp4 r3.y, r0, c14
dp4 r3.x, r0, c13
mul r2, r1.xyzz, r1.yzzx
dp4 r0.z, r2, c18
dp4 r0.x, r2, c16
dp4 r0.y, r2, c17
add r4.xyz, r3, r0
mov r0.xyz, v3
mov r0.w, c21.x
dp4 r2.z, r0, c6
dp4 r2.x, r0, c4
dp4 r2.y, r0, c5
dp3 r0.x, r2, r2
mul r0.y, r1, r1
mad r0.w, r1.x, r1.x, -r0.y
mul r3.xyz, r0.w, c19
rsq r0.x, r0.x
mul r0.xyz, r0.x, r2
mul r2.xyz, r1.zxyw, r0.yzxw
add r3.xyz, r4, r3
mad o8.xyz, r1.yzxw, r0.zxyw, -r2
mov o7.xyz, r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o1, r0
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.w, c21.x
mov r0.xyz, v1
mul o3.xyz, r3, c20.x
mov o2.xyz, r1
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * tmpvar_7).xyz;
  tmpvar_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  lowp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((modelMatrix * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((modelMatrix * tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  mediump vec3 tmpvar_16;
  mediump vec4 normal;
  normal = tmpvar_15;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAr, normal);
  x1.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAg, normal);
  x1.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAb, normal);
  x1.z = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBr, tmpvar_20);
  x2.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBg, tmpvar_20);
  x2.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBb, tmpvar_20);
  x2.z = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (unity_SHC.xyz * vC);
  x3 = tmpvar_25;
  tmpvar_16 = ((x1 + x2) + x3);
  shl = tmpvar_16;
  highp vec3 tmpvar_26;
  tmpvar_26 = (shl * _SHLightingScale);
  tmpvar_3 = tmpvar_26;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_10;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_10, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = tmpvar_1;
  highp vec3 tmpvar_8;
  tmpvar_8 = (_Object2World * tmpvar_7).xyz;
  tmpvar_5 = tmpvar_8;
  lowp vec4 tmpvar_9;
  tmpvar_9.w = 0.0;
  tmpvar_9.xyz = tmpvar_1;
  lowp vec3 tmpvar_10;
  tmpvar_10 = normalize ((tmpvar_9 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((modelMatrix * _glesVertex) - tmpvar_11).xyz);
  tmpvar_4 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((modelMatrix * tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  mediump vec3 tmpvar_16;
  mediump vec4 normal;
  normal = tmpvar_15;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_17;
  tmpvar_17 = dot (unity_SHAr, normal);
  x1.x = tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = dot (unity_SHAg, normal);
  x1.y = tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = dot (unity_SHAb, normal);
  x1.z = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_21;
  tmpvar_21 = dot (unity_SHBr, tmpvar_20);
  x2.x = tmpvar_21;
  highp float tmpvar_22;
  tmpvar_22 = dot (unity_SHBg, tmpvar_20);
  x2.y = tmpvar_22;
  highp float tmpvar_23;
  tmpvar_23 = dot (unity_SHBb, tmpvar_20);
  x2.z = tmpvar_23;
  mediump float tmpvar_24;
  tmpvar_24 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (unity_SHC.xyz * vC);
  x3 = tmpvar_25;
  tmpvar_16 = ((x1 + x2) + x3);
  shl = tmpvar_16;
  highp vec3 tmpvar_26;
  tmpvar_26 = (shl * _SHLightingScale);
  tmpvar_3 = tmpvar_26;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_10;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_10, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
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
Vector 29 [_Color]
Float 30 [_SHLightingScale]
"3.0-!!ARBvp1.0
# 117 ALU
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
MOV R0.x, c[14];
MOV R0.z, c[16].x;
MOV R0.y, c[15].x;
ADD R0.xyz, -R2, R0;
DP3 R1.w, R0, R0;
RSQ R2.w, R1.w;
MUL R0.xyz, R2.w, R0;
DP3 R0.y, R3, R0;
MUL R0.x, R1.w, c[17];
ADD R0.w, R0.x, c[0].y;
MAX R1.w, R0.y, c[0].x;
RCP R1.x, R0.w;
MUL R1.xyz, R1.x, c[18];
MUL R1.xyz, R1, c[29];
MUL R1.xyz, R1, R1.w;
MOV R0.x, c[14].y;
MOV R0.z, c[16].y;
MOV R0.y, c[15];
ADD R0.xyz, -R2, R0;
DP3 R0.w, R0, R0;
RSQ R2.w, R0.w;
MUL R0.xyz, R2.w, R0;
DP3 R0.y, R3, R0;
MAX R1.w, R0.y, c[0].x;
MUL R0.w, R0, c[17].y;
ADD R0.x, R0.w, c[0].y;
RCP R0.w, R0.x;
MUL R4.xyz, R0.w, c[19];
MUL R4.xyz, R4, c[29];
MUL R4.xyz, R4, R1.w;
ADD R1.xyz, R1, R4;
MUL R2.w, R3.y, R3.y;
MOV R0.x, c[14].z;
MOV R0.z, c[16];
MOV R0.y, c[15].z;
ADD R0.xyz, -R2, R0;
DP3 R0.w, R0, R0;
RSQ R1.w, R0.w;
MUL R0.xyz, R1.w, R0;
DP3 R0.y, R3, R0;
MAX R1.w, R0.y, c[0].x;
MUL R0.w, R0, c[17].z;
ADD R0.x, R0.w, c[0].y;
RCP R0.w, R0.x;
MUL R4.xyz, R0.w, c[20];
MUL R4.xyz, R4, c[29];
MUL R4.xyz, R4, R1.w;
ADD R1.xyz, R1, R4;
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
MUL R0.xyz, R0, c[29];
MUL R0.xyz, R0, R0.w;
ADD R4.xyz, R1, R0;
MOV R0.xyz, R3;
MOV R0.w, c[0].y;
DP4 R5.z, R0, c[24];
DP4 R5.y, R0, c[23];
DP4 R5.x, R0, c[22];
MUL R1, R3.xyzz, R3.yzzx;
DP4 R0.z, R1, c[27];
DP4 R0.x, R1, c[25];
DP4 R0.y, R1, c[26];
ADD R1.xyz, R5, R0;
MAD R1.w, R3.x, R3.x, -R2;
DP4 R2.w, vertex.position, c[8];
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R5.z, R0, c[7];
DP4 R5.x, R0, c[5];
DP4 R5.y, R0, c[6];
DP3 R0.w, R5, R5;
MUL R0.xyz, R1.w, c[28];
ADD R0.xyz, R1, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R5;
MUL R5.xyz, R0, c[30].x;
MUL R0.xyz, R3.zxyw, R1.yzxw;
MAD result.texcoord[7].xyz, R3.yzxw, R1.zxyw, -R0;
ADD R0.xyz, R2, -c[13];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
ADD result.texcoord[2].xyz, R4, R5;
MOV result.texcoord[6].xyz, R1;
MOV result.texcoord[0], R2;
MOV result.texcoord[1].xyz, R3;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 117 instructions, 6 R-regs
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
Vector 28 [_Color]
Float 29 [_SHLightingScale]
"vs_3_0
; 117 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c30, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
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
mov r0.x, c13
mov r0.z, c15.x
mov r0.y, c14.x
add r0.xyz, -r2, r0
dp3 r1.w, r0, r0
rsq r2.w, r1.w
mul r0.xyz, r2.w, r0
dp3 r0.y, r3, r0
mul r0.x, r1.w, c16
max r1.w, r0.y, c30.x
add r0.w, r0.x, c30.y
mov r0.x, c13.y
mov r0.z, c15.y
mov r0.y, c14
add r1.xyz, -r2, r0
rcp r0.x, r0.w
dp3 r0.w, r1, r1
rsq r2.w, r0.w
mul r1.xyz, r2.w, r1
dp3 r1.x, r3, r1
mul r0.xyz, r0.x, c17
mul r0.xyz, r0, c28
mul r0.xyz, r0, r1.w
max r1.w, r1.x, c30.x
mul r0.w, r0, c16.y
add r0.w, r0, c30.y
rcp r0.w, r0.w
mov r1.x, c13.z
mov r1.z, c15
mov r1.y, c14.z
add r4.xyz, -r2, r1
mul r1.xyz, r0.w, c18
mul r1.xyz, r1, c28
mul r1.xyz, r1, r1.w
dp3 r0.w, r4, r4
rsq r1.w, r0.w
add r0.xyz, r0, r1
mul r1.xyz, r1.w, r4
dp3 r1.y, r3, r1
mul r0.w, r0, c16.z
add r1.x, r0.w, c30.y
max r0.w, r1.y, c30.x
rcp r1.w, r1.x
mov r1.x, c13.w
mov r1.z, c15.w
mov r1.y, c14.w
add r4.xyz, -r2, r1
mul r1.xyz, r1.w, c19
mul r1.xyz, r1, c28
mul r1.xyz, r1, r0.w
dp3 r1.w, r4, r4
mul r0.w, r1, c16
rsq r1.w, r1.w
mul r4.xyz, r1.w, r4
add r0.w, r0, c30.y
add r0.xyz, r0, r1
dp3 r1.w, r3, r4
rcp r0.w, r0.w
mul r4.xyz, r0.w, c20
max r0.w, r1, c30.x
mul r4.xyz, r4, c28
mul r4.xyz, r4, r0.w
add r4.xyz, r0, r4
mov r0.xyz, r3
mov r0.w, c30.y
dp4 r5.z, r0, c23
dp4 r5.y, r0, c22
dp4 r5.x, r0, c21
mul r1, r3.xyzz, r3.yzzx
dp4 r0.z, r1, c26
dp4 r0.x, r1, c24
dp4 r0.y, r1, c25
add r1.xyz, r5, r0
mul r2.w, r3.y, r3.y
mad r1.w, r3.x, r3.x, -r2
dp4 r2.w, v0, c7
mov r0.w, c30.x
mov r0.xyz, v3
dp4 r5.z, r0, c6
dp4 r5.x, r0, c4
dp4 r5.y, r0, c5
dp3 r0.w, r5, r5
mul r0.xyz, r1.w, c27
add r0.xyz, r1, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r5
mul r0.xyz, r0, c29.x
mul r5.xyz, r3.zxyw, r1.yzxw
add o3.xyz, r4, r0
add r0.xyz, r2, -c12
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o5.xyz, r0.w, r0
mov r0.w, c30.x
mov r0.xyz, v1
mad o8.xyz, r3.yzxw, r1.zxyw, -r5
mov o7.xyz, r1
mov o1, r2
mov o2.xyz, r3
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 diffuseReflection;
  lowp float attenuation;
  lowp vec3 vertexToLightSource;
  lowp vec4 lightPosition;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  highp vec4 tmpvar_7;
  tmpvar_7 = (modelMatrix * _glesVertex);
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_Object2World * tmpvar_8).xyz;
  tmpvar_5 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 0.0;
  tmpvar_10.xyz = tmpvar_1;
  lowp vec3 tmpvar_11;
  tmpvar_11 = normalize ((tmpvar_10 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (((modelMatrix * _glesVertex) - tmpvar_12).xyz);
  tmpvar_4 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((modelMatrix * tmpvar_14).xyz);
  tmpvar_6 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.x = unity_4LightPosX0.x;
  tmpvar_16.y = unity_4LightPosY0.x;
  tmpvar_16.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_17;
  lowp float tmpvar_18;
  tmpvar_18 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_19;
  tmpvar_19 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_18))));
  attenuation = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_21;
  tmpvar_21 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_20);
  diffuseReflection = tmpvar_21;
  tmpvar_3 = diffuseReflection;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.x = unity_4LightPosX0.y;
  tmpvar_22.y = unity_4LightPosY0.y;
  tmpvar_22.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_25;
  tmpvar_25 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_24))));
  attenuation = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_27;
  tmpvar_27 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_26);
  diffuseReflection = tmpvar_27;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.x = unity_4LightPosX0.z;
  tmpvar_28.y = unity_4LightPosY0.z;
  tmpvar_28.z = unity_4LightPosZ0.z;
  lightPosition = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_31;
  tmpvar_31 = (1.0/((1.0 + (unity_4LightAtten0.z * tmpvar_30))));
  attenuation = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_33;
  tmpvar_33 = (((attenuation * unity_LightColor[2].xyz) * _Color.xyz) * tmpvar_32);
  diffuseReflection = tmpvar_33;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  highp vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.x = unity_4LightPosX0.w;
  tmpvar_34.y = unity_4LightPosY0.w;
  tmpvar_34.z = unity_4LightPosZ0.w;
  lightPosition = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_35;
  lowp float tmpvar_36;
  tmpvar_36 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_37;
  tmpvar_37 = (1.0/((1.0 + (unity_4LightAtten0.w * tmpvar_36))));
  attenuation = tmpvar_37;
  lowp float tmpvar_38;
  tmpvar_38 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_39;
  tmpvar_39 = (((attenuation * unity_LightColor[3].xyz) * _Color.xyz) * tmpvar_38);
  diffuseReflection = tmpvar_39;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  lowp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_11;
  mediump vec3 tmpvar_41;
  mediump vec4 normal;
  normal = tmpvar_40;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_42;
  tmpvar_42 = dot (unity_SHAr, normal);
  x1.x = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = dot (unity_SHAg, normal);
  x1.y = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = dot (unity_SHAb, normal);
  x1.z = tmpvar_44;
  mediump vec4 tmpvar_45;
  tmpvar_45 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_46;
  tmpvar_46 = dot (unity_SHBr, tmpvar_45);
  x2.x = tmpvar_46;
  highp float tmpvar_47;
  tmpvar_47 = dot (unity_SHBg, tmpvar_45);
  x2.y = tmpvar_47;
  highp float tmpvar_48;
  tmpvar_48 = dot (unity_SHBb, tmpvar_45);
  x2.z = tmpvar_48;
  mediump float tmpvar_49;
  tmpvar_49 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_49;
  highp vec3 tmpvar_50;
  tmpvar_50 = (unity_SHC.xyz * vC);
  x3 = tmpvar_50;
  tmpvar_41 = ((x1 + x2) + x3);
  shl = tmpvar_41;
  highp vec3 tmpvar_51;
  tmpvar_51 = (tmpvar_3 + (shl * _SHLightingScale));
  tmpvar_3 = tmpvar_51;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_7;
  xlv_TEXCOORD1 = tmpvar_11;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_11, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 diffuseReflection;
  lowp float attenuation;
  lowp vec3 vertexToLightSource;
  lowp vec4 lightPosition;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  highp vec4 tmpvar_7;
  tmpvar_7 = (modelMatrix * _glesVertex);
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_Object2World * tmpvar_8).xyz;
  tmpvar_5 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 0.0;
  tmpvar_10.xyz = tmpvar_1;
  lowp vec3 tmpvar_11;
  tmpvar_11 = normalize ((tmpvar_10 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (((modelMatrix * _glesVertex) - tmpvar_12).xyz);
  tmpvar_4 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((modelMatrix * tmpvar_14).xyz);
  tmpvar_6 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.x = unity_4LightPosX0.x;
  tmpvar_16.y = unity_4LightPosY0.x;
  tmpvar_16.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_17;
  lowp float tmpvar_18;
  tmpvar_18 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_19;
  tmpvar_19 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_18))));
  attenuation = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_21;
  tmpvar_21 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_20);
  diffuseReflection = tmpvar_21;
  tmpvar_3 = diffuseReflection;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.x = unity_4LightPosX0.y;
  tmpvar_22.y = unity_4LightPosY0.y;
  tmpvar_22.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_25;
  tmpvar_25 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_24))));
  attenuation = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_27;
  tmpvar_27 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_26);
  diffuseReflection = tmpvar_27;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.x = unity_4LightPosX0.z;
  tmpvar_28.y = unity_4LightPosY0.z;
  tmpvar_28.z = unity_4LightPosZ0.z;
  lightPosition = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_31;
  tmpvar_31 = (1.0/((1.0 + (unity_4LightAtten0.z * tmpvar_30))));
  attenuation = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_33;
  tmpvar_33 = (((attenuation * unity_LightColor[2].xyz) * _Color.xyz) * tmpvar_32);
  diffuseReflection = tmpvar_33;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  highp vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.x = unity_4LightPosX0.w;
  tmpvar_34.y = unity_4LightPosY0.w;
  tmpvar_34.z = unity_4LightPosZ0.w;
  lightPosition = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_35;
  lowp float tmpvar_36;
  tmpvar_36 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_37;
  tmpvar_37 = (1.0/((1.0 + (unity_4LightAtten0.w * tmpvar_36))));
  attenuation = tmpvar_37;
  lowp float tmpvar_38;
  tmpvar_38 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_39;
  tmpvar_39 = (((attenuation * unity_LightColor[3].xyz) * _Color.xyz) * tmpvar_38);
  diffuseReflection = tmpvar_39;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  lowp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_11;
  mediump vec3 tmpvar_41;
  mediump vec4 normal;
  normal = tmpvar_40;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_42;
  tmpvar_42 = dot (unity_SHAr, normal);
  x1.x = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = dot (unity_SHAg, normal);
  x1.y = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = dot (unity_SHAb, normal);
  x1.z = tmpvar_44;
  mediump vec4 tmpvar_45;
  tmpvar_45 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_46;
  tmpvar_46 = dot (unity_SHBr, tmpvar_45);
  x2.x = tmpvar_46;
  highp float tmpvar_47;
  tmpvar_47 = dot (unity_SHBg, tmpvar_45);
  x2.y = tmpvar_47;
  highp float tmpvar_48;
  tmpvar_48 = dot (unity_SHBb, tmpvar_45);
  x2.z = tmpvar_48;
  mediump float tmpvar_49;
  tmpvar_49 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_49;
  highp vec3 tmpvar_50;
  tmpvar_50 = (unity_SHC.xyz * vC);
  x3 = tmpvar_50;
  tmpvar_41 = ((x1 + x2) + x3);
  shl = tmpvar_41;
  highp vec3 tmpvar_51;
  tmpvar_51 = (tmpvar_3 + (shl * _SHLightingScale));
  tmpvar_3 = tmpvar_51;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_7;
  xlv_TEXCOORD1 = tmpvar_11;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_11, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" ATTR14
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
Vector 29 [_Color]
Float 30 [_SHLightingScale]
"3.0-!!ARBvp1.0
# 117 ALU
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
MOV R0.x, c[14];
MOV R0.z, c[16].x;
MOV R0.y, c[15].x;
ADD R0.xyz, -R2, R0;
DP3 R1.w, R0, R0;
RSQ R2.w, R1.w;
MUL R0.xyz, R2.w, R0;
DP3 R0.y, R3, R0;
MUL R0.x, R1.w, c[17];
ADD R0.w, R0.x, c[0].y;
MAX R1.w, R0.y, c[0].x;
RCP R1.x, R0.w;
MUL R1.xyz, R1.x, c[18];
MUL R1.xyz, R1, c[29];
MUL R1.xyz, R1, R1.w;
MOV R0.x, c[14].y;
MOV R0.z, c[16].y;
MOV R0.y, c[15];
ADD R0.xyz, -R2, R0;
DP3 R0.w, R0, R0;
RSQ R2.w, R0.w;
MUL R0.xyz, R2.w, R0;
DP3 R0.y, R3, R0;
MAX R1.w, R0.y, c[0].x;
MUL R0.w, R0, c[17].y;
ADD R0.x, R0.w, c[0].y;
RCP R0.w, R0.x;
MUL R4.xyz, R0.w, c[19];
MUL R4.xyz, R4, c[29];
MUL R4.xyz, R4, R1.w;
ADD R1.xyz, R1, R4;
MUL R2.w, R3.y, R3.y;
MOV R0.x, c[14].z;
MOV R0.z, c[16];
MOV R0.y, c[15].z;
ADD R0.xyz, -R2, R0;
DP3 R0.w, R0, R0;
RSQ R1.w, R0.w;
MUL R0.xyz, R1.w, R0;
DP3 R0.y, R3, R0;
MAX R1.w, R0.y, c[0].x;
MUL R0.w, R0, c[17].z;
ADD R0.x, R0.w, c[0].y;
RCP R0.w, R0.x;
MUL R4.xyz, R0.w, c[20];
MUL R4.xyz, R4, c[29];
MUL R4.xyz, R4, R1.w;
ADD R1.xyz, R1, R4;
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
MUL R0.xyz, R0, c[29];
MUL R0.xyz, R0, R0.w;
ADD R4.xyz, R1, R0;
MOV R0.xyz, R3;
MOV R0.w, c[0].y;
DP4 R5.z, R0, c[24];
DP4 R5.y, R0, c[23];
DP4 R5.x, R0, c[22];
MUL R1, R3.xyzz, R3.yzzx;
DP4 R0.z, R1, c[27];
DP4 R0.x, R1, c[25];
DP4 R0.y, R1, c[26];
ADD R1.xyz, R5, R0;
MAD R1.w, R3.x, R3.x, -R2;
DP4 R2.w, vertex.position, c[8];
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R5.z, R0, c[7];
DP4 R5.x, R0, c[5];
DP4 R5.y, R0, c[6];
DP3 R0.w, R5, R5;
MUL R0.xyz, R1.w, c[28];
ADD R0.xyz, R1, R0;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R5;
MUL R5.xyz, R0, c[30].x;
MUL R0.xyz, R3.zxyw, R1.yzxw;
MAD result.texcoord[7].xyz, R3.yzxw, R1.zxyw, -R0;
ADD R0.xyz, R2, -c[13];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
ADD result.texcoord[2].xyz, R4, R5;
MOV result.texcoord[6].xyz, R1;
MOV result.texcoord[0], R2;
MOV result.texcoord[1].xyz, R3;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 117 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "tangent" TexCoord2
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
Vector 28 [_Color]
Float 29 [_SHLightingScale]
"vs_3_0
; 117 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c30, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
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
mov r0.x, c13
mov r0.z, c15.x
mov r0.y, c14.x
add r0.xyz, -r2, r0
dp3 r1.w, r0, r0
rsq r2.w, r1.w
mul r0.xyz, r2.w, r0
dp3 r0.y, r3, r0
mul r0.x, r1.w, c16
max r1.w, r0.y, c30.x
add r0.w, r0.x, c30.y
mov r0.x, c13.y
mov r0.z, c15.y
mov r0.y, c14
add r1.xyz, -r2, r0
rcp r0.x, r0.w
dp3 r0.w, r1, r1
rsq r2.w, r0.w
mul r1.xyz, r2.w, r1
dp3 r1.x, r3, r1
mul r0.xyz, r0.x, c17
mul r0.xyz, r0, c28
mul r0.xyz, r0, r1.w
max r1.w, r1.x, c30.x
mul r0.w, r0, c16.y
add r0.w, r0, c30.y
rcp r0.w, r0.w
mov r1.x, c13.z
mov r1.z, c15
mov r1.y, c14.z
add r4.xyz, -r2, r1
mul r1.xyz, r0.w, c18
mul r1.xyz, r1, c28
mul r1.xyz, r1, r1.w
dp3 r0.w, r4, r4
rsq r1.w, r0.w
add r0.xyz, r0, r1
mul r1.xyz, r1.w, r4
dp3 r1.y, r3, r1
mul r0.w, r0, c16.z
add r1.x, r0.w, c30.y
max r0.w, r1.y, c30.x
rcp r1.w, r1.x
mov r1.x, c13.w
mov r1.z, c15.w
mov r1.y, c14.w
add r4.xyz, -r2, r1
mul r1.xyz, r1.w, c19
mul r1.xyz, r1, c28
mul r1.xyz, r1, r0.w
dp3 r1.w, r4, r4
mul r0.w, r1, c16
rsq r1.w, r1.w
mul r4.xyz, r1.w, r4
add r0.w, r0, c30.y
add r0.xyz, r0, r1
dp3 r1.w, r3, r4
rcp r0.w, r0.w
mul r4.xyz, r0.w, c20
max r0.w, r1, c30.x
mul r4.xyz, r4, c28
mul r4.xyz, r4, r0.w
add r4.xyz, r0, r4
mov r0.xyz, r3
mov r0.w, c30.y
dp4 r5.z, r0, c23
dp4 r5.y, r0, c22
dp4 r5.x, r0, c21
mul r1, r3.xyzz, r3.yzzx
dp4 r0.z, r1, c26
dp4 r0.x, r1, c24
dp4 r0.y, r1, c25
add r1.xyz, r5, r0
mul r2.w, r3.y, r3.y
mad r1.w, r3.x, r3.x, -r2
dp4 r2.w, v0, c7
mov r0.w, c30.x
mov r0.xyz, v3
dp4 r5.z, r0, c6
dp4 r5.x, r0, c4
dp4 r5.y, r0, c5
dp3 r0.w, r5, r5
mul r0.xyz, r1.w, c27
add r0.xyz, r1, r0
rsq r0.w, r0.w
mul r1.xyz, r0.w, r5
mul r0.xyz, r0, c29.x
mul r5.xyz, r3.zxyw, r1.yzxw
add o3.xyz, r4, r0
add r0.xyz, r2, -c12
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o5.xyz, r0.w, r0
mov r0.w, c30.x
mov r0.xyz, v1
mad o8.xyz, r3.yzxw, r1.zxyw, -r5
mov o7.xyz, r1
mov o1, r2
mov o2.xyz, r3
mov o4, v2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
dp4 o0.w, v0, c3
dp4 o0.z, v0, c2
dp4 o0.y, v0, c1
dp4 o0.x, v0, c0
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 diffuseReflection;
  lowp float attenuation;
  lowp vec3 vertexToLightSource;
  lowp vec4 lightPosition;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  highp vec4 tmpvar_7;
  tmpvar_7 = (modelMatrix * _glesVertex);
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_Object2World * tmpvar_8).xyz;
  tmpvar_5 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 0.0;
  tmpvar_10.xyz = tmpvar_1;
  lowp vec3 tmpvar_11;
  tmpvar_11 = normalize ((tmpvar_10 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (((modelMatrix * _glesVertex) - tmpvar_12).xyz);
  tmpvar_4 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((modelMatrix * tmpvar_14).xyz);
  tmpvar_6 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.x = unity_4LightPosX0.x;
  tmpvar_16.y = unity_4LightPosY0.x;
  tmpvar_16.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_17;
  lowp float tmpvar_18;
  tmpvar_18 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_19;
  tmpvar_19 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_18))));
  attenuation = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_21;
  tmpvar_21 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_20);
  diffuseReflection = tmpvar_21;
  tmpvar_3 = diffuseReflection;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.x = unity_4LightPosX0.y;
  tmpvar_22.y = unity_4LightPosY0.y;
  tmpvar_22.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_25;
  tmpvar_25 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_24))));
  attenuation = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_27;
  tmpvar_27 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_26);
  diffuseReflection = tmpvar_27;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.x = unity_4LightPosX0.z;
  tmpvar_28.y = unity_4LightPosY0.z;
  tmpvar_28.z = unity_4LightPosZ0.z;
  lightPosition = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_31;
  tmpvar_31 = (1.0/((1.0 + (unity_4LightAtten0.z * tmpvar_30))));
  attenuation = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_33;
  tmpvar_33 = (((attenuation * unity_LightColor[2].xyz) * _Color.xyz) * tmpvar_32);
  diffuseReflection = tmpvar_33;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  highp vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.x = unity_4LightPosX0.w;
  tmpvar_34.y = unity_4LightPosY0.w;
  tmpvar_34.z = unity_4LightPosZ0.w;
  lightPosition = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_35;
  lowp float tmpvar_36;
  tmpvar_36 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_37;
  tmpvar_37 = (1.0/((1.0 + (unity_4LightAtten0.w * tmpvar_36))));
  attenuation = tmpvar_37;
  lowp float tmpvar_38;
  tmpvar_38 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_39;
  tmpvar_39 = (((attenuation * unity_LightColor[3].xyz) * _Color.xyz) * tmpvar_38);
  diffuseReflection = tmpvar_39;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  lowp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_11;
  mediump vec3 tmpvar_41;
  mediump vec4 normal;
  normal = tmpvar_40;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_42;
  tmpvar_42 = dot (unity_SHAr, normal);
  x1.x = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = dot (unity_SHAg, normal);
  x1.y = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = dot (unity_SHAb, normal);
  x1.z = tmpvar_44;
  mediump vec4 tmpvar_45;
  tmpvar_45 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_46;
  tmpvar_46 = dot (unity_SHBr, tmpvar_45);
  x2.x = tmpvar_46;
  highp float tmpvar_47;
  tmpvar_47 = dot (unity_SHBg, tmpvar_45);
  x2.y = tmpvar_47;
  highp float tmpvar_48;
  tmpvar_48 = dot (unity_SHBb, tmpvar_45);
  x2.z = tmpvar_48;
  mediump float tmpvar_49;
  tmpvar_49 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_49;
  highp vec3 tmpvar_50;
  tmpvar_50 = (unity_SHC.xyz * vC);
  x3 = tmpvar_50;
  tmpvar_41 = ((x1 + x2) + x3);
  shl = tmpvar_41;
  highp vec3 tmpvar_51;
  tmpvar_51 = (tmpvar_3 + (shl * _SHLightingScale));
  tmpvar_3 = tmpvar_51;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_7;
  xlv_TEXCOORD1 = tmpvar_11;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_11, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
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

varying lowp vec3 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
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
  highp vec3 shl;
  lowp vec3 diffuseReflection;
  lowp float attenuation;
  lowp vec3 vertexToLightSource;
  lowp vec4 lightPosition;
  lowp vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  highp vec4 tmpvar_7;
  tmpvar_7 = (modelMatrix * _glesVertex);
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = (_Object2World * tmpvar_8).xyz;
  tmpvar_5 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 0.0;
  tmpvar_10.xyz = tmpvar_1;
  lowp vec3 tmpvar_11;
  tmpvar_11 = normalize ((tmpvar_10 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (((modelMatrix * _glesVertex) - tmpvar_12).xyz);
  tmpvar_4 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((modelMatrix * tmpvar_14).xyz);
  tmpvar_6 = tmpvar_15;
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.x = unity_4LightPosX0.x;
  tmpvar_16.y = unity_4LightPosY0.x;
  tmpvar_16.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_17;
  lowp float tmpvar_18;
  tmpvar_18 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_19;
  tmpvar_19 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_18))));
  attenuation = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_21;
  tmpvar_21 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_20);
  diffuseReflection = tmpvar_21;
  tmpvar_3 = diffuseReflection;
  highp vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.x = unity_4LightPosX0.y;
  tmpvar_22.y = unity_4LightPosY0.y;
  tmpvar_22.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_25;
  tmpvar_25 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_24))));
  attenuation = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_27;
  tmpvar_27 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_26);
  diffuseReflection = tmpvar_27;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  highp vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.x = unity_4LightPosX0.z;
  tmpvar_28.y = unity_4LightPosY0.z;
  tmpvar_28.z = unity_4LightPosZ0.z;
  lightPosition = tmpvar_28;
  highp vec3 tmpvar_29;
  tmpvar_29 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_29;
  lowp float tmpvar_30;
  tmpvar_30 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_31;
  tmpvar_31 = (1.0/((1.0 + (unity_4LightAtten0.z * tmpvar_30))));
  attenuation = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_33;
  tmpvar_33 = (((attenuation * unity_LightColor[2].xyz) * _Color.xyz) * tmpvar_32);
  diffuseReflection = tmpvar_33;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  highp vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.x = unity_4LightPosX0.w;
  tmpvar_34.y = unity_4LightPosY0.w;
  tmpvar_34.z = unity_4LightPosZ0.w;
  lightPosition = tmpvar_34;
  highp vec3 tmpvar_35;
  tmpvar_35 = (lightPosition - tmpvar_7).xyz;
  vertexToLightSource = tmpvar_35;
  lowp float tmpvar_36;
  tmpvar_36 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_37;
  tmpvar_37 = (1.0/((1.0 + (unity_4LightAtten0.w * tmpvar_36))));
  attenuation = tmpvar_37;
  lowp float tmpvar_38;
  tmpvar_38 = max (0.0, dot (tmpvar_11, normalize (vertexToLightSource)));
  highp vec3 tmpvar_39;
  tmpvar_39 = (((attenuation * unity_LightColor[3].xyz) * _Color.xyz) * tmpvar_38);
  diffuseReflection = tmpvar_39;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
  lowp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_11;
  mediump vec3 tmpvar_41;
  mediump vec4 normal;
  normal = tmpvar_40;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_42;
  tmpvar_42 = dot (unity_SHAr, normal);
  x1.x = tmpvar_42;
  highp float tmpvar_43;
  tmpvar_43 = dot (unity_SHAg, normal);
  x1.y = tmpvar_43;
  highp float tmpvar_44;
  tmpvar_44 = dot (unity_SHAb, normal);
  x1.z = tmpvar_44;
  mediump vec4 tmpvar_45;
  tmpvar_45 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_46;
  tmpvar_46 = dot (unity_SHBr, tmpvar_45);
  x2.x = tmpvar_46;
  highp float tmpvar_47;
  tmpvar_47 = dot (unity_SHBg, tmpvar_45);
  x2.y = tmpvar_47;
  highp float tmpvar_48;
  tmpvar_48 = dot (unity_SHBb, tmpvar_45);
  x2.z = tmpvar_48;
  mediump float tmpvar_49;
  tmpvar_49 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_49;
  highp vec3 tmpvar_50;
  tmpvar_50 = (unity_SHC.xyz * vC);
  x3 = tmpvar_50;
  tmpvar_41 = ((x1 + x2) + x3);
  shl = tmpvar_41;
  highp vec3 tmpvar_51;
  tmpvar_51 = (tmpvar_3 + (shl * _SHLightingScale));
  tmpvar_3 = tmpvar_51;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_7;
  xlv_TEXCOORD1 = tmpvar_11;
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_4;
  xlv_TEXCOORD5 = tmpvar_5;
  xlv_TEXCOORD6 = tmpvar_6;
  xlv_TEXCOORD7 = cross (tmpvar_11, tmpvar_6);
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

varying lowp vec3 xlv_TEXCOORD7;
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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
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
  mediump vec2 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, tmpvar_3);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * _Gloss);
  specularReflection = tmpvar_11;
  lowp mat3 tmpvar_12;
  tmpvar_12[0] = xlv_TEXCOORD6;
  tmpvar_12[1] = xlv_TEXCOORD7;
  tmpvar_12[2] = xlv_TEXCOORD5;
  mat3 tmpvar_13;
  tmpvar_13[0].x = tmpvar_12[0].x;
  tmpvar_13[0].y = tmpvar_12[1].x;
  tmpvar_13[0].z = tmpvar_12[2].x;
  tmpvar_13[1].x = tmpvar_12[0].y;
  tmpvar_13[1].y = tmpvar_12[1].y;
  tmpvar_13[1].z = tmpvar_12[2].y;
  tmpvar_13[2].x = tmpvar_12[0].z;
  tmpvar_13[2].y = tmpvar_12[1].z;
  tmpvar_13[2].z = tmpvar_12[2].z;
  mat3 tmpvar_14;
  tmpvar_14[0].x = tmpvar_13[0].x;
  tmpvar_14[0].y = tmpvar_13[1].x;
  tmpvar_14[0].z = tmpvar_13[2].x;
  tmpvar_14[1].x = tmpvar_13[0].y;
  tmpvar_14[1].y = tmpvar_13[1].y;
  tmpvar_14[1].z = tmpvar_13[2].y;
  tmpvar_14[2].x = tmpvar_13[0].z;
  tmpvar_14[2].y = tmpvar_13[1].z;
  tmpvar_14[2].z = tmpvar_13[2].z;
  lowp float tmpvar_15;
  tmpvar_15 = clamp (dot (normalize ((tmpvar_14 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_16;
  tmpvar_16 = (tmpvar_15 * tmpvar_15);
  mediump vec4 tmpvar_17;
  tmpvar_17 = (pow (tmpvar_16, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_17;
  lowp vec3 tmpvar_18;
  tmpvar_18 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_Cube, tmpvar_18);
  reflTex = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = clamp (abs (dot (tmpvar_18, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_21;
  tmpvar_21 = pow ((1.0 - tmpvar_20), _FrezFalloff);
  frez = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = (frez * _FrezPow);
  frez = tmpvar_22;
  reflTex.xyz = (tmpvar_19.xyz * clamp ((_Reflection + tmpvar_22), 0.0, 1.0));
  lowp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + (paintColor * _FlakePower));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + reflTex) + (tmpvar_22 * reflTex));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 83 to 83, TEX: 3 to 3
//   d3d9 - ALU: 85 to 85, TEX: 3 to 3
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Vector 1 [_WorldSpaceCameraPos]
Vector 2 [_WorldSpaceLightPos0]
Vector 3 [_Color]
Float 4 [_Reflection]
Vector 5 [_SpecColor]
Float 6 [_Shininess]
Float 7 [_Gloss]
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_OuterFlakePower]
Vector 11 [_paintColor2]
Float 12 [_FrezPow]
Float 13 [_FrezFalloff]
Vector 14 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 83 ALU, 3 TEX
PARAM c[17] = { state.lightmodel.ambient,
		program.local[1..14],
		{ 2, 1, 20, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R0, R0;
RSQ R2.w, R0.w;
ABS R0.w, -c[2];
DP3 R1.x, c[2], c[2];
CMP R0.w, -R0, c[15], c[15].y;
ABS R0.w, R0;
CMP R1.w, -R0, c[15], c[15].y;
RSQ R1.x, R1.x;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, fragment.texcoord[1];
MUL R1.xyz, R1.x, c[2];
MUL R0.xyz, R2.w, R0;
CMP R0.xyz, -R1.w, R0, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R1.x, R3, R3;
RSQ R3.w, R1.x;
DP3 R0.w, R2, R0;
MUL R1.xyz, R2, -R0.w;
MAD R0.xyz, -R1, c[15].x, -R0;
MUL R3.xyz, R3.w, R3;
DP3 R0.x, R0, R3;
SLT R0.y, R0.w, c[15].w;
ABS R1.x, R0.y;
MAX R0.x, R0, c[15].w;
POW R1.y, R0.x, c[6].x;
CMP R0.x, -R1.w, R2.w, c[15].y;
MUL R3.xyz, R0.x, c[14];
MUL R0.xyz, R3, c[5];
MUL R0.xyz, R0, R1.y;
CMP R1.z, -R1.x, c[15].w, c[15].y;
CMP R4.xyz, -R1.z, R0, c[15].w;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R1, c[15].z;
TEX R0.xyz, R0, texture[1], 2D;
MOV R1.xy, c[16];
MAD R1.xyz, R0, c[15].x, R1.xxyw;
MOV R0.x, fragment.texcoord[6].z;
MOV R0.y, fragment.texcoord[7].z;
MOV R0.z, fragment.texcoord[5];
DP3 R5.z, R0, -R1;
MOV R0.x, fragment.texcoord[6];
MOV R0.z, fragment.texcoord[5].x;
MOV R0.y, fragment.texcoord[7].x;
DP3 R5.x, -R1, R0;
MOV R0.x, fragment.texcoord[6].y;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.y, fragment.texcoord[7];
DP3 R5.y, -R1, R0;
DP3 R0.x, R5, R5;
RSQ R1.w, R0.x;
MOV R0.xyz, c[3];
MUL R1.xyz, R4, c[7].x;
MAX R0.w, R0, c[15];
MAD R0.xyz, R0, c[0], fragment.texcoord[2];
MUL R3.xyz, R3, c[3];
MAD_SAT R3.xyz, R3, R0.w, R0;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R2.xyz, R2, R0.w;
MAD R2.xyz, -R2, c[15].x, fragment.texcoord[4];
TEX R0.xyz, fragment.texcoord[3], texture[0], 2D;
MAD R0.xyz, R0, R3, R1;
MUL R1.xyz, R1.w, R5;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.x, R1, R3;
DP3 R0.w, R2, fragment.texcoord[1];
MUL R1.x, R1, R1;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[15].y;
POW R2.w, R0.w, c[13].x;
MUL R2.w, R2, c[12].x;
POW R1.x, R1.x, c[10].x;
MUL R1, R1.x, c[11];
MOV R0.w, c[15].y;
MAD R0, R1, c[9].x, R0;
TEX R1, R2, texture[2], CUBE;
ADD_SAT R3.x, R2.w, c[4];
MUL R1.xyz, R1, R3.x;
ADD R0, R1, R0;
MAD result.color, R2.w, R1, R0;
END
# 83 instructions, 6 R-regs
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_OuterFlakePower]
Vector 11 [_paintColor2]
Float 12 [_FrezPow]
Float 13 [_FrezFalloff]
Vector 14 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 85 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c15, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c16, 2.00000000, -1.00000000, 3.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7.xyz
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r3.w, r0.w
dp3_pp r1.x, c2, c2
abs_pp r0.w, -c2
cmp_pp r0.w, -r0, c15.y, c15.z
abs_pp r2.w, r0
rsq_pp r1.x, r1.x
dp3_pp r0.w, v1, v1
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, v1
mul_pp r1.xyz, r1.x, c2
mul_pp r0.xyz, r3.w, r0
cmp_pp r0.xyz, -r2.w, r0, r1
add r3.xyz, -v0, c1
dp3 r1.x, r3, r3
rsq r1.w, r1.x
dp3_pp r0.w, r2, r0
mul_pp r1.xyz, r2, -r0.w
mad_pp r0.xyz, -r1, c15.x, -r0
mul r3.xyz, r1.w, r3
dp3_pp r0.x, r0, r3
max_pp r0.x, r0, c15.z
pow_pp r1, r0.x, c6.x
cmp_pp r0.x, -r2.w, r3.w, c15.y
mul_pp r3.xyz, r0.x, c14
mul_pp r0.xyz, r3, c5
mul_pp r1.xyz, r0, r1.x
cmp_pp r0.z, r0.w, c15, c15.y
abs_pp r1.w, r0.z
mul_pp r0.xy, v3, c8.x
mul_pp r0.xy, r0, c15.w
texld r0.xyz, r0, s1
cmp_pp r4.xyz, -r1.w, r1, c15.z
mad_pp r1.xyz, r0, c16.x, c16.yyzw
mov r0.x, v6.z
mov r0.y, v7.z
mov r0.z, v5
dp3_pp r5.z, r0, -r1
mov r0.x, v6
mov r0.z, v5.x
mov r0.y, v7.x
dp3_pp r5.x, -r1, r0
mov r0.x, v6.y
mov r0.z, v5.y
mov r0.y, v7
dp3_pp r5.y, -r1, r0
dp3_pp r0.x, r5, r5
rsq_pp r1.w, r0.x
mov_pp r0.xyz, c0
mul_pp r1.xyz, r4, c7.x
max_pp r0.w, r0, c15.z
mad_pp r0.xyz, c3, r0, v2
mul_pp r3.xyz, r3, c3
mad_pp_sat r3.xyz, r3, r0.w, r0
dp3_pp r0.w, r2, v4
mul_pp r2.xyz, r2, r0.w
mad_pp r2.xyz, -r2, c15.x, v4
texld r0.xyz, v3, s0
mad_pp r0.xyz, r0, r3, r1
mul_pp r1.xyz, r1.w, r5
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r1.w, v4
dp3_pp_sat r1.x, r1, r3
mul_pp r2.w, r1.x, r1.x
pow_pp r1, r2.w, c10.x
dp3_pp r0.w, r2, v1
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c15.y
pow_pp r3, r0.w, c13.x
mov_pp r0.w, r1.x
mul_pp r1, r0.w, c11
mov_pp r2.w, r3.x
mul_pp r2.w, r2, c12.x
mov_pp r0.w, c15.y
mad_pp r0, r1, c9.x, r0
texld r1, r2, s2
add_pp_sat r3.x, r2.w, c4
mul_pp r1.xyz, r1, r3.x
add_pp r0, r1, r0
mad_pp oC0, r2.w, r1, r0
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_OuterFlakePower]
Vector 11 [_paintColor2]
Float 12 [_FrezPow]
Float 13 [_FrezFalloff]
Vector 14 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 83 ALU, 3 TEX
PARAM c[17] = { state.lightmodel.ambient,
		program.local[1..14],
		{ 2, 1, 20, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R0, R0;
RSQ R2.w, R0.w;
ABS R0.w, -c[2];
DP3 R1.x, c[2], c[2];
CMP R0.w, -R0, c[15], c[15].y;
ABS R0.w, R0;
CMP R1.w, -R0, c[15], c[15].y;
RSQ R1.x, R1.x;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, fragment.texcoord[1];
MUL R1.xyz, R1.x, c[2];
MUL R0.xyz, R2.w, R0;
CMP R0.xyz, -R1.w, R0, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R1.x, R3, R3;
RSQ R3.w, R1.x;
DP3 R0.w, R2, R0;
MUL R1.xyz, R2, -R0.w;
MAD R0.xyz, -R1, c[15].x, -R0;
MUL R3.xyz, R3.w, R3;
DP3 R0.x, R0, R3;
SLT R0.y, R0.w, c[15].w;
ABS R1.x, R0.y;
MAX R0.x, R0, c[15].w;
POW R1.y, R0.x, c[6].x;
CMP R0.x, -R1.w, R2.w, c[15].y;
MUL R3.xyz, R0.x, c[14];
MUL R0.xyz, R3, c[5];
MUL R0.xyz, R0, R1.y;
CMP R1.z, -R1.x, c[15].w, c[15].y;
CMP R4.xyz, -R1.z, R0, c[15].w;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R1, c[15].z;
TEX R0.xyz, R0, texture[1], 2D;
MOV R1.xy, c[16];
MAD R1.xyz, R0, c[15].x, R1.xxyw;
MOV R0.x, fragment.texcoord[6].z;
MOV R0.y, fragment.texcoord[7].z;
MOV R0.z, fragment.texcoord[5];
DP3 R5.z, R0, -R1;
MOV R0.x, fragment.texcoord[6];
MOV R0.z, fragment.texcoord[5].x;
MOV R0.y, fragment.texcoord[7].x;
DP3 R5.x, -R1, R0;
MOV R0.x, fragment.texcoord[6].y;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.y, fragment.texcoord[7];
DP3 R5.y, -R1, R0;
DP3 R0.x, R5, R5;
RSQ R1.w, R0.x;
MOV R0.xyz, c[3];
MUL R1.xyz, R4, c[7].x;
MAX R0.w, R0, c[15];
MAD R0.xyz, R0, c[0], fragment.texcoord[2];
MUL R3.xyz, R3, c[3];
MAD_SAT R3.xyz, R3, R0.w, R0;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R2.xyz, R2, R0.w;
MAD R2.xyz, -R2, c[15].x, fragment.texcoord[4];
TEX R0.xyz, fragment.texcoord[3], texture[0], 2D;
MAD R0.xyz, R0, R3, R1;
MUL R1.xyz, R1.w, R5;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.x, R1, R3;
DP3 R0.w, R2, fragment.texcoord[1];
MUL R1.x, R1, R1;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[15].y;
POW R2.w, R0.w, c[13].x;
MUL R2.w, R2, c[12].x;
POW R1.x, R1.x, c[10].x;
MUL R1, R1.x, c[11];
MOV R0.w, c[15].y;
MAD R0, R1, c[9].x, R0;
TEX R1, R2, texture[2], CUBE;
ADD_SAT R3.x, R2.w, c[4];
MUL R1.xyz, R1, R3.x;
ADD R0, R1, R0;
MAD result.color, R2.w, R1, R0;
END
# 83 instructions, 6 R-regs
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_OuterFlakePower]
Vector 11 [_paintColor2]
Float 12 [_FrezPow]
Float 13 [_FrezFalloff]
Vector 14 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 85 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c15, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c16, 2.00000000, -1.00000000, 3.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7.xyz
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r3.w, r0.w
dp3_pp r1.x, c2, c2
abs_pp r0.w, -c2
cmp_pp r0.w, -r0, c15.y, c15.z
abs_pp r2.w, r0
rsq_pp r1.x, r1.x
dp3_pp r0.w, v1, v1
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, v1
mul_pp r1.xyz, r1.x, c2
mul_pp r0.xyz, r3.w, r0
cmp_pp r0.xyz, -r2.w, r0, r1
add r3.xyz, -v0, c1
dp3 r1.x, r3, r3
rsq r1.w, r1.x
dp3_pp r0.w, r2, r0
mul_pp r1.xyz, r2, -r0.w
mad_pp r0.xyz, -r1, c15.x, -r0
mul r3.xyz, r1.w, r3
dp3_pp r0.x, r0, r3
max_pp r0.x, r0, c15.z
pow_pp r1, r0.x, c6.x
cmp_pp r0.x, -r2.w, r3.w, c15.y
mul_pp r3.xyz, r0.x, c14
mul_pp r0.xyz, r3, c5
mul_pp r1.xyz, r0, r1.x
cmp_pp r0.z, r0.w, c15, c15.y
abs_pp r1.w, r0.z
mul_pp r0.xy, v3, c8.x
mul_pp r0.xy, r0, c15.w
texld r0.xyz, r0, s1
cmp_pp r4.xyz, -r1.w, r1, c15.z
mad_pp r1.xyz, r0, c16.x, c16.yyzw
mov r0.x, v6.z
mov r0.y, v7.z
mov r0.z, v5
dp3_pp r5.z, r0, -r1
mov r0.x, v6
mov r0.z, v5.x
mov r0.y, v7.x
dp3_pp r5.x, -r1, r0
mov r0.x, v6.y
mov r0.z, v5.y
mov r0.y, v7
dp3_pp r5.y, -r1, r0
dp3_pp r0.x, r5, r5
rsq_pp r1.w, r0.x
mov_pp r0.xyz, c0
mul_pp r1.xyz, r4, c7.x
max_pp r0.w, r0, c15.z
mad_pp r0.xyz, c3, r0, v2
mul_pp r3.xyz, r3, c3
mad_pp_sat r3.xyz, r3, r0.w, r0
dp3_pp r0.w, r2, v4
mul_pp r2.xyz, r2, r0.w
mad_pp r2.xyz, -r2, c15.x, v4
texld r0.xyz, v3, s0
mad_pp r0.xyz, r0, r3, r1
mul_pp r1.xyz, r1.w, r5
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r1.w, v4
dp3_pp_sat r1.x, r1, r3
mul_pp r2.w, r1.x, r1.x
pow_pp r1, r2.w, c10.x
dp3_pp r0.w, r2, v1
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c15.y
pow_pp r3, r0.w, c13.x
mov_pp r0.w, r1.x
mul_pp r1, r0.w, c11
mov_pp r2.w, r3.x
mul_pp r2.w, r2, c12.x
mov_pp r0.w, c15.y
mad_pp r0, r1, c9.x, r0
texld r1, r2, s2
add_pp_sat r3.x, r2.w, c4
mul_pp r1.xyz, r1, r3.x
add_pp r0, r1, r0
mad_pp oC0, r2.w, r1, r0
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_OuterFlakePower]
Vector 11 [_paintColor2]
Float 12 [_FrezPow]
Float 13 [_FrezFalloff]
Vector 14 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 83 ALU, 3 TEX
PARAM c[17] = { state.lightmodel.ambient,
		program.local[1..14],
		{ 2, 1, 20, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R0, R0;
RSQ R2.w, R0.w;
ABS R0.w, -c[2];
DP3 R1.x, c[2], c[2];
CMP R0.w, -R0, c[15], c[15].y;
ABS R0.w, R0;
CMP R1.w, -R0, c[15], c[15].y;
RSQ R1.x, R1.x;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, fragment.texcoord[1];
MUL R1.xyz, R1.x, c[2];
MUL R0.xyz, R2.w, R0;
CMP R0.xyz, -R1.w, R0, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R1.x, R3, R3;
RSQ R3.w, R1.x;
DP3 R0.w, R2, R0;
MUL R1.xyz, R2, -R0.w;
MAD R0.xyz, -R1, c[15].x, -R0;
MUL R3.xyz, R3.w, R3;
DP3 R0.x, R0, R3;
SLT R0.y, R0.w, c[15].w;
ABS R1.x, R0.y;
MAX R0.x, R0, c[15].w;
POW R1.y, R0.x, c[6].x;
CMP R0.x, -R1.w, R2.w, c[15].y;
MUL R3.xyz, R0.x, c[14];
MUL R0.xyz, R3, c[5];
MUL R0.xyz, R0, R1.y;
CMP R1.z, -R1.x, c[15].w, c[15].y;
CMP R4.xyz, -R1.z, R0, c[15].w;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R1, c[15].z;
TEX R0.xyz, R0, texture[1], 2D;
MOV R1.xy, c[16];
MAD R1.xyz, R0, c[15].x, R1.xxyw;
MOV R0.x, fragment.texcoord[6].z;
MOV R0.y, fragment.texcoord[7].z;
MOV R0.z, fragment.texcoord[5];
DP3 R5.z, R0, -R1;
MOV R0.x, fragment.texcoord[6];
MOV R0.z, fragment.texcoord[5].x;
MOV R0.y, fragment.texcoord[7].x;
DP3 R5.x, -R1, R0;
MOV R0.x, fragment.texcoord[6].y;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.y, fragment.texcoord[7];
DP3 R5.y, -R1, R0;
DP3 R0.x, R5, R5;
RSQ R1.w, R0.x;
MOV R0.xyz, c[3];
MUL R1.xyz, R4, c[7].x;
MAX R0.w, R0, c[15];
MAD R0.xyz, R0, c[0], fragment.texcoord[2];
MUL R3.xyz, R3, c[3];
MAD_SAT R3.xyz, R3, R0.w, R0;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R2.xyz, R2, R0.w;
MAD R2.xyz, -R2, c[15].x, fragment.texcoord[4];
TEX R0.xyz, fragment.texcoord[3], texture[0], 2D;
MAD R0.xyz, R0, R3, R1;
MUL R1.xyz, R1.w, R5;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.x, R1, R3;
DP3 R0.w, R2, fragment.texcoord[1];
MUL R1.x, R1, R1;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[15].y;
POW R2.w, R0.w, c[13].x;
MUL R2.w, R2, c[12].x;
POW R1.x, R1.x, c[10].x;
MUL R1, R1.x, c[11];
MOV R0.w, c[15].y;
MAD R0, R1, c[9].x, R0;
TEX R1, R2, texture[2], CUBE;
ADD_SAT R3.x, R2.w, c[4];
MUL R1.xyz, R1, R3.x;
ADD R0, R1, R0;
MAD result.color, R2.w, R1, R0;
END
# 83 instructions, 6 R-regs
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_OuterFlakePower]
Vector 11 [_paintColor2]
Float 12 [_FrezPow]
Float 13 [_FrezFalloff]
Vector 14 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 85 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c15, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c16, 2.00000000, -1.00000000, 3.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7.xyz
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r3.w, r0.w
dp3_pp r1.x, c2, c2
abs_pp r0.w, -c2
cmp_pp r0.w, -r0, c15.y, c15.z
abs_pp r2.w, r0
rsq_pp r1.x, r1.x
dp3_pp r0.w, v1, v1
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, v1
mul_pp r1.xyz, r1.x, c2
mul_pp r0.xyz, r3.w, r0
cmp_pp r0.xyz, -r2.w, r0, r1
add r3.xyz, -v0, c1
dp3 r1.x, r3, r3
rsq r1.w, r1.x
dp3_pp r0.w, r2, r0
mul_pp r1.xyz, r2, -r0.w
mad_pp r0.xyz, -r1, c15.x, -r0
mul r3.xyz, r1.w, r3
dp3_pp r0.x, r0, r3
max_pp r0.x, r0, c15.z
pow_pp r1, r0.x, c6.x
cmp_pp r0.x, -r2.w, r3.w, c15.y
mul_pp r3.xyz, r0.x, c14
mul_pp r0.xyz, r3, c5
mul_pp r1.xyz, r0, r1.x
cmp_pp r0.z, r0.w, c15, c15.y
abs_pp r1.w, r0.z
mul_pp r0.xy, v3, c8.x
mul_pp r0.xy, r0, c15.w
texld r0.xyz, r0, s1
cmp_pp r4.xyz, -r1.w, r1, c15.z
mad_pp r1.xyz, r0, c16.x, c16.yyzw
mov r0.x, v6.z
mov r0.y, v7.z
mov r0.z, v5
dp3_pp r5.z, r0, -r1
mov r0.x, v6
mov r0.z, v5.x
mov r0.y, v7.x
dp3_pp r5.x, -r1, r0
mov r0.x, v6.y
mov r0.z, v5.y
mov r0.y, v7
dp3_pp r5.y, -r1, r0
dp3_pp r0.x, r5, r5
rsq_pp r1.w, r0.x
mov_pp r0.xyz, c0
mul_pp r1.xyz, r4, c7.x
max_pp r0.w, r0, c15.z
mad_pp r0.xyz, c3, r0, v2
mul_pp r3.xyz, r3, c3
mad_pp_sat r3.xyz, r3, r0.w, r0
dp3_pp r0.w, r2, v4
mul_pp r2.xyz, r2, r0.w
mad_pp r2.xyz, -r2, c15.x, v4
texld r0.xyz, v3, s0
mad_pp r0.xyz, r0, r3, r1
mul_pp r1.xyz, r1.w, r5
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r1.w, v4
dp3_pp_sat r1.x, r1, r3
mul_pp r2.w, r1.x, r1.x
pow_pp r1, r2.w, c10.x
dp3_pp r0.w, r2, v1
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c15.y
pow_pp r3, r0.w, c13.x
mov_pp r0.w, r1.x
mul_pp r1, r0.w, c11
mov_pp r2.w, r3.x
mul_pp r2.w, r2, c12.x
mov_pp r0.w, c15.y
mad_pp r0, r1, c9.x, r0
texld r1, r2, s2
add_pp_sat r3.x, r2.w, c4
mul_pp r1.xyz, r1, r3.x
add_pp r0, r1, r0
mad_pp oC0, r2.w, r1, r0
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_OuterFlakePower]
Vector 11 [_paintColor2]
Float 12 [_FrezPow]
Float 13 [_FrezFalloff]
Vector 14 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 83 ALU, 3 TEX
PARAM c[17] = { state.lightmodel.ambient,
		program.local[1..14],
		{ 2, 1, 20, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R0, R0;
RSQ R2.w, R0.w;
ABS R0.w, -c[2];
DP3 R1.x, c[2], c[2];
CMP R0.w, -R0, c[15], c[15].y;
ABS R0.w, R0;
CMP R1.w, -R0, c[15], c[15].y;
RSQ R1.x, R1.x;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, fragment.texcoord[1];
MUL R1.xyz, R1.x, c[2];
MUL R0.xyz, R2.w, R0;
CMP R0.xyz, -R1.w, R0, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R1.x, R3, R3;
RSQ R3.w, R1.x;
DP3 R0.w, R2, R0;
MUL R1.xyz, R2, -R0.w;
MAD R0.xyz, -R1, c[15].x, -R0;
MUL R3.xyz, R3.w, R3;
DP3 R0.x, R0, R3;
SLT R0.y, R0.w, c[15].w;
ABS R1.x, R0.y;
MAX R0.x, R0, c[15].w;
POW R1.y, R0.x, c[6].x;
CMP R0.x, -R1.w, R2.w, c[15].y;
MUL R3.xyz, R0.x, c[14];
MUL R0.xyz, R3, c[5];
MUL R0.xyz, R0, R1.y;
CMP R1.z, -R1.x, c[15].w, c[15].y;
CMP R4.xyz, -R1.z, R0, c[15].w;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R1, c[15].z;
TEX R0.xyz, R0, texture[1], 2D;
MOV R1.xy, c[16];
MAD R1.xyz, R0, c[15].x, R1.xxyw;
MOV R0.x, fragment.texcoord[6].z;
MOV R0.y, fragment.texcoord[7].z;
MOV R0.z, fragment.texcoord[5];
DP3 R5.z, R0, -R1;
MOV R0.x, fragment.texcoord[6];
MOV R0.z, fragment.texcoord[5].x;
MOV R0.y, fragment.texcoord[7].x;
DP3 R5.x, -R1, R0;
MOV R0.x, fragment.texcoord[6].y;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.y, fragment.texcoord[7];
DP3 R5.y, -R1, R0;
DP3 R0.x, R5, R5;
RSQ R1.w, R0.x;
MOV R0.xyz, c[3];
MUL R1.xyz, R4, c[7].x;
MAX R0.w, R0, c[15];
MAD R0.xyz, R0, c[0], fragment.texcoord[2];
MUL R3.xyz, R3, c[3];
MAD_SAT R3.xyz, R3, R0.w, R0;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R2.xyz, R2, R0.w;
MAD R2.xyz, -R2, c[15].x, fragment.texcoord[4];
TEX R0.xyz, fragment.texcoord[3], texture[0], 2D;
MAD R0.xyz, R0, R3, R1;
MUL R1.xyz, R1.w, R5;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.x, R1, R3;
DP3 R0.w, R2, fragment.texcoord[1];
MUL R1.x, R1, R1;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[15].y;
POW R2.w, R0.w, c[13].x;
MUL R2.w, R2, c[12].x;
POW R1.x, R1.x, c[10].x;
MUL R1, R1.x, c[11];
MOV R0.w, c[15].y;
MAD R0, R1, c[9].x, R0;
TEX R1, R2, texture[2], CUBE;
ADD_SAT R3.x, R2.w, c[4];
MUL R1.xyz, R1, R3.x;
ADD R0, R1, R0;
MAD result.color, R2.w, R1, R0;
END
# 83 instructions, 6 R-regs
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_OuterFlakePower]
Vector 11 [_paintColor2]
Float 12 [_FrezPow]
Float 13 [_FrezFalloff]
Vector 14 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 85 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c15, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c16, 2.00000000, -1.00000000, 3.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7.xyz
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r3.w, r0.w
dp3_pp r1.x, c2, c2
abs_pp r0.w, -c2
cmp_pp r0.w, -r0, c15.y, c15.z
abs_pp r2.w, r0
rsq_pp r1.x, r1.x
dp3_pp r0.w, v1, v1
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, v1
mul_pp r1.xyz, r1.x, c2
mul_pp r0.xyz, r3.w, r0
cmp_pp r0.xyz, -r2.w, r0, r1
add r3.xyz, -v0, c1
dp3 r1.x, r3, r3
rsq r1.w, r1.x
dp3_pp r0.w, r2, r0
mul_pp r1.xyz, r2, -r0.w
mad_pp r0.xyz, -r1, c15.x, -r0
mul r3.xyz, r1.w, r3
dp3_pp r0.x, r0, r3
max_pp r0.x, r0, c15.z
pow_pp r1, r0.x, c6.x
cmp_pp r0.x, -r2.w, r3.w, c15.y
mul_pp r3.xyz, r0.x, c14
mul_pp r0.xyz, r3, c5
mul_pp r1.xyz, r0, r1.x
cmp_pp r0.z, r0.w, c15, c15.y
abs_pp r1.w, r0.z
mul_pp r0.xy, v3, c8.x
mul_pp r0.xy, r0, c15.w
texld r0.xyz, r0, s1
cmp_pp r4.xyz, -r1.w, r1, c15.z
mad_pp r1.xyz, r0, c16.x, c16.yyzw
mov r0.x, v6.z
mov r0.y, v7.z
mov r0.z, v5
dp3_pp r5.z, r0, -r1
mov r0.x, v6
mov r0.z, v5.x
mov r0.y, v7.x
dp3_pp r5.x, -r1, r0
mov r0.x, v6.y
mov r0.z, v5.y
mov r0.y, v7
dp3_pp r5.y, -r1, r0
dp3_pp r0.x, r5, r5
rsq_pp r1.w, r0.x
mov_pp r0.xyz, c0
mul_pp r1.xyz, r4, c7.x
max_pp r0.w, r0, c15.z
mad_pp r0.xyz, c3, r0, v2
mul_pp r3.xyz, r3, c3
mad_pp_sat r3.xyz, r3, r0.w, r0
dp3_pp r0.w, r2, v4
mul_pp r2.xyz, r2, r0.w
mad_pp r2.xyz, -r2, c15.x, v4
texld r0.xyz, v3, s0
mad_pp r0.xyz, r0, r3, r1
mul_pp r1.xyz, r1.w, r5
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r1.w, v4
dp3_pp_sat r1.x, r1, r3
mul_pp r2.w, r1.x, r1.x
pow_pp r1, r2.w, c10.x
dp3_pp r0.w, r2, v1
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c15.y
pow_pp r3, r0.w, c13.x
mov_pp r0.w, r1.x
mul_pp r1, r0.w, c11
mov_pp r2.w, r3.x
mul_pp r2.w, r2, c12.x
mov_pp r0.w, c15.y
mad_pp r0, r1, c9.x, r0
texld r1, r2, s2
add_pp_sat r3.x, r2.w, c4
mul_pp r1.xyz, r1, r3.x
add_pp r0, r1, r0
mad_pp oC0, r2.w, r1, r0
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_OuterFlakePower]
Vector 11 [_paintColor2]
Float 12 [_FrezPow]
Float 13 [_FrezFalloff]
Vector 14 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 83 ALU, 3 TEX
PARAM c[17] = { state.lightmodel.ambient,
		program.local[1..14],
		{ 2, 1, 20, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R0, R0;
RSQ R2.w, R0.w;
ABS R0.w, -c[2];
DP3 R1.x, c[2], c[2];
CMP R0.w, -R0, c[15], c[15].y;
ABS R0.w, R0;
CMP R1.w, -R0, c[15], c[15].y;
RSQ R1.x, R1.x;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, fragment.texcoord[1];
MUL R1.xyz, R1.x, c[2];
MUL R0.xyz, R2.w, R0;
CMP R0.xyz, -R1.w, R0, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R1.x, R3, R3;
RSQ R3.w, R1.x;
DP3 R0.w, R2, R0;
MUL R1.xyz, R2, -R0.w;
MAD R0.xyz, -R1, c[15].x, -R0;
MUL R3.xyz, R3.w, R3;
DP3 R0.x, R0, R3;
SLT R0.y, R0.w, c[15].w;
ABS R1.x, R0.y;
MAX R0.x, R0, c[15].w;
POW R1.y, R0.x, c[6].x;
CMP R0.x, -R1.w, R2.w, c[15].y;
MUL R3.xyz, R0.x, c[14];
MUL R0.xyz, R3, c[5];
MUL R0.xyz, R0, R1.y;
CMP R1.z, -R1.x, c[15].w, c[15].y;
CMP R4.xyz, -R1.z, R0, c[15].w;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R1, c[15].z;
TEX R0.xyz, R0, texture[1], 2D;
MOV R1.xy, c[16];
MAD R1.xyz, R0, c[15].x, R1.xxyw;
MOV R0.x, fragment.texcoord[6].z;
MOV R0.y, fragment.texcoord[7].z;
MOV R0.z, fragment.texcoord[5];
DP3 R5.z, R0, -R1;
MOV R0.x, fragment.texcoord[6];
MOV R0.z, fragment.texcoord[5].x;
MOV R0.y, fragment.texcoord[7].x;
DP3 R5.x, -R1, R0;
MOV R0.x, fragment.texcoord[6].y;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.y, fragment.texcoord[7];
DP3 R5.y, -R1, R0;
DP3 R0.x, R5, R5;
RSQ R1.w, R0.x;
MOV R0.xyz, c[3];
MUL R1.xyz, R4, c[7].x;
MAX R0.w, R0, c[15];
MAD R0.xyz, R0, c[0], fragment.texcoord[2];
MUL R3.xyz, R3, c[3];
MAD_SAT R3.xyz, R3, R0.w, R0;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R2.xyz, R2, R0.w;
MAD R2.xyz, -R2, c[15].x, fragment.texcoord[4];
TEX R0.xyz, fragment.texcoord[3], texture[0], 2D;
MAD R0.xyz, R0, R3, R1;
MUL R1.xyz, R1.w, R5;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.x, R1, R3;
DP3 R0.w, R2, fragment.texcoord[1];
MUL R1.x, R1, R1;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[15].y;
POW R2.w, R0.w, c[13].x;
MUL R2.w, R2, c[12].x;
POW R1.x, R1.x, c[10].x;
MUL R1, R1.x, c[11];
MOV R0.w, c[15].y;
MAD R0, R1, c[9].x, R0;
TEX R1, R2, texture[2], CUBE;
ADD_SAT R3.x, R2.w, c[4];
MUL R1.xyz, R1, R3.x;
ADD R0, R1, R0;
MAD result.color, R2.w, R1, R0;
END
# 83 instructions, 6 R-regs
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_OuterFlakePower]
Vector 11 [_paintColor2]
Float 12 [_FrezPow]
Float 13 [_FrezFalloff]
Vector 14 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 85 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c15, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c16, 2.00000000, -1.00000000, 3.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7.xyz
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r3.w, r0.w
dp3_pp r1.x, c2, c2
abs_pp r0.w, -c2
cmp_pp r0.w, -r0, c15.y, c15.z
abs_pp r2.w, r0
rsq_pp r1.x, r1.x
dp3_pp r0.w, v1, v1
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, v1
mul_pp r1.xyz, r1.x, c2
mul_pp r0.xyz, r3.w, r0
cmp_pp r0.xyz, -r2.w, r0, r1
add r3.xyz, -v0, c1
dp3 r1.x, r3, r3
rsq r1.w, r1.x
dp3_pp r0.w, r2, r0
mul_pp r1.xyz, r2, -r0.w
mad_pp r0.xyz, -r1, c15.x, -r0
mul r3.xyz, r1.w, r3
dp3_pp r0.x, r0, r3
max_pp r0.x, r0, c15.z
pow_pp r1, r0.x, c6.x
cmp_pp r0.x, -r2.w, r3.w, c15.y
mul_pp r3.xyz, r0.x, c14
mul_pp r0.xyz, r3, c5
mul_pp r1.xyz, r0, r1.x
cmp_pp r0.z, r0.w, c15, c15.y
abs_pp r1.w, r0.z
mul_pp r0.xy, v3, c8.x
mul_pp r0.xy, r0, c15.w
texld r0.xyz, r0, s1
cmp_pp r4.xyz, -r1.w, r1, c15.z
mad_pp r1.xyz, r0, c16.x, c16.yyzw
mov r0.x, v6.z
mov r0.y, v7.z
mov r0.z, v5
dp3_pp r5.z, r0, -r1
mov r0.x, v6
mov r0.z, v5.x
mov r0.y, v7.x
dp3_pp r5.x, -r1, r0
mov r0.x, v6.y
mov r0.z, v5.y
mov r0.y, v7
dp3_pp r5.y, -r1, r0
dp3_pp r0.x, r5, r5
rsq_pp r1.w, r0.x
mov_pp r0.xyz, c0
mul_pp r1.xyz, r4, c7.x
max_pp r0.w, r0, c15.z
mad_pp r0.xyz, c3, r0, v2
mul_pp r3.xyz, r3, c3
mad_pp_sat r3.xyz, r3, r0.w, r0
dp3_pp r0.w, r2, v4
mul_pp r2.xyz, r2, r0.w
mad_pp r2.xyz, -r2, c15.x, v4
texld r0.xyz, v3, s0
mad_pp r0.xyz, r0, r3, r1
mul_pp r1.xyz, r1.w, r5
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r1.w, v4
dp3_pp_sat r1.x, r1, r3
mul_pp r2.w, r1.x, r1.x
pow_pp r1, r2.w, c10.x
dp3_pp r0.w, r2, v1
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c15.y
pow_pp r3, r0.w, c13.x
mov_pp r0.w, r1.x
mul_pp r1, r0.w, c11
mov_pp r2.w, r3.x
mul_pp r2.w, r2, c12.x
mov_pp r0.w, c15.y
mad_pp r0, r1, c9.x, r0
texld r1, r2, s2
add_pp_sat r3.x, r2.w, c4
mul_pp r1.xyz, r1, r3.x
add_pp r0, r1, r0
mad_pp oC0, r2.w, r1, r0
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_OuterFlakePower]
Vector 11 [_paintColor2]
Float 12 [_FrezPow]
Float 13 [_FrezFalloff]
Vector 14 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 83 ALU, 3 TEX
PARAM c[17] = { state.lightmodel.ambient,
		program.local[1..14],
		{ 2, 1, 20, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
ADD R0.xyz, -fragment.texcoord[0], c[2];
DP3 R0.w, R0, R0;
RSQ R2.w, R0.w;
ABS R0.w, -c[2];
DP3 R1.x, c[2], c[2];
CMP R0.w, -R0, c[15], c[15].y;
ABS R0.w, R0;
CMP R1.w, -R0, c[15], c[15].y;
RSQ R1.x, R1.x;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, fragment.texcoord[1];
MUL R1.xyz, R1.x, c[2];
MUL R0.xyz, R2.w, R0;
CMP R0.xyz, -R1.w, R0, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R1.x, R3, R3;
RSQ R3.w, R1.x;
DP3 R0.w, R2, R0;
MUL R1.xyz, R2, -R0.w;
MAD R0.xyz, -R1, c[15].x, -R0;
MUL R3.xyz, R3.w, R3;
DP3 R0.x, R0, R3;
SLT R0.y, R0.w, c[15].w;
ABS R1.x, R0.y;
MAX R0.x, R0, c[15].w;
POW R1.y, R0.x, c[6].x;
CMP R0.x, -R1.w, R2.w, c[15].y;
MUL R3.xyz, R0.x, c[14];
MUL R0.xyz, R3, c[5];
MUL R0.xyz, R0, R1.y;
CMP R1.z, -R1.x, c[15].w, c[15].y;
CMP R4.xyz, -R1.z, R0, c[15].w;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R1, c[15].z;
TEX R0.xyz, R0, texture[1], 2D;
MOV R1.xy, c[16];
MAD R1.xyz, R0, c[15].x, R1.xxyw;
MOV R0.x, fragment.texcoord[6].z;
MOV R0.y, fragment.texcoord[7].z;
MOV R0.z, fragment.texcoord[5];
DP3 R5.z, R0, -R1;
MOV R0.x, fragment.texcoord[6];
MOV R0.z, fragment.texcoord[5].x;
MOV R0.y, fragment.texcoord[7].x;
DP3 R5.x, -R1, R0;
MOV R0.x, fragment.texcoord[6].y;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.y, fragment.texcoord[7];
DP3 R5.y, -R1, R0;
DP3 R0.x, R5, R5;
RSQ R1.w, R0.x;
MOV R0.xyz, c[3];
MUL R1.xyz, R4, c[7].x;
MAX R0.w, R0, c[15];
MAD R0.xyz, R0, c[0], fragment.texcoord[2];
MUL R3.xyz, R3, c[3];
MAD_SAT R3.xyz, R3, R0.w, R0;
DP3 R0.w, R2, fragment.texcoord[4];
MUL R2.xyz, R2, R0.w;
MAD R2.xyz, -R2, c[15].x, fragment.texcoord[4];
TEX R0.xyz, fragment.texcoord[3], texture[0], 2D;
MAD R0.xyz, R0, R3, R1;
MUL R1.xyz, R1.w, R5;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.x, R1, R3;
DP3 R0.w, R2, fragment.texcoord[1];
MUL R1.x, R1, R1;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[15].y;
POW R2.w, R0.w, c[13].x;
MUL R2.w, R2, c[12].x;
POW R1.x, R1.x, c[10].x;
MUL R1, R1.x, c[11];
MOV R0.w, c[15].y;
MAD R0, R1, c[9].x, R0;
TEX R1, R2, texture[2], CUBE;
ADD_SAT R3.x, R2.w, c[4];
MUL R1.xyz, R1, R3.x;
ADD R0, R1, R0;
MAD result.color, R2.w, R1, R0;
END
# 83 instructions, 6 R-regs
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
Float 8 [_FlakeScale]
Float 9 [_FlakePower]
Float 10 [_OuterFlakePower]
Vector 11 [_paintColor2]
Float 12 [_FrezPow]
Float 13 [_FrezFalloff]
Vector 14 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_SparkleTex] 2D
SetTexture 2 [_Cube] CUBE
"ps_3_0
; 85 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c15, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c16, 2.00000000, -1.00000000, 3.00000000, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3.xy
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7.xyz
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r3.w, r0.w
dp3_pp r1.x, c2, c2
abs_pp r0.w, -c2
cmp_pp r0.w, -r0, c15.y, c15.z
abs_pp r2.w, r0
rsq_pp r1.x, r1.x
dp3_pp r0.w, v1, v1
rsq_pp r0.w, r0.w
mul_pp r2.xyz, r0.w, v1
mul_pp r1.xyz, r1.x, c2
mul_pp r0.xyz, r3.w, r0
cmp_pp r0.xyz, -r2.w, r0, r1
add r3.xyz, -v0, c1
dp3 r1.x, r3, r3
rsq r1.w, r1.x
dp3_pp r0.w, r2, r0
mul_pp r1.xyz, r2, -r0.w
mad_pp r0.xyz, -r1, c15.x, -r0
mul r3.xyz, r1.w, r3
dp3_pp r0.x, r0, r3
max_pp r0.x, r0, c15.z
pow_pp r1, r0.x, c6.x
cmp_pp r0.x, -r2.w, r3.w, c15.y
mul_pp r3.xyz, r0.x, c14
mul_pp r0.xyz, r3, c5
mul_pp r1.xyz, r0, r1.x
cmp_pp r0.z, r0.w, c15, c15.y
abs_pp r1.w, r0.z
mul_pp r0.xy, v3, c8.x
mul_pp r0.xy, r0, c15.w
texld r0.xyz, r0, s1
cmp_pp r4.xyz, -r1.w, r1, c15.z
mad_pp r1.xyz, r0, c16.x, c16.yyzw
mov r0.x, v6.z
mov r0.y, v7.z
mov r0.z, v5
dp3_pp r5.z, r0, -r1
mov r0.x, v6
mov r0.z, v5.x
mov r0.y, v7.x
dp3_pp r5.x, -r1, r0
mov r0.x, v6.y
mov r0.z, v5.y
mov r0.y, v7
dp3_pp r5.y, -r1, r0
dp3_pp r0.x, r5, r5
rsq_pp r1.w, r0.x
mov_pp r0.xyz, c0
mul_pp r1.xyz, r4, c7.x
max_pp r0.w, r0, c15.z
mad_pp r0.xyz, c3, r0, v2
mul_pp r3.xyz, r3, c3
mad_pp_sat r3.xyz, r3, r0.w, r0
dp3_pp r0.w, r2, v4
mul_pp r2.xyz, r2, r0.w
mad_pp r2.xyz, -r2, c15.x, v4
texld r0.xyz, v3, s0
mad_pp r0.xyz, r0, r3, r1
mul_pp r1.xyz, r1.w, r5
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mul_pp r3.xyz, r1.w, v4
dp3_pp_sat r1.x, r1, r3
mul_pp r2.w, r1.x, r1.x
pow_pp r1, r2.w, c10.x
dp3_pp r0.w, r2, v1
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c15.y
pow_pp r3, r0.w, c13.x
mov_pp r0.w, r1.x
mul_pp r1, r0.w, c11
mov_pp r2.w, r3.x
mul_pp r2.w, r2, c12.x
mov_pp r0.w, c15.y
mad_pp r0, r1, c9.x, r0
texld r1, r2, s2
add_pp_sat r3.x, r2.w, c4
mul_pp r1.xyz, r1, r3.x
add_pp r0, r1, r0
mad_pp oC0, r2.w, r1, r0
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

#LINE 289

      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Mobile/Diffuse"
}