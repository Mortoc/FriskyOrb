//like MED but without POINT LIGHTS and with many optimisations

Shader "RedDotGames/Mobile/Car Paint Low Detail Ref Color Mask" {
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
 
         CGPROGRAM
         #pragma fragmentoption ARB_precision_hint_fastest
         #pragma multi_compile_fwdbase 
         #pragma vertex vert
         #pragma fragment frag
		 #pragma target 2.0	
		 #pragma exclude_renderers d3d11 xbox360 ps3 d3d11_9x flash
		 //#include "AutoLight.cginc"
 		 #include "UnityCG.cginc"
 
         // User-specified properties
		 uniform sampler2D _MainTex; 
         //uniform sampler2D _BumpMap; 
		 
         //uniform fixed4 _BumpMap_ST;		 
         uniform fixed4 _Color; 
		 uniform fixed _Reflection;
         uniform fixed4 _SpecColor; 
         uniform half _Shininess;
		 uniform half _Gloss;
		 
		 //uniform fixed normalPerturbation;
		 
		 //uniform fixed4 _paintColor0; 
		 //uniform fixed4 _paintColorMid; 

		 uniform samplerCUBE _Cube; 
		 fixed _FrezPow;
		 half _FrezFalloff;
		 
 
         // The following built-in uniforms (except _LightColor0) 
         // are also defined in "UnityCG.cginc", 
         // i.e. one could #include "UnityCG.cginc" 
         uniform fixed4 _LightColor0; 
            // color of light source (from "Lighting.cginc")
 
         struct vertexInput {
            float4 vertex : POSITION;
            fixed3 normal : NORMAL;
			half4 texcoord : TEXCOORD0;
			
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 posWorld : TEXCOORD0;
            fixed3 normalDir : TEXCOORD1;
			half4 tex : TEXCOORD3;
			//LIGHTING_COORDS(7,8)
			
         };
 
         vertexOutput vert(vertexInput input)
         {          
            vertexOutput o;
 
            o.posWorld = mul(_Object2World, input.vertex);
		
            o.normalDir = normalize(fixed3(mul(fixed4(input.normal, 0.0), _World2Object)));
			   
			o.tex = input.texcoord;
            o.pos = mul(UNITY_MATRIX_MVP, input.vertex);
  
            //TRANSFER_VERTEX_TO_FRAGMENT(o);			   
            return o;
         }
 
         fixed4 frag(vertexOutput input) : COLOR
         {
		 
		 
		    //fixed4 encodedNormal = tex2D(_BumpMap, _BumpMap_ST.xy * input.tex.xy + _BumpMap_ST.zw);
		 
            fixed3 normalDirection = normalize(input.normalDir); 
            fixed3 viewDirection = normalize(
               _WorldSpaceCameraPos - input.posWorld.xyz);
            fixed3 lightDirection;
            fixed attenuation;
 
			fixed4 textureColor = tex2D(_MainTex, fixed2(input.tex));
 
            attenuation = 1.0; // no attenuation
            lightDirection = normalize(fixed3(_WorldSpaceLightPos0));
 
            fixed3 ambientLighting = 
                fixed3(UNITY_LIGHTMODEL_AMBIENT);
 
            fixed3 diffuseReflection = 
               attenuation * fixed3(_LightColor0) * max(0.0, dot(normalDirection, lightDirection));
				  
			fixed dotLN = dot(lightDirection, input.normalDir); 				  

            fixed3 specularReflection;
			
			if (dot(normalDirection, lightDirection) < 0.0) 
            {
               specularReflection = fixed3(0.0, 0.0, 0.0); 
            }
            else // light source on the right side
            {
               specularReflection = attenuation * fixed3(_LightColor0) 
                  * fixed3(_SpecColor) * pow(max(0.0, dot(
                  reflect(-lightDirection, normalDirection), 
                  viewDirection)), _Shininess);
            }
		 
			specularReflection *= _Gloss;

			fixed3 reflectedDir = reflect(-viewDirection, normalDirection );
            fixed4 reflTex = texCUBE(_Cube, reflectedDir);
			
			//Calculate Reflection vector
			fixed SurfAngle= clamp(abs(dot (reflectedDir,input.normalDir)),0,1);
			fixed frez = pow(1-SurfAngle,_FrezFalloff) ;
			frez*=_FrezPow;
			
			_Reflection += frez;			
			
			reflTex.rgb *= saturate(_Reflection);

			fixed3 col = lerp(_Color.rgb,(1.0,1.0,1.0),1-textureColor.a);
			
            fixed4 color = fixed4(textureColor.rgb * col * saturate(ambientLighting + diffuseReflection) + specularReflection, 1.0);
			
			
			color += reflTex * textureColor.a;
			color += (frez * reflTex) * textureColor.a;
 
            return color;
			
			
			
         }
         ENDCG
      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Mobile/Diffuse"
}