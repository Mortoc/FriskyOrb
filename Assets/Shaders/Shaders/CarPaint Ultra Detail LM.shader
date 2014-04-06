//same like HIGH + self shadow enabled

Shader "RedDotGames/Mobile/Lightmapping Support/Car Paint Ultra Detail" {
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

	  
   }
SubShader {
   Tags { "QUEUE"="Geometry" "RenderType"="Opaque" " IgnoreProjector"="True"}	  
      Pass {  
      
         Tags { "LightMode" = "ForwardBase" } // pass for 
            // 4 vertex lights, ambient light & first pixel light
 
         Program "vp" {
// Vertex combos: 8
//   opengl - ALU: 36 to 104
//   d3d9 - ALU: 36 to 104
SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_LightmapST]
"3.0-!!ARBvp1.0
# 36 ALU
PARAM c[15] = { { 0 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[1].xyz, R1.w, R1;
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
MAD result.texcoord[3].zw, vertex.texcoord[1].xyxy, c[14].xyxy, c[14];
MOV result.texcoord[3].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 36 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_LightmapST]
"vs_3_0
; 36 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c14, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_tangent0 v4
mov r1.w, c14.x
mov r1.xyz, v4
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c14.x
dp3 r1.w, r1, r1
rsq r1.w, r1.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o5.xyz, r0.w, r0
mov r0.w, c14.x
mov r0.xyz, v1
mul o2.xyz, r1.w, r1
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c14.x
mad o4.zw, v3.xyxy, c13.xyxy, c13
mov o4.xy, v2
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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * _World2Object).xyz);
  tmpvar_3 = tmpvar_9;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  tmpvar_4.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_7 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_6 = tmpvar_15;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
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
uniform sampler2D unity_Lightmap;

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
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3.zw).xyz);
  lowp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  lowp vec3 tmpvar_8;
  tmpvar_8 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_8;
  lowp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_10;
    tmpvar_10 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_2), viewDirection) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_11;
    tmpvar_11 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_10, _Shininess));
    specularReflection = tmpvar_11;
  };
  mediump vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  lowp mat3 tmpvar_13;
  tmpvar_13[0] = xlv_TEXCOORD6;
  tmpvar_13[1] = binormalDirection;
  tmpvar_13[2] = xlv_TEXCOORD5;
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
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  lowp float tmpvar_16;
  tmpvar_16 = clamp (dot (normalize ((tmpvar_15 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_16 * tmpvar_16);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (pow (tmpvar_17, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = (paintColor * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  paintColor = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, tmpvar_20);
  reflTex = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (tmpvar_20, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - tmpvar_22), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (tmpvar_21.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = (((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (tmpvar_19 * _FlakePower));
  color = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = ((color + reflTex) + (tmpvar_24 * reflTex));
  color = tmpvar_27;
  gl_FragData[0] = tmpvar_27;
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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * _World2Object).xyz);
  tmpvar_3 = tmpvar_9;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  tmpvar_4.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_7 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_6 = tmpvar_15;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
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
uniform sampler2D unity_Lightmap;

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
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (unity_Lightmap, xlv_TEXCOORD3.zw);
  lowp vec3 tmpvar_2;
  tmpvar_2 = ((8.0 * tmpvar_1.w) * tmpvar_1.xyz);
  lowp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_6;
    tmpvar_6 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_6;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  lowp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_11;
    tmpvar_11 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_3), viewDirection) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_12;
    tmpvar_12 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_11, _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = binormalDirection;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
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
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = (paintColor * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
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
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = (((tmpvar_5.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_8), 0.0, 1.0)) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (tmpvar_20 * _FlakePower));
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
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_LightmapST]
"3.0-!!ARBvp1.0
# 36 ALU
PARAM c[15] = { { 0 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[1].xyz, R1.w, R1;
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
MAD result.texcoord[3].zw, vertex.texcoord[1].xyxy, c[14].xyxy, c[14];
MOV result.texcoord[3].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 36 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_LightmapST]
"vs_3_0
; 36 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c14, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_tangent0 v4
mov r1.w, c14.x
mov r1.xyz, v4
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c14.x
dp3 r1.w, r1, r1
rsq r1.w, r1.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o5.xyz, r0.w, r0
mov r0.w, c14.x
mov r0.xyz, v1
mul o2.xyz, r1.w, r1
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c14.x
mad o4.zw, v3.xyxy, c13.xyxy, c13
mov o4.xy, v2
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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * _World2Object).xyz);
  tmpvar_3 = tmpvar_9;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  tmpvar_4.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_7 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_6 = tmpvar_15;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
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
uniform sampler2D unity_Lightmap;

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
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3.zw).xyz);
  lowp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  lowp vec3 tmpvar_8;
  tmpvar_8 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_8;
  lowp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_10;
    tmpvar_10 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_2), viewDirection) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_11;
    tmpvar_11 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_10, _Shininess));
    specularReflection = tmpvar_11;
  };
  mediump vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  lowp mat3 tmpvar_13;
  tmpvar_13[0] = xlv_TEXCOORD6;
  tmpvar_13[1] = binormalDirection;
  tmpvar_13[2] = xlv_TEXCOORD5;
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
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  lowp float tmpvar_16;
  tmpvar_16 = clamp (dot (normalize ((tmpvar_15 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_16 * tmpvar_16);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (pow (tmpvar_17, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = (paintColor * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  paintColor = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, tmpvar_20);
  reflTex = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (tmpvar_20, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - tmpvar_22), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (tmpvar_21.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = (((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (tmpvar_19 * _FlakePower));
  color = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = ((color + reflTex) + (tmpvar_24 * reflTex));
  color = tmpvar_27;
  gl_FragData[0] = tmpvar_27;
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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * _World2Object).xyz);
  tmpvar_3 = tmpvar_9;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  tmpvar_4.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_7 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_6 = tmpvar_15;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
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
uniform sampler2D unity_Lightmap;

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
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (unity_Lightmap, xlv_TEXCOORD3.zw);
  lowp vec3 tmpvar_2;
  tmpvar_2 = ((8.0 * tmpvar_1.w) * tmpvar_1.xyz);
  lowp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_6;
    tmpvar_6 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_6;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  lowp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_11;
    tmpvar_11 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_3), viewDirection) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_12;
    tmpvar_12 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_11, _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = binormalDirection;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
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
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = (paintColor * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
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
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = (((tmpvar_5.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_8), 0.0, 1.0)) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (tmpvar_20 * _FlakePower));
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
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Vector 13 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 14 [unity_LightmapST]
"3.0-!!ARBvp1.0
# 36 ALU
PARAM c[15] = { { 0 },
		state.matrix.mvp,
		program.local[5..14] };
TEMP R0;
TEMP R1;
MOV R1.w, c[0].x;
MOV R1.xyz, vertex.attrib[14];
DP4 R0.z, R1, c[7];
DP4 R0.x, R1, c[5];
DP4 R0.y, R1, c[6];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R0;
MUL R1.xyz, vertex.normal.y, c[10];
MAD R1.xyz, vertex.normal.x, c[9], R1;
MAD R1.xyz, vertex.normal.z, c[11], R1;
ADD R1.xyz, R1, c[0].x;
DP3 R1.w, R1, R1;
RSQ R1.w, R1.w;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[13];
DP3 R0.w, R0, R0;
RSQ R0.w, R0.w;
MUL result.texcoord[4].xyz, R0.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MUL result.texcoord[1].xyz, R1.w, R1;
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[2].xyz, c[0].x;
MAD result.texcoord[3].zw, vertex.texcoord[1].xyxy, c[14].xyxy, c[14];
MOV result.texcoord[3].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 36 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_OFF" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 13 [unity_LightmapST]
"vs_3_0
; 36 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c14, 0.00000000, 0, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_tangent0 v4
mov r1.w, c14.x
mov r1.xyz, v4
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
mul r1.xyz, v1.y, c9
mad r1.xyz, v1.x, c8, r1
mad r1.xyz, v1.z, c10, r1
add r1.xyz, r1, c14.x
dp3 r1.w, r1, r1
rsq r1.w, r1.w
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c12
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o5.xyz, r0.w, r0
mov r0.w, c14.x
mov r0.xyz, v1
mul o2.xyz, r1.w, r1
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o3.xyz, c14.x
mad o4.zw, v3.xyxy, c13.xyxy, c13
mov o4.xy, v2
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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * _World2Object).xyz);
  tmpvar_3 = tmpvar_9;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  tmpvar_4.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_7 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_6 = tmpvar_15;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
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
uniform sampler2D unity_Lightmap;

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
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3.zw).xyz);
  lowp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  lowp vec3 tmpvar_8;
  tmpvar_8 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_8;
  lowp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_10;
    tmpvar_10 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_2), viewDirection) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_11;
    tmpvar_11 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_10, _Shininess));
    specularReflection = tmpvar_11;
  };
  mediump vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  lowp mat3 tmpvar_13;
  tmpvar_13[0] = xlv_TEXCOORD6;
  tmpvar_13[1] = binormalDirection;
  tmpvar_13[2] = xlv_TEXCOORD5;
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
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  lowp float tmpvar_16;
  tmpvar_16 = clamp (dot (normalize ((tmpvar_15 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_16 * tmpvar_16);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (pow (tmpvar_17, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = (paintColor * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  paintColor = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, tmpvar_20);
  reflTex = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (tmpvar_20, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - tmpvar_22), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (tmpvar_21.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = (((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (tmpvar_19 * _FlakePower));
  color = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = ((color + reflTex) + (tmpvar_24 * reflTex));
  color = tmpvar_27;
  gl_FragData[0] = tmpvar_27;
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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * _World2Object).xyz);
  tmpvar_3 = tmpvar_9;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  tmpvar_4.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10.w = 1.0;
  tmpvar_10.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize (((_Object2World * _glesVertex) - tmpvar_10).xyz);
  tmpvar_5 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 0.0;
  tmpvar_12.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize ((_Object2World * tmpvar_12).xyz);
  tmpvar_7 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_1;
  highp vec3 tmpvar_15;
  tmpvar_15 = (_Object2World * tmpvar_14).xyz;
  tmpvar_6 = tmpvar_15;
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
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
uniform sampler2D unity_Lightmap;

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
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (unity_Lightmap, xlv_TEXCOORD3.zw);
  lowp vec3 tmpvar_2;
  tmpvar_2 = ((8.0 * tmpvar_1.w) * tmpvar_1.xyz);
  lowp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_6;
    tmpvar_6 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_6;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  lowp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_11;
    tmpvar_11 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_3), viewDirection) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_12;
    tmpvar_12 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_11, _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = binormalDirection;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
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
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = (paintColor * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
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
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = (((tmpvar_5.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_8), 0.0, 1.0)) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (tmpvar_20 * _FlakePower));
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
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_LightmapST]
"3.0-!!ARBvp1.0
# 42 ALU
PARAM c[16] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..15] };
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
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R0.y, R1, c[13].x;
MOV R0.x, R1;
ADD result.texcoord[7].xy, R0, R1.z;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R1.xyz, vertex.normal.z, c[11], R0;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
ADD R1.xyz, R1, c[0].x;
DP3 R1.w, R0, R0;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
RSQ R1.w, R1.w;
MUL result.texcoord[1].xyz, R0.w, R1;
MUL result.texcoord[4].xyz, R1.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
MAD result.texcoord[3].zw, vertex.texcoord[1].xyxy, c[15].xyxy, c[15];
MOV result.texcoord[3].xy, vertex.texcoord[0];
END
# 42 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_LightmapST]
"vs_3_0
; 42 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c16, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_tangent0 v4
mov r1.w, c16.x
mov r1.xyz, v4
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c16.y
mul r0.y, r1, c12.x
mov r0.x, r1
mad o8.xy, r1.z, c13.zwzw, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r1.xyz, v1.z, c10, r0
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
add r1.xyz, r1, c16.x
dp3 r1.w, r0, r0
dp3 r0.w, r1, r1
rsq r0.w, r0.w
rsq r1.w, r1.w
mul o2.xyz, r0.w, r1
mul o5.xyz, r1.w, r0
mov r0.w, c16.x
mov r0.xyz, v1
mov o0, r2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c16.x
mad o4.zw, v3.xyxy, c15.xyxy, c15
mov o4.xy, v2
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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * _World2Object).xyz);
  tmpvar_3 = tmpvar_9;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  tmpvar_4.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((_Object2World * _glesVertex) - tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((_Object2World * tmpvar_13).xyz);
  tmpvar_7 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 0.0;
  tmpvar_15.xyz = tmpvar_1;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * tmpvar_15).xyz;
  tmpvar_6 = tmpvar_16;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_10 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_10.zw;
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
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
uniform sampler2D unity_Lightmap;

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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3.zw).xyz);
  lowp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = (((tmpvar_6.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  lowp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_11;
    tmpvar_11 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_2), viewDirection) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_12;
    tmpvar_12 = (((tmpvar_6.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_11, _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = binormalDirection;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
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
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = (paintColor * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
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
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = (((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_8), 0.0, 1.0)) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (tmpvar_20 * _FlakePower));
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * _World2Object).xyz);
  tmpvar_3 = tmpvar_9;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  tmpvar_4.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((_Object2World * _glesVertex) - tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((_Object2World * tmpvar_13).xyz);
  tmpvar_7 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 0.0;
  tmpvar_15.xyz = tmpvar_1;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * tmpvar_15).xyz;
  tmpvar_6 = tmpvar_16;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_10 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_10.zw;
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
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
uniform sampler2D unity_Lightmap;

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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (unity_Lightmap, xlv_TEXCOORD3.zw);
  lowp vec3 tmpvar_2;
  tmpvar_2 = ((8.0 * tmpvar_1.w) * tmpvar_1.xyz);
  lowp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_6;
    tmpvar_6 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_6;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_8;
  tmpvar_8 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = (((tmpvar_7.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  lowp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_3), viewDirection) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((tmpvar_7.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = binormalDirection;
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
  lowp vec4 tmpvar_21;
  tmpvar_21 = (paintColor * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  paintColor = tmpvar_21;
  lowp vec3 tmpvar_22;
  tmpvar_22 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_Cube, tmpvar_22);
  reflTex = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = clamp (abs (dot (tmpvar_22, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = pow ((1.0 - tmpvar_24), _FrezFalloff);
  frez = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = (frez * _FrezPow);
  frez = tmpvar_26;
  reflTex.xyz = (tmpvar_23.xyz * clamp ((_Reflection + tmpvar_26), 0.0, 1.0));
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((tmpvar_5.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_9), 0.0, 1.0)) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_27 + (tmpvar_21 * _FlakePower));
  color = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = ((color + reflTex) + (tmpvar_26 * reflTex));
  color = tmpvar_29;
  gl_FragData[0] = tmpvar_29;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_LightmapST]
"3.0-!!ARBvp1.0
# 42 ALU
PARAM c[16] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..15] };
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
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R0.y, R1, c[13].x;
MOV R0.x, R1;
ADD result.texcoord[7].xy, R0, R1.z;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R1.xyz, vertex.normal.z, c[11], R0;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
ADD R1.xyz, R1, c[0].x;
DP3 R1.w, R0, R0;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
RSQ R1.w, R1.w;
MUL result.texcoord[1].xyz, R0.w, R1;
MUL result.texcoord[4].xyz, R1.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
MAD result.texcoord[3].zw, vertex.texcoord[1].xyxy, c[15].xyxy, c[15];
MOV result.texcoord[3].xy, vertex.texcoord[0];
END
# 42 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_LightmapST]
"vs_3_0
; 42 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c16, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_tangent0 v4
mov r1.w, c16.x
mov r1.xyz, v4
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c16.y
mul r0.y, r1, c12.x
mov r0.x, r1
mad o8.xy, r1.z, c13.zwzw, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r1.xyz, v1.z, c10, r0
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
add r1.xyz, r1, c16.x
dp3 r1.w, r0, r0
dp3 r0.w, r1, r1
rsq r0.w, r0.w
rsq r1.w, r1.w
mul o2.xyz, r0.w, r1
mul o5.xyz, r1.w, r0
mov r0.w, c16.x
mov r0.xyz, v1
mov o0, r2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c16.x
mad o4.zw, v3.xyxy, c15.xyxy, c15
mov o4.xy, v2
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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * _World2Object).xyz);
  tmpvar_3 = tmpvar_9;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  tmpvar_4.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((_Object2World * _glesVertex) - tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((_Object2World * tmpvar_13).xyz);
  tmpvar_7 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 0.0;
  tmpvar_15.xyz = tmpvar_1;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * tmpvar_15).xyz;
  tmpvar_6 = tmpvar_16;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_10 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_10.zw;
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
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
uniform sampler2D unity_Lightmap;

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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3.zw).xyz);
  lowp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = (((tmpvar_6.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  lowp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_11;
    tmpvar_11 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_2), viewDirection) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_12;
    tmpvar_12 = (((tmpvar_6.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_11, _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = binormalDirection;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
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
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = (paintColor * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
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
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = (((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_8), 0.0, 1.0)) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (tmpvar_20 * _FlakePower));
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * _World2Object).xyz);
  tmpvar_3 = tmpvar_9;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  tmpvar_4.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((_Object2World * _glesVertex) - tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((_Object2World * tmpvar_13).xyz);
  tmpvar_7 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 0.0;
  tmpvar_15.xyz = tmpvar_1;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * tmpvar_15).xyz;
  tmpvar_6 = tmpvar_16;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_10 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_10.zw;
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
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
uniform sampler2D unity_Lightmap;

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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (unity_Lightmap, xlv_TEXCOORD3.zw);
  lowp vec3 tmpvar_2;
  tmpvar_2 = ((8.0 * tmpvar_1.w) * tmpvar_1.xyz);
  lowp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_6;
    tmpvar_6 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_6;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_8;
  tmpvar_8 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = (((tmpvar_7.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  lowp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_3), viewDirection) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((tmpvar_7.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = binormalDirection;
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
  lowp vec4 tmpvar_21;
  tmpvar_21 = (paintColor * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  paintColor = tmpvar_21;
  lowp vec3 tmpvar_22;
  tmpvar_22 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_Cube, tmpvar_22);
  reflTex = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = clamp (abs (dot (tmpvar_22, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = pow ((1.0 - tmpvar_24), _FrezFalloff);
  frez = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = (frez * _FrezPow);
  frez = tmpvar_26;
  reflTex.xyz = (tmpvar_23.xyz * clamp ((_Reflection + tmpvar_26), 0.0, 1.0));
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((tmpvar_5.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_9), 0.0, 1.0)) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_27 + (tmpvar_21 * _FlakePower));
  color = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = ((color + reflTex) + (tmpvar_26 * reflTex));
  color = tmpvar_29;
  gl_FragData[0] = tmpvar_29;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 5 [_Object2World]
Matrix 9 [_World2Object]
Vector 15 [unity_LightmapST]
"3.0-!!ARBvp1.0
# 42 ALU
PARAM c[16] = { { 0, 0.5 },
		state.matrix.mvp,
		program.local[5..15] };
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
DP4 R2.w, vertex.position, c[4];
DP4 R2.z, vertex.position, c[3];
DP4 R2.x, vertex.position, c[1];
DP4 R2.y, vertex.position, c[2];
MUL R1.xyz, R2.xyww, c[0].y;
MUL R0.y, R1, c[13].x;
MOV R0.x, R1;
ADD result.texcoord[7].xy, R0, R1.z;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R0.xyz, vertex.normal.x, c[9], R0;
MAD R1.xyz, vertex.normal.z, c[11], R0;
DP4 R0.w, vertex.position, c[8];
DP4 R0.z, vertex.position, c[7];
DP4 R0.x, vertex.position, c[5];
DP4 R0.y, vertex.position, c[6];
MOV result.texcoord[0], R0;
ADD R0.xyz, R0, -c[14];
ADD R1.xyz, R1, c[0].x;
DP3 R1.w, R0, R0;
DP3 R0.w, R1, R1;
RSQ R0.w, R0.w;
RSQ R1.w, R1.w;
MUL result.texcoord[1].xyz, R0.w, R1;
MUL result.texcoord[4].xyz, R1.w, R0;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.position, R2;
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R2;
MOV result.texcoord[2].xyz, c[0].x;
MAD result.texcoord[3].zw, vertex.texcoord[1].xyxy, c[15].xyxy, c[15];
MOV result.texcoord[3].xy, vertex.texcoord[0];
END
# 42 instructions, 3 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_ON" "DIRLIGHTMAP_ON" "SHADOWS_SCREEN" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_LightmapST]
"vs_3_0
; 42 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c16, 0.00000000, 0.50000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_tangent0 v4
mov r1.w, c16.x
mov r1.xyz, v4
dp4 r0.z, r1, c6
dp4 r0.x, r1, c4
dp4 r0.y, r1, c5
dp3 r0.w, r0, r0
rsq r0.w, r0.w
mul o7.xyz, r0.w, r0
dp4 r2.w, v0, c3
dp4 r2.z, v0, c2
dp4 r2.x, v0, c0
dp4 r2.y, v0, c1
mul r1.xyz, r2.xyww, c16.y
mul r0.y, r1, c12.x
mov r0.x, r1
mad o8.xy, r1.z, c13.zwzw, r0
mul r0.xyz, v1.y, c9
mad r0.xyz, v1.x, c8, r0
mad r1.xyz, v1.z, c10, r0
dp4 r0.w, v0, c7
dp4 r0.z, v0, c6
dp4 r0.x, v0, c4
dp4 r0.y, v0, c5
mov o1, r0
add r0.xyz, r0, -c14
add r1.xyz, r1, c16.x
dp3 r1.w, r0, r0
dp3 r0.w, r1, r1
rsq r0.w, r0.w
rsq r1.w, r1.w
mul o2.xyz, r0.w, r1
mul o5.xyz, r1.w, r0
mov r0.w, c16.x
mov r0.xyz, v1
mov o0, r2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r2
mov o3.xyz, c16.x
mad o4.zw, v3.xyxy, c15.xyxy, c15
mov o4.xy, v2
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
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * _World2Object).xyz);
  tmpvar_3 = tmpvar_9;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  tmpvar_4.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((_Object2World * _glesVertex) - tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((_Object2World * tmpvar_13).xyz);
  tmpvar_7 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 0.0;
  tmpvar_15.xyz = tmpvar_1;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * tmpvar_15).xyz;
  tmpvar_6 = tmpvar_16;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_10 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_10.zw;
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
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
uniform sampler2D unity_Lightmap;

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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3.zw).xyz);
  lowp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = (((tmpvar_6.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  lowp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_11;
    tmpvar_11 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_2), viewDirection) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_12;
    tmpvar_12 = (((tmpvar_6.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_11, _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = binormalDirection;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
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
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = (paintColor * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
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
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = (((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_8), 0.0, 1.0)) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (tmpvar_20 * _FlakePower));
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump vec4 unity_LightmapST;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_4;
  lowp vec3 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8.w = 0.0;
  tmpvar_8.xyz = tmpvar_1;
  highp vec3 tmpvar_9;
  tmpvar_9 = normalize ((tmpvar_8 * _World2Object).xyz);
  tmpvar_3 = tmpvar_9;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  tmpvar_4.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_10;
  tmpvar_10 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize (((_Object2World * _glesVertex) - tmpvar_11).xyz);
  tmpvar_5 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 0.0;
  tmpvar_13.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize ((_Object2World * tmpvar_13).xyz);
  tmpvar_7 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15.w = 0.0;
  tmpvar_15.xyz = tmpvar_1;
  highp vec3 tmpvar_16;
  tmpvar_16 = (_Object2World * tmpvar_15).xyz;
  tmpvar_6 = tmpvar_16;
  highp vec4 o_i0;
  highp vec4 tmpvar_17;
  tmpvar_17 = (tmpvar_10 * 0.5);
  o_i0 = tmpvar_17;
  highp vec2 tmpvar_18;
  tmpvar_18.x = tmpvar_17.x;
  tmpvar_18.y = (tmpvar_17.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_18 + tmpvar_17.w);
  o_i0.zw = tmpvar_10.zw;
  gl_Position = tmpvar_10;
  xlv_TEXCOORD0 = (_Object2World * _glesVertex);
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = vec3(0.0, 0.0, 0.0);
  xlv_TEXCOORD3 = tmpvar_4;
  xlv_TEXCOORD4 = tmpvar_5;
  xlv_TEXCOORD5 = tmpvar_6;
  xlv_TEXCOORD6 = tmpvar_7;
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
uniform sampler2D unity_Lightmap;

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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (unity_Lightmap, xlv_TEXCOORD3.zw);
  lowp vec3 tmpvar_2;
  tmpvar_2 = ((8.0 * tmpvar_1.w) * tmpvar_1.xyz);
  lowp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_6;
    tmpvar_6 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_6;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_8;
  tmpvar_8 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = (((tmpvar_7.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  lowp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_3), viewDirection) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((tmpvar_7.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = binormalDirection;
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
  lowp vec4 tmpvar_21;
  tmpvar_21 = (paintColor * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  paintColor = tmpvar_21;
  lowp vec3 tmpvar_22;
  tmpvar_22 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_Cube, tmpvar_22);
  reflTex = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = clamp (abs (dot (tmpvar_22, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = pow ((1.0 - tmpvar_24), _FrezFalloff);
  frez = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = (frez * _FrezPow);
  frez = tmpvar_26;
  reflTex.xyz = (tmpvar_23.xyz * clamp ((_Reflection + tmpvar_26), 0.0, 1.0));
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((tmpvar_5.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_9), 0.0, 1.0)) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_27 + (tmpvar_21 * _FlakePower));
  color = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = ((color + reflTex) + (tmpvar_26 * reflTex));
  color = tmpvar_29;
  gl_FragData[0] = tmpvar_29;
}



#endif"
}

SubProgram "opengl " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
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
Vector 22 [unity_LightmapST]
Vector 23 [_Color]
"3.0-!!ARBvp1.0
# 99 ALU
PARAM c[24] = { { 0, 1 },
		state.matrix.mvp,
		program.local[5..23] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R2.xyz, vertex.normal.x, c[9], R0;
MAD R2.xyz, vertex.normal.z, c[11], R2;
ADD R2.xyz, R2, c[0].x;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R2;
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
MOV R1.x, c[14];
MOV R1.z, c[16].x;
MOV R1.y, c[15].x;
ADD R1.xyz, -R0, R1;
DP3 R1.w, R1, R1;
RSQ R2.w, R1.w;
MUL R1.xyz, R2.w, R1;
DP3 R0.w, R2, R1;
MUL R1.w, R1, c[17].x;
ADD R1.x, R1.w, c[0].y;
RCP R1.w, R1.x;
MUL R3.xyz, R1.w, c[18];
MAX R0.w, R0, c[0].x;
MUL R3.xyz, R3, c[23];
MUL R3.xyz, R3, R0.w;
MOV R1.x, c[14].y;
MOV R1.z, c[16].y;
MOV R1.y, c[15];
ADD R1.xyz, -R0, R1;
DP3 R1.w, R1, R1;
RSQ R2.w, R1.w;
MUL R1.xyz, R2.w, R1;
DP3 R1.y, R2, R1;
MUL R0.w, R1, c[17].y;
ADD R0.w, R0, c[0].y;
RCP R1.x, R0.w;
MUL R4.xyz, R1.x, c[19];
MAX R0.w, R1.y, c[0].x;
MUL R4.xyz, R4, c[23];
MUL R4.xyz, R4, R0.w;
ADD R3.xyz, R3, R4;
MOV R1.x, c[14].z;
MOV R1.z, c[16];
MOV R1.y, c[15].z;
ADD R1.xyz, -R0, R1;
DP3 R0.w, R1, R1;
RSQ R1.w, R0.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.y, R2, R1;
MUL R0.w, R0, c[17].z;
ADD R0.w, R0, c[0].y;
RCP R1.x, R0.w;
MUL R4.xyz, R1.x, c[20];
MAX R0.w, R1.y, c[0].x;
MUL R4.xyz, R4, c[23];
MUL R4.xyz, R4, R0.w;
ADD R4.xyz, R3, R4;
MOV R1.x, c[14].w;
MOV R1.z, c[16].w;
MOV R1.y, c[15].w;
ADD R1.xyz, -R0, R1;
DP3 R0.w, R1, R1;
RSQ R1.w, R0.w;
MUL R1.xyz, R1.w, R1;
MUL R0.w, R0, c[17];
MOV R1.w, c[0].x;
DP3 R1.y, R2, R1;
ADD R0.w, R0, c[0].y;
RCP R1.x, R0.w;
MAX R0.w, R1.y, c[0].x;
MUL R3.xyz, R1.x, c[21];
MOV R1.xyz, vertex.attrib[14];
DP4 R5.z, R1, c[7];
DP4 R5.x, R1, c[5];
DP4 R5.y, R1, c[6];
MUL R1.xyz, R3, c[23];
MUL R1.xyz, R1, R0.w;
DP3 R1.w, R5, R5;
RSQ R0.w, R1.w;
ADD result.texcoord[2].xyz, R4, R1;
ADD R1.xyz, R0, -c[13];
MUL result.texcoord[6].xyz, R0.w, R5;
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
DP3 R1.w, R1, R1;
RSQ R0.x, R1.w;
MUL result.texcoord[4].xyz, R0.x, R1;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[1].xyz, R2;
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MAD result.texcoord[3].zw, vertex.texcoord[1].xyxy, c[22].xyxy, c[22];
MOV result.texcoord[3].xy, vertex.texcoord[0];
DP4 result.position.w, vertex.position, c[4];
DP4 result.position.z, vertex.position, c[3];
DP4 result.position.y, vertex.position, c[2];
DP4 result.position.x, vertex.position, c[1];
END
# 99 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_OFF" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
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
Vector 21 [unity_LightmapST]
Vector 22 [_Color]
"vs_3_0
; 99 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
def c23, 0.00000000, 1.00000000, 0, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_tangent0 v4
mul r0.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r0
mad r2.xyz, v1.z, c10, r2
add r2.xyz, r2, c23.x
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul r2.xyz, r0.w, r2
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.x, c13
mov r1.z, c15.x
mov r1.y, c14.x
add r1.xyz, -r0, r1
dp3 r1.w, r1, r1
rsq r2.w, r1.w
mul r1.xyz, r2.w, r1
dp3 r0.w, r2, r1
mul r1.w, r1, c16.x
add r1.x, r1.w, c23.y
rcp r1.w, r1.x
mul r3.xyz, r1.w, c17
max r0.w, r0, c23.x
mul r3.xyz, r3, c22
mul r3.xyz, r3, r0.w
mov r1.x, c13.y
mov r1.z, c15.y
mov r1.y, c14
add r1.xyz, -r0, r1
dp3 r1.w, r1, r1
rsq r2.w, r1.w
mul r1.xyz, r2.w, r1
dp3 r1.y, r2, r1
mul r0.w, r1, c16.y
add r0.w, r0, c23.y
rcp r1.x, r0.w
mul r4.xyz, r1.x, c18
max r0.w, r1.y, c23.x
mul r4.xyz, r4, c22
mul r4.xyz, r4, r0.w
add r3.xyz, r3, r4
mov r1.x, c13.z
mov r1.z, c15
mov r1.y, c14.z
add r1.xyz, -r0, r1
dp3 r0.w, r1, r1
rsq r1.w, r0.w
mul r1.xyz, r1.w, r1
dp3 r1.y, r2, r1
mul r0.w, r0, c16.z
add r0.w, r0, c23.y
rcp r1.x, r0.w
mul r4.xyz, r1.x, c19
max r0.w, r1.y, c23.x
mul r4.xyz, r4, c22
mul r4.xyz, r4, r0.w
add r4.xyz, r3, r4
mov r1.x, c13.w
mov r1.z, c15.w
mov r1.y, c14.w
add r1.xyz, -r0, r1
dp3 r0.w, r1, r1
rsq r1.w, r0.w
mul r1.xyz, r1.w, r1
mul r0.w, r0, c16
mov r1.w, c23.x
dp3 r1.y, r2, r1
add r0.w, r0, c23.y
rcp r1.x, r0.w
max r0.w, r1.y, c23.x
mul r3.xyz, r1.x, c20
mov r1.xyz, v4
dp4 r5.z, r1, c6
dp4 r5.x, r1, c4
dp4 r5.y, r1, c5
mul r1.xyz, r3, c22
mul r1.xyz, r1, r0.w
dp3 r1.w, r5, r5
rsq r0.w, r1.w
add o3.xyz, r4, r1
add r1.xyz, r0, -c12
mul o7.xyz, r0.w, r5
dp4 r0.w, v0, c7
mov o1, r0
dp3 r1.w, r1, r1
rsq r0.x, r1.w
mul o5.xyz, r0.x, r1
mov r0.w, c23.x
mov r0.xyz, v1
mov o2.xyz, r2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mad o4.zw, v3.xyxy, c21.xyxy, c21
mov o4.xy, v2
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
uniform mediump vec4 unity_LightmapST;
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
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (_Object2World * _glesVertex);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 0.0;
  tmpvar_10.xyz = tmpvar_1;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((tmpvar_10 * _World2Object).xyz);
  tmpvar_3 = tmpvar_11;
  tmpvar_5.xy = _glesMultiTexCoord0.xy;
  tmpvar_5.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (((_Object2World * _glesVertex) - tmpvar_12).xyz);
  tmpvar_6 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_Object2World * tmpvar_14).xyz);
  tmpvar_8 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 0.0;
  tmpvar_16.xyz = tmpvar_1;
  highp vec3 tmpvar_17;
  tmpvar_17 = (_Object2World * tmpvar_16).xyz;
  tmpvar_7 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.x = unity_4LightPosX0.x;
  tmpvar_18.y = unity_4LightPosY0.x;
  tmpvar_18.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_21;
  tmpvar_21 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_20))));
  attenuation = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_23;
  tmpvar_23 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_22);
  diffuseReflection = tmpvar_23;
  tmpvar_4 = diffuseReflection;
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.x = unity_4LightPosX0.y;
  tmpvar_24.y = unity_4LightPosY0.y;
  tmpvar_24.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_27;
  tmpvar_27 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_26))));
  attenuation = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_29;
  tmpvar_29 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_28);
  diffuseReflection = tmpvar_29;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.x = unity_4LightPosX0.z;
  tmpvar_30.y = unity_4LightPosY0.z;
  tmpvar_30.z = unity_4LightPosZ0.z;
  lightPosition = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_33;
  tmpvar_33 = (1.0/((1.0 + (unity_4LightAtten0.z * tmpvar_32))));
  attenuation = tmpvar_33;
  lowp float tmpvar_34;
  tmpvar_34 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_35;
  tmpvar_35 = (((attenuation * unity_LightColor[2].xyz) * _Color.xyz) * tmpvar_34);
  diffuseReflection = tmpvar_35;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.x = unity_4LightPosX0.w;
  tmpvar_36.y = unity_4LightPosY0.w;
  tmpvar_36.z = unity_4LightPosZ0.w;
  lightPosition = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_37;
  lowp float tmpvar_38;
  tmpvar_38 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_39;
  tmpvar_39 = (1.0/((1.0 + (unity_4LightAtten0.w * tmpvar_38))));
  attenuation = tmpvar_39;
  lowp float tmpvar_40;
  tmpvar_40 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_41;
  tmpvar_41 = (((attenuation * unity_LightColor[3].xyz) * _Color.xyz) * tmpvar_40);
  diffuseReflection = tmpvar_41;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_9;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = tmpvar_8;
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
uniform sampler2D unity_Lightmap;

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
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3.zw).xyz);
  lowp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_6;
  tmpvar_6 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_6;
  lowp vec3 tmpvar_7;
  tmpvar_7 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  lowp vec3 tmpvar_8;
  tmpvar_8 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_8;
  lowp float tmpvar_9;
  tmpvar_9 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_9 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_10;
    tmpvar_10 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_2), viewDirection) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_11;
    tmpvar_11 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_10, _Shininess));
    specularReflection = tmpvar_11;
  };
  mediump vec3 tmpvar_12;
  tmpvar_12 = (specularReflection * _Gloss);
  specularReflection = tmpvar_12;
  lowp mat3 tmpvar_13;
  tmpvar_13[0] = xlv_TEXCOORD6;
  tmpvar_13[1] = binormalDirection;
  tmpvar_13[2] = xlv_TEXCOORD5;
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
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
  lowp float tmpvar_16;
  tmpvar_16 = clamp (dot (normalize ((tmpvar_15 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_17;
  tmpvar_17 = (tmpvar_16 * tmpvar_16);
  mediump vec4 tmpvar_18;
  tmpvar_18 = (pow (tmpvar_17, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = (paintColor * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  paintColor = tmpvar_19;
  lowp vec3 tmpvar_20;
  tmpvar_20 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_21;
  tmpvar_21 = textureCube (_Cube, tmpvar_20);
  reflTex = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = clamp (abs (dot (tmpvar_20, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_23;
  tmpvar_23 = pow ((1.0 - tmpvar_22), _FrezFalloff);
  frez = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = (frez * _FrezPow);
  frez = tmpvar_24;
  reflTex.xyz = (tmpvar_21.xyz * clamp ((_Reflection + tmpvar_24), 0.0, 1.0));
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = (((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_7), 0.0, 1.0)) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_26;
  tmpvar_26 = (tmpvar_25 + (tmpvar_19 * _FlakePower));
  color = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = ((color + reflTex) + (tmpvar_24 * reflTex));
  color = tmpvar_27;
  gl_FragData[0] = tmpvar_27;
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
uniform mediump vec4 unity_LightmapST;
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
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (_Object2World * _glesVertex);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 0.0;
  tmpvar_10.xyz = tmpvar_1;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((tmpvar_10 * _World2Object).xyz);
  tmpvar_3 = tmpvar_11;
  tmpvar_5.xy = _glesMultiTexCoord0.xy;
  tmpvar_5.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize (((_Object2World * _glesVertex) - tmpvar_12).xyz);
  tmpvar_6 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 0.0;
  tmpvar_14.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize ((_Object2World * tmpvar_14).xyz);
  tmpvar_8 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16.w = 0.0;
  tmpvar_16.xyz = tmpvar_1;
  highp vec3 tmpvar_17;
  tmpvar_17 = (_Object2World * tmpvar_16).xyz;
  tmpvar_7 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.x = unity_4LightPosX0.x;
  tmpvar_18.y = unity_4LightPosY0.x;
  tmpvar_18.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_18;
  highp vec3 tmpvar_19;
  tmpvar_19 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_19;
  lowp float tmpvar_20;
  tmpvar_20 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_21;
  tmpvar_21 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_20))));
  attenuation = tmpvar_21;
  lowp float tmpvar_22;
  tmpvar_22 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_23;
  tmpvar_23 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_22);
  diffuseReflection = tmpvar_23;
  tmpvar_4 = diffuseReflection;
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.x = unity_4LightPosX0.y;
  tmpvar_24.y = unity_4LightPosY0.y;
  tmpvar_24.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_27;
  tmpvar_27 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_26))));
  attenuation = tmpvar_27;
  lowp float tmpvar_28;
  tmpvar_28 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_29;
  tmpvar_29 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_28);
  diffuseReflection = tmpvar_29;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.x = unity_4LightPosX0.z;
  tmpvar_30.y = unity_4LightPosY0.z;
  tmpvar_30.z = unity_4LightPosZ0.z;
  lightPosition = tmpvar_30;
  highp vec3 tmpvar_31;
  tmpvar_31 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_31;
  lowp float tmpvar_32;
  tmpvar_32 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_33;
  tmpvar_33 = (1.0/((1.0 + (unity_4LightAtten0.z * tmpvar_32))));
  attenuation = tmpvar_33;
  lowp float tmpvar_34;
  tmpvar_34 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_35;
  tmpvar_35 = (((attenuation * unity_LightColor[2].xyz) * _Color.xyz) * tmpvar_34);
  diffuseReflection = tmpvar_35;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.x = unity_4LightPosX0.w;
  tmpvar_36.y = unity_4LightPosY0.w;
  tmpvar_36.z = unity_4LightPosZ0.w;
  lightPosition = tmpvar_36;
  highp vec3 tmpvar_37;
  tmpvar_37 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_37;
  lowp float tmpvar_38;
  tmpvar_38 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_39;
  tmpvar_39 = (1.0/((1.0 + (unity_4LightAtten0.w * tmpvar_38))));
  attenuation = tmpvar_39;
  lowp float tmpvar_40;
  tmpvar_40 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_41;
  tmpvar_41 = (((attenuation * unity_LightColor[3].xyz) * _Color.xyz) * tmpvar_40);
  diffuseReflection = tmpvar_41;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  gl_Position = (gl_ModelViewProjectionMatrix * _glesVertex);
  xlv_TEXCOORD0 = tmpvar_9;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = tmpvar_8;
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
uniform sampler2D unity_Lightmap;

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
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (unity_Lightmap, xlv_TEXCOORD3.zw);
  lowp vec3 tmpvar_2;
  tmpvar_2 = ((8.0 * tmpvar_1.w) * tmpvar_1.xyz);
  lowp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_6;
    tmpvar_6 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_6;
    lightDirection = normalize (vertexToLightSource);
  };
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = ((_LightColor0.xyz * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  lowp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_11;
    tmpvar_11 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_3), viewDirection) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_12;
    tmpvar_12 = ((_LightColor0.xyz * _SpecColor.xyz) * pow (tmpvar_11, _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = binormalDirection;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
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
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = (paintColor * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
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
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = (((tmpvar_5.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_8), 0.0, 1.0)) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (tmpvar_20 * _FlakePower));
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
Bind "texcoord1" TexCoord1
Bind "tangent" ATTR14
Vector 13 [_ProjectionParams]
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
Vector 23 [unity_LightmapST]
Vector 24 [_Color]
"3.0-!!ARBvp1.0
# 104 ALU
PARAM c[25] = { { 0, 1, 0.5 },
		state.matrix.mvp,
		program.local[5..24] };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
TEMP R5;
MUL R0.xyz, vertex.normal.y, c[10];
MAD R2.xyz, vertex.normal.x, c[9], R0;
MAD R2.xyz, vertex.normal.z, c[11], R2;
ADD R2.xyz, R2, c[0].x;
DP3 R0.w, R2, R2;
RSQ R0.w, R0.w;
MUL R2.xyz, R0.w, R2;
DP4 R0.z, vertex.position, c[7];
DP4 R0.y, vertex.position, c[6];
DP4 R0.x, vertex.position, c[5];
MOV R1.x, c[15];
MOV R1.z, c[17].x;
MOV R1.y, c[16].x;
ADD R1.xyz, -R0, R1;
DP3 R1.w, R1, R1;
RSQ R2.w, R1.w;
MUL R1.xyz, R2.w, R1;
DP3 R0.w, R2, R1;
MUL R1.w, R1, c[18].x;
ADD R1.x, R1.w, c[0].y;
RCP R1.w, R1.x;
MUL R3.xyz, R1.w, c[19];
MAX R0.w, R0, c[0].x;
MUL R3.xyz, R3, c[24];
MUL R3.xyz, R3, R0.w;
MOV R1.x, c[15].y;
MOV R1.z, c[17].y;
MOV R1.y, c[16];
ADD R1.xyz, -R0, R1;
DP3 R1.w, R1, R1;
RSQ R2.w, R1.w;
MUL R1.xyz, R2.w, R1;
DP3 R1.y, R2, R1;
MUL R0.w, R1, c[18].y;
ADD R0.w, R0, c[0].y;
RCP R1.x, R0.w;
MUL R4.xyz, R1.x, c[20];
MAX R0.w, R1.y, c[0].x;
MUL R4.xyz, R4, c[24];
MUL R4.xyz, R4, R0.w;
ADD R3.xyz, R3, R4;
MOV R1.x, c[15].z;
MOV R1.z, c[17];
MOV R1.y, c[16].z;
ADD R1.xyz, -R0, R1;
DP3 R0.w, R1, R1;
RSQ R1.w, R0.w;
MUL R1.xyz, R1.w, R1;
DP3 R1.y, R2, R1;
MUL R0.w, R0, c[18].z;
ADD R0.w, R0, c[0].y;
RCP R1.x, R0.w;
MUL R4.xyz, R1.x, c[21];
MAX R0.w, R1.y, c[0].x;
MUL R4.xyz, R4, c[24];
MUL R4.xyz, R4, R0.w;
ADD R4.xyz, R3, R4;
MOV R1.x, c[15].w;
MOV R1.z, c[17].w;
MOV R1.y, c[16].w;
ADD R1.xyz, -R0, R1;
DP3 R0.w, R1, R1;
MUL R1.w, R0, c[18];
RSQ R0.w, R0.w;
MUL R1.xyz, R0.w, R1;
ADD R1.w, R1, c[0].y;
RCP R0.w, R1.w;
DP3 R1.w, R2, R1;
MUL R1.xyz, R0.w, c[22];
MAX R0.w, R1, c[0].x;
MUL R1.xyz, R1, c[24];
MUL R3.xyz, R1, R0.w;
MOV R1.xyz, vertex.attrib[14];
MOV R1.w, c[0].x;
DP4 R5.z, R1, c[7];
DP4 R5.x, R1, c[5];
DP4 R5.y, R1, c[6];
DP3 R0.w, R5, R5;
RSQ R0.w, R0.w;
MUL result.texcoord[6].xyz, R0.w, R5;
DP4 R0.w, vertex.position, c[8];
MOV result.texcoord[0], R0;
DP4 R1.w, vertex.position, c[4];
DP4 R1.z, vertex.position, c[3];
DP4 R1.x, vertex.position, c[1];
DP4 R1.y, vertex.position, c[2];
ADD result.texcoord[2].xyz, R4, R3;
MUL R3.xyz, R1.xyww, c[0].z;
MUL R3.y, R3, c[13].x;
ADD result.texcoord[7].xy, R3, R3.z;
ADD R3.xyz, R0, -c[14];
MOV result.position, R1;
DP3 R1.x, R3, R3;
RSQ R0.x, R1.x;
MUL result.texcoord[4].xyz, R0.x, R3;
MOV R0.w, c[0].x;
MOV R0.xyz, vertex.normal;
MOV result.texcoord[1].xyz, R2;
DP4 result.texcoord[5].z, R0, c[7];
DP4 result.texcoord[5].y, R0, c[6];
DP4 result.texcoord[5].x, R0, c[5];
MOV result.texcoord[7].zw, R1;
MAD result.texcoord[3].zw, vertex.texcoord[1].xyxy, c[23].xyxy, c[23];
MOV result.texcoord[3].xy, vertex.texcoord[0];
END
# 104 instructions, 6 R-regs
"
}

SubProgram "d3d9 " {
Keywords { "DIRECTIONAL" "LIGHTMAP_OFF" "DIRLIGHTMAP_OFF" "SHADOWS_SCREEN" "VERTEXLIGHT_ON" }
Bind "vertex" Vertex
Bind "normal" Normal
Bind "texcoord" TexCoord0
Bind "texcoord1" TexCoord1
Bind "tangent" TexCoord2
Matrix 0 [glstate_matrix_mvp]
Vector 12 [_ProjectionParams]
Vector 13 [_ScreenParams]
Vector 14 [_WorldSpaceCameraPos]
Matrix 4 [_Object2World]
Matrix 8 [_World2Object]
Vector 15 [unity_4LightPosX0]
Vector 16 [unity_4LightPosY0]
Vector 17 [unity_4LightPosZ0]
Vector 18 [unity_4LightAtten0]
Vector 19 [unity_LightColor0]
Vector 20 [unity_LightColor1]
Vector 21 [unity_LightColor2]
Vector 22 [unity_LightColor3]
Vector 23 [unity_LightmapST]
Vector 24 [_Color]
"vs_3_0
; 104 ALU
dcl_position o0
dcl_texcoord0 o1
dcl_texcoord1 o2
dcl_texcoord2 o3
dcl_texcoord3 o4
dcl_texcoord4 o5
dcl_texcoord5 o6
dcl_texcoord6 o7
dcl_texcoord7 o8
def c25, 0.00000000, 1.00000000, 0.50000000, 0
dcl_position0 v0
dcl_normal0 v1
dcl_texcoord0 v2
dcl_texcoord1 v3
dcl_tangent0 v4
mul r0.xyz, v1.y, c9
mad r2.xyz, v1.x, c8, r0
mad r2.xyz, v1.z, c10, r2
add r2.xyz, r2, c25.x
dp3 r0.w, r2, r2
rsq r0.w, r0.w
mul r2.xyz, r0.w, r2
dp4 r0.z, v0, c6
dp4 r0.y, v0, c5
dp4 r0.x, v0, c4
mov r1.x, c15
mov r1.z, c17.x
mov r1.y, c16.x
add r1.xyz, -r0, r1
dp3 r1.w, r1, r1
rsq r2.w, r1.w
mul r1.xyz, r2.w, r1
dp3 r0.w, r2, r1
mul r1.w, r1, c18.x
add r1.x, r1.w, c25.y
rcp r1.w, r1.x
mul r3.xyz, r1.w, c19
max r0.w, r0, c25.x
mul r3.xyz, r3, c24
mul r3.xyz, r3, r0.w
mov r1.x, c15.y
mov r1.z, c17.y
mov r1.y, c16
add r1.xyz, -r0, r1
dp3 r1.w, r1, r1
rsq r2.w, r1.w
mul r1.xyz, r2.w, r1
dp3 r1.y, r2, r1
mul r0.w, r1, c18.y
add r0.w, r0, c25.y
rcp r1.x, r0.w
mul r4.xyz, r1.x, c20
max r0.w, r1.y, c25.x
mul r4.xyz, r4, c24
mul r4.xyz, r4, r0.w
add r3.xyz, r3, r4
mov r1.x, c15.z
mov r1.z, c17
mov r1.y, c16.z
add r1.xyz, -r0, r1
dp3 r0.w, r1, r1
rsq r1.w, r0.w
mul r1.xyz, r1.w, r1
dp3 r1.y, r2, r1
mul r0.w, r0, c18.z
add r0.w, r0, c25.y
rcp r1.x, r0.w
mul r4.xyz, r1.x, c21
max r0.w, r1.y, c25.x
mul r4.xyz, r4, c24
mul r4.xyz, r4, r0.w
add r4.xyz, r3, r4
mov r1.x, c15.w
mov r1.z, c17.w
mov r1.y, c16.w
add r1.xyz, -r0, r1
dp3 r0.w, r1, r1
mul r1.w, r0, c18
rsq r0.w, r0.w
mul r1.xyz, r0.w, r1
add r1.w, r1, c25.y
rcp r0.w, r1.w
dp3 r1.w, r2, r1
mul r1.xyz, r0.w, c22
max r0.w, r1, c25.x
mul r1.xyz, r1, c24
mul r3.xyz, r1, r0.w
mov r1.xyz, v4
mov r1.w, c25.x
dp4 r5.z, r1, c6
dp4 r5.x, r1, c4
dp4 r5.y, r1, c5
dp3 r0.w, r5, r5
rsq r0.w, r0.w
mul o7.xyz, r0.w, r5
dp4 r0.w, v0, c7
mov o1, r0
dp4 r1.w, v0, c3
dp4 r1.z, v0, c2
dp4 r1.x, v0, c0
dp4 r1.y, v0, c1
add o3.xyz, r4, r3
mul r3.xyz, r1.xyww, c25.z
mul r3.y, r3, c12.x
mad o8.xy, r3.z, c13.zwzw, r3
add r3.xyz, r0, -c14
mov o0, r1
dp3 r1.x, r3, r3
rsq r0.x, r1.x
mul o5.xyz, r0.x, r3
mov r0.w, c25.x
mov r0.xyz, v1
mov o2.xyz, r2
dp4 o6.z, r0, c6
dp4 o6.y, r0, c5
dp4 o6.x, r0, c4
mov o8.zw, r1
mad o4.zw, v3.xyxy, c23.xyxy, c23
mov o4.xy, v2
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
uniform mediump vec4 unity_LightmapST;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform lowp vec4 _Color;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (_Object2World * _glesVertex);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 0.0;
  tmpvar_10.xyz = tmpvar_1;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((tmpvar_10 * _World2Object).xyz);
  tmpvar_3 = tmpvar_11;
  tmpvar_5.xy = _glesMultiTexCoord0.xy;
  tmpvar_5.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_12;
  tmpvar_12 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (((_Object2World * _glesVertex) - tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 0.0;
  tmpvar_15.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize ((_Object2World * tmpvar_15).xyz);
  tmpvar_8 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 0.0;
  tmpvar_17.xyz = tmpvar_1;
  highp vec3 tmpvar_18;
  tmpvar_18 = (_Object2World * tmpvar_17).xyz;
  tmpvar_7 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.x = unity_4LightPosX0.x;
  tmpvar_19.y = unity_4LightPosY0.x;
  tmpvar_19.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_20;
  lowp float tmpvar_21;
  tmpvar_21 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_22;
  tmpvar_22 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_21))));
  attenuation = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_24;
  tmpvar_24 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_23);
  diffuseReflection = tmpvar_24;
  tmpvar_4 = diffuseReflection;
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.x = unity_4LightPosX0.y;
  tmpvar_25.y = unity_4LightPosY0.y;
  tmpvar_25.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_28;
  tmpvar_28 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_27))));
  attenuation = tmpvar_28;
  lowp float tmpvar_29;
  tmpvar_29 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_30;
  tmpvar_30 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_29);
  diffuseReflection = tmpvar_30;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.x = unity_4LightPosX0.z;
  tmpvar_31.y = unity_4LightPosY0.z;
  tmpvar_31.z = unity_4LightPosZ0.z;
  lightPosition = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_32;
  lowp float tmpvar_33;
  tmpvar_33 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_34;
  tmpvar_34 = (1.0/((1.0 + (unity_4LightAtten0.z * tmpvar_33))));
  attenuation = tmpvar_34;
  lowp float tmpvar_35;
  tmpvar_35 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_36;
  tmpvar_36 = (((attenuation * unity_LightColor[2].xyz) * _Color.xyz) * tmpvar_35);
  diffuseReflection = tmpvar_36;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_37;
  tmpvar_37.w = 1.0;
  tmpvar_37.x = unity_4LightPosX0.w;
  tmpvar_37.y = unity_4LightPosY0.w;
  tmpvar_37.z = unity_4LightPosZ0.w;
  lightPosition = tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_38 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_38;
  lowp float tmpvar_39;
  tmpvar_39 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_40;
  tmpvar_40 = (1.0/((1.0 + (unity_4LightAtten0.w * tmpvar_39))));
  attenuation = tmpvar_40;
  lowp float tmpvar_41;
  tmpvar_41 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_42;
  tmpvar_42 = (((attenuation * unity_LightColor[3].xyz) * _Color.xyz) * tmpvar_41);
  diffuseReflection = tmpvar_42;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 o_i0;
  highp vec4 tmpvar_43;
  tmpvar_43 = (tmpvar_12 * 0.5);
  o_i0 = tmpvar_43;
  highp vec2 tmpvar_44;
  tmpvar_44.x = tmpvar_43.x;
  tmpvar_44.y = (tmpvar_43.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_44 + tmpvar_43.w);
  o_i0.zw = tmpvar_12.zw;
  gl_Position = tmpvar_12;
  xlv_TEXCOORD0 = tmpvar_9;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = tmpvar_8;
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
uniform sampler2D unity_Lightmap;

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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec3 tmpvar_1;
  tmpvar_1 = (2.0 * texture2D (unity_Lightmap, xlv_TEXCOORD3.zw).xyz);
  lowp vec3 tmpvar_2;
  tmpvar_2 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_3;
  tmpvar_3 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_3;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_5;
    tmpvar_5 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_5;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_6;
  tmpvar_6 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_7;
  tmpvar_7 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_7;
  lowp vec3 tmpvar_8;
  tmpvar_8 = (((tmpvar_6.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_2, lightDirection)));
  lowp vec3 tmpvar_9;
  tmpvar_9 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_9;
  lowp float tmpvar_10;
  tmpvar_10 = dot (tmpvar_2, lightDirection);
  if ((tmpvar_10 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_11;
    tmpvar_11 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_2), viewDirection) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_12;
    tmpvar_12 = (((tmpvar_6.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_11, _Shininess));
    specularReflection = tmpvar_12;
  };
  mediump vec3 tmpvar_13;
  tmpvar_13 = (specularReflection * _Gloss);
  specularReflection = tmpvar_13;
  lowp mat3 tmpvar_14;
  tmpvar_14[0] = xlv_TEXCOORD6;
  tmpvar_14[1] = binormalDirection;
  tmpvar_14[2] = xlv_TEXCOORD5;
  mat3 tmpvar_15;
  tmpvar_15[0].x = tmpvar_14[0].x;
  tmpvar_15[0].y = tmpvar_14[1].x;
  tmpvar_15[0].z = tmpvar_14[2].x;
  tmpvar_15[1].x = tmpvar_14[0].y;
  tmpvar_15[1].y = tmpvar_14[1].y;
  tmpvar_15[1].z = tmpvar_14[2].y;
  tmpvar_15[2].x = tmpvar_14[0].z;
  tmpvar_15[2].y = tmpvar_14[1].z;
  tmpvar_15[2].z = tmpvar_14[2].z;
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
  lowp float tmpvar_17;
  tmpvar_17 = clamp (dot (normalize ((tmpvar_16 * -((((2.0 * texture2D (_SparkleTex, ((xlv_TEXCOORD3.xy * 20.0) * _FlakeScale)).xyz) - 1.0) + (4.0 * vec3(0.0, 0.0, 1.0)))))), normalize (xlv_TEXCOORD4)), 0.0, 1.0);
  lowp float tmpvar_18;
  tmpvar_18 = (tmpvar_17 * tmpvar_17);
  mediump vec4 tmpvar_19;
  tmpvar_19 = (pow (tmpvar_18, _OuterFlakePower) * _paintColor2);
  paintColor = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = (paintColor * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
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
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = (((tmpvar_4.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_8), 0.0, 1.0)) * clamp (dot (tmpvar_1, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_27;
  tmpvar_27 = (tmpvar_26 + (tmpvar_20 * _FlakePower));
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

varying highp vec4 xlv_TEXCOORD7;
varying lowp vec3 xlv_TEXCOORD6;
varying lowp vec3 xlv_TEXCOORD5;
varying lowp vec3 xlv_TEXCOORD4;
varying mediump vec4 xlv_TEXCOORD3;
varying lowp vec3 xlv_TEXCOORD2;
varying lowp vec3 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD0;
uniform mediump vec4 unity_LightmapST;
uniform highp vec4 unity_LightColor[4];
uniform highp vec4 unity_4LightPosZ0;
uniform highp vec4 unity_4LightPosY0;
uniform highp vec4 unity_4LightPosX0;
uniform highp vec4 unity_4LightAtten0;

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp mat4 _World2Object;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 _Object2World;
uniform lowp vec4 _Color;
attribute vec4 _glesTANGENT;
attribute vec4 _glesMultiTexCoord1;
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
  mediump vec4 tmpvar_5;
  lowp vec3 tmpvar_6;
  lowp vec3 tmpvar_7;
  lowp vec3 tmpvar_8;
  highp vec4 tmpvar_9;
  tmpvar_9 = (_Object2World * _glesVertex);
  lowp vec4 tmpvar_10;
  tmpvar_10.w = 0.0;
  tmpvar_10.xyz = tmpvar_1;
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize ((tmpvar_10 * _World2Object).xyz);
  tmpvar_3 = tmpvar_11;
  tmpvar_5.xy = _glesMultiTexCoord0.xy;
  tmpvar_5.zw = ((_glesMultiTexCoord1.xy * unity_LightmapST.xy) + unity_LightmapST.zw);
  highp vec4 tmpvar_12;
  tmpvar_12 = (gl_ModelViewProjectionMatrix * _glesVertex);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = _WorldSpaceCameraPos;
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize (((_Object2World * _glesVertex) - tmpvar_13).xyz);
  tmpvar_6 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 0.0;
  tmpvar_15.xyz = tmpvar_2.xyz;
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize ((_Object2World * tmpvar_15).xyz);
  tmpvar_8 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17.w = 0.0;
  tmpvar_17.xyz = tmpvar_1;
  highp vec3 tmpvar_18;
  tmpvar_18 = (_Object2World * tmpvar_17).xyz;
  tmpvar_7 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.x = unity_4LightPosX0.x;
  tmpvar_19.y = unity_4LightPosY0.x;
  tmpvar_19.z = unity_4LightPosZ0.x;
  lightPosition = tmpvar_19;
  highp vec3 tmpvar_20;
  tmpvar_20 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_20;
  lowp float tmpvar_21;
  tmpvar_21 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_22;
  tmpvar_22 = (1.0/((1.0 + (unity_4LightAtten0.x * tmpvar_21))));
  attenuation = tmpvar_22;
  lowp float tmpvar_23;
  tmpvar_23 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_24;
  tmpvar_24 = (((attenuation * unity_LightColor[0].xyz) * _Color.xyz) * tmpvar_23);
  diffuseReflection = tmpvar_24;
  tmpvar_4 = diffuseReflection;
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.x = unity_4LightPosX0.y;
  tmpvar_25.y = unity_4LightPosY0.y;
  tmpvar_25.z = unity_4LightPosZ0.y;
  lightPosition = tmpvar_25;
  highp vec3 tmpvar_26;
  tmpvar_26 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_26;
  lowp float tmpvar_27;
  tmpvar_27 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_28;
  tmpvar_28 = (1.0/((1.0 + (unity_4LightAtten0.y * tmpvar_27))));
  attenuation = tmpvar_28;
  lowp float tmpvar_29;
  tmpvar_29 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_30;
  tmpvar_30 = (((attenuation * unity_LightColor[1].xyz) * _Color.xyz) * tmpvar_29);
  diffuseReflection = tmpvar_30;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.x = unity_4LightPosX0.z;
  tmpvar_31.y = unity_4LightPosY0.z;
  tmpvar_31.z = unity_4LightPosZ0.z;
  lightPosition = tmpvar_31;
  highp vec3 tmpvar_32;
  tmpvar_32 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_32;
  lowp float tmpvar_33;
  tmpvar_33 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_34;
  tmpvar_34 = (1.0/((1.0 + (unity_4LightAtten0.z * tmpvar_33))));
  attenuation = tmpvar_34;
  lowp float tmpvar_35;
  tmpvar_35 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_36;
  tmpvar_36 = (((attenuation * unity_LightColor[2].xyz) * _Color.xyz) * tmpvar_35);
  diffuseReflection = tmpvar_36;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 tmpvar_37;
  tmpvar_37.w = 1.0;
  tmpvar_37.x = unity_4LightPosX0.w;
  tmpvar_37.y = unity_4LightPosY0.w;
  tmpvar_37.z = unity_4LightPosZ0.w;
  lightPosition = tmpvar_37;
  highp vec3 tmpvar_38;
  tmpvar_38 = (lightPosition - tmpvar_9).xyz;
  vertexToLightSource = tmpvar_38;
  lowp float tmpvar_39;
  tmpvar_39 = dot (vertexToLightSource, vertexToLightSource);
  highp float tmpvar_40;
  tmpvar_40 = (1.0/((1.0 + (unity_4LightAtten0.w * tmpvar_39))));
  attenuation = tmpvar_40;
  lowp float tmpvar_41;
  tmpvar_41 = max (0.0, dot (tmpvar_3, normalize (vertexToLightSource)));
  highp vec3 tmpvar_42;
  tmpvar_42 = (((attenuation * unity_LightColor[3].xyz) * _Color.xyz) * tmpvar_41);
  diffuseReflection = tmpvar_42;
  tmpvar_4 = (tmpvar_4 + diffuseReflection);
  highp vec4 o_i0;
  highp vec4 tmpvar_43;
  tmpvar_43 = (tmpvar_12 * 0.5);
  o_i0 = tmpvar_43;
  highp vec2 tmpvar_44;
  tmpvar_44.x = tmpvar_43.x;
  tmpvar_44.y = (tmpvar_43.y * _ProjectionParams.x);
  o_i0.xy = (tmpvar_44 + tmpvar_43.w);
  o_i0.zw = tmpvar_12.zw;
  gl_Position = tmpvar_12;
  xlv_TEXCOORD0 = tmpvar_9;
  xlv_TEXCOORD1 = tmpvar_3;
  xlv_TEXCOORD2 = tmpvar_4;
  xlv_TEXCOORD3 = tmpvar_5;
  xlv_TEXCOORD4 = tmpvar_6;
  xlv_TEXCOORD5 = tmpvar_7;
  xlv_TEXCOORD6 = tmpvar_8;
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
uniform sampler2D unity_Lightmap;

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
void main ()
{
  lowp vec4 color;
  lowp float frez;
  lowp vec4 reflTex;
  lowp vec4 paintColor;
  lowp vec3 specularReflection;
  highp vec3 binormalDirection;
  lowp vec3 ambientLighting;
  lowp vec3 vertexToLightSource;
  lowp vec3 lightDirection;
  lowp vec3 viewDirection;
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (unity_Lightmap, xlv_TEXCOORD3.zw);
  lowp vec3 tmpvar_2;
  tmpvar_2 = ((8.0 * tmpvar_1.w) * tmpvar_1.xyz);
  lowp vec3 tmpvar_3;
  tmpvar_3 = normalize (xlv_TEXCOORD1);
  highp vec3 tmpvar_4;
  tmpvar_4 = normalize ((_WorldSpaceCameraPos - xlv_TEXCOORD0.xyz));
  viewDirection = tmpvar_4;
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_MainTex, xlv_TEXCOORD3.xy);
  if ((0.0 == _WorldSpaceLightPos0.w)) {
    lightDirection = normalize (_WorldSpaceLightPos0.xyz);
  } else {
    highp vec3 tmpvar_6;
    tmpvar_6 = (_WorldSpaceLightPos0 - xlv_TEXCOORD0).xyz;
    vertexToLightSource = tmpvar_6;
    lightDirection = normalize (vertexToLightSource);
  };
  lowp vec4 tmpvar_7;
  tmpvar_7 = texture2DProj (_ShadowMapTexture, xlv_TEXCOORD7);
  highp vec3 tmpvar_8;
  tmpvar_8 = (gl_LightModel.ambient.xyz * _Color.xyz);
  ambientLighting = tmpvar_8;
  lowp vec3 tmpvar_9;
  tmpvar_9 = (((tmpvar_7.x * _LightColor0.xyz) * _Color.xyz) * max (0.0, dot (tmpvar_3, lightDirection)));
  lowp vec3 tmpvar_10;
  tmpvar_10 = cross (xlv_TEXCOORD1, xlv_TEXCOORD6);
  binormalDirection = tmpvar_10;
  lowp float tmpvar_11;
  tmpvar_11 = dot (tmpvar_3, lightDirection);
  if ((tmpvar_11 < 0.0)) {
    specularReflection = vec3(0.0, 0.0, 0.0);
  } else {
    lowp float tmpvar_12;
    tmpvar_12 = max (0.0, (dot (reflect (-(lightDirection), tmpvar_3), viewDirection) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)));
    mediump vec3 tmpvar_13;
    tmpvar_13 = (((tmpvar_7.x * _LightColor0.xyz) * _SpecColor.xyz) * pow (tmpvar_12, _Shininess));
    specularReflection = tmpvar_13;
  };
  mediump vec3 tmpvar_14;
  tmpvar_14 = (specularReflection * _Gloss);
  specularReflection = tmpvar_14;
  lowp mat3 tmpvar_15;
  tmpvar_15[0] = xlv_TEXCOORD6;
  tmpvar_15[1] = binormalDirection;
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
  lowp vec4 tmpvar_21;
  tmpvar_21 = (paintColor * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  paintColor = tmpvar_21;
  lowp vec3 tmpvar_22;
  tmpvar_22 = reflect (xlv_TEXCOORD4, normalize (xlv_TEXCOORD1));
  lowp vec4 tmpvar_23;
  tmpvar_23 = textureCube (_Cube, tmpvar_22);
  reflTex = tmpvar_23;
  lowp float tmpvar_24;
  tmpvar_24 = clamp (abs (dot (tmpvar_22, xlv_TEXCOORD1)), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = pow ((1.0 - tmpvar_24), _FrezFalloff);
  frez = tmpvar_25;
  lowp float tmpvar_26;
  tmpvar_26 = (frez * _FrezPow);
  frez = tmpvar_26;
  reflTex.xyz = (tmpvar_23.xyz * clamp ((_Reflection + tmpvar_26), 0.0, 1.0));
  reflTex.xyz = (reflTex.xyz * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0));
  lowp vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((tmpvar_5.xyz * clamp (((xlv_TEXCOORD2 + ambientLighting) + tmpvar_9), 0.0, 1.0)) * clamp (dot (tmpvar_2, vec3(0.22, 0.707, 0.071)), 0.0, 1.0)) + specularReflection);
  mediump vec4 tmpvar_28;
  tmpvar_28 = (tmpvar_27 + (tmpvar_21 * _FlakePower));
  color = tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = ((color + reflTex) + (tmpvar_26 * reflTex));
  color = tmpvar_29;
  gl_FragData[0] = tmpvar_29;
}



#endif"
}

}
Program "fp" {
// Fragment combos: 6
//   opengl - ALU: 94 to 95, TEX: 4 to 5
//   d3d9 - ALU: 95 to 95, TEX: 4 to 5
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
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 94 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..14],
		{ 2, 1, 8, 20 },
		{ 0.2199707, 0.70703125, 0.070983887, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.xyz, fragment.texcoord[6];
MUL R1.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R1.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R1;
MOV R2.y, R1.z;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R3.w, R3, R3;
RSQ R3.w, R3.w;
MUL R0.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R0, c[15].w;
MUL R3.xyz, R3.w, R3;
MOV R2.w, c[15].y;
MOV R1.zw, c[17].xyxy;
TEX R0.xyz, R0, texture[2], 2D;
MAD R0.xyz, R0, c[15].x, R1.zzww;
MOV R2.x, fragment.texcoord[6].z;
MOV R2.z, fragment.texcoord[5];
DP3 R1.z, R2, -R0;
MOV R2.y, R1.x;
MOV R2.z, fragment.texcoord[5].x;
MOV R2.x, fragment.texcoord[6];
DP3 R1.x, -R0, R2;
MOV R2.y, R1;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R1.y, -R0, R2;
DP3 R0.x, R1, R1;
DP3 R0.y, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.y;
MUL R2.xyz, R0.w, fragment.texcoord[4];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, R1;
DP3_SAT R0.x, R0, R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
MUL R1.w, R0.x, R0.x;
DP3 R0.y, R1, R1;
RSQ R0.x, R0.y;
MUL R0.xyz, R0.x, R1;
DP3 R0.w, c[2], c[2];
RSQ R1.x, R0.w;
ABS R0.w, -c[2];
CMP R0.w, -R0, c[16], R2;
ABS R2.x, R0.w;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
CMP R2.x, -R2, c[16].w, R2.w;
MUL R1.xyz, R1.x, c[2];
CMP R1.xyz, -R2.x, R0, R1;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, fragment.texcoord[1];
DP3 R0.w, R0, R1;
MUL R2.xyz, R0, -R0.w;
MAD R2.xyz, -R2, c[15].x, -R1;
POW R4.x, R1.w, c[10].x;
TEX R1, fragment.texcoord[3].zwzw, texture[0], 2D;
MUL R1.xyz, R1.w, R1;
DP3 R1.w, R2, R3;
MUL R1.xyz, R1, c[15].z;
DP3_SAT R3.w, R1, c[16];
MUL R2.x, R3.w, R1.w;
MUL R1, R4.x, c[11];
MAX R2.x, R2, c[16].w;
POW R3.y, R2.x, c[6].x;
SLT R3.x, R0.w, c[16].w;
MOV R2.xyz, c[5];
ABS R3.x, R3;
CMP R3.x, -R3, c[16].w, R2.w;
DP3 R2.w, R0, fragment.texcoord[4];
MUL R0.xyz, R0, R2.w;
MUL R2.xyz, R2, c[14];
MUL R2.xyz, R2, R3.y;
CMP R2.xyz, -R3.x, R2, c[16].w;
MUL R4.xyz, R2, c[7].x;
MOV R2.xyz, c[3];
MAD R3.xyz, R2, c[0], fragment.texcoord[2];
MAX R2.w, R0, c[16];
MAD R0.xyz, -R0, c[15].x, fragment.texcoord[4];
DP3 R0.w, R0, fragment.texcoord[1];
MUL R2.xyz, R2, c[14];
MAD_SAT R3.xyz, R2, R2.w, R3;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[15].y;
TEX R2.xyz, fragment.texcoord[3], texture[1], 2D;
MUL R2.xyz, R2, R3;
POW R0.w, R0.w, c[13].x;
MUL R3.x, R0.w, c[12];
TEX R0, R0, texture[3], CUBE;
ADD_SAT R3.y, R3.x, c[4].x;
MUL R0.xyz, R0, R3.y;
MUL R0.xyz, R0, R3.w;
MUL R1, R3.w, R1;
MAD R2.xyz, R3.w, R2, R4;
MOV R2.w, c[15].y;
MAD R1, R1, c[9].x, R2;
ADD R1, R0, R1;
MAD result.color, R3.x, R0, R1;
END
# 94 instructions, 5 R-regs
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
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 95 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c15, 2.00000000, 1.00000000, 8.00000000, 20.00000000
def c16, 0.21997070, 0.70703125, 0.07098389, 0.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0
def c18, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r1.x, r0.w
mul_pp r4.xy, v3, c8.x
mul_pp r4.xy, r4, c15.w
texld r4.xyz, r4, s2
mad_pp r4.xyz, r4, c17.x, c17.yyzw
mul_pp r0.xyz, r1.x, r0
dp3_pp r0.w, c2, c2
rsq_pp r1.x, r0.w
mul_pp r2.xyz, r1.x, c2
dp3_pp r0.w, v1, v1
abs_pp r1.x, -c2.w
cmp_pp r1.xyz, -r1.x, r2, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, v1
dp3_pp r1.w, r0, r1
mul_pp r2.xyz, r0, -r1.w
mad_pp r1.xyz, -r2, c15.x, -r1
add r3.xyz, -v0, c1
dp3 r0.w, r3, r3
texld r2, v3.zwzw, s0
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r1.x, r1, r3
mul_pp r2.xyz, r2.w, r2
mul_pp r2.xyz, r2, c15.z
dp3_pp_sat r0.w, r2, c16
mul_pp r1.x, r0.w, r1
max_pp r1.x, r1, c16.w
pow_pp r2, r1.x, c6.x
mov_pp r2.y, r2.x
cmp_pp r2.x, r1.w, c18, c18.y
mov_pp r1.xyz, c14
mul_pp r1.xyz, c5, r1
mov_pp r3.xyz, v6
mul_pp r3.xyz, v1.zxyw, r3.yzxw
mul_pp r1.xyz, r1, r2.y
abs_pp r2.x, r2
cmp_pp r2.xyz, -r2.x, r1, c16.w
mov_pp r1.xyz, v6
mad_pp r1.xyz, v1.yzxw, r1.zxyw, -r3
mov r3.y, r1.z
mov r3.x, v6.z
mov r3.z, v5
dp3_pp r1.z, r3, -r4
mov r3.y, r1.x
mov r3.z, v5.x
mov r3.x, v6
dp3_pp r1.x, -r4, r3
mov r3.y, r1
mov r3.z, v5.y
mov r3.x, v6.y
dp3_pp r1.y, -r4, r3
mul_pp r4.xyz, r2, c7.x
dp3_pp r2.w, r1, r1
rsq_pp r2.w, r2.w
mul_pp r1.xyz, r2.w, r1
mov_pp r3.xyz, c0
mov_pp r2.xyz, c14
dp3_pp r2.w, v4, v4
max_pp r1.w, r1, c16
mul_pp r2.xyz, c3, r2
mad_pp r3.xyz, c3, r3, v2
mad_pp_sat r3.xyz, r2, r1.w, r3
dp3_pp r1.w, r0, v4
mul_pp r0.xyz, r0, r1.w
texld r2.xyz, v3, s1
mul_pp r2.xyz, r2, r3
rsq_pp r2.w, r2.w
mul_pp r3.xyz, r2.w, v4
dp3_pp_sat r1.y, r1, r3
mad_pp r0.xyz, -r0, c15.x, v4
dp3_pp r1.x, r0, v1
mad_pp r2.xyz, r0.w, r2, r4
mul_pp r3.x, r1.y, r1.y
abs_pp_sat r2.w, r1.x
pow_pp r1, r3.x, c10.x
add_pp r1.y, -r2.w, c15
pow_pp r3, r1.y, c13.x
mov_pp r2.w, r3.x
mul_pp r4.x, r2.w, c12
mul_pp r1, r1.x, c11
mul_pp r3, r0.w, r1
texld r1, r0, s3
add_pp_sat r0.x, r4, c4
mul_pp r0.xyz, r1, r0.x
mul_pp r0.xyz, r0, r0.w
mov_pp r2.w, c15.y
mov_pp r0.w, r1
mad_pp r2, r3, c9.x, r2
add_pp r1, r0, r2
mad_pp oC0, r4.x, r0, r1
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
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 94 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..14],
		{ 2, 1, 8, 20 },
		{ 0.2199707, 0.70703125, 0.070983887, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.xyz, fragment.texcoord[6];
MUL R1.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R1.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R1;
MOV R2.y, R1.z;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R3.w, R3, R3;
RSQ R3.w, R3.w;
MUL R0.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R0, c[15].w;
MUL R3.xyz, R3.w, R3;
MOV R2.w, c[15].y;
MOV R1.zw, c[17].xyxy;
TEX R0.xyz, R0, texture[2], 2D;
MAD R0.xyz, R0, c[15].x, R1.zzww;
MOV R2.x, fragment.texcoord[6].z;
MOV R2.z, fragment.texcoord[5];
DP3 R1.z, R2, -R0;
MOV R2.y, R1.x;
MOV R2.z, fragment.texcoord[5].x;
MOV R2.x, fragment.texcoord[6];
DP3 R1.x, -R0, R2;
MOV R2.y, R1;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R1.y, -R0, R2;
DP3 R0.x, R1, R1;
DP3 R0.y, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.y;
MUL R2.xyz, R0.w, fragment.texcoord[4];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, R1;
DP3_SAT R0.x, R0, R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
MUL R1.w, R0.x, R0.x;
DP3 R0.y, R1, R1;
RSQ R0.x, R0.y;
MUL R0.xyz, R0.x, R1;
DP3 R0.w, c[2], c[2];
RSQ R1.x, R0.w;
ABS R0.w, -c[2];
CMP R0.w, -R0, c[16], R2;
ABS R2.x, R0.w;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
CMP R2.x, -R2, c[16].w, R2.w;
MUL R1.xyz, R1.x, c[2];
CMP R1.xyz, -R2.x, R0, R1;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, fragment.texcoord[1];
DP3 R0.w, R0, R1;
MUL R2.xyz, R0, -R0.w;
MAD R2.xyz, -R2, c[15].x, -R1;
POW R4.x, R1.w, c[10].x;
TEX R1, fragment.texcoord[3].zwzw, texture[0], 2D;
MUL R1.xyz, R1.w, R1;
DP3 R1.w, R2, R3;
MUL R1.xyz, R1, c[15].z;
DP3_SAT R3.w, R1, c[16];
MUL R2.x, R3.w, R1.w;
MUL R1, R4.x, c[11];
MAX R2.x, R2, c[16].w;
POW R3.y, R2.x, c[6].x;
SLT R3.x, R0.w, c[16].w;
MOV R2.xyz, c[5];
ABS R3.x, R3;
CMP R3.x, -R3, c[16].w, R2.w;
DP3 R2.w, R0, fragment.texcoord[4];
MUL R0.xyz, R0, R2.w;
MUL R2.xyz, R2, c[14];
MUL R2.xyz, R2, R3.y;
CMP R2.xyz, -R3.x, R2, c[16].w;
MUL R4.xyz, R2, c[7].x;
MOV R2.xyz, c[3];
MAD R3.xyz, R2, c[0], fragment.texcoord[2];
MAX R2.w, R0, c[16];
MAD R0.xyz, -R0, c[15].x, fragment.texcoord[4];
DP3 R0.w, R0, fragment.texcoord[1];
MUL R2.xyz, R2, c[14];
MAD_SAT R3.xyz, R2, R2.w, R3;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[15].y;
TEX R2.xyz, fragment.texcoord[3], texture[1], 2D;
MUL R2.xyz, R2, R3;
POW R0.w, R0.w, c[13].x;
MUL R3.x, R0.w, c[12];
TEX R0, R0, texture[3], CUBE;
ADD_SAT R3.y, R3.x, c[4].x;
MUL R0.xyz, R0, R3.y;
MUL R0.xyz, R0, R3.w;
MUL R1, R3.w, R1;
MAD R2.xyz, R3.w, R2, R4;
MOV R2.w, c[15].y;
MAD R1, R1, c[9].x, R2;
ADD R1, R0, R1;
MAD result.color, R3.x, R0, R1;
END
# 94 instructions, 5 R-regs
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
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 95 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c15, 2.00000000, 1.00000000, 8.00000000, 20.00000000
def c16, 0.21997070, 0.70703125, 0.07098389, 0.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0
def c18, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r1.x, r0.w
mul_pp r4.xy, v3, c8.x
mul_pp r4.xy, r4, c15.w
texld r4.xyz, r4, s2
mad_pp r4.xyz, r4, c17.x, c17.yyzw
mul_pp r0.xyz, r1.x, r0
dp3_pp r0.w, c2, c2
rsq_pp r1.x, r0.w
mul_pp r2.xyz, r1.x, c2
dp3_pp r0.w, v1, v1
abs_pp r1.x, -c2.w
cmp_pp r1.xyz, -r1.x, r2, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, v1
dp3_pp r1.w, r0, r1
mul_pp r2.xyz, r0, -r1.w
mad_pp r1.xyz, -r2, c15.x, -r1
add r3.xyz, -v0, c1
dp3 r0.w, r3, r3
texld r2, v3.zwzw, s0
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r1.x, r1, r3
mul_pp r2.xyz, r2.w, r2
mul_pp r2.xyz, r2, c15.z
dp3_pp_sat r0.w, r2, c16
mul_pp r1.x, r0.w, r1
max_pp r1.x, r1, c16.w
pow_pp r2, r1.x, c6.x
mov_pp r2.y, r2.x
cmp_pp r2.x, r1.w, c18, c18.y
mov_pp r1.xyz, c14
mul_pp r1.xyz, c5, r1
mov_pp r3.xyz, v6
mul_pp r3.xyz, v1.zxyw, r3.yzxw
mul_pp r1.xyz, r1, r2.y
abs_pp r2.x, r2
cmp_pp r2.xyz, -r2.x, r1, c16.w
mov_pp r1.xyz, v6
mad_pp r1.xyz, v1.yzxw, r1.zxyw, -r3
mov r3.y, r1.z
mov r3.x, v6.z
mov r3.z, v5
dp3_pp r1.z, r3, -r4
mov r3.y, r1.x
mov r3.z, v5.x
mov r3.x, v6
dp3_pp r1.x, -r4, r3
mov r3.y, r1
mov r3.z, v5.y
mov r3.x, v6.y
dp3_pp r1.y, -r4, r3
mul_pp r4.xyz, r2, c7.x
dp3_pp r2.w, r1, r1
rsq_pp r2.w, r2.w
mul_pp r1.xyz, r2.w, r1
mov_pp r3.xyz, c0
mov_pp r2.xyz, c14
dp3_pp r2.w, v4, v4
max_pp r1.w, r1, c16
mul_pp r2.xyz, c3, r2
mad_pp r3.xyz, c3, r3, v2
mad_pp_sat r3.xyz, r2, r1.w, r3
dp3_pp r1.w, r0, v4
mul_pp r0.xyz, r0, r1.w
texld r2.xyz, v3, s1
mul_pp r2.xyz, r2, r3
rsq_pp r2.w, r2.w
mul_pp r3.xyz, r2.w, v4
dp3_pp_sat r1.y, r1, r3
mad_pp r0.xyz, -r0, c15.x, v4
dp3_pp r1.x, r0, v1
mad_pp r2.xyz, r0.w, r2, r4
mul_pp r3.x, r1.y, r1.y
abs_pp_sat r2.w, r1.x
pow_pp r1, r3.x, c10.x
add_pp r1.y, -r2.w, c15
pow_pp r3, r1.y, c13.x
mov_pp r2.w, r3.x
mul_pp r4.x, r2.w, c12
mul_pp r1, r1.x, c11
mul_pp r3, r0.w, r1
texld r1, r0, s3
add_pp_sat r0.x, r4, c4
mul_pp r0.xyz, r1, r0.x
mul_pp r0.xyz, r0, r0.w
mov_pp r2.w, c15.y
mov_pp r0.w, r1
mad_pp r2, r3, c9.x, r2
add_pp r1, r0, r2
mad_pp oC0, r4.x, r0, r1
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
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 94 ALU, 4 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..14],
		{ 2, 1, 8, 20 },
		{ 0.2199707, 0.70703125, 0.070983887, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.xyz, fragment.texcoord[6];
MUL R1.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R1.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R1;
MOV R2.y, R1.z;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R3.w, R3, R3;
RSQ R3.w, R3.w;
MUL R0.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R0, c[15].w;
MUL R3.xyz, R3.w, R3;
MOV R2.w, c[15].y;
MOV R1.zw, c[17].xyxy;
TEX R0.xyz, R0, texture[2], 2D;
MAD R0.xyz, R0, c[15].x, R1.zzww;
MOV R2.x, fragment.texcoord[6].z;
MOV R2.z, fragment.texcoord[5];
DP3 R1.z, R2, -R0;
MOV R2.y, R1.x;
MOV R2.z, fragment.texcoord[5].x;
MOV R2.x, fragment.texcoord[6];
DP3 R1.x, -R0, R2;
MOV R2.y, R1;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R1.y, -R0, R2;
DP3 R0.x, R1, R1;
DP3 R0.y, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.y;
MUL R2.xyz, R0.w, fragment.texcoord[4];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, R1;
DP3_SAT R0.x, R0, R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
MUL R1.w, R0.x, R0.x;
DP3 R0.y, R1, R1;
RSQ R0.x, R0.y;
MUL R0.xyz, R0.x, R1;
DP3 R0.w, c[2], c[2];
RSQ R1.x, R0.w;
ABS R0.w, -c[2];
CMP R0.w, -R0, c[16], R2;
ABS R2.x, R0.w;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
CMP R2.x, -R2, c[16].w, R2.w;
MUL R1.xyz, R1.x, c[2];
CMP R1.xyz, -R2.x, R0, R1;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, fragment.texcoord[1];
DP3 R0.w, R0, R1;
MUL R2.xyz, R0, -R0.w;
MAD R2.xyz, -R2, c[15].x, -R1;
POW R4.x, R1.w, c[10].x;
TEX R1, fragment.texcoord[3].zwzw, texture[0], 2D;
MUL R1.xyz, R1.w, R1;
DP3 R1.w, R2, R3;
MUL R1.xyz, R1, c[15].z;
DP3_SAT R3.w, R1, c[16];
MUL R2.x, R3.w, R1.w;
MUL R1, R4.x, c[11];
MAX R2.x, R2, c[16].w;
POW R3.y, R2.x, c[6].x;
SLT R3.x, R0.w, c[16].w;
MOV R2.xyz, c[5];
ABS R3.x, R3;
CMP R3.x, -R3, c[16].w, R2.w;
DP3 R2.w, R0, fragment.texcoord[4];
MUL R0.xyz, R0, R2.w;
MUL R2.xyz, R2, c[14];
MUL R2.xyz, R2, R3.y;
CMP R2.xyz, -R3.x, R2, c[16].w;
MUL R4.xyz, R2, c[7].x;
MOV R2.xyz, c[3];
MAD R3.xyz, R2, c[0], fragment.texcoord[2];
MAX R2.w, R0, c[16];
MAD R0.xyz, -R0, c[15].x, fragment.texcoord[4];
DP3 R0.w, R0, fragment.texcoord[1];
MUL R2.xyz, R2, c[14];
MAD_SAT R3.xyz, R2, R2.w, R3;
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[15].y;
TEX R2.xyz, fragment.texcoord[3], texture[1], 2D;
MUL R2.xyz, R2, R3;
POW R0.w, R0.w, c[13].x;
MUL R3.x, R0.w, c[12];
TEX R0, R0, texture[3], CUBE;
ADD_SAT R3.y, R3.x, c[4].x;
MUL R0.xyz, R0, R3.y;
MUL R0.xyz, R0, R3.w;
MUL R1, R3.w, R1;
MAD R2.xyz, R3.w, R2, R4;
MOV R2.w, c[15].y;
MAD R1, R1, c[9].x, R2;
ADD R1, R0, R1;
MAD result.color, R3.x, R0, R1;
END
# 94 instructions, 5 R-regs
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
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_SparkleTex] 2D
SetTexture 3 [_Cube] CUBE
"ps_3_0
; 95 ALU, 4 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_cube s3
def c15, 2.00000000, 1.00000000, 8.00000000, 20.00000000
def c16, 0.21997070, 0.70703125, 0.07098389, 0.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0
def c18, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
add r0.xyz, -v0, c2
dp3_pp r0.w, r0, r0
rsq_pp r1.x, r0.w
mul_pp r4.xy, v3, c8.x
mul_pp r4.xy, r4, c15.w
texld r4.xyz, r4, s2
mad_pp r4.xyz, r4, c17.x, c17.yyzw
mul_pp r0.xyz, r1.x, r0
dp3_pp r0.w, c2, c2
rsq_pp r1.x, r0.w
mul_pp r2.xyz, r1.x, c2
dp3_pp r0.w, v1, v1
abs_pp r1.x, -c2.w
cmp_pp r1.xyz, -r1.x, r2, r0
rsq_pp r0.w, r0.w
mul_pp r0.xyz, r0.w, v1
dp3_pp r1.w, r0, r1
mul_pp r2.xyz, r0, -r1.w
mad_pp r1.xyz, -r2, c15.x, -r1
add r3.xyz, -v0, c1
dp3 r0.w, r3, r3
texld r2, v3.zwzw, s0
rsq r0.w, r0.w
mul r3.xyz, r0.w, r3
dp3_pp r1.x, r1, r3
mul_pp r2.xyz, r2.w, r2
mul_pp r2.xyz, r2, c15.z
dp3_pp_sat r0.w, r2, c16
mul_pp r1.x, r0.w, r1
max_pp r1.x, r1, c16.w
pow_pp r2, r1.x, c6.x
mov_pp r2.y, r2.x
cmp_pp r2.x, r1.w, c18, c18.y
mov_pp r1.xyz, c14
mul_pp r1.xyz, c5, r1
mov_pp r3.xyz, v6
mul_pp r3.xyz, v1.zxyw, r3.yzxw
mul_pp r1.xyz, r1, r2.y
abs_pp r2.x, r2
cmp_pp r2.xyz, -r2.x, r1, c16.w
mov_pp r1.xyz, v6
mad_pp r1.xyz, v1.yzxw, r1.zxyw, -r3
mov r3.y, r1.z
mov r3.x, v6.z
mov r3.z, v5
dp3_pp r1.z, r3, -r4
mov r3.y, r1.x
mov r3.z, v5.x
mov r3.x, v6
dp3_pp r1.x, -r4, r3
mov r3.y, r1
mov r3.z, v5.y
mov r3.x, v6.y
dp3_pp r1.y, -r4, r3
mul_pp r4.xyz, r2, c7.x
dp3_pp r2.w, r1, r1
rsq_pp r2.w, r2.w
mul_pp r1.xyz, r2.w, r1
mov_pp r3.xyz, c0
mov_pp r2.xyz, c14
dp3_pp r2.w, v4, v4
max_pp r1.w, r1, c16
mul_pp r2.xyz, c3, r2
mad_pp r3.xyz, c3, r3, v2
mad_pp_sat r3.xyz, r2, r1.w, r3
dp3_pp r1.w, r0, v4
mul_pp r0.xyz, r0, r1.w
texld r2.xyz, v3, s1
mul_pp r2.xyz, r2, r3
rsq_pp r2.w, r2.w
mul_pp r3.xyz, r2.w, v4
dp3_pp_sat r1.y, r1, r3
mad_pp r0.xyz, -r0, c15.x, v4
dp3_pp r1.x, r0, v1
mad_pp r2.xyz, r0.w, r2, r4
mul_pp r3.x, r1.y, r1.y
abs_pp_sat r2.w, r1.x
pow_pp r1, r3.x, c10.x
add_pp r1.y, -r2.w, c15
pow_pp r3, r1.y, c13.x
mov_pp r2.w, r3.x
mul_pp r4.x, r2.w, c12
mul_pp r1, r1.x, c11
mul_pp r3, r0.w, r1
texld r1, r0, s3
add_pp_sat r0.x, r4, c4
mul_pp r0.xyz, r1, r0.x
mul_pp r0.xyz, r0, r0.w
mov_pp r2.w, c15.y
mov_pp r0.w, r1
mad_pp r2, r3, c9.x, r2
add_pp r1, r0, r2
mad_pp oC0, r4.x, r0, r1
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
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 95 ALU, 5 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..14],
		{ 2, 1, 8, 20 },
		{ 0.2199707, 0.70703125, 0.070983887, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.xyz, fragment.texcoord[6];
MUL R1.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R1.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R1;
MOV R2.y, R1.z;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R3.w, R3, R3;
RSQ R3.w, R3.w;
MUL R0.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R0, c[15].w;
MUL R3.xyz, R3.w, R3;
MOV R2.w, c[15].y;
MOV R1.zw, c[17].xyxy;
TEX R0.xyz, R0, texture[3], 2D;
MAD R0.xyz, R0, c[15].x, R1.zzww;
MOV R2.x, fragment.texcoord[6].z;
MOV R2.z, fragment.texcoord[5];
DP3 R1.z, R2, -R0;
MOV R2.y, R1.x;
MOV R2.z, fragment.texcoord[5].x;
MOV R2.x, fragment.texcoord[6];
DP3 R1.x, -R0, R2;
MOV R2.y, R1;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R1.y, -R0, R2;
DP3 R0.x, R1, R1;
DP3 R0.y, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.y;
MUL R2.xyz, R0.w, fragment.texcoord[4];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, R1;
DP3_SAT R0.x, R0, R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
MUL R1.w, R0.x, R0.x;
DP3 R0.y, R1, R1;
RSQ R0.x, R0.y;
MUL R0.xyz, R0.x, R1;
DP3 R0.w, c[2], c[2];
RSQ R1.x, R0.w;
ABS R0.w, -c[2];
CMP R0.w, -R0, c[16], R2;
ABS R2.x, R0.w;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
CMP R2.x, -R2, c[16].w, R2.w;
MUL R1.xyz, R1.x, c[2];
CMP R1.xyz, -R2.x, R0, R1;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, fragment.texcoord[1];
DP3 R0.w, R0, R1;
MUL R2.xyz, R0, -R0.w;
MAD R2.xyz, -R2, c[15].x, -R1;
POW R4.x, R1.w, c[10].x;
TEX R1, fragment.texcoord[3].zwzw, texture[0], 2D;
MUL R1.xyz, R1.w, R1;
DP3 R1.w, R2, R3;
MUL R1.xyz, R1, c[15].z;
DP3_SAT R3.w, R1, c[16];
MUL R2.x, R3.w, R1.w;
MUL R1, R4.x, c[11];
SLT R3.x, R0.w, c[16].w;
MAX R2.x, R2, c[16].w;
POW R4.y, R2.x, c[6].x;
ABS R4.x, R3;
CMP R4.x, -R4, c[16].w, R2.w;
DP3 R2.w, R0, fragment.texcoord[4];
MUL R0.xyz, R0, R2.w;
TXP R2.x, fragment.texcoord[7], texture[2], 2D;
MUL R2.xyz, R2.x, c[14];
MUL R3.xyz, R2, c[5];
MUL R3.xyz, R3, R4.y;
CMP R3.xyz, -R4.x, R3, c[16].w;
MUL R4.xyz, R3, c[7].x;
MOV R3.xyz, c[3];
MAX R2.w, R0, c[16];
MAD R0.xyz, -R0, c[15].x, fragment.texcoord[4];
DP3 R0.w, R0, fragment.texcoord[1];
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[15].y;
MUL R2.xyz, R2, c[3];
MAD R3.xyz, R3, c[0], fragment.texcoord[2];
MAD_SAT R3.xyz, R2, R2.w, R3;
TEX R2.xyz, fragment.texcoord[3], texture[1], 2D;
MUL R2.xyz, R2, R3;
POW R0.w, R0.w, c[13].x;
MUL R3.x, R0.w, c[12];
TEX R0, R0, texture[4], CUBE;
ADD_SAT R3.y, R3.x, c[4].x;
MUL R0.xyz, R0, R3.y;
MUL R0.xyz, R0, R3.w;
MUL R1, R3.w, R1;
MAD R2.xyz, R3.w, R2, R4;
MOV R2.w, c[15].y;
MAD R1, R1, c[9].x, R2;
ADD R1, R0, R1;
MAD result.color, R3.x, R0, R1;
END
# 95 instructions, 5 R-regs
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
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 95 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c15, 2.00000000, 1.00000000, 8.00000000, 20.00000000
def c16, 0.21997070, 0.70703125, 0.07098389, 0.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0
def c18, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
add r1.xyz, -v0, c2
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
dp3_pp r0.w, c2, c2
dp3_pp r1.w, v1, v1
mov_pp r4.xyz, v6
mul_pp r5.xy, v3, c8.x
mul_pp r0.xyz, r0.x, r1
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp_pp r2.xyz, -r0.w, r1, r0
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, v1
dp3_pp r1.w, r1, r2
mul_pp r3.xyz, r1, -r1.w
mad_pp r2.xyz, -r3, c15.x, -r2
add r0.xyz, -v0, c1
dp3 r0.w, r0, r0
texld r3, v3.zwzw, s0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mul_pp r3.xyz, r3.w, r3
mul_pp r3.xyz, r3, c15.z
dp3_pp_sat r0.w, r3, c16
dp3_pp r0.x, r2, r0
cmp_pp r3.x, r1.w, c18, c18.y
mul_pp r0.x, r0.w, r0
max_pp r0.x, r0, c16.w
pow_pp r2, r0.x, c6.x
mul_pp r5.xy, r5, c15.w
mov_pp r2.w, r2.x
texldp r0.x, v7, s2
mul_pp r2.xyz, r0.x, c14
mul_pp r0.xyz, r2, c5
mul_pp r0.xyz, r0, r2.w
abs_pp r2.w, r3.x
cmp_pp r3.xyz, -r2.w, r0, c16.w
mul_pp r4.xyz, v1.zxyw, r4.yzxw
mov_pp r0.xyz, v6
mad_pp r0.xyz, v1.yzxw, r0.zxyw, -r4
texld r4.xyz, r5, s3
mad_pp r4.xyz, r4, c17.x, c17.yyzw
mov r5.y, r0.z
mov r5.x, v6.z
mov r5.z, v5
dp3_pp r0.z, r5, -r4
mov r5.y, r0.x
mov r5.z, v5.x
mov r5.x, v6
dp3_pp r0.x, -r4, r5
mul_pp r3.xyz, r3, c7.x
max_pp r1.w, r1, c16
mul_pp r2.xyz, r2, c3
mov r5.y, r0
mov r5.z, v5.y
mov r5.x, v6.y
dp3_pp r0.y, -r4, r5
dp3_pp r2.w, r0, r0
mov_pp r4.xyz, c0
mad_pp r4.xyz, c3, r4, v2
mad_pp_sat r4.xyz, r2, r1.w, r4
texld r2.xyz, v3, s1
mul_pp r2.xyz, r2, r4
mad_pp r2.xyz, r0.w, r2, r3
rsq_pp r2.w, r2.w
mul_pp r3.xyz, r2.w, r0
dp3_pp r0.x, v4, v4
rsq_pp r1.w, r0.x
dp3_pp r0.y, r1, v4
mul_pp r0.xyz, r1, r0.y
mul_pp r1.xyz, r1.w, v4
dp3_pp_sat r1.x, r3, r1
mad_pp r0.xyz, -r0, c15.x, v4
dp3_pp r1.y, r0, v1
mul_pp r1.x, r1, r1
pow_pp r3, r1.x, c10.x
abs_pp_sat r1.y, r1
add_pp r2.w, -r1.y, c15.y
pow_pp r1, r2.w, c13.x
mov_pp r1.y, r3.x
mov_pp r2.w, r1.x
mul_pp r3, r1.y, c11
mul_pp r1, r0.w, r3
mul_pp r4.x, r2.w, c12
texld r3, r0, s4
add_pp_sat r0.x, r4, c4
mov_pp r2.w, c15.y
mul_pp r0.xyz, r3, r0.x
mul_pp r0.xyz, r0, r0.w
mov_pp r0.w, r3
mad_pp r1, r1, c9.x, r2
add_pp r1, r0, r1
mad_pp oC0, r4.x, r0, r1
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
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 95 ALU, 5 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..14],
		{ 2, 1, 8, 20 },
		{ 0.2199707, 0.70703125, 0.070983887, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.xyz, fragment.texcoord[6];
MUL R1.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R1.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R1;
MOV R2.y, R1.z;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R3.w, R3, R3;
RSQ R3.w, R3.w;
MUL R0.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R0, c[15].w;
MUL R3.xyz, R3.w, R3;
MOV R2.w, c[15].y;
MOV R1.zw, c[17].xyxy;
TEX R0.xyz, R0, texture[3], 2D;
MAD R0.xyz, R0, c[15].x, R1.zzww;
MOV R2.x, fragment.texcoord[6].z;
MOV R2.z, fragment.texcoord[5];
DP3 R1.z, R2, -R0;
MOV R2.y, R1.x;
MOV R2.z, fragment.texcoord[5].x;
MOV R2.x, fragment.texcoord[6];
DP3 R1.x, -R0, R2;
MOV R2.y, R1;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R1.y, -R0, R2;
DP3 R0.x, R1, R1;
DP3 R0.y, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.y;
MUL R2.xyz, R0.w, fragment.texcoord[4];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, R1;
DP3_SAT R0.x, R0, R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
MUL R1.w, R0.x, R0.x;
DP3 R0.y, R1, R1;
RSQ R0.x, R0.y;
MUL R0.xyz, R0.x, R1;
DP3 R0.w, c[2], c[2];
RSQ R1.x, R0.w;
ABS R0.w, -c[2];
CMP R0.w, -R0, c[16], R2;
ABS R2.x, R0.w;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
CMP R2.x, -R2, c[16].w, R2.w;
MUL R1.xyz, R1.x, c[2];
CMP R1.xyz, -R2.x, R0, R1;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, fragment.texcoord[1];
DP3 R0.w, R0, R1;
MUL R2.xyz, R0, -R0.w;
MAD R2.xyz, -R2, c[15].x, -R1;
POW R4.x, R1.w, c[10].x;
TEX R1, fragment.texcoord[3].zwzw, texture[0], 2D;
MUL R1.xyz, R1.w, R1;
DP3 R1.w, R2, R3;
MUL R1.xyz, R1, c[15].z;
DP3_SAT R3.w, R1, c[16];
MUL R2.x, R3.w, R1.w;
MUL R1, R4.x, c[11];
SLT R3.x, R0.w, c[16].w;
MAX R2.x, R2, c[16].w;
POW R4.y, R2.x, c[6].x;
ABS R4.x, R3;
CMP R4.x, -R4, c[16].w, R2.w;
DP3 R2.w, R0, fragment.texcoord[4];
MUL R0.xyz, R0, R2.w;
TXP R2.x, fragment.texcoord[7], texture[2], 2D;
MUL R2.xyz, R2.x, c[14];
MUL R3.xyz, R2, c[5];
MUL R3.xyz, R3, R4.y;
CMP R3.xyz, -R4.x, R3, c[16].w;
MUL R4.xyz, R3, c[7].x;
MOV R3.xyz, c[3];
MAX R2.w, R0, c[16];
MAD R0.xyz, -R0, c[15].x, fragment.texcoord[4];
DP3 R0.w, R0, fragment.texcoord[1];
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[15].y;
MUL R2.xyz, R2, c[3];
MAD R3.xyz, R3, c[0], fragment.texcoord[2];
MAD_SAT R3.xyz, R2, R2.w, R3;
TEX R2.xyz, fragment.texcoord[3], texture[1], 2D;
MUL R2.xyz, R2, R3;
POW R0.w, R0.w, c[13].x;
MUL R3.x, R0.w, c[12];
TEX R0, R0, texture[4], CUBE;
ADD_SAT R3.y, R3.x, c[4].x;
MUL R0.xyz, R0, R3.y;
MUL R0.xyz, R0, R3.w;
MUL R1, R3.w, R1;
MAD R2.xyz, R3.w, R2, R4;
MOV R2.w, c[15].y;
MAD R1, R1, c[9].x, R2;
ADD R1, R0, R1;
MAD result.color, R3.x, R0, R1;
END
# 95 instructions, 5 R-regs
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
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 95 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c15, 2.00000000, 1.00000000, 8.00000000, 20.00000000
def c16, 0.21997070, 0.70703125, 0.07098389, 0.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0
def c18, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
add r1.xyz, -v0, c2
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
dp3_pp r0.w, c2, c2
dp3_pp r1.w, v1, v1
mov_pp r4.xyz, v6
mul_pp r5.xy, v3, c8.x
mul_pp r0.xyz, r0.x, r1
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp_pp r2.xyz, -r0.w, r1, r0
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, v1
dp3_pp r1.w, r1, r2
mul_pp r3.xyz, r1, -r1.w
mad_pp r2.xyz, -r3, c15.x, -r2
add r0.xyz, -v0, c1
dp3 r0.w, r0, r0
texld r3, v3.zwzw, s0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mul_pp r3.xyz, r3.w, r3
mul_pp r3.xyz, r3, c15.z
dp3_pp_sat r0.w, r3, c16
dp3_pp r0.x, r2, r0
cmp_pp r3.x, r1.w, c18, c18.y
mul_pp r0.x, r0.w, r0
max_pp r0.x, r0, c16.w
pow_pp r2, r0.x, c6.x
mul_pp r5.xy, r5, c15.w
mov_pp r2.w, r2.x
texldp r0.x, v7, s2
mul_pp r2.xyz, r0.x, c14
mul_pp r0.xyz, r2, c5
mul_pp r0.xyz, r0, r2.w
abs_pp r2.w, r3.x
cmp_pp r3.xyz, -r2.w, r0, c16.w
mul_pp r4.xyz, v1.zxyw, r4.yzxw
mov_pp r0.xyz, v6
mad_pp r0.xyz, v1.yzxw, r0.zxyw, -r4
texld r4.xyz, r5, s3
mad_pp r4.xyz, r4, c17.x, c17.yyzw
mov r5.y, r0.z
mov r5.x, v6.z
mov r5.z, v5
dp3_pp r0.z, r5, -r4
mov r5.y, r0.x
mov r5.z, v5.x
mov r5.x, v6
dp3_pp r0.x, -r4, r5
mul_pp r3.xyz, r3, c7.x
max_pp r1.w, r1, c16
mul_pp r2.xyz, r2, c3
mov r5.y, r0
mov r5.z, v5.y
mov r5.x, v6.y
dp3_pp r0.y, -r4, r5
dp3_pp r2.w, r0, r0
mov_pp r4.xyz, c0
mad_pp r4.xyz, c3, r4, v2
mad_pp_sat r4.xyz, r2, r1.w, r4
texld r2.xyz, v3, s1
mul_pp r2.xyz, r2, r4
mad_pp r2.xyz, r0.w, r2, r3
rsq_pp r2.w, r2.w
mul_pp r3.xyz, r2.w, r0
dp3_pp r0.x, v4, v4
rsq_pp r1.w, r0.x
dp3_pp r0.y, r1, v4
mul_pp r0.xyz, r1, r0.y
mul_pp r1.xyz, r1.w, v4
dp3_pp_sat r1.x, r3, r1
mad_pp r0.xyz, -r0, c15.x, v4
dp3_pp r1.y, r0, v1
mul_pp r1.x, r1, r1
pow_pp r3, r1.x, c10.x
abs_pp_sat r1.y, r1
add_pp r2.w, -r1.y, c15.y
pow_pp r1, r2.w, c13.x
mov_pp r1.y, r3.x
mov_pp r2.w, r1.x
mul_pp r3, r1.y, c11
mul_pp r1, r0.w, r3
mul_pp r4.x, r2.w, c12
texld r3, r0, s4
add_pp_sat r0.x, r4, c4
mov_pp r2.w, c15.y
mul_pp r0.xyz, r3, r0.x
mul_pp r0.xyz, r0, r0.w
mov_pp r0.w, r3
mad_pp r1, r1, c9.x, r2
add_pp r1, r0, r1
mad_pp oC0, r4.x, r0, r1
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
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"3.0-!!ARBfp1.0
OPTION ARB_precision_hint_fastest;
# 95 ALU, 5 TEX
PARAM c[18] = { state.lightmodel.ambient,
		program.local[1..14],
		{ 2, 1, 8, 20 },
		{ 0.2199707, 0.70703125, 0.070983887, 0 },
		{ -1, 3, 0 } };
TEMP R0;
TEMP R1;
TEMP R2;
TEMP R3;
TEMP R4;
MOV R0.xyz, fragment.texcoord[6];
MUL R1.xyz, fragment.texcoord[1].zxyw, R0.yzxw;
MAD R1.xyz, fragment.texcoord[1].yzxw, R0.zxyw, -R1;
MOV R2.y, R1.z;
ADD R3.xyz, -fragment.texcoord[0], c[1];
DP3 R3.w, R3, R3;
RSQ R3.w, R3.w;
MUL R0.xy, fragment.texcoord[3], c[8].x;
MUL R0.xy, R0, c[15].w;
MUL R3.xyz, R3.w, R3;
MOV R2.w, c[15].y;
MOV R1.zw, c[17].xyxy;
TEX R0.xyz, R0, texture[3], 2D;
MAD R0.xyz, R0, c[15].x, R1.zzww;
MOV R2.x, fragment.texcoord[6].z;
MOV R2.z, fragment.texcoord[5];
DP3 R1.z, R2, -R0;
MOV R2.y, R1.x;
MOV R2.z, fragment.texcoord[5].x;
MOV R2.x, fragment.texcoord[6];
DP3 R1.x, -R0, R2;
MOV R2.y, R1;
MOV R2.z, fragment.texcoord[5].y;
MOV R2.x, fragment.texcoord[6].y;
DP3 R1.y, -R0, R2;
DP3 R0.x, R1, R1;
DP3 R0.y, fragment.texcoord[4], fragment.texcoord[4];
RSQ R0.w, R0.y;
MUL R2.xyz, R0.w, fragment.texcoord[4];
RSQ R0.x, R0.x;
MUL R0.xyz, R0.x, R1;
DP3_SAT R0.x, R0, R2;
ADD R1.xyz, -fragment.texcoord[0], c[2];
MUL R1.w, R0.x, R0.x;
DP3 R0.y, R1, R1;
RSQ R0.x, R0.y;
MUL R0.xyz, R0.x, R1;
DP3 R0.w, c[2], c[2];
RSQ R1.x, R0.w;
ABS R0.w, -c[2];
CMP R0.w, -R0, c[16], R2;
ABS R2.x, R0.w;
DP3 R0.w, fragment.texcoord[1], fragment.texcoord[1];
CMP R2.x, -R2, c[16].w, R2.w;
MUL R1.xyz, R1.x, c[2];
CMP R1.xyz, -R2.x, R0, R1;
RSQ R0.w, R0.w;
MUL R0.xyz, R0.w, fragment.texcoord[1];
DP3 R0.w, R0, R1;
MUL R2.xyz, R0, -R0.w;
MAD R2.xyz, -R2, c[15].x, -R1;
POW R4.x, R1.w, c[10].x;
TEX R1, fragment.texcoord[3].zwzw, texture[0], 2D;
MUL R1.xyz, R1.w, R1;
DP3 R1.w, R2, R3;
MUL R1.xyz, R1, c[15].z;
DP3_SAT R3.w, R1, c[16];
MUL R2.x, R3.w, R1.w;
MUL R1, R4.x, c[11];
SLT R3.x, R0.w, c[16].w;
MAX R2.x, R2, c[16].w;
POW R4.y, R2.x, c[6].x;
ABS R4.x, R3;
CMP R4.x, -R4, c[16].w, R2.w;
DP3 R2.w, R0, fragment.texcoord[4];
MUL R0.xyz, R0, R2.w;
TXP R2.x, fragment.texcoord[7], texture[2], 2D;
MUL R2.xyz, R2.x, c[14];
MUL R3.xyz, R2, c[5];
MUL R3.xyz, R3, R4.y;
CMP R3.xyz, -R4.x, R3, c[16].w;
MUL R4.xyz, R3, c[7].x;
MOV R3.xyz, c[3];
MAX R2.w, R0, c[16];
MAD R0.xyz, -R0, c[15].x, fragment.texcoord[4];
DP3 R0.w, R0, fragment.texcoord[1];
ABS_SAT R0.w, R0;
ADD R0.w, -R0, c[15].y;
MUL R2.xyz, R2, c[3];
MAD R3.xyz, R3, c[0], fragment.texcoord[2];
MAD_SAT R3.xyz, R2, R2.w, R3;
TEX R2.xyz, fragment.texcoord[3], texture[1], 2D;
MUL R2.xyz, R2, R3;
POW R0.w, R0.w, c[13].x;
MUL R3.x, R0.w, c[12];
TEX R0, R0, texture[4], CUBE;
ADD_SAT R3.y, R3.x, c[4].x;
MUL R0.xyz, R0, R3.y;
MUL R0.xyz, R0, R3.w;
MUL R1, R3.w, R1;
MAD R2.xyz, R3.w, R2, R4;
MOV R2.w, c[15].y;
MAD R1, R1, c[9].x, R2;
ADD R1, R0, R1;
MAD result.color, R3.x, R0, R1;
END
# 95 instructions, 5 R-regs
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
SetTexture 0 [unity_Lightmap] 2D
SetTexture 1 [_MainTex] 2D
SetTexture 2 [_ShadowMapTexture] 2D
SetTexture 3 [_SparkleTex] 2D
SetTexture 4 [_Cube] CUBE
"ps_3_0
; 95 ALU, 5 TEX
dcl_2d s0
dcl_2d s1
dcl_2d s2
dcl_2d s3
dcl_cube s4
def c15, 2.00000000, 1.00000000, 8.00000000, 20.00000000
def c16, 0.21997070, 0.70703125, 0.07098389, 0.00000000
def c17, 2.00000000, -1.00000000, 3.00000000, 0
def c18, 0.00000000, 1.00000000, 0, 0
dcl_texcoord0 v0.xyz
dcl_texcoord1 v1.xyz
dcl_texcoord2 v2.xyz
dcl_texcoord3 v3
dcl_texcoord4 v4.xyz
dcl_texcoord5 v5.xyz
dcl_texcoord6 v6.xyz
dcl_texcoord7 v7
add r1.xyz, -v0, c2
dp3_pp r0.x, r1, r1
rsq_pp r0.x, r0.x
dp3_pp r0.w, c2, c2
dp3_pp r1.w, v1, v1
mov_pp r4.xyz, v6
mul_pp r5.xy, v3, c8.x
mul_pp r0.xyz, r0.x, r1
rsq_pp r0.w, r0.w
mul_pp r1.xyz, r0.w, c2
abs_pp r0.w, -c2
cmp_pp r2.xyz, -r0.w, r1, r0
rsq_pp r1.w, r1.w
mul_pp r1.xyz, r1.w, v1
dp3_pp r1.w, r1, r2
mul_pp r3.xyz, r1, -r1.w
mad_pp r2.xyz, -r3, c15.x, -r2
add r0.xyz, -v0, c1
dp3 r0.w, r0, r0
texld r3, v3.zwzw, s0
rsq r0.w, r0.w
mul r0.xyz, r0.w, r0
mul_pp r3.xyz, r3.w, r3
mul_pp r3.xyz, r3, c15.z
dp3_pp_sat r0.w, r3, c16
dp3_pp r0.x, r2, r0
cmp_pp r3.x, r1.w, c18, c18.y
mul_pp r0.x, r0.w, r0
max_pp r0.x, r0, c16.w
pow_pp r2, r0.x, c6.x
mul_pp r5.xy, r5, c15.w
mov_pp r2.w, r2.x
texldp r0.x, v7, s2
mul_pp r2.xyz, r0.x, c14
mul_pp r0.xyz, r2, c5
mul_pp r0.xyz, r0, r2.w
abs_pp r2.w, r3.x
cmp_pp r3.xyz, -r2.w, r0, c16.w
mul_pp r4.xyz, v1.zxyw, r4.yzxw
mov_pp r0.xyz, v6
mad_pp r0.xyz, v1.yzxw, r0.zxyw, -r4
texld r4.xyz, r5, s3
mad_pp r4.xyz, r4, c17.x, c17.yyzw
mov r5.y, r0.z
mov r5.x, v6.z
mov r5.z, v5
dp3_pp r0.z, r5, -r4
mov r5.y, r0.x
mov r5.z, v5.x
mov r5.x, v6
dp3_pp r0.x, -r4, r5
mul_pp r3.xyz, r3, c7.x
max_pp r1.w, r1, c16
mul_pp r2.xyz, r2, c3
mov r5.y, r0
mov r5.z, v5.y
mov r5.x, v6.y
dp3_pp r0.y, -r4, r5
dp3_pp r2.w, r0, r0
mov_pp r4.xyz, c0
mad_pp r4.xyz, c3, r4, v2
mad_pp_sat r4.xyz, r2, r1.w, r4
texld r2.xyz, v3, s1
mul_pp r2.xyz, r2, r4
mad_pp r2.xyz, r0.w, r2, r3
rsq_pp r2.w, r2.w
mul_pp r3.xyz, r2.w, r0
dp3_pp r0.x, v4, v4
rsq_pp r1.w, r0.x
dp3_pp r0.y, r1, v4
mul_pp r0.xyz, r1, r0.y
mul_pp r1.xyz, r1.w, v4
dp3_pp_sat r1.x, r3, r1
mad_pp r0.xyz, -r0, c15.x, v4
dp3_pp r1.y, r0, v1
mul_pp r1.x, r1, r1
pow_pp r3, r1.x, c10.x
abs_pp_sat r1.y, r1
add_pp r2.w, -r1.y, c15.y
pow_pp r1, r2.w, c13.x
mov_pp r1.y, r3.x
mov_pp r2.w, r1.x
mul_pp r3, r1.y, c11
mul_pp r1, r0.w, r3
mul_pp r4.x, r2.w, c12
texld r3, r0, s4
add_pp_sat r0.x, r4, c4
mov_pp r2.w, c15.y
mul_pp r0.xyz, r3, r0.x
mul_pp r0.xyz, r0, r0.w
mov_pp r0.w, r3
mad_pp r1, r1, c9.x, r2
add_pp r1, r0, r1
mad_pp oC0, r4.x, r0, r1
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