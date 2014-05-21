Shader "Starbomb/Player/GroundGlowProjection" {
  Properties {
  	  _Color ("Main Color", Color) = (1,1,1,1)   	
     _ShadowTex ("Cookie", 2D) = "" { TexGen ObjectLinear }
     _FalloffTex ("FallOff", 2D) = "" { TexGen ObjectLinear }
  }
  Subshader {
     Pass {
        ZWrite off
        Color [_Color]
        ColorMask RGB
        Blend One SrcColor
		Offset -1, -1
        SetTexture [_ShadowTex] {
		   combine texture * primary, ONE - texture
           Matrix [_Projector]
        }
        SetTexture [_FalloffTex] {
           constantColor (0,0,0,0)
           combine previous lerp (texture) constant
           Matrix [_ProjectorClip]
        }
     }
  }
}