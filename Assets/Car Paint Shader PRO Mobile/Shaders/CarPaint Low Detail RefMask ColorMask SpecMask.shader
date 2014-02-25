//like MED but without POINT LIGHTS and with many optimisations

Shader "RedDotGames/Mobile/Car Paint Low Detail Ref Color Spec Mask" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _Shininess ("Shininess", Range (0.01, 10)) = 1
	  _Gloss ("Gloss", Range (0.0, 10)) = 1
	  _MainTex ("Texture(RGB) Mask (A)", 2D) = "white" {} 
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
//   opengl - ALU: 16 to 16
//   d3d9 - ALU: 16 to 16
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"!!ARBvp1.0
# 16 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 16 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_2_0
; 16 ALU
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0
mov oT3, v2
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.w, v0, c7
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"agal_vs
c12 0.0 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r1.xyz, a1.z, c10
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c12.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaabaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v1.xyz, r0.w, r0.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bdaaaaaaaaaaaiaeaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 v0.w, a0, c7
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"!!ARBvp1.0
# 16 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 16 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_2_0
; 16 ALU
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0
mov oT3, v2
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.w, v0, c7
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"agal_vs
c12 0.0 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r1.xyz, a1.z, c10
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c12.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaabaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v1.xyz, r0.w, r0.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bdaaaaaaaaaaaiaeaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 v0.w, a0, c7
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"!!ARBvp1.0
# 16 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 16 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_2_0
; 16 ALU
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0
mov oT3, v2
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.w, v0, c7
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"agal_vs
c12 0.0 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r1.xyz, a1.z, c10
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c12.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaabaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v1.xyz, r0.w, r0.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bdaaaaaaaaaaaiaeaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 v0.w, a0, c7
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"!!ARBvp1.0
# 16 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 16 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_2_0
; 16 ALU
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0
mov oT3, v2
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.w, v0, c7
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"agal_vs
c12 0.0 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r1.xyz, a1.z, c10
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c12.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaabaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v1.xyz, r0.w, r0.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bdaaaaaaaaaaaiaeaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 v0.w, a0, c7
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"!!ARBvp1.0
# 16 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 16 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_2_0
; 16 ALU
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0
mov oT3, v2
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.w, v0, c7
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"agal_vs
c12 0.0 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r1.xyz, a1.z, c10
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c12.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaabaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v1.xyz, r0.w, r0.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bdaaaaaaaaaaaiaeaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 v0.w, a0, c7
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"!!ARBvp1.0
# 16 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 16 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_2_0
; 16 ALU
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0
mov oT3, v2
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.w, v0, c7
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"agal_vs
c12 0.0 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r1.xyz, a1.z, c10
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c12.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaabaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v1.xyz, r0.w, r0.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bdaaaaaaaaaaaiaeaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 v0.w, a0, c7
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"!!ARBvp1.0
# 16 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 16 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_2_0
; 16 ALU
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0
mov oT3, v2
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.w, v0, c7
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"agal_vs
c12 0.0 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r1.xyz, a1.z, c10
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c12.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaabaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v1.xyz, r0.w, r0.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bdaaaaaaaaaaaiaeaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 v0.w, a0, c7
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
"!!ARBvp1.0
# 16 ALU
PARAM c[13] = { { 0 },
		state.matrix.mvp,
		program.local[5..12] };
TEMP R0;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R0.xyz, vertex.normal.z, c[11], R0;
ADD R0.xyz, R0, c[0].x;
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[1].xyz, R0.w, R0;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
DP4 result.texcoord[0].w, vertex.position, c[8];
DP4 result.texcoord[0].z, vertex.position, c[7];
DP4 result.texcoord[0].y, vertex.position, c[6];
DP4 result.texcoord[0].x, vertex.position, c[5];
END
# 16 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"vs_2_0
; 16 ALU
def c12, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r0.xyz, v1.z, c10, r0
add r0.xyz, r0, c12.x
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul oT1.xyz, r0.w, r0
mov oT3, v2
dp4 oPos.w, v0, c3
dp4 oPos.z, v0, c2
dp4 oPos.y, v0, c1
dp4 oPos.x, v0, c0
dp4 oT0.w, v0, c7
dp4 oT0.z, v0, c6
dp4 oT0.y, v0, c5
dp4 oT0.x, v0, c4
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
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

varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;

uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesMultiTexCoord0;
attribute vec3 _glesNormal;
attribute vec4 _glesVertex;
void main ()
{
  lowp vec3 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2.w = 0.0;
  tmpvar_2.xyz = normalize (_glesNormal);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((tmpvar_2 * _World2Object).xyz);
  tmpvar_1 = tmpvar_3;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_1;
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
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

varying mediump vec4 xlv_TEXCOORD3;
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
uniform samplerCube _Cube;
uniform lowp vec4 _Color;
void main ()
{
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec3 specularReflection;
  lowp vec3 ambientLighting;
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
  lowp vec3 tmpvar_5;
  tmpvar_5 = normalize (_WorldSpaceLightPos0.xyz);
  highp vec3 tmpvar_6;
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = (_LightColor0.xyz * max (0.0, dot (tmpvar_1, tmpvar_5)));
  lowp float tmpvar_8;
  tmpvar_8 = dot (tmpvar_1, tmpvar_5);
  if ((tmpvar_8 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_9;
    tmpvar_9 = max (0.0, dot (reflect (-(tmpvar_5), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_10;
    tmpvar_10 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_9, _Shininess));
    specularReflection = tmpvar_10;
  };
  mediump vec3 tmpvar_11;
  tmpvar_11 = (specularReflection * (_Gloss * tmpvar_4.w));
  specularReflection = tmpvar_11;
  lowp vec3 tmpvar_12;
  tmpvar_12 = reflect (-(viewDirection), tmpvar_1);
  lowp vec4 tmpvar_13;
  tmpvar_13 = textureCube (_Cube, tmpvar_12);
  reflTex = tmpvar_13;
  lowp float tmpvar_14;
  tmpvar_14 = clamp (abs (dot (tmpvar_12, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_15;
  tmpvar_15 = pow ((1.0 - tmpvar_14), _FrezFalloff);
  frez = tmpvar_15;
  lowp float tmpvar_16;
  tmpvar_16 = (frez * _FrezPow);
  frez = tmpvar_16;
  reflTex.xyz = (tmpvar_13.xyz * clamp ((_Reflection + tmpvar_16), 0.0, 1.0));
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp ((ambientLighting + tmpvar_7), 0.0, 1.0)) + specularReflection);
  gl_FragData[0] = ((tmpvar_17 + (reflTex * tmpvar_4.w)) + ((tmpvar_16 * reflTex) * tmpvar_4.w));
}



#endif"
}

SubProgram "flash " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Matrix 0 [glstate_matrix_mvp]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
"agal_vs
c12 0.0 0.0 0.0 0.0
[bc]
adaaaaaaaaaaahacabaaaaffaaaaaaaaajaaaaoeabaaaaaa mul r0.xyz, a1.y, c9
adaaaaaaabaaahacabaaaaaaaaaaaaaaaiaaaaoeabaaaaaa mul r1.xyz, a1.x, c8
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
adaaaaaaabaaahacabaaaakkaaaaaaaaakaaaaoeabaaaaaa mul r1.xyz, a1.z, c10
abaaaaaaaaaaahacabaaaakeacaaaaaaaaaaaakeacaaaaaa add r0.xyz, r1.xyzz, r0.xyzz
abaaaaaaaaaaahacaaaaaakeacaaaaaaamaaaaaaabaaaaaa add r0.xyz, r0.xyzz, c12.x
bcaaaaaaaaaaaiacaaaaaakeacaaaaaaaaaaaakeacaaaaaa dp3 r0.w, r0.xyzz, r0.xyzz
akaaaaaaaaaaaiacaaaaaappacaaaaaaaaaaaaaaaaaaaaaa rsq r0.w, r0.w
adaaaaaaabaaahaeaaaaaappacaaaaaaaaaaaakeacaaaaaa mul v1.xyz, r0.w, r0.xyzz
aaaaaaaaadaaapaeadaaaaoeaaaaaaaaaaaaaaaaaaaaaaaa mov v3, a3
bdaaaaaaaaaaaiadaaaaaaoeaaaaaaaaadaaaaoeabaaaaaa dp4 o0.w, a0, c3
bdaaaaaaaaaaaeadaaaaaaoeaaaaaaaaacaaaaoeabaaaaaa dp4 o0.z, a0, c2
bdaaaaaaaaaaacadaaaaaaoeaaaaaaaaabaaaaoeabaaaaaa dp4 o0.y, a0, c1
bdaaaaaaaaaaabadaaaaaaoeaaaaaaaaaaaaaaoeabaaaaaa dp4 o0.x, a0, c0
bdaaaaaaaaaaaiaeaaaaaaoeaaaaaaaaahaaaaoeabaaaaaa dp4 v0.w, a0, c7
bdaaaaaaaaaaaeaeaaaaaaoeaaaaaaaaagaaaaoeabaaaaaa dp4 v0.z, a0, c6
bdaaaaaaaaaaacaeaaaaaaoeaaaaaaaaafaaaaoeabaaaaaa dp4 v0.y, a0, c5
bdaaaaaaaaaaabaeaaaaaaoeaaaaaaaaaeaaaaoeabaaaaaa dp4 v0.x, a0, c4
aaaaaaaaabaaaiaeaaaaaaoeabaaaaaaaaaaaaaaaaaaaaaa mov v1.w, c0
"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 50 to 50, TEX: 2 to 2
//   d3d9 - ALU: 55 to 55, TEX: 2 to 2
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
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 50 ALU, 2 TEX
PARAM c[12] = { state.lightmodel.ambient,
		program.local[1..10],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
ADD R1.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R1, R1;
RSQ R0.y, R0.y;
MUL R3.xyz, R0.y, R1;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R2, -R3;
MUL R0.xyz, R2, R0.x;
MAD R4.xyz, -R0, c[11].x, -R3;
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
MUL R5.xyz, R2.w, c[2];
DP3 R2.w, R2, R5;
MUL R2.xyz, R2, -R2.w;
MAD R2.xyz, -R2, c[11].x, -R5;
DP3 R2.x, R3, R2;
SLT R3.y, R2.w, c[11].z;
MAX R2.x, R2, c[11].z;
POW R3.z, R2.x, c[6].x;
DP3 R3.x, R4, fragment.texcoord[1];
ABS_SAT R3.x, R3;
MOV R2.xyz, c[5];
ABS R3.y, R3;
MUL R2.xyz, R2, c[10];
MUL R2.xyz, R2, R3.z;
CMP R3.y, -R3, c[11].z, c[11];
CMP R2.xyz, -R3.y, R2, c[11].z;
ADD R3.w, -R3.x, c[11].y;
MAX R2.w, R2, c[11].z;
TEX R1, fragment.texcoord[3], texture[0], 2D;
TEX R0, R4, texture[1], CUBE;
MUL R3.y, R1.w, c[7].x;
MUL R3.xyz, R2, R3.y;
POW R2.y, R3.w, c[9].x;
MUL R3.w, R2.y, c[8].x;
MOV R2.x, c[11].y;
ADD R4.x, -R1.w, c[11].y;
ADD R2.xyz, R2.x, -c[3];
MAD R2.xyz, R4.x, R2, c[3];
MUL R1.xyz, R1, R2;
ADD_SAT R4.x, R3.w, c[4];
MOV R2.xyz, c[0];
MAD_SAT R2.xyz, R2.w, c[10], R2;
MUL R0.xyz, R0, R4.x;
MAD R2.xyz, R1, R2, R3;
MOV R2.w, c[11].y;
MAD R2, R0, R1.w, R2;
MUL R0, R3.w, R0;
MAD result.color, R0, R1.w, R2;
END
# 50 instructions, 6 R-regs
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
"ps_2_0
; 55 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c11, 2.00000000, 1.00000000, 0.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t3.xy
texld r4, t3, s0
add r2.xyz, -t0, c1
dp3 r1.x, r2, r2
rsq r1.x, r1.x
dp3_pp r0.x, t1, t1
mul r2.xyz, r1.x, r2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, t1
dp3_pp r0.x, r1, -r2
mul_pp r0.xyz, r1, r0.x
mad_pp r3.xyz, -r0, c11.x, -r2
dp3_pp r0.x, c2, c2
rsq_pp r0.x, r0.x
mul_pp r6.xyz, r0.x, c2
dp3_pp r0.x, r1, r6
mul_pp r1.xyz, r1, -r0.x
mad_pp r1.xyz, -r1, c11.x, -r6
dp3_pp r1.x, r2, r1
max_pp r1.x, r1, c11.z
pow_pp r2.y, r1.x, c6.x
dp3_pp r1.x, r3, t1
mov_pp r6.xyz, c10
abs_pp_sat r1.x, r1
mul_pp r6.xyz, c5, r6
add_pp r1.x, -r1, c11.y
mov_pp r2.w, c11.y
texld r5, r3, s1
mov_pp r3.x, r2
cmp_pp r2.x, r0, c11.z, c11.y
mul_pp r3.xyz, r6, r3.x
abs_pp r2.x, r2
cmp_pp r6.xyz, -r2.x, r3, c11.z
pow_pp r3.w, r1.x, c9.x
mul_pp r2.x, r4.w, c7
mul_pp r6.xyz, r6, r2.x
mov_pp r1.x, r3.w
mov_pp r2.xyz, c3
add_pp r3.xyz, c11.y, -r2
add_pp r2.x, -r4.w, c11.y
mad_pp r2.xyz, r2.x, r3, c3
mul_pp r1.x, r1, c8
mov_pp r0.w, r5
mul_pp r2.xyz, r4, r2
mov_pp r3.xyz, c0
max_pp r0.x, r0, c11.z
mad_pp_sat r0.xyz, r0.x, c10, r3
mad_pp r2.xyz, r2, r0, r6
add_pp_sat r0.x, r1, c4
mul_pp r0.xyz, r5, r0.x
mad_pp r2, r0, r4.w, r2
mul_pp r0, r1.x, r0
mad_pp r0, r0, r4.w, r2
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
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 50 ALU, 2 TEX
PARAM c[12] = { state.lightmodel.ambient,
		program.local[1..10],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
ADD R1.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R1, R1;
RSQ R0.y, R0.y;
MUL R3.xyz, R0.y, R1;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R2, -R3;
MUL R0.xyz, R2, R0.x;
MAD R4.xyz, -R0, c[11].x, -R3;
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
MUL R5.xyz, R2.w, c[2];
DP3 R2.w, R2, R5;
MUL R2.xyz, R2, -R2.w;
MAD R2.xyz, -R2, c[11].x, -R5;
DP3 R2.x, R3, R2;
SLT R3.y, R2.w, c[11].z;
MAX R2.x, R2, c[11].z;
POW R3.z, R2.x, c[6].x;
DP3 R3.x, R4, fragment.texcoord[1];
ABS_SAT R3.x, R3;
MOV R2.xyz, c[5];
ABS R3.y, R3;
MUL R2.xyz, R2, c[10];
MUL R2.xyz, R2, R3.z;
CMP R3.y, -R3, c[11].z, c[11];
CMP R2.xyz, -R3.y, R2, c[11].z;
ADD R3.w, -R3.x, c[11].y;
MAX R2.w, R2, c[11].z;
TEX R1, fragment.texcoord[3], texture[0], 2D;
TEX R0, R4, texture[1], CUBE;
MUL R3.y, R1.w, c[7].x;
MUL R3.xyz, R2, R3.y;
POW R2.y, R3.w, c[9].x;
MUL R3.w, R2.y, c[8].x;
MOV R2.x, c[11].y;
ADD R4.x, -R1.w, c[11].y;
ADD R2.xyz, R2.x, -c[3];
MAD R2.xyz, R4.x, R2, c[3];
MUL R1.xyz, R1, R2;
ADD_SAT R4.x, R3.w, c[4];
MOV R2.xyz, c[0];
MAD_SAT R2.xyz, R2.w, c[10], R2;
MUL R0.xyz, R0, R4.x;
MAD R2.xyz, R1, R2, R3;
MOV R2.w, c[11].y;
MAD R2, R0, R1.w, R2;
MUL R0, R3.w, R0;
MAD result.color, R0, R1.w, R2;
END
# 50 instructions, 6 R-regs
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
"ps_2_0
; 55 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c11, 2.00000000, 1.00000000, 0.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t3.xy
texld r4, t3, s0
add r2.xyz, -t0, c1
dp3 r1.x, r2, r2
rsq r1.x, r1.x
dp3_pp r0.x, t1, t1
mul r2.xyz, r1.x, r2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, t1
dp3_pp r0.x, r1, -r2
mul_pp r0.xyz, r1, r0.x
mad_pp r3.xyz, -r0, c11.x, -r2
dp3_pp r0.x, c2, c2
rsq_pp r0.x, r0.x
mul_pp r6.xyz, r0.x, c2
dp3_pp r0.x, r1, r6
mul_pp r1.xyz, r1, -r0.x
mad_pp r1.xyz, -r1, c11.x, -r6
dp3_pp r1.x, r2, r1
max_pp r1.x, r1, c11.z
pow_pp r2.y, r1.x, c6.x
dp3_pp r1.x, r3, t1
mov_pp r6.xyz, c10
abs_pp_sat r1.x, r1
mul_pp r6.xyz, c5, r6
add_pp r1.x, -r1, c11.y
mov_pp r2.w, c11.y
texld r5, r3, s1
mov_pp r3.x, r2
cmp_pp r2.x, r0, c11.z, c11.y
mul_pp r3.xyz, r6, r3.x
abs_pp r2.x, r2
cmp_pp r6.xyz, -r2.x, r3, c11.z
pow_pp r3.w, r1.x, c9.x
mul_pp r2.x, r4.w, c7
mul_pp r6.xyz, r6, r2.x
mov_pp r1.x, r3.w
mov_pp r2.xyz, c3
add_pp r3.xyz, c11.y, -r2
add_pp r2.x, -r4.w, c11.y
mad_pp r2.xyz, r2.x, r3, c3
mul_pp r1.x, r1, c8
mov_pp r0.w, r5
mul_pp r2.xyz, r4, r2
mov_pp r3.xyz, c0
max_pp r0.x, r0, c11.z
mad_pp_sat r0.xyz, r0.x, c10, r3
mad_pp r2.xyz, r2, r0, r6
add_pp_sat r0.x, r1, c4
mul_pp r0.xyz, r5, r0.x
mad_pp r2, r0, r4.w, r2
mul_pp r0, r1.x, r0
mad_pp r0, r0, r4.w, r2
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
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 50 ALU, 2 TEX
PARAM c[12] = { state.lightmodel.ambient,
		program.local[1..10],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
ADD R1.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R1, R1;
RSQ R0.y, R0.y;
MUL R3.xyz, R0.y, R1;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R2, -R3;
MUL R0.xyz, R2, R0.x;
MAD R4.xyz, -R0, c[11].x, -R3;
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
MUL R5.xyz, R2.w, c[2];
DP3 R2.w, R2, R5;
MUL R2.xyz, R2, -R2.w;
MAD R2.xyz, -R2, c[11].x, -R5;
DP3 R2.x, R3, R2;
SLT R3.y, R2.w, c[11].z;
MAX R2.x, R2, c[11].z;
POW R3.z, R2.x, c[6].x;
DP3 R3.x, R4, fragment.texcoord[1];
ABS_SAT R3.x, R3;
MOV R2.xyz, c[5];
ABS R3.y, R3;
MUL R2.xyz, R2, c[10];
MUL R2.xyz, R2, R3.z;
CMP R3.y, -R3, c[11].z, c[11];
CMP R2.xyz, -R3.y, R2, c[11].z;
ADD R3.w, -R3.x, c[11].y;
MAX R2.w, R2, c[11].z;
TEX R1, fragment.texcoord[3], texture[0], 2D;
TEX R0, R4, texture[1], CUBE;
MUL R3.y, R1.w, c[7].x;
MUL R3.xyz, R2, R3.y;
POW R2.y, R3.w, c[9].x;
MUL R3.w, R2.y, c[8].x;
MOV R2.x, c[11].y;
ADD R4.x, -R1.w, c[11].y;
ADD R2.xyz, R2.x, -c[3];
MAD R2.xyz, R4.x, R2, c[3];
MUL R1.xyz, R1, R2;
ADD_SAT R4.x, R3.w, c[4];
MOV R2.xyz, c[0];
MAD_SAT R2.xyz, R2.w, c[10], R2;
MUL R0.xyz, R0, R4.x;
MAD R2.xyz, R1, R2, R3;
MOV R2.w, c[11].y;
MAD R2, R0, R1.w, R2;
MUL R0, R3.w, R0;
MAD result.color, R0, R1.w, R2;
END
# 50 instructions, 6 R-regs
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
"ps_2_0
; 55 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c11, 2.00000000, 1.00000000, 0.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t3.xy
texld r4, t3, s0
add r2.xyz, -t0, c1
dp3 r1.x, r2, r2
rsq r1.x, r1.x
dp3_pp r0.x, t1, t1
mul r2.xyz, r1.x, r2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, t1
dp3_pp r0.x, r1, -r2
mul_pp r0.xyz, r1, r0.x
mad_pp r3.xyz, -r0, c11.x, -r2
dp3_pp r0.x, c2, c2
rsq_pp r0.x, r0.x
mul_pp r6.xyz, r0.x, c2
dp3_pp r0.x, r1, r6
mul_pp r1.xyz, r1, -r0.x
mad_pp r1.xyz, -r1, c11.x, -r6
dp3_pp r1.x, r2, r1
max_pp r1.x, r1, c11.z
pow_pp r2.y, r1.x, c6.x
dp3_pp r1.x, r3, t1
mov_pp r6.xyz, c10
abs_pp_sat r1.x, r1
mul_pp r6.xyz, c5, r6
add_pp r1.x, -r1, c11.y
mov_pp r2.w, c11.y
texld r5, r3, s1
mov_pp r3.x, r2
cmp_pp r2.x, r0, c11.z, c11.y
mul_pp r3.xyz, r6, r3.x
abs_pp r2.x, r2
cmp_pp r6.xyz, -r2.x, r3, c11.z
pow_pp r3.w, r1.x, c9.x
mul_pp r2.x, r4.w, c7
mul_pp r6.xyz, r6, r2.x
mov_pp r1.x, r3.w
mov_pp r2.xyz, c3
add_pp r3.xyz, c11.y, -r2
add_pp r2.x, -r4.w, c11.y
mad_pp r2.xyz, r2.x, r3, c3
mul_pp r1.x, r1, c8
mov_pp r0.w, r5
mul_pp r2.xyz, r4, r2
mov_pp r3.xyz, c0
max_pp r0.x, r0, c11.z
mad_pp_sat r0.xyz, r0.x, c10, r3
mad_pp r2.xyz, r2, r0, r6
add_pp_sat r0.x, r1, c4
mul_pp r0.xyz, r5, r0.x
mad_pp r2, r0, r4.w, r2
mul_pp r0, r1.x, r0
mad_pp r0, r0, r4.w, r2
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
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 50 ALU, 2 TEX
PARAM c[12] = { state.lightmodel.ambient,
		program.local[1..10],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
ADD R1.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R1, R1;
RSQ R0.y, R0.y;
MUL R3.xyz, R0.y, R1;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R2, -R3;
MUL R0.xyz, R2, R0.x;
MAD R4.xyz, -R0, c[11].x, -R3;
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
MUL R5.xyz, R2.w, c[2];
DP3 R2.w, R2, R5;
MUL R2.xyz, R2, -R2.w;
MAD R2.xyz, -R2, c[11].x, -R5;
DP3 R2.x, R3, R2;
SLT R3.y, R2.w, c[11].z;
MAX R2.x, R2, c[11].z;
POW R3.z, R2.x, c[6].x;
DP3 R3.x, R4, fragment.texcoord[1];
ABS_SAT R3.x, R3;
MOV R2.xyz, c[5];
ABS R3.y, R3;
MUL R2.xyz, R2, c[10];
MUL R2.xyz, R2, R3.z;
CMP R3.y, -R3, c[11].z, c[11];
CMP R2.xyz, -R3.y, R2, c[11].z;
ADD R3.w, -R3.x, c[11].y;
MAX R2.w, R2, c[11].z;
TEX R1, fragment.texcoord[3], texture[0], 2D;
TEX R0, R4, texture[1], CUBE;
MUL R3.y, R1.w, c[7].x;
MUL R3.xyz, R2, R3.y;
POW R2.y, R3.w, c[9].x;
MUL R3.w, R2.y, c[8].x;
MOV R2.x, c[11].y;
ADD R4.x, -R1.w, c[11].y;
ADD R2.xyz, R2.x, -c[3];
MAD R2.xyz, R4.x, R2, c[3];
MUL R1.xyz, R1, R2;
ADD_SAT R4.x, R3.w, c[4];
MOV R2.xyz, c[0];
MAD_SAT R2.xyz, R2.w, c[10], R2;
MUL R0.xyz, R0, R4.x;
MAD R2.xyz, R1, R2, R3;
MOV R2.w, c[11].y;
MAD R2, R0, R1.w, R2;
MUL R0, R3.w, R0;
MAD result.color, R0, R1.w, R2;
END
# 50 instructions, 6 R-regs
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
"ps_2_0
; 55 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c11, 2.00000000, 1.00000000, 0.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t3.xy
texld r4, t3, s0
add r2.xyz, -t0, c1
dp3 r1.x, r2, r2
rsq r1.x, r1.x
dp3_pp r0.x, t1, t1
mul r2.xyz, r1.x, r2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, t1
dp3_pp r0.x, r1, -r2
mul_pp r0.xyz, r1, r0.x
mad_pp r3.xyz, -r0, c11.x, -r2
dp3_pp r0.x, c2, c2
rsq_pp r0.x, r0.x
mul_pp r6.xyz, r0.x, c2
dp3_pp r0.x, r1, r6
mul_pp r1.xyz, r1, -r0.x
mad_pp r1.xyz, -r1, c11.x, -r6
dp3_pp r1.x, r2, r1
max_pp r1.x, r1, c11.z
pow_pp r2.y, r1.x, c6.x
dp3_pp r1.x, r3, t1
mov_pp r6.xyz, c10
abs_pp_sat r1.x, r1
mul_pp r6.xyz, c5, r6
add_pp r1.x, -r1, c11.y
mov_pp r2.w, c11.y
texld r5, r3, s1
mov_pp r3.x, r2
cmp_pp r2.x, r0, c11.z, c11.y
mul_pp r3.xyz, r6, r3.x
abs_pp r2.x, r2
cmp_pp r6.xyz, -r2.x, r3, c11.z
pow_pp r3.w, r1.x, c9.x
mul_pp r2.x, r4.w, c7
mul_pp r6.xyz, r6, r2.x
mov_pp r1.x, r3.w
mov_pp r2.xyz, c3
add_pp r3.xyz, c11.y, -r2
add_pp r2.x, -r4.w, c11.y
mad_pp r2.xyz, r2.x, r3, c3
mul_pp r1.x, r1, c8
mov_pp r0.w, r5
mul_pp r2.xyz, r4, r2
mov_pp r3.xyz, c0
max_pp r0.x, r0, c11.z
mad_pp_sat r0.xyz, r0.x, c10, r3
mad_pp r2.xyz, r2, r0, r6
add_pp_sat r0.x, r1, c4
mul_pp r0.xyz, r5, r0.x
mad_pp r2, r0, r4.w, r2
mul_pp r0, r1.x, r0
mad_pp r0, r0, r4.w, r2
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
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 50 ALU, 2 TEX
PARAM c[12] = { state.lightmodel.ambient,
		program.local[1..10],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
ADD R1.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R1, R1;
RSQ R0.y, R0.y;
MUL R3.xyz, R0.y, R1;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R2, -R3;
MUL R0.xyz, R2, R0.x;
MAD R4.xyz, -R0, c[11].x, -R3;
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
MUL R5.xyz, R2.w, c[2];
DP3 R2.w, R2, R5;
MUL R2.xyz, R2, -R2.w;
MAD R2.xyz, -R2, c[11].x, -R5;
DP3 R2.x, R3, R2;
SLT R3.y, R2.w, c[11].z;
MAX R2.x, R2, c[11].z;
POW R3.z, R2.x, c[6].x;
DP3 R3.x, R4, fragment.texcoord[1];
ABS_SAT R3.x, R3;
MOV R2.xyz, c[5];
ABS R3.y, R3;
MUL R2.xyz, R2, c[10];
MUL R2.xyz, R2, R3.z;
CMP R3.y, -R3, c[11].z, c[11];
CMP R2.xyz, -R3.y, R2, c[11].z;
ADD R3.w, -R3.x, c[11].y;
MAX R2.w, R2, c[11].z;
TEX R1, fragment.texcoord[3], texture[0], 2D;
TEX R0, R4, texture[1], CUBE;
MUL R3.y, R1.w, c[7].x;
MUL R3.xyz, R2, R3.y;
POW R2.y, R3.w, c[9].x;
MUL R3.w, R2.y, c[8].x;
MOV R2.x, c[11].y;
ADD R4.x, -R1.w, c[11].y;
ADD R2.xyz, R2.x, -c[3];
MAD R2.xyz, R4.x, R2, c[3];
MUL R1.xyz, R1, R2;
ADD_SAT R4.x, R3.w, c[4];
MOV R2.xyz, c[0];
MAD_SAT R2.xyz, R2.w, c[10], R2;
MUL R0.xyz, R0, R4.x;
MAD R2.xyz, R1, R2, R3;
MOV R2.w, c[11].y;
MAD R2, R0, R1.w, R2;
MUL R0, R3.w, R0;
MAD result.color, R0, R1.w, R2;
END
# 50 instructions, 6 R-regs
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
"ps_2_0
; 55 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c11, 2.00000000, 1.00000000, 0.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t3.xy
texld r4, t3, s0
add r2.xyz, -t0, c1
dp3 r1.x, r2, r2
rsq r1.x, r1.x
dp3_pp r0.x, t1, t1
mul r2.xyz, r1.x, r2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, t1
dp3_pp r0.x, r1, -r2
mul_pp r0.xyz, r1, r0.x
mad_pp r3.xyz, -r0, c11.x, -r2
dp3_pp r0.x, c2, c2
rsq_pp r0.x, r0.x
mul_pp r6.xyz, r0.x, c2
dp3_pp r0.x, r1, r6
mul_pp r1.xyz, r1, -r0.x
mad_pp r1.xyz, -r1, c11.x, -r6
dp3_pp r1.x, r2, r1
max_pp r1.x, r1, c11.z
pow_pp r2.y, r1.x, c6.x
dp3_pp r1.x, r3, t1
mov_pp r6.xyz, c10
abs_pp_sat r1.x, r1
mul_pp r6.xyz, c5, r6
add_pp r1.x, -r1, c11.y
mov_pp r2.w, c11.y
texld r5, r3, s1
mov_pp r3.x, r2
cmp_pp r2.x, r0, c11.z, c11.y
mul_pp r3.xyz, r6, r3.x
abs_pp r2.x, r2
cmp_pp r6.xyz, -r2.x, r3, c11.z
pow_pp r3.w, r1.x, c9.x
mul_pp r2.x, r4.w, c7
mul_pp r6.xyz, r6, r2.x
mov_pp r1.x, r3.w
mov_pp r2.xyz, c3
add_pp r3.xyz, c11.y, -r2
add_pp r2.x, -r4.w, c11.y
mad_pp r2.xyz, r2.x, r3, c3
mul_pp r1.x, r1, c8
mov_pp r0.w, r5
mul_pp r2.xyz, r4, r2
mov_pp r3.xyz, c0
max_pp r0.x, r0, c11.z
mad_pp_sat r0.xyz, r0.x, c10, r3
mad_pp r2.xyz, r2, r0, r6
add_pp_sat r0.x, r1, c4
mul_pp r0.xyz, r5, r0.x
mad_pp r2, r0, r4.w, r2
mul_pp r0, r1.x, r0
mad_pp r0, r0, r4.w, r2
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
"!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 50 ALU, 2 TEX
PARAM c[12] = { state.lightmodel.ambient,
		program.local[1..10],
		{ 2, 1, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
ADD R1.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R1, R1;
RSQ R0.y, R0.y;
MUL R3.xyz, R0.y, R1;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R2.xyz, R0.x, fragment.texcoord[1];
DP3 R0.x, R2, -R3;
MUL R0.xyz, R2, R0.x;
MAD R4.xyz, -R0, c[11].x, -R3;
DP3 R2.w, c[2], c[2];
RSQ R2.w, R2.w;
MUL R5.xyz, R2.w, c[2];
DP3 R2.w, R2, R5;
MUL R2.xyz, R2, -R2.w;
MAD R2.xyz, -R2, c[11].x, -R5;
DP3 R2.x, R3, R2;
SLT R3.y, R2.w, c[11].z;
MAX R2.x, R2, c[11].z;
POW R3.z, R2.x, c[6].x;
DP3 R3.x, R4, fragment.texcoord[1];
ABS_SAT R3.x, R3;
MOV R2.xyz, c[5];
ABS R3.y, R3;
MUL R2.xyz, R2, c[10];
MUL R2.xyz, R2, R3.z;
CMP R3.y, -R3, c[11].z, c[11];
CMP R2.xyz, -R3.y, R2, c[11].z;
ADD R3.w, -R3.x, c[11].y;
MAX R2.w, R2, c[11].z;
TEX R1, fragment.texcoord[3], texture[0], 2D;
TEX R0, R4, texture[1], CUBE;
MUL R3.y, R1.w, c[7].x;
MUL R3.xyz, R2, R3.y;
POW R2.y, R3.w, c[9].x;
MUL R3.w, R2.y, c[8].x;
MOV R2.x, c[11].y;
ADD R4.x, -R1.w, c[11].y;
ADD R2.xyz, R2.x, -c[3];
MAD R2.xyz, R4.x, R2, c[3];
MUL R1.xyz, R1, R2;
ADD_SAT R4.x, R3.w, c[4];
MOV R2.xyz, c[0];
MAD_SAT R2.xyz, R2.w, c[10], R2;
MUL R0.xyz, R0, R4.x;
MAD R2.xyz, R1, R2, R3;
MOV R2.w, c[11].y;
MAD R2, R0, R1.w, R2;
MUL R0, R3.w, R0;
MAD result.color, R0, R1.w, R2;
END
# 50 instructions, 6 R-regs
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
"ps_2_0
; 55 ALU, 2 TEX
dcl_2d s0
dcl_cube s1
def c11, 2.00000000, 1.00000000, 0.00000000, 0
dcl t0.xyz
dcl t1.xyz
dcl t3.xy
texld r4, t3, s0
add r2.xyz, -t0, c1
dp3 r1.x, r2, r2
rsq r1.x, r1.x
dp3_pp r0.x, t1, t1
mul r2.xyz, r1.x, r2
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, t1
dp3_pp r0.x, r1, -r2
mul_pp r0.xyz, r1, r0.x
mad_pp r3.xyz, -r0, c11.x, -r2
dp3_pp r0.x, c2, c2
rsq_pp r0.x, r0.x
mul_pp r6.xyz, r0.x, c2
dp3_pp r0.x, r1, r6
mul_pp r1.xyz, r1, -r0.x
mad_pp r1.xyz, -r1, c11.x, -r6
dp3_pp r1.x, r2, r1
max_pp r1.x, r1, c11.z
pow_pp r2.y, r1.x, c6.x
dp3_pp r1.x, r3, t1
mov_pp r6.xyz, c10
abs_pp_sat r1.x, r1
mul_pp r6.xyz, c5, r6
add_pp r1.x, -r1, c11.y
mov_pp r2.w, c11.y
texld r5, r3, s1
mov_pp r3.x, r2
cmp_pp r2.x, r0, c11.z, c11.y
mul_pp r3.xyz, r6, r3.x
abs_pp r2.x, r2
cmp_pp r6.xyz, -r2.x, r3, c11.z
pow_pp r3.w, r1.x, c9.x
mul_pp r2.x, r4.w, c7
mul_pp r6.xyz, r6, r2.x
mov_pp r1.x, r3.w
mov_pp r2.xyz, c3
add_pp r3.xyz, c11.y, -r2
add_pp r2.x, -r4.w, c11.y
mad_pp r2.xyz, r2.x, r3, c3
mul_pp r1.x, r1, c8
mov_pp r0.w, r5
mul_pp r2.xyz, r4, r2
mov_pp r3.xyz, c0
max_pp r0.x, r0, c11.z
mad_pp_sat r0.xyz, r0.x, c10, r3
mad_pp r2.xyz, r2, r0, r6
add_pp_sat r0.x, r1, c4
mul_pp r0.xyz, r5, r0.x
mad_pp r2, r0, r4.w, r2
mul_pp r0, r1.x, r0
mad_pp r0, r0, r4.w, r2
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

#LINE 158

      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Mobile/Diffuse"
}