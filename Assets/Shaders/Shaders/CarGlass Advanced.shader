Shader "RedDotGames/Mobile/Car Glass Advanced" {
Properties {
	_Color ("Main Color (RGB)", Color) = (1,1,1,1)
	_ReflectColor ("Reflection Color (RGB)", Color) = (1,1,1,0.5)
	_MainTex ("Base (RGB) Mask (A)", 2D) = "black" {} 
	_Cube ("Reflection Cubemap (CUBE)", Cube) = "_Skybox" { TexGen CubeReflect }
	_FresnelPower ("Fresnel Power", Range(0.05,5.0)) = 0.75
	_TintColor ("Tint Color (RGB)", Color) = (1,1,1,1)
	_AlphaPower ("Alpha", Range(0.0,2.0)) = 1.0
	_OpaqueReflection ("Opaque Reflection", Range(0.0,1.0)) = 0.0
	
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
//   opengl - ALU: 26 to 72
//   d3d9 - ALU: 26 to 72
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
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
Vector 22 [_MainTex_ST]
"!!ARBvp1.0
# 43 ALU
PARAM c[23] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..22] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 R3.w, R1, c[6];
DP3 R2.w, R1, c[7];
DP3 R0.w, R1, c[5];
MOV R0.x, R3.w;
MOV R0.y, R2.w;
MOV R0.z, c[0].x;
MUL R1, R0.wxyy, R0.xyyw;
DP4 R2.z, R0.wxyz, c[17];
DP4 R2.y, R0.wxyz, c[16];
DP4 R2.x, R0.wxyz, c[15];
DP4 R0.z, R1, c[20];
DP4 R0.x, R1, c[18];
DP4 R0.y, R1, c[19];
ADD R2.xyz, R2, R0;
MOV R1.w, c[0].x;
MOV R1.xyz, c[14];
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R1.xyz, R0, c[13].w, -vertex.position;
MUL R0.y, R3.w, R3.w;
MAD R1.w, R0, R0, -R0.y;
DP3 R0.x, vertex.normal, -R1;
MUL R0.xyz, vertex.normal, R0.x;
MAD R0.xyz, -R0, c[0].y, -R1;
MUL R3.xyz, R1.w, c[21];
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[4].xyz, R2, R3;
ADD result.texcoord[2].xyz, -R0, c[14];
MOV result.texcoord[3].z, R2.w;
MOV result.texcoord[3].y, R3.w;
MOV result.texcoord[3].x, R0.w;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[22], c[22].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 43 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
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
Vector 21 [_MainTex_ST]
"vs_2_0
; 43 ALU
def c22, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r1.xyz, v1, c12.w
dp3 r3.w, r1, c5
dp3 r2.w, r1, c6
dp3 r0.w, r1, c4
mov r0.x, r3.w
mov r0.y, r2.w
mov r0.z, c22.x
mul r1, r0.wxyy, r0.xyyw
dp4 r2.z, r0.wxyz, c16
dp4 r2.y, r0.wxyz, c15
dp4 r2.x, r0.wxyz, c14
dp4 r0.z, r1, c19
dp4 r0.x, r1, c17
dp4 r0.y, r1, c18
add r2.xyz, r2, r0
mov r1.w, c22.x
mov r1.xyz, c13
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r1.xyz, r0, c12.w, -v0
mul r0.y, r3.w, r3.w
mad r1.w, r0, r0, -r0.y
dp3 r0.x, v1, -r1
mul r0.xyz, v1, r0.x
mad r0.xyz, -r0, c22.y, -r1
mul r3.xyz, r1.w, c20
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT4.xyz, r2, r3
add oT2.xyz, -r0, c13
mov oT3.z, r2.w
mov oT3.y, r3.w
mov oT3.x, r0.w
mad oT0.xy, v2, c21, c21.zwzw
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
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
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
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
  shlight = tmpvar_13;
  tmpvar_5 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD3, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_4 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + (tmpvar_4 * 0.25));
  c.w = tmpvar_5;
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
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
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
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
  shlight = tmpvar_13;
  tmpvar_5 = shlight;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD3, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_4 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + (tmpvar_4 * 0.25));
  c.w = tmpvar_5;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
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
Vector 21 [_MainTex_ST]
"agal_vs
c22 1.0 2.0 0.0 0.0
[bc]
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bcaaaaaaadaaaiacabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r3.w, r1.xyzz, c5
bcaaaaaaacaaaiacabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r2.w, r1.xyzz, c6
bcaaaaaaaaaaaiacabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r0.w, r1.xyzz, c4
aaaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.w
aaaaaaaaaaaaacacacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r0.y, r2.w
aaaaaaaaaaaaaeacbgaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r0.z, c22.x
adaaaaaaabaaapacaaaaaafdacaaaaaaaaaaaaneacaaaaaa mul r1, r0.wxyy, r0.xyyw
bdaaaaaaacaaaeacaaaaaajdacaaaaaabaaaaaoeabaaaaaa dp4 r2.z, r0.wxyz, c16
bdaaaaaaacaaacacaaaaaajdacaaaaaaapaaaaoeabaaaaaa dp4 r2.y, r0.wxyz, c15
bdaaaaaaacaaabacaaaaaajdacaaaaaaaoaaaaoeabaaaaaa dp4 r2.x, r0.wxyz, c14
bdaaaaaaaaaaaeacabaaaaoeacaaaaaabdaaaaoeabaaaaaa dp4 r0.z, r1, c19
bdaaaaaaaaaaabacabaaaaoeacaaaaaabbaaaaoeabaaaaaa dp4 r0.x, r1, c17
bdaaaaaaaaaaacacabaaaaoeacaaaaaabcaaaaoeabaaaaaa dp4 r0.y, r1, c18
abaaaaaaacaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa add r2.xyz, r2.xyzz, r0.xyzz
aaaaaaaaabaaaiacbgaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c22.x
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaaeaaahacaaaaaakeacaaaaaaamaaaappabaaaaaa mul r4.xyz, r0.xyzz, c12.w
acaaaaaaabaaahacaeaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r4.xyzz, a0
adaaaaaaaaaaacacadaaaappacaaaaaaadaaaappacaaaaaa mul r0.y, r3.w, r3.w
adaaaaaaaeaaaiacaaaaaappacaaaaaaaaaaaappacaaaaaa mul r4.w, r0.w, r0.w
acaaaaaaabaaaiacaeaaaappacaaaaaaaaaaaaffacaaaaaa sub r1.w, r4.w, r0.y
bfaaaaaaaeaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r1.xyzz
bcaaaaaaaaaaabacabaaaaoeaaaaaaaaaeaaaakeacaaaaaa dp3 r0.x, a1, r4.xyzz
adaaaaaaaaaaahacabaaaaoeaaaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, a1, r0.x
bfaaaaaaaeaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r0.xyzz
adaaaaaaaeaaahacaeaaaakeacaaaaaabgaaaaffabaaaaaa mul r4.xyz, r4.xyzz, c22.y
acaaaaaaaaaaahacaeaaaakeacaaaaaaabaaaakeacaaaaaa sub r0.xyz, r4.xyzz, r1.xyzz
adaaaaaaadaaahacabaaaappacaaaaaabeaaaaoeabaaaaaa mul r3.xyz, r1.w, c20
bcaaaaaaabaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r0.xyzz, c6
bcaaaaaaabaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r0.xyzz, c5
bcaaaaaaabaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
abaaaaaaaeaaahaeacaaaakeacaaaaaaadaaaakeacaaaaaa add v4.xyz, r2.xyzz, r3.xyzz
bfaaaaaaaeaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r4.xyz, r0.xyzz
abaaaaaaacaaahaeaeaaaakeacaaaaaaanaaaaoeabaaaaaa add v2.xyz, r4.xyzz, c13
aaaaaaaaadaaaeaeacaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v3.z, r2.w
aaaaaaaaadaaacaeadaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v3.y, r3.w
aaaaaaaaadaaabaeaaaaaappacaaaaaaaaaaaaaaaaaaaaaa mov v3.x, r0.w
adaaaaaaaeaaadacadaaaaoeaaaaaaaabfaaaaoeabaaaaaa mul r4.xy, a3, c21
abaaaaaaaaaaadaeaeaaaafeacaaaaaabfaaaaooabaaaaaa add v0.xy, r4.xyyy, c21.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
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
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 26 ALU
PARAM c[17] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[14];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[13].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[2].xyz, -R0, c[14];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 26 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"vs_2_0
; 26 ALU
def c16, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mov r1.xyz, c13
mov r1.w, c16.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c12.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c16.y, -r0
mul r1.xyz, v1, c12.w
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT2.xyz, -r0, c13
dp3 oT3.z, r1, c6
dp3 oT3.y, r1, c5
dp3 oT3.x, r1, c4
mad oT0.xy, v2, c15, c15.zwzw
mad oT4.xy, v3, c14, c14.zwzw
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  c.xyz = (tmpvar_4 * (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz));
  c.w = tmpvar_5;
  c.xyz = (c.xyz + (tmpvar_4 * 0.25));
  c.w = tmpvar_5;
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  c.xyz = (tmpvar_4 * ((8.0 * tmpvar_12.w) * tmpvar_12.xyz));
  c.w = tmpvar_5;
  c.xyz = (c.xyz + (tmpvar_4 * 0.25));
  c.w = tmpvar_5;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"agal_vs
