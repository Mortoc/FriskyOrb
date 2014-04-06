Shader "RedDotGames/Mobile/Light Probes Support/Car Glass" {
Properties {
	_Color ("Main Color (RGB)", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color (RGB)", Color) = (1,1,1,0.5)
	_Cube ("Reflection Cubemap (CUBE)", Cube) = "_Skybox" { TexGen CubeReflect }
	_FresnelPower ("Fresnel Power", Range(0.05,5.0)) = 0.75
	_SHLightingScale("LightProbe influence scale",Range(0,1)) = 1
}
SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	
	Alphatest Greater 0 ZWrite Off ColorMask RGB
	
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha
Program "vp" {
// Vertex combos: 4
//   opengl - ALU: 43 to 73
//   d3d9 - ALU: 43 to 73
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
"!!ARBvp1.0
# 45 ALU
PARAM c[22] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 R2.w, R1, c[5];
DP3 R3.z, R1, c[6];
DP3 R3.xy, R1, c[7];
MOV R0.x, R2.w;
MOV R0.y, R3.z;
MOV R0.z, R3.y;
MOV R0.w, c[0].x;
MUL R1, R0.xyzz, R0.yzzx;
DP4 R2.z, R0, c[17];
DP4 R2.y, R0, c[16];
DP4 R2.x, R0, c[15];
DP4 R0.z, R1, c[20];
DP4 R0.y, R1, c[19];
DP4 R0.x, R1, c[18];
ADD R1.xyz, R2, R0;
MUL R0.w, R3.z, R3.z;
MAD R1.w, R2, R2, -R0;
MOV R0.w, c[0].x;
MOV R0.xyz, c[14];
DP4 R2.z, R0, c[11];
DP4 R2.x, R0, c[9];
DP4 R2.y, R0, c[10];
MAD R0.xyz, R2, c[13].w, -vertex.position;
MUL R2.xyz, R1.w, c[21];
ADD R2.xyz, R1, R2;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
MOV result.texcoord[2].xyz, R2;
MOV result.texcoord[4].xyz, R2;
MOV R2.x, R3.z;
MOV R2.y, R3.x;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[3].xyz, R2.wxyw;
ADD result.texcoord[1].xyz, -R0, c[14];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 45 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
"vs_2_0
; 45 ALU
def c21, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r1.xyz, v1, c12.w
dp3 r2.w, r1, c4
dp3 r3.z, r1, c5
dp3 r3.xy, r1, c6
mov r0.x, r2.w
mov r0.y, r3.z
mov r0.z, r3.y
mov r0.w, c21.x
mul r1, r0.xyzz, r0.yzzx
dp4 r2.z, r0, c16
dp4 r2.y, r0, c15
dp4 r2.x, r0, c14
dp4 r0.z, r1, c19
dp4 r0.y, r1, c18
dp4 r0.x, r1, c17
add r1.xyz, r2, r0
mul r0.w, r3.z, r3.z
mad r1.w, r2, r2, -r0
mov r0.w, c21.x
mov r0.xyz, c13
dp4 r2.z, r0, c10
dp4 r2.x, r0, c8
dp4 r2.y, r0, c9
mad r0.xyz, r2, c12.w, -v0
mul r2.xyz, r1.w, c20
add r2.xyz, r1, r2
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c21.y, -r0
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
mov oT2.xyz, r2
mov oT4.xyz, r2
mov r2.x, r3.z
mov r2.y, r3.x
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov oT3.xyz, r2.wxyw
add oT1.xyz, -r0, c13
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_23;
  mediump vec3 tmpvar_25;
  mediump vec4 normal_i0;
  normal_i0 = tmpvar_24;
  mediump vec3 x3_i0;
  highp float vC_i0;
  mediump vec3 x2_i0;
  mediump vec3 x1_i0;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAr, normal_i0);
  x1_i0.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAg, normal_i0);
  x1_i0.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHAb, normal_i0);
  x1_i0.z = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = (normal_i0.xyzz * normal_i0.yzzx);
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBr, tmpvar_29);
  x2_i0.x = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBg, tmpvar_29);
  x2_i0.y = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = dot (unity_SHBb, tmpvar_29);
  x2_i0.z = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = ((normal_i0.x * normal_i0.x) - (normal_i0.y * normal_i0.y));
  vC_i0 = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (unity_SHC.xyz * vC_i0);
  x3_i0 = tmpvar_34;
  tmpvar_25 = ((x1_i0 + x2_i0) + x3_i0);
  shlight = tmpvar_25;
  tmpvar_5 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp float _SHLightingScale;
uniform lowp vec4 _ReflectColor;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_4;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_5;
  lowp float tmpvar_6;
  tmpvar_6 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_7;
  tmpvar_7 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_6, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_4 = tmpvar_8;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD3, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_4 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + ((tmpvar_4 * 0.25) * (_SHLightingScale * tmpvar_3)));
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_23;
  mediump vec3 tmpvar_25;
  mediump vec4 normal_i0;
  normal_i0 = tmpvar_24;
  mediump vec3 x3_i0;
  highp float vC_i0;
  mediump vec3 x2_i0;
  mediump vec3 x1_i0;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAr, normal_i0);
  x1_i0.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAg, normal_i0);
  x1_i0.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHAb, normal_i0);
  x1_i0.z = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = (normal_i0.xyzz * normal_i0.yzzx);
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBr, tmpvar_29);
  x2_i0.x = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBg, tmpvar_29);
  x2_i0.y = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = dot (unity_SHBb, tmpvar_29);
  x2_i0.z = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = ((normal_i0.x * normal_i0.x) - (normal_i0.y * normal_i0.y));
  vC_i0 = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (unity_SHC.xyz * vC_i0);
  x3_i0 = tmpvar_34;
  tmpvar_25 = ((x1_i0 + x2_i0) + x3_i0);
  shlight = tmpvar_25;
  tmpvar_5 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp float _SHLightingScale;
