Shader "RedDotGames/Mobile/Car Paint Unlit" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
	  _MainTex ("Diffuse Texture", 2D) = "white" {} 
	  _Cube("Reflection Map", Cube) = "" {}
	  _Reflection("Reflection Power", Range (0.00, 1)) = 0
	  _FrezPow("Fresnel Power",Range(0,2)) = .25
	  _FrezFalloff("Fresnal Falloff",Range(0,10)) = 4	  
  
   }
SubShader {
   Tags { "QUEUE"="Geometry" "RenderType"="Opaque" " IgnoreProjector"="True"}	  
      Pass {  
      
         Tags { "LightMode" = "ForwardBase" }
 
         CGPROGRAM
         #pragma fragmentoption ARB_precision_hint_fastest
         #pragma multi_compile_fwdbase 
         #pragma vertex vert
         #pragma fragment frag
		 #pragma target 2.0	
		 #pragma exclude_renderers d3d11 xbox360 ps3 d3d11_9x flash
		 
 		 #include "UnityCG.cginc"
 
		 uniform sampler2D _MainTex; 
	 
         uniform fixed4 _Color; 
		 uniform fixed _Reflection;

		 uniform samplerCUBE _Cube; 
		 fixed _FrezPow;
		 half _FrezFalloff;
		 
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
			
         };
 
         vertexOutput vert(vertexInput input)
         {          
            vertexOutput o;
 
            o.posWorld = mul(_Object2World, input.vertex);
		
            o.normalDir = normalize(fixed3(mul(fixed4(input.normal, 0.0), _World2Object)));
			   
			o.tex = input.texcoord;
            o.pos = mul(UNITY_MATRIX_MVP, input.vertex);
   
            return o;
         }
 
         fixed4 frag(vertexOutput input) : COLOR
         {
		 
            fixed3 normalDirection = normalize(input.normalDir); 
            fixed3 viewDirection = normalize(
               _WorldSpaceCameraPos - input.posWorld.xyz);
 
			fixed4 textureColor = tex2D(_MainTex, fixed2(input.tex));
		 
			fixed3 reflectedDir = reflect(-viewDirection, normalDirection );
            fixed4 reflTex = texCUBE(_Cube, reflectedDir);
			
			//Calculate Reflection vector
			fixed SurfAngle= clamp(abs(dot (reflectedDir,input.normalDir)),0,1);
			fixed frez = pow(1-SurfAngle,_FrezFalloff) ;
			frez*=_FrezPow;
			
			_Reflection += frez;			
			
			reflTex.rgb *= saturate(_Reflection);
			 
            return fixed4(textureColor.rgb + reflTex + (frez * reflTex), 1.0);
			
			
			
         }
         ENDCG
      }
 }
 Fallback "Mobile/Diffuse"
}