c16 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
aaaaaaaaabaaaiacbaaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c16.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaaamaaaappabaaaaaa mul r2.xyz, r0.xyzz, c12.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaabaaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c16.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bcaaaaaaabaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r0.xyzz, c6
bcaaaaaaabaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r0.xyzz, c5
bcaaaaaaabaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaaanaaaaoeabaaaaaa add v2.xyz, r2.xyzz, c13
bcaaaaaaadaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v3.z, r1.xyzz, c6
bcaaaaaaadaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v3.y, r1.xyzz, c5
bcaaaaaaadaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v3.x, r1.xyzz, c4
adaaaaaaacaaadacadaaaaoeaaaaaaaaapaaaaoeabaaaaaa mul r2.xy, a3, c15
abaaaaaaaaaaadaeacaaaafeacaaaaaaapaaaaooabaaaaaa add v0.xy, r2.xyyy, c15.zwzw
adaaaaaaacaaadacaeaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r2.xy, a4, c14
abaaaaaaaeaaadaeacaaaafeacaaaaaaaoaaaaooabaaaaaa add v4.xy, r2.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
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
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_LightmapST]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 26 ALU
PARAM c[17] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[14];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[13].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[2].xyz, -R0, c[14];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
MAD result.texcoord[4].xy, vertex.texcoord[1], c[15], c[15].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 26 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"vs_2_0
; 26 ALU
def c16, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
mov r1.xyz, c13
mov r1.w, c16.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c12.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c16.y, -r0
mul r1.xyz, v1, c12.w
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT2.xyz, -r0, c13
dp3 oT3.z, r1, c6
dp3 oT3.y, r1, c5
dp3 oT3.x, r1, c4
mad oT0.xy, v2, c15, c15.zwzw
mad oT4.xy, v3, c14, c14.zwzw
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_12;
  tmpvar_12 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD4).xyz);
  lm_i0 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_4 * lm_i0);
  c.xyz = tmpvar_13;
  c.w = tmpvar_5;
  c.xyz = (c.xyz + (tmpvar_4 * 0.25));
  c.w = tmpvar_5;
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;
uniform highp vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord1;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  highp vec2 tmpvar_5;
  tmpvar_5 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_7;
  tmpvar_7[0] = _Object2World[0].xyz;
  tmpvar_7[1] = _Object2World[1].xyz;
  tmpvar_7[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_7 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_6).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_8;
  mat3 tmpvar_9;
  tmpvar_9[0] = _Object2World[0].xyz;
  tmpvar_9[1] = _Object2World[1].xyz;
  tmpvar_9[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_10;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform sampler2D unity_Lightmap;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  c = vec4(0.0, 0.0, 0.0, 0.0);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (unity_Lightmap, xlv_TEXCOORD4);
  mediump vec3 lm_i0;
  lowp vec3 tmpvar_13;
  tmpvar_13 = ((8.0 * tmpvar_12.w) * tmpvar_12.xyz);
  lm_i0 = tmpvar_13;
  mediump vec3 tmpvar_14;
  tmpvar_14 = (tmpvar_4 * lm_i0);
  c.xyz = tmpvar_14;
  c.w = tmpvar_5;
  c.xyz = (c.xyz + (tmpvar_4 * 0.25));
  c.w = tmpvar_5;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 14 [unity_LightmapST]
Vector 15 [_MainTex_ST]
"agal_vs
c16 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
aaaaaaaaabaaaiacbaaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c16.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaaamaaaappabaaaaaa mul r2.xyz, r0.xyzz, c12.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaabaaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c16.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bcaaaaaaabaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r0.xyzz, c6
bcaaaaaaabaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r0.xyzz, c5
bcaaaaaaabaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaaanaaaaoeabaaaaaa add v2.xyz, r2.xyzz, c13
bcaaaaaaadaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v3.z, r1.xyzz, c6
bcaaaaaaadaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v3.y, r1.xyzz, c5
bcaaaaaaadaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v3.x, r1.xyzz, c4
adaaaaaaacaaadacadaaaaoeaaaaaaaaapaaaaoeabaaaaaa mul r2.xy, a3, c15
abaaaaaaaaaaadaeacaaaafeacaaaaaaapaaaaooabaaaaaa add v0.xy, r2.xyyy, c15.zwzw
adaaaaaaacaaadacaeaaaaoeaaaaaaaaaoaaaaoeabaaaaaa mul r2.xy, a4, c14
abaaaaaaaeaaadaeacaaaafeacaaaaaaaoaaaaooabaaaaaa add v4.xy, r2.xyyy, c14.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
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
Bind "texcoord" TexCoord0
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
Vector 30 [_MainTex_ST]
"!!ARBvp1.0
# 72 ALU
PARAM c[31] = { { 1, 2, 0 },
		state.matrix.mvp,
		program.local[5..30] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R3.xyz, vertex.normal, c[13].w;
DP3 R5.x, R3, c[5];
DP4 R4.zw, vertex.position, c[6];
ADD R2, -R4.z, c[16];
DP3 R4.z, R3, c[6];
DP4 R3.w, vertex.position, c[5];
MUL R0, R4.z, R2;
ADD R1, -R3.w, c[15];
MUL R2, R2, R2;
MOV R5.y, R4.z;
MOV R5.w, c[0].x;
DP4 R4.xy, vertex.position, c[7];
MAD R0, R5.x, R1, R0;
MAD R2, R1, R1, R2;
ADD R1, -R4.x, c[17];
DP3 R4.x, R3, c[7];
MAD R2, R1, R1, R2;
MAD R0, R4.x, R1, R0;
MUL R1, R2, c[18];
ADD R1, R1, c[0].x;
MOV R5.z, R4.x;
RSQ R2.x, R2.x;
RSQ R2.y, R2.y;
RSQ R2.z, R2.z;
RSQ R2.w, R2.w;
MUL R0, R0, R2;
DP4 R2.z, R5, c[25];
DP4 R2.y, R5, c[24];
DP4 R2.x, R5, c[23];
RCP R1.x, R1.x;
RCP R1.y, R1.y;
RCP R1.w, R1.w;
RCP R1.z, R1.z;
MAX R0, R0, c[0].z;
MUL R0, R0, R1;
MUL R1.xyz, R0.y, c[20];
MAD R1.xyz, R0.x, c[19], R1;
MAD R0.xyz, R0.z, c[21], R1;
MUL R1, R5.xyzz, R5.yzzx;
MAD R0.xyz, R0.w, c[22], R0;
DP4 R3.z, R1, c[28];
DP4 R3.x, R1, c[26];
DP4 R3.y, R1, c[27];
ADD R3.xyz, R2, R3;
MOV R1.w, c[0].x;
MOV R1.xyz, c[14];
DP4 R2.z, R1, c[11];
DP4 R2.y, R1, c[10];
DP4 R2.x, R1, c[9];
MUL R0.w, R4.z, R4.z;
MAD R1.w, R5.x, R5.x, -R0;
MAD R1.xyz, R2, c[13].w, -vertex.position;
DP3 R0.w, vertex.normal, -R1;
MUL R5.yzw, R1.w, c[29].xxyz;
ADD R3.xyz, R3, R5.yzww;
ADD result.texcoord[4].xyz, R3, R0;
MUL R2.xyz, vertex.normal, R0.w;
MAD R1.xyz, -R2, c[0].y, -R1;
MOV R3.x, R4.w;
MOV R3.y, R4;
DP3 result.texcoord[1].z, R1, c[7];
DP3 result.texcoord[1].y, R1, c[6];
DP3 result.texcoord[1].x, R1, c[5];
ADD result.texcoord[2].xyz, -R3.wxyw, c[14];
MOV result.texcoord[3].z, R4.x;
MOV result.texcoord[3].y, R4.z;
MOV result.texcoord[3].x, R5;
MAD result.texcoord[0].xy, vertex.texcoord[0], c[30], c[30].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 72 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
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
Vector 29 [_MainTex_ST]
"vs_2_0
; 72 ALU
def c30, 1.00000000, 2.00000000, 0.00000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r3.xyz, v1, c12.w
dp3 r5.x, r3, c4
dp4 r4.zw, v0, c5
add r2, -r4.z, c15
dp3 r4.z, r3, c5
dp4 r3.w, v0, c4
mul r0, r4.z, r2
add r1, -r3.w, c14
mul r2, r2, r2
mov r5.y, r4.z
mov r5.w, c30.x
dp4 r4.xy, v0, c6
mad r0, r5.x, r1, r0
mad r2, r1, r1, r2
add r1, -r4.x, c16
dp3 r4.x, r3, c6
mad r2, r1, r1, r2
mad r0, r4.x, r1, r0
mul r1, r2, c17
add r1, r1, c30.x
mov r5.z, r4.x
rsq r2.x, r2.x
rsq r2.y, r2.y
rsq r2.z, r2.z
rsq r2.w, r2.w
mul r0, r0, r2
dp4 r2.z, r5, c24
dp4 r2.y, r5, c23
dp4 r2.x, r5, c22
rcp r1.x, r1.x
rcp r1.y, r1.y
rcp r1.w, r1.w
rcp r1.z, r1.z
max r0, r0, c30.z
mul r0, r0, r1
mul r1.xyz, r0.y, c19
mad r1.xyz, r0.x, c18, r1
mad r0.xyz, r0.z, c20, r1
mul r1, r5.xyzz, r5.yzzx
mad r0.xyz, r0.w, c21, r0
dp4 r3.z, r1, c27
dp4 r3.x, r1, c25
dp4 r3.y, r1, c26
add r3.xyz, r2, r3
mov r1.w, c30.x
mov r1.xyz, c13
dp4 r2.z, r1, c10
dp4 r2.y, r1, c9
dp4 r2.x, r1, c8
mul r0.w, r4.z, r4.z
mad r1.w, r5.x, r5.x, -r0
mad r1.xyz, r2, c12.w, -v0
dp3 r0.w, v1, -r1
mul r5.yzw, r1.w, c28.xxyz
add r3.xyz, r3, r5.yzww
add oT4.xyz, r3, r0
mul r2.xyz, v1, r0.w
mad r1.xyz, -r2, c30.y, -r1
mov r3.x, r4.w
mov r3.y, r4
dp3 oT1.z, r1, c6
dp3 oT1.y, r1, c5
dp3 oT1.x, r1, c4
add oT2.xyz, -r3.wxyw, c13
mov oT3.z, r4.x
mov oT3.y, r4.z
mov oT3.x, r5
mad oT0.xy, v2, c29, c29.zwzw
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
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
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
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
  shlight = tmpvar_13;
  tmpvar_5 = shlight;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosX0 - tmpvar_23.x);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosY0 - tmpvar_23.y);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosZ0 - tmpvar_23.z);
  highp vec4 tmpvar_27;
  tmpvar_27 = (((tmpvar_24 * tmpvar_24) + (tmpvar_25 * tmpvar_25)) + (tmpvar_26 * tmpvar_26));
  highp vec4 tmpvar_28;
  tmpvar_28 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_24 * tmpvar_11.x) + (tmpvar_25 * tmpvar_11.y)) + (tmpvar_26 * tmpvar_11.z)) * inversesqrt (tmpvar_27))) * (1.0/((1.0 + (tmpvar_27 * unity_4LightAtten0)))));
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_5 + ((((unity_LightColor[0].xyz * tmpvar_28.x) + (unity_LightColor[1].xyz * tmpvar_28.y)) + (unity_LightColor[2].xyz * tmpvar_28.z)) + (unity_LightColor[3].xyz * tmpvar_28.w)));
  tmpvar_5 = tmpvar_29;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD3, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_4 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + (tmpvar_4 * 0.25));
  c.w = tmpvar_5;
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
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
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  highp vec3 shlight;
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  lowp vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_11;
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
  shlight = tmpvar_13;
  tmpvar_5 = shlight;
  highp vec3 tmpvar_23;
  tmpvar_23 = (_Object2World * _glesVertex).xyz;
  highp vec4 tmpvar_24;
  tmpvar_24 = (unity_4LightPosX0 - tmpvar_23.x);
  highp vec4 tmpvar_25;
  tmpvar_25 = (unity_4LightPosY0 - tmpvar_23.y);
  highp vec4 tmpvar_26;
  tmpvar_26 = (unity_4LightPosZ0 - tmpvar_23.z);
  highp vec4 tmpvar_27;
  tmpvar_27 = (((tmpvar_24 * tmpvar_24) + (tmpvar_25 * tmpvar_25)) + (tmpvar_26 * tmpvar_26));
  highp vec4 tmpvar_28;
  tmpvar_28 = (max (vec4(0.0, 0.0, 0.0, 0.0), ((((tmpvar_24 * tmpvar_11.x) + (tmpvar_25 * tmpvar_11.y)) + (tmpvar_26 * tmpvar_11.z)) * inversesqrt (tmpvar_27))) * (1.0/((1.0 + (tmpvar_27 * unity_4LightAtten0)))));
  highp vec3 tmpvar_29;
  tmpvar_29 = (tmpvar_5 + ((((unity_LightColor[0].xyz * tmpvar_28.x) + (unity_LightColor[1].xyz * tmpvar_28.y)) + (unity_LightColor[2].xyz * tmpvar_28.z)) + (unity_LightColor[3].xyz * tmpvar_28.w)));
  tmpvar_5 = tmpvar_29;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying lowp vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _WorldSpaceLightPos0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD3, _WorldSpaceLightPos0.xyz)) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.xyz = (c_i0_i1.xyz + (tmpvar_4 * xlv_TEXCOORD4));
  c.xyz = (c.xyz + (tmpvar_4 * 0.25));
  c.w = tmpvar_5;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
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
Vector 29 [_MainTex_ST]
"agal_vs
c30 1.0 2.0 0.0 0.0
[bc]
adaaaaaaadaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r3.xyz, a1, c12.w
bcaaaaaaafaaabacadaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 r5.x, r3.xyzz, c4
bdaaaaaaaeaaamacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r4.zw, a0, c5
bfaaaaaaacaaaeacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa neg r2.z, r4.z
abaaaaaaacaaapacacaaaakkacaaaaaaapaaaaoeabaaaaaa add r2, r2.z, c15
bcaaaaaaaeaaaeacadaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 r4.z, r3.xyzz, c5
bdaaaaaaadaaaiacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r3.w, a0, c4
adaaaaaaaaaaapacaeaaaakkacaaaaaaacaaaaoeacaaaaaa mul r0, r4.z, r2
bfaaaaaaabaaaiacadaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r1.w, r3.w
abaaaaaaabaaapacabaaaappacaaaaaaaoaaaaoeabaaaaaa add r1, r1.w, c14
adaaaaaaacaaapacacaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r2, r2, r2
aaaaaaaaafaaacacaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov r5.y, r4.z
aaaaaaaaafaaaiacboaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r5.w, c30.x
bdaaaaaaaeaaadacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r4.xy, a0, c6
adaaaaaaagaaapacafaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r5.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
bfaaaaaaabaaabacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r1.x, r4.x
abaaaaaaabaaapacabaaaaaaacaaaaaabaaaaaoeabaaaaaa add r1, r1.x, c16
bcaaaaaaaeaaabacadaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 r4.x, r3.xyzz, c6
adaaaaaaagaaapacabaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r6, r1, r1
abaaaaaaacaaapacagaaaaoeacaaaaaaacaaaaoeacaaaaaa add r2, r6, r2
adaaaaaaagaaapacaeaaaaaaacaaaaaaabaaaaoeacaaaaaa mul r6, r4.x, r1
abaaaaaaaaaaapacagaaaaoeacaaaaaaaaaaaaoeacaaaaaa add r0, r6, r0
adaaaaaaabaaapacacaaaaoeacaaaaaabbaaaaoeabaaaaaa mul r1, r2, c17
abaaaaaaabaaapacabaaaaoeacaaaaaaboaaaaaaabaaaaaa add r1, r1, c30.x
aaaaaaaaafaaaeacaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r5.z, r4.x
akaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r2.x
akaaaaaaacaaacacacaaaaffacaaaaaaaaaaaaaaaaaaaaaa rsq r2.y, r2.y
akaaaaaaacaaaeacacaaaakkacaaaaaaaaaaaaaaaaaaaaaa rsq r2.z, r2.z
akaaaaaaacaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r2.w, r2.w
adaaaaaaaaaaapacaaaaaaoeacaaaaaaacaaaaoeacaaaaaa mul r0, r0, r2
bdaaaaaaacaaaeacafaaaaoeacaaaaaabiaaaaoeabaaaaaa dp4 r2.z, r5, c24
bdaaaaaaacaaacacafaaaaoeacaaaaaabhaaaaoeabaaaaaa dp4 r2.y, r5, c23
bdaaaaaaacaaabacafaaaaoeacaaaaaabgaaaaoeabaaaaaa dp4 r2.x, r5, c22
afaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rcp r1.x, r1.x
afaaaaaaabaaacacabaaaaffacaaaaaaaaaaaaaaaaaaaaaa rcp r1.y, r1.y
afaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa rcp r1.w, r1.w
afaaaaaaabaaaeacabaaaakkacaaaaaaaaaaaaaaaaaaaaaa rcp r1.z, r1.z
ahaaaaaaaaaaapacaaaaaaoeacaaaaaaboaaaakkabaaaaaa max r0, r0, c30.z
adaaaaaaaaaaapacaaaaaaoeacaaaaaaabaaaaoeacaaaaaa mul r0, r0, r1
adaaaaaaabaaahacaaaaaaffacaaaaaabdaaaaoeabaaaaaa mul r1.xyz, r0.y, c19
adaaaaaaagaaahacaaaaaaaaacaaaaaabcaaaaoeabaaaaaa mul r6.xyz, r0.x, c18
abaaaaaaabaaahacagaaaakeacaaaaaaabaaaakeacaaaaaa add r1.xyz, r6.xyzz, r1.xyzz
adaaaaaaaaaaahacaaaaaakkacaaaaaabeaaaaoeabaaaaaa mul r0.xyz, r0.z, c20
abaaaaaaaaaaahacaaaaaakeacaaaaaaabaaaakeacaaaaaa add r0.xyz, r0.xyzz, r1.xyzz
adaaaaaaabaaapacafaaaakeacaaaaaaafaaaacjacaaaaaa mul r1, r5.xyzz, r5.yzzx
adaaaaaaagaaahacaaaaaappacaaaaaabfaaaaoeabaaaaaa mul r6.xyz, r0.w, c21
abaaaaaaaaaaahacagaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r6.xyzz, r0.xyzz
bdaaaaaaadaaaeacabaaaaoeacaaaaaablaaaaoeabaaaaaa dp4 r3.z, r1, c27
bdaaaaaaadaaabacabaaaaoeacaaaaaabjaaaaoeabaaaaaa dp4 r3.x, r1, c25
bdaaaaaaadaaacacabaaaaoeacaaaaaabkaaaaoeabaaaaaa dp4 r3.y, r1, c26
abaaaaaaadaaahacacaaaakeacaaaaaaadaaaakeacaaaaaa add r3.xyz, r2.xyzz, r3.xyzz
aaaaaaaaabaaaiacboaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c30.x
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
bdaaaaaaacaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r2.z, r1, c10
bdaaaaaaacaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r2.y, r1, c9
bdaaaaaaacaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r2.x, r1, c8
adaaaaaaaaaaaiacaeaaaakkacaaaaaaaeaaaakkacaaaaaa mul r0.w, r4.z, r4.z
adaaaaaaagaaaiacafaaaaaaacaaaaaaafaaaaaaacaaaaaa mul r6.w, r5.x, r5.x
acaaaaaaabaaaiacagaaaappacaaaaaaaaaaaappacaaaaaa sub r1.w, r6.w, r0.w
adaaaaaaagaaahacacaaaakeacaaaaaaamaaaappabaaaaaa mul r6.xyz, r2.xyzz, c12.w
acaaaaaaabaaahacagaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r1.xyz, r6.xyzz, a0
bfaaaaaaagaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyz, r1.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaagaaaakeacaaaaaa dp3 r0.w, a1, r6.xyzz
adaaaaaaafaaaoacabaaaappacaaaaaabmaaaajaabaaaaaa mul r5.yzw, r1.w, c28.xxyz
abaaaaaaadaaahacadaaaakeacaaaaaaafaaaapjacaaaaaa add r3.xyz, r3.xyzz, r5.yzww
abaaaaaaaeaaahaeadaaaakeacaaaaaaaaaaaakeacaaaaaa add v4.xyz, r3.xyzz, r0.xyzz
adaaaaaaacaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r2.xyz, a1, r0.w
bfaaaaaaagaaahacacaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyz, r2.xyzz
adaaaaaaagaaahacagaaaakeacaaaaaaboaaaaffabaaaaaa mul r6.xyz, r6.xyzz, c30.y
acaaaaaaabaaahacagaaaakeacaaaaaaabaaaakeacaaaaaa sub r1.xyz, r6.xyzz, r1.xyzz
aaaaaaaaadaaabacaeaaaappacaaaaaaaaaaaaaaaaaaaaaa mov r3.x, r4.w
aaaaaaaaadaaacacaeaaaaffacaaaaaaaaaaaaaaaaaaaaaa mov r3.y, r4.y
bcaaaaaaabaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r1.xyzz, c6
bcaaaaaaabaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r1.xyzz, c5
bcaaaaaaabaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r1.xyzz, c4
bfaaaaaaagaaalacadaaaapdacaaaaaaaaaaaaaaaaaaaaaa neg r6.xyw, r3.wxww
abaaaaaaacaaahaeagaaaafdacaaaaaaanaaaaoeabaaaaaa add v2.xyz, r6.wxyy, c13
aaaaaaaaadaaaeaeaeaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v3.z, r4.x
aaaaaaaaadaaacaeaeaaaakkacaaaaaaaaaaaaaaaaaaaaaa mov v3.y, r4.z
aaaaaaaaadaaabaeafaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov v3.x, r5.x
adaaaaaaagaaadacadaaaaoeaaaaaaaabnaaaaoeabaaaaaa mul r6.xy, a3, c29
abaaaaaaaaaaadaeagaaaafeacaaaaaabnaaaaooabaaaaaa add v0.xy, r6.xyyy, c29.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
aaaaaaaaacaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v2.w, c0
aaaaaaaaadaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v3.w, c0
aaaaaaaaaeaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.w, c0
"
}

}
Program "fp" {
// Fragment combos: 3
//   opengl - ALU: 27 to 29, TEX: 2 to 3
//   d3d9 - ALU: 28 to 31, TEX: 2 to 3
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_TintColor]
Vector 4 [_ReflectColor]
Float 5 [_AlphaPower]
Float 6 [_OpaqueReflection]
Float 7 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 29 ALU, 2 TEX
PARAM c[10] = { program.local[0..7],
		{ 0, 1, 0.79638672, 0.20373535 },
		{ 0.25, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[1], CUBE;
MOV R1.w, c[8].y;
ADD R1.w, R1, -c[6].x;
MUL R1.xyz, R1, c[4];
MUL R0.xyz, R0, c[2];
MAD R0.w, -R0, R1, c[8].y;
MUL R1.xyz, R1, c[3];
MAD R2.xyz, R1, R0.w, R0;
DP3 R0.y, fragment.texcoord[3], fragment.texcoord[3];
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
MUL R1.xyz, R0.y, fragment.texcoord[3];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
DP3 R0.w, R0, R1;
MAX R0.w, R0, c[8].x;
DP3 R1.x, fragment.texcoord[3], c[0];
ADD_SAT R0.w, -R0, c[8].y;
POW R0.w, R0.w, c[7].x;
MAD R0.w, R0, c[8].z, c[8];
MAX R0.w, R0, c[8].x;
MAX R1.x, R1, c[8];
MUL R0.xyz, R2, c[1];
MUL R0.xyz, R1.x, R0;
MUL R1.xyz, R2, fragment.texcoord[4];
MAD R0.xyz, R0, c[9].y, R1;
MAD result.color.xyz, R2, c[9].x, R0;
MUL_SAT result.color.w, R0, c[5].x;
END
# 29 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" }
Vector 0 [_WorldSpaceLightPos0]
Vector 1 [_LightColor0]
Vector 2 [_Color]
Vector 3 [_TintColor]
Vector 4 [_ReflectColor]
Float 5 [_AlphaPower]
Float 6 [_OpaqueReflection]
Float 7 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"ps_2_0
; 31 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c8, 0.00000000, 0.79638672, 0.20373535, 1.00000000
def c9, 2.00000000, 0.25000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r3, t1, s1
texld r2, t0, s0
dp3_pp r1.x, t3, t3
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r1.x
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r1.x, t3
mul_pp r0.xyz, r0.x, t2
dp3_pp r0.x, r0, r1
mul_pp r1.xyz, r3, c4
mul_pp r3.xyz, r1, c3
max_pp r0.x, r0, c8
mov_pp r1.x, c6
add_pp r1.x, c8.w, -r1
mul_pp r2.xyz, r2, c2
mad_pp r1.x, -r2.w, r1, c8.w
mad_pp r1.xyz, r3, r1.x, r2
add_pp_sat r0.x, -r0, c8.w
pow_pp r2.w, r0.x, c7.x
dp3_pp r0.x, t3, c0
mul_pp r3.xyz, r1, c1
max_pp r0.x, r0, c8
mul_pp r3.xyz, r0.x, r3
mov_pp r0.x, r2.w
mul_pp r2.xyz, r1, t4
mad_pp r0.x, r0, c8.y, c8.z
mad_pp r2.xyz, r3, c9.x, r2
max_pp r0.x, r0, c8
mad_pp r1.xyz, r1, c9.y, r2
mul_pp_sat r1.w, r0.x, c5.x
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
Vector 3 [_TintColor]
Vector 4 [_ReflectColor]
Float 5 [_AlphaPower]
Float 6 [_OpaqueReflection]
Float 7 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"agal_ps
c8 0.0 0.796387 0.203735 1.0
c9 2.0 0.25 0.0 0.0
[bc]
ciaaaaaaadaaapacabaaaaoeaeaaaaaaabaaaaaaafbababb tex r3, v1, s1 <cube wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
adaaaaaaabaaahacadaaaakeacaaaaaaaeaaaaoeabaaaaaa mul r1.xyz, r3.xyzz, c4
adaaaaaaadaaahacabaaaakeacaaaaaaadaaaaoeabaaaaaa mul r3.xyz, r1.xyzz, c3
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r0.x, c8
aaaaaaaaabaaabacagaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.x, c6
acaaaaaaabaaabacaiaaaappabaaaaaaabaaaaaaacaaaaaa sub r1.x, c8.w, r1.x
adaaaaaaacaaahacacaaaakeacaaaaaaacaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c2
bfaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r0.w, r2.w
adaaaaaaabaaabacaaaaaappacaaaaaaabaaaaaaacaaaaaa mul r1.x, r0.w, r1.x
abaaaaaaabaaabacabaaaaaaacaaaaaaaiaaaappabaaaaaa add r1.x, r1.x, c8.w
adaaaaaaabaaahacadaaaakeacaaaaaaabaaaaaaacaaaaaa mul r1.xyz, r3.xyzz, r1.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaappabaaaaaa add r0.x, r0.x, c8.w
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaacaaapacaaaaaaaaacaaaaaaahaaaaaaabaaaaaa pow r2, r0.x, c7.x
bcaaaaaaaaaaabacadaaaaoeaeaaaaaaaaaaaaoeabaaaaaa dp3 r0.x, v3, c0
adaaaaaaadaaahacabaaaakeacaaaaaaabaaaaoeabaaaaaa mul r3.xyz, r1.xyzz, c1
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r0.x, c8
adaaaaaaadaaahacaaaaaaaaacaaaaaaadaaaakeacaaaaaa mul r3.xyz, r0.x, r3.xyzz
aaaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r2.x
adaaaaaaacaaahacabaaaakeacaaaaaaaeaaaaoeaeaaaaaa mul r2.xyz, r1.xyzz, v4
adaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaffabaaaaaa mul r0.x, r0.x, c8.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaakkabaaaaaa add r0.x, r0.x, c8.z
adaaaaaaadaaahacadaaaakeacaaaaaaajaaaaaaabaaaaaa mul r3.xyz, r3.xyzz, c9.x
abaaaaaaacaaahacadaaaakeacaaaaaaacaaaakeacaaaaaa add r2.xyz, r3.xyzz, r2.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaaiaaaaoeabaaaaaa max r0.x, r0.x, c8
adaaaaaaabaaahacabaaaakeacaaaaaaajaaaaffabaaaaaa mul r1.xyz, r1.xyzz, c9.y
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
adaaaaaaabaaaiacaaaaaaaaacaaaaaaafaaaaaaabaaaaaa mul r1.w, r0.x, c5.x
bgaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa sat r1.w, r1.w
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_AlphaPower]
Float 4 [_OpaqueReflection]
Float 5 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 27 ALU, 3 TEX
PARAM c[8] = { program.local[0..5],
		{ 0, 1, 0.79638672, 0.20373535 },
		{ 8, 0.25 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[4], texture[2], 2D;
TEX R1, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[1], CUBE;
DP3 R3.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R3.x, R3.x;
DP3 R2.w, fragment.texcoord[2], fragment.texcoord[2];
MUL R2.xyz, R2, c[2];
RSQ R2.w, R2.w;
MUL R4.xyz, R3.x, fragment.texcoord[3];
MUL R3.xyz, R2.w, fragment.texcoord[2];
DP3 R3.x, R3, R4;
MOV R2.w, c[6].y;
ADD R3.y, R2.w, -c[4].x;
MAX R3.x, R3, c[6];
MAD R1.w, -R1, R3.y, c[6].y;
MUL R0.xyz, R0.w, R0;
ADD_SAT R2.w, -R3.x, c[6].y;
MUL R1.xyz, R1, c[0];
MUL R2.xyz, R2, c[1];
MAD R1.xyz, R2, R1.w, R1;
MUL R0.xyz, R0, R1;
POW R1.w, R2.w, c[5].x;
MAD R0.w, R1, c[6].z, c[6];
MUL R1.xyz, R1, c[7].y;
MAX R0.w, R0, c[6].x;
MAD result.color.xyz, R0, c[7].x, R1;
MUL_SAT result.color.w, R0, c[3].x;
END
# 27 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_AlphaPower]
Float 4 [_OpaqueReflection]
Float 5 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 28 ALU, 3 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c6, 0.00000000, 0.79638672, 0.20373535, 1.00000000
def c7, 0.25000000, 8.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xy
texld r3, t4, s2
texld r2, t0, s0
texld r4, t1, s1
dp3_pp r1.x, t3, t3
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r1.x
rsq_pp r0.x, r0.x
mul_pp r4.xyz, r4, c2
mul_pp r1.xyz, r1.x, t3
mul_pp r0.xyz, r0.x, t2
dp3_pp r0.x, r0, r1
max_pp r0.x, r0, c6
add_pp_sat r0.x, -r0, c6.w
pow_pp r1.w, r0.x, c5.x
mov_pp r0.x, c4
add_pp r0.x, c6.w, -r0
mad_pp r0.x, -r2.w, r0, c6.w
mul_pp r4.xyz, r4, c1
mul_pp r2.xyz, r2, c0
mad_pp r2.xyz, r4, r0.x, r2
mov_pp r0.x, r1.w
mul_pp r1.xyz, r3.w, r3
mul_pp r1.xyz, r1, r2
mad_pp r0.x, r0, c6.y, c6.z
mul_pp r2.xyz, r2, c7.x
max_pp r0.x, r0, c6
mad_pp r1.xyz, r1, c7.y, r2
mul_pp_sat r1.w, r0.x, c3.x
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
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_AlphaPower]
Float 4 [_OpaqueReflection]
Float 5 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [unity_Lightmap] 2D
"agal_ps
c6 0.0 0.796387 0.203735 1.0
c7 0.25 8.0 0.0 0.0
[bc]
ciaaaaaaadaaapacaeaaaaoeaeaaaaaaacaaaaaaafaababb tex r3, v4, s2 <2d wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
ciaaaaaaaeaaapacabaaaaoeaeaaaaaaabaaaaaaafbababb tex r4, v1, s1 <cube wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaeaaahacaeaaaakeacaaaaaaacaaaaoeabaaaaaa mul r4.xyz, r4.xyzz, c2
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaaoeabaaaaaa max r0.x, r0.x, c6
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaappabaaaaaa add r0.x, r0.x, c6.w
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaabaaapacaaaaaaaaacaaaaaaafaaaaaaabaaaaaa pow r1, r0.x, c5.x
aaaaaaaaaaaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c4
acaaaaaaaaaaabacagaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c6.w, r0.x
bfaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r0.w, r2.w
adaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r0.w, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaappabaaaaaa add r0.x, r0.x, c6.w
adaaaaaaaeaaahacaeaaaakeacaaaaaaabaaaaoeabaaaaaa mul r4.xyz, r4.xyzz, c1
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
adaaaaaaaeaaahacaeaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r4.xyz, r4.xyzz, r0.x
abaaaaaaacaaahacaeaaaakeacaaaaaaacaaaakeacaaaaaa add r2.xyz, r4.xyzz, r2.xyzz
aaaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.x
adaaaaaaabaaahacadaaaappacaaaaaaadaaaakeacaaaaaa mul r1.xyz, r3.w, r3.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r1.xyzz, r2.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaaffabaaaaaa mul r0.x, r0.x, c6.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaakkabaaaaaa add r0.x, r0.x, c6.z
adaaaaaaacaaahacacaaaakeacaaaaaaahaaaaaaabaaaaaa mul r2.xyz, r2.xyzz, c7.x
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaaoeabaaaaaa max r0.x, r0.x, c6
adaaaaaaabaaahacabaaaakeacaaaaaaahaaaaffabaaaaaa mul r1.xyz, r1.xyzz, c7.y
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
adaaaaaaabaaaiacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa mul r1.w, r0.x, c3.x
bgaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa sat r1.w, r1.w
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_AlphaPower]
Float 4 [_OpaqueReflection]
Float 5 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [unity_Lightmap] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 27 ALU, 3 TEX
PARAM c[8] = { program.local[0..5],
		{ 0, 1, 0.79638672, 0.20373535 },
		{ 8, 0.25 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEX R0, fragment.texcoord[4], texture[2], 2D;
TEX R1, fragment.texcoord[0], texture[0], 2D;
TEX R2.xyz, fragment.texcoord[1], texture[1], CUBE;
DP3 R3.x, fragment.texcoord[3], fragment.texcoord[3];
RSQ R3.x, R3.x;
DP3 R2.w, fragment.texcoord[2], fragment.texcoord[2];
MUL R2.xyz, R2, c[2];
RSQ R2.w, R2.w;
MUL R4.xyz, R3.x, fragment.texcoord[3];
MUL R3.xyz, R2.w, fragment.texcoord[2];
DP3 R3.x, R3, R4;
MOV R2.w, c[6].y;
ADD R3.y, R2.w, -c[4].x;
MAX R3.x, R3, c[6];
MAD R1.w, -R1, R3.y, c[6].y;
MUL R0.xyz, R0.w, R0;
ADD_SAT R2.w, -R3.x, c[6].y;
MUL R1.xyz, R1, c[0];
MUL R2.xyz, R2, c[1];
MAD R1.xyz, R2, R1.w, R1;
MUL R0.xyz, R0, R1;
POW R1.w, R2.w, c[5].x;
MAD R0.w, R1, c[6].z, c[6];
MUL R1.xyz, R1, c[7].y;
MAX R0.w, R0, c[6].x;
MAD result.color.xyz, R0, c[7].x, R1;
MUL_SAT result.color.w, R0, c[3].x;
END
# 27 instructions, 5 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" }
Vector 0 [_Color]
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_AlphaPower]
Float 4 [_OpaqueReflection]
Float 5 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [unity_Lightmap] 2D
"ps_2_0
; 28 ALU, 3 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c6, 0.00000000, 0.79638672, 0.20373535, 1.00000000
def c7, 0.25000000, 8.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xy
texld r3, t4, s2
texld r2, t0, s0
texld r4, t1, s1
dp3_pp r1.x, t3, t3
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r1.x
rsq_pp r0.x, r0.x
mul_pp r4.xyz, r4, c2
mul_pp r1.xyz, r1.x, t3
mul_pp r0.xyz, r0.x, t2
dp3_pp r0.x, r0, r1
max_pp r0.x, r0, c6
add_pp_sat r0.x, -r0, c6.w
pow_pp r1.w, r0.x, c5.x
mov_pp r0.x, c4
add_pp r0.x, c6.w, -r0
mad_pp r0.x, -r2.w, r0, c6.w
mul_pp r4.xyz, r4, c1
mul_pp r2.xyz, r2, c0
mad_pp r2.xyz, r4, r0.x, r2
mov_pp r0.x, r1.w
mul_pp r1.xyz, r3.w, r3
mul_pp r1.xyz, r1, r2
mad_pp r0.x, r0, c6.y, c6.z
mul_pp r2.xyz, r2, c7.x
max_pp r0.x, r0, c6
mad_pp r1.xyz, r1, c7.y, r2
mul_pp_sat r1.w, r0.x, c3.x
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
Vector 1 [_TintColor]
Vector 2 [_ReflectColor]
Float 3 [_AlphaPower]
Float 4 [_OpaqueReflection]
Float 5 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [unity_Lightmap] 2D
"agal_ps
c6 0.0 0.796387 0.203735 1.0
c7 0.25 8.0 0.0 0.0
[bc]
ciaaaaaaadaaapacaeaaaaoeaeaaaaaaacaaaaaaafaababb tex r3, v4, s2 <2d wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
ciaaaaaaaeaaapacabaaaaoeaeaaaaaaabaaaaaaafbababb tex r4, v1, s1 <cube wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaeaaahacaeaaaakeacaaaaaaacaaaaoeabaaaaaa mul r4.xyz, r4.xyzz, c2
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaaoeabaaaaaa max r0.x, r0.x, c6
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaappabaaaaaa add r0.x, r0.x, c6.w
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaabaaapacaaaaaaaaacaaaaaaafaaaaaaabaaaaaa pow r1, r0.x, c5.x
aaaaaaaaaaaaabacaeaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c4
acaaaaaaaaaaabacagaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c6.w, r0.x
bfaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r0.w, r2.w
adaaaaaaaaaaabacaaaaaappacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r0.w, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaappabaaaaaa add r0.x, r0.x, c6.w
adaaaaaaaeaaahacaeaaaakeacaaaaaaabaaaaoeabaaaaaa mul r4.xyz, r4.xyzz, c1
adaaaaaaacaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c0
adaaaaaaaeaaahacaeaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r4.xyz, r4.xyzz, r0.x
abaaaaaaacaaahacaeaaaakeacaaaaaaacaaaakeacaaaaaa add r2.xyz, r4.xyzz, r2.xyzz
aaaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.x
adaaaaaaabaaahacadaaaappacaaaaaaadaaaakeacaaaaaa mul r1.xyz, r3.w, r3.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r1.xyzz, r2.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaaffabaaaaaa mul r0.x, r0.x, c6.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaakkabaaaaaa add r0.x, r0.x, c6.z
adaaaaaaacaaahacacaaaakeacaaaaaaahaaaaaaabaaaaaa mul r2.xyz, r2.xyzz, c7.x
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaagaaaaoeabaaaaaa max r0.x, r0.x, c6
adaaaaaaabaaahacabaaaakeacaaaaaaahaaaaffabaaaaaa mul r1.xyz, r1.xyzz, c7.y
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
adaaaaaaabaaaiacaaaaaaaaacaaaaaaadaaaaaaabaaaaaa mul r1.w, r0.x, c3.x
bgaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa sat r1.w, r1.w
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
//   opengl - ALU: 26 to 31
//   d3d9 - ALU: 26 to 31
SubProgram "opengl " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
"!!ARBvp1.0
# 30 ALU
PARAM c[21] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[18];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[17].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[5].z, R0, c[15];
DP4 result.texcoord[5].y, R0, c[14];
DP4 result.texcoord[5].x, R0, c[13];
ADD result.texcoord[2].xyz, -R0, c[18];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
ADD result.texcoord[4].xyz, -R0, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 30 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_2_0
; 30 ALU
def c20, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r1.xyz, c17
mov r1.w, c20.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c16.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c20.y, -r0
mul r1.xyz, v1, c16.w
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT5.z, r0, c14
dp4 oT5.y, r0, c13
dp4 oT5.x, r0, c12
add oT2.xyz, -r0, c17
dp3 oT3.z, r1, c6
dp3 oT3.y, r1, c5
dp3 oT3.x, r1, c4
add oT4.xyz, -r0, c18
mad oT0.xy, v2, c19, c19.zwzw
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD4);
  lightDir = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13 = vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * texture2D (_LightTexture0, tmpvar_13).w) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.w = tmpvar_5;
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD4);
  lightDir = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13 = vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * texture2D (_LightTexture0, tmpvar_13).w) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.w = tmpvar_5;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"agal_vs