uniform lowp vec4 _ReflectColor;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_4;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_5;
  lowp float tmpvar_6;
  tmpvar_6 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_7;
  tmpvar_7 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_6, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_4 = tmpvar_8;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD3, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_4 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + ((tmpvar_4 * 0.25) * (_SHLightingScale * tmpvar_3)));
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
"agal_vs
c21 1.0 2.0 0.0 0.0
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bcaaaaaaacaaaiacabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r2.w, r1.xyzz, c4
bcaaaaaaadaaaeacabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.z, r1.xyzz, c5
bcaaaaaaadaaadacabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r3.xy, r1.xyzz, c6
aaaaaaaaaaaaabacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r2.w
aaaaaaaaaaaaacacadaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r3.z
aaaaaaaaaaaaaeacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r0.z, r3.y
aaaaaaaaaaaaaiacbfaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c21.x
adaaaaaaabaaapacaaaaaakeacaaaaaaaaaaaacjacaaaaaa mul r1, r0.xyzz, r0.yzzx
bdaaaaaaacaaaeacaaaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r2.z, r0, c16
bdaaaaaaacaaacacaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r2.y, r0, c15
bdaaaaaaacaaabacaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r2.x, r0, c14
bdaaaaaaaaaaaeacabaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r0.z, r1, c19
bdaaaaaaaaaaacacabaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r0.y, r1, c18
bdaaaaaaaaaaabacabaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r0.x, r1, c17
abaaaaaaabaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r2.xyzz, r0.xyzz
adaaaaaaaaaaaiacadaaaakkacaaaaaaadaaaakkacaaaaaa mul r0.w, r3.z, r3.z
adaaaaaaadaaaiacacaaaappacaaaaaaacaaaappacaaaaaa mul r3.w, r2.w, r2.w
acaaaaaaabaaaiacadaaaappacaaaaaaaaaaaappacaaaaaa sub r1.w, r3.w, r0.w
aaaaaaaaaaaaaiacbfaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c21.x
aaaaaaaaaaaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, c13
bdaaaaaaacaaaeacaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r2.z, r0, c10
bdaaaaaaacaaabacaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r2.x, r0, c8
bdaaaaaaacaaacacaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r2.y, r0, c9
adaaaaaaaeaaahacacaaaakeacaaaaaaamaaaappabaaaaaa mul r4.xyz, r2.xyzz, c12.w
acaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r4.xyzz, a0
adaaaaaaacaaahacabaaaappacaaaaaabeaaaaoeabaaaaaa mul r2.xyz, r1.w, c20
abaaaaaaacaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r2.xyz, r1.xyzz, r2.xyzz
bfaaaaaaaeaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaaeaaaakeacaaaaaa dp3 r0.w, a1, r4.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaaeaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r1.xyzz
adaaaaaaaeaaahacaeaaaakeacaaaaaabfaaaaffabaaaaaa mul r4.xyz, r4.xyzz, c21.y
acaaaaaaaaaaahacaeaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r4.xyzz, r0.xyzz
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
aaaaaaaaacaaahaeacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, r2.xyzz
aaaaaaaaaeaaahaeacaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v4.xyz, r2.xyzz
aaaaaaaaacaaabacadaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r2.x, r3.z
aaaaaaaaacaaacacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r2.y, r3.x
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
aaaaaaaaadaaahaeacaaaafdacaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, r2.wxyy
bfaaaaaaaeaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r0.xyzz
abaaaaaaabaaahaeaeaaaakeacaaaaaaanaaaaoeabaaaaaa add v1.xyz, r4.xyzz, c13
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Vector 22 [unity_LightmapST]
"!!ARBvp1.0
# 43 ALU
PARAM c[23] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R2.xyz, vertex.normal, c[13].w;
DP3 R0.zw, R2, c[6];
DP3 R4.x, R2, c[5];
DP3 R4.z, R2, c[7];
MOV R4.y, R0.w;
MOV R1.y, R0.z;
MOV R1.x, R4;
MOV R1.z, R4;
MOV R1.w, c[0].x;
MUL R2, R1.xyzz, R1.yzzx;
DP4 R3.z, R1, c[17];
DP4 R3.y, R1, c[16];
DP4 R3.x, R1, c[15];
MOV R1.w, c[0].x;
DP4 R1.z, R2, c[20];
DP4 R1.x, R2, c[18];
DP4 R1.y, R2, c[19];
ADD R2.xyz, R3, R1;
MOV R1.xyz, c[14];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
MAD R1.xyz, R3, c[13].w, -vertex.position;
MUL R0.y, R0.z, R0.z;
MAD R1.w, R4.x, R4.x, -R0.y;
DP3 R0.x, vertex.normal, -R1;
MUL R0.xyz, vertex.normal, R0.x;
MAD R0.xyz, -R0, c[0].y, -R1;
MUL R3.xyz, R1.w, c[21];
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[2].xyz, R2, R3;
MOV result.texcoord[3].xyz, R4;
ADD result.texcoord[1].xyz, -R0, c[14];
MAD result.texcoord[4].xy, vertex.texcoord[1], c[22], c[22].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 43 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Vector 21 [unity_LightmapST]
"vs_2_0
; 43 ALU
def c22, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord1 v2
mul r2.xyz, v1, c12.w
dp3 r0.zw, r2, c5
dp3 r4.x, r2, c4
dp3 r4.z, r2, c6
mov r4.y, r0.w
mov r1.y, r0.z
mov r1.x, r4
mov r1.z, r4
mov r1.w, c22.x
mul r2, r1.xyzz, r1.yzzx
dp4 r3.z, r1, c16
dp4 r3.y, r1, c15
dp4 r3.x, r1, c14
mov r1.w, c22.x
dp4 r1.z, r2, c19
dp4 r1.x, r2, c17
dp4 r1.y, r2, c18
add r2.xyz, r3, r1
mov r1.xyz, c13
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c12.w, -v0
mul r0.y, r0.z, r0.z
mad r1.w, r4.x, r4.x, -r0.y
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r0.xyz, -r0, c22.y, -r1
mul r3.xyz, r1.w, c20
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT2.xyz, r2, r3
mov oT3.xyz, r4
add oT1.xyz, -r0, c13
mad oT4.xy, v2, c21, c21.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord1;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_6 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal;
  normal = tmpvar_7;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAr, normal);
  x1.x = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAg, normal);
  x1.y = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAb, normal);
  x1.z = tmpvar_11;
  mediump vec4 tmpvar_12;
  tmpvar_12 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBr, tmpvar_12);
  x2.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBg, tmpvar_12);
  x2.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBb, tmpvar_12);
  x2.z = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (unity_SHC.xyz * vC);
  x3 = tmpvar_17;
  tmpvar_8 = ((x1 + x2) + x3);
  tmpvar_5 = tmpvar_8;
  tmpvar_3 = tmpvar_5;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_18).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_20;
  mat3 tmpvar_21;
  tmpvar_21[0] = _Object2World[0].xyz;
  tmpvar_21[1] = _Object2World[1].xyz;
  tmpvar_21[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp float _SHLightingScale;
uniform lowp vec4 _ReflectColor;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_4;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_5;
  lowp float tmpvar_6;
  tmpvar_6 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_7;
  tmpvar_7 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_6, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_4 = tmpvar_8;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  c.xyz = (tmpvar_4 * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz));
  c.w = refl2Refr;
  c.xyz = (c.xyz + ((tmpvar_4 * 0.25) * (_SHLightingScale * tmpvar_3)));
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord1;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_6 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal;
  normal = tmpvar_7;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAr, normal);
  x1.x = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAg, normal);
  x1.y = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAb, normal);
  x1.z = tmpvar_11;
  mediump vec4 tmpvar_12;
  tmpvar_12 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBr, tmpvar_12);
  x2.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBg, tmpvar_12);
  x2.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBb, tmpvar_12);
  x2.z = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (unity_SHC.xyz * vC);
  x3 = tmpvar_17;
  tmpvar_8 = ((x1 + x2) + x3);
  tmpvar_5 = tmpvar_8;
  tmpvar_3 = tmpvar_5;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_18).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_20;
  mat3 tmpvar_21;
  tmpvar_21[0] = _Object2World[0].xyz;
  tmpvar_21[1] = _Object2World[1].xyz;
  tmpvar_21[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp float _SHLightingScale;
uniform lowp vec4 _ReflectColor;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_4;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_5;
  lowp float tmpvar_6;
  tmpvar_6 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_7;
  tmpvar_7 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_6, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_4 = tmpvar_8;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  c.xyz = (tmpvar_4 * ((8.0 * tmpvar_9.w) * tmpvar_9.xyz));
  c.w = refl2Refr;
  c.xyz = (c.xyz + ((tmpvar_4 * 0.25) * (_SHLightingScale * tmpvar_3)));
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Vector 21 [unity_LightmapST]
"agal_vs
c22 1.0 2.0 0.0 0.0
[bc]
adaaaaaaacaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r2.xyz, a1, c12.w
bcaaaaaaaaaaamacacaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r0.zw, r2.xyzz, c5
bcaaaaaaaeaaabacacaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r4.x, r2.xyzz, c4
bcaaaaaaaeaaaeacacaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r4.z, r2.xyzz, c6
aaaaaaaaaeaaacacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r0.w
aaaaaaaaabaaacacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r0.z
aaaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r4.x
aaaaaaaaabaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.z, r4.z
aaaaaaaaabaaaiacbgaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c22.x
adaaaaaaacaaapacabaaaakeacaaaaaaabaaaacjacaaaaaa mul r2, r1.xyzz, r1.yzzx
bdaaaaaaadaaaeacabaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r3.z, r1, c16
bdaaaaaaadaaacacabaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r3.y, r1, c15
bdaaaaaaadaaabacabaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r3.x, r1, c14
aaaaaaaaabaaaiacbgaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c22.x
bdaaaaaaabaaaeacacaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r1.z, r2, c19
bdaaaaaaabaaabacacaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r1.x, r2, c17
bdaaaaaaabaaacacacaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r1.y, r2, c18
abaaaaaaacaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r3.xyzz, r1.xyzz
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
bdaaaaaaadaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r3.z, r1, c10
bdaaaaaaadaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r3.x, r1, c8
bdaaaaaaadaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r3.y, r1, c9
adaaaaaaafaaahacadaaaakeacaaaaaaamaaaappabaaaaaa mul r5.xyz, r3.xyzz, c12.w
acaaaaaaabaaahacafaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r5.xyzz, a0
adaaaaaaaaaaacacaaaaaakkacaaaaaaaaaaaakkacaaaaaa mul r0.y, r0.z, r0.z
adaaaaaaafaaaiacaeaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r5.w, r4.x, r4.x
acaaaaaaabaaaiacafaaaappacaaaaaaaaaaaaffacaaaaaa sub r1.w, r5.w, r0.y
bfaaaaaaafaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r1.xyzz
bcaaaaaaaaaaabacabaaaaoeaaaaaaaaafaaaakeacaaaaaa dp3 r0.x, a1, r5.xyzz
adaaaaaaaaaaahacabaaaaoeaaaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, a1, r0.x
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
adaaaaaaafaaahacafaaaakeacaaaaaabgaaaaffabaaaaaa mul r5.xyz, r5.xyzz, c22.y
acaaaaaaaaaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r5.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaappacaaaaaabeaaaaoeabaaaaaa mul r3.xyz, r1.w, c20
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
abaaaaaaacaaahaeacaaaakeacaaaaaaadaaaakeacaaaaaa add v2.xyz, r2.xyzz, r3.xyzz
aaaaaaaaadaaahaeaeaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, r4.xyzz
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
abaaaaaaabaaahaeafaaaakeacaaaaaaanaaaaoeabaaaaaa add v1.xyz, r5.xyzz, c13
adaaaaaaafaaadacaeaaaaoeaaaaaaaabfaaaaoeabaaaaaa mul r5.xy, a4, c21
abaaaaaaaeaaadaeafaaaafeacaaaaaabfaaaaooabaaaaaa add v4.xy, r5.xyyy, c21.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.zw, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
Vector 22 [unity_LightmapST]
"!!ARBvp1.0
# 43 ALU
PARAM c[23] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R2.xyz, vertex.normal, c[13].w;
DP3 R0.zw, R2, c[6];
DP3 R4.x, R2, c[5];
DP3 R4.z, R2, c[7];
MOV R4.y, R0.w;
MOV R1.y, R0.z;
MOV R1.x, R4;
MOV R1.z, R4;
MOV R1.w, c[0].x;
MUL R2, R1.xyzz, R1.yzzx;
DP4 R3.z, R1, c[17];
DP4 R3.y, R1, c[16];
DP4 R3.x, R1, c[15];
MOV R1.w, c[0].x;
DP4 R1.z, R2, c[20];
DP4 R1.x, R2, c[18];
DP4 R1.y, R2, c[19];
ADD R2.xyz, R3, R1;
MOV R1.xyz, c[14];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
MAD R1.xyz, R3, c[13].w, -vertex.position;
MUL R0.y, R0.z, R0.z;
MAD R1.w, R4.x, R4.x, -R0.y;
DP3 R0.x, vertex.normal, -R1;
MUL R0.xyz, vertex.normal, R0.x;
MAD R0.xyz, -R0, c[0].y, -R1;
MUL R3.xyz, R1.w, c[21];
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[2].xyz, R2, R3;
MOV result.texcoord[3].xyz, R4;
ADD result.texcoord[1].xyz, -R0, c[14];
MAD result.texcoord[4].xy, vertex.texcoord[1], c[22], c[22].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 43 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Vector 21 [unity_LightmapST]
"vs_2_0
; 43 ALU
def c22, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord1 v2
mul r2.xyz, v1, c12.w
dp3 r0.zw, r2, c5
dp3 r4.x, r2, c4
dp3 r4.z, r2, c6
mov r4.y, r0.w
mov r1.y, r0.z
mov r1.x, r4
mov r1.z, r4
mov r1.w, c22.x
mul r2, r1.xyzz, r1.yzzx
dp4 r3.z, r1, c16
dp4 r3.y, r1, c15
dp4 r3.x, r1, c14
mov r1.w, c22.x
dp4 r1.z, r2, c19
dp4 r1.x, r2, c17
dp4 r1.y, r2, c18
add r2.xyz, r3, r1
mov r1.xyz, c13
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c12.w, -v0
mul r0.y, r0.z, r0.z
mad r1.w, r4.x, r4.x, -r0.y
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r0.xyz, -r0, c22.y, -r1
mul r3.xyz, r1.w, c20
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT2.xyz, r2, r3
mov oT3.xyz, r4
add oT1.xyz, -r0, c13
mad oT4.xy, v2, c21, c21.zwzw
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord1;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_6 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal;
  normal = tmpvar_7;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAr, normal);
  x1.x = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAg, normal);
  x1.y = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAb, normal);
  x1.z = tmpvar_11;
  mediump vec4 tmpvar_12;
  tmpvar_12 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBr, tmpvar_12);
  x2.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBg, tmpvar_12);
  x2.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBb, tmpvar_12);
  x2.z = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (unity_SHC.xyz * vC);
  x3 = tmpvar_17;
  tmpvar_8 = ((x1 + x2) + x3);
  tmpvar_5 = tmpvar_8;
  tmpvar_3 = tmpvar_5;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_18).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_20;
  mat3 tmpvar_21;
  tmpvar_21[0] = _Object2World[0].xyz;
  tmpvar_21[1] = _Object2World[1].xyz;
  tmpvar_21[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp float _SHLightingScale;
uniform lowp vec4 _ReflectColor;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_4;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_5;
  lowp float tmpvar_6;
  tmpvar_6 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_7;
  tmpvar_7 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_6, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_4 = tmpvar_8;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_9;
  tmpvar_9 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz);
  lm_i0 = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_4 * lm_i0);
  c.xyz = tmpvar_10;
  c.w = refl2Refr;
  c.xyz = (c.xyz + ((tmpvar_4 * 0.25) * (_SHLightingScale * tmpvar_3)));
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord1;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  mat3 tmpvar_6;
  tmpvar_6[0] = _Object2World[0].xyz;
  tmpvar_6[1] = _Object2World[1].xyz;
  tmpvar_6[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = (tmpvar_6 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_8;
  mediump vec4 normal;
  normal = tmpvar_7;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_9;
  tmpvar_9 = dot (unity_SHAr, normal);
  x1.x = tmpvar_9;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAg, normal);
  x1.y = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAb, normal);
  x1.z = tmpvar_11;
  mediump vec4 tmpvar_12;
  tmpvar_12 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_13;
  tmpvar_13 = dot (unity_SHBr, tmpvar_12);
  x2.x = tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBg, tmpvar_12);
  x2.y = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBb, tmpvar_12);
  x2.z = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_16;
  highp vec3 tmpvar_17;
  tmpvar_17 = (unity_SHC.xyz * vC);
  x3 = tmpvar_17;
  tmpvar_8 = ((x1 + x2) + x3);
  tmpvar_5 = tmpvar_8;
  tmpvar_3 = tmpvar_5;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_19;
  tmpvar_19[0] = _Object2World[0].xyz;
  tmpvar_19[1] = _Object2World[1].xyz;
  tmpvar_19[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_20;
  tmpvar_20 = (tmpvar_19 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_18).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_20;
  mat3 tmpvar_21;
  tmpvar_21[0] = _Object2World[0].xyz;
  tmpvar_21[1] = _Object2World[1].xyz;
  tmpvar_21[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_22;
  tmpvar_22 = (tmpvar_21 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_22;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp float _SHLightingScale;
uniform lowp vec4 _ReflectColor;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_4;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_5;
  lowp float tmpvar_6;
  tmpvar_6 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_7;
  tmpvar_7 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_6, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_4 = tmpvar_8;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_10;
  tmpvar_10 = ((8.0 * tmpvar_9.w) * tmpvar_9.xyz);
  lm_i0 = tmpvar_10;
  mediump vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_4 * lm_i0);
  c.xyz = tmpvar_11;
  c.w = refl2Refr;
  c.xyz = (c.xyz + ((tmpvar_4 * 0.25) * (_SHLightingScale * tmpvar_3)));
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_SHAr]
Vector 15 [unity_SHAg]
Vector 16 [unity_SHAb]
Vector 17 [unity_SHBr]
Vector 18 [unity_SHBg]
Vector 19 [unity_SHBb]
Vector 20 [unity_SHC]
Vector 21 [unity_LightmapST]
"agal_vs
c22 1.0 2.0 0.0 0.0
[bc]
adaaaaaaacaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r2.xyz, a1, c12.w
bcaaaaaaaaaaamacacaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r0.zw, r2.xyzz, c5
bcaaaaaaaeaaabacacaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r4.x, r2.xyzz, c4
bcaaaaaaaeaaaeacacaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r4.z, r2.xyzz, c6
aaaaaaaaaeaaacacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r0.w
aaaaaaaaabaaacacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r0.z
aaaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r4.x
aaaaaaaaabaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.z, r4.z
aaaaaaaaabaaaiacbgaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c22.x
adaaaaaaacaaapacabaaaakeacaaaaaaabaaaacjacaaaaaa mul r2, r1.xyzz, r1.yzzx
bdaaaaaaadaaaeacabaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r3.z, r1, c16
bdaaaaaaadaaacacabaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r3.y, r1, c15
bdaaaaaaadaaabacabaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 r3.x, r1, c14
aaaaaaaaabaaaiacbgaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c22.x
bdaaaaaaabaaaeacacaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r1.z, r2, c19
bdaaaaaaabaaabacacaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r1.x, r2, c17
bdaaaaaaabaaacacacaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r1.y, r2, c18
abaaaaaaacaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r3.xyzz, r1.xyzz
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
bdaaaaaaadaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r3.z, r1, c10
bdaaaaaaadaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r3.x, r1, c8
bdaaaaaaadaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r3.y, r1, c9
adaaaaaaafaaahacadaaaakeacaaaaaaamaaaappabaaaaaa mul r5.xyz, r3.xyzz, c12.w
acaaaaaaabaaahacafaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r5.xyzz, a0
adaaaaaaaaaaacacaaaaaakkacaaaaaaaaaaaakkacaaaaaa mul r0.y, r0.z, r0.z
adaaaaaaafaaaiacaeaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r5.w, r4.x, r4.x
acaaaaaaabaaaiacafaaaappacaaaaaaaaaaaaffacaaaaaa sub r1.w, r5.w, r0.y
bfaaaaaaafaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r1.xyzz
bcaaaaaaaaaaabacabaaaaoeaaaaaaaaafaaaakeacaaaaaa dp3 r0.x, a1, r5.xyzz
adaaaaaaaaaaahacabaaaaoeaaaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, a1, r0.x
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
adaaaaaaafaaahacafaaaakeacaaaaaabgaaaaffabaaaaaa mul r5.xyz, r5.xyzz, c22.y
acaaaaaaaaaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r5.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaappacaaaaaabeaaaaoeabaaaaaa mul r3.xyz, r1.w, c20
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
abaaaaaaacaaahaeacaaaakeacaaaaaaadaaaakeacaaaaaa add v2.xyz, r2.xyzz, r3.xyzz
aaaaaaaaadaaahaeaeaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, r4.xyzz
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
abaaaaaaabaaahaeafaaaakeacaaaaaaanaaaaoeabaaaaaa add v1.xyz, r5.xyzz, c13
adaaaaaaafaaadacaeaaaaoeaaaaaaaabfaaaaoeabaaaaaa mul r5.xy, a4, c21
abaaaaaaaeaaadaeafaaaafeacaaaaaabfaaaaooabaaaaaa add v4.xy, r5.xyyy, c21.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.zw, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_SHAr]
Vector 24 [unity_SHAg]
Vector 25 [unity_SHAb]
Vector 26 [unity_SHBr]
Vector 27 [unity_SHBg]
Vector 28 [unity_SHBb]
Vector 29 [unity_SHC]
"!!ARBvp1.0
# 73 ALU
PARAM c[30] = { { 1, 2, 0 },
		state.matrix.mvp,
		program.local[5..29] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
DP4 R4.zw, vertex.position, c[6];
MUL R3.xyz, vertex.normal, c[13].w;
ADD R2, -R4.z, c[16];
DP3 R4.z, R3, c[6];
DP3 R5.x, R3, c[5];
DP4 R3.w, vertex.position, c[5];
MUL R0, R4.z, R2;
ADD R1, -R3.w, c[15];
MUL R2, R2, R2;
DP3 R3.xy, R3, c[7];
MAD R0, R5.x, R1, R0;
DP4 R4.xy, vertex.position, c[7];
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[17];
MAD R2, R1, R1, R2;
MAD R0, R3.x, R1, R0;
MUL R1, R2, c[18];
ADD R1, R1, c[0].x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].z;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[20];
MAD R1.xyz, R0.x, c[19], R1;
MAD R0.xyz, R0.z, c[21], R1;
MAD R2.xyz, R0.w, c[22], R0;
MOV R0.z, R3.y;
MOV R0.x, R5;
MOV R0.y, R4.z;
MOV R0.w, c[0].x;
MUL R1, R0.xyzz, R0.yzzx;
DP4 R5.w, R0, c[25];
DP4 R5.z, R0, c[24];
DP4 R5.y, R0, c[23];
DP4 R0.z, R1, c[28];
DP4 R0.y, R1, c[27];
DP4 R0.x, R1, c[26];
ADD R1.xyz, R5.yzww, R0;
MUL R0.w, R4.z, R4.z;
MAD R1.w, R5.x, R5.x, -R0;
MOV R0.w, c[0].x;
MOV R0.xyz, c[14];
DP4 R5.w, R0, c[11];
DP4 R5.y, R0, c[9];
DP4 R5.z, R0, c[10];
MAD R0.xyz, R5.yzww, c[13].w, -vertex.position;
MUL R5.yzw, R1.w, c[29].xxyz;
ADD R5.yzw, R1.xxyz, R5;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
ADD result.texcoord[4].xyz, R5.yzww, R2;
MOV result.texcoord[2].xyz, R5.yzww;
MOV R5.z, R3.x;
MOV R5.y, R4.z;
MOV R3.x, R4.w;
MOV R3.y, R4;
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
MOV result.texcoord[3].xyz, R5;
ADD result.texcoord[1].xyz, -R3.wxyw, c[14];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 73 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
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
"vs_2_0
; 73 ALU
def c29, 1.00000000, 2.00000000, 0.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dp4 r4.zw, v0, c5
mul r3.xyz, v1, c12.w
add r2, -r4.z, c15
dp3 r4.z, r3, c5
dp3 r5.x, r3, c4
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c14
mul r2, r2, r2
dp3 r3.xy, r3, c6
mad r0, r5.x, r1, r0
dp4 r4.xy, v0, c6
mad r2, r1, r1, r2
add r1, -r4.x, c16
mad r2, r1, r1, r2
mad r0, r3.x, r1, r0
mul r1, r2, c17
add r1, r1, c29.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c29.z
mul r0, r0, r1
mul r1.xyz, r0.y, c19
mad r1.xyz, r0.x, c18, r1
mad r0.xyz, r0.z, c20, r1
mad r2.xyz, r0.w, c21, r0
mov r0.z, r3.y
mov r0.x, r5
mov r0.y, r4.z
mov r0.w, c29.x
mul r1, r0.xyzz, r0.yzzx
dp4 r5.w, r0, c24
dp4 r5.z, r0, c23
dp4 r5.y, r0, c22
dp4 r0.z, r1, c27
dp4 r0.y, r1, c26
dp4 r0.x, r1, c25
add r1.xyz, r5.yzww, r0
mul r0.w, r4.z, r4.z
mad r1.w, r5.x, r5.x, -r0
mov r0.w, c29.x
mov r0.xyz, c13
dp4 r5.w, r0, c10
dp4 r5.y, r0, c8
dp4 r5.z, r0, c9
mad r0.xyz, r5.yzww, c12.w, -v0
mul r5.yzw, r1.w, c28.xxyz
add r5.yzw, r1.xxyz, r5
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c29.y, -r0
add oT4.xyz, r5.yzww, r2
mov oT2.xyz, r5.yzww
mov r5.z, r3.x
mov r5.y, r4.z
mov r3.x, r4.w
mov r3.y, r4
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
mov oT3.xyz, r5
add oT1.xyz, -r3.wxyw, c13
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
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
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_23;
  mediump vec3 tmpvar_25;
  mediump vec4 normal_i0;
  normal_i0 = tmpvar_24;
  mediump vec3 x3_i0;
  highp float vC_i0;
  mediump vec3 x2_i0;
  mediump vec3 x1_i0;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAr, normal_i0);
  x1_i0.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAg, normal_i0);
  x1_i0.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHAb, normal_i0);
  x1_i0.z = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = (normal_i0.xyzz * normal_i0.yzzx);
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBr, tmpvar_29);
  x2_i0.x = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBg, tmpvar_29);
  x2_i0.y = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = dot (unity_SHBb, tmpvar_29);
  x2_i0.z = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = ((normal_i0.x * normal_i0.x) - (normal_i0.y * normal_i0.y));
  vC_i0 = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (unity_SHC.xyz * vC_i0);
  x3_i0 = tmpvar_34;
  tmpvar_25 = ((x1_i0 + x2_i0) + x3_i0);
  shlight = tmpvar_25;
  tmpvar_5 = shlight;
  highp vec3 tmpvar_35;
  tmpvar_35 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosX0 - tmpvar_35.x);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosY0 - tmpvar_35.y);
  highp vec4 tmpvar_38;
  tmpvar_38 = (unity_4LightPosZ0 - tmpvar_35.z);
  highp vec4 tmpvar_39;
  tmpvar_39 = (((tmpvar_36 * tmpvar_36) + (tmpvar_37 * tmpvar_37)) + (tmpvar_38 * tmpvar_38));
  highp vec4 tmpvar_40;
  tmpvar_40 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_36 * tmpvar_23.x) + (tmpvar_37 * tmpvar_23.y)) + (tmpvar_38 * tmpvar_23.z)) * inversesqrt (tmpvar_39))) * (1.0/((1.0 + (tmpvar_39 * unity_4LightAtten0)))));
  highp vec3 tmpvar_41;
  tmpvar_41 = (tmpvar_5 + ((((unity_LightColor[0].xyz * tmpvar_40.x) + (unity_LightColor[1].xyz * tmpvar_40.y)) + (unity_LightColor[2].xyz * tmpvar_40.z)) + (unity_LightColor[3].xyz * tmpvar_40.w)));
  tmpvar_5 = tmpvar_41;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp float _SHLightingScale;
