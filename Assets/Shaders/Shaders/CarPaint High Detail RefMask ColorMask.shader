Shader "RedDotGames/Mobile/Car Paint High Detail Ref Color Mask" {
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
//   opengl - ALU: 39 to 97
//   d3d9 - ALU: 39 to 97
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
# 39 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R0, c[7];
DP4 R2.y, R0, c[6];
MAD R1.xyz, vertex.normal.z, c[11], R1;
DP4 R2.x, R0, c[5];
ADD R0.xyz, R1, c[0].x;
DP3 R1.x, R2, R2;
DP3 R0.w, R0, R0;
RSQ R1.x, R1.x;
MUL R2.xyz, R1.x, R2;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
MUL R0.xyz, R1.zxyw, R2.yzxw;
MAD result.texcoord[7].xyz, R1.yzxw, R2.zxyw, -R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
MOV result.texcoord[6].xyz, R2;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[1].xyz, R1;
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
# 39 instructions, 3 R-regs
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
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mov r0.w, c13.x
mov r0.xyz, v3
dp4 r2.z, r0, c6
dp4 r2.y, r0, c5
mad r1.xyz, v1.z, c10, r1
dp4 r2.x, r0, c4
add r0.xyz, r1, c13.x
dp3 r1.x, r2, r2
dp3 r0.w, r0, r0
rsq r1.x, r1.x
mul r2.xyz, r1.x, r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r0.xyz, r1.zxyw, r2.yzxw
mad o8.xyz, r1.yzxw, r2.zxyw, -r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o1, r0
mov o7.xyz, r2
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.w, c13.x
mov r0.xyz, v1
mov o2.xyz, r1
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

varying lowp vec3 xlv_TEXCOORD7;
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
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  lowp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_9;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = cross (tmpvar_9, tmpvar_5);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  lowp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_9;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = cross (tmpvar_9, tmpvar_5);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R0, c[7];
DP4 R2.y, R0, c[6];
MAD R1.xyz, vertex.normal.z, c[11], R1;
DP4 R2.x, R0, c[5];
ADD R0.xyz, R1, c[0].x;
DP3 R1.x, R2, R2;
DP3 R0.w, R0, R0;
RSQ R1.x, R1.x;
MUL R2.xyz, R1.x, R2;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
MUL R0.xyz, R1.zxyw, R2.yzxw;
MAD result.texcoord[7].xyz, R1.yzxw, R2.zxyw, -R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
MOV result.texcoord[6].xyz, R2;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[1].xyz, R1;
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
# 39 instructions, 3 R-regs
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
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mov r0.w, c13.x
mov r0.xyz, v3
dp4 r2.z, r0, c6
dp4 r2.y, r0, c5
mad r1.xyz, v1.z, c10, r1
dp4 r2.x, r0, c4
add r0.xyz, r1, c13.x
dp3 r1.x, r2, r2
dp3 r0.w, r0, r0
rsq r1.x, r1.x
mul r2.xyz, r1.x, r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r0.xyz, r1.zxyw, r2.yzxw
mad o8.xyz, r1.yzxw, r2.zxyw, -r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o1, r0
mov o7.xyz, r2
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.w, c13.x
mov r0.xyz, v1
mov o2.xyz, r1
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

varying lowp vec3 xlv_TEXCOORD7;
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
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  lowp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_9;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = cross (tmpvar_9, tmpvar_5);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  lowp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_9;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = cross (tmpvar_9, tmpvar_5);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R0, c[7];
DP4 R2.y, R0, c[6];
MAD R1.xyz, vertex.normal.z, c[11], R1;
DP4 R2.x, R0, c[5];
ADD R0.xyz, R1, c[0].x;
DP3 R1.x, R2, R2;
DP3 R0.w, R0, R0;
RSQ R1.x, R1.x;
MUL R2.xyz, R1.x, R2;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
MUL R0.xyz, R1.zxyw, R2.yzxw;
MAD result.texcoord[7].xyz, R1.yzxw, R2.zxyw, -R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
MOV result.texcoord[6].xyz, R2;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[1].xyz, R1;
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
# 39 instructions, 3 R-regs
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
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mov r0.w, c13.x
mov r0.xyz, v3
dp4 r2.z, r0, c6
dp4 r2.y, r0, c5
mad r1.xyz, v1.z, c10, r1
dp4 r2.x, r0, c4
add r0.xyz, r1, c13.x
dp3 r1.x, r2, r2
dp3 r0.w, r0, r0
rsq r1.x, r1.x
mul r2.xyz, r1.x, r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r0.xyz, r1.zxyw, r2.yzxw
mad o8.xyz, r1.yzxw, r2.zxyw, -r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o1, r0
mov o7.xyz, r2
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.w, c13.x
mov r0.xyz, v1
mov o2.xyz, r1
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

varying lowp vec3 xlv_TEXCOORD7;
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
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  lowp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_9;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = cross (tmpvar_9, tmpvar_5);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  lowp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_9;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = cross (tmpvar_9, tmpvar_5);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R0, c[7];
DP4 R2.y, R0, c[6];
MAD R1.xyz, vertex.normal.z, c[11], R1;
DP4 R2.x, R0, c[5];
ADD R0.xyz, R1, c[0].x;
DP3 R1.x, R2, R2;
DP3 R0.w, R0, R0;
RSQ R1.x, R1.x;
MUL R2.xyz, R1.x, R2;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
MUL R0.xyz, R1.zxyw, R2.yzxw;
MAD result.texcoord[7].xyz, R1.yzxw, R2.zxyw, -R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
MOV result.texcoord[6].xyz, R2;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[1].xyz, R1;
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
# 39 instructions, 3 R-regs
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
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mov r0.w, c13.x
mov r0.xyz, v3
dp4 r2.z, r0, c6
dp4 r2.y, r0, c5
mad r1.xyz, v1.z, c10, r1
dp4 r2.x, r0, c4
add r0.xyz, r1, c13.x
dp3 r1.x, r2, r2
dp3 r0.w, r0, r0
rsq r1.x, r1.x
mul r2.xyz, r1.x, r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r0.xyz, r1.zxyw, r2.yzxw
mad o8.xyz, r1.yzxw, r2.zxyw, -r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o1, r0
mov o7.xyz, r2
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.w, c13.x
mov r0.xyz, v1
mov o2.xyz, r1
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
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  lowp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_9;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = cross (tmpvar_9, tmpvar_5);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  lowp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_9;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = cross (tmpvar_9, tmpvar_5);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R0, c[7];
DP4 R2.y, R0, c[6];
MAD R1.xyz, vertex.normal.z, c[11], R1;
DP4 R2.x, R0, c[5];
ADD R0.xyz, R1, c[0].x;
DP3 R1.x, R2, R2;
DP3 R0.w, R0, R0;
RSQ R1.x, R1.x;
MUL R2.xyz, R1.x, R2;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
MUL R0.xyz, R1.zxyw, R2.yzxw;
MAD result.texcoord[7].xyz, R1.yzxw, R2.zxyw, -R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
MOV result.texcoord[6].xyz, R2;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[1].xyz, R1;
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
# 39 instructions, 3 R-regs
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
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mov r0.w, c13.x
mov r0.xyz, v3
dp4 r2.z, r0, c6
dp4 r2.y, r0, c5
mad r1.xyz, v1.z, c10, r1
dp4 r2.x, r0, c4
add r0.xyz, r1, c13.x
dp3 r1.x, r2, r2
dp3 r0.w, r0, r0
rsq r1.x, r1.x
mul r2.xyz, r1.x, r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r0.xyz, r1.zxyw, r2.yzxw
mad o8.xyz, r1.yzxw, r2.zxyw, -r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o1, r0
mov o7.xyz, r2
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.w, c13.x
mov r0.xyz, v1
mov o2.xyz, r1
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
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  lowp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_9;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = cross (tmpvar_9, tmpvar_5);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  lowp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_9;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = cross (tmpvar_9, tmpvar_5);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
"3.0-!!ARBvp1.0
# 39 ALU
PARAM c[14] = { { 0 },
		state.matrix.mvp,
		program.local[5..13] };
TEMP R0;
TEMP R1;
TEMP R2;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.attrib[14];
DP4 R2.z, R0, c[7];
DP4 R2.y, R0, c[6];
MAD R1.xyz, vertex.normal.z, c[11], R1;
DP4 R2.x, R0, c[5];
ADD R0.xyz, R1, c[0].x;
DP3 R1.x, R2, R2;
DP3 R0.w, R0, R0;
RSQ R1.x, R1.x;
MUL R2.xyz, R1.x, R2;
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R0;
MUL R0.xyz, R1.zxyw, R2.yzxw;
MAD result.texcoord[7].xyz, R1.yzxw, R2.zxyw, -R0;
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
MOV result.texcoord[6].xyz, R2;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[1].xyz, R1;
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
# 39 instructions, 3 R-regs
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
"vs_3_0
; 39 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c13, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mov r0.w, c13.x
mov r0.xyz, v3
dp4 r2.z, r0, c6
dp4 r2.y, r0, c5
mad r1.xyz, v1.z, c10, r1
dp4 r2.x, r0, c4
add r0.xyz, r1, c13.x
dp3 r1.x, r2, r2
dp3 r0.w, r0, r0
rsq r1.x, r1.x
mul r2.xyz, r1.x, r2
rsq r0.w, r0.w
mul r1.xyz, r0.w, r0
mul r0.xyz, r1.zxyw, r2.yzxw
mad o8.xyz, r1.yzxw, r2.zxyw, -r0
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
dp4 r0.w, v0, c7
mov o1, r0
mov o7.xyz, r2
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.w, c13.x
mov r0.xyz, v1
mov o2.xyz, r1
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
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  lowp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_9;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = cross (tmpvar_9, tmpvar_5);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
  lowp mat4 modelMatrixInverse;
  lowp mat4 modelMatrix;
  modelMatrix = (_Object2World);
  modelMatrixInverse = (_World2Object);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 0.0;
  tmpvar_6.xyz = tmpvar_1;
  highp vec3 tmpvar_7;
  tmpvar_7 = (_Object2World * tmpvar_6).xyz;
  tmpvar_4 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  lowp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * modelMatrixInverse).xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((modelMatrix * _glesVertex) - tmpvar_10).xyz);
  tmpvar_3 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((modelMatrix * tmpvar_12).xyz);
  tmpvar_5 = tmpvar_13;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (modelMatrix * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_9;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = _glesMultiTexCoord0;
  xlv_TEXCOORD4 = tmpvar_3;
  xlv_TEXCOORD5 = tmpvar_4;
  xlv_TEXCOORD6 = tmpvar_5;
  xlv_TEXCOORD7 = cross (tmpvar_9, tmpvar_5);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
"3.0-!!ARBvp1.0
# 97 ALU
PARAM c[22] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
MOV R1.x, c[14].y;
MOV R1.z, c[16].y;
MOV R1.y, c[15];
ADD R1.xyz, -R0, R1;
DP3 R0.w, R1, R1;
RSQ R1.w, R0.w;
MUL R2.xyz, R1.w, R1;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
MUL R0.w, R0, c[17].y;
ADD R1.xyz, R1, c[0].x;
ADD R0.w, R0, c[0].y;
MOV R3.x, c[14].z;
MOV R3.z, c[16];
MOV R3.y, c[15].z;
ADD R3.xyz, -R0, R3;
DP3 R1.w, R3, R3;
RSQ R2.w, R1.w;
MUL R3.xyz, R2.w, R3;
DP3 R2.w, R1, R1;
MUL R3.w, R1, c[17].z;
RSQ R1.w, R2.w;
MUL R1.xyz, R1.w, R1;
ADD R2.w, R3, c[0].y;
RCP R1.w, R2.w;
DP3 R3.x, R1, R3;
MAX R2.w, R3.x, c[0].x;
MUL R3.xyz, R1.w, c[20];
DP3 R1.w, R1, R2;
MUL R4.xyz, R3, R2.w;
RCP R2.w, R0.w;
MOV R3.w, c[0].x;
MAX R1.w, R1, c[0].x;
MUL R3.xyz, R2.w, c[19];
MUL R3.xyz, R3, R1.w;
MOV R2.x, c[14];
MOV R2.z, c[16].x;
MOV R2.y, c[15].x;
ADD R2.xyz, -R0, R2;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R2.xyz, R1.w, R2;
DP3 R1.w, R1, R2;
MUL R0.w, R0, c[17].x;
ADD R0.w, R0, c[0].y;
RCP R0.w, R0.w;
MAX R1.w, R1, c[0].x;
MUL R2.xyz, R0.w, c[18];
MUL R2.xyz, R2, R1.w;
ADD R2.xyz, R2, R3;
MOV R3.xyz, vertex.attrib[14];
ADD R5.xyz, R2, R4;
DP4 R2.z, R3, c[7];
DP4 R2.x, R3, c[5];
DP4 R2.y, R3, c[6];
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R2.xyz, R1.w, R2;
MOV R3.x, c[14].w;
MOV R3.z, c[16].w;
MOV R3.y, c[15].w;
ADD R3.xyz, -R0, R3;
DP3 R0.w, R3, R3;
RSQ R1.w, R0.w;
MUL R3.xyz, R1.w, R3;
DP3 R1.w, R1, R3;
MUL R0.w, R0, c[17];
ADD R0.w, R0, c[0].y;
RCP R0.w, R0.w;
MUL R3.xyz, R0.w, c[21];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
MAX R1.w, R1, c[0].x;
MUL R4.xyz, R3, R1.w;
MUL R3.xyz, R1.zxyw, R2.yzxw;
MOV R0.w, c[0].x;
MAD result.texcoord[7].xyz, R1.yzxw, R2.zxyw, -R3;
MOV result.texcoord[6].xyz, R2;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.xyz, vertex.normal;
ADD result.texcoord[2].xyz, R5, R4;
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
# 97 instructions, 6 R-regs
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
"vs_3_0
; 97 ALU
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
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.x, c13.y
mov r1.z, c15.y
mov r1.y, c14
add r1.xyz, -r0, r1
dp3 r0.w, r1, r1
rsq r1.w, r0.w
mul r2.xyz, r1.w, r1
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
mul r0.w, r0, c16.y
add r1.xyz, r1, c21.x
add r0.w, r0, c21.y
mov r3.x, c13.z
mov r3.z, c15
mov r3.y, c14.z
add r3.xyz, -r0, r3
dp3 r1.w, r3, r3
rsq r2.w, r1.w
mul r3.xyz, r2.w, r3
dp3 r2.w, r1, r1
mul r3.w, r1, c16.z
rsq r1.w, r2.w
mul r1.xyz, r1.w, r1
add r2.w, r3, c21.y
rcp r1.w, r2.w
dp3 r3.x, r1, r3
max r2.w, r3.x, c21.x
mul r3.xyz, r1.w, c19
dp3 r1.w, r1, r2
mul r4.xyz, r3, r2.w
rcp r2.w, r0.w
mov r3.w, c21.x
max r1.w, r1, c21.x
mul r3.xyz, r2.w, c18
mul r3.xyz, r3, r1.w
mov r2.x, c13
mov r2.z, c15.x
mov r2.y, c14.x
add r2.xyz, -r0, r2
dp3 r0.w, r2, r2
rsq r1.w, r0.w
mul r2.xyz, r1.w, r2
dp3 r1.w, r1, r2
mul r0.w, r0, c16.x
add r0.w, r0, c21.y
rcp r0.w, r0.w
max r1.w, r1, c21.x
mul r2.xyz, r0.w, c17
mul r2.xyz, r2, r1.w
add r2.xyz, r2, r3
mov r3.xyz, v3
add r5.xyz, r2, r4
dp4 r2.z, r3, c6
dp4 r2.x, r3, c4
dp4 r2.y, r3, c5
dp3 r0.w, r2, r2
rsq r1.w, r0.w
mul r2.xyz, r1.w, r2
mov r3.x, c13.w
mov r3.z, c15.w
mov r3.y, c14.w
add r3.xyz, -r0, r3
dp3 r0.w, r3, r3
rsq r1.w, r0.w
mul r3.xyz, r1.w, r3
dp3 r1.w, r1, r3
mul r0.w, r0, c16
add r0.w, r0, c21.y
rcp r0.w, r0.w
mul r3.xyz, r0.w, c20
dp4 r0.w, v0, c7
mov o1, r0
max r1.w, r1, c21.x
mul r4.xyz, r3, r1.w
mul r3.xyz, r1.zxyw, r2.yzxw
mov r0.w, c21.x
mad o8.xyz, r1.yzxw, r2.zxyw, -r3
mov o7.xyz, r2
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.xyz, v1
add o3.xyz, r5, r4
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
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

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
  tmpvar_21 = ((attenuation * unity_LightColor[0].xyz) * tmpvar_20);
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
  tmpvar_27 = ((attenuation * unity_LightColor[1].xyz) * tmpvar_26);
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
  tmpvar_33 = ((attenuation * unity_LightColor[2].xyz) * tmpvar_32);
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
  tmpvar_39 = ((attenuation * unity_LightColor[3].xyz) * tmpvar_38);
  diffuseReflection = tmpvar_39;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

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
  tmpvar_21 = ((attenuation * unity_LightColor[0].xyz) * tmpvar_20);
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
  tmpvar_27 = ((attenuation * unity_LightColor[1].xyz) * tmpvar_26);
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
  tmpvar_33 = ((attenuation * unity_LightColor[2].xyz) * tmpvar_32);
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
  tmpvar_39 = ((attenuation * unity_LightColor[3].xyz) * tmpvar_38);
  diffuseReflection = tmpvar_39;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
"3.0-!!ARBvp1.0
# 97 ALU
PARAM c[22] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..21] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
MOV R1.x, c[14].y;
MOV R1.z, c[16].y;
MOV R1.y, c[15];
ADD R1.xyz, -R0, R1;
DP3 R0.w, R1, R1;
RSQ R1.w, R0.w;
MUL R2.xyz, R1.w, R1;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
MUL R0.w, R0, c[17].y;
ADD R1.xyz, R1, c[0].x;
ADD R0.w, R0, c[0].y;
MOV R3.x, c[14].z;
MOV R3.z, c[16];
MOV R3.y, c[15].z;
ADD R3.xyz, -R0, R3;
DP3 R1.w, R3, R3;
RSQ R2.w, R1.w;
MUL R3.xyz, R2.w, R3;
DP3 R2.w, R1, R1;
MUL R3.w, R1, c[17].z;
RSQ R1.w, R2.w;
MUL R1.xyz, R1.w, R1;
ADD R2.w, R3, c[0].y;
RCP R1.w, R2.w;
DP3 R3.x, R1, R3;
MAX R2.w, R3.x, c[0].x;
MUL R3.xyz, R1.w, c[20];
DP3 R1.w, R1, R2;
MUL R4.xyz, R3, R2.w;
RCP R2.w, R0.w;
MOV R3.w, c[0].x;
MAX R1.w, R1, c[0].x;
MUL R3.xyz, R2.w, c[19];
MUL R3.xyz, R3, R1.w;
MOV R2.x, c[14];
MOV R2.z, c[16].x;
MOV R2.y, c[15].x;
ADD R2.xyz, -R0, R2;
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R2.xyz, R1.w, R2;
DP3 R1.w, R1, R2;
MUL R0.w, R0, c[17].x;
ADD R0.w, R0, c[0].y;
RCP R0.w, R0.w;
MAX R1.w, R1, c[0].x;
MUL R2.xyz, R0.w, c[18];
MUL R2.xyz, R2, R1.w;
ADD R2.xyz, R2, R3;
MOV R3.xyz, vertex.attrib[14];
ADD R5.xyz, R2, R4;
DP4 R2.z, R3, c[7];
DP4 R2.x, R3, c[5];
DP4 R2.y, R3, c[6];
DP3 R0.w, R2, R2;
RSQ R1.w, R0.w;
MUL R2.xyz, R1.w, R2;
MOV R3.x, c[14].w;
MOV R3.z, c[16].w;
MOV R3.y, c[15].w;
ADD R3.xyz, -R0, R3;
DP3 R0.w, R3, R3;
RSQ R1.w, R0.w;
MUL R3.xyz, R1.w, R3;
DP3 R1.w, R1, R3;
MUL R0.w, R0, c[17];
ADD R0.w, R0, c[0].y;
RCP R0.w, R0.w;
MUL R3.xyz, R0.w, c[21];
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
MAX R1.w, R1, c[0].x;
MUL R4.xyz, R3, R1.w;
MUL R3.xyz, R1.zxyw, R2.yzxw;
MOV R0.w, c[0].x;
MAD result.texcoord[7].xyz, R1.yzxw, R2.zxyw, -R3;
MOV result.texcoord[6].xyz, R2;
ADD R2.xyz, R0, -c[13];
DP3 R0.x, R2, R2;
RSQ R0.x, R0.x;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.xyz, vertex.normal;
ADD result.texcoord[2].xyz, R5, R4;
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
# 97 instructions, 6 R-regs
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
"vs_3_0
; 97 ALU
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
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.x, c13.y
mov r1.z, c15.y
mov r1.y, c14
add r1.xyz, -r0, r1
dp3 r0.w, r1, r1
rsq r1.w, r0.w
mul r2.xyz, r1.w, r1
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
mul r0.w, r0, c16.y
add r1.xyz, r1, c21.x
add r0.w, r0, c21.y
mov r3.x, c13.z
mov r3.z, c15
mov r3.y, c14.z
add r3.xyz, -r0, r3
dp3 r1.w, r3, r3
rsq r2.w, r1.w
mul r3.xyz, r2.w, r3
dp3 r2.w, r1, r1
mul r3.w, r1, c16.z
rsq r1.w, r2.w
mul r1.xyz, r1.w, r1
add r2.w, r3, c21.y
rcp r1.w, r2.w
dp3 r3.x, r1, r3
max r2.w, r3.x, c21.x
mul r3.xyz, r1.w, c19
dp3 r1.w, r1, r2
mul r4.xyz, r3, r2.w
rcp r2.w, r0.w
mov r3.w, c21.x
max r1.w, r1, c21.x
mul r3.xyz, r2.w, c18
mul r3.xyz, r3, r1.w
mov r2.x, c13
mov r2.z, c15.x
mov r2.y, c14.x
add r2.xyz, -r0, r2
dp3 r0.w, r2, r2
rsq r1.w, r0.w
mul r2.xyz, r1.w, r2
dp3 r1.w, r1, r2
mul r0.w, r0, c16.x
add r0.w, r0, c21.y
rcp r0.w, r0.w
max r1.w, r1, c21.x
mul r2.xyz, r0.w, c17
mul r2.xyz, r2, r1.w
add r2.xyz, r2, r3
mov r3.xyz, v3
add r5.xyz, r2, r4
dp4 r2.z, r3, c6
dp4 r2.x, r3, c4
dp4 r2.y, r3, c5
dp3 r0.w, r2, r2
rsq r1.w, r0.w
mul r2.xyz, r1.w, r2
mov r3.x, c13.w
mov r3.z, c15.w
mov r3.y, c14.w
add r3.xyz, -r0, r3
dp3 r0.w, r3, r3
rsq r1.w, r0.w
mul r3.xyz, r1.w, r3
dp3 r1.w, r1, r3
mul r0.w, r0, c16
add r0.w, r0, c21.y
rcp r0.w, r0.w
mul r3.xyz, r0.w, c20
dp4 r0.w, v0, c7
mov o1, r0
max r1.w, r1, c21.x
mul r4.xyz, r3, r1.w
mul r3.xyz, r1.zxyw, r2.yzxw
mov r0.w, c21.x
mad o8.xyz, r1.yzxw, r2.zxyw, -r3
mov o7.xyz, r2
add r2.xyz, r0, -c12
dp3 r0.x, r2, r2
rsq r0.x, r0.x
mul o5.xyz, r0.x, r2
mov r0.xyz, v1
add o3.xyz, r5, r4
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
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

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
  tmpvar_21 = ((attenuation * unity_LightColor[0].xyz) * tmpvar_20);
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
  tmpvar_27 = ((attenuation * unity_LightColor[1].xyz) * tmpvar_26);
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
  tmpvar_33 = ((attenuation * unity_LightColor[2].xyz) * tmpvar_32);
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
  tmpvar_39 = ((attenuation * unity_LightColor[3].xyz) * tmpvar_38);
  diffuseReflection = tmpvar_39;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
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
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

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
  tmpvar_21 = ((attenuation * unity_LightColor[0].xyz) * tmpvar_20);
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
  tmpvar_27 = ((attenuation * unity_LightColor[1].xyz) * tmpvar_26);
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
  tmpvar_33 = ((attenuation * unity_LightColor[2].xyz) * tmpvar_32);
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
  tmpvar_39 = ((attenuation * unity_LightColor[3].xyz) * tmpvar_38);
  diffuseReflection = tmpvar_39;
  tmpvar_3 = (tmpvar_3 + diffuseReflection);
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
  tmpvar_6 = gl_LightModel.ambient.xyz;
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((attenuation * _LightColor0.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
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
  tmpvar_23.xyz = (((tmpvar_4.xyz * mix (_Color.xyz, vec3(1.0, 1.0, 1.0), vec3((1.0 - tmpvar_4.w)))) * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_24;
  tmpvar_24 = (tmpvar_23 + ((paintColor * _FlakePower) * tmpvar_4.w));
  color = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = ((color + (reflTex * tmpvar_4.w)) + ((tmpvar_22 * reflTex) * tmpvar_4.w));
  color = tmpvar_25;
  gl_FragData[0] = tmpvar_25;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 88 to 88, TEX: 3 to 3
//   d3d9 - ALU: 90 to 90, TEX: 3 to 3
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
# 88 ALU, 3 TEX
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
RSQ R1.x, R1.x;
ABS R0.w, R0;
MUL R0.xyz, R2.w, R0;
CMP R0.w, -R0, c[15], c[15].y;
MUL R1.xyz, R1.x, c[2];
CMP R2.xyz, -R0.w, R0, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R3, R3;
RSQ R3.w, R0.y;
MUL R3.xyz, R3.w, R3;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R1.xyz, R0.x, fragment.texcoord[1];
DP3 R1.w, R1, R2;
MUL R0.xyz, R1, -R1.w;
MAD R0.xyz, -R0, c[15].x, -R2;
DP3 R0.x, R0, R3;
SLT R0.y, R1.w, c[15].w;
MAX R0.x, R0, c[15].w;
POW R2.x, R0.x, c[6].x;
CMP R0.x, -R0.w, R2.w, c[15].y;
ABS R0.w, R0.y;
MUL R4.xyz, R0.x, c[14];
MUL R0.xyz, R4, c[5];
MUL R0.xyz, R0, R2.x;
CMP R0.w, -R0, c[15], c[15].y;
CMP R0.xyz, -R0.w, R0, c[15].w;
MUL R5.xyz, R0, c[7].x;
MUL R2.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R2, c[15].z;
TEX R0.xyz, R0, texture[1], 2D;
MOV R2.xy, c[16];
MAD R3.xyz, R0, c[15].x, R2.xxyw;
MOV R0.x, fragment.texcoord[6].z;
MOV R0.y, fragment.texcoord[7].z;
MOV R0.z, fragment.texcoord[5];
DP3 R2.z, R0, -R3;
MOV R0.x, fragment.texcoord[6].y;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.y, fragment.texcoord[7];
DP3 R2.y, -R3, R0;
MOV R0.x, fragment.texcoord[6];
MOV R0.z, fragment.texcoord[5].x;
MOV R0.y, fragment.texcoord[7].x;
DP3 R2.x, -R3, R0;
MOV R2.w, c[15].y;
TEX R0, fragment.texcoord[3], texture[0], 2D;
ADD R3.xyz, R2.w, -c[3];
ADD R2.w, -R0, c[15].y;
MAD R3.xyz, R2.w, R3, c[3];
MUL R0.xyz, R0, R3;
DP3 R2.w, R2, R2;
MAX R1.w, R1, c[15];
ADD R3.xyz, fragment.texcoord[2], c[0];
MAD_SAT R3.xyz, R4, R1.w, R3;
MAD R3.xyz, R0, R3, R5;
RSQ R0.x, R2.w;
MUL R0.xyz, R0.x, R2;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R2.x, R1.w;
DP3 R1.w, R1, fragment.texcoord[4];
MUL R1.xyz, R1, R1.w;
MUL R2.xyz, R2.x, fragment.texcoord[4];
DP3_SAT R1.w, R0, R2;
MAD R0.xyz, -R1, c[15].x, fragment.texcoord[4];
MUL R1.y, R1.w, R1.w;
DP3 R1.x, R0, fragment.texcoord[1];
ABS_SAT R2.x, R1;
POW R1.y, R1.y, c[10].x;
MUL R1, R1.y, c[11];
ADD R2.x, -R2, c[15].y;
POW R2.x, R2.x, c[13].x;
MUL R4.x, R2, c[12];
TEX R2, R0, texture[2], CUBE;
MUL R1, R1, c[9].x;
MOV R3.w, c[15].y;
MAD R1, R0.w, R1, R3;
ADD_SAT R3.x, R4, c[4];
MUL R2.xyz, R2, R3.x;
MAD R1, R2, R0.w, R1;
MUL R2, R4.x, R2;
MAD result.color, R2, R0.w, R1;
END
# 88 instructions, 6 R-regs
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
; 90 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c15, 2.00000000, 20.00000000, -1.00000000, 3.00000000
def c16, 1.00000000, 0.00000000, 0, 0
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
cmp_pp r0.w, -r0, c16.x, c16.y
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r3.w, r0
abs_pp r2.w, r0
mul_pp r1.xyz, r1.x, c2
cmp_pp r2.xyz, -r2.w, r0, r1
add r3.xyz, -v0, c1
dp3 r0.y, r3, r3
rsq r0.w, r0.y
dp3_pp r0.x, v1, v1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v1
dp3_pp r1.w, r1, r2
mul_pp r0.xyz, r1, -r1.w
mad_pp r0.xyz, -r0, c15.x, -r2
mul r3.xyz, r0.w, r3
dp3_pp r0.x, r0, r3
max_pp r2.x, r0, c16.y
pow_pp r0, r2.x, c6.x
cmp_pp r0.y, -r2.w, r3.w, c16.x
mul_pp r4.xyz, r0.y, c14
mov_pp r0.w, r0.x
mul_pp r0.xyz, r4, c5
mul_pp r2.xyz, r0, r0.w
cmp_pp r0.z, r1.w, c16.y, c16.x
abs_pp r0.z, r0
cmp_pp r2.xyz, -r0.z, r2, c16.y
mul_pp r0.xy, v3, c8.x
mul_pp r0.xy, r0, c15.y
texld r0.xyz, r0, s1
mad_pp r3.xyz, r0, c15.x, c15.zzww
mul_pp r5.xyz, r2, c7.x
mov r0.x, v6.z
mov r0.y, v7.z
mov r0.z, v5
dp3_pp r2.z, r0, -r3
mov r0.x, v6.y
mov r0.z, v5.y
mov r0.y, v7
dp3_pp r2.y, -r3, r0
mov r0.x, v6
mov r0.z, v5.x
mov r0.y, v7.x
dp3_pp r2.x, -r3, r0
texld r0, v3, s0
mov_pp r3.xyz, c3
add_pp r2.w, -r0, c16.x
add_pp r3.xyz, c16.x, -r3
mad_pp r3.xyz, r2.w, r3, c3
mul_pp r0.xyz, r0, r3
dp3_pp r2.w, r2, r2
max_pp r1.w, r1, c16.y
add_pp r3.xyz, v2, c0
mad_pp_sat r3.xyz, r4, r1.w, r3
mad_pp r3.xyz, r0, r3, r5
rsq_pp r0.x, r2.w
mul_pp r0.xyz, r0.x, r2
dp3_pp r1.w, v4, v4
rsq_pp r2.x, r1.w
dp3_pp r1.w, r1, v4
mul_pp r2.xyz, r2.x, v4
mul_pp r1.xyz, r1, r1.w
dp3_pp_sat r1.w, r0, r2
mad_pp r0.xyz, -r1, c15.x, v4
mul_pp r2.y, r1.w, r1.w
pow_pp r1, r2.y, c10.x
dp3_pp r2.x, r0, v1
abs_pp_sat r1.y, r2.x
add_pp r2.x, -r1.y, c16
mov_pp r2.y, r1.x
pow_pp r1, r2.x, c13.x
mul_pp r2, r2.y, c11
mul_pp r4.x, r1, c12
mul_pp r2, r2, c9.x
mov_pp r3.w, c16.x
mad_pp r1, r0.w, r2, r3
texld r2, r0, s2
add_pp_sat r3.x, r4, c4
mul_pp r2.xyz, r2, r3.x
mad_pp r1, r2, r0.w, r1
mul_pp r2, r4.x, r2
mad_pp oC0, r2, r0.w, r1
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
# 88 ALU, 3 TEX
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
RSQ R1.x, R1.x;
ABS R0.w, R0;
MUL R0.xyz, R2.w, R0;
CMP R0.w, -R0, c[15], c[15].y;
MUL R1.xyz, R1.x, c[2];
CMP R2.xyz, -R0.w, R0, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R3, R3;
RSQ R3.w, R0.y;
MUL R3.xyz, R3.w, R3;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R1.xyz, R0.x, fragment.texcoord[1];
DP3 R1.w, R1, R2;
MUL R0.xyz, R1, -R1.w;
MAD R0.xyz, -R0, c[15].x, -R2;
DP3 R0.x, R0, R3;
SLT R0.y, R1.w, c[15].w;
MAX R0.x, R0, c[15].w;
POW R2.x, R0.x, c[6].x;
CMP R0.x, -R0.w, R2.w, c[15].y;
ABS R0.w, R0.y;
MUL R4.xyz, R0.x, c[14];
MUL R0.xyz, R4, c[5];
MUL R0.xyz, R0, R2.x;
CMP R0.w, -R0, c[15], c[15].y;
CMP R0.xyz, -R0.w, R0, c[15].w;
MUL R5.xyz, R0, c[7].x;
MUL R2.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R2, c[15].z;
TEX R0.xyz, R0, texture[1], 2D;
MOV R2.xy, c[16];
MAD R3.xyz, R0, c[15].x, R2.xxyw;
MOV R0.x, fragment.texcoord[6].z;
MOV R0.y, fragment.texcoord[7].z;
MOV R0.z, fragment.texcoord[5];
DP3 R2.z, R0, -R3;
MOV R0.x, fragment.texcoord[6].y;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.y, fragment.texcoord[7];
DP3 R2.y, -R3, R0;
MOV R0.x, fragment.texcoord[6];
MOV R0.z, fragment.texcoord[5].x;
MOV R0.y, fragment.texcoord[7].x;
DP3 R2.x, -R3, R0;
MOV R2.w, c[15].y;
TEX R0, fragment.texcoord[3], texture[0], 2D;
ADD R3.xyz, R2.w, -c[3];
ADD R2.w, -R0, c[15].y;
MAD R3.xyz, R2.w, R3, c[3];
MUL R0.xyz, R0, R3;
DP3 R2.w, R2, R2;
MAX R1.w, R1, c[15];
ADD R3.xyz, fragment.texcoord[2], c[0];
MAD_SAT R3.xyz, R4, R1.w, R3;
MAD R3.xyz, R0, R3, R5;
RSQ R0.x, R2.w;
MUL R0.xyz, R0.x, R2;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R2.x, R1.w;
DP3 R1.w, R1, fragment.texcoord[4];
MUL R1.xyz, R1, R1.w;
MUL R2.xyz, R2.x, fragment.texcoord[4];
DP3_SAT R1.w, R0, R2;
MAD R0.xyz, -R1, c[15].x, fragment.texcoord[4];
MUL R1.y, R1.w, R1.w;
DP3 R1.x, R0, fragment.texcoord[1];
ABS_SAT R2.x, R1;
POW R1.y, R1.y, c[10].x;
MUL R1, R1.y, c[11];
ADD R2.x, -R2, c[15].y;
POW R2.x, R2.x, c[13].x;
MUL R4.x, R2, c[12];
TEX R2, R0, texture[2], CUBE;
MUL R1, R1, c[9].x;
MOV R3.w, c[15].y;
MAD R1, R0.w, R1, R3;
ADD_SAT R3.x, R4, c[4];
MUL R2.xyz, R2, R3.x;
MAD R1, R2, R0.w, R1;
MUL R2, R4.x, R2;
MAD result.color, R2, R0.w, R1;
END
# 88 instructions, 6 R-regs
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
; 90 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c15, 2.00000000, 20.00000000, -1.00000000, 3.00000000
def c16, 1.00000000, 0.00000000, 0, 0
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
cmp_pp r0.w, -r0, c16.x, c16.y
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r3.w, r0
abs_pp r2.w, r0
mul_pp r1.xyz, r1.x, c2
cmp_pp r2.xyz, -r2.w, r0, r1
add r3.xyz, -v0, c1
dp3 r0.y, r3, r3
rsq r0.w, r0.y
dp3_pp r0.x, v1, v1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v1
dp3_pp r1.w, r1, r2
mul_pp r0.xyz, r1, -r1.w
mad_pp r0.xyz, -r0, c15.x, -r2
mul r3.xyz, r0.w, r3
dp3_pp r0.x, r0, r3
max_pp r2.x, r0, c16.y
pow_pp r0, r2.x, c6.x
cmp_pp r0.y, -r2.w, r3.w, c16.x
mul_pp r4.xyz, r0.y, c14
mov_pp r0.w, r0.x
mul_pp r0.xyz, r4, c5
mul_pp r2.xyz, r0, r0.w
cmp_pp r0.z, r1.w, c16.y, c16.x
abs_pp r0.z, r0
cmp_pp r2.xyz, -r0.z, r2, c16.y
mul_pp r0.xy, v3, c8.x
mul_pp r0.xy, r0, c15.y
texld r0.xyz, r0, s1
mad_pp r3.xyz, r0, c15.x, c15.zzww
mul_pp r5.xyz, r2, c7.x
mov r0.x, v6.z
mov r0.y, v7.z
mov r0.z, v5
dp3_pp r2.z, r0, -r3
mov r0.x, v6.y
mov r0.z, v5.y
mov r0.y, v7
dp3_pp r2.y, -r3, r0
mov r0.x, v6
mov r0.z, v5.x
mov r0.y, v7.x
dp3_pp r2.x, -r3, r0
texld r0, v3, s0
mov_pp r3.xyz, c3
add_pp r2.w, -r0, c16.x
add_pp r3.xyz, c16.x, -r3
mad_pp r3.xyz, r2.w, r3, c3
mul_pp r0.xyz, r0, r3
dp3_pp r2.w, r2, r2
max_pp r1.w, r1, c16.y
add_pp r3.xyz, v2, c0
mad_pp_sat r3.xyz, r4, r1.w, r3
mad_pp r3.xyz, r0, r3, r5
rsq_pp r0.x, r2.w
mul_pp r0.xyz, r0.x, r2
dp3_pp r1.w, v4, v4
rsq_pp r2.x, r1.w
dp3_pp r1.w, r1, v4
mul_pp r2.xyz, r2.x, v4
mul_pp r1.xyz, r1, r1.w
dp3_pp_sat r1.w, r0, r2
mad_pp r0.xyz, -r1, c15.x, v4
mul_pp r2.y, r1.w, r1.w
pow_pp r1, r2.y, c10.x
dp3_pp r2.x, r0, v1
abs_pp_sat r1.y, r2.x
add_pp r2.x, -r1.y, c16
mov_pp r2.y, r1.x
pow_pp r1, r2.x, c13.x
mul_pp r2, r2.y, c11
mul_pp r4.x, r1, c12
mul_pp r2, r2, c9.x
mov_pp r3.w, c16.x
mad_pp r1, r0.w, r2, r3
texld r2, r0, s2
add_pp_sat r3.x, r4, c4
mul_pp r2.xyz, r2, r3.x
mad_pp r1, r2, r0.w, r1
mul_pp r2, r4.x, r2
mad_pp oC0, r2, r0.w, r1
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
# 88 ALU, 3 TEX
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
RSQ R1.x, R1.x;
ABS R0.w, R0;
MUL R0.xyz, R2.w, R0;
CMP R0.w, -R0, c[15], c[15].y;
MUL R1.xyz, R1.x, c[2];
CMP R2.xyz, -R0.w, R0, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R3, R3;
RSQ R3.w, R0.y;
MUL R3.xyz, R3.w, R3;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R1.xyz, R0.x, fragment.texcoord[1];
DP3 R1.w, R1, R2;
MUL R0.xyz, R1, -R1.w;
MAD R0.xyz, -R0, c[15].x, -R2;
DP3 R0.x, R0, R3;
SLT R0.y, R1.w, c[15].w;
MAX R0.x, R0, c[15].w;
POW R2.x, R0.x, c[6].x;
CMP R0.x, -R0.w, R2.w, c[15].y;
ABS R0.w, R0.y;
MUL R4.xyz, R0.x, c[14];
MUL R0.xyz, R4, c[5];
MUL R0.xyz, R0, R2.x;
CMP R0.w, -R0, c[15], c[15].y;
CMP R0.xyz, -R0.w, R0, c[15].w;
MUL R5.xyz, R0, c[7].x;
MUL R2.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R2, c[15].z;
TEX R0.xyz, R0, texture[1], 2D;
MOV R2.xy, c[16];
MAD R3.xyz, R0, c[15].x, R2.xxyw;
MOV R0.x, fragment.texcoord[6].z;
MOV R0.y, fragment.texcoord[7].z;
MOV R0.z, fragment.texcoord[5];
DP3 R2.z, R0, -R3;
MOV R0.x, fragment.texcoord[6].y;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.y, fragment.texcoord[7];
DP3 R2.y, -R3, R0;
MOV R0.x, fragment.texcoord[6];
MOV R0.z, fragment.texcoord[5].x;
MOV R0.y, fragment.texcoord[7].x;
DP3 R2.x, -R3, R0;
MOV R2.w, c[15].y;
TEX R0, fragment.texcoord[3], texture[0], 2D;
ADD R3.xyz, R2.w, -c[3];
ADD R2.w, -R0, c[15].y;
MAD R3.xyz, R2.w, R3, c[3];
MUL R0.xyz, R0, R3;
DP3 R2.w, R2, R2;
MAX R1.w, R1, c[15];
ADD R3.xyz, fragment.texcoord[2], c[0];
MAD_SAT R3.xyz, R4, R1.w, R3;
MAD R3.xyz, R0, R3, R5;
RSQ R0.x, R2.w;
MUL R0.xyz, R0.x, R2;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R2.x, R1.w;
DP3 R1.w, R1, fragment.texcoord[4];
MUL R1.xyz, R1, R1.w;
MUL R2.xyz, R2.x, fragment.texcoord[4];
DP3_SAT R1.w, R0, R2;
MAD R0.xyz, -R1, c[15].x, fragment.texcoord[4];
MUL R1.y, R1.w, R1.w;
DP3 R1.x, R0, fragment.texcoord[1];
ABS_SAT R2.x, R1;
POW R1.y, R1.y, c[10].x;
MUL R1, R1.y, c[11];
ADD R2.x, -R2, c[15].y;
POW R2.x, R2.x, c[13].x;
MUL R4.x, R2, c[12];
TEX R2, R0, texture[2], CUBE;
MUL R1, R1, c[9].x;
MOV R3.w, c[15].y;
MAD R1, R0.w, R1, R3;
ADD_SAT R3.x, R4, c[4];
MUL R2.xyz, R2, R3.x;
MAD R1, R2, R0.w, R1;
MUL R2, R4.x, R2;
MAD result.color, R2, R0.w, R1;
END
# 88 instructions, 6 R-regs
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
; 90 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c15, 2.00000000, 20.00000000, -1.00000000, 3.00000000
def c16, 1.00000000, 0.00000000, 0, 0
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
cmp_pp r0.w, -r0, c16.x, c16.y
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r3.w, r0
abs_pp r2.w, r0
mul_pp r1.xyz, r1.x, c2
cmp_pp r2.xyz, -r2.w, r0, r1
add r3.xyz, -v0, c1
dp3 r0.y, r3, r3
rsq r0.w, r0.y
dp3_pp r0.x, v1, v1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v1
dp3_pp r1.w, r1, r2
mul_pp r0.xyz, r1, -r1.w
mad_pp r0.xyz, -r0, c15.x, -r2
mul r3.xyz, r0.w, r3
dp3_pp r0.x, r0, r3
max_pp r2.x, r0, c16.y
pow_pp r0, r2.x, c6.x
cmp_pp r0.y, -r2.w, r3.w, c16.x
mul_pp r4.xyz, r0.y, c14
mov_pp r0.w, r0.x
mul_pp r0.xyz, r4, c5
mul_pp r2.xyz, r0, r0.w
cmp_pp r0.z, r1.w, c16.y, c16.x
abs_pp r0.z, r0
cmp_pp r2.xyz, -r0.z, r2, c16.y
mul_pp r0.xy, v3, c8.x
mul_pp r0.xy, r0, c15.y
texld r0.xyz, r0, s1
mad_pp r3.xyz, r0, c15.x, c15.zzww
mul_pp r5.xyz, r2, c7.x
mov r0.x, v6.z
mov r0.y, v7.z
mov r0.z, v5
dp3_pp r2.z, r0, -r3
mov r0.x, v6.y
mov r0.z, v5.y
mov r0.y, v7
dp3_pp r2.y, -r3, r0
mov r0.x, v6
mov r0.z, v5.x
mov r0.y, v7.x
dp3_pp r2.x, -r3, r0
texld r0, v3, s0
mov_pp r3.xyz, c3
add_pp r2.w, -r0, c16.x
add_pp r3.xyz, c16.x, -r3
mad_pp r3.xyz, r2.w, r3, c3
mul_pp r0.xyz, r0, r3
dp3_pp r2.w, r2, r2
max_pp r1.w, r1, c16.y
add_pp r3.xyz, v2, c0
mad_pp_sat r3.xyz, r4, r1.w, r3
mad_pp r3.xyz, r0, r3, r5
rsq_pp r0.x, r2.w
mul_pp r0.xyz, r0.x, r2
dp3_pp r1.w, v4, v4
rsq_pp r2.x, r1.w
dp3_pp r1.w, r1, v4
mul_pp r2.xyz, r2.x, v4
mul_pp r1.xyz, r1, r1.w
dp3_pp_sat r1.w, r0, r2
mad_pp r0.xyz, -r1, c15.x, v4
mul_pp r2.y, r1.w, r1.w
pow_pp r1, r2.y, c10.x
dp3_pp r2.x, r0, v1
abs_pp_sat r1.y, r2.x
add_pp r2.x, -r1.y, c16
mov_pp r2.y, r1.x
pow_pp r1, r2.x, c13.x
mul_pp r2, r2.y, c11
mul_pp r4.x, r1, c12
mul_pp r2, r2, c9.x
mov_pp r3.w, c16.x
mad_pp r1, r0.w, r2, r3
texld r2, r0, s2
add_pp_sat r3.x, r4, c4
mul_pp r2.xyz, r2, r3.x
mad_pp r1, r2, r0.w, r1
mul_pp r2, r4.x, r2
mad_pp oC0, r2, r0.w, r1
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
# 88 ALU, 3 TEX
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
RSQ R1.x, R1.x;
ABS R0.w, R0;
MUL R0.xyz, R2.w, R0;
CMP R0.w, -R0, c[15], c[15].y;
MUL R1.xyz, R1.x, c[2];
CMP R2.xyz, -R0.w, R0, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R3, R3;
RSQ R3.w, R0.y;
MUL R3.xyz, R3.w, R3;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R1.xyz, R0.x, fragment.texcoord[1];
DP3 R1.w, R1, R2;
MUL R0.xyz, R1, -R1.w;
MAD R0.xyz, -R0, c[15].x, -R2;
DP3 R0.x, R0, R3;
SLT R0.y, R1.w, c[15].w;
MAX R0.x, R0, c[15].w;
POW R2.x, R0.x, c[6].x;
CMP R0.x, -R0.w, R2.w, c[15].y;
ABS R0.w, R0.y;
MUL R4.xyz, R0.x, c[14];
MUL R0.xyz, R4, c[5];
MUL R0.xyz, R0, R2.x;
CMP R0.w, -R0, c[15], c[15].y;
CMP R0.xyz, -R0.w, R0, c[15].w;
MUL R5.xyz, R0, c[7].x;
MUL R2.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R2, c[15].z;
TEX R0.xyz, R0, texture[1], 2D;
MOV R2.xy, c[16];
MAD R3.xyz, R0, c[15].x, R2.xxyw;
MOV R0.x, fragment.texcoord[6].z;
MOV R0.y, fragment.texcoord[7].z;
MOV R0.z, fragment.texcoord[5];
DP3 R2.z, R0, -R3;
MOV R0.x, fragment.texcoord[6].y;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.y, fragment.texcoord[7];
DP3 R2.y, -R3, R0;
MOV R0.x, fragment.texcoord[6];
MOV R0.z, fragment.texcoord[5].x;
MOV R0.y, fragment.texcoord[7].x;
DP3 R2.x, -R3, R0;
MOV R2.w, c[15].y;
TEX R0, fragment.texcoord[3], texture[0], 2D;
ADD R3.xyz, R2.w, -c[3];
ADD R2.w, -R0, c[15].y;
MAD R3.xyz, R2.w, R3, c[3];
MUL R0.xyz, R0, R3;
DP3 R2.w, R2, R2;
MAX R1.w, R1, c[15];
ADD R3.xyz, fragment.texcoord[2], c[0];
MAD_SAT R3.xyz, R4, R1.w, R3;
MAD R3.xyz, R0, R3, R5;
RSQ R0.x, R2.w;
MUL R0.xyz, R0.x, R2;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R2.x, R1.w;
DP3 R1.w, R1, fragment.texcoord[4];
MUL R1.xyz, R1, R1.w;
MUL R2.xyz, R2.x, fragment.texcoord[4];
DP3_SAT R1.w, R0, R2;
MAD R0.xyz, -R1, c[15].x, fragment.texcoord[4];
MUL R1.y, R1.w, R1.w;
DP3 R1.x, R0, fragment.texcoord[1];
ABS_SAT R2.x, R1;
POW R1.y, R1.y, c[10].x;
MUL R1, R1.y, c[11];
ADD R2.x, -R2, c[15].y;
POW R2.x, R2.x, c[13].x;
MUL R4.x, R2, c[12];
TEX R2, R0, texture[2], CUBE;
MUL R1, R1, c[9].x;
MOV R3.w, c[15].y;
MAD R1, R0.w, R1, R3;
ADD_SAT R3.x, R4, c[4];
MUL R2.xyz, R2, R3.x;
MAD R1, R2, R0.w, R1;
MUL R2, R4.x, R2;
MAD result.color, R2, R0.w, R1;
END
# 88 instructions, 6 R-regs
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
; 90 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c15, 2.00000000, 20.00000000, -1.00000000, 3.00000000
def c16, 1.00000000, 0.00000000, 0, 0
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
cmp_pp r0.w, -r0, c16.x, c16.y
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r3.w, r0
abs_pp r2.w, r0
mul_pp r1.xyz, r1.x, c2
cmp_pp r2.xyz, -r2.w, r0, r1
add r3.xyz, -v0, c1
dp3 r0.y, r3, r3
rsq r0.w, r0.y
dp3_pp r0.x, v1, v1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v1
dp3_pp r1.w, r1, r2
mul_pp r0.xyz, r1, -r1.w
mad_pp r0.xyz, -r0, c15.x, -r2
mul r3.xyz, r0.w, r3
dp3_pp r0.x, r0, r3
max_pp r2.x, r0, c16.y
pow_pp r0, r2.x, c6.x
cmp_pp r0.y, -r2.w, r3.w, c16.x
mul_pp r4.xyz, r0.y, c14
mov_pp r0.w, r0.x
mul_pp r0.xyz, r4, c5
mul_pp r2.xyz, r0, r0.w
cmp_pp r0.z, r1.w, c16.y, c16.x
abs_pp r0.z, r0
cmp_pp r2.xyz, -r0.z, r2, c16.y
mul_pp r0.xy, v3, c8.x
mul_pp r0.xy, r0, c15.y
texld r0.xyz, r0, s1
mad_pp r3.xyz, r0, c15.x, c15.zzww
mul_pp r5.xyz, r2, c7.x
mov r0.x, v6.z
mov r0.y, v7.z
mov r0.z, v5
dp3_pp r2.z, r0, -r3
mov r0.x, v6.y
mov r0.z, v5.y
mov r0.y, v7
dp3_pp r2.y, -r3, r0
mov r0.x, v6
mov r0.z, v5.x
mov r0.y, v7.x
dp3_pp r2.x, -r3, r0
texld r0, v3, s0
mov_pp r3.xyz, c3
add_pp r2.w, -r0, c16.x
add_pp r3.xyz, c16.x, -r3
mad_pp r3.xyz, r2.w, r3, c3
mul_pp r0.xyz, r0, r3
dp3_pp r2.w, r2, r2
max_pp r1.w, r1, c16.y
add_pp r3.xyz, v2, c0
mad_pp_sat r3.xyz, r4, r1.w, r3
mad_pp r3.xyz, r0, r3, r5
rsq_pp r0.x, r2.w
mul_pp r0.xyz, r0.x, r2
dp3_pp r1.w, v4, v4
rsq_pp r2.x, r1.w
dp3_pp r1.w, r1, v4
mul_pp r2.xyz, r2.x, v4
mul_pp r1.xyz, r1, r1.w
dp3_pp_sat r1.w, r0, r2
mad_pp r0.xyz, -r1, c15.x, v4
mul_pp r2.y, r1.w, r1.w
pow_pp r1, r2.y, c10.x
dp3_pp r2.x, r0, v1
abs_pp_sat r1.y, r2.x
add_pp r2.x, -r1.y, c16
mov_pp r2.y, r1.x
pow_pp r1, r2.x, c13.x
mul_pp r2, r2.y, c11
mul_pp r4.x, r1, c12
mul_pp r2, r2, c9.x
mov_pp r3.w, c16.x
mad_pp r1, r0.w, r2, r3
texld r2, r0, s2
add_pp_sat r3.x, r4, c4
mul_pp r2.xyz, r2, r3.x
mad_pp r1, r2, r0.w, r1
mul_pp r2, r4.x, r2
mad_pp oC0, r2, r0.w, r1
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
# 88 ALU, 3 TEX
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
RSQ R1.x, R1.x;
ABS R0.w, R0;
MUL R0.xyz, R2.w, R0;
CMP R0.w, -R0, c[15], c[15].y;
MUL R1.xyz, R1.x, c[2];
CMP R2.xyz, -R0.w, R0, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R3, R3;
RSQ R3.w, R0.y;
MUL R3.xyz, R3.w, R3;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R1.xyz, R0.x, fragment.texcoord[1];
DP3 R1.w, R1, R2;
MUL R0.xyz, R1, -R1.w;
MAD R0.xyz, -R0, c[15].x, -R2;
DP3 R0.x, R0, R3;
SLT R0.y, R1.w, c[15].w;
MAX R0.x, R0, c[15].w;
POW R2.x, R0.x, c[6].x;
CMP R0.x, -R0.w, R2.w, c[15].y;
ABS R0.w, R0.y;
MUL R4.xyz, R0.x, c[14];
MUL R0.xyz, R4, c[5];
MUL R0.xyz, R0, R2.x;
CMP R0.w, -R0, c[15], c[15].y;
CMP R0.xyz, -R0.w, R0, c[15].w;
MUL R5.xyz, R0, c[7].x;
MUL R2.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R2, c[15].z;
TEX R0.xyz, R0, texture[1], 2D;
MOV R2.xy, c[16];
MAD R3.xyz, R0, c[15].x, R2.xxyw;
MOV R0.x, fragment.texcoord[6].z;
MOV R0.y, fragment.texcoord[7].z;
MOV R0.z, fragment.texcoord[5];
DP3 R2.z, R0, -R3;
MOV R0.x, fragment.texcoord[6].y;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.y, fragment.texcoord[7];
DP3 R2.y, -R3, R0;
MOV R0.x, fragment.texcoord[6];
MOV R0.z, fragment.texcoord[5].x;
MOV R0.y, fragment.texcoord[7].x;
DP3 R2.x, -R3, R0;
MOV R2.w, c[15].y;
TEX R0, fragment.texcoord[3], texture[0], 2D;
ADD R3.xyz, R2.w, -c[3];
ADD R2.w, -R0, c[15].y;
MAD R3.xyz, R2.w, R3, c[3];
MUL R0.xyz, R0, R3;
DP3 R2.w, R2, R2;
MAX R1.w, R1, c[15];
ADD R3.xyz, fragment.texcoord[2], c[0];
MAD_SAT R3.xyz, R4, R1.w, R3;
MAD R3.xyz, R0, R3, R5;
RSQ R0.x, R2.w;
MUL R0.xyz, R0.x, R2;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R2.x, R1.w;
DP3 R1.w, R1, fragment.texcoord[4];
MUL R1.xyz, R1, R1.w;
MUL R2.xyz, R2.x, fragment.texcoord[4];
DP3_SAT R1.w, R0, R2;
MAD R0.xyz, -R1, c[15].x, fragment.texcoord[4];
MUL R1.y, R1.w, R1.w;
DP3 R1.x, R0, fragment.texcoord[1];
ABS_SAT R2.x, R1;
POW R1.y, R1.y, c[10].x;
MUL R1, R1.y, c[11];
ADD R2.x, -R2, c[15].y;
POW R2.x, R2.x, c[13].x;
MUL R4.x, R2, c[12];
TEX R2, R0, texture[2], CUBE;
MUL R1, R1, c[9].x;
MOV R3.w, c[15].y;
MAD R1, R0.w, R1, R3;
ADD_SAT R3.x, R4, c[4];
MUL R2.xyz, R2, R3.x;
MAD R1, R2, R0.w, R1;
MUL R2, R4.x, R2;
MAD result.color, R2, R0.w, R1;
END
# 88 instructions, 6 R-regs
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
; 90 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c15, 2.00000000, 20.00000000, -1.00000000, 3.00000000
def c16, 1.00000000, 0.00000000, 0, 0
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
cmp_pp r0.w, -r0, c16.x, c16.y
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r3.w, r0
abs_pp r2.w, r0
mul_pp r1.xyz, r1.x, c2
cmp_pp r2.xyz, -r2.w, r0, r1
add r3.xyz, -v0, c1
dp3 r0.y, r3, r3
rsq r0.w, r0.y
dp3_pp r0.x, v1, v1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v1
dp3_pp r1.w, r1, r2
mul_pp r0.xyz, r1, -r1.w
mad_pp r0.xyz, -r0, c15.x, -r2
mul r3.xyz, r0.w, r3
dp3_pp r0.x, r0, r3
max_pp r2.x, r0, c16.y
pow_pp r0, r2.x, c6.x
cmp_pp r0.y, -r2.w, r3.w, c16.x
mul_pp r4.xyz, r0.y, c14
mov_pp r0.w, r0.x
mul_pp r0.xyz, r4, c5
mul_pp r2.xyz, r0, r0.w
cmp_pp r0.z, r1.w, c16.y, c16.x
abs_pp r0.z, r0
cmp_pp r2.xyz, -r0.z, r2, c16.y
mul_pp r0.xy, v3, c8.x
mul_pp r0.xy, r0, c15.y
texld r0.xyz, r0, s1
mad_pp r3.xyz, r0, c15.x, c15.zzww
mul_pp r5.xyz, r2, c7.x
mov r0.x, v6.z
mov r0.y, v7.z
mov r0.z, v5
dp3_pp r2.z, r0, -r3
mov r0.x, v6.y
mov r0.z, v5.y
mov r0.y, v7
dp3_pp r2.y, -r3, r0
mov r0.x, v6
mov r0.z, v5.x
mov r0.y, v7.x
dp3_pp r2.x, -r3, r0
texld r0, v3, s0
mov_pp r3.xyz, c3
add_pp r2.w, -r0, c16.x
add_pp r3.xyz, c16.x, -r3
mad_pp r3.xyz, r2.w, r3, c3
mul_pp r0.xyz, r0, r3
dp3_pp r2.w, r2, r2
max_pp r1.w, r1, c16.y
add_pp r3.xyz, v2, c0
mad_pp_sat r3.xyz, r4, r1.w, r3
mad_pp r3.xyz, r0, r3, r5
rsq_pp r0.x, r2.w
mul_pp r0.xyz, r0.x, r2
dp3_pp r1.w, v4, v4
rsq_pp r2.x, r1.w
dp3_pp r1.w, r1, v4
mul_pp r2.xyz, r2.x, v4
mul_pp r1.xyz, r1, r1.w
dp3_pp_sat r1.w, r0, r2
mad_pp r0.xyz, -r1, c15.x, v4
mul_pp r2.y, r1.w, r1.w
pow_pp r1, r2.y, c10.x
dp3_pp r2.x, r0, v1
abs_pp_sat r1.y, r2.x
add_pp r2.x, -r1.y, c16
mov_pp r2.y, r1.x
pow_pp r1, r2.x, c13.x
mul_pp r2, r2.y, c11
mul_pp r4.x, r1, c12
mul_pp r2, r2, c9.x
mov_pp r3.w, c16.x
mad_pp r1, r0.w, r2, r3
texld r2, r0, s2
add_pp_sat r3.x, r4, c4
mul_pp r2.xyz, r2, r3.x
mad_pp r1, r2, r0.w, r1
mul_pp r2, r4.x, r2
mad_pp oC0, r2, r0.w, r1
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
# 88 ALU, 3 TEX
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
RSQ R1.x, R1.x;
ABS R0.w, R0;
MUL R0.xyz, R2.w, R0;
CMP R0.w, -R0, c[15], c[15].y;
MUL R1.xyz, R1.x, c[2];
CMP R2.xyz, -R0.w, R0, R1;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R3, R3;
RSQ R3.w, R0.y;
MUL R3.xyz, R3.w, R3;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R1.xyz, R0.x, fragment.texcoord[1];
DP3 R1.w, R1, R2;
MUL R0.xyz, R1, -R1.w;
MAD R0.xyz, -R0, c[15].x, -R2;
DP3 R0.x, R0, R3;
SLT R0.y, R1.w, c[15].w;
MAX R0.x, R0, c[15].w;
POW R2.x, R0.x, c[6].x;
CMP R0.x, -R0.w, R2.w, c[15].y;
ABS R0.w, R0.y;
MUL R4.xyz, R0.x, c[14];
MUL R0.xyz, R4, c[5];
MUL R0.xyz, R0, R2.x;
CMP R0.w, -R0, c[15], c[15].y;
CMP R0.xyz, -R0.w, R0, c[15].w;
MUL R5.xyz, R0, c[7].x;
MUL R2.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R2, c[15].z;
TEX R0.xyz, R0, texture[1], 2D;
MOV R2.xy, c[16];
MAD R3.xyz, R0, c[15].x, R2.xxyw;
MOV R0.x, fragment.texcoord[6].z;
MOV R0.y, fragment.texcoord[7].z;
MOV R0.z, fragment.texcoord[5];
DP3 R2.z, R0, -R3;
MOV R0.x, fragment.texcoord[6].y;
MOV R0.z, fragment.texcoord[5].y;
MOV R0.y, fragment.texcoord[7];
DP3 R2.y, -R3, R0;
MOV R0.x, fragment.texcoord[6];
MOV R0.z, fragment.texcoord[5].x;
MOV R0.y, fragment.texcoord[7].x;
DP3 R2.x, -R3, R0;
MOV R2.w, c[15].y;
TEX R0, fragment.texcoord[3], texture[0], 2D;
ADD R3.xyz, R2.w, -c[3];
ADD R2.w, -R0, c[15].y;
MAD R3.xyz, R2.w, R3, c[3];
MUL R0.xyz, R0, R3;
DP3 R2.w, R2, R2;
MAX R1.w, R1, c[15];
ADD R3.xyz, fragment.texcoord[2], c[0];
MAD_SAT R3.xyz, R4, R1.w, R3;
MAD R3.xyz, R0, R3, R5;
RSQ R0.x, R2.w;
MUL R0.xyz, R0.x, R2;
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R2.x, R1.w;
DP3 R1.w, R1, fragment.texcoord[4];
MUL R1.xyz, R1, R1.w;
MUL R2.xyz, R2.x, fragment.texcoord[4];
DP3_SAT R1.w, R0, R2;
MAD R0.xyz, -R1, c[15].x, fragment.texcoord[4];
MUL R1.y, R1.w, R1.w;
DP3 R1.x, R0, fragment.texcoord[1];
ABS_SAT R2.x, R1;
POW R1.y, R1.y, c[10].x;
MUL R1, R1.y, c[11];
ADD R2.x, -R2, c[15].y;
POW R2.x, R2.x, c[13].x;
MUL R4.x, R2, c[12];
TEX R2, R0, texture[2], CUBE;
MUL R1, R1, c[9].x;
MOV R3.w, c[15].y;
MAD R1, R0.w, R1, R3;
ADD_SAT R3.x, R4, c[4];
MUL R2.xyz, R2, R3.x;
MAD R1, R2, R0.w, R1;
MUL R2, R4.x, R2;
MAD result.color, R2, R0.w, R1;
END
# 88 instructions, 6 R-regs
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
; 90 ALU, 3 TEX
dcl_2d s0
dcl_2d s1
dcl_cube s2
def c15, 2.00000000, 20.00000000, -1.00000000, 3.00000000
def c16, 1.00000000, 0.00000000, 0, 0
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
cmp_pp r0.w, -r0, c16.x, c16.y
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r3.w, r0
abs_pp r2.w, r0
mul_pp r1.xyz, r1.x, c2
cmp_pp r2.xyz, -r2.w, r0, r1
add r3.xyz, -v0, c1
dp3 r0.y, r3, r3
rsq r0.w, r0.y
dp3_pp r0.x, v1, v1
rsq_pp r0.x, r0.x
mul_pp r1.xyz, r0.x, v1
dp3_pp r1.w, r1, r2
mul_pp r0.xyz, r1, -r1.w
mad_pp r0.xyz, -r0, c15.x, -r2
mul r3.xyz, r0.w, r3
dp3_pp r0.x, r0, r3
max_pp r2.x, r0, c16.y
pow_pp r0, r2.x, c6.x
cmp_pp r0.y, -r2.w, r3.w, c16.x
mul_pp r4.xyz, r0.y, c14
mov_pp r0.w, r0.x
mul_pp r0.xyz, r4, c5
mul_pp r2.xyz, r0, r0.w
cmp_pp r0.z, r1.w, c16.y, c16.x
abs_pp r0.z, r0
cmp_pp r2.xyz, -r0.z, r2, c16.y
mul_pp r0.xy, v3, c8.x
mul_pp r0.xy, r0, c15.y
texld r0.xyz, r0, s1
mad_pp r3.xyz, r0, c15.x, c15.zzww
mul_pp r5.xyz, r2, c7.x
mov r0.x, v6.z
mov r0.y, v7.z
mov r0.z, v5
dp3_pp r2.z, r0, -r3
mov r0.x, v6.y
mov r0.z, v5.y
mov r0.y, v7
dp3_pp r2.y, -r3, r0
mov r0.x, v6
mov r0.z, v5.x
mov r0.y, v7.x
dp3_pp r2.x, -r3, r0
texld r0, v3, s0
mov_pp r3.xyz, c3
add_pp r2.w, -r0, c16.x
add_pp r3.xyz, c16.x, -r3
mad_pp r3.xyz, r2.w, r3, c3
mul_pp r0.xyz, r0, r3
dp3_pp r2.w, r2, r2
max_pp r1.w, r1, c16.y
add_pp r3.xyz, v2, c0
mad_pp_sat r3.xyz, r4, r1.w, r3
mad_pp r3.xyz, r0, r3, r5
rsq_pp r0.x, r2.w
mul_pp r0.xyz, r0.x, r2
dp3_pp r1.w, v4, v4
rsq_pp r2.x, r1.w
dp3_pp r1.w, r1, v4
mul_pp r2.xyz, r2.x, v4
mul_pp r1.xyz, r1, r1.w
dp3_pp_sat r1.w, r0, r2
mad_pp r0.xyz, -r1, c15.x, v4
mul_pp r2.y, r1.w, r1.w
pow_pp r1, r2.y, c10.x
dp3_pp r2.x, r0, v1
abs_pp_sat r1.y, r2.x
add_pp r2.x, -r1.y, c16
mov_pp r2.y, r1.x
pow_pp r1, r2.x, c13.x
mul_pp r2, r2.y, c11
mul_pp r4.x, r1, c12
mul_pp r2, r2, c9.x
mov_pp r3.w, c16.x
mad_pp r1, r0.w, r2, r3
texld r2, r0, s2
add_pp_sat r3.x, r4, c4
mul_pp r2.xyz, r2, r3.x
mad_pp r1, r2, r0.w, r1
mul_pp r2, r4.x, r2
mad_pp oC0, r2, r0.w, r1
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
   Fallback "Mobile/Diffuse"
}