c20 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
aaaaaaaaabaaaiacbeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c20.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaabaaaaappabaaaaaa mul r2.xyz, r0.xyzz, c16.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaabeaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c20.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r1.xyz, a1, c16.w
bcaaaaaaabaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r0.xyzz, c6
bcaaaaaaabaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r0.xyzz, c5
bcaaaaaaabaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaafaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v5.z, r0, c14
bdaaaaaaafaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v5.y, r0, c13
bdaaaaaaafaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v5.x, r0, c12
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaabbaaaaoeabaaaaaa add v2.xyz, r2.xyzz, c17
bcaaaaaaadaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v3.z, r1.xyzz, c6
bcaaaaaaadaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v3.y, r1.xyzz, c5
bcaaaaaaadaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v3.x, r1.xyzz, c4
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaaeaaahaeacaaaakeacaaaaaabcaaaaoeabaaaaaa add v4.xyz, r2.xyzz, c18
adaaaaaaacaaadacadaaaaoeaaaaaaaabdaaaaoeabaaaaaa mul r2.xy, a3, c19
abaaaaaaaaaaadaeacaaaafeacaaaaaabdaaaaooabaaaaaa add v0.xy, r2.xyyy, c19.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
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
Bind "texcoord" TexCoord0
Vector 13 [unity_Scale]
Vector 14 [_WorldSpaceCameraPos]
Vector 15 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 16 [_MainTex_ST]
"!!ARBvp1.0
# 26 ALU
PARAM c[17] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..16] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[14];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[13].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[13].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
ADD result.texcoord[2].xyz, -R0, c[14];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
MOV result.texcoord[4].xyz, c[15];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[16], c[16].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 26 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [_MainTex_ST]
"vs_2_0
; 26 ALU
def c16, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r1.xyz, c13
mov r1.w, c16.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c12.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c16.y, -r0
mul r1.xyz, v1, c12.w
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
add oT2.xyz, -r0, c13
dp3 oT3.z, r1, c6
dp3 oT3.y, r1, c5
dp3 oT3.x, r1, c4
mov oT4.xyz, c14
mad oT0.xy, v2, c15, c15.zwzw
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = _WorldSpaceLightPos0.xyz;
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  lightDir = xlv_TEXCOORD4;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD3, lightDir)) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.w = tmpvar_5;
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = _WorldSpaceLightPos0.xyz;
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
}



