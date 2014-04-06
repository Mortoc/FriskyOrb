Shader "RedDotGames/Mobile/Car Paint High Detal Decal" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _Shininess ("Shininess", Range (0.01, 10)) = 1
	  _Gloss ("Gloss", Range (0.0, 10)) = 1
	  _MainTex ("Diffuse Texture", 2D) = "white" {} 
      _DecalMap ("Decal map", 2D) = "white" {}
      _decalPower ("Decal Power", Range (0.0, 1.0)) = 0.5	  
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
//   opengl - ALU: 39 to 69
//   d3d9 - ALU: 39 to 69
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
Vector 20 [_Color]
"3.0-!!ARBvp1.0
# 69 ALU
PARAM c[21] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R0.xyz, R1, c[0].x;
DP3 R1.w, R0, R0;
RSQ R2.w, R1.w;
MUL R0.xyz, R2.w, R0;
DP4 R1.z, vertex.position, c[7];
DP4 R1.y, vertex.position, c[6];
DP4 R1.x, vertex.position, c[5];
MOV R3.x, c[14].y;
MOV R3.z, c[16].y;
MOV R3.y, c[15];
ADD R4.xyz, -R1, R3;
MUL R3.xyz, R0.zxyw, R2.yzxw;
DP3 R0.w, R4, R4;
RSQ R1.w, R0.w;
MUL R4.xyz, R1.w, R4;
DP3 R2.w, R0, R4;
MUL R0.w, R0, c[17].y;
ADD R1.w, R0, c[0].y;
MAD result.texcoord[7].xyz, R0.yzxw, R2.zxyw, -R3;
MOV result.texcoord[6].xyz, R2;
MAX R0.w, R2, c[0].x;
RCP R1.w, R1.w;
MOV R4.x, c[14];
MOV R4.z, c[16].x;
MOV R4.y, c[15].x;
ADD R5.xyz, -R1, R4;
MUL R4.xyz, R1.w, c[19];
MUL R4.xyz, R4, c[20];
DP3 R1.w, R5, R5;
MUL R4.xyz, R4, R0.w;
MUL R0.w, R1, c[17].x;
RSQ R1.w, R1.w;
MUL R5.xyz, R1.w, R5;
ADD R0.w, R0, c[0].y;
DP3 R1.w, R0, R5;
RCP R0.w, R0.w;
MUL R5.xyz, R0.w, c[18];
MAX R0.w, R1, c[0].x;
MUL R5.xyz, R5, c[20];
MUL R5.xyz, R5, R0.w;
ADD R2.xyz, R1, -c[13];
DP4 R1.w, vertex.position, c[8];
DP3 R0.w, R2, R2;
MOV result.texcoord[1].xyz, R0;
RSQ R0.x, R0.w;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
ADD result.texcoord[2].xyz, R5, R4;
MOV result.texcoord[0], R1;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 69 instructions, 6 R-regs
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
Vector 19 [_Color]
"vs_3_0
; 69 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c20, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c20.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r0.xyz, r1, c20.x
dp3 r1.w, r0, r0
rsq r2.w, r1.w
mul r0.xyz, r2.w, r0
dp4 r1.z, v0, c6
dp4 r1.y, v0, c5
dp4 r1.x, v0, c4
mov r3.x, c13.y
mov r3.z, c15.y
mov r3.y, c14
add r4.xyz, -r1, r3
mul r3.xyz, r0.zxyw, r2.yzxw
dp3 r0.w, r4, r4
rsq r1.w, r0.w
mul r4.xyz, r1.w, r4
dp3 r2.w, r0, r4
mul r0.w, r0, c16.y
add r1.w, r0, c20.y
mad o8.xyz, r0.yzxw, r2.zxyw, -r3
mov o7.xyz, r2
max r0.w, r2, c20.x
rcp r1.w, r1.w
mov r4.x, c13
mov r4.z, c15.x
mov r4.y, c14.x
add r5.xyz, -r1, r4
mul r4.xyz, r1.w, c18
mul r4.xyz, r4, c19
dp3 r1.w, r5, r5
mul r4.xyz, r4, r0.w
mul r0.w, r1, c16.x
rsq r1.w, r1.w
mul r5.xyz, r1.w, r5
add r0.w, r0, c20.y
dp3 r1.w, r0, r5
rcp r0.w, r0.w
mul r5.xyz, r0.w, c17
max r0.w, r1, c20.x
mul r5.xyz, r5, c19
mul r5.xyz, r5, r0.w
add r2.xyz, r1, -c12
dp4 r1.w, v0, c7
dp3 r0.w, r2, r2
mov o2.xyz, r0
rsq r0.x, r0.w
mul o5.xyz, r0.x, r2
mov r0.w, c20.x
mov r0.xyz, v1
add o3.xyz, r5, r4
mov o1, r1
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
Vector 20 [_Color]
"3.0-!!ARBvp1.0
# 69 ALU
PARAM c[21] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..20] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.y, R1, c[6];
DP4 R0.x, R1, c[5];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R0.xyz, R1, c[0].x;
DP3 R1.w, R0, R0;
RSQ R2.w, R1.w;
MUL R0.xyz, R2.w, R0;
DP4 R1.z, vertex.position, c[7];
DP4 R1.y, vertex.position, c[6];
DP4 R1.x, vertex.position, c[5];
MOV R3.x, c[14].y;
MOV R3.z, c[16].y;
MOV R3.y, c[15];
ADD R4.xyz, -R1, R3;
MUL R3.xyz, R0.zxyw, R2.yzxw;
DP3 R0.w, R4, R4;
RSQ R1.w, R0.w;
MUL R4.xyz, R1.w, R4;
DP3 R2.w, R0, R4;
MUL R0.w, R0, c[17].y;
ADD R1.w, R0, c[0].y;
MAD result.texcoord[7].xyz, R0.yzxw, R2.zxyw, -R3;
MOV result.texcoord[6].xyz, R2;
MAX R0.w, R2, c[0].x;
RCP R1.w, R1.w;
MOV R4.x, c[14];
MOV R4.z, c[16].x;
MOV R4.y, c[15].x;
ADD R5.xyz, -R1, R4;
MUL R4.xyz, R1.w, c[19];
MUL R4.xyz, R4, c[20];
DP3 R1.w, R5, R5;
MUL R4.xyz, R4, R0.w;
MUL R0.w, R1, c[17].x;
RSQ R1.w, R1.w;
MUL R5.xyz, R1.w, R5;
ADD R0.w, R0, c[0].y;
DP3 R1.w, R0, R5;
RCP R0.w, R0.w;
MUL R5.xyz, R0.w, c[18];
MAX R0.w, R1, c[0].x;
MUL R5.xyz, R5, c[20];
MUL R5.xyz, R5, R0.w;
ADD R2.xyz, R1, -c[13];
DP4 R1.w, vertex.position, c[8];
DP3 R0.w, R2, R2;
MOV result.texcoord[1].xyz, R0;
RSQ R0.x, R0.w;
MUL result.texcoord[4].xyz, R0.x, R2;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
ADD result.texcoord[2].xyz, R5, R4;
MOV result.texcoord[0], R1;
MOV result.texcoord[3], vertex.texcoord[0];
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 69 instructions, 6 R-regs
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
Vector 19 [_Color]
"vs_3_0
; 69 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c20, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_tangent0 v3
mov r1.w, c20.x
mov r1.xyz, v3
dp4 r0.z, r1, c6
dp4 r0.y, r1, c5
dp4 r0.x, r1, c4
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul r2.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r0.xyz, r1, c20.x
dp3 r1.w, r0, r0
rsq r2.w, r1.w
mul r0.xyz, r2.w, r0
dp4 r1.z, v0, c6
dp4 r1.y, v0, c5
dp4 r1.x, v0, c4
mov r3.x, c13.y
mov r3.z, c15.y
mov r3.y, c14
add r4.xyz, -r1, r3
mul r3.xyz, r0.zxyw, r2.yzxw
dp3 r0.w, r4, r4
rsq r1.w, r0.w
mul r4.xyz, r1.w, r4
dp3 r2.w, r0, r4
mul r0.w, r0, c16.y
add r1.w, r0, c20.y
mad o8.xyz, r0.yzxw, r2.zxyw, -r3
mov o7.xyz, r2
max r0.w, r2, c20.x
rcp r1.w, r1.w
mov r4.x, c13
mov r4.z, c15.x
mov r4.y, c14.x
add r5.xyz, -r1, r4
mul r4.xyz, r1.w, c18
mul r4.xyz, r4, c19
dp3 r1.w, r5, r5
mul r4.xyz, r4, r0.w
mul r0.w, r1, c16.x
rsq r1.w, r1.w
mul r5.xyz, r1.w, r5
add r0.w, r0, c20.y
dp3 r1.w, r0, r5
rcp r0.w, r0.w
mul r5.xyz, r0.w, c17
max r0.w, r1, c20.x
mul r5.xyz, r5, c19
mul r5.xyz, r5, r0.w
add r2.xyz, r1, -c12
dp4 r1.w, v0, c7
dp3 r0.w, r2, r2
mov o2.xyz, r0
rsq r0.x, r0.w
mul o5.xyz, r0.x, r2
mov r0.w, c20.x
mov r0.xyz, v1
add o3.xyz, r5, r4
mov o1, r1
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
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
uniform lowp float _decalPower;
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
uniform sampler2D _DecalMap;
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
  highp vec4 detail;
  lowp vec4 textureColor;
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
  textureColor = tmpvar_4;
  mediump vec2 tmpvar_5;
  tmpvar_5 = xlv_TEXCOORD3.xy;
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2D (_DecalMap, tmpvar_5);
  detail = tmpvar_6;
  highp vec3 tmpvar_7;
  tmpvar_7 = mix (tmpvar_4.xyz, detail.xyz, vec3((detail.w * _decalPower)));
  textureColor.xyz = tmpvar_7;
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    attenuation = 1.0;
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_8;
    tmpvar_8 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_8;
    attenuation = (1.0/(length (vertexToLightSource)));
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_9;
  tmpvar_9 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_9;
  lowp vec3 tmpvar_10;
  tmpvar_10 = (((attenuation * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_1, lightDirection)));
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_1, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, dot (reflect (-(lightDirection), tmpvar_1), viewDirection));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((attenuation * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = xlv_TEXCOORD7;
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
  lowp vec3 tmpvar_21;
  tmpvar_21 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_22;
  tmpvar_22 = textureCube (_Cube, tmpvar_21);
  reflTex = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = clamp (abs (dot (tmpvar_21, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = pow ((1.0 - tmpvar_23), _FrezFalloff);
  frez = tmpvar_24;
  lowp float tmpvar_25;
  tmpvar_25 = (frez * _FrezPow);
  frez = tmpvar_25;
  reflTex.xyz = (tmpvar_22.xyz * clamp ((_Reflection + tmpvar_25), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((textureColor.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_10), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (paintColor * _FlakePower));
  color = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = ((color + reflTex) + (tmpvar_25 * reflTex));
  color = tmpvar_28;
  gl_FragData[0] = tmpvar_28;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 87 to 87, TEX: 4 to 4
//   d3d9 - ALU: 89 to 89, TEX: 4 to 4
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
Float 11 [_decalPower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 87 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
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
CMP R0.w, -R0, c[16], c[16].y;
RSQ R1.x, R1.x;
ABS R0.w, R0;
MUL R0.xyz, R2.w, R0;
CMP R0.w, -R0, c[16], c[16].y;
MUL R1.xyz, R1.x, c[2];
CMP R1.xyz, -R0.w, R0, R1;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R3.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R3.xyz, R0.x, fragment.texcoord[1];
DP3 R1.w, R3, R1;
MUL R0.xyz, R3, -R1.w;
MAD R0.xyz, -R0, c[16].x, -R1;
MUL R2.xyz, R3.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[16].w;
POW R1.x, R0.x, c[6].x;
CMP R0.x, -R0.w, R2.w, c[16].y;
SLT R0.y, R1.w, c[16].w;
ABS R0.w, R0.y;
MUL R4.xyz, R0.x, c[15];
MUL R0.xyz, R4, c[5];
MUL R0.xyz, R0, R1.x;
CMP R0.w, -R0, c[16], c[16].y;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[16].z;
TEX R1.xyz, R1, texture[2], 2D;
MOV R2.xy, c[17];
MAD R5.xyz, R1, c[16].x, R2.xxyw;
CMP R0.xyz, -R0.w, R0, c[16].w;
MOV R1.x, fragment.texcoord[6].z;
MOV R1.y, fragment.texcoord[7].z;
MOV R1.z, fragment.texcoord[5];
DP3 R2.z, R1, -R5;
MOV R1.x, fragment.texcoord[6];
MOV R1.z, fragment.texcoord[5].x;
MOV R1.y, fragment.texcoord[7].x;
DP3 R2.x, -R5, R1;
MOV R1.x, fragment.texcoord[6].y;
MOV R1.z, fragment.texcoord[5].y;
MOV R1.y, fragment.texcoord[7];
DP3 R2.y, -R5, R1;
DP3 R0.w, R2, R2;
RSQ R2.w, R0.w;
MUL R5.xyz, R0, c[7].x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
TEX R1.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R0.xyz, R0, -R1;
MUL R0.w, R0, c[11].x;
MAD R0.xyz, R0.w, R0, R1;
MAX R0.w, R1, c[16];
MOV R1.xyz, c[3];
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MAD R1.xyz, R1, c[0], fragment.texcoord[2];
MUL R4.xyz, R4, c[3];
MAD_SAT R1.xyz, R4, R0.w, R1;
MAD R0.xyz, R0, R1, R5;
MUL R1.xyz, R2.w, R2;
DP3 R0.w, R3, fragment.texcoord[4];
MUL R2.xyz, R3, R0.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.x, R1, R3;
MAD R2.xyz, -R2, c[16].x, fragment.texcoord[4];
DP3 R0.w, R2, fragment.texcoord[1];
MUL R1.x, R1, R1;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[16].y;
POW R2.w, R0.w, c[14].x;
MUL R2.w, R2, c[13].x;
POW R1.x, R1.x, c[10].x;
MUL R1, R1.x, c[12];
MOV R0.w, c[16].y;
MAD R0, R1, c[9].x, R0;
TEX R1, R2, texture[3], CUBE;
ADD_SAT R3.x, R2.w, c[4];
MUL R1.xyz, R1, R3.x;
ADD R0, R1, R0;
MAD result.color, R2.w, R1, R0;
END
# 87 instructions, 6 R-regs
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
Float 11 [_decalPower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 89 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c16, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0
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
cmp_pp r0.w, -r0, c16.y, c16.z
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r3.w, r0
abs_pp r2.w, r0
mul_pp r1.xyz, r1.x, c2
cmp_pp r1.xyz, -r2.w, r0, r1
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r0.w, r0.y
dp3_pp r0.x, v1, v1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, v1
dp3_pp r1.w, r3, r1
mul_pp r0.xyz, r3, -r1.w
mul r2.xyz, r0.w, r2
mad_pp r0.xyz, -r0, c16.x, -r1
dp3_pp r0.x, r0, r2
max_pp r1.x, r0, c16.z
pow_pp r0, r1.x, c6.x
cmp_pp r0.y, -r2.w, r3.w, c16
mul_pp r1.xy, v3, c8.x
mul_pp r1.xy, r1, c16.w
texld r1.xyz, r1, s2
mad_pp r5.xyz, r1, c17.x, c17.yyzw
mul_pp r4.xyz, r0.y, c15
mov_pp r0.w, r0.x
mul_pp r0.xyz, r4, c5
mul_pp r0.xyz, r0, r0.w
cmp_pp r0.w, r1, c16.z, c16.y
abs_pp r0.w, r0
cmp_pp r0.xyz, -r0.w, r0, c16.z
mov r1.x, v6.z
mov r1.y, v7.z
mov r1.z, v5
dp3_pp r2.z, r1, -r5
mov r1.x, v6
mov r1.z, v5.x
mov r1.y, v7.x
dp3_pp r2.x, -r5, r1
mov r1.x, v6.y
mov r1.z, v5.y
mov r1.y, v7
dp3_pp r2.y, -r5, r1
dp3_pp r0.w, r2, r2
rsq_pp r2.w, r0.w
mul_pp r5.xyz, r0, c7.x
texld r0, v3, s1
texld r1.xyz, v3, s0
add_pp r0.xyz, r0, -r1
mul r0.w, r0, c11.x
mad_pp r0.xyz, r0.w, r0, r1
max_pp r0.w, r1, c16.z
mov_pp r1.xyz, c0
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mad_pp r1.xyz, c3, r1, v2
mul_pp r4.xyz, r4, c3
mad_pp_sat r1.xyz, r4, r0.w, r1
mad_pp r0.xyz, r0, r1, r5
mul_pp r1.xyz, r2.w, r2
dp3_pp r0.w, r3, v4
mul_pp r2.xyz, r3, r0.w
mul_pp r3.xyz, r1.w, v4
dp3_pp_sat r1.x, r1, r3
mul_pp r2.w, r1.x, r1.x
pow_pp r1, r2.w, c10.x
mad_pp r2.xyz, -r2, c16.x, v4
dp3_pp r0.w, r2, v1
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c16.y
pow_pp r3, r0.w, c14.x
mov_pp r0.w, r1.x
mul_pp r1, r0.w, c12
mov_pp r2.w, r3.x
mul_pp r2.w, r2, c13.x
mov_pp r0.w, c16.y
mad_pp r0, r1, c9.x, r0
texld r1, r2, s3
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
Float 11 [_decalPower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 87 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
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
CMP R0.w, -R0, c[16], c[16].y;
RSQ R1.x, R1.x;
ABS R0.w, R0;
MUL R0.xyz, R2.w, R0;
CMP R0.w, -R0, c[16], c[16].y;
MUL R1.xyz, R1.x, c[2];
CMP R1.xyz, -R0.w, R0, R1;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R3.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R3.xyz, R0.x, fragment.texcoord[1];
DP3 R1.w, R3, R1;
MUL R0.xyz, R3, -R1.w;
MAD R0.xyz, -R0, c[16].x, -R1;
MUL R2.xyz, R3.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[16].w;
POW R1.x, R0.x, c[6].x;
CMP R0.x, -R0.w, R2.w, c[16].y;
SLT R0.y, R1.w, c[16].w;
ABS R0.w, R0.y;
MUL R4.xyz, R0.x, c[15];
MUL R0.xyz, R4, c[5];
MUL R0.xyz, R0, R1.x;
CMP R0.w, -R0, c[16], c[16].y;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[16].z;
TEX R1.xyz, R1, texture[2], 2D;
MOV R2.xy, c[17];
MAD R5.xyz, R1, c[16].x, R2.xxyw;
CMP R0.xyz, -R0.w, R0, c[16].w;
MOV R1.x, fragment.texcoord[6].z;
MOV R1.y, fragment.texcoord[7].z;
MOV R1.z, fragment.texcoord[5];
DP3 R2.z, R1, -R5;
MOV R1.x, fragment.texcoord[6];
MOV R1.z, fragment.texcoord[5].x;
MOV R1.y, fragment.texcoord[7].x;
DP3 R2.x, -R5, R1;
MOV R1.x, fragment.texcoord[6].y;
MOV R1.z, fragment.texcoord[5].y;
MOV R1.y, fragment.texcoord[7];
DP3 R2.y, -R5, R1;
DP3 R0.w, R2, R2;
RSQ R2.w, R0.w;
MUL R5.xyz, R0, c[7].x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
TEX R1.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R0.xyz, R0, -R1;
MUL R0.w, R0, c[11].x;
MAD R0.xyz, R0.w, R0, R1;
MAX R0.w, R1, c[16];
MOV R1.xyz, c[3];
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MAD R1.xyz, R1, c[0], fragment.texcoord[2];
MUL R4.xyz, R4, c[3];
MAD_SAT R1.xyz, R4, R0.w, R1;
MAD R0.xyz, R0, R1, R5;
MUL R1.xyz, R2.w, R2;
DP3 R0.w, R3, fragment.texcoord[4];
MUL R2.xyz, R3, R0.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.x, R1, R3;
MAD R2.xyz, -R2, c[16].x, fragment.texcoord[4];
DP3 R0.w, R2, fragment.texcoord[1];
MUL R1.x, R1, R1;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[16].y;
POW R2.w, R0.w, c[14].x;
MUL R2.w, R2, c[13].x;
POW R1.x, R1.x, c[10].x;
MUL R1, R1.x, c[12];
MOV R0.w, c[16].y;
MAD R0, R1, c[9].x, R0;
TEX R1, R2, texture[3], CUBE;
ADD_SAT R3.x, R2.w, c[4];
MUL R1.xyz, R1, R3.x;
ADD R0, R1, R0;
MAD result.color, R2.w, R1, R0;
END
# 87 instructions, 6 R-regs
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
Float 11 [_decalPower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 89 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c16, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0
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
cmp_pp r0.w, -r0, c16.y, c16.z
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r3.w, r0
abs_pp r2.w, r0
mul_pp r1.xyz, r1.x, c2
cmp_pp r1.xyz, -r2.w, r0, r1
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r0.w, r0.y
dp3_pp r0.x, v1, v1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, v1
dp3_pp r1.w, r3, r1
mul_pp r0.xyz, r3, -r1.w
mul r2.xyz, r0.w, r2
mad_pp r0.xyz, -r0, c16.x, -r1
dp3_pp r0.x, r0, r2
max_pp r1.x, r0, c16.z
pow_pp r0, r1.x, c6.x
cmp_pp r0.y, -r2.w, r3.w, c16
mul_pp r1.xy, v3, c8.x
mul_pp r1.xy, r1, c16.w
texld r1.xyz, r1, s2
mad_pp r5.xyz, r1, c17.x, c17.yyzw
mul_pp r4.xyz, r0.y, c15
mov_pp r0.w, r0.x
mul_pp r0.xyz, r4, c5
mul_pp r0.xyz, r0, r0.w
cmp_pp r0.w, r1, c16.z, c16.y
abs_pp r0.w, r0
cmp_pp r0.xyz, -r0.w, r0, c16.z
mov r1.x, v6.z
mov r1.y, v7.z
mov r1.z, v5
dp3_pp r2.z, r1, -r5
mov r1.x, v6
mov r1.z, v5.x
mov r1.y, v7.x
dp3_pp r2.x, -r5, r1
mov r1.x, v6.y
mov r1.z, v5.y
mov r1.y, v7
dp3_pp r2.y, -r5, r1
dp3_pp r0.w, r2, r2
rsq_pp r2.w, r0.w
mul_pp r5.xyz, r0, c7.x
texld r0, v3, s1
texld r1.xyz, v3, s0
add_pp r0.xyz, r0, -r1
mul r0.w, r0, c11.x
mad_pp r0.xyz, r0.w, r0, r1
max_pp r0.w, r1, c16.z
mov_pp r1.xyz, c0
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mad_pp r1.xyz, c3, r1, v2
mul_pp r4.xyz, r4, c3
mad_pp_sat r1.xyz, r4, r0.w, r1
mad_pp r0.xyz, r0, r1, r5
mul_pp r1.xyz, r2.w, r2
dp3_pp r0.w, r3, v4
mul_pp r2.xyz, r3, r0.w
mul_pp r3.xyz, r1.w, v4
dp3_pp_sat r1.x, r1, r3
mul_pp r2.w, r1.x, r1.x
pow_pp r1, r2.w, c10.x
mad_pp r2.xyz, -r2, c16.x, v4
dp3_pp r0.w, r2, v1
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c16.y
pow_pp r3, r0.w, c14.x
mov_pp r0.w, r1.x
mul_pp r1, r0.w, c12
mov_pp r2.w, r3.x
mul_pp r2.w, r2, c13.x
mov_pp r0.w, c16.y
mad_pp r0, r1, c9.x, r0
texld r1, r2, s3
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
Float 11 [_decalPower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 87 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
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
CMP R0.w, -R0, c[16], c[16].y;
RSQ R1.x, R1.x;
ABS R0.w, R0;
MUL R0.xyz, R2.w, R0;
CMP R0.w, -R0, c[16], c[16].y;
MUL R1.xyz, R1.x, c[2];
CMP R1.xyz, -R0.w, R0, R1;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R3.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R3.xyz, R0.x, fragment.texcoord[1];
DP3 R1.w, R3, R1;
MUL R0.xyz, R3, -R1.w;
MAD R0.xyz, -R0, c[16].x, -R1;
MUL R2.xyz, R3.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[16].w;
POW R1.x, R0.x, c[6].x;
CMP R0.x, -R0.w, R2.w, c[16].y;
SLT R0.y, R1.w, c[16].w;
ABS R0.w, R0.y;
MUL R4.xyz, R0.x, c[15];
MUL R0.xyz, R4, c[5];
MUL R0.xyz, R0, R1.x;
CMP R0.w, -R0, c[16], c[16].y;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[16].z;
TEX R1.xyz, R1, texture[2], 2D;
MOV R2.xy, c[17];
MAD R5.xyz, R1, c[16].x, R2.xxyw;
CMP R0.xyz, -R0.w, R0, c[16].w;
MOV R1.x, fragment.texcoord[6].z;
MOV R1.y, fragment.texcoord[7].z;
MOV R1.z, fragment.texcoord[5];
DP3 R2.z, R1, -R5;
MOV R1.x, fragment.texcoord[6];
MOV R1.z, fragment.texcoord[5].x;
MOV R1.y, fragment.texcoord[7].x;
DP3 R2.x, -R5, R1;
MOV R1.x, fragment.texcoord[6].y;
MOV R1.z, fragment.texcoord[5].y;
MOV R1.y, fragment.texcoord[7];
DP3 R2.y, -R5, R1;
DP3 R0.w, R2, R2;
RSQ R2.w, R0.w;
MUL R5.xyz, R0, c[7].x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
TEX R1.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R0.xyz, R0, -R1;
MUL R0.w, R0, c[11].x;
MAD R0.xyz, R0.w, R0, R1;
MAX R0.w, R1, c[16];
MOV R1.xyz, c[3];
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MAD R1.xyz, R1, c[0], fragment.texcoord[2];
MUL R4.xyz, R4, c[3];
MAD_SAT R1.xyz, R4, R0.w, R1;
MAD R0.xyz, R0, R1, R5;
MUL R1.xyz, R2.w, R2;
DP3 R0.w, R3, fragment.texcoord[4];
MUL R2.xyz, R3, R0.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.x, R1, R3;
MAD R2.xyz, -R2, c[16].x, fragment.texcoord[4];
DP3 R0.w, R2, fragment.texcoord[1];
MUL R1.x, R1, R1;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[16].y;
POW R2.w, R0.w, c[14].x;
MUL R2.w, R2, c[13].x;
POW R1.x, R1.x, c[10].x;
MUL R1, R1.x, c[12];
MOV R0.w, c[16].y;
MAD R0, R1, c[9].x, R0;
TEX R1, R2, texture[3], CUBE;
ADD_SAT R3.x, R2.w, c[4];
MUL R1.xyz, R1, R3.x;
ADD R0, R1, R0;
MAD result.color, R2.w, R1, R0;
END
# 87 instructions, 6 R-regs
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
Float 11 [_decalPower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 89 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c16, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0
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
cmp_pp r0.w, -r0, c16.y, c16.z
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r3.w, r0
abs_pp r2.w, r0
mul_pp r1.xyz, r1.x, c2
cmp_pp r1.xyz, -r2.w, r0, r1
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r0.w, r0.y
dp3_pp r0.x, v1, v1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, v1
dp3_pp r1.w, r3, r1
mul_pp r0.xyz, r3, -r1.w
mul r2.xyz, r0.w, r2
mad_pp r0.xyz, -r0, c16.x, -r1
dp3_pp r0.x, r0, r2
max_pp r1.x, r0, c16.z
pow_pp r0, r1.x, c6.x
cmp_pp r0.y, -r2.w, r3.w, c16
mul_pp r1.xy, v3, c8.x
mul_pp r1.xy, r1, c16.w
texld r1.xyz, r1, s2
mad_pp r5.xyz, r1, c17.x, c17.yyzw
mul_pp r4.xyz, r0.y, c15
mov_pp r0.w, r0.x
mul_pp r0.xyz, r4, c5
mul_pp r0.xyz, r0, r0.w
cmp_pp r0.w, r1, c16.z, c16.y
abs_pp r0.w, r0
cmp_pp r0.xyz, -r0.w, r0, c16.z
mov r1.x, v6.z
mov r1.y, v7.z
mov r1.z, v5
dp3_pp r2.z, r1, -r5
mov r1.x, v6
mov r1.z, v5.x
mov r1.y, v7.x
dp3_pp r2.x, -r5, r1
mov r1.x, v6.y
mov r1.z, v5.y
mov r1.y, v7
dp3_pp r2.y, -r5, r1
dp3_pp r0.w, r2, r2
rsq_pp r2.w, r0.w
mul_pp r5.xyz, r0, c7.x
texld r0, v3, s1
texld r1.xyz, v3, s0
add_pp r0.xyz, r0, -r1
mul r0.w, r0, c11.x
mad_pp r0.xyz, r0.w, r0, r1
max_pp r0.w, r1, c16.z
mov_pp r1.xyz, c0
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mad_pp r1.xyz, c3, r1, v2
mul_pp r4.xyz, r4, c3
mad_pp_sat r1.xyz, r4, r0.w, r1
mad_pp r0.xyz, r0, r1, r5
mul_pp r1.xyz, r2.w, r2
dp3_pp r0.w, r3, v4
mul_pp r2.xyz, r3, r0.w
mul_pp r3.xyz, r1.w, v4
dp3_pp_sat r1.x, r1, r3
mul_pp r2.w, r1.x, r1.x
pow_pp r1, r2.w, c10.x
mad_pp r2.xyz, -r2, c16.x, v4
dp3_pp r0.w, r2, v1
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c16.y
pow_pp r3, r0.w, c14.x
mov_pp r0.w, r1.x
mul_pp r1, r0.w, c12
mov_pp r2.w, r3.x
mul_pp r2.w, r2, c13.x
mov_pp r0.w, c16.y
mad_pp r0, r1, c9.x, r0
texld r1, r2, s3
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
Float 11 [_decalPower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 87 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
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
CMP R0.w, -R0, c[16], c[16].y;
RSQ R1.x, R1.x;
ABS R0.w, R0;
MUL R0.xyz, R2.w, R0;
CMP R0.w, -R0, c[16], c[16].y;
MUL R1.xyz, R1.x, c[2];
CMP R1.xyz, -R0.w, R0, R1;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R3.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R3.xyz, R0.x, fragment.texcoord[1];
DP3 R1.w, R3, R1;
MUL R0.xyz, R3, -R1.w;
MAD R0.xyz, -R0, c[16].x, -R1;
MUL R2.xyz, R3.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[16].w;
POW R1.x, R0.x, c[6].x;
CMP R0.x, -R0.w, R2.w, c[16].y;
SLT R0.y, R1.w, c[16].w;
ABS R0.w, R0.y;
MUL R4.xyz, R0.x, c[15];
MUL R0.xyz, R4, c[5];
MUL R0.xyz, R0, R1.x;
CMP R0.w, -R0, c[16], c[16].y;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[16].z;
TEX R1.xyz, R1, texture[2], 2D;
MOV R2.xy, c[17];
MAD R5.xyz, R1, c[16].x, R2.xxyw;
CMP R0.xyz, -R0.w, R0, c[16].w;
MOV R1.x, fragment.texcoord[6].z;
MOV R1.y, fragment.texcoord[7].z;
MOV R1.z, fragment.texcoord[5];
DP3 R2.z, R1, -R5;
MOV R1.x, fragment.texcoord[6];
MOV R1.z, fragment.texcoord[5].x;
MOV R1.y, fragment.texcoord[7].x;
DP3 R2.x, -R5, R1;
MOV R1.x, fragment.texcoord[6].y;
MOV R1.z, fragment.texcoord[5].y;
MOV R1.y, fragment.texcoord[7];
DP3 R2.y, -R5, R1;
DP3 R0.w, R2, R2;
RSQ R2.w, R0.w;
MUL R5.xyz, R0, c[7].x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
TEX R1.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R0.xyz, R0, -R1;
MUL R0.w, R0, c[11].x;
MAD R0.xyz, R0.w, R0, R1;
MAX R0.w, R1, c[16];
MOV R1.xyz, c[3];
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MAD R1.xyz, R1, c[0], fragment.texcoord[2];
MUL R4.xyz, R4, c[3];
MAD_SAT R1.xyz, R4, R0.w, R1;
MAD R0.xyz, R0, R1, R5;
MUL R1.xyz, R2.w, R2;
DP3 R0.w, R3, fragment.texcoord[4];
MUL R2.xyz, R3, R0.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.x, R1, R3;
MAD R2.xyz, -R2, c[16].x, fragment.texcoord[4];
DP3 R0.w, R2, fragment.texcoord[1];
MUL R1.x, R1, R1;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[16].y;
POW R2.w, R0.w, c[14].x;
MUL R2.w, R2, c[13].x;
POW R1.x, R1.x, c[10].x;
MUL R1, R1.x, c[12];
MOV R0.w, c[16].y;
MAD R0, R1, c[9].x, R0;
TEX R1, R2, texture[3], CUBE;
ADD_SAT R3.x, R2.w, c[4];
MUL R1.xyz, R1, R3.x;
ADD R0, R1, R0;
MAD result.color, R2.w, R1, R0;
END
# 87 instructions, 6 R-regs
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
Float 11 [_decalPower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 89 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c16, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0
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
cmp_pp r0.w, -r0, c16.y, c16.z
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r3.w, r0
abs_pp r2.w, r0
mul_pp r1.xyz, r1.x, c2
cmp_pp r1.xyz, -r2.w, r0, r1
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r0.w, r0.y
dp3_pp r0.x, v1, v1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, v1
dp3_pp r1.w, r3, r1
mul_pp r0.xyz, r3, -r1.w
mul r2.xyz, r0.w, r2
mad_pp r0.xyz, -r0, c16.x, -r1
dp3_pp r0.x, r0, r2
max_pp r1.x, r0, c16.z
pow_pp r0, r1.x, c6.x
cmp_pp r0.y, -r2.w, r3.w, c16
mul_pp r1.xy, v3, c8.x
mul_pp r1.xy, r1, c16.w
texld r1.xyz, r1, s2
mad_pp r5.xyz, r1, c17.x, c17.yyzw
mul_pp r4.xyz, r0.y, c15
mov_pp r0.w, r0.x
mul_pp r0.xyz, r4, c5
mul_pp r0.xyz, r0, r0.w
cmp_pp r0.w, r1, c16.z, c16.y
abs_pp r0.w, r0
cmp_pp r0.xyz, -r0.w, r0, c16.z
mov r1.x, v6.z
mov r1.y, v7.z
mov r1.z, v5
dp3_pp r2.z, r1, -r5
mov r1.x, v6
mov r1.z, v5.x
mov r1.y, v7.x
dp3_pp r2.x, -r5, r1
mov r1.x, v6.y
mov r1.z, v5.y
mov r1.y, v7
dp3_pp r2.y, -r5, r1
dp3_pp r0.w, r2, r2
rsq_pp r2.w, r0.w
mul_pp r5.xyz, r0, c7.x
texld r0, v3, s1
texld r1.xyz, v3, s0
add_pp r0.xyz, r0, -r1
mul r0.w, r0, c11.x
mad_pp r0.xyz, r0.w, r0, r1
max_pp r0.w, r1, c16.z
mov_pp r1.xyz, c0
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mad_pp r1.xyz, c3, r1, v2
mul_pp r4.xyz, r4, c3
mad_pp_sat r1.xyz, r4, r0.w, r1
mad_pp r0.xyz, r0, r1, r5
mul_pp r1.xyz, r2.w, r2
dp3_pp r0.w, r3, v4
mul_pp r2.xyz, r3, r0.w
mul_pp r3.xyz, r1.w, v4
dp3_pp_sat r1.x, r1, r3
mul_pp r2.w, r1.x, r1.x
pow_pp r1, r2.w, c10.x
mad_pp r2.xyz, -r2, c16.x, v4
dp3_pp r0.w, r2, v1
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c16.y
pow_pp r3, r0.w, c14.x
mov_pp r0.w, r1.x
mul_pp r1, r0.w, c12
mov_pp r2.w, r3.x
mul_pp r2.w, r2, c13.x
mov_pp r0.w, c16.y
mad_pp r0, r1, c9.x, r0
texld r1, r2, s3
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
Float 11 [_decalPower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 87 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
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
CMP R0.w, -R0, c[16], c[16].y;
RSQ R1.x, R1.x;
ABS R0.w, R0;
MUL R0.xyz, R2.w, R0;
CMP R0.w, -R0, c[16], c[16].y;
MUL R1.xyz, R1.x, c[2];
CMP R1.xyz, -R0.w, R0, R1;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R3.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R3.xyz, R0.x, fragment.texcoord[1];
DP3 R1.w, R3, R1;
MUL R0.xyz, R3, -R1.w;
MAD R0.xyz, -R0, c[16].x, -R1;
MUL R2.xyz, R3.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[16].w;
POW R1.x, R0.x, c[6].x;
CMP R0.x, -R0.w, R2.w, c[16].y;
SLT R0.y, R1.w, c[16].w;
ABS R0.w, R0.y;
MUL R4.xyz, R0.x, c[15];
MUL R0.xyz, R4, c[5];
MUL R0.xyz, R0, R1.x;
CMP R0.w, -R0, c[16], c[16].y;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[16].z;
TEX R1.xyz, R1, texture[2], 2D;
MOV R2.xy, c[17];
MAD R5.xyz, R1, c[16].x, R2.xxyw;
CMP R0.xyz, -R0.w, R0, c[16].w;
MOV R1.x, fragment.texcoord[6].z;
MOV R1.y, fragment.texcoord[7].z;
MOV R1.z, fragment.texcoord[5];
DP3 R2.z, R1, -R5;
MOV R1.x, fragment.texcoord[6];
MOV R1.z, fragment.texcoord[5].x;
MOV R1.y, fragment.texcoord[7].x;
DP3 R2.x, -R5, R1;
MOV R1.x, fragment.texcoord[6].y;
MOV R1.z, fragment.texcoord[5].y;
MOV R1.y, fragment.texcoord[7];
DP3 R2.y, -R5, R1;
DP3 R0.w, R2, R2;
RSQ R2.w, R0.w;
MUL R5.xyz, R0, c[7].x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
TEX R1.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R0.xyz, R0, -R1;
MUL R0.w, R0, c[11].x;
MAD R0.xyz, R0.w, R0, R1;
MAX R0.w, R1, c[16];
MOV R1.xyz, c[3];
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MAD R1.xyz, R1, c[0], fragment.texcoord[2];
MUL R4.xyz, R4, c[3];
MAD_SAT R1.xyz, R4, R0.w, R1;
MAD R0.xyz, R0, R1, R5;
MUL R1.xyz, R2.w, R2;
DP3 R0.w, R3, fragment.texcoord[4];
MUL R2.xyz, R3, R0.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.x, R1, R3;
MAD R2.xyz, -R2, c[16].x, fragment.texcoord[4];
DP3 R0.w, R2, fragment.texcoord[1];
MUL R1.x, R1, R1;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[16].y;
POW R2.w, R0.w, c[14].x;
MUL R2.w, R2, c[13].x;
POW R1.x, R1.x, c[10].x;
MUL R1, R1.x, c[12];
MOV R0.w, c[16].y;
MAD R0, R1, c[9].x, R0;
TEX R1, R2, texture[3], CUBE;
ADD_SAT R3.x, R2.w, c[4];
MUL R1.xyz, R1, R3.x;
ADD R0, R1, R0;
MAD result.color, R2.w, R1, R0;
END
# 87 instructions, 6 R-regs
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
Float 11 [_decalPower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 89 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c16, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0
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
cmp_pp r0.w, -r0, c16.y, c16.z
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r3.w, r0
abs_pp r2.w, r0
mul_pp r1.xyz, r1.x, c2
cmp_pp r1.xyz, -r2.w, r0, r1
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r0.w, r0.y
dp3_pp r0.x, v1, v1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, v1
dp3_pp r1.w, r3, r1
mul_pp r0.xyz, r3, -r1.w
mul r2.xyz, r0.w, r2
mad_pp r0.xyz, -r0, c16.x, -r1
dp3_pp r0.x, r0, r2
max_pp r1.x, r0, c16.z
pow_pp r0, r1.x, c6.x
cmp_pp r0.y, -r2.w, r3.w, c16
mul_pp r1.xy, v3, c8.x
mul_pp r1.xy, r1, c16.w
texld r1.xyz, r1, s2
mad_pp r5.xyz, r1, c17.x, c17.yyzw
mul_pp r4.xyz, r0.y, c15
mov_pp r0.w, r0.x
mul_pp r0.xyz, r4, c5
mul_pp r0.xyz, r0, r0.w
cmp_pp r0.w, r1, c16.z, c16.y
abs_pp r0.w, r0
cmp_pp r0.xyz, -r0.w, r0, c16.z
mov r1.x, v6.z
mov r1.y, v7.z
mov r1.z, v5
dp3_pp r2.z, r1, -r5
mov r1.x, v6
mov r1.z, v5.x
mov r1.y, v7.x
dp3_pp r2.x, -r5, r1
mov r1.x, v6.y
mov r1.z, v5.y
mov r1.y, v7
dp3_pp r2.y, -r5, r1
dp3_pp r0.w, r2, r2
rsq_pp r2.w, r0.w
mul_pp r5.xyz, r0, c7.x
texld r0, v3, s1
texld r1.xyz, v3, s0
add_pp r0.xyz, r0, -r1
mul r0.w, r0, c11.x
mad_pp r0.xyz, r0.w, r0, r1
max_pp r0.w, r1, c16.z
mov_pp r1.xyz, c0
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mad_pp r1.xyz, c3, r1, v2
mul_pp r4.xyz, r4, c3
mad_pp_sat r1.xyz, r4, r0.w, r1
mad_pp r0.xyz, r0, r1, r5
mul_pp r1.xyz, r2.w, r2
dp3_pp r0.w, r3, v4
mul_pp r2.xyz, r3, r0.w
mul_pp r3.xyz, r1.w, v4
dp3_pp_sat r1.x, r1, r3
mul_pp r2.w, r1.x, r1.x
pow_pp r1, r2.w, c10.x
mad_pp r2.xyz, -r2, c16.x, v4
dp3_pp r0.w, r2, v1
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c16.y
pow_pp r3, r0.w, c14.x
mov_pp r0.w, r1.x
mul_pp r1, r0.w, c12
mov_pp r2.w, r3.x
mul_pp r2.w, r2, c13.x
mov_pp r0.w, c16.y
mad_pp r0, r1, c9.x, r0
texld r1, r2, s3
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
Float 11 [_decalPower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 87 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..15],
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
CMP R0.w, -R0, c[16], c[16].y;
RSQ R1.x, R1.x;
ABS R0.w, R0;
MUL R0.xyz, R2.w, R0;
CMP R0.w, -R0, c[16], c[16].y;
MUL R1.xyz, R1.x, c[2];
CMP R1.xyz, -R0.w, R0, R1;
ADD R2.xyz, -fragment.texcoord[0], c[1];
DP3 R0.y, R2, R2;
RSQ R3.w, R0.y;
DP3 R0.x, fragment.texcoord[1], fragment.texcoord[1];
RSQ R0.x, R0.x;
MUL R3.xyz, R0.x, fragment.texcoord[1];
DP3 R1.w, R3, R1;
MUL R0.xyz, R3, -R1.w;
MAD R0.xyz, -R0, c[16].x, -R1;
MUL R2.xyz, R3.w, R2;
DP3 R0.x, R0, R2;
MAX R0.x, R0, c[16].w;
POW R1.x, R0.x, c[6].x;
CMP R0.x, -R0.w, R2.w, c[16].y;
SLT R0.y, R1.w, c[16].w;
ABS R0.w, R0.y;
MUL R4.xyz, R0.x, c[15];
MUL R0.xyz, R4, c[5];
MUL R0.xyz, R0, R1.x;
CMP R0.w, -R0, c[16], c[16].y;
MUL R1.xy, fragment.texcoord[3], c[8].x;
MUL R1.xy, R1, c[16].z;
TEX R1.xyz, R1, texture[2], 2D;
MOV R2.xy, c[17];
MAD R5.xyz, R1, c[16].x, R2.xxyw;
CMP R0.xyz, -R0.w, R0, c[16].w;
MOV R1.x, fragment.texcoord[6].z;
MOV R1.y, fragment.texcoord[7].z;
MOV R1.z, fragment.texcoord[5];
DP3 R2.z, R1, -R5;
MOV R1.x, fragment.texcoord[6];
MOV R1.z, fragment.texcoord[5].x;
MOV R1.y, fragment.texcoord[7].x;
DP3 R2.x, -R5, R1;
MOV R1.x, fragment.texcoord[6].y;
MOV R1.z, fragment.texcoord[5].y;
MOV R1.y, fragment.texcoord[7];
DP3 R2.y, -R5, R1;
DP3 R0.w, R2, R2;
RSQ R2.w, R0.w;
MUL R5.xyz, R0, c[7].x;
TEX R0, fragment.texcoord[3], texture[1], 2D;
TEX R1.xyz, fragment.texcoord[3], texture[0], 2D;
ADD R0.xyz, R0, -R1;
MUL R0.w, R0, c[11].x;
MAD R0.xyz, R0.w, R0, R1;
MAX R0.w, R1, c[16];
MOV R1.xyz, c[3];
DP3 R1.w, fragment.texcoord[4], fragment.texcoord[4];
RSQ R1.w, R1.w;
MAD R1.xyz, R1, c[0], fragment.texcoord[2];
MUL R4.xyz, R4, c[3];
MAD_SAT R1.xyz, R4, R0.w, R1;
MAD R0.xyz, R0, R1, R5;
MUL R1.xyz, R2.w, R2;
DP3 R0.w, R3, fragment.texcoord[4];
MUL R2.xyz, R3, R0.w;
MUL R3.xyz, R1.w, fragment.texcoord[4];
DP3_SAT R1.x, R1, R3;
MAD R2.xyz, -R2, c[16].x, fragment.texcoord[4];
DP3 R0.w, R2, fragment.texcoord[1];
MUL R1.x, R1, R1;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[16].y;
POW R2.w, R0.w, c[14].x;
MUL R2.w, R2, c[13].x;
POW R1.x, R1.x, c[10].x;
MUL R1, R1.x, c[12];
MOV R0.w, c[16].y;
MAD R0, R1, c[9].x, R0;
TEX R1, R2, texture[3], CUBE;
ADD_SAT R3.x, R2.w, c[4];
MUL R1.xyz, R1, R3.x;
ADD R0, R1, R0;
MAD result.color, R2.w, R1, R0;
END
# 87 instructions, 6 R-regs
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
Float 11 [_decalPower]
Vector 12 [_paintColor2]
Float 13 [_FrezPow]
Float 14 [_FrezFalloff]
Vector 15 [_LightColor0]
SetTexture 0 [_MainTex] 2D
SetTexture 1 [_DecalMap] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 89 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c16, 2.00000000, 1.00000000, 0.00000000, 20.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0
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
cmp_pp r0.w, -r0, c16.y, c16.z
rsq_pp r1.x, r1.x
mul_pp r0.xyz, r3.w, r0
abs_pp r2.w, r0
mul_pp r1.xyz, r1.x, c2
cmp_pp r1.xyz, -r2.w, r0, r1
add r2.xyz, -v0, c1
dp3 r0.y, r2, r2
rsq r0.w, r0.y
dp3_pp r0.x, v1, v1
rsq_pp r0.x, r0.x
mul_pp r3.xyz, r0.x, v1
dp3_pp r1.w, r3, r1
mul_pp r0.xyz, r3, -r1.w
mul r2.xyz, r0.w, r2
mad_pp r0.xyz, -r0, c16.x, -r1
dp3_pp r0.x, r0, r2
max_pp r1.x, r0, c16.z
pow_pp r0, r1.x, c6.x
cmp_pp r0.y, -r2.w, r3.w, c16
mul_pp r1.xy, v3, c8.x
mul_pp r1.xy, r1, c16.w
texld r1.xyz, r1, s2
mad_pp r5.xyz, r1, c17.x, c17.yyzw
mul_pp r4.xyz, r0.y, c15
mov_pp r0.w, r0.x
mul_pp r0.xyz, r4, c5
mul_pp r0.xyz, r0, r0.w
cmp_pp r0.w, r1, c16.z, c16.y
abs_pp r0.w, r0
cmp_pp r0.xyz, -r0.w, r0, c16.z
mov r1.x, v6.z
mov r1.y, v7.z
mov r1.z, v5
dp3_pp r2.z, r1, -r5
mov r1.x, v6
mov r1.z, v5.x
mov r1.y, v7.x
dp3_pp r2.x, -r5, r1
mov r1.x, v6.y
mov r1.z, v5.y
mov r1.y, v7
dp3_pp r2.y, -r5, r1
dp3_pp r0.w, r2, r2
rsq_pp r2.w, r0.w
mul_pp r5.xyz, r0, c7.x
texld r0, v3, s1
texld r1.xyz, v3, s0
add_pp r0.xyz, r0, -r1
mul r0.w, r0, c11.x
mad_pp r0.xyz, r0.w, r0, r1
max_pp r0.w, r1, c16.z
mov_pp r1.xyz, c0
dp3_pp r1.w, v4, v4
rsq_pp r1.w, r1.w
mad_pp r1.xyz, c3, r1, v2
mul_pp r4.xyz, r4, c3
mad_pp_sat r1.xyz, r4, r0.w, r1
mad_pp r0.xyz, r0, r1, r5
mul_pp r1.xyz, r2.w, r2
dp3_pp r0.w, r3, v4
mul_pp r2.xyz, r3, r0.w
mul_pp r3.xyz, r1.w, v4
dp3_pp_sat r1.x, r1, r3
mul_pp r2.w, r1.x, r1.x
pow_pp r1, r2.w, c10.x
mad_pp r2.xyz, -r2, c16.x, v4
dp3_pp r0.w, r2, v1
abs_pp_sat r0.w, r0
add_pp r0.w, -r0, c16.y
pow_pp r3, r0.w, c14.x
mov_pp r0.w, r1.x
mul_pp r1, r0.w, c12
mov_pp r2.w, r3.x
mul_pp r2.w, r2, c13.x
mov_pp r0.w, c16.y
mad_pp r0, r1, c9.x, r0
texld r1, r2, s3
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

#LINE 287

      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Mobile/Diffuse"
}