uniform lowp vec4 _ReflectColor;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_4;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_5;
  lowp float tmpvar_6;
  tmpvar_6 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_7;
  tmpvar_7 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_6, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_4 = tmpvar_8;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD3, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_4 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + ((tmpvar_4 * 0.25) * (_SHLightingScale * tmpvar_3)));
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
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
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_23;
  mediump vec3 tmpvar_25;
  mediump vec4 normal_i0;
  normal_i0 = tmpvar_24;
  mediump vec3 x3_i0;
  highp float vC_i0;
  mediump vec3 x2_i0;
  mediump vec3 x1_i0;
  highp float tmpvar_26;
  tmpvar_26 = dot (unity_SHAr, normal_i0);
  x1_i0.x = tmpvar_26;
  highp float tmpvar_27;
  tmpvar_27 = dot (unity_SHAg, normal_i0);
  x1_i0.y = tmpvar_27;
  highp float tmpvar_28;
  tmpvar_28 = dot (unity_SHAb, normal_i0);
  x1_i0.z = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29 = (normal_i0.xyzz * normal_i0.yzzx);
  highp float tmpvar_30;
  tmpvar_30 = dot (unity_SHBr, tmpvar_29);
  x2_i0.x = tmpvar_30;
  highp float tmpvar_31;
  tmpvar_31 = dot (unity_SHBg, tmpvar_29);
  x2_i0.y = tmpvar_31;
  highp float tmpvar_32;
  tmpvar_32 = dot (unity_SHBb, tmpvar_29);
  x2_i0.z = tmpvar_32;
  mediump float tmpvar_33;
  tmpvar_33 = ((normal_i0.x * normal_i0.x) - (normal_i0.y * normal_i0.y));
  vC_i0 = tmpvar_33;
  highp vec3 tmpvar_34;
  tmpvar_34 = (unity_SHC.xyz * vC_i0);
  x3_i0 = tmpvar_34;
  tmpvar_25 = ((x1_i0 + x2_i0) + x3_i0);
  shlight = tmpvar_25;
  tmpvar_5 = shlight;
  highp vec3 tmpvar_35;
  tmpvar_35 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_36;
  tmpvar_36 = (unity_4LightPosX0 - tmpvar_35.x);
  highp vec4 tmpvar_37;
  tmpvar_37 = (unity_4LightPosY0 - tmpvar_35.y);
  highp vec4 tmpvar_38;
  tmpvar_38 = (unity_4LightPosZ0 - tmpvar_35.z);
  highp vec4 tmpvar_39;
  tmpvar_39 = (((tmpvar_36 * tmpvar_36) + (tmpvar_37 * tmpvar_37)) + (tmpvar_38 * tmpvar_38));
  highp vec4 tmpvar_40;
  tmpvar_40 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_36 * tmpvar_23.x) + (tmpvar_37 * tmpvar_23.y)) + (tmpvar_38 * tmpvar_23.z)) * inversesqrt (tmpvar_39))) * (1.0/((1.0 + (tmpvar_39 * unity_4LightAtten0)))));
  highp vec3 tmpvar_41;
  tmpvar_41 = (tmpvar_5 + ((((unity_LightColor[0].xyz * tmpvar_40.x) + (unity_LightColor[1].xyz * tmpvar_40.y)) + (unity_LightColor[2].xyz * tmpvar_40.z)) + (unity_LightColor[3].xyz * tmpvar_40.w)));
  tmpvar_5 = tmpvar_41;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp float _SHLightingScale;