#endif
#ifdef FRAGMENT

varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  lightDir = xlv_TEXCOORD4;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * (max (0.0, dot (xlv_TEXCOORD3, lightDir)) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.w = tmpvar_5;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 12 [unity_Scale]
Vector 13 [_WorldSpaceCameraPos]
Vector 14 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [_MainTex_ST]
"agal_vs
c16 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacanaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c13
aaaaaaaaabaaaiacbaaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c16.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaaamaaaappabaaaaaa mul r2.xyz, r0.xyzz, c12.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaabaaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c16.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaamaaaappabaaaaaa mul r1.xyz, a1, c12.w
bcaaaaaaabaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r0.xyzz, c6
bcaaaaaaabaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r0.xyzz, c5
bcaaaaaaabaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaaanaaaaoeabaaaaaa add v2.xyz, r2.xyzz, c13
bcaaaaaaadaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v3.z, r1.xyzz, c6
bcaaaaaaadaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v3.y, r1.xyzz, c5
bcaaaaaaadaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v3.x, r1.xyzz, c4
aaaaaaaaaeaaahaeaoaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.xyz, c14
adaaaaaaacaaadacadaaaaoeaaaaaaaaapaaaaoeabaaaaaa mul r2.xy, a3, c15
abaaaaaaaaaaadaeacaaaafeacaaaaaaapaaaaooabaaaaaa add v0.xy, r2.xyyy, c15.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
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
Bind "texcoord" TexCoord0
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
"!!ARBvp1.0
# 31 ALU
PARAM c[21] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[18];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[17].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[17].w;
DP4 R0.w, vertex.position, c[8];
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 result.texcoord[5].w, R0, c[16];
DP4 result.texcoord[5].z, R0, c[15];
DP4 result.texcoord[5].y, R0, c[14];
DP4 result.texcoord[5].x, R0, c[13];
ADD result.texcoord[2].xyz, -R0, c[18];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
ADD result.texcoord[4].xyz, -R0, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 31 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_2_0
; 31 ALU
def c20, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r1.xyz, c17
mov r1.w, c20.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c16.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c20.y, -r0
mul r1.xyz, v1, c16.w
dp4 r0.w, v0, c7
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 oT5.w, r0, c15
dp4 oT5.z, r0, c14
dp4 oT5.y, r0, c13
dp4 oT5.x, r0, c12
add oT2.xyz, -r0, c17
dp3 oT3.z, r1, c6
dp3 oT3.y, r1, c5
dp3 oT3.x, r1, c4
add oT4.xyz, -r0, c18
mad oT0.xy, v2, c19, c19.zwzw
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD4);
  lightDir = tmpvar_12;
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD5.xyz;
  highp vec2 tmpvar_13;
  tmpvar_13 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp float atten;
  atten = ((float((xlv_TEXCOORD5.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD5.xy / xlv_TEXCOORD5.w) + 0.5)).w) * texture2D (_LightTextureB0, tmpvar_13).w);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * atten) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.w = tmpvar_5;
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex));
}



