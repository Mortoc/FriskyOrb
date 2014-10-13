Car Paint Shader PRO Mobile 4.0.1
-------------------------------

Information
-----------
Pack includes 38 shaders :
- Car Paint Unlit
- Car Paint Low Detail
- Car Paint High Detail
- Car Paint Medium Detail
- Car Paint Ultra Detail
- Car Paint with Alpha Blending Low Detail
- Car Paint with Alpha Blending Medium Detail
- Car Paint with Alpha Blending Ultra Detail
- Car Paint Duo Color
- Car Paint Duo Color with Probes
- Car Paint Medium Detail Scrolled Enviroment
- Car Glass Unlit
- Car Glass Shader with Reflection and Fresnel Formula
- Car Glass with Diffuse Textures
- Car Glass Advanced
- Car Glass with Probes
- Car Glass Double Side Shader
- Car Glass Advanced Double Side Shader
- Car Chrome Shader
- Car Chrome Shader with Probes
- Car Paint Ultra Detail with Lightmapping Support
- Car Paint Ultra Detail with Normal Map
- Car Paint Ultra Detail with Normal Map with Reflection & Specular Mask
- Car Paint Ultra Detail with Normal Map with Reflection & Color & Specular Mask
- Car Paint Low Detail FakeHDR
- Car Paint High Detail with Probes
- Car Paint Medium Detail with Probes
- Car Paint High Detail with Decal
- Car Paint Medium Detail with Decal
- Car Paint Low Detail with Reflection Mask
- Car Paint High Detail with Reflection Mask
- Car Paint Medium Detail with Reflection Mask
- Car Paint Low Detail with Reflection & Color Mask
- Car Paint High Detail with Reflection & Color Mask
- Car Paint Medium Detail with Reflection & Color Mask
- Car Paint Low Detail with Reflection & Color & Specular Mask
- Car Paint High Detail with Reflection & Color & Specular Mask
- Car Paint Medium Detail with Reflection & Color & Specular Mask


Shader Description
------------------
1) Car Paint Low Detail / Medium Detail / High Detail / Ultra

                          Low          Medium         High       Ultra
   Specular / Gloss        +             +             +           +
   Reflection              +             +             +           +
   Fresnel                 +             +             +           +
   Flakes                                +             +           +
   Up to 2 vertex lights                 +             +           +
   Up to 4 vertex lights                               +           +
   Self Shadowing                                                  +

2) Alpha Blending Shaders
   Like normal but with Diffuse Color Alpha value work as transparency - good for transparent parts (tail lights)

3) Glass Shaders
   Special formula shader for glass - also with texture support
   With Advanced Shader you can set Tint param and Alpha value - this will help you make more tinted windows (almost black for example)
  
4) Shader with Decals (only Medium and High for now)
   With additional texture work as decals (additional blend)
  
5) Shader with Reflection Mask
   Alpha of main texture is working as reflection mask (you can use one material per all model and just prepare another grayscale texture with reflection mask)

6) Shader with Reflection Mask & Color Mask
   Like 5) but non reflective parts of car are without diffuse color
  
7) Shader with Reflection Mask & Specular Mask
   Like 6) but also with Specular Masking  
  
8) Shaders with Probe Support
   No need to explain that
  
9) FakeHDR Shader
   Test shader - you can adjust dark parts of model to be more lightened

Features :
----------
- Up to 4 Lights Sources (2 in Medium Detail Shaders) + Directional Light
- Diffuse and Ambient Color
- Specular Color with Gloss
- Normal mapping
- Reflection Cubemap
- Reflection Fresnel
- Decal with alpha control (for stickers, mud)
- Flakes with 3 prepared sparkle textures fully adjustable via shader parameters
- Light Probes support (on few shaders)

Version History
---------------
1.0 Initial Version
1.1 Added Car Paint shader with Reflection Mask (High and Medium Detail)
	Added Car Paint shader with Reflection & Color Mask (High and Medium Detail)
1.2 Added 4 shaders with Light Probes support
1.3 Added Duo Color to Light Probes shaders
	Added Low Version of Car Paint Shader and Paint Shader Alpha
1.4 Added Car Glass shader with Diffuse Texture
	Fixed High Quality shaders
	Fixed all shaders for calculation precision at larger world positions
	Better sample car materials
2.0 Added Car Paint Ultra Detail (with self shadowing)
	Added Car Paint Ultra Detail with Alpha Blending (with self shadowing)
	Added Car Paint Ultra Detail with Lightmapping support
	Added Car Paint Low Detail with Reflection Mask
	Added Car Paint Low Detail with Reflection Mask & Color Mask
	Added Car Paint Low / Medium / High Detail with Reflection, Color, Specular Mask
	Added Car Glass Advanced Shader
	Added Shaders Description in this file
2.1 Added Car Paint Ultra Detail with Normal Map
	Added Car Paint Ultra Detail with Normal Map Reflection & Specular Mask
	All masked shaders are taking reflection/color/specular mask from main texture ALPHA!
2.2 Added texture into Car Glass Advanced
2.3 New Car Glass Advanced Shader
	Added Glass Double Side Shader
	Added Glass Advanced Double Side Shader
3.0 Optimized bunch of shaders
	Added Glass Advanced Shader sample
	Added Lightmapping Sample Scene
	Added Car Paint Medium Detail Scrolled Enviroment + SetSpeed sample script + Sample Scene
3.1 Added new Car Model with 3 materials setup for mobile
3.2 Fixed Medium Shaders due was problems on some Android Devices
	Fixed Chrome Shader due was problems on some Android Devices
	Fixed Duo Color Shaders due was problems on some Android Devices
	Fixed Ultra Shaders to work proper with Real Time Shadows 
	Deleted Ultra Alpha Shader - use Medium or High instead
3.3 Added Car Paint Unlit shader
	Added Car Glass Unlit shader
	Fixed 2 bumped shaders
	Added Car Paint Ultra Detail with Normal Map with Reflection & Color & Specular Mask
4.0 Released uncompiled shaders!
4.0.1 Excluded DX11 renderer
								
Requests
--------
This pack of shaders is constantly updated by shaders that you have requested. If you got some request - feel free to contact me or write on Unity3d forum.		

Desktop Shader Pack
-------------------
Those shader will work on Desktop of course but if you need highest quality desktop shaders - check out our Car Paint Shader PRO on Asset Store
		
Credits
-------
Red Dot Games 2013
http://www.reddotgames.pl