uniform lowp vec4 _ReflectColor;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_3 = xlv_TEXCOORD2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_4;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_5;
  tmpvar_5 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_5;
  lowp float tmpvar_6;
  tmpvar_6 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_7;
  tmpvar_7 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_6, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_4 = tmpvar_8;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD3, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_4 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + ((tmpvar_4 * 0.25) * (_SHLightingScale * tmpvar_3)));
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
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
"agal_vs
c29 1.0 2.0 0.0 0.0
[bc]
bdaaaaaaaeaaamacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r4.zw, a0, c5
adaaaaaaadaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r3.xyz, a1, c12.w
bfaaaaaaacaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa neg r2.z, r4.z
abaaaaaaacaaapacacaaaakkacaaaaaaapaaaaoeabaaaaaa add r2, r2.z, c15
bcaaaaaaaeaaaeacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r4.z, r3.xyzz, c5
bcaaaaaaafaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r5.x, r3.xyzz, c4
bdaaaaaaadaaaiacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r3.w, a0, c4
adaaaaaaaaaaapacaeaaaakkacaaaaaaacaaaaoeacaaaaaa mul r0, r4.z, r2
bfaaaaaaabaaaiacadaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r3.w
abaaaaaaabaaapacabaaaappacaaaaaaaoaaaaoeabaaaaaa add r1, r1.w, c14
adaaaaaaacaaapacacaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r2, r2, r2
bcaaaaaaadaaadacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r3.xy, r3.xyzz, c6
adaaaaaaagaaapacafaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r5.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
bdaaaaaaaeaaadacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.xy, a0, c6
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
bfaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r4.x
abaaaaaaabaaapacabaaaaaaacaaaaaabaaaaaoeabaaaaaa add r1, r1.x, c16
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
adaaaaaaagaaapacadaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r3.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaabaaapacacaaaaoeacaaaaaabbaaaaoeabaaaaaa mul r1, r2, c17
abaaaaaaabaaapacabaaaaoeacaaaaaabnaaaaaaabaaaaaa add r1, r1, c29.x
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
akaaaaaaacaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r2.y, r2.y
akaaaaaaacaaaeacacaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r2.z, r2.z
akaaaaaaacaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r2.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r0, r0, r2
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaabnaaaakkabaaaaaa max r0, r0, c29.z
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaabdaaaaoeabaaaaaa mul r1.xyz, r0.y, c19
adaaaaaaagaaahacaaaaaaaaacaaaaaabcaaaaoeabaaaaaa mul r6.xyz, r0.x, c18
abaaaaaaabaaahacagaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r6.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaabeaaaaoeabaaaaaa mul r0.xyz, r0.z, c20
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaacaaahacaaaaaappacaaaaaabfaaaaoeabaaaaaa mul r2.xyz, r0.w, c21
abaaaaaaacaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r2.xyz, r2.xyzz, r0.xyzz
aaaaaaaaaaaaaeacadaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r0.z, r3.y
aaaaaaaaaaaaabacafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r5.x
aaaaaaaaaaaaacacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r4.z
aaaaaaaaaaaaaiacbnaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c29.x
adaaaaaaabaaapacaaaaaakeacaaaaaaaaaaaacjacaaaaaa mul r1, r0.xyzz, r0.yzzx
bdaaaaaaafaaaiacaaaaaaoeacaaaaaabiaaaaoeabaaaaaa dp4 r5.w, r0, c24
bdaaaaaaafaaaeacaaaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r5.z, r0, c23
bdaaaaaaafaaacacaaaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r5.y, r0, c22
bdaaaaaaaaaaaeacabaaaaoeacaaaaaablaaaaoeabaaaaaa dp4 r0.z, r1, c27
bdaaaaaaaaaaacacabaaaaoeacaaaaaabkaaaaoeabaaaaaa dp4 r0.y, r1, c26
bdaaaaaaaaaaabacabaaaaoeacaaaaaabjaaaaoeabaaaaaa dp4 r0.x, r1, c25
abaaaaaaabaaahacafaaaapjacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r5.yzww, r0.xyzz
adaaaaaaaaaaaiacaeaaaakkacaaaaaaaeaaaakkacaaaaaa mul r0.w, r4.z, r4.z
adaaaaaaagaaaiacafaaaaaaacaaaaaaafaaaaaaacaaaaaa mul r6.w, r5.x, r5.x
acaaaaaaabaaaiacagaaaappacaaaaaaaaaaaappacaaaaaa sub r1.w, r6.w, r0.w
aaaaaaaaaaaaaiacbnaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.w, c29.x
aaaaaaaaaaaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, c13
bdaaaaaaafaaaiacaaaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r5.w, r0, c10
bdaaaaaaafaaacacaaaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r5.y, r0, c8
bdaaaaaaafaaaeacaaaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r5.z, r0, c9
adaaaaaaagaaahacafaaaapjacaaaaaaamaaaappabaaaaaa mul r6.xyz, r5.yzww, c12.w
acaaaaaaaaaaahacagaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r6.xyzz, a0
adaaaaaaafaaaoacabaaaappacaaaaaabmaaaajaabaaaaaa mul r5.yzw, r1.w, c28.xxyz
abaaaaaaafaaaoacabaaaajcacaaaaaaafaaaaohacaaaaaa add r5.yzw, r1.zxyz, r5.wyzw
bfaaaaaaagaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaagaaaakeacaaaaaa dp3 r0.w, a1, r6.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaagaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyz, r1.xyzz
adaaaaaaagaaahacagaaaakeacaaaaaabnaaaaffabaaaaaa mul r6.xyz, r6.xyzz, c29.y
acaaaaaaaaaaahacagaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r6.xyzz, r0.xyzz
abaaaaaaaeaaahaeafaaaapjacaaaaaaacaaaakeacaaaaaa add v4.xyz, r5.yzww, r2.xyzz
aaaaaaaaacaaahaeafaaaapjacaaaaaaaaaaaaaaaaaaaaaa mov v2.xyz, r5.yzww
aaaaaaaaafaaaeacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r5.z, r3.x
aaaaaaaaafaaacacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r5.y, r4.z
aaaaaaaaadaaabacaeaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r3.x, r4.w
aaaaaaaaadaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r3.y, r4.y
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
aaaaaaaaadaaahaeafaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, r5.xyzz
bfaaaaaaagaaalacadaaaapdacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyw, r3.wxww
abaaaaaaabaaahaeagaaaafdacaaaaaaanaaaaoeabaaaaaa add v1.xyz, r6.wxyy, c13
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

}
Program "fp" {
// Fragment combos: 3
//   opengl - ALU: 22 to 24, TEX: 1 to 2
//   d3d9 - ALU: 24 to 27, TEX: 1 to 2
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_ReflectColor]
Float 4 [_FresnelPower]
Float 5 [_SHLightingScale]
SetTexture 0 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 24 ALU, 1 TEX
PARAM c[8] = { program.local[0..5],
		{ 0, 1, 0.79638672, 0.20373535 },
		{ 0.25, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.x;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
DP3 R1.w, fragment.texcoord[3], c[0];
MUL R2.xyz, R1.x, fragment.texcoord[3];
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, fragment.texcoord[1];
DP3 R0.w, R1, R2;
MOV R1.xyz, c[2];
MAD R1.xyz, R0, c[3], R1;
MAX R0.w, R0, c[6].x;
ADD_SAT R0.w, -R0, c[6].y;
POW R0.w, R0.w, c[4].x;
MAD R0.w, R0, c[6].z, c[6];
MUL R2.xyz, R1, fragment.texcoord[4];
MUL R0.xyz, R1, c[1];
MAX R1.w, R1, c[6].x;
MUL R0.xyz, R1.w, R0;
MAD R2.xyz, R0, c[7].y, R2;
MUL R0.xyz, fragment.texcoord[2], c[5].x;
MUL R0.xyz, R1, R0;
MAD result.color.xyz, R0, c[7].x, R2;
MAX result.color.w, R0, c[6].x;
END
# 24 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_ReflectColor]
Float 4 [_FresnelPower]
Float 5 [_SHLightingScale]
SetTexture 0 [_Cube] CUBE
"ps_2_0
; 27 ALU, 1 TEX
dcl_cube s0
def c6, 0.00000000, 1.00000000, 0.79638672, 0.20373535
def c7, 2.00000000, 0.25000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r1, t0, s0
dp3_pp r2.x, t3, t3
dp3_pp r0.x, t1, t1
rsq_pp r2.x, r2.x
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t1
mul_pp r2.xyz, r2.x, t3
dp3_pp r0.x, r0, r2
max_pp r0.x, r0, c6
add_pp_sat r0.x, -r0, c6.y
pow_pp r4.x, r0.x, c4.x
mov_pp r0.xyz, c2
mad_pp r1.xyz, r1, c3, r0
dp3_pp r0.x, t3, c0
mul_pp r2.xyz, r1, c1
max_pp r0.x, r0, c6
mul_pp r0.xyz, r0.x, r2
mul_pp r3.xyz, r1, t4
mul_pp r2.xyz, t2, c5.x
mad_pp r3.xyz, r0, c7.x, r3
mov_pp r0.x, r4.x
mad_pp r0.x, r0, c6.z, c6.w
mul_pp r1.xyz, r1, r2
mad_pp r1.xyz, r1, c7.y, r3
max_pp r1.w, r0.x, c6.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_ReflectColor]
Float 4 [_FresnelPower]
Float 5 [_SHLightingScale]
SetTexture 0 [_Cube] CUBE
"agal_ps
c6 0.0 1.0 0.796387 0.203735
c7 2.0 0.25 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r1, v0, s0 <cube wrap linear point>
bcaaaaaaacaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r2.x, v3, v3
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r0.xyz, r0.x, v1
adaaaaaaacaaahacacaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r2.xyz, r2.x, v3
bcaaaaaaaaaaabacaaaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r2.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaaoeabaaaaaa max r0.x, r0.x, c6
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaaffabaaaaaa add r0.x, r0.x, c6.y
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaaeaaapacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa pow r4, r0.x, c4.x
aaaaaaaaaaaaahacacaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, c2
adaaaaaaabaaahacabaaaakeacaaaaaaadaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c3
abaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r1.xyz, r1.xyzz, r0.xyzz
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r0.x, v3, c0
adaaaaaaacaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r1.xyzz, c1
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaaoeabaaaaaa max r0.x, r0.x, c6
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaakeacaaaaaa mul r0.xyz, r0.x, r2.xyzz
adaaaaaaadaaahacabaaaakeacaaaaaaaeaaaaoeaeaaaaaa mul r3.xyz, r1.xyzz, v4
adaaaaaaacaaahacacaaaaoeaeaaaaaaafaaaaaaabaaaaaa mul r2.xyz, v2, c5.x
adaaaaaaaeaaaoacaaaaaakeacaaaaaaahaaaaaaabaaaaaa mul r4.yzw, r0.xyzz, c7.x
abaaaaaaadaaahacaeaaaapjacaaaaaaadaaaakeacaaaaaa add r3.xyz, r4.yzww, r3.xyzz
aaaaaaaaaaaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r4.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaakkabaaaaaa mul r0.x, r0.x, c6.z
abaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaappabaaaaaa add r0.x, r0.x, c6.w
adaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r1.xyzz, r2.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaahaaaaffabaaaaaa mul r1.xyz, r1.xyzz, c7.y
abaaaaaaabaaahacabaaaakeacaaaaaaadaaaakeacaaaaaa add r1.xyz, r1.xyzz, r3.xyzz
ahaaaaaaabaaaiacaaaaaaaaacaaaaaaagaaaaaaabaaaaaa max r1.w, r0.x, c6.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [_ReflectColor]
Float 2 [_FresnelPower]
Float 3 [_SHLightingScale]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 22 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0, 1, 0.79638672, 0.20373535 },
		{ 8, 0.25 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[4], texture[1], 2D;
TEX R1.xyz, fragment.texcoord[0], texture[0], CUBE;
MOV R4.xyz, c[0];
DP3 R2.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R2.x, R2.x;
DP3 R1.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.w, R1.w;
MUL R3.xyz, R2.x, fragment.texcoord[3];
MUL R2.xyz, R1.w, fragment.texcoord[1];
DP3 R1.w, R2, R3;
MUL R0.xyz, R0.w, R0;
MAD R1.xyz, R1, c[1], R4;
MAX R0.w, R1, c[4].x;
ADD_SAT R0.w, -R0, c[4].y;
POW R0.w, R0.w, c[2].x;
MAD R0.w, R0, c[4].z, c[4];
MUL R0.xyz, R0, R1;
MUL R2.xyz, fragment.texcoord[2], c[3].x;
MUL R1.xyz, R1, R2;
MUL R1.xyz, R1, c[5].y;
MAD result.color.xyz, R0, c[5].x, R1;
MAX result.color.w, R0, c[4].x;
END
# 22 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [_ReflectColor]
Float 2 [_FresnelPower]
Float 3 [_SHLightingScale]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 24 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c4, 0.00000000, 1.00000000, 0.79638672, 0.20373535
def c5, 0.25000000, 8.00000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xy
texld r3, t0, s0
texld r2, t4, s1
dp3_pp r1.x, t3, t3
dp3_pp r0.x, t1, t1
rsq_pp r1.x, r1.x
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t1
mul_pp r1.xyz, r1.x, t3
dp3_pp r0.x, r0, r1
max_pp r0.x, r0, c4
add_pp_sat r0.x, -r0, c4.y
mov_pp r1.xyz, c0
mad_pp r1.xyz, r3, c1, r1
mul_pp r2.xyz, r2.w, r2
mul_pp r3.xyz, r2, r1
pow_pp r2.x, r0.x, c2.x
mul_pp r0.xyz, t2, c3.x
mul_pp r1.xyz, r1, r0
mov_pp r0.x, r2.x
mul_pp r1.xyz, r1, c5.x
mad_pp r0.x, r0, c4.z, c4.w
mad_pp r1.xyz, r3, c5.y, r1
max_pp r1.w, r0.x, c4.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [_ReflectColor]
Float 2 [_FresnelPower]
Float 3 [_SHLightingScale]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"agal_ps
c4 0.0 1.0 0.796387 0.203735
c5 0.25 8.0 0.0 0.0
[bc]
ciaaaaaaadaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r3, v0, s0 <cube wrap linear point>
ciaaaaaaacaaapacaeaaaaoeaeaaaaaaabaaaaaaafaababb tex r2, v4, s1 <2d wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r0.xyz, r0.x, v1
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r0.x, r0.x, c4
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa add r0.x, r0.x, c4.y
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
aaaaaaaaabaaahacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c0
adaaaaaaaeaaahacadaaaakeacaaaaaaabaaaaoeabaaaaaa mul r4.xyz, r3.xyzz, c1
abaaaaaaabaaahacaeaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r4.xyzz, r1.xyzz
adaaaaaaacaaahacacaaaappacaaaaaaacaaaakeacaaaaaa mul r2.xyz, r2.w, r2.xyzz
adaaaaaaadaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa mul r3.xyz, r2.xyzz, r1.xyzz
alaaaaaaacaaapacaaaaaaaaacaaaaaaacaaaaaaabaaaaaa pow r2, r0.x, c2.x
adaaaaaaaaaaahacacaaaaoeaeaaaaaaadaaaaaaabaaaaaa mul r0.xyz, v2, c3.x
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r1.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r2.x
adaaaaaaabaaahacabaaaakeacaaaaaaafaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c5.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa mul r0.x, r0.x, c4.z
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaappabaaaaaa add r0.x, r0.x, c4.w
adaaaaaaaeaaahacadaaaakeacaaaaaaafaaaaffabaaaaaa mul r4.xyz, r3.xyzz, c5.y
abaaaaaaabaaahacaeaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r4.xyzz, r1.xyzz
ahaaaaaaabaaaiacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa max r1.w, r0.x, c4.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Color]
Vector 1 [_ReflectColor]
Float 2 [_FresnelPower]
Float 3 [_SHLightingScale]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 22 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0, 1, 0.79638672, 0.20373535 },
		{ 8, 0.25 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[4], texture[1], 2D;
TEX R1.xyz, fragment.texcoord[0], texture[0], CUBE;
MOV R4.xyz, c[0];
DP3 R2.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R2.x, R2.x;
DP3 R1.w, fragment.texcoord[1], fragment.texcoord[1];
RSQ R1.w, R1.w;
MUL R3.xyz, R2.x, fragment.texcoord[3];
MUL R2.xyz, R1.w, fragment.texcoord[1];
DP3 R1.w, R2, R3;
MUL R0.xyz, R0.w, R0;
MAD R1.xyz, R1, c[1], R4;
MAX R0.w, R1, c[4].x;
ADD_SAT R0.w, -R0, c[4].y;
POW R0.w, R0.w, c[2].x;
MAD R0.w, R0, c[4].z, c[4];
MUL R0.xyz, R0, R1;
MUL R2.xyz, fragment.texcoord[2], c[3].x;
MUL R1.xyz, R1, R2;
MUL R1.xyz, R1, c[5].y;
MAD result.color.xyz, R0, c[5].x, R1;
MAX result.color.w, R0, c[4].x;
END
# 22 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Color]
Vector 1 [_ReflectColor]
Float 2 [_FresnelPower]
Float 3 [_SHLightingScale]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"ps_2_0
; 24 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c4, 0.00000000, 1.00000000, 0.79638672, 0.20373535
def c5, 0.25000000, 8.00000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xy
texld r3, t0, s0
texld r2, t4, s1
dp3_pp r1.x, t3, t3
dp3_pp r0.x, t1, t1
rsq_pp r1.x, r1.x
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t1
mul_pp r1.xyz, r1.x, t3
dp3_pp r0.x, r0, r1
max_pp r0.x, r0, c4
add_pp_sat r0.x, -r0, c4.y
mov_pp r1.xyz, c0
mad_pp r1.xyz, r3, c1, r1
mul_pp r2.xyz, r2.w, r2
mul_pp r3.xyz, r2, r1
pow_pp r2.x, r0.x, c2.x
mul_pp r0.xyz, t2, c3.x
mul_pp r1.xyz, r1, r0
mov_pp r0.x, r2.x
mul_pp r1.xyz, r1, c5.x
mad_pp r0.x, r0, c4.z, c4.w
mad_pp r1.xyz, r3, c5.y, r1
max_pp r1.w, r0.x, c4.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Color]
Vector 1 [_ReflectColor]
Float 2 [_FresnelPower]
Float 3 [_SHLightingScale]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [unity_Lightmap] 2D
"agal_ps
c4 0.0 1.0 0.796387 0.203735
c5 0.25 8.0 0.0 0.0
[bc]
ciaaaaaaadaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r3, v0, s0 <cube wrap linear point>
ciaaaaaaacaaapacaeaaaaoeaeaaaaaaabaaaaaaafaababb tex r2, v4, s1 <2d wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r0.xyz, r0.x, v1
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r0.x, r0.x, c4
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa add r0.x, r0.x, c4.y
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
aaaaaaaaabaaahacaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c0
adaaaaaaaeaaahacadaaaakeacaaaaaaabaaaaoeabaaaaaa mul r4.xyz, r3.xyzz, c1
abaaaaaaabaaahacaeaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r4.xyzz, r1.xyzz
adaaaaaaacaaahacacaaaappacaaaaaaacaaaakeacaaaaaa mul r2.xyz, r2.w, r2.xyzz
adaaaaaaadaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa mul r3.xyz, r2.xyzz, r1.xyzz
alaaaaaaacaaapacaaaaaaaaacaaaaaaacaaaaaaabaaaaaa pow r2, r0.x, c2.x
adaaaaaaaaaaahacacaaaaoeaeaaaaaaadaaaaaaabaaaaaa mul r0.xyz, v2, c3.x
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa mul r1.xyz, r1.xyzz, r0.xyzz
aaaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r2.x
adaaaaaaabaaahacabaaaakeacaaaaaaafaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c5.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa mul r0.x, r0.x, c4.z
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaappabaaaaaa add r0.x, r0.x, c4.w
adaaaaaaaeaaahacadaaaakeacaaaaaaafaaaaffabaaaaaa mul r4.xyz, r3.xyzz, c5.y
abaaaaaaabaaahacaeaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r4.xyzz, r1.xyzz
ahaaaaaaabaaaiacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa max r1.w, r0.x, c4.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

}
	}
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One Fog { Color (0,0,0,0) }
		Blend SrcAlpha One
Program "vp" {
// Vertex combos: 5
//   opengl - ALU: 43 to 48
//   d3d9 - ALU: 43 to 48
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 20 [unity_SHAr]
Vector 21 [unity_SHAg]
Vector 22 [unity_SHAb]
Vector 23 [unity_SHBr]
Vector 24 [unity_SHBg]
Vector 25 [unity_SHBb]
Vector 26 [unity_SHC]
Matrix 13 [_LightMatrix0]
"!!ARBvp1.0
# 47 ALU
PARAM c[27] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..26] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R2.xyz, vertex.normal, c[17].w;
DP3 R0.zw, R2, c[6];
DP3 R4.x, R2, c[5];
DP3 R4.z, R2, c[7];
MOV R4.y, R0.w;
MOV R1.y, R0.z;
MOV R1.x, R4;
MOV R1.z, R4;
MOV R1.w, c[0].x;
MUL R2, R1.xyzz, R1.yzzx;
DP4 R3.z, R1, c[22];
DP4 R3.y, R1, c[21];
DP4 R3.x, R1, c[20];
MOV R1.w, c[0].x;
DP4 R1.z, R2, c[25];
DP4 R1.x, R2, c[23];
DP4 R1.y, R2, c[24];
ADD R2.xyz, R3, R1;
MOV R1.xyz, c[18];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
MAD R1.xyz, R3, c[17].w, -vertex.position;
MUL R0.y, R0.z, R0.z;
MAD R1.w, R4.x, R4.x, -R0.y;
DP3 R0.x, vertex.normal, -R1;
MUL R0.xyz, vertex.normal, R0.x;
MAD R0.xyz, -R0, c[0].y, -R1;
MUL R3.xyz, R1.w, c[26];
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
ADD result.texcoord[2].xyz, R2, R3;
MOV result.texcoord[3].xyz, R4;
DP4 result.texcoord[5].z, R0, c[15];
DP4 result.texcoord[5].y, R0, c[14];
DP4 result.texcoord[5].x, R0, c[13];
ADD result.texcoord[1].xyz, -R0, c[18];
ADD result.texcoord[4].xyz, -R0, c[19];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 47 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 12 [_LightMatrix0]
"vs_2_0
; 47 ALU
def c26, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r2.xyz, v1, c16.w
dp3 r0.zw, r2, c5
dp3 r4.x, r2, c4
dp3 r4.z, r2, c6
mov r4.y, r0.w
mov r1.y, r0.z
mov r1.x, r4
mov r1.z, r4
mov r1.w, c26.x
mul r2, r1.xyzz, r1.yzzx
dp4 r3.z, r1, c21
dp4 r3.y, r1, c20
dp4 r3.x, r1, c19
mov r1.w, c26.x
dp4 r1.z, r2, c24
dp4 r1.x, r2, c22
dp4 r1.y, r2, c23
add r2.xyz, r3, r1
mov r1.xyz, c17
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
mul r0.y, r0.z, r0.z
mad r1.w, r4.x, r4.x, -r0.y
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r0.xyz, -r0, c26.y, -r1
mul r3.xyz, r1.w, c25
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
add oT2.xyz, r2, r3
mov oT3.xyz, r4
dp4 oT5.z, r0, c14
dp4 oT5.y, r0, c13
dp4 oT5.x, r0, c12
add oT1.xyz, -r0, c17
add oT4.xyz, -r0, c18
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_5 = tmpvar_24;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_3;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_5, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_3 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize (xlv_TEXCOORD4);
  lightDir = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * texture2D (_LightTexture0, tmpvar_9).w) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_5 = tmpvar_24;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_3;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_5, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_3 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize (xlv_TEXCOORD4);
  lightDir = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * texture2D (_LightTexture0, tmpvar_9).w) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 12 [_LightMatrix0]
"agal_vs
c26 1.0 2.0 0.0 0.0
[bc]
adaaaaaaacaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r2.xyz, a1, c16.w
bcaaaaaaaaaaamacacaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r0.zw, r2.xyzz, c5
bcaaaaaaaeaaabacacaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r4.x, r2.xyzz, c4
bcaaaaaaaeaaaeacacaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r4.z, r2.xyzz, c6
aaaaaaaaaeaaacacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r0.w
aaaaaaaaabaaacacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r0.z
aaaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r4.x
aaaaaaaaabaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.z, r4.z
aaaaaaaaabaaaiacbkaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c26.x
adaaaaaaacaaapacabaaaakeacaaaaaaabaaaacjacaaaaaa mul r2, r1.xyzz, r1.yzzx
bdaaaaaaadaaaeacabaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r3.z, r1, c21
bdaaaaaaadaaacacabaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r3.y, r1, c20
bdaaaaaaadaaabacabaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r3.x, r1, c19
aaaaaaaaabaaaiacbkaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c26.x
bdaaaaaaabaaaeacacaaaaoeacaaaaaabiaaaaoeabaaaaaa dp4 r1.z, r2, c24
bdaaaaaaabaaabacacaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r1.x, r2, c22
bdaaaaaaabaaacacacaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r1.y, r2, c23
abaaaaaaacaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r3.xyzz, r1.xyzz
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
bdaaaaaaadaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r3.z, r1, c10
bdaaaaaaadaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r3.x, r1, c8
bdaaaaaaadaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r3.y, r1, c9
adaaaaaaafaaahacadaaaakeacaaaaaabaaaaappabaaaaaa mul r5.xyz, r3.xyzz, c16.w
acaaaaaaabaaahacafaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r5.xyzz, a0
adaaaaaaaaaaacacaaaaaakkacaaaaaaaaaaaakkacaaaaaa mul r0.y, r0.z, r0.z
adaaaaaaafaaaiacaeaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r5.w, r4.x, r4.x
acaaaaaaabaaaiacafaaaappacaaaaaaaaaaaaffacaaaaaa sub r1.w, r5.w, r0.y
bfaaaaaaafaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r1.xyzz
bcaaaaaaaaaaabacabaaaaoeaaaaaaaaafaaaakeacaaaaaa dp3 r0.x, a1, r5.xyzz
adaaaaaaaaaaahacabaaaaoeaaaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, a1, r0.x
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
adaaaaaaafaaahacafaaaakeacaaaaaabkaaaaffabaaaaaa mul r5.xyz, r5.xyzz, c26.y
acaaaaaaaaaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r5.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaappacaaaaaabjaaaaoeabaaaaaa mul r3.xyz, r1.w, c25
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
abaaaaaaacaaahaeacaaaakeacaaaaaaadaaaakeacaaaaaa add v2.xyz, r2.xyzz, r3.xyzz
aaaaaaaaadaaahaeaeaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, r4.xyzz
bdaaaaaaafaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v5.z, r0, c14
bdaaaaaaafaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v5.y, r0, c13
bdaaaaaaafaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v5.x, r0, c12
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
abaaaaaaabaaahaeafaaaakeacaaaaaabbaaaaoeabaaaaaa add v1.xyz, r5.xyzz, c17
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
abaaaaaaaeaaahaeafaaaakeacaaaaaabcaaaaoeabaaaaaa add v4.xyz, r5.xyzz, c18
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaafaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v5.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 16 [unity_SHAr]
Vector 17 [unity_SHAg]
Vector 18 [unity_SHAb]
Vector 19 [unity_SHBr]
Vector 20 [unity_SHBg]
Vector 21 [unity_SHBb]
Vector 22 [unity_SHC]
"!!ARBvp1.0
# 43 ALU
PARAM c[23] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R2.xyz, vertex.normal, c[13].w;
DP3 R0.zw, R2, c[6];
DP3 R4.x, R2, c[5];
DP3 R4.z, R2, c[7];
MOV R4.y, R0.w;
MOV R1.y, R0.z;
MOV R1.x, R4;
MOV R1.z, R4;
MOV R1.w, c[0].x;
MUL R2, R1.xyzz, R1.yzzx;
DP4 R3.z, R1, c[18];
DP4 R3.y, R1, c[17];
DP4 R3.x, R1, c[16];
MOV R1.w, c[0].x;
DP4 R1.z, R2, c[21];
DP4 R1.x, R2, c[19];
DP4 R1.y, R2, c[20];
ADD R2.xyz, R3, R1;
MOV R1.xyz, c[14];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
MAD R1.xyz, R3, c[13].w, -vertex.position;
MUL R0.y, R0.z, R0.z;
MAD R1.w, R4.x, R4.x, -R0.y;
DP3 R0.x, vertex.normal, -R1;
MUL R0.xyz, vertex.normal, R0.x;
MAD R0.xyz, -R0, c[0].y, -R1;
MUL R3.xyz, R1.w, c[22];
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[2].xyz, R2, R3;
MOV result.texcoord[3].xyz, R4;
ADD result.texcoord[1].xyz, -R0, c[14];
MOV result.texcoord[4].xyz, c[15];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 43 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
"vs_2_0
; 43 ALU
def c22, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r2.xyz, v1, c12.w
dp3 r0.zw, r2, c5
dp3 r4.x, r2, c4
dp3 r4.z, r2, c6
mov r4.y, r0.w
mov r1.y, r0.z
mov r1.x, r4
mov r1.z, r4
mov r1.w, c22.x
mul r2, r1.xyzz, r1.yzzx
dp4 r3.z, r1, c17
dp4 r3.y, r1, c16
dp4 r3.x, r1, c15
mov r1.w, c22.x
dp4 r1.z, r2, c20
dp4 r1.x, r2, c18
dp4 r1.y, r2, c19
add r2.xyz, r3, r1
mov r1.xyz, c13
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c12.w, -v0
mul r0.y, r0.z, r0.z
mad r1.w, r4.x, r4.x, -r0.y
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r0.xyz, -r0, c22.y, -r1
mul r3.xyz, r1.w, c21
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT2.xyz, r2, r3
mov oT3.xyz, r4
add oT1.xyz, -r0, c13
mov oT4.xyz, c14
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = _WorldSpaceLightPos0.xyz;
  tmpvar_5 = tmpvar_24;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _ReflectColor;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_3;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_5, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_3 = tmpvar_7;
  lightDir = xlv_TEXCOORD4;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD3, lightDir)) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = _WorldSpaceLightPos0.xyz;
  tmpvar_5 = tmpvar_24;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _ReflectColor;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_3;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_5, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_3 = tmpvar_7;
  lightDir = xlv_TEXCOORD4;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD3, lightDir)) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_SHAr]
Vector 16 [unity_SHAg]
Vector 17 [unity_SHAb]
Vector 18 [unity_SHBr]
Vector 19 [unity_SHBg]
Vector 20 [unity_SHBb]
Vector 21 [unity_SHC]
"agal_vs
c22 1.0 2.0 0.0 0.0
[bc]
adaaaaaaacaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r2.xyz, a1, c12.w
bcaaaaaaaaaaamacacaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r0.zw, r2.xyzz, c5
bcaaaaaaaeaaabacacaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r4.x, r2.xyzz, c4
bcaaaaaaaeaaaeacacaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r4.z, r2.xyzz, c6
aaaaaaaaaeaaacacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r0.w
aaaaaaaaabaaacacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r0.z
aaaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r4.x
aaaaaaaaabaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.z, r4.z
aaaaaaaaabaaaiacbgaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c22.x
adaaaaaaacaaapacabaaaakeacaaaaaaabaaaacjacaaaaaa mul r2, r1.xyzz, r1.yzzx
bdaaaaaaadaaaeacabaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r3.z, r1, c17
bdaaaaaaadaaacacabaaaaoeacaaaaaabaaaaaoeabaaaaaa dp4 r3.y, r1, c16
bdaaaaaaadaaabacabaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 r3.x, r1, c15
aaaaaaaaabaaaiacbgaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c22.x
bdaaaaaaabaaaeacacaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r1.z, r2, c20
bdaaaaaaabaaabacacaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r1.x, r2, c18
bdaaaaaaabaaacacacaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r1.y, r2, c19
abaaaaaaacaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r3.xyzz, r1.xyzz
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
bdaaaaaaadaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r3.z, r1, c10
bdaaaaaaadaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r3.x, r1, c8
bdaaaaaaadaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r3.y, r1, c9
adaaaaaaafaaahacadaaaakeacaaaaaaamaaaappabaaaaaa mul r5.xyz, r3.xyzz, c12.w
acaaaaaaabaaahacafaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r5.xyzz, a0
adaaaaaaaaaaacacaaaaaakkacaaaaaaaaaaaakkacaaaaaa mul r0.y, r0.z, r0.z
adaaaaaaafaaaiacaeaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r5.w, r4.x, r4.x
acaaaaaaabaaaiacafaaaappacaaaaaaaaaaaaffacaaaaaa sub r1.w, r5.w, r0.y
bfaaaaaaafaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r1.xyzz
bcaaaaaaaaaaabacabaaaaoeaaaaaaaaafaaaakeacaaaaaa dp3 r0.x, a1, r5.xyzz
adaaaaaaaaaaahacabaaaaoeaaaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, a1, r0.x
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
adaaaaaaafaaahacafaaaakeacaaaaaabgaaaaffabaaaaaa mul r5.xyz, r5.xyzz, c22.y
acaaaaaaaaaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r5.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaappacaaaaaabfaaaaoeabaaaaaa mul r3.xyz, r1.w, c21
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
abaaaaaaacaaahaeacaaaakeacaaaaaaadaaaakeacaaaaaa add v2.xyz, r2.xyzz, r3.xyzz
aaaaaaaaadaaahaeaeaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, r4.xyzz
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
abaaaaaaabaaahaeafaaaakeacaaaaaaanaaaaoeabaaaaaa add v1.xyz, r5.xyzz, c13
aaaaaaaaaeaaahaeaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.xyz, c14
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 20 [unity_SHAr]
Vector 21 [unity_SHAg]
Vector 22 [unity_SHAb]
Vector 23 [unity_SHBr]
Vector 24 [unity_SHBg]
Vector 25 [unity_SHBb]
Vector 26 [unity_SHC]
Matrix 13 [_LightMatrix0]
"!!ARBvp1.0
# 48 ALU
PARAM c[27] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..26] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R2.xyz, vertex.normal, c[17].w;
DP3 R0.zw, R2, c[6];
DP3 R4.x, R2, c[5];
DP3 R4.z, R2, c[7];
MOV R4.y, R0.w;
MOV R1.y, R0.z;
MOV R1.x, R4;
MOV R1.z, R4;
MOV R1.w, c[0].x;
MUL R2, R1.xyzz, R1.yzzx;
DP4 R3.z, R1, c[22];
DP4 R3.y, R1, c[21];
DP4 R3.x, R1, c[20];
MOV R1.w, c[0].x;
DP4 R0.w, vertex.position, c[8];
DP4 R1.z, R2, c[25];
DP4 R1.x, R2, c[23];
DP4 R1.y, R2, c[24];
ADD R2.xyz, R3, R1;
MOV R1.xyz, c[18];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
MAD R1.xyz, R3, c[17].w, -vertex.position;
MUL R0.y, R0.z, R0.z;
MAD R1.w, R4.x, R4.x, -R0.y;
DP3 R0.x, vertex.normal, -R1;
MUL R0.xyz, vertex.normal, R0.x;
MAD R0.xyz, -R0, c[0].y, -R1;
MUL R3.xyz, R1.w, c[26];
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[2].xyz, R2, R3;
MOV result.texcoord[3].xyz, R4;
DP4 result.texcoord[5].w, R0, c[16];
DP4 result.texcoord[5].z, R0, c[15];
DP4 result.texcoord[5].y, R0, c[14];
DP4 result.texcoord[5].x, R0, c[13];
ADD result.texcoord[1].xyz, -R0, c[18];
ADD result.texcoord[4].xyz, -R0, c[19];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 48 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 12 [_LightMatrix0]
"vs_2_0
; 48 ALU
def c26, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r2.xyz, v1, c16.w
dp3 r0.zw, r2, c5
dp3 r4.x, r2, c4
dp3 r4.z, r2, c6
mov r4.y, r0.w
mov r1.y, r0.z
mov r1.x, r4
mov r1.z, r4
mov r1.w, c26.x
mul r2, r1.xyzz, r1.yzzx
dp4 r3.z, r1, c21
dp4 r3.y, r1, c20
dp4 r3.x, r1, c19
mov r1.w, c26.x
dp4 r0.w, v0, c7
dp4 r1.z, r2, c24
dp4 r1.x, r2, c22
dp4 r1.y, r2, c23
add r2.xyz, r3, r1
mov r1.xyz, c17
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
mul r0.y, r0.z, r0.z
mad r1.w, r4.x, r4.x, -r0.y
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r0.xyz, -r0, c26.y, -r1
mul r3.xyz, r1.w, c25
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT2.xyz, r2, r3
mov oT3.xyz, r4
dp4 oT5.w, r0, c15
dp4 oT5.z, r0, c14
dp4 oT5.y, r0, c13
dp4 oT5.x, r0, c12
add oT1.xyz, -r0, c17
add oT4.xyz, -r0, c18
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_5 = tmpvar_24;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_3;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_5, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_3 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize (xlv_TEXCOORD4);
  lightDir = tmpvar_8;
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD5.xyz;
  highp vec2 tmpvar_9;
  tmpvar_9 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp float atten;
  atten = ((float((xlv_TEXCOORD5.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD5.xy / xlv_TEXCOORD5.w) + 0.5)).w) * texture2D (_LightTextureB0, tmpvar_9).w);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * atten) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec4 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_5 = tmpvar_24;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_3;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_5, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_3 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize (xlv_TEXCOORD4);
  lightDir = tmpvar_8;
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD5.xyz;
  highp vec2 tmpvar_9;
  tmpvar_9 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp float atten;
  atten = ((float((xlv_TEXCOORD5.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD5.xy / xlv_TEXCOORD5.w) + 0.5)).w) * texture2D (_LightTextureB0, tmpvar_9).w);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * atten) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 12 [_LightMatrix0]
"agal_vs
c26 1.0 2.0 0.0 0.0
[bc]
adaaaaaaacaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r2.xyz, a1, c16.w
bcaaaaaaaaaaamacacaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r0.zw, r2.xyzz, c5
bcaaaaaaaeaaabacacaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r4.x, r2.xyzz, c4
bcaaaaaaaeaaaeacacaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r4.z, r2.xyzz, c6
aaaaaaaaaeaaacacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r0.w
aaaaaaaaabaaacacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r0.z
aaaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r4.x
aaaaaaaaabaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.z, r4.z
aaaaaaaaabaaaiacbkaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c26.x
adaaaaaaacaaapacabaaaakeacaaaaaaabaaaacjacaaaaaa mul r2, r1.xyzz, r1.yzzx
bdaaaaaaadaaaeacabaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r3.z, r1, c21
bdaaaaaaadaaacacabaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r3.y, r1, c20
bdaaaaaaadaaabacabaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r3.x, r1, c19
aaaaaaaaabaaaiacbkaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c26.x
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaabaaaeacacaaaaoeacaaaaaabiaaaaoeabaaaaaa dp4 r1.z, r2, c24
bdaaaaaaabaaabacacaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r1.x, r2, c22
bdaaaaaaabaaacacacaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r1.y, r2, c23
abaaaaaaacaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r3.xyzz, r1.xyzz
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
bdaaaaaaadaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r3.z, r1, c10
bdaaaaaaadaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r3.x, r1, c8
bdaaaaaaadaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r3.y, r1, c9
adaaaaaaafaaahacadaaaakeacaaaaaabaaaaappabaaaaaa mul r5.xyz, r3.xyzz, c16.w
acaaaaaaabaaahacafaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r5.xyzz, a0
adaaaaaaaaaaacacaaaaaakkacaaaaaaaaaaaakkacaaaaaa mul r0.y, r0.z, r0.z
adaaaaaaafaaaiacaeaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r5.w, r4.x, r4.x
acaaaaaaabaaaiacafaaaappacaaaaaaaaaaaaffacaaaaaa sub r1.w, r5.w, r0.y
bfaaaaaaafaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r1.xyzz
bcaaaaaaaaaaabacabaaaaoeaaaaaaaaafaaaakeacaaaaaa dp3 r0.x, a1, r5.xyzz
adaaaaaaaaaaahacabaaaaoeaaaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, a1, r0.x
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
adaaaaaaafaaahacafaaaakeacaaaaaabkaaaaffabaaaaaa mul r5.xyz, r5.xyzz, c26.y
acaaaaaaaaaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r5.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaappacaaaaaabjaaaaoeabaaaaaa mul r3.xyz, r1.w, c25
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
abaaaaaaacaaahaeacaaaakeacaaaaaaadaaaakeacaaaaaa add v2.xyz, r2.xyzz, r3.xyzz
aaaaaaaaadaaahaeaeaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, r4.xyzz
bdaaaaaaafaaaiaeaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 v5.w, r0, c15
bdaaaaaaafaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v5.z, r0, c14
bdaaaaaaafaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v5.y, r0, c13
bdaaaaaaafaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v5.x, r0, c12
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
abaaaaaaabaaahaeafaaaakeacaaaaaabbaaaaoeabaaaaaa add v1.xyz, r5.xyzz, c17
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
abaaaaaaaeaaahaeafaaaakeacaaaaaabcaaaaoeabaaaaaa add v4.xyz, r5.xyzz, c18
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 20 [unity_SHAr]
Vector 21 [unity_SHAg]
Vector 22 [unity_SHAb]
Vector 23 [unity_SHBr]
Vector 24 [unity_SHBg]
Vector 25 [unity_SHBb]
Vector 26 [unity_SHC]
Matrix 13 [_LightMatrix0]
"!!ARBvp1.0
# 47 ALU
PARAM c[27] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..26] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R2.xyz, vertex.normal, c[17].w;
DP3 R0.zw, R2, c[6];
DP3 R4.x, R2, c[5];
DP3 R4.z, R2, c[7];
MOV R4.y, R0.w;
MOV R1.y, R0.z;
MOV R1.x, R4;
MOV R1.z, R4;
MOV R1.w, c[0].x;
MUL R2, R1.xyzz, R1.yzzx;
DP4 R3.z, R1, c[22];
DP4 R3.y, R1, c[21];
DP4 R3.x, R1, c[20];
MOV R1.w, c[0].x;
DP4 R1.z, R2, c[25];
DP4 R1.x, R2, c[23];
DP4 R1.y, R2, c[24];
ADD R2.xyz, R3, R1;
MOV R1.xyz, c[18];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
MAD R1.xyz, R3, c[17].w, -vertex.position;
MUL R0.y, R0.z, R0.z;
MAD R1.w, R4.x, R4.x, -R0.y;
DP3 R0.x, vertex.normal, -R1;
MUL R0.xyz, vertex.normal, R0.x;
MAD R0.xyz, -R0, c[0].y, -R1;
MUL R3.xyz, R1.w, c[26];
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
ADD result.texcoord[2].xyz, R2, R3;
MOV result.texcoord[3].xyz, R4;
DP4 result.texcoord[5].z, R0, c[15];
DP4 result.texcoord[5].y, R0, c[14];
DP4 result.texcoord[5].x, R0, c[13];
ADD result.texcoord[1].xyz, -R0, c[18];
ADD result.texcoord[4].xyz, -R0, c[19];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 47 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 12 [_LightMatrix0]
"vs_2_0
; 47 ALU
def c26, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r2.xyz, v1, c16.w
dp3 r0.zw, r2, c5
dp3 r4.x, r2, c4
dp3 r4.z, r2, c6
mov r4.y, r0.w
mov r1.y, r0.z
mov r1.x, r4
mov r1.z, r4
mov r1.w, c26.x
mul r2, r1.xyzz, r1.yzzx
dp4 r3.z, r1, c21
dp4 r3.y, r1, c20
dp4 r3.x, r1, c19
mov r1.w, c26.x
dp4 r1.z, r2, c24
dp4 r1.x, r2, c22
dp4 r1.y, r2, c23
add r2.xyz, r3, r1
mov r1.xyz, c17
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
mul r0.y, r0.z, r0.z
mad r1.w, r4.x, r4.x, -r0.y
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r0.xyz, -r0, c26.y, -r1
mul r3.xyz, r1.w, c25
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
add oT2.xyz, r2, r3
mov oT3.xyz, r4
dp4 oT5.z, r0, c14
dp4 oT5.y, r0, c13
dp4 oT5.x, r0, c12
add oT1.xyz, -r0, c17
add oT4.xyz, -r0, c18
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_5 = tmpvar_24;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_3;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_5, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_3 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize (xlv_TEXCOORD4);
  lightDir = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * (texture2D (_LightTextureB0, tmpvar_9).w * textureCube (_LightTexture0, xlv_TEXCOORD5).w)) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_5 = tmpvar_24;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_3;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_5, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_3 = tmpvar_7;
  mediump vec3 tmpvar_8;
  tmpvar_8 = normalize (xlv_TEXCOORD4);
  lightDir = tmpvar_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * (texture2D (_LightTextureB0, tmpvar_9).w * textureCube (_LightTexture0, xlv_TEXCOORD5).w)) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 12 [_LightMatrix0]
"agal_vs
c26 1.0 2.0 0.0 0.0
[bc]
adaaaaaaacaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r2.xyz, a1, c16.w
bcaaaaaaaaaaamacacaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r0.zw, r2.xyzz, c5
bcaaaaaaaeaaabacacaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r4.x, r2.xyzz, c4
bcaaaaaaaeaaaeacacaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r4.z, r2.xyzz, c6
aaaaaaaaaeaaacacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r0.w
aaaaaaaaabaaacacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r0.z
aaaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r4.x
aaaaaaaaabaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.z, r4.z
aaaaaaaaabaaaiacbkaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c26.x
adaaaaaaacaaapacabaaaakeacaaaaaaabaaaacjacaaaaaa mul r2, r1.xyzz, r1.yzzx
bdaaaaaaadaaaeacabaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r3.z, r1, c21
bdaaaaaaadaaacacabaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r3.y, r1, c20
bdaaaaaaadaaabacabaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r3.x, r1, c19
aaaaaaaaabaaaiacbkaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c26.x
bdaaaaaaabaaaeacacaaaaoeacaaaaaabiaaaaoeabaaaaaa dp4 r1.z, r2, c24
bdaaaaaaabaaabacacaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r1.x, r2, c22
bdaaaaaaabaaacacacaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r1.y, r2, c23
abaaaaaaacaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r3.xyzz, r1.xyzz
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
bdaaaaaaadaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r3.z, r1, c10
bdaaaaaaadaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r3.x, r1, c8
bdaaaaaaadaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r3.y, r1, c9
adaaaaaaafaaahacadaaaakeacaaaaaabaaaaappabaaaaaa mul r5.xyz, r3.xyzz, c16.w
acaaaaaaabaaahacafaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r5.xyzz, a0
adaaaaaaaaaaacacaaaaaakkacaaaaaaaaaaaakkacaaaaaa mul r0.y, r0.z, r0.z
adaaaaaaafaaaiacaeaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r5.w, r4.x, r4.x
acaaaaaaabaaaiacafaaaappacaaaaaaaaaaaaffacaaaaaa sub r1.w, r5.w, r0.y
bfaaaaaaafaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r1.xyzz
bcaaaaaaaaaaabacabaaaaoeaaaaaaaaafaaaakeacaaaaaa dp3 r0.x, a1, r5.xyzz
adaaaaaaaaaaahacabaaaaoeaaaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, a1, r0.x
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
adaaaaaaafaaahacafaaaakeacaaaaaabkaaaaffabaaaaaa mul r5.xyz, r5.xyzz, c26.y
acaaaaaaaaaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r5.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaappacaaaaaabjaaaaoeabaaaaaa mul r3.xyz, r1.w, c25
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
abaaaaaaacaaahaeacaaaakeacaaaaaaadaaaakeacaaaaaa add v2.xyz, r2.xyzz, r3.xyzz
aaaaaaaaadaaahaeaeaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, r4.xyzz
bdaaaaaaafaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v5.z, r0, c14
bdaaaaaaafaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v5.y, r0, c13
bdaaaaaaafaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v5.x, r0, c12
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
abaaaaaaabaaahaeafaaaakeacaaaaaabbaaaaoeabaaaaaa add v1.xyz, r5.xyzz, c17
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
abaaaaaaaeaaahaeafaaaakeacaaaaaabcaaaaoeabaaaaaa add v4.xyz, r5.xyzz, c18
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaafaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v5.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 20 [unity_SHAr]
Vector 21 [unity_SHAg]
Vector 22 [unity_SHAb]
Vector 23 [unity_SHBr]
Vector 24 [unity_SHBg]
Vector 25 [unity_SHBb]
Vector 26 [unity_SHC]
Matrix 13 [_LightMatrix0]
"!!ARBvp1.0
# 46 ALU
PARAM c[27] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..26] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MUL R2.xyz, vertex.normal, c[17].w;
DP3 R0.zw, R2, c[6];
DP3 R4.x, R2, c[5];
DP3 R4.z, R2, c[7];
MOV R4.y, R0.w;
MOV R1.y, R0.z;
MOV R1.x, R4;
MOV R1.z, R4;
MOV R1.w, c[0].x;
MUL R2, R1.xyzz, R1.yzzx;
DP4 R3.z, R1, c[22];
DP4 R3.y, R1, c[21];
DP4 R3.x, R1, c[20];
MOV R1.w, c[0].x;
DP4 R1.z, R2, c[25];
DP4 R1.x, R2, c[23];
DP4 R1.y, R2, c[24];
ADD R2.xyz, R3, R1;
MOV R1.xyz, c[18];
DP4 R3.z, R1, c[11];
DP4 R3.x, R1, c[9];
DP4 R3.y, R1, c[10];
MAD R1.xyz, R3, c[17].w, -vertex.position;
MUL R0.y, R0.z, R0.z;
MAD R1.w, R4.x, R4.x, -R0.y;
DP3 R0.x, vertex.normal, -R1;
MUL R0.xyz, vertex.normal, R0.x;
MAD R0.xyz, -R0, c[0].y, -R1;
MUL R3.xyz, R1.w, c[26];
DP3 result.texcoord[0].z, R0, c[7];
DP3 result.texcoord[0].y, R0, c[6];
DP3 result.texcoord[0].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
ADD result.texcoord[2].xyz, R2, R3;
MOV result.texcoord[3].xyz, R4;
DP4 result.texcoord[5].y, R0, c[14];
DP4 result.texcoord[5].x, R0, c[13];
ADD result.texcoord[1].xyz, -R0, c[18];
MOV result.texcoord[4].xyz, c[19];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 46 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 12 [_LightMatrix0]
"vs_2_0
; 46 ALU
def c26, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
mul r2.xyz, v1, c16.w
dp3 r0.zw, r2, c5
dp3 r4.x, r2, c4
dp3 r4.z, r2, c6
mov r4.y, r0.w
mov r1.y, r0.z
mov r1.x, r4
mov r1.z, r4
mov r1.w, c26.x
mul r2, r1.xyzz, r1.yzzx
dp4 r3.z, r1, c21
dp4 r3.y, r1, c20
dp4 r3.x, r1, c19
mov r1.w, c26.x
dp4 r1.z, r2, c24
dp4 r1.x, r2, c22
dp4 r1.y, r2, c23
add r2.xyz, r3, r1
mov r1.xyz, c17
dp4 r3.z, r1, c10
dp4 r3.x, r1, c8
dp4 r3.y, r1, c9
mad r1.xyz, r3, c16.w, -v0
mul r0.y, r0.z, r0.z
mad r1.w, r4.x, r4.x, -r0.y
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r0.xyz, -r0, c26.y, -r1
mul r3.xyz, r1.w, c25
dp3 oT0.z, r0, c6
dp3 oT0.y, r0, c5
dp3 oT0.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
add oT2.xyz, r2, r3
mov oT3.xyz, r4
dp4 oT5.y, r0, c13
dp4 oT5.x, r0, c12
add oT1.xyz, -r0, c17
mov oT4.xyz, c18
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = _WorldSpaceLightPos0.xyz;
  tmpvar_5 = tmpvar_24;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_3;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_5, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_3 = tmpvar_7;
  lightDir = xlv_TEXCOORD4;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * texture2D (_LightTexture0, xlv_TEXCOORD5).w) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES
#define SHADER_API_GLES 1
#define tex2D texture2D


#ifdef VERTEX
#define gl_ModelViewProjectionMatrix glstate_matrix_mvp
uniform mat4 glstate_matrix_mvp;

varying highp vec2 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying mediump vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_SHC;
uniform highp vec4 unity_SHBr;
uniform highp vec4 unity_SHBg;
uniform highp vec4 unity_SHBb;
uniform highp vec4 unity_SHAr;
uniform highp vec4 unity_SHAg;
uniform highp vec4 unity_SHAb;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp mat4 _LightMatrix0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec3 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = (tmpvar_7 * (tmpvar_1 * unity_Scale.w));
  mediump vec3 tmpvar_9;
  mediump vec4 normal;
  normal = tmpvar_8;
  mediump vec3 x3;
  highp float vC;
  mediump vec3 x2;
  mediump vec3 x1;
  highp float tmpvar_10;
  tmpvar_10 = dot (unity_SHAr, normal);
  x1.x = tmpvar_10;
  highp float tmpvar_11;
  tmpvar_11 = dot (unity_SHAg, normal);
  x1.y = tmpvar_11;
  highp float tmpvar_12;
  tmpvar_12 = dot (unity_SHAb, normal);
  x1.z = tmpvar_12;
  mediump vec4 tmpvar_13;
  tmpvar_13 = (normal.xyzz * normal.yzzx);
  highp float tmpvar_14;
  tmpvar_14 = dot (unity_SHBr, tmpvar_13);
  x2.x = tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = dot (unity_SHBg, tmpvar_13);
  x2.y = tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = dot (unity_SHBb, tmpvar_13);
  x2.z = tmpvar_16;
  mediump float tmpvar_17;
  tmpvar_17 = ((normal.x * normal.x) - (normal.y * normal.y));
  vC = tmpvar_17;
  highp vec3 tmpvar_18;
  tmpvar_18 = (unity_SHC.xyz * vC);
  x3 = tmpvar_18;
  tmpvar_9 = ((x1 + x2) + x3);
  tmpvar_6 = tmpvar_9;
  tmpvar_3 = tmpvar_6;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_20;
  tmpvar_20[0] = _Object2World[0].xyz;
  tmpvar_20[1] = _Object2World[1].xyz;
  tmpvar_20[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_21;
  tmpvar_21 = (tmpvar_20 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_19).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_2 = tmpvar_21;
  mat3 tmpvar_22;
  tmpvar_22[0] = _Object2World[0].xyz;
  tmpvar_22[1] = _Object2World[1].xyz;
  tmpvar_22[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_22 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = _WorldSpaceLightPos0.xyz;
  tmpvar_5 = tmpvar_24;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD2 = tmpvar_3;
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD1;
varying mediump vec3 xlv_TEXCOORD0;
uniform lowp vec4 _ReflectColor;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec3 tmpvar_1;
  lowp vec3 tmpvar_2;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  lowp vec3 tmpvar_3;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 c_i0;
  c_i0 = _Color;
  worldReflVec = tmpvar_1;
  lowp vec4 tmpvar_4;
  tmpvar_4 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_4;
  lowp float tmpvar_5;
  tmpvar_5 = clamp ((1.0 - max (dot (normalize (tmpvar_2), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_6;
  tmpvar_6 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_5, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((reflcol.xyz * _ReflectColor.xyz) + c_i0.xyz);
  tmpvar_3 = tmpvar_7;
  lightDir = xlv_TEXCOORD4;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_3 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * texture2D (_LightTexture0, xlv_TEXCOORD5).w) * 2.0));
  c_i0_i1.w = refl2Refr;
  c = c_i0_i1;
  c.w = refl2Refr;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 19 [unity_SHAr]
Vector 20 [unity_SHAg]
Vector 21 [unity_SHAb]
Vector 22 [unity_SHBr]
Vector 23 [unity_SHBg]
Vector 24 [unity_SHBb]
Vector 25 [unity_SHC]
Matrix 12 [_LightMatrix0]
"agal_vs
c26 1.0 2.0 0.0 0.0
[bc]
adaaaaaaacaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r2.xyz, a1, c16.w
bcaaaaaaaaaaamacacaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r0.zw, r2.xyzz, c5
bcaaaaaaaeaaabacacaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r4.x, r2.xyzz, c4
bcaaaaaaaeaaaeacacaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r4.z, r2.xyzz, c6
aaaaaaaaaeaaacacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r4.y, r0.w
aaaaaaaaabaaacacaaaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.y, r0.z
aaaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.x, r4.x
aaaaaaaaabaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r1.z, r4.z
aaaaaaaaabaaaiacbkaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c26.x
adaaaaaaacaaapacabaaaakeacaaaaaaabaaaacjacaaaaaa mul r2, r1.xyzz, r1.yzzx
bdaaaaaaadaaaeacabaaaaoeacaaaaaabfaaaaoeabaaaaaa dp4 r3.z, r1, c21
bdaaaaaaadaaacacabaaaaoeacaaaaaabeaaaaoeabaaaaaa dp4 r3.y, r1, c20
bdaaaaaaadaaabacabaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r3.x, r1, c19
aaaaaaaaabaaaiacbkaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c26.x
bdaaaaaaabaaaeacacaaaaoeacaaaaaabiaaaaoeabaaaaaa dp4 r1.z, r2, c24
bdaaaaaaabaaabacacaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r1.x, r2, c22
bdaaaaaaabaaacacacaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r1.y, r2, c23
abaaaaaaacaaahacadaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r3.xyzz, r1.xyzz
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
bdaaaaaaadaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r3.z, r1, c10
bdaaaaaaadaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r3.x, r1, c8
bdaaaaaaadaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r3.y, r1, c9
adaaaaaaafaaahacadaaaakeacaaaaaabaaaaappabaaaaaa mul r5.xyz, r3.xyzz, c16.w
acaaaaaaabaaahacafaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r5.xyzz, a0
adaaaaaaaaaaacacaaaaaakkacaaaaaaaaaaaakkacaaaaaa mul r0.y, r0.z, r0.z
adaaaaaaafaaaiacaeaaaaaaacaaaaaaaeaaaaaaacaaaaaa mul r5.w, r4.x, r4.x
acaaaaaaabaaaiacafaaaappacaaaaaaaaaaaaffacaaaaaa sub r1.w, r5.w, r0.y
bfaaaaaaafaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r1.xyzz
bcaaaaaaaaaaabacabaaaaoeaaaaaaaaafaaaakeacaaaaaa dp3 r0.x, a1, r5.xyzz
adaaaaaaaaaaahacabaaaaoeaaaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, a1, r0.x
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
adaaaaaaafaaahacafaaaakeacaaaaaabkaaaaffabaaaaaa mul r5.xyz, r5.xyzz, c26.y
acaaaaaaaaaaahacafaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r5.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaappacaaaaaabjaaaaoeabaaaaaa mul r3.xyz, r1.w, c25
bcaaaaaaaaaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v0.z, r0.xyzz, c6
bcaaaaaaaaaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v0.y, r0.xyzz, c5
bcaaaaaaaaaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v0.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
abaaaaaaacaaahaeacaaaakeacaaaaaaadaaaakeacaaaaaa add v2.xyz, r2.xyzz, r3.xyzz
aaaaaaaaadaaahaeaeaaaakeacaaaaaaaaaaaaaaaaaaaaaa mov v3.xyz, r4.xyzz
bdaaaaaaafaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v5.y, r0, c13
bdaaaaaaafaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v5.x, r0, c12
bfaaaaaaafaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r5.xyz, r0.xyzz
abaaaaaaabaaahaeafaaaakeacaaaaaabbaaaaoeabaaaaaa add v1.xyz, r5.xyzz, c17
aaaaaaaaaeaaahaebcaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.xyz, c18
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.w, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
aaaaaaaaafaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v5.zw, c0
"
}

}
Program "fp" {
// Fragment combos: 5
//   opengl - ALU: 21 to 32, TEX: 1 to 3
//   d3d9 - ALU: 24 to 34, TEX: 1 to 3
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 26 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.20373535, 0.79638672, 1, 0 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
DP3 R0.w, fragment.texcoord[5], fragment.texcoord[5];
DP3 R1.y, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.y, R1.y;
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R2.xyz, R1.y, fragment.texcoord[3];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[1];
DP3 R1.x, R1, R2;
DP3 R1.y, fragment.texcoord[4], fragment.texcoord[4];
RSQ R2.x, R1.y;
MAX R1.x, R1, c[4].w;
ADD_SAT R1.x, -R1, c[4].z;
POW R1.x, R1.x, c[3].x;
MAD R1.w, R1.x, c[4].y, c[4].x;
MOV R1.xyz, c[1];
MAD R0.xyz, R0, c[2], R1;
MUL R2.xyz, R2.x, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R2;
MUL R0.xyz, R0, c[0];
MAX R1.x, R1, c[4].w;
MAX result.color.w, R1, c[4];
TEX R0.w, R0.w, texture[1], 2D;
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[5].x;
END
# 26 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 29 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c4, 0.00000000, 1.00000000, 0.79638672, 0.20373535
def c5, 2.00000000, 0, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t3.xyz
dcl t4.xyz
dcl t5.xyz
texld r2, t0, s0
dp3 r0.x, t5, t5
mov r0.xy, r0.x
dp3_pp r1.x, t3, t3
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t3
mov_pp r4.xyz, c1
mad_pp r2.xyz, r2, c2, r4
mul_pp r2.xyz, r2, c0
texld r3, r0, s1
dp3_pp r0.x, t1, t1
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t1
dp3_pp r0.x, r0, r1
max_pp r0.x, r0, c4
add_pp_sat r0.x, -r0, c4.y
pow_pp r1.w, r0.x, c3.x
mov_pp r0.x, r1.w
dp3_pp r1.x, t4, t4
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t4
dp3_pp r1.x, t3, r1
mad_pp r0.x, r0, c4.z, c4.w
max_pp r1.x, r1, c4
mul_pp r1.x, r1, r3
mul_pp r1.xyz, r1.x, r2
mul_pp r1.xyz, r1, c5.x
max_pp r1.w, r0.x, c4.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c4 0.0 1.0 0.796387 0.203735
c5 2.0 0.0 0.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r2, v0, s0 <cube wrap linear point>
bcaaaaaaaaaaabacafaaaaoeaeaaaaaaafaaaaoeaeaaaaaa dp3 r0.x, v5, v5
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
aaaaaaaaadaaahacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r3.xyz, c1
adaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c2
abaaaaaaacaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r2.xyz, r2.xyzz, r3.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
ciaaaaaaaaaaapacaaaaaafeacaaaaaaabaaaaaaafaababb tex r0, r0.xyyy, s1 <2d wrap linear point>
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r0.xyz, r0.x, v1
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r0.x, r0.x, c4
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa add r0.x, r0.x, c4.y
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaabaaapacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r1, r0.x, c3.x
aaaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.x
bcaaaaaaabaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r1.x, v4, v4
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaaeaaaaoeaeaaaaaa mul r1.xyz, r1.x, v4
bcaaaaaaabaaabacadaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v3, r1.xyzz
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
adaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaappacaaaaaa mul r1.x, r1.x, r0.w
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r1.x, r2.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa mul r0.x, r0.x, c4.z
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaappabaaaaaa add r0.x, r0.x, c4.w
adaaaaaaabaaahacabaaaakeacaaaaaaafaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c5.x
ahaaaaaaabaaaiacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa max r1.w, r0.x, c4.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 21 ALU, 1 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.20373535, 0.79638672, 1, 0 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
DP3 R1.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.x, R1.x;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
MUL R2.xyz, R1.x, fragment.texcoord[3];
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, fragment.texcoord[1];
DP3 R0.w, R1, R2;
MOV R1.xyz, c[1];
MAD R0.xyz, R0, c[2], R1;
MAX R0.w, R0, c[4];
ADD_SAT R0.w, -R0, c[4].z;
POW R0.w, R0.w, c[3].x;
MAD R0.w, R0, c[4].y, c[4].x;
MOV R2.xyz, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R2;
MUL R0.xyz, R0, c[0];
MAX R1.x, R1, c[4].w;
MUL R0.xyz, R1.x, R0;
MAX result.color.w, R0, c[4];
MUL result.color.xyz, R0, c[5].x;
END
# 21 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
"ps_2_0
; 24 ALU, 1 TEX
dcl_cube s0
def c4, 0.00000000, 1.00000000, 0.79638672, 0.20373535
def c5, 2.00000000, 0, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t3.xyz
dcl t4.xyz
texld r1, t0, s0
dp3_pp r2.x, t3, t3
dp3_pp r0.x, t1, t1
rsq_pp r2.x, r2.x
rsq_pp r0.x, r0.x
mul_pp r2.xyz, r2.x, t3
mul_pp r0.xyz, r0.x, t1
dp3_pp r0.x, r0, r2
max_pp r0.x, r0, c4
add_pp_sat r0.x, -r0, c4.y
pow_pp r2.w, r0.x, c3.x
mov_pp r0.x, r2.w
mov_pp r2.xyz, c1
mad_pp r2.xyz, r1, c2, r2
mov_pp r3.xyz, t4
dp3_pp r1.x, t3, r3
mad_pp r0.x, r0, c4.z, c4.w
mul_pp r2.xyz, r2, c0
max_pp r1.x, r1, c4
mul_pp r1.xyz, r1.x, r2
mul_pp r1.xyz, r1, c5.x
max_pp r1.w, r0.x, c4.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
"agal_ps
c4 0.0 1.0 0.796387 0.203735
c5 2.0 0.0 0.0 0.0
[bc]
ciaaaaaaabaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r1, v0, s0 <cube wrap linear point>
bcaaaaaaacaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r2.x, v3, v3
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaacaaahacacaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r2.xyz, r2.x, v3
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r0.xyz, r0.x, v1
bcaaaaaaaaaaabacaaaaaakeacaaaaaaacaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r2.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r0.x, r0.x, c4
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa add r0.x, r0.x, c4.y
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaacaaapacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r2, r0.x, c3.x
aaaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r2.x
aaaaaaaaacaaahacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r2.xyz, c1
adaaaaaaadaaahacabaaaakeacaaaaaaacaaaaoeabaaaaaa mul r3.xyz, r1.xyzz, c2
abaaaaaaacaaahacadaaaakeacaaaaaaacaaaakeacaaaaaa add r2.xyz, r3.xyzz, r2.xyzz
aaaaaaaaadaaahacaeaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r3.xyz, v4
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaakeacaaaaaa dp3 r1.x, v3, r3.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa mul r0.x, r0.x, c4.z
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaappabaaaaaa add r0.x, r0.x, c4.w
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r1.x, r2.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaafaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c5.x
ahaaaaaaabaaaiacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa max r1.w, r0.x, c4.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 32 ALU, 3 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.20373535, 0.79638672, 1, 0 },
		{ 0.5, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
RCP R0.x, fragment.texcoord[5].w;
MAD R1.xy, fragment.texcoord[5], R0.x, c[5].x;
DP3 R1.z, fragment.texcoord[5], fragment.texcoord[5];
TEX R0.w, R1, texture[1], 2D;
TEX R1.w, R1.z, texture[2], 2D;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
DP3 R1.y, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.y, R1.y;
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R2.xyz, R1.y, fragment.texcoord[3];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[1];
DP3 R1.x, R1, R2;
MAX R1.x, R1, c[4].w;
ADD_SAT R1.x, -R1, c[4].z;
POW R1.x, R1.x, c[3].x;
MAD R2.x, R1, c[4].y, c[4];
MOV R1.xyz, c[1];
MAD R0.xyz, R0, c[2], R1;
DP3 R2.y, fragment.texcoord[4], fragment.texcoord[4];
RSQ R2.y, R2.y;
MUL R1.xyz, R2.y, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
SLT R1.y, c[4].w, fragment.texcoord[5].z;
MUL R0.w, R1.y, R0;
MUL R1.y, R0.w, R1.w;
MAX R0.w, R1.x, c[4];
MUL R0.xyz, R0, c[0];
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0.w, R0;
MAX result.color.w, R2.x, c[4];
MUL result.color.xyz, R0, c[5].y;
END
# 32 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"ps_2_0
; 34 ALU, 3 TEX
dcl_cube s0
dcl_2d s1
dcl_2d s2
def c4, 0.00000000, 1.00000000, 0.79638672, 0.20373535
def c5, 0.50000000, 2.00000000, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t3.xyz
dcl t4.xyz
dcl t5
texld r2, t0, s0
dp3 r1.x, t5, t5
mov r1.xy, r1.x
rcp r0.x, t5.w
mad r0.xy, t5, r0.x, c5.x
texld r3, r1, s2
texld r0, r0, s1
dp3_pp r1.x, t3, t3
dp3_pp r0.x, t1, t1
rsq_pp r1.x, r1.x
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t1
mul_pp r1.xyz, r1.x, t3
dp3_pp r0.x, r0, r1
max_pp r0.x, r0, c4
add_pp_sat r0.x, -r0, c4.y
pow_pp r1.w, r0.x, c3.x
mov_pp r0.xyz, c1
mad_pp r2.xyz, r2, c2, r0
mov_pp r0.x, r1.w
mad_pp r0.x, r0, c4.z, c4.w
mul_pp r4.xyz, r2, c0
dp3_pp r1.x, t4, t4
rsq_pp r2.x, r1.x
cmp r1.x, -t5.z, c4, c4.y
mul_pp r2.xyz, r2.x, t4
dp3_pp r2.x, t3, r2
mul_pp r1.x, r1, r0.w
mul_pp r1.x, r1, r3
max_pp r2.x, r2, c4
mul_pp r1.x, r2, r1
mul_pp r1.xyz, r1.x, r4
mul_pp r1.xyz, r1, c5.y
max_pp r1.w, r0.x, c4.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "SPOT" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
SetTexture 2 [_LightTextureB0] 2D
"agal_ps
c4 0.0 1.0 0.796387 0.203735
c5 0.5 2.0 0.0 0.0
[bc]
bcaaaaaaabaaabacafaaaaoeaeaaaaaaafaaaaoeaeaaaaaa dp3 r1.x, v5, v5
aaaaaaaaacaaadacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r2.xy, r1.x
afaaaaaaaaaaabacafaaaappaeaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, v5.w
adaaaaaaabaaadacafaaaaoeaeaaaaaaaaaaaaaaacaaaaaa mul r1.xy, v5, r0.x
abaaaaaaabaaadacabaaaafeacaaaaaaafaaaaaaabaaaaaa add r1.xy, r1.xyyy, c5.x
ciaaaaaaaaaaapacacaaaafeacaaaaaaacaaaaaaafaababb tex r0, r2.xyyy, s2 <2d wrap linear point>
ciaaaaaaadaaapacabaaaafeacaaaaaaabaaaaaaafaababb tex r3, r1.xyyy, s1 <2d wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r2, v0, s0 <cube wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r0.xyz, r0.x, v1
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r0.x, r0.x, c4
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa add r0.x, r0.x, c4.y
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaabaaapacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r1, r0.x, c3.x
aaaaaaaaaaaaahacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.xyz, c1
adaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c2
abaaaaaaacaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r2.xyz, r2.xyzz, r0.xyzz
aaaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.x
adaaaaaaadaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r3.xyz, r2.xyzz, c0
bcaaaaaaabaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r1.x, v4, v4
akaaaaaaacaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r1.x
adaaaaaaacaaahacacaaaaaaacaaaaaaaeaaaaoeaeaaaaaa mul r2.xyz, r2.x, v4
bcaaaaaaacaaabacadaaaaoeaeaaaaaaacaaaakeacaaaaaa dp3 r2.x, v3, r2.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa mul r0.x, r0.x, c4.z
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaappabaaaaaa add r0.x, r0.x, c4.w
bfaaaaaaacaaaiacafaaaakkaeaaaaaaaaaaaaaaaaaaaaaa neg r2.w, v5.z
ckaaaaaaabaaabacacaaaappacaaaaaaafaaaakkabaaaaaa slt r1.x, r2.w, c5.z
adaaaaaaabaaabacabaaaaaaacaaaaaaadaaaappacaaaaaa mul r1.x, r1.x, r3.w
adaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaappacaaaaaa mul r1.x, r1.x, r0.w
ahaaaaaaacaaabacacaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r2.x, r2.x, c4
adaaaaaaabaaabacacaaaaaaacaaaaaaabaaaaaaacaaaaaa mul r1.x, r2.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaakeacaaaaaa mul r1.xyz, r1.x, r3.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaafaaaaffabaaaaaa mul r1.xyz, r1.xyzz, c5.y
ahaaaaaaabaaaiacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa max r1.w, r0.x, c4.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 28 ALU, 3 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.20373535, 0.79638672, 1, 0 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
TEX R1.w, fragment.texcoord[5], texture[2], CUBE;
DP3 R0.w, fragment.texcoord[5], fragment.texcoord[5];
DP3 R1.y, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.y, R1.y;
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R2.xyz, R1.y, fragment.texcoord[3];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[1];
DP3 R1.x, R1, R2;
MAX R1.x, R1, c[4].w;
ADD_SAT R1.x, -R1, c[4].z;
POW R1.x, R1.x, c[3].x;
MAD R2.x, R1, c[4].y, c[4];
MOV R1.xyz, c[1];
MAD R0.xyz, R0, c[2], R1;
DP3 R2.y, fragment.texcoord[4], fragment.texcoord[4];
RSQ R2.y, R2.y;
MUL R1.xyz, R2.y, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
MUL R0.xyz, R0, c[0];
MAX result.color.w, R2.x, c[4];
TEX R0.w, R0.w, texture[1], 2D;
MUL R1.y, R0.w, R1.w;
MAX R0.w, R1.x, c[4];
MUL R0.w, R0, R1.y;
MUL R0.xyz, R0.w, R0;
MUL result.color.xyz, R0, c[5].x;
END
# 28 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"ps_2_0
; 30 ALU, 3 TEX
dcl_cube s0
dcl_2d s1
dcl_cube s2
def c4, 0.00000000, 1.00000000, 0.79638672, 0.20373535
def c5, 2.00000000, 0, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t3.xyz
dcl t4.xyz
dcl t5.xyz
texld r2, t0, s0
dp3 r0.x, t5, t5
mov r1.xy, r0.x
texld r3, r1, s1
texld r0, t5, s2
dp3_pp r1.x, t3, t3
dp3_pp r0.x, t1, t1
rsq_pp r1.x, r1.x
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t1
mul_pp r1.xyz, r1.x, t3
dp3_pp r0.x, r0, r1
max_pp r0.x, r0, c4
add_pp_sat r0.x, -r0, c4.y
pow_pp r1.w, r0.x, c3.x
mov_pp r0.x, r1.w
mov_pp r1.xyz, c1
mad_pp r2.xyz, r2, c2, r1
dp3_pp r1.x, t4, t4
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t4
dp3_pp r1.x, t3, r1
mad_pp r0.x, r0, c4.z, c4.w
mul_pp r2.xyz, r2, c0
mul r3.x, r3, r0.w
max_pp r1.x, r1, c4
mul_pp r1.x, r1, r3
mul_pp r1.xyz, r1.x, r2
mul_pp r1.xyz, r1, c5.x
max_pp r1.w, r0.x, c4.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "POINT_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTextureB0] 2D
SetTexture 2 [_LightTexture0] CUBE
"agal_ps
c4 0.0 1.0 0.796387 0.203735
c5 2.0 0.0 0.0 0.0
[bc]
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r2, v0, s0 <cube wrap linear point>
bcaaaaaaaaaaabacafaaaaoeaeaaaaaaafaaaaoeaeaaaaaa dp3 r0.x, v5, v5
aaaaaaaaabaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.xy, r0.x
ciaaaaaaadaaapacabaaaafeacaaaaaaabaaaaaaafaababb tex r3, r1.xyyy, s1 <2d wrap linear point>
ciaaaaaaaaaaapacafaaaaoeaeaaaaaaacaaaaaaafbababb tex r0, v5, s2 <cube wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r0.xyz, r0.x, v1
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r0.x, r0.x, c4
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa add r0.x, r0.x, c4.y
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaabaaapacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r1, r0.x, c3.x
aaaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.x
aaaaaaaaabaaahacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c1
adaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c2
abaaaaaaacaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r2.xyzz, r1.xyzz
bcaaaaaaabaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r1.x, v4, v4
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaaeaaaaoeaeaaaaaa mul r1.xyz, r1.x, v4
bcaaaaaaabaaabacadaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v3, r1.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa mul r0.x, r0.x, c4.z
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaappabaaaaaa add r0.x, r0.x, c4.w
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
adaaaaaaadaaabacadaaaappacaaaaaaaaaaaappacaaaaaa mul r3.x, r3.w, r0.w
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
adaaaaaaabaaabacabaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r1.x, r1.x, r3.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r1.x, r2.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaafaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c5.x
ahaaaaaaabaaaiacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa max r1.w, r0.x, c4.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 23 ALU, 2 TEX
PARAM c[6] = { program.local[0..3],
		{ 0.20373535, 0.79638672, 1, 0 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[0], texture[0], CUBE;
TEX R0.w, fragment.texcoord[5], texture[1], 2D;
DP3 R1.y, fragment.texcoord[3], fragment.texcoord[3];
RSQ R1.y, R1.y;
DP3 R1.x, fragment.texcoord[1], fragment.texcoord[1];
MUL R2.xyz, R1.y, fragment.texcoord[3];
RSQ R1.x, R1.x;
MUL R1.xyz, R1.x, fragment.texcoord[1];
DP3 R1.x, R1, R2;
MAX R1.x, R1, c[4].w;
ADD_SAT R1.x, -R1, c[4].z;
POW R1.x, R1.x, c[3].x;
MAD R1.w, R1.x, c[4].y, c[4].x;
MOV R1.xyz, c[1];
MAD R0.xyz, R0, c[2], R1;
MOV R2.xyz, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R2;
MAX R1.x, R1, c[4].w;
MUL R0.xyz, R0, c[0];
MUL R0.w, R1.x, R0;
MUL R0.xyz, R0.w, R0;
MAX result.color.w, R1, c[4];
MUL result.color.xyz, R0, c[5].x;
END
# 23 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"ps_2_0
; 25 ALU, 2 TEX
dcl_cube s0
dcl_2d s1
def c4, 0.00000000, 1.00000000, 0.79638672, 0.20373535
def c5, 2.00000000, 0, 0, 0
dcl t0.xyz
dcl t1.xyz
dcl t3.xyz
dcl t4.xyz
dcl t5.xy
texld r0, t5, s1
texld r2, t0, s0
dp3_pp r1.x, t3, t3
dp3_pp r0.x, t1, t1
rsq_pp r1.x, r1.x
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t1
mul_pp r1.xyz, r1.x, t3
dp3_pp r0.x, r0, r1
max_pp r0.x, r0, c4
add_pp_sat r0.x, -r0, c4.y
pow_pp r1.w, r0.x, c3.x
mov_pp r0.x, r1.w
mad_pp r0.x, r0, c4.z, c4.w
mov_pp r1.xyz, c1
mad_pp r2.xyz, r2, c2, r1
mov_pp r1.xyz, t4
dp3_pp r1.x, t3, r1
max_pp r1.x, r1, c4
mul_pp r2.xyz, r2, c0
mul_pp r1.x, r1, r0.w
mul_pp r1.xyz, r1.x, r2
mul_pp r1.xyz, r1, c5.x
max_pp r1.w, r0.x, c4.x
mov_pp oC0, r1
"
}

SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "glesdesktop " {
Keywords { "DIRECTIONAL_COOKIE" }
"!!GLES"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_ReflectColor]
Float 3 [_FresnelPower]
SetTexture 0 [_Cube] CUBE
SetTexture 1 [_LightTexture0] 2D
"agal_ps
c4 0.0 1.0 0.796387 0.203735
c5 2.0 0.0 0.0 0.0
[bc]
ciaaaaaaaaaaapacafaaaaoeaeaaaaaaabaaaaaaafaababb tex r0, v5, s1 <2d wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafbababb tex r2, v0, s0 <cube wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
bcaaaaaaaaaaabacabaaaaoeaeaaaaaaabaaaaoeaeaaaaaa dp3 r0.x, v1, v1
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaabaaaaoeaeaaaaaa mul r0.xyz, r0.x, v1
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r0.x, r0.x, c4
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaaffabaaaaaa add r0.x, r0.x, c4.y
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaabaaapacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa pow r1, r0.x, c3.x
aaaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaakkabaaaaaa mul r0.x, r0.x, c4.z
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaeaaaappabaaaaaa add r0.x, r0.x, c4.w
aaaaaaaaabaaahacabaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c1
adaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c2
abaaaaaaacaaahacacaaaakeacaaaaaaabaaaakeacaaaaaa add r2.xyz, r2.xyzz, r1.xyzz
aaaaaaaaabaaahacaeaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, v4
bcaaaaaaabaaabacadaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v3, r1.xyzz
ahaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaaoeabaaaaaa max r1.x, r1.x, c4
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
adaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaappacaaaaaa mul r1.x, r1.x, r0.w
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r1.x, r2.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaafaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c5.x
ahaaaaaaabaaaiacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa max r1.w, r0.x, c4.x
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

}
	}

#LINE 56


}
	
FallBack "Reflective/VertexLit"
} 