#endif
#ifdef FRAGMENT

varying highp vec4 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD4);
  lightDir = tmpvar_12;
  highp vec3 LightCoord_i0;
  LightCoord_i0 = xlv_TEXCOORD5.xyz;
  highp vec2 tmpvar_13;
  tmpvar_13 = vec2(dot (LightCoord_i0, LightCoord_i0));
  lowp float atten;
  atten = ((float((xlv_TEXCOORD5.z > 0.0)) * texture2D (_LightTexture0, ((xlv_TEXCOORD5.xy / xlv_TEXCOORD5.w) + 0.5)).w) * texture2D (_LightTextureB0, tmpvar_13).w);
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * atten) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.w = tmpvar_5;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "SPOT" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"agal_vs
c20 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
aaaaaaaaabaaaiacbeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c20.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaabaaaaappabaaaaaa mul r2.xyz, r0.xyzz, c16.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaabeaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c20.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r1.xyz, a1, c16.w
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bcaaaaaaabaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r0.xyzz, c6
bcaaaaaaabaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r0.xyzz, c5
bcaaaaaaabaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaafaaaiaeaaaaaaoeacaaaaaaapaaaaoeabaaaaaa dp4 v5.w, r0, c15
bdaaaaaaafaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v5.z, r0, c14
bdaaaaaaafaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v5.y, r0, c13
bdaaaaaaafaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v5.x, r0, c12
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaabbaaaaoeabaaaaaa add v2.xyz, r2.xyzz, c17
bcaaaaaaadaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v3.z, r1.xyzz, c6
bcaaaaaaadaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v3.y, r1.xyzz, c5
bcaaaaaaadaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v3.x, r1.xyzz, c4
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaaeaaahaeacaaaakeacaaaaaabcaaaaoeabaaaaaa add v4.xyz, r2.xyzz, c18
adaaaaaaacaaadacadaaaaoeaaaaaaaabdaaaaoeabaaaaaa mul r2.xy, a3, c19
abaaaaaaaaaaadaeacaaaafeacaaaaaabdaaaaooabaaaaaa add v0.xy, r2.xyyy, c19.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
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
Bind "texcoord" TexCoord0
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
"!!ARBvp1.0
# 30 ALU
PARAM c[21] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[18];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[17].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[5].z, R0, c[15];
DP4 result.texcoord[5].y, R0, c[14];
DP4 result.texcoord[5].x, R0, c[13];
ADD result.texcoord[2].xyz, -R0, c[18];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
ADD result.texcoord[4].xyz, -R0, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 30 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_2_0
; 30 ALU
def c20, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r1.xyz, c17
mov r1.w, c20.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c16.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c20.y, -r0
mul r1.xyz, v1, c16.w
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT5.z, r0, c14
dp4 oT5.y, r0, c13
dp4 oT5.x, r0, c12
add oT2.xyz, -r0, c17
dp3 oT3.z, r1, c6
dp3 oT3.y, r1, c5
dp3 oT3.x, r1, c4
add oT4.xyz, -r0, c18
mad oT0.xy, v2, c19, c19.zwzw
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD4);
  lightDir = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13 = vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * (texture2D (_LightTextureB0, tmpvar_13).w * textureCube (_LightTexture0, xlv_TEXCOORD5).w)) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.w = tmpvar_5;
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform highp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = (_WorldSpaceLightPos0.xyz - (_Object2World * _glesVertex).xyz);
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xyz;
}



#endif
#ifdef FRAGMENT

varying highp vec3 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform sampler2D _LightTextureB0;
uniform samplerCube _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize (xlv_TEXCOORD4);
  lightDir = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13 = vec2(dot (xlv_TEXCOORD5, xlv_TEXCOORD5));
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * (texture2D (_LightTextureB0, tmpvar_13).w * textureCube (_LightTexture0, xlv_TEXCOORD5).w)) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.w = tmpvar_5;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "POINT_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"agal_vs
c20 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
aaaaaaaaabaaaiacbeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c20.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaabaaaaappabaaaaaa mul r2.xyz, r0.xyzz, c16.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaabeaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c20.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r1.xyz, a1, c16.w
bcaaaaaaabaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r0.xyzz, c6
bcaaaaaaabaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r0.xyzz, c5
bcaaaaaaabaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaafaaaeaeaaaaaaoeacaaaaaaaoaaaaoeabaaaaaa dp4 v5.z, r0, c14
bdaaaaaaafaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v5.y, r0, c13
bdaaaaaaafaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v5.x, r0, c12
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaabbaaaaoeabaaaaaa add v2.xyz, r2.xyzz, c17
bcaaaaaaadaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v3.z, r1.xyzz, c6
bcaaaaaaadaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v3.y, r1.xyzz, c5
bcaaaaaaadaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v3.x, r1.xyzz, c4
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaaeaaahaeacaaaakeacaaaaaabcaaaaoeabaaaaaa add v4.xyz, r2.xyzz, c18
adaaaaaaacaaadacadaaaaoeaaaaaaaabdaaaaoeabaaaaaa mul r2.xy, a3, c19
abaaaaaaaaaaadaeacaaaafeacaaaaaabdaaaaooabaaaaaa add v0.xy, r2.xyyy, c19.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
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
Bind "texcoord" TexCoord0
Vector 17 [unity_Scale]
Vector 18 [_WorldSpaceCameraPos]
Vector 19 [_WorldSpaceLightPos0]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Matrix 13 [_LightMatrix0]
Vector 20 [_MainTex_ST]
"!!ARBvp1.0
# 29 ALU
PARAM c[21] = { { 1, 2 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
MOV R1.xyz, c[18];
MOV R1.w, c[0].x;
DP4 R0.z, R1, c[11];
DP4 R0.x, R1, c[9];
DP4 R0.y, R1, c[10];
MAD R0.xyz, R0, c[17].w, -vertex.position;
DP3 R0.w, vertex.normal, -R0;
MUL R1.xyz, vertex.normal, R0.w;
MAD R0.xyz, -R1, c[0].y, -R0;
MUL R1.xyz, vertex.normal, c[17].w;
DP3 result.texcoord[1].z, R0, c[7];
DP3 result.texcoord[1].y, R0, c[6];
DP3 result.texcoord[1].x, R0, c[5];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
DP4 result.texcoord[5].y, R0, c[14];
DP4 result.texcoord[5].x, R0, c[13];
ADD result.texcoord[2].xyz, -R0, c[18];
DP3 result.texcoord[3].z, R1, c[7];
DP3 result.texcoord[3].y, R1, c[6];
DP3 result.texcoord[3].x, R1, c[5];
MOV result.texcoord[4].xyz, c[19];
MAD result.texcoord[0].xy, vertex.texcoord[0], c[20], c[20].zwzw;
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 29 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"vs_2_0
; 29 ALU
def c20, 1.00000000, 2.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mov r1.xyz, c17
mov r1.w, c20.x
dp4 r0.z, r1, c10
dp4 r0.x, r1, c8
dp4 r0.y, r1, c9
mad r0.xyz, r0, c16.w, -v0
dp3 r0.w, v1, -r0
mul r1.xyz, v1, r0.w
mad r0.xyz, -r1, c20.y, -r0
mul r1.xyz, v1, c16.w
dp3 oT1.z, r0, c6
dp3 oT1.y, r0, c5
dp3 oT1.x, r0, c4
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
dp4 oT5.y, r0, c13
dp4 oT5.x, r0, c12
add oT2.xyz, -r0, c17
dp3 oT3.z, r1, c6
dp3 oT3.y, r1, c5
dp3 oT3.x, r1, c4
mov oT4.xyz, c18
mad oT0.xy, v2, c19, c19.zwzw
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = _WorldSpaceLightPos0.xyz;
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  lightDir = xlv_TEXCOORD4;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * texture2D (_LightTexture0, xlv_TEXCOORD5).w) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.w = tmpvar_5;
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
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform highp vec4 unity_Scale;

uniform lowp vec4 _WorldSpaceLightPos0;
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 _LightMatrix0;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  vec3 tmpvar_1;
  tmpvar_1 = normalize (_glesNormal);
  mediump vec2 tmpvar_2;
  mediump vec3 tmpvar_3;
  lowp vec3 tmpvar_4;
  mediump vec3 tmpvar_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  tmpvar_2 = tmpvar_6;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = _WorldSpaceCameraPos;
  mat3 tmpvar_8;
  tmpvar_8[0] = _Object2World[0].xyz;
  tmpvar_8[1] = _Object2World[1].xyz;
  tmpvar_8[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_8 * reflect ((_glesVertex.xyz - ((_World2Object * tmpvar_7).xyz * unity_Scale.w)), tmpvar_1));
  tmpvar_3 = tmpvar_9;
  mat3 tmpvar_10;
  tmpvar_10[0] = _Object2World[0].xyz;
  tmpvar_10[1] = _Object2World[1].xyz;
  tmpvar_10[2] = _Object2World[2].xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 * (tmpvar_1 * unity_Scale.w));
  tmpvar_4 = tmpvar_11;
  highp vec3 tmpvar_12;
  tmpvar_12 = _WorldSpaceLightPos0.xyz;
  tmpvar_5 = tmpvar_12;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_2;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = (_WorldSpaceCameraPos - (_Object2World * _glesVertex).xyz);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = (_LightMatrix0 * (_Object2World * _glesVertex)).xy;
}



#endif
#ifdef FRAGMENT

varying highp vec2 xlv_TEXCOORD5;
varying mediump vec3 xlv_TEXCOORD4;
varying lowp vec3 xlv_TEXCOORD3;
varying highp vec3 xlv_TEXCOORD2;
varying mediump vec3 xlv_TEXCOORD1;
varying mediump vec2 xlv_TEXCOORD0;
uniform lowp vec4 _TintColor;
uniform lowp vec4 _ReflectColor;
uniform mediump float _OpaqueReflection;
uniform sampler2D _MainTex;
uniform sampler2D _LightTexture0;
uniform lowp vec4 _LightColor0;
uniform mediump float _FresnelPower;
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
uniform mediump float _AlphaPower;
void main ()
{
  lowp vec4 c;
  lowp vec3 lightDir;
  lowp vec2 tmpvar_1;
  lowp vec3 tmpvar_2;
  lowp vec3 tmpvar_3;
  tmpvar_1 = xlv_TEXCOORD0;
  tmpvar_2 = xlv_TEXCOORD1;
  tmpvar_3 = xlv_TEXCOORD2;
  lowp vec3 tmpvar_4;
  lowp float tmpvar_5;
  lowp float refl2Refr;
  mediump vec4 reflcol;
  mediump vec3 worldReflVec;
  mediump vec4 tex;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_MainTex, tmpvar_1);
  tex = tmpvar_6;
  worldReflVec = tmpvar_2;
  lowp vec4 tmpvar_7;
  tmpvar_7 = textureCube (_Cube, worldReflVec);
  reflcol = tmpvar_7;
  lowp float tmpvar_8;
  tmpvar_8 = clamp ((1.0 - max (dot (normalize (tmpvar_3), normalize (xlv_TEXCOORD3)), 0.0)), 0.0, 1.0);
  mediump float tmpvar_9;
  tmpvar_9 = max ((0.20373 + ((1.0 - 0.20373) * pow (tmpvar_8, _FresnelPower))), 0.0);
  refl2Refr = tmpvar_9;
  mediump vec3 tmpvar_10;
  tmpvar_10 = ((((reflcol.xyz * _ReflectColor.xyz) * _TintColor.xyz) * (1.0 - (tex.w * (1.0 - _OpaqueReflection)))) + (tex * _Color).xyz);
  tmpvar_4 = tmpvar_10;
  mediump float tmpvar_11;
  tmpvar_11 = clamp ((refl2Refr * _AlphaPower), 0.0, 1.0);
  tmpvar_5 = tmpvar_11;
  lightDir = xlv_TEXCOORD4;
  lowp vec4 c_i0_i1;
  c_i0_i1.xyz = ((tmpvar_4 * _LightColor0.xyz) * ((max (0.0, dot (xlv_TEXCOORD3, lightDir)) * texture2D (_LightTexture0, xlv_TEXCOORD5).w) * 2.0));
  c_i0_i1.w = tmpvar_5;
  c = c_i0_i1;
  c.w = tmpvar_5;
  gl_FragData[0] = c;
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL_COOKIE" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Vector 16 [unity_Scale]
Vector 17 [_WorldSpaceCameraPos]
Vector 18 [_WorldSpaceLightPos0]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Matrix 12 [_LightMatrix0]
Vector 19 [_MainTex_ST]
"agal_vs
c20 1.0 2.0 0.0 0.0
[bc]
aaaaaaaaabaaahacbbaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, c17
aaaaaaaaabaaaiacbeaaaaaaabaaaaaaaaaaaaaaaaaaaaaa mov r1.w, c20.x
bdaaaaaaaaaaaeacabaaaaoeacaaaaaaakaaaaoeabaaaaaa dp4 r0.z, r1, c10
bdaaaaaaaaaaabacabaaaaoeacaaaaaaaiaaaaoeabaaaaaa dp4 r0.x, r1, c8
bdaaaaaaaaaaacacabaaaaoeacaaaaaaajaaaaoeabaaaaaa dp4 r0.y, r1, c9
adaaaaaaacaaahacaaaaaakeacaaaaaabaaaaappabaaaaaa mul r2.xyz, r0.xyzz, c16.w
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaaoeaaaaaaaa sub r0.xyz, r2.xyzz, a0
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
bcaaaaaaaaaaaiacabaaaaoeaaaaaaaaacaaaakeacaaaaaa dp3 r0.w, a1, r2.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaaaaaaaappacaaaaaa mul r1.xyz, a1, r0.w
bfaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r1.xyzz
adaaaaaaacaaahacacaaaakeacaaaaaabeaaaaffabaaaaaa mul r2.xyz, r2.xyzz, c20.y
acaaaaaaaaaaahacacaaaakeacaaaaaaaaaaaakeacaaaaaa sub r0.xyz, r2.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaaoeaaaaaaaabaaaaappabaaaaaa mul r1.xyz, a1, c16.w
bcaaaaaaabaaaeaeaaaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v1.z, r0.xyzz, c6
bcaaaaaaabaaacaeaaaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v1.y, r0.xyzz, c5
bcaaaaaaabaaabaeaaaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v1.x, r0.xyzz, c4
bdaaaaaaaaaaaeacaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 r0.z, a0, c6
bdaaaaaaaaaaabacaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 r0.x, a0, c4
bdaaaaaaaaaaacacaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 r0.y, a0, c5
bdaaaaaaaaaaaiacaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 r0.w, a0, c7
bdaaaaaaafaaacaeaaaaaaoeacaaaaaaanaaaaoeabaaaaaa dp4 v5.y, r0, c13
bdaaaaaaafaaabaeaaaaaaoeacaaaaaaamaaaaoeabaaaaaa dp4 v5.x, r0, c12
bfaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaaaaaaaaaaa neg r2.xyz, r0.xyzz
abaaaaaaacaaahaeacaaaakeacaaaaaabbaaaaoeabaaaaaa add v2.xyz, r2.xyzz, c17
bcaaaaaaadaaaeaeabaaaakeacaaaaaaagaaaaoeabaaaaaa dp3 v3.z, r1.xyzz, c6
bcaaaaaaadaaacaeabaaaakeacaaaaaaafaaaaoeabaaaaaa dp3 v3.y, r1.xyzz, c5
bcaaaaaaadaaabaeabaaaakeacaaaaaaaeaaaaoeabaaaaaa dp3 v3.x, r1.xyzz, c4
aaaaaaaaaeaaahaebcaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v4.xyz, c18
adaaaaaaacaaadacadaaaaoeaaaaaaaabdaaaaoeabaaaaaa mul r2.xy, a3, c19
abaaaaaaaaaaadaeacaaaafeacaaaaaabdaaaaooabaaaaaa add v0.xy, r2.xyyy, c19.zwzw
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
aaaaaaaaaaaaamaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v0.zw, c0
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
//   opengl - ALU: 28 to 39, TEX: 2 to 4
//   d3d9 - ALU: 30 to 40, TEX: 2 to 4
SubProgram "opengl " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 33 ALU, 3 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.20373535, 0.79638672, 1, 0 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[1], CUBE;
DP3 R1.w, fragment.texcoord[5], fragment.texcoord[5];
MOV R2.x, c[7].z;
ADD R2.x, R2, -c[5];
MUL R1.xyz, R1, c[3];
MAD R0.w, -R0, R2.x, c[7].z;
MUL R1.xyz, R1, c[2];
MUL R0.xyz, R0, c[1];
MAD R0.xyz, R1, R0.w, R0;
MUL R2.xyz, R0, c[0];
DP3 R0.y, fragment.texcoord[3], fragment.texcoord[3];
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
MUL R1.xyz, R0.y, fragment.texcoord[3];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
DP3 R0.x, R0, R1;
MAX R0.x, R0, c[7].w;
ADD_SAT R0.w, -R0.x, c[7].z;
DP3 R0.y, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.y, R0.y;
MUL R0.xyz, R0.y, fragment.texcoord[4];
DP3 R0.y, fragment.texcoord[3], R0;
POW R0.w, R0.w, c[6].x;
MAD R0.x, R0.w, c[7].y, c[7];
MAX R0.x, R0, c[7].w;
MAX R0.y, R0, c[7].w;
MUL_SAT result.color.w, R0.x, c[4].x;
TEX R1.w, R1.w, texture[2], 2D;
MUL R0.y, R0, R1.w;
MUL R1.xyz, R0.y, R2;
MUL result.color.xyz, R1, c[8].x;
END
# 33 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_LightTexture0] 2D
"ps_2_0
; 35 ALU, 3 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c7, 0.00000000, 0.79638672, 0.20373535, 1.00000000
def c8, 2.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
dcl t5.xyz
texld r3, t1, s1
texld r2, t0, s0
dp3 r0.x, t5, t5
mov r0.xy, r0.x
dp3_pp r1.x, t3, t3
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t3
mul_pp r2.xyz, r2, c1
texld r4, r0, s2
dp3_pp r0.x, t2, t2
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t2
dp3_pp r0.x, r0, r1
mul_pp r1.xyz, r3, c3
mul_pp r3.xyz, r1, c2
max_pp r0.x, r0, c7
mov_pp r1.x, c5
add_pp r1.x, c7.w, -r1
mad_pp r1.x, -r2.w, r1, c7.w
mad_pp r1.xyz, r3, r1.x, r2
add_pp_sat r0.x, -r0, c7.w
pow_pp r2.w, r0.x, c6.x
dp3_pp r0.x, t4, t4
rsq_pp r3.x, r0.x
mov_pp r0.x, r2.w
mul_pp r2.xyz, r3.x, t4
mad_pp r0.x, r0, c7.y, c7.z
dp3_pp r2.x, t3, r2
max_pp r0.x, r0, c7
mul_pp r1.xyz, r1, c0
max_pp r2.x, r2, c7
mul_pp r2.x, r2, r4
mul_pp r1.xyz, r2.x, r1
mul_pp r1.xyz, r1, c8.x
mul_pp_sat r1.w, r0.x, c4.x
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
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_LightTexture0] 2D
"agal_ps
c7 0.0 0.796387 0.203735 1.0
c8 2.0 0.0 0.0 0.0
[bc]
ciaaaaaaadaaapacabaaaaoeaeaaaaaaabaaaaaaafbababb tex r3, v1, s1 <cube wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacafaaaaoeaeaaaaaaafaaaaoeaeaaaaaa dp3 r0.x, v5, v5
aaaaaaaaaaaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.xy, r0.x
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c1
ciaaaaaaaaaaapacaaaaaafeacaaaaaaacaaaaaaafaababb tex r0, r0.xyyy, s2 <2d wrap linear point>
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
adaaaaaaabaaahacadaaaakeacaaaaaaadaaaaoeabaaaaaa mul r1.xyz, r3.xyzz, c3
adaaaaaaadaaahacabaaaakeacaaaaaaacaaaaoeabaaaaaa mul r3.xyz, r1.xyzz, c2
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
aaaaaaaaabaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.x, c5
acaaaaaaabaaabacahaaaappabaaaaaaabaaaaaaacaaaaaa sub r1.x, c7.w, r1.x
bfaaaaaaadaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r3.w, r2.w
adaaaaaaabaaabacadaaaappacaaaaaaabaaaaaaacaaaaaa mul r1.x, r3.w, r1.x
abaaaaaaabaaabacabaaaaaaacaaaaaaahaaaappabaaaaaa add r1.x, r1.x, c7.w
adaaaaaaabaaahacadaaaakeacaaaaaaabaaaaaaacaaaaaa mul r1.xyz, r3.xyzz, r1.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaappabaaaaaa add r0.x, r0.x, c7.w
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaacaaapacaaaaaaaaacaaaaaaagaaaaaaabaaaaaa pow r2, r0.x, c6.x
bcaaaaaaaaaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r0.x, v4, v4
akaaaaaaadaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r3.x, r0.x
aaaaaaaaaaaaabacacaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r2.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaffabaaaaaa mul r0.x, r0.x, c7.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaakkabaaaaaa add r0.x, r0.x, c7.z
adaaaaaaacaaahacadaaaaaaacaaaaaaaeaaaaoeaeaaaaaa mul r2.xyz, r3.x, v4
bcaaaaaaacaaabacadaaaaoeaeaaaaaaacaaaakeacaaaaaa dp3 r2.x, v3, r2.xyzz
ahaaaaaaacaaabacacaaaaaaacaaaaaaahaaaaoeabaaaaaa max r2.x, r2.x, c7
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
adaaaaaaabaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c0
adaaaaaaacaaabacacaaaaaaacaaaaaaaaaaaappacaaaaaa mul r2.x, r2.x, r0.w
adaaaaaaabaaahacacaaaaaaacaaaaaaabaaaakeacaaaaaa mul r1.xyz, r2.x, r1.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaaiaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c8.x
adaaaaaaabaaaiacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa mul r1.w, r0.x, c4.x
bgaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa sat r1.w, r1.w
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 28 ALU, 2 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.20373535, 0.79638672, 1, 0 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[1], CUBE;
DP3 R1.w, fragment.texcoord[2], fragment.texcoord[2];
RSQ R1.w, R1.w;
MUL R2.xyz, R1.w, fragment.texcoord[2];
DP3 R2.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R2.w, R2.w;
MUL R1.xyz, R1, c[3];
MOV R1.w, c[7].z;
MUL R3.xyz, R2.w, fragment.texcoord[3];
ADD R2.w, R1, -c[5].x;
MAD R0.w, -R0, R2, c[7].z;
MUL R1.xyz, R1, c[2];
MUL R0.xyz, R0, c[1];
MAD R0.xyz, R1, R0.w, R0;
MOV R1.xyz, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
DP3 R1.w, R2, R3;
MAX R0.w, R1, c[7];
ADD_SAT R0.w, -R0, c[7].z;
POW R0.w, R0.w, c[6].x;
MUL R0.xyz, R0, c[0];
MAX R1.x, R1, c[7].w;
MUL R1.xyz, R1.x, R0;
MAD R0.w, R0, c[7].y, c[7].x;
MAX R0.x, R0.w, c[7].w;
MUL result.color.xyz, R1, c[8].x;
MUL_SAT result.color.w, R0.x, c[4].x;
END
# 28 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"ps_2_0
; 30 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c7, 0.00000000, 0.79638672, 0.20373535, 1.00000000
def c8, 2.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
texld r3, t1, s1
texld r2, t0, s0
dp3_pp r1.x, t3, t3
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r1.x
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r1.x, t3
mul_pp r0.xyz, r0.x, t2
dp3_pp r0.x, r0, r1
mul_pp r1.xyz, r3, c3
mul_pp r3.xyz, r1, c2
max_pp r0.x, r0, c7
mov_pp r1.x, c5
add_pp r1.x, c7.w, -r1
add_pp_sat r0.x, -r0, c7.w
mul_pp r2.xyz, r2, c1
mad_pp r1.x, -r2.w, r1, c7.w
mad_pp r1.xyz, r3, r1.x, r2
pow_pp r3.x, r0.x, c6.x
mul_pp r2.xyz, r1, c0
mov_pp r1.xyz, t4
dp3_pp r1.x, t3, r1
mov_pp r0.x, r3.x
mad_pp r0.x, r0, c7.y, c7.z
max_pp r1.x, r1, c7
mul_pp r1.xyz, r1.x, r2
max_pp r0.x, r0, c7
mul_pp r1.xyz, r1, c8.x
mul_pp_sat r1.w, r0.x, c4.x
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
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
"agal_ps
c7 0.0 0.796387 0.203735 1.0
c8 2.0 0.0 0.0 0.0
[bc]
ciaaaaaaadaaapacabaaaaoeaeaaaaaaabaaaaaaafbababb tex r3, v1, s1 <cube wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
adaaaaaaabaaahacadaaaakeacaaaaaaadaaaaoeabaaaaaa mul r1.xyz, r3.xyzz, c3
adaaaaaaadaaahacabaaaakeacaaaaaaacaaaaoeabaaaaaa mul r3.xyz, r1.xyzz, c2
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
aaaaaaaaabaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r1.x, c5
acaaaaaaabaaabacahaaaappabaaaaaaabaaaaaaacaaaaaa sub r1.x, c7.w, r1.x
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaappabaaaaaa add r0.x, r0.x, c7.w
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c1
bfaaaaaaaaaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r0.w, r2.w
adaaaaaaabaaabacaaaaaappacaaaaaaabaaaaaaacaaaaaa mul r1.x, r0.w, r1.x
abaaaaaaabaaabacabaaaaaaacaaaaaaahaaaappabaaaaaa add r1.x, r1.x, c7.w
adaaaaaaabaaahacadaaaakeacaaaaaaabaaaaaaacaaaaaa mul r1.xyz, r3.xyzz, r1.x
abaaaaaaabaaahacabaaaakeacaaaaaaacaaaakeacaaaaaa add r1.xyz, r1.xyzz, r2.xyzz
alaaaaaaadaaapacaaaaaaaaacaaaaaaagaaaaaaabaaaaaa pow r3, r0.x, c6.x
adaaaaaaacaaahacabaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r1.xyzz, c0
aaaaaaaaabaaahacaeaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, v4
bcaaaaaaabaaabacadaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v3, r1.xyzz
aaaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaffabaaaaaa mul r0.x, r0.x, c7.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaakkabaaaaaa add r0.x, r0.x, c7.z
ahaaaaaaabaaabacabaaaaaaacaaaaaaahaaaaoeabaaaaaa max r1.x, r1.x, c7
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r1.x, r2.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
adaaaaaaabaaahacabaaaakeacaaaaaaaiaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c8.x
adaaaaaaabaaaiacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa mul r1.w, r0.x, c4.x
bgaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa sat r1.w, r1.w
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_LightTexture0] 2D
SetTexture 3 [_LightTextureB0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 39 ALU, 4 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.20373535, 0.79638672, 1, 0 },
		{ 0.5, 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R2, fragment.texcoord[0], texture[0], 2D;
RCP R0.x, fragment.texcoord[5].w;
MAD R1.xy, fragment.texcoord[5], R0.x, c[8].x;
DP3 R1.z, fragment.texcoord[5], fragment.texcoord[5];
TEX R0.w, R1, texture[2], 2D;
TEX R0.xyz, fragment.texcoord[1], texture[1], CUBE;
TEX R1.w, R1.z, texture[3], 2D;
MOV R1.x, c[7].z;
ADD R1.x, R1, -c[5];
MAD R2.w, -R2, R1.x, c[7].z;
MUL R0.xyz, R0, c[3];
MUL R0.xyz, R0, c[2];
MUL R1.xyz, R2, c[1];
MAD R2.xyz, R0, R2.w, R1;
DP3 R0.y, fragment.texcoord[3], fragment.texcoord[3];
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
MUL R1.xyz, R0.y, fragment.texcoord[3];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
DP3 R1.x, R0, R1;
MAX R1.x, R1, c[7].w;
DP3 R1.y, fragment.texcoord[4], fragment.texcoord[4];
MUL R0.xyz, R2, c[0];
ADD_SAT R1.x, -R1, c[7].z;
POW R2.x, R1.x, c[6].x;
RSQ R1.y, R1.y;
MUL R1.xyz, R1.y, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
SLT R1.y, c[7].w, fragment.texcoord[5].z;
MUL R0.w, R1.y, R0;
MUL R1.y, R0.w, R1.w;
MAX R0.w, R1.x, c[7];
MUL R0.w, R0, R1.y;
MUL R1.xyz, R0.w, R0;
MAD R2.x, R2, c[7].y, c[7];
MAX R0.x, R2, c[7].w;
MUL result.color.xyz, R1, c[8].y;
MUL_SAT result.color.w, R0.x, c[4].x;
END
# 39 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "SPOT" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_LightTexture0] 2D
SetTexture 3 [_LightTextureB0] 2D
"ps_2_0
; 40 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_2d s3
def c7, 0.00000000, 0.79638672, 0.20373535, 1.00000000
def c8, 0.50000000, 2.00000000, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
dcl t5
texld r2, t0, s0
texld r3, t1, s1
dp3 r1.x, t5, t5
mov r1.xy, r1.x
rcp r0.x, t5.w
mad r0.xy, t5, r0.x, c8.x
mul_pp r2.xyz, r2, c1
texld r4, r1, s3
texld r0, r0, s2
dp3_pp r1.x, t3, t3
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r1.x
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t2
mul_pp r1.xyz, r1.x, t3
dp3_pp r0.x, r0, r1
max_pp r0.x, r0, c7
add_pp_sat r0.x, -r0, c7.w
pow_pp r1.w, r0.x, c6.x
mul_pp r0.xyz, r3, c3
mul_pp r3.xyz, r0, c2
mov_pp r0.x, c5
add_pp r0.x, c7.w, -r0
mad_pp r0.x, -r2.w, r0, c7.w
mad_pp r2.xyz, r3, r0.x, r2
mov_pp r0.x, r1.w
mad_pp r0.x, r0, c7.y, c7.z
max_pp r0.x, r0, c7
mul_pp r3.xyz, r2, c0
dp3_pp r1.x, t4, t4
rsq_pp r2.x, r1.x
cmp r1.x, -t5.z, c7, c7.w
mul_pp r2.xyz, r2.x, t4
dp3_pp r2.x, t3, r2
mul_pp r1.x, r1, r0.w
mul_pp r1.x, r1, r4
max_pp r2.x, r2, c7
mul_pp r1.x, r2, r1
mul_pp r1.xyz, r1.x, r3
mul_pp r1.xyz, r1, c8.y
mul_pp_sat r1.w, r0.x, c4.x
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
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_LightTexture0] 2D
SetTexture 3 [_LightTextureB0] 2D
"agal_ps
c7 0.0 0.796387 0.203735 1.0
c8 0.5 2.0 0.0 0.0
[bc]
ciaaaaaaadaaapacabaaaaoeaeaaaaaaabaaaaaaafbababb tex r3, v1, s1 <cube wrap linear point>
bcaaaaaaabaaabacafaaaaoeaeaaaaaaafaaaaoeaeaaaaaa dp3 r1.x, v5, v5
aaaaaaaaacaaadacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r2.xy, r1.x
afaaaaaaaaaaabacafaaaappaeaaaaaaaaaaaaaaaaaaaaaa rcp r0.x, v5.w
adaaaaaaabaaadacafaaaaoeaeaaaaaaaaaaaaaaacaaaaaa mul r1.xy, v5, r0.x
abaaaaaaabaaadacabaaaafeacaaaaaaaiaaaaaaabaaaaaa add r1.xy, r1.xyyy, c8.x
ciaaaaaaaaaaapacacaaaafeacaaaaaaadaaaaaaafaababb tex r0, r2.xyyy, s3 <2d wrap linear point>
ciaaaaaaaeaaapacabaaaafeacaaaaaaacaaaaaaafaababb tex r4, r1.xyyy, s2 <2d wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaappabaaaaaa add r0.x, r0.x, c7.w
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaabaaapacaaaaaaaaacaaaaaaagaaaaaaabaaaaaa pow r1, r0.x, c6.x
adaaaaaaaaaaahacadaaaakeacaaaaaaadaaaaoeabaaaaaa mul r0.xyz, r3.xyzz, c3
adaaaaaaadaaahacaaaaaakeacaaaaaaacaaaaoeabaaaaaa mul r3.xyz, r0.xyzz, c2
aaaaaaaaaaaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c5
acaaaaaaaaaaabacahaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c7.w, r0.x
bfaaaaaaadaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r3.w, r2.w
adaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r3.w, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaappabaaaaaa add r0.x, r0.x, c7.w
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c1
adaaaaaaaeaaahacadaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r4.xyz, r3.xyzz, r0.x
abaaaaaaacaaahacaeaaaakeacaaaaaaacaaaakeacaaaaaa add r2.xyz, r4.xyzz, r2.xyzz
aaaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaffabaaaaaa mul r0.x, r0.x, c7.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaakkabaaaaaa add r0.x, r0.x, c7.z
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
adaaaaaaadaaahacacaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r3.xyz, r2.xyzz, c0
bcaaaaaaabaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r1.x, v4, v4
akaaaaaaacaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r2.x, r1.x
adaaaaaaacaaahacacaaaaaaacaaaaaaaeaaaaoeaeaaaaaa mul r2.xyz, r2.x, v4
bcaaaaaaacaaabacadaaaaoeaeaaaaaaacaaaakeacaaaaaa dp3 r2.x, v3, r2.xyzz
bfaaaaaaafaaaeacafaaaakkaeaaaaaaaaaaaaaaaaaaaaaa neg r5.z, v5.z
ckaaaaaaabaaabacafaaaakkacaaaaaaaiaaaakkabaaaaaa slt r1.x, r5.z, c8.z
adaaaaaaabaaabacabaaaaaaacaaaaaaaeaaaappacaaaaaa mul r1.x, r1.x, r4.w
adaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaappacaaaaaa mul r1.x, r1.x, r0.w
ahaaaaaaacaaabacacaaaaaaacaaaaaaahaaaaoeabaaaaaa max r2.x, r2.x, c7
adaaaaaaabaaabacacaaaaaaacaaaaaaabaaaaaaacaaaaaa mul r1.x, r2.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaakeacaaaaaa mul r1.xyz, r1.x, r3.xyzz
adaaaaaaabaaahacabaaaakeacaaaaaaaiaaaaffabaaaaaa mul r1.xyz, r1.xyzz, c8.y
adaaaaaaabaaaiacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa mul r1.w, r0.x, c4.x
bgaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa sat r1.w, r1.w
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_LightTextureB0] 2D
SetTexture 3 [_LightTexture0] CUBE
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 35 ALU, 4 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.20373535, 0.79638672, 1, 0 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEX R0.xyz, fragment.texcoord[1], texture[1], CUBE;
TEX R2, fragment.texcoord[0], texture[0], 2D;
TEX R1.w, fragment.texcoord[5], texture[3], CUBE;
DP3 R0.w, fragment.texcoord[5], fragment.texcoord[5];
MOV R1.x, c[7].z;
ADD R1.x, R1, -c[5];
MAD R2.w, -R2, R1.x, c[7].z;
MUL R0.xyz, R0, c[3];
MUL R0.xyz, R0, c[2];
MUL R1.xyz, R2, c[1];
MAD R2.xyz, R0, R2.w, R1;
DP3 R0.y, fragment.texcoord[3], fragment.texcoord[3];
RSQ R0.y, R0.y;
DP3 R0.x, fragment.texcoord[2], fragment.texcoord[2];
MUL R1.xyz, R0.y, fragment.texcoord[3];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, fragment.texcoord[2];
DP3 R1.x, R0, R1;
MAX R1.x, R1, c[7].w;
DP3 R1.y, fragment.texcoord[4], fragment.texcoord[4];
MUL R0.xyz, R2, c[0];
ADD_SAT R1.x, -R1, c[7].z;
POW R2.x, R1.x, c[6].x;
RSQ R1.y, R1.y;
MUL R1.xyz, R1.y, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
MAD R2.x, R2, c[7].y, c[7];
TEX R0.w, R0.w, texture[2], 2D;
MUL R1.y, R0.w, R1.w;
MAX R0.w, R1.x, c[7];
MUL R0.w, R0, R1.y;
MUL R1.xyz, R0.w, R0;
MAX R0.x, R2, c[7].w;
MUL result.color.xyz, R1, c[8].x;
MUL_SAT result.color.w, R0.x, c[4].x;
END
# 35 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "POINT_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_LightTextureB0] 2D
SetTexture 3 [_LightTexture0] CUBE
"ps_2_0
; 36 ALU, 4 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
dcl_cube s3
def c7, 0.00000000, 0.79638672, 0.20373535, 1.00000000
def c8, 2.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
dcl t5.xyz
texld r2, t0, s0
texld r3, t1, s1
dp3 r0.x, t5, t5
mov r1.xy, r0.x
mul_pp r3.xyz, r3, c3
mul_pp r3.xyz, r3, c2
mul_pp r2.xyz, r2, c1
texld r4, r1, s2
texld r0, t5, s3
dp3_pp r1.x, t3, t3
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r1.x
rsq_pp r0.x, r0.x
mul_pp r0.xyz, r0.x, t2
mul_pp r1.xyz, r1.x, t3
dp3_pp r0.x, r0, r1
max_pp r0.x, r0, c7
add_pp_sat r0.x, -r0, c7.w
pow_pp r1.w, r0.x, c6.x
mov_pp r0.x, c5
add_pp r0.x, c7.w, -r0
mad_pp r0.x, -r2.w, r0, c7.w
mad_pp r0.xyz, r3, r0.x, r2
mul_pp r2.xyz, r0, c0
mov_pp r0.x, r1.w
mad_pp r0.x, r0, c7.y, c7.z
dp3_pp r1.x, t4, t4
rsq_pp r1.x, r1.x
mul_pp r1.xyz, r1.x, t4
dp3_pp r1.x, t3, r1
max_pp r0.x, r0, c7
mul r3.x, r4, r0.w
max_pp r1.x, r1, c7
mul_pp r1.x, r1, r3
mul_pp r1.xyz, r1.x, r2
mul_pp r1.xyz, r1, c8.x
mul_pp_sat r1.w, r0.x, c4.x
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
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_LightTextureB0] 2D
SetTexture 3 [_LightTexture0] CUBE
"agal_ps
c7 0.0 0.796387 0.203735 1.0
c8 2.0 0.0 0.0 0.0
[bc]
ciaaaaaaadaaapacabaaaaoeaeaaaaaaabaaaaaaafbababb tex r3, v1, s1 <cube wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
bcaaaaaaaaaaabacafaaaaoeaeaaaaaaafaaaaoeaeaaaaaa dp3 r0.x, v5, v5
aaaaaaaaabaaadacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r1.xy, r0.x
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c1
ciaaaaaaabaaapacabaaaafeacaaaaaaacaaaaaaafaababb tex r1, r1.xyyy, s2 <2d wrap linear point>
ciaaaaaaaaaaapacafaaaaoeaeaaaaaaadaaaaaaafbababb tex r0, v5, s3 <cube wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
adaaaaaaabaaahacadaaaakeacaaaaaaadaaaaoeabaaaaaa mul r1.xyz, r3.xyzz, c3
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaappabaaaaaa add r0.x, r0.x, c7.w
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaadaaapacaaaaaaaaacaaaaaaagaaaaaaabaaaaaa pow r3, r0.x, c6.x
aaaaaaaaaaaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c5
acaaaaaaaaaaabacahaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c7.w, r0.x
adaaaaaaabaaahacabaaaakeacaaaaaaacaaaaoeabaaaaaa mul r1.xyz, r1.xyzz, c2
bfaaaaaaadaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r3.w, r2.w
adaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r3.w, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaappabaaaaaa add r0.x, r0.x, c7.w
adaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r1.xyzz, r0.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
bcaaaaaaabaaabacaeaaaaoeaeaaaaaaaeaaaaoeaeaaaaaa dp3 r1.x, v4, v4
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
adaaaaaaabaaahacabaaaaaaacaaaaaaaeaaaaoeaeaaaaaa mul r1.xyz, r1.x, v4
bcaaaaaaabaaabacadaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v3, r1.xyzz
adaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r0.xyzz, c0
aaaaaaaaaaaaabacadaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r3.x
adaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaffabaaaaaa mul r0.x, r0.x, c7.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaakkabaaaaaa add r0.x, r0.x, c7.z
adaaaaaaadaaabacabaaaappacaaaaaaaaaaaappacaaaaaa mul r3.x, r1.w, r0.w
ahaaaaaaabaaabacabaaaaaaacaaaaaaahaaaaoeabaaaaaa max r1.x, r1.x, c7
adaaaaaaabaaabacabaaaaaaacaaaaaaadaaaaaaacaaaaaa mul r1.x, r1.x, r3.x
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r1.x, r2.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
adaaaaaaabaaahacabaaaakeacaaaaaaaiaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c8.x
adaaaaaaabaaaiacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa mul r1.w, r0.x, c4.x
bgaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa sat r1.w, r1.w
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_LightTexture0] 2D
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 30 ALU, 3 TEX
PARAM c[9] = { program.local[0..6],
		{ 0.20373535, 0.79638672, 1, 0 },
		{ 2 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEX R0, fragment.texcoord[0], texture[0], 2D;
TEX R1.xyz, fragment.texcoord[1], texture[1], CUBE;
TEX R1.w, fragment.texcoord[5], texture[2], 2D;
DP3 R2.w, fragment.texcoord[3], fragment.texcoord[3];
RSQ R3.x, R2.w;
DP3 R2.x, fragment.texcoord[2], fragment.texcoord[2];
RSQ R2.x, R2.x;
MOV R2.w, c[7].z;
ADD R2.w, R2, -c[5].x;
MUL R1.xyz, R1, c[3];
MAD R0.w, -R0, R2, c[7].z;
MUL R1.xyz, R1, c[2];
MUL R0.xyz, R0, c[1];
MAD R0.xyz, R1, R0.w, R0;
MOV R1.xyz, fragment.texcoord[4];
DP3 R1.x, fragment.texcoord[3], R1;
MAX R1.x, R1, c[7].w;
MUL R0.xyz, R0, c[0];
MUL R1.x, R1, R1.w;
MUL R1.xyz, R1.x, R0;
MUL R2.xyz, R2.x, fragment.texcoord[2];
MUL R3.xyz, R3.x, fragment.texcoord[3];
DP3 R2.x, R2, R3;
MAX R0.w, R2.x, c[7];
ADD_SAT R0.w, -R0, c[7].z;
POW R0.w, R0.w, c[6].x;
MAD R0.w, R0, c[7].y, c[7].x;
MAX R0.x, R0.w, c[7].w;
MUL result.color.xyz, R1, c[8].x;
MUL_SAT result.color.w, R0.x, c[4].x;
END
# 30 instructions, 4 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL_COOKIE" }
Vector 0 [_LightColor0]
Vector 1 [_Color]
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_LightTexture0] 2D
"ps_2_0
; 31 ALU, 3 TEX
dcl_2d s0
dcl_cube s1
dcl_2d s2
def c7, 0.00000000, 0.79638672, 0.20373535, 1.00000000
def c8, 2.00000000, 0, 0, 0
dcl t0.xy
dcl t1.xyz
dcl t2.xyz
dcl t3.xyz
dcl t4.xyz
dcl t5.xy
texld r0, t5, s2
texld r2, t0, s0
texld r3, t1, s1
dp3_pp r1.x, t3, t3
dp3_pp r0.x, t2, t2
rsq_pp r1.x, r1.x
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r3, c3
mul_pp r0.xyz, r0.x, t2
mul_pp r1.xyz, r1.x, t3
dp3_pp r0.x, r0, r1
max_pp r0.x, r0, c7
add_pp_sat r0.x, -r0, c7.w
pow_pp r1.w, r0.x, c6.x
mov_pp r0.x, c5
add_pp r0.x, c7.w, -r0
mul_pp r2.xyz, r2, c1
mul_pp r3.xyz, r3, c2
mad_pp r0.x, -r2.w, r0, c7.w
mad_pp r0.xyz, r3, r0.x, r2
mul_pp r2.xyz, r0, c0
mov_pp r0.x, r1.w
mov_pp r1.xyz, t4
dp3_pp r1.x, t3, r1
mad_pp r0.x, r0, c7.y, c7.z
max_pp r1.x, r1, c7
mul_pp r1.x, r1, r0.w
mul_pp r1.xyz, r1.x, r2
max_pp r0.x, r0, c7
mul_pp r1.xyz, r1, c8.x
mul_pp_sat r1.w, r0.x, c4.x
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
Vector 2 [_TintColor]
Vector 3 [_ReflectColor]
Float 4 [_AlphaPower]
Float 5 [_OpaqueReflection]
Float 6 [_FresnelPower]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_Cube] CUBE
SetTexture 2 [_LightTexture0] 2D
"agal_ps
c7 0.0 0.796387 0.203735 1.0
c8 2.0 0.0 0.0 0.0
[bc]
ciaaaaaaaaaaapacafaaaaoeaeaaaaaaacaaaaaaafaababb tex r0, v5, s2 <2d wrap linear point>
ciaaaaaaacaaapacaaaaaaoeaeaaaaaaaaaaaaaaafaababb tex r2, v0, s0 <2d wrap linear point>
ciaaaaaaadaaapacabaaaaoeaeaaaaaaabaaaaaaafbababb tex r3, v1, s1 <cube wrap linear point>
bcaaaaaaabaaabacadaaaaoeaeaaaaaaadaaaaoeaeaaaaaa dp3 r1.x, v3, v3
bcaaaaaaaaaaabacacaaaaoeaeaaaaaaacaaaaoeaeaaaaaa dp3 r0.x, v2, v2
akaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r1.x, r1.x
akaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa rsq r0.x, r0.x
adaaaaaaadaaahacadaaaakeacaaaaaaadaaaaoeabaaaaaa mul r3.xyz, r3.xyzz, c3
adaaaaaaaaaaahacaaaaaaaaacaaaaaaacaaaaoeaeaaaaaa mul r0.xyz, r0.x, v2
adaaaaaaabaaahacabaaaaaaacaaaaaaadaaaaoeaeaaaaaa mul r1.xyz, r1.x, v3
bcaaaaaaaaaaabacaaaaaakeacaaaaaaabaaaakeacaaaaaa dp3 r0.x, r0.xyzz, r1.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
bfaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa neg r0.x, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaappabaaaaaa add r0.x, r0.x, c7.w
bgaaaaaaaaaaabacaaaaaaaaacaaaaaaaaaaaaaaaaaaaaaa sat r0.x, r0.x
alaaaaaaabaaapacaaaaaaaaacaaaaaaagaaaaaaabaaaaaa pow r1, r0.x, c6.x
aaaaaaaaaaaaabacafaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov r0.x, c5
acaaaaaaaaaaabacahaaaappabaaaaaaaaaaaaaaacaaaaaa sub r0.x, c7.w, r0.x
adaaaaaaacaaahacacaaaakeacaaaaaaabaaaaoeabaaaaaa mul r2.xyz, r2.xyzz, c1
adaaaaaaadaaahacadaaaakeacaaaaaaacaaaaoeabaaaaaa mul r3.xyz, r3.xyzz, c2
bfaaaaaaadaaaiacacaaaappacaaaaaaaaaaaaaaaaaaaaaa neg r3.w, r2.w
adaaaaaaaaaaabacadaaaappacaaaaaaaaaaaaaaacaaaaaa mul r0.x, r3.w, r0.x
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaappabaaaaaa add r0.x, r0.x, c7.w
adaaaaaaaaaaahacadaaaakeacaaaaaaaaaaaaaaacaaaaaa mul r0.xyz, r3.xyzz, r0.x
abaaaaaaaaaaahacaaaaaakeacaaaaaaacaaaakeacaaaaaa add r0.xyz, r0.xyzz, r2.xyzz
adaaaaaaacaaahacaaaaaakeacaaaaaaaaaaaaoeabaaaaaa mul r2.xyz, r0.xyzz, c0
aaaaaaaaaaaaabacabaaaaaaacaaaaaaaaaaaaaaaaaaaaaa mov r0.x, r1.x
aaaaaaaaabaaahacaeaaaaoeaeaaaaaaaaaaaaaaaaaaaaaa mov r1.xyz, v4
bcaaaaaaabaaabacadaaaaoeaeaaaaaaabaaaakeacaaaaaa dp3 r1.x, v3, r1.xyzz
adaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaffabaaaaaa mul r0.x, r0.x, c7.y
abaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaakkabaaaaaa add r0.x, r0.x, c7.z
ahaaaaaaabaaabacabaaaaaaacaaaaaaahaaaaoeabaaaaaa max r1.x, r1.x, c7
adaaaaaaabaaabacabaaaaaaacaaaaaaaaaaaappacaaaaaa mul r1.x, r1.x, r0.w
adaaaaaaabaaahacabaaaaaaacaaaaaaacaaaakeacaaaaaa mul r1.xyz, r1.x, r2.xyzz
ahaaaaaaaaaaabacaaaaaaaaacaaaaaaahaaaaoeabaaaaaa max r0.x, r0.x, c7
adaaaaaaabaaahacabaaaakeacaaaaaaaiaaaaaaabaaaaaa mul r1.xyz, r1.xyzz, c8.x
adaaaaaaabaaaiacaaaaaaaaacaaaaaaaeaaaaaaabaaaaaa mul r1.w, r0.x, c4.x
bgaaaaaaabaaaiacabaaaappacaaaaaaaaaaaaaaaaaaaaaa sat r1.w, r1.w
aaaaaaaaaaaaapadabaaaaoeacaaaaaaaaaaaaaaaaaaaaaa mov o0, r1
"
}

}
	}

#LINE 56


}
	
FallBack "Reflective/VertexLit"
} 

