// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape/URP/Water River"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][Header(Maps)][Header(.)][SingleLineTexture]_FlowMask("Flow Mask", 2D) = "white" {}
		[SingleLineTexture]_FoamMask("Foam Mask", 2D) = "white" {}
		[Normal][SingleLineTexture]_NormalMap("Normal Map", 2D) = "bump" {}
		[SingleLineTexture]_HeightMap("Height Map", 2D) = "white" {}
		_WaterFoamColor("Water Foam Color", Color) = (1,1,1,1)
		_WaterFoamColorIntensity("Water Foam Color Intensity", Float) = 1
		[Header(Color)]_ColorShallow("Color Shallow", Color) = (0.5990566,0.9091429,1,0)
		_ColorDeep("Color Deep", Color) = (0.1213065,0.347919,0.5471698,0)
		_ColorDepthFade("Color Depth Fade", Range( 0 , 100)) = 0
		[Header(Refraction)]_RefractionStrength("Refraction Strength", Range( 0 , 10)) = 1
		_RefractionDepth("Refraction Depth", Range( 0 , 100)) = 1
		[Header(Edge Foam)]_EdgeFoamSpeed("Edge Foam Speed", Vector) = (0,0,0,0)
		_EdgeFoamScale("Edge Foam Scale", Range( 0 , 10)) = 1
		_EdgeFoamDepthFade("Edge Foam Depth Fade", Range( 0 , 10)) = 0.19
		_EdgeFoamIntensity("Edge Foam Intensity", Range( 0 , 100)) = 1
		_EdgeFoamCutoff("Edge Foam Cutoff", Range( 0 , 5)) = 1
		[Header(Foam)]_FoamUVTiling("Foam UV Tiling", Vector) = (1,1,0,0)
		_FoamSpeed("Foam Speed", Vector) = (1,1,0,0)
		_FoamIntensity("Foam Intensity", Range( 0 , 100)) = 1
		_FoamPower("Foam Power", Range( 0 , 20)) = 1
		_FoamRandomizeUV("Foam Randomize UV", Range( 0 , 1)) = 0.26
		[Header(Flow)]_FlowUVTiling("Flow UV Tiling", Vector) = (1,1,0,0)
		_FlowSpeed("Flow Speed", Vector) = (0,-0.2,0,0)
		_FlowIntensity("Flow Intensity", Range( 0 , 100)) = 1
		_FlowPower("Flow Power", Range( 0 , 20)) = 1
		_FlowRandomizeUV("Flow Randomize UV", Range( 0 , 1)) = 0.26
		[Header(Normal)]_NormalUVTiling("Normal UV Tiling", Vector) = (1,1,0,0)
		_NormalSpeed("Normal Speed", Vector) = (0,-0.2,0,0)
		_NormalIntensity("Normal Intensity", Range( 0 , 1)) = 0.5
		_NormalRandomizeUV("Normal Randomize UV", Range( 0 , 1)) = 0.26
		[Header(Displacement)]_HeightUVTiling("Height UV Tiling", Vector) = (1,1,0,0)
		_HeightSpeed("Height Speed", Vector) = (1,1,0,0)
		_HeightIntensity("Height Intensity", Float) = 1
		_HeightPower("Height  Power", Float) = 1
		_HeightRandomizeUV("Height Randomize UV", Range( 0 , 1)) = 0.26
		_Metallic("Metallic", Range( 0 , 1)) = 0.2
		_Roughness("Roughness", Range( 0 , 1)) = 0.05
		[Toggle(_USESTEPFORFLOW_ON)] _useStepforFlow("use Step for Flow?", Float) = 0
		[ASEEnd]_Opacity("Opacity", Range( 0 , 1)) = 1


		//_TransmissionShadow( "Transmission Shadow", Range( 0, 1 ) ) = 0.5
		//_TransStrength( "Trans Strength", Range( 0, 50 ) ) = 1
		//_TransNormal( "Trans Normal Distortion", Range( 0, 1 ) ) = 0.5
		//_TransScattering( "Trans Scattering", Range( 1, 50 ) ) = 2
		//_TransDirect( "Trans Direct", Range( 0, 1 ) ) = 0.9
		//_TransAmbient( "Trans Ambient", Range( 0, 1 ) ) = 0.1
		//_TransShadow( "Trans Shadow", Range( 0, 1 ) ) = 0.5
		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		[HideInInspector][ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
		[HideInInspector][ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0
		[HideInInspector][ToggleOff] _ReceiveShadows("Receive Shadows", Float) = 1.0

		[HideInInspector] _QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector] _QueueControl("_QueueControl", Float) = -1

        [HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" }

		Cull Back
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		AlphaToMask Off

		

		HLSLINCLUDE
		#pragma target 3.5
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"

		#ifndef ASE_TESS_FUNCS
		#define ASE_TESS_FUNCS
		float4 FixedTess( float tessValue )
		{
			return tessValue;
		}

		float CalcDistanceTessFactor (float4 vertex, float minDist, float maxDist, float tess, float4x4 o2w, float3 cameraPos )
		{
			float3 wpos = mul(o2w,vertex).xyz;
			float dist = distance (wpos, cameraPos);
			float f = clamp(1.0 - (dist - minDist) / (maxDist - minDist), 0.01, 1.0) * tess;
			return f;
		}

		float4 CalcTriEdgeTessFactors (float3 triVertexFactors)
		{
			float4 tess;
			tess.x = 0.5 * (triVertexFactors.y + triVertexFactors.z);
			tess.y = 0.5 * (triVertexFactors.x + triVertexFactors.z);
			tess.z = 0.5 * (triVertexFactors.x + triVertexFactors.y);
			tess.w = (triVertexFactors.x + triVertexFactors.y + triVertexFactors.z) / 3.0f;
			return tess;
		}

		float CalcEdgeTessFactor (float3 wpos0, float3 wpos1, float edgeLen, float3 cameraPos, float4 scParams )
		{
			float dist = distance (0.5 * (wpos0+wpos1), cameraPos);
			float len = distance(wpos0, wpos1);
			float f = max(len * scParams.y / (edgeLen * dist), 1.0);
			return f;
		}

		float DistanceFromPlane (float3 pos, float4 plane)
		{
			float d = dot (float4(pos,1.0f), plane);
			return d;
		}

		bool WorldViewFrustumCull (float3 wpos0, float3 wpos1, float3 wpos2, float cullEps, float4 planes[6] )
		{
			float4 planeTest;
			planeTest.x = (( DistanceFromPlane(wpos0, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[0]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[0]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.y = (( DistanceFromPlane(wpos0, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[1]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[1]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.z = (( DistanceFromPlane(wpos0, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[2]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[2]) > -cullEps) ? 1.0f : 0.0f );
			planeTest.w = (( DistanceFromPlane(wpos0, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos1, planes[3]) > -cullEps) ? 1.0f : 0.0f ) +
							(( DistanceFromPlane(wpos2, planes[3]) > -cullEps) ? 1.0f : 0.0f );
			return !all (planeTest);
		}

		float4 DistanceBasedTess( float4 v0, float4 v1, float4 v2, float tess, float minDist, float maxDist, float4x4 o2w, float3 cameraPos )
		{
			float3 f;
			f.x = CalcDistanceTessFactor (v0,minDist,maxDist,tess,o2w,cameraPos);
			f.y = CalcDistanceTessFactor (v1,minDist,maxDist,tess,o2w,cameraPos);
			f.z = CalcDistanceTessFactor (v2,minDist,maxDist,tess,o2w,cameraPos);

			return CalcTriEdgeTessFactors (f);
		}

		float4 EdgeLengthBasedTess( float4 v0, float4 v1, float4 v2, float edgeLength, float4x4 o2w, float3 cameraPos, float4 scParams )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;
			tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
			tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
			tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
			tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			return tess;
		}

		float4 EdgeLengthBasedTessCull( float4 v0, float4 v1, float4 v2, float edgeLength, float maxDisplacement, float4x4 o2w, float3 cameraPos, float4 scParams, float4 planes[6] )
		{
			float3 pos0 = mul(o2w,v0).xyz;
			float3 pos1 = mul(o2w,v1).xyz;
			float3 pos2 = mul(o2w,v2).xyz;
			float4 tess;

			if (WorldViewFrustumCull(pos0, pos1, pos2, maxDisplacement, planes))
			{
				tess = 0.0f;
			}
			else
			{
				tess.x = CalcEdgeTessFactor (pos1, pos2, edgeLength, cameraPos, scParams);
				tess.y = CalcEdgeTessFactor (pos2, pos0, edgeLength, cameraPos, scParams);
				tess.z = CalcEdgeTessFactor (pos0, pos1, edgeLength, cameraPos, scParams);
				tess.w = (tess.x + tess.y + tess.z) / 3.0f;
			}
			return tess;
		}
		#endif //ASE_TESS_FUNCS
		ENDHLSL

		
		Pass
		{
			
			Name "Forward"
			Tags { "LightMode"="UniversalForward" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite Off
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120108
			#define REQUIRE_DEPTH_TEXTURE 1
			#define REQUIRE_OPAQUE_TEXTURE 1


			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _LIGHT_LAYERS
			#pragma multi_compile_fragment _ _LIGHT_COOKIES
			#pragma multi_compile _ _CLUSTERED_RENDERING
			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ DEBUG_DISPLAY

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_FORWARD

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _USESTEPFORFLOW_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					float4 screenPos : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
					float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _ColorShallow;
			float4 _ColorDeep;
			float4 _WaterFoamColor;
			float2 _FlowSpeed;
			float2 _HeightSpeed;
			float2 _HeightUVTiling;
			float2 _FoamSpeed;
			float2 _FoamUVTiling;
			float2 _FlowUVTiling;
			float2 _NormalUVTiling;
			float2 _NormalSpeed;
			float2 _EdgeFoamSpeed;
			float _HeightIntensity;
			float _FoamPower;
			float _NormalIntensity;
			float _RefractionStrength;
			float _RefractionDepth;
			float _Metallic;
			float _NormalRandomizeUV;
			float _FoamRandomizeUV;
			float _FlowRandomizeUV;
			float _FlowPower;
			float _Roughness;
			float _FlowIntensity;
			float _EdgeFoamIntensity;
			float _EdgeFoamScale;
			float _EdgeFoamCutoff;
			float _EdgeFoamDepthFade;
			float _WaterFoamColorIntensity;
			float _ColorDepthFade;
			float _HeightPower;
			float _HeightRandomizeUV;
			float _FoamIntensity;
			float _Opacity;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _HeightMap;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _FlowMask;
			sampler2D _FoamMask;
			sampler2D _NormalMap;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float temp_output_7_0_g69 = ( _HeightRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g68 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g68 = ( _TimeParameters.x * _HeightSpeed + ( _HeightUVTiling * texCoord5_g68 ));
				float2 temp_output_2_0_g69 = panner7_g68;
				float2 panner9_g69 = ( temp_output_7_0_g69 * float2( 0.1,0.1 ) + temp_output_2_0_g69);
				float2 panner13_g69 = ( temp_output_7_0_g69 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g69 + float2( 0.45,0.3 ) ));
				float2 panner18_g69 = ( temp_output_7_0_g69 * float2( -0.1,0.1 ) + ( temp_output_2_0_g69 + float2( 0.85,0.14 ) ));
				float4 temp_cast_0 = (_HeightPower).xxxx;
				float4 vDisplacement160 = ( ( _HeightIntensity * pow( ( ( ( tex2Dlod( _HeightMap, float4( panner9_g69, 0, 0.0) ) + tex2Dlod( _HeightMap, float4( panner13_g69, 0, 0.0) ) ) + tex2Dlod( _HeightMap, float4( panner18_g69, 0, 0.0) ) ) * 0.25 ) , temp_cast_0 ) ) * float4( v.ase_normal , 0.0 ) );
				
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord8.z = eyeDepth;
				
				o.ase_texcoord8.xy = v.texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vDisplacement160.rgb;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif
				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord;
					o.lightmapUVOrVertexSH.xy = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );

				#ifdef ASE_FOG
					half fogFactor = ComputeFogFactor( positionCS.z );
				#else
					half fogFactor = 0;
				#endif

				o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					o.screenPos = ComputeScreenPos(positionCS);
				#endif

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag ( VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					float4 ScreenPos = IN.screenPos;
				#endif

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth65 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth65 = abs( ( screenDepth65 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _ColorDepthFade ) );
				float4 lerpResult69 = lerp( _ColorShallow , _ColorDeep , saturate( distanceDepth65 ));
				float temp_output_7_0_g69 = ( _HeightRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g68 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g68 = ( _TimeParameters.x * _HeightSpeed + ( _HeightUVTiling * texCoord5_g68 ));
				float2 temp_output_2_0_g69 = panner7_g68;
				float2 panner9_g69 = ( temp_output_7_0_g69 * float2( 0.1,0.1 ) + temp_output_2_0_g69);
				float2 panner13_g69 = ( temp_output_7_0_g69 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g69 + float2( 0.45,0.3 ) ));
				float2 panner18_g69 = ( temp_output_7_0_g69 * float2( -0.1,0.1 ) + ( temp_output_2_0_g69 + float2( 0.85,0.14 ) ));
				float4 temp_cast_0 = (_HeightPower).xxxx;
				float4 vDisplacement160 = ( ( _HeightIntensity * pow( ( ( ( tex2D( _HeightMap, panner9_g69 ) + tex2D( _HeightMap, panner13_g69 ) ) + tex2D( _HeightMap, panner18_g69 ) ) * 0.25 ) , temp_cast_0 ) ) * float4( IN.ase_normal , 0.0 ) );
				float4 lerpResult72 = lerp( lerpResult69 , ( lerpResult69 + float4( 0.5,0.5,0.5,0 ) ) , vDisplacement160);
				float4 vColorWaves73 = lerpResult72;
				float4 vFoamColor169 = ( _WaterFoamColor * _WaterFoamColorIntensity );
				float screenDepth9_g53 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth9_g53 = abs( ( screenDepth9_g53 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _EdgeFoamDepthFade ) );
				float mulTime4_g53 = _TimeParameters.x * 0.1;
				float2 temp_cast_2 = (_EdgeFoamScale).xx;
				float2 texCoord2_g53 = IN.ase_texcoord8.xy * temp_cast_2 + float2( 0,0 );
				float2 panner6_g53 = ( mulTime4_g53 * _EdgeFoamSpeed + texCoord2_g53);
				float simpleNoise13_g53 = SimpleNoise( panner6_g53*50.0 );
				float temp_output_22_0_g53 = ( step( ( saturate( distanceDepth9_g53 ) * _EdgeFoamCutoff ) , simpleNoise13_g53 ) * _EdgeFoamIntensity );
				float vEdgeFoam167 = temp_output_22_0_g53;
				float temp_output_7_0_g65 = ( _FlowRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g64 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g64 = ( _TimeParameters.x * _FlowSpeed + ( _FlowUVTiling * texCoord5_g64 ));
				float2 temp_output_2_0_g65 = panner7_g64;
				float2 panner9_g65 = ( temp_output_7_0_g65 * float2( 0.1,0.1 ) + temp_output_2_0_g65);
				float2 panner13_g65 = ( temp_output_7_0_g65 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g65 + float2( 0.45,0.3 ) ));
				float2 panner18_g65 = ( temp_output_7_0_g65 * float2( -0.1,0.1 ) + ( temp_output_2_0_g65 + float2( 0.85,0.14 ) ));
				float4 temp_cast_3 = (_FlowPower).xxxx;
				float4 vFlow168 = ( _FlowIntensity * pow( ( ( ( tex2D( _FlowMask, panner9_g65 ) + tex2D( _FlowMask, panner13_g65 ) ) + tex2D( _FlowMask, panner18_g65 ) ) * 0.25 ) , temp_cast_3 ) );
				float4 temp_output_37_0 = ( vEdgeFoam167 + vFlow168 );
				float temp_output_7_0_g67 = ( _FoamRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g66 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g66 = ( _TimeParameters.x * _FoamSpeed + ( _FoamUVTiling * texCoord5_g66 ));
				float2 temp_output_2_0_g67 = panner7_g66;
				float2 panner9_g67 = ( temp_output_7_0_g67 * float2( 0.1,0.1 ) + temp_output_2_0_g67);
				float2 panner13_g67 = ( temp_output_7_0_g67 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g67 + float2( 0.45,0.3 ) ));
				float2 panner18_g67 = ( temp_output_7_0_g67 * float2( -0.1,0.1 ) + ( temp_output_2_0_g67 + float2( 0.85,0.14 ) ));
				float4 temp_cast_4 = (_FoamPower).xxxx;
				float4 temp_output_198_0 = ( _FoamIntensity * pow( ( ( ( tex2D( _FoamMask, panner9_g67 ) + tex2D( _FoamMask, panner13_g67 ) ) + tex2D( _FoamMask, panner18_g67 ) ) * 0.25 ) , temp_cast_4 ) );
				float4 vSurfaceFoam166 = temp_output_198_0;
				float4 lerpResult47 = lerp( temp_output_37_0 , float4( 0,0,0,0 ) , vSurfaceFoam166);
				#ifdef _USESTEPFORFLOW_ON
				float staticSwitch185 = ( (step( temp_output_37_0 , vSurfaceFoam166 )).r + vEdgeFoam167 );
				#else
				float staticSwitch185 = (lerpResult47).r;
				#endif
				float clampResult59 = clamp( staticSwitch185 , 0.0 , 1.0 );
				float4 vFoam175 = ( vFoamColor169 * clampResult59 );
				float4 temp_output_77_0 = ( vColorWaves73 + vFoam175 );
				float temp_output_7_0_g71 = ( _NormalRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g70 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g70 = ( _TimeParameters.x * _NormalSpeed + ( _NormalUVTiling * texCoord5_g70 ));
				float2 temp_output_2_0_g71 = panner7_g70;
				float2 panner9_g71 = ( temp_output_7_0_g71 * float2( 0.1,0.1 ) + temp_output_2_0_g71);
				float temp_output_24_0_g71 = _NormalIntensity;
				float3 unpack10_g71 = UnpackNormalScale( tex2D( _NormalMap, panner9_g71 ), temp_output_24_0_g71 );
				unpack10_g71.z = lerp( 1, unpack10_g71.z, saturate(temp_output_24_0_g71) );
				float2 panner13_g71 = ( temp_output_7_0_g71 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g71 + float2( 0.45,0.3 ) ));
				float3 unpack14_g71 = UnpackNormalScale( tex2D( _NormalMap, panner13_g71 ), temp_output_24_0_g71 );
				unpack14_g71.z = lerp( 1, unpack14_g71.z, saturate(temp_output_24_0_g71) );
				float2 panner18_g71 = ( temp_output_7_0_g71 * float2( -0.1,0.1 ) + ( temp_output_2_0_g71 + float2( 0.85,0.14 ) ));
				float3 unpack20_g71 = UnpackNormalScale( tex2D( _NormalMap, panner18_g71 ), temp_output_24_0_g71 );
				unpack20_g71.z = lerp( 1, unpack20_g71.z, saturate(temp_output_24_0_g71) );
				float3 vNormal154 = BlendNormal( BlendNormal( unpack10_g71 , unpack14_g71 ) , unpack20_g71 );
				float eyeDepth = IN.ase_texcoord8.z;
				float eyeDepth28_g72 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float2 temp_output_20_0_g72 = ( (vNormal154).xy * ( _RefractionStrength / max( eyeDepth , 0.1 ) ) * saturate( ( eyeDepth28_g72 - eyeDepth ) ) );
				float eyeDepth2_g72 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ( float4( temp_output_20_0_g72, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float2 temp_output_32_0_g72 = (( float4( ( temp_output_20_0_g72 * saturate( ( eyeDepth2_g72 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				float4 fetchOpaqueVal125 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( temp_output_32_0_g72 ), 1.0 );
				float4 vRefraction126 = fetchOpaqueVal125;
				float4 blendOpSrc131 = temp_output_77_0;
				float4 blendOpDest131 = vRefraction126;
				float screenDepth129 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth129 = abs( ( screenDepth129 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _RefractionDepth ) );
				float4 lerpResult133 = lerp( ( saturate( (( blendOpDest131 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest131 ) * ( 1.0 - blendOpSrc131 ) ) : ( 2.0 * blendOpDest131 * blendOpSrc131 ) ) )) , temp_output_77_0 , saturate( distanceDepth129 ));
				float4 vFinalColor180 = lerpResult133;
				

				float3 BaseColor = vFinalColor180.rgb;
				float3 Normal = vNormal154;
				float3 Emission = 0;
				float3 Specular = 0.5;
				float Metallic = _Metallic;
				float Smoothness = ( 1.0 - _Roughness );
				float Occlusion = 1;
				float Alpha = _Opacity;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _CLEARCOAT
					float CoatMask = 0;
					float CoatSmoothness = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;

				#ifdef _NORMALMAP
						#if _NORMAL_DROPOFF_TS
							inputData.normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent, WorldBiTangent, WorldNormal));
						#elif _NORMAL_DROPOFF_OS
							inputData.normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							inputData.normalWS = Normal;
						#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = WorldNormal;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					inputData.shadowCoord = ShadowCoords;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
				#else
					inputData.shadowCoord = float4(0, 0, 0, 0);
				#endif

				#ifdef ASE_FOG
					inputData.fogCoord = IN.fogFactorAndVertexLight.x;
				#endif
					inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
				#else
					inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS);
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
					#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				SurfaceData surfaceData;
				surfaceData.albedo              = BaseColor;
				surfaceData.metallic            = saturate(Metallic);
				surfaceData.specular            = Specular;
				surfaceData.smoothness          = saturate(Smoothness),
				surfaceData.occlusion           = Occlusion,
				surfaceData.emission            = Emission,
				surfaceData.alpha               = saturate(Alpha);
				surfaceData.normalTS            = Normal;
				surfaceData.clearCoatMask       = 0;
				surfaceData.clearCoatSmoothness = 1;

				#ifdef _CLEARCOAT
					surfaceData.clearCoatMask       = saturate(CoatMask);
					surfaceData.clearCoatSmoothness = saturate(CoatSmoothness);
				#endif

				#ifdef _DBUFFER
					ApplyDecalToSurfaceData(IN.clipPos, surfaceData, inputData);
				#endif

				half4 color = UniversalFragmentPBR( inputData, surfaceData);

				#ifdef ASE_TRANSMISSION
				{
					float shadow = _TransmissionShadow;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );
					half3 mainTransmission = max(0 , -dot(inputData.normalWS, mainLight.direction)) * mainAtten * Transmission;
					color.rgb += BaseColor * mainTransmission;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 transmission = max(0 , -dot(inputData.normalWS, light.direction)) * atten * Transmission;
							color.rgb += BaseColor * transmission;
						}
					#endif
				}
				#endif

				#ifdef ASE_TRANSLUCENCY
				{
					float shadow = _TransShadow;
					float normal = _TransNormal;
					float scattering = _TransScattering;
					float direct = _TransDirect;
					float ambient = _TransAmbient;
					float strength = _TransStrength;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );

					half3 mainLightDir = mainLight.direction + inputData.normalWS * normal;
					half mainVdotL = pow( saturate( dot( inputData.viewDirectionWS, -mainLightDir ) ), scattering );
					half3 mainTranslucency = mainAtten * ( mainVdotL * direct + inputData.bakedGI * ambient ) * Translucency;
					color.rgb += BaseColor * mainTranslucency * strength;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 lightDir = light.direction + inputData.normalWS * normal;
							half VdotL = pow( saturate( dot( inputData.viewDirectionWS, -lightDir ) ), scattering );
							half3 translucency = atten * ( VdotL * direct + inputData.bakedGI * ambient ) * Translucency;
							color.rgb += BaseColor * translucency * strength;
						}
					#endif
				}
				#endif

				#ifdef ASE_REFRACTION
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, float4( WorldNormal,0 ) ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos.xy ) * RefractionColor;
					color.rgb = lerp( refraction, color.rgb, color.a );
					color.a = 1;
				#endif

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_FOG
					#ifdef TERRAIN_SPLAT_ADDPASS
						color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
					#else
						color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
					#endif
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return color;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ShadowCaster"
			Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual
			AlphaToMask Off
			ColorMask 0

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120108


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

			#define SHADERPASS SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _ColorShallow;
			float4 _ColorDeep;
			float4 _WaterFoamColor;
			float2 _FlowSpeed;
			float2 _HeightSpeed;
			float2 _HeightUVTiling;
			float2 _FoamSpeed;
			float2 _FoamUVTiling;
			float2 _FlowUVTiling;
			float2 _NormalUVTiling;
			float2 _NormalSpeed;
			float2 _EdgeFoamSpeed;
			float _HeightIntensity;
			float _FoamPower;
			float _NormalIntensity;
			float _RefractionStrength;
			float _RefractionDepth;
			float _Metallic;
			float _NormalRandomizeUV;
			float _FoamRandomizeUV;
			float _FlowRandomizeUV;
			float _FlowPower;
			float _Roughness;
			float _FlowIntensity;
			float _EdgeFoamIntensity;
			float _EdgeFoamScale;
			float _EdgeFoamCutoff;
			float _EdgeFoamDepthFade;
			float _WaterFoamColorIntensity;
			float _ColorDepthFade;
			float _HeightPower;
			float _HeightRandomizeUV;
			float _FoamIntensity;
			float _Opacity;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _HeightMap;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			
			float3 _LightDirection;
			float3 _LightPosition;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float temp_output_7_0_g69 = ( _HeightRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g68 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g68 = ( _TimeParameters.x * _HeightSpeed + ( _HeightUVTiling * texCoord5_g68 ));
				float2 temp_output_2_0_g69 = panner7_g68;
				float2 panner9_g69 = ( temp_output_7_0_g69 * float2( 0.1,0.1 ) + temp_output_2_0_g69);
				float2 panner13_g69 = ( temp_output_7_0_g69 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g69 + float2( 0.45,0.3 ) ));
				float2 panner18_g69 = ( temp_output_7_0_g69 * float2( -0.1,0.1 ) + ( temp_output_2_0_g69 + float2( 0.85,0.14 ) ));
				float4 temp_cast_0 = (_HeightPower).xxxx;
				float4 vDisplacement160 = ( ( _HeightIntensity * pow( ( ( ( tex2Dlod( _HeightMap, float4( panner9_g69, 0, 0.0) ) + tex2Dlod( _HeightMap, float4( panner13_g69, 0, 0.0) ) ) + tex2Dlod( _HeightMap, float4( panner18_g69, 0, 0.0) ) ) * 0.25 ) , temp_cast_0 ) ) * float4( v.ase_normal , 0.0 ) );
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vDisplacement160.rgb;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				#if _CASTING_PUNCTUAL_LIGHT_SHADOW
					float3 lightDirectionWS = normalize(_LightPosition - positionWS);
				#else
					float3 lightDirectionWS = _LightDirection;
				#endif

				float4 clipPos = TransformWorldToHClip(ApplyShadowBias(positionWS, normalWS, lightDirectionWS));

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, UNITY_NEAR_CLIP_VALUE);
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = clipPos;

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				

				float Alpha = _Opacity;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					#ifdef _ALPHATEST_SHADOW_ON
						clip(Alpha - AlphaClipThresholdShadow);
					#else
						clip(Alpha - AlphaClipThreshold);
					#endif
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthOnly"
			Tags { "LightMode"="DepthOnly" }

			ZWrite On
			ColorMask 0
			AlphaToMask Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120108


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
				float4 shadowCoord : TEXCOORD1;
				#endif
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _ColorShallow;
			float4 _ColorDeep;
			float4 _WaterFoamColor;
			float2 _FlowSpeed;
			float2 _HeightSpeed;
			float2 _HeightUVTiling;
			float2 _FoamSpeed;
			float2 _FoamUVTiling;
			float2 _FlowUVTiling;
			float2 _NormalUVTiling;
			float2 _NormalSpeed;
			float2 _EdgeFoamSpeed;
			float _HeightIntensity;
			float _FoamPower;
			float _NormalIntensity;
			float _RefractionStrength;
			float _RefractionDepth;
			float _Metallic;
			float _NormalRandomizeUV;
			float _FoamRandomizeUV;
			float _FlowRandomizeUV;
			float _FlowPower;
			float _Roughness;
			float _FlowIntensity;
			float _EdgeFoamIntensity;
			float _EdgeFoamScale;
			float _EdgeFoamCutoff;
			float _EdgeFoamDepthFade;
			float _WaterFoamColorIntensity;
			float _ColorDepthFade;
			float _HeightPower;
			float _HeightRandomizeUV;
			float _FoamIntensity;
			float _Opacity;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _HeightMap;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float temp_output_7_0_g69 = ( _HeightRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g68 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g68 = ( _TimeParameters.x * _HeightSpeed + ( _HeightUVTiling * texCoord5_g68 ));
				float2 temp_output_2_0_g69 = panner7_g68;
				float2 panner9_g69 = ( temp_output_7_0_g69 * float2( 0.1,0.1 ) + temp_output_2_0_g69);
				float2 panner13_g69 = ( temp_output_7_0_g69 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g69 + float2( 0.45,0.3 ) ));
				float2 panner18_g69 = ( temp_output_7_0_g69 * float2( -0.1,0.1 ) + ( temp_output_2_0_g69 + float2( 0.85,0.14 ) ));
				float4 temp_cast_0 = (_HeightPower).xxxx;
				float4 vDisplacement160 = ( ( _HeightIntensity * pow( ( ( ( tex2Dlod( _HeightMap, float4( panner9_g69, 0, 0.0) ) + tex2Dlod( _HeightMap, float4( panner13_g69, 0, 0.0) ) ) + tex2Dlod( _HeightMap, float4( panner18_g69, 0, 0.0) ) ) * 0.25 ) , temp_cast_0 ) ) * float4( v.ase_normal , 0.0 ) );
				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vDisplacement160.rgb;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				

				float Alpha = _Opacity;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120108
			#define REQUIRE_DEPTH_TEXTURE 1
			#define REQUIRE_OPAQUE_TEXTURE 1


			#pragma vertex vert
			#pragma fragment frag

			#pragma shader_feature EDITOR_VISUALIZATION

			#define SHADERPASS SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _USESTEPFORFLOW_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				#ifdef EDITOR_VISUALIZATION
					float4 VizUV : TEXCOORD2;
					float4 LightCoord : TEXCOORD3;
				#endif
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _ColorShallow;
			float4 _ColorDeep;
			float4 _WaterFoamColor;
			float2 _FlowSpeed;
			float2 _HeightSpeed;
			float2 _HeightUVTiling;
			float2 _FoamSpeed;
			float2 _FoamUVTiling;
			float2 _FlowUVTiling;
			float2 _NormalUVTiling;
			float2 _NormalSpeed;
			float2 _EdgeFoamSpeed;
			float _HeightIntensity;
			float _FoamPower;
			float _NormalIntensity;
			float _RefractionStrength;
			float _RefractionDepth;
			float _Metallic;
			float _NormalRandomizeUV;
			float _FoamRandomizeUV;
			float _FlowRandomizeUV;
			float _FlowPower;
			float _Roughness;
			float _FlowIntensity;
			float _EdgeFoamIntensity;
			float _EdgeFoamScale;
			float _EdgeFoamCutoff;
			float _EdgeFoamDepthFade;
			float _WaterFoamColorIntensity;
			float _ColorDepthFade;
			float _HeightPower;
			float _HeightRandomizeUV;
			float _FoamIntensity;
			float _Opacity;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _HeightMap;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _FlowMask;
			sampler2D _FoamMask;
			sampler2D _NormalMap;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float temp_output_7_0_g69 = ( _HeightRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g68 = v.texcoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g68 = ( _TimeParameters.x * _HeightSpeed + ( _HeightUVTiling * texCoord5_g68 ));
				float2 temp_output_2_0_g69 = panner7_g68;
				float2 panner9_g69 = ( temp_output_7_0_g69 * float2( 0.1,0.1 ) + temp_output_2_0_g69);
				float2 panner13_g69 = ( temp_output_7_0_g69 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g69 + float2( 0.45,0.3 ) ));
				float2 panner18_g69 = ( temp_output_7_0_g69 * float2( -0.1,0.1 ) + ( temp_output_2_0_g69 + float2( 0.85,0.14 ) ));
				float4 temp_cast_0 = (_HeightPower).xxxx;
				float4 vDisplacement160 = ( ( _HeightIntensity * pow( ( ( ( tex2Dlod( _HeightMap, float4( panner9_g69, 0, 0.0) ) + tex2Dlod( _HeightMap, float4( panner13_g69, 0, 0.0) ) ) + tex2Dlod( _HeightMap, float4( panner18_g69, 0, 0.0) ) ) * 0.25 ) , temp_cast_0 ) ) * float4( v.ase_normal , 0.0 ) );
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord5.z = eyeDepth;
				
				o.ase_texcoord5.xy = v.texcoord0.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vDisplacement160.rgb;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );

				#ifdef EDITOR_VISUALIZATION
					float2 VizUV = 0;
					float4 LightCoord = 0;
					UnityEditorVizData(v.vertex.xyz, v.texcoord0.xy, v.texcoord1.xy, v.texcoord2.xy, VizUV, LightCoord);
					o.VizUV = float4(VizUV, 0, 0);
					o.LightCoord = LightCoord;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.texcoord0 = v.texcoord0;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.texcoord0 = patch[0].texcoord0 * bary.x + patch[1].texcoord0 * bary.y + patch[2].texcoord0 * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float4 screenPos = IN.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth65 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth65 = abs( ( screenDepth65 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _ColorDepthFade ) );
				float4 lerpResult69 = lerp( _ColorShallow , _ColorDeep , saturate( distanceDepth65 ));
				float temp_output_7_0_g69 = ( _HeightRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g68 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g68 = ( _TimeParameters.x * _HeightSpeed + ( _HeightUVTiling * texCoord5_g68 ));
				float2 temp_output_2_0_g69 = panner7_g68;
				float2 panner9_g69 = ( temp_output_7_0_g69 * float2( 0.1,0.1 ) + temp_output_2_0_g69);
				float2 panner13_g69 = ( temp_output_7_0_g69 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g69 + float2( 0.45,0.3 ) ));
				float2 panner18_g69 = ( temp_output_7_0_g69 * float2( -0.1,0.1 ) + ( temp_output_2_0_g69 + float2( 0.85,0.14 ) ));
				float4 temp_cast_0 = (_HeightPower).xxxx;
				float4 vDisplacement160 = ( ( _HeightIntensity * pow( ( ( ( tex2D( _HeightMap, panner9_g69 ) + tex2D( _HeightMap, panner13_g69 ) ) + tex2D( _HeightMap, panner18_g69 ) ) * 0.25 ) , temp_cast_0 ) ) * float4( IN.ase_normal , 0.0 ) );
				float4 lerpResult72 = lerp( lerpResult69 , ( lerpResult69 + float4( 0.5,0.5,0.5,0 ) ) , vDisplacement160);
				float4 vColorWaves73 = lerpResult72;
				float4 vFoamColor169 = ( _WaterFoamColor * _WaterFoamColorIntensity );
				float screenDepth9_g53 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth9_g53 = abs( ( screenDepth9_g53 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _EdgeFoamDepthFade ) );
				float mulTime4_g53 = _TimeParameters.x * 0.1;
				float2 temp_cast_2 = (_EdgeFoamScale).xx;
				float2 texCoord2_g53 = IN.ase_texcoord5.xy * temp_cast_2 + float2( 0,0 );
				float2 panner6_g53 = ( mulTime4_g53 * _EdgeFoamSpeed + texCoord2_g53);
				float simpleNoise13_g53 = SimpleNoise( panner6_g53*50.0 );
				float temp_output_22_0_g53 = ( step( ( saturate( distanceDepth9_g53 ) * _EdgeFoamCutoff ) , simpleNoise13_g53 ) * _EdgeFoamIntensity );
				float vEdgeFoam167 = temp_output_22_0_g53;
				float temp_output_7_0_g65 = ( _FlowRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g64 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g64 = ( _TimeParameters.x * _FlowSpeed + ( _FlowUVTiling * texCoord5_g64 ));
				float2 temp_output_2_0_g65 = panner7_g64;
				float2 panner9_g65 = ( temp_output_7_0_g65 * float2( 0.1,0.1 ) + temp_output_2_0_g65);
				float2 panner13_g65 = ( temp_output_7_0_g65 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g65 + float2( 0.45,0.3 ) ));
				float2 panner18_g65 = ( temp_output_7_0_g65 * float2( -0.1,0.1 ) + ( temp_output_2_0_g65 + float2( 0.85,0.14 ) ));
				float4 temp_cast_3 = (_FlowPower).xxxx;
				float4 vFlow168 = ( _FlowIntensity * pow( ( ( ( tex2D( _FlowMask, panner9_g65 ) + tex2D( _FlowMask, panner13_g65 ) ) + tex2D( _FlowMask, panner18_g65 ) ) * 0.25 ) , temp_cast_3 ) );
				float4 temp_output_37_0 = ( vEdgeFoam167 + vFlow168 );
				float temp_output_7_0_g67 = ( _FoamRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g66 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g66 = ( _TimeParameters.x * _FoamSpeed + ( _FoamUVTiling * texCoord5_g66 ));
				float2 temp_output_2_0_g67 = panner7_g66;
				float2 panner9_g67 = ( temp_output_7_0_g67 * float2( 0.1,0.1 ) + temp_output_2_0_g67);
				float2 panner13_g67 = ( temp_output_7_0_g67 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g67 + float2( 0.45,0.3 ) ));
				float2 panner18_g67 = ( temp_output_7_0_g67 * float2( -0.1,0.1 ) + ( temp_output_2_0_g67 + float2( 0.85,0.14 ) ));
				float4 temp_cast_4 = (_FoamPower).xxxx;
				float4 temp_output_198_0 = ( _FoamIntensity * pow( ( ( ( tex2D( _FoamMask, panner9_g67 ) + tex2D( _FoamMask, panner13_g67 ) ) + tex2D( _FoamMask, panner18_g67 ) ) * 0.25 ) , temp_cast_4 ) );
				float4 vSurfaceFoam166 = temp_output_198_0;
				float4 lerpResult47 = lerp( temp_output_37_0 , float4( 0,0,0,0 ) , vSurfaceFoam166);
				#ifdef _USESTEPFORFLOW_ON
				float staticSwitch185 = ( (step( temp_output_37_0 , vSurfaceFoam166 )).r + vEdgeFoam167 );
				#else
				float staticSwitch185 = (lerpResult47).r;
				#endif
				float clampResult59 = clamp( staticSwitch185 , 0.0 , 1.0 );
				float4 vFoam175 = ( vFoamColor169 * clampResult59 );
				float4 temp_output_77_0 = ( vColorWaves73 + vFoam175 );
				float temp_output_7_0_g71 = ( _NormalRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g70 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g70 = ( _TimeParameters.x * _NormalSpeed + ( _NormalUVTiling * texCoord5_g70 ));
				float2 temp_output_2_0_g71 = panner7_g70;
				float2 panner9_g71 = ( temp_output_7_0_g71 * float2( 0.1,0.1 ) + temp_output_2_0_g71);
				float temp_output_24_0_g71 = _NormalIntensity;
				float3 unpack10_g71 = UnpackNormalScale( tex2D( _NormalMap, panner9_g71 ), temp_output_24_0_g71 );
				unpack10_g71.z = lerp( 1, unpack10_g71.z, saturate(temp_output_24_0_g71) );
				float2 panner13_g71 = ( temp_output_7_0_g71 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g71 + float2( 0.45,0.3 ) ));
				float3 unpack14_g71 = UnpackNormalScale( tex2D( _NormalMap, panner13_g71 ), temp_output_24_0_g71 );
				unpack14_g71.z = lerp( 1, unpack14_g71.z, saturate(temp_output_24_0_g71) );
				float2 panner18_g71 = ( temp_output_7_0_g71 * float2( -0.1,0.1 ) + ( temp_output_2_0_g71 + float2( 0.85,0.14 ) ));
				float3 unpack20_g71 = UnpackNormalScale( tex2D( _NormalMap, panner18_g71 ), temp_output_24_0_g71 );
				unpack20_g71.z = lerp( 1, unpack20_g71.z, saturate(temp_output_24_0_g71) );
				float3 vNormal154 = BlendNormal( BlendNormal( unpack10_g71 , unpack14_g71 ) , unpack20_g71 );
				float eyeDepth = IN.ase_texcoord5.z;
				float eyeDepth28_g72 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float2 temp_output_20_0_g72 = ( (vNormal154).xy * ( _RefractionStrength / max( eyeDepth , 0.1 ) ) * saturate( ( eyeDepth28_g72 - eyeDepth ) ) );
				float eyeDepth2_g72 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ( float4( temp_output_20_0_g72, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float2 temp_output_32_0_g72 = (( float4( ( temp_output_20_0_g72 * saturate( ( eyeDepth2_g72 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				float4 fetchOpaqueVal125 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( temp_output_32_0_g72 ), 1.0 );
				float4 vRefraction126 = fetchOpaqueVal125;
				float4 blendOpSrc131 = temp_output_77_0;
				float4 blendOpDest131 = vRefraction126;
				float screenDepth129 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth129 = abs( ( screenDepth129 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _RefractionDepth ) );
				float4 lerpResult133 = lerp( ( saturate( (( blendOpDest131 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest131 ) * ( 1.0 - blendOpSrc131 ) ) : ( 2.0 * blendOpDest131 * blendOpSrc131 ) ) )) , temp_output_77_0 , saturate( distanceDepth129 ));
				float4 vFinalColor180 = lerpResult133;
				

				float3 BaseColor = vFinalColor180.rgb;
				float3 Emission = 0;
				float Alpha = _Opacity;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = BaseColor;
				metaInput.Emission = Emission;
				#ifdef EDITOR_VISUALIZATION
					metaInput.VizUV = IN.VizUV.xy;
					metaInput.LightCoord = IN.LightCoord;
				#endif

				return UnityMetaFragment(metaInput);
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "Universal2D"
			Tags { "LightMode"="Universal2D" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite Off
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120108
			#define REQUIRE_DEPTH_TEXTURE 1
			#define REQUIRE_OPAQUE_TEXTURE 1


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _USESTEPFORFLOW_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _ColorShallow;
			float4 _ColorDeep;
			float4 _WaterFoamColor;
			float2 _FlowSpeed;
			float2 _HeightSpeed;
			float2 _HeightUVTiling;
			float2 _FoamSpeed;
			float2 _FoamUVTiling;
			float2 _FlowUVTiling;
			float2 _NormalUVTiling;
			float2 _NormalSpeed;
			float2 _EdgeFoamSpeed;
			float _HeightIntensity;
			float _FoamPower;
			float _NormalIntensity;
			float _RefractionStrength;
			float _RefractionDepth;
			float _Metallic;
			float _NormalRandomizeUV;
			float _FoamRandomizeUV;
			float _FlowRandomizeUV;
			float _FlowPower;
			float _Roughness;
			float _FlowIntensity;
			float _EdgeFoamIntensity;
			float _EdgeFoamScale;
			float _EdgeFoamCutoff;
			float _EdgeFoamDepthFade;
			float _WaterFoamColorIntensity;
			float _ColorDepthFade;
			float _HeightPower;
			float _HeightRandomizeUV;
			float _FoamIntensity;
			float _Opacity;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _HeightMap;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _FlowMask;
			sampler2D _FoamMask;
			sampler2D _NormalMap;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float temp_output_7_0_g69 = ( _HeightRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g68 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g68 = ( _TimeParameters.x * _HeightSpeed + ( _HeightUVTiling * texCoord5_g68 ));
				float2 temp_output_2_0_g69 = panner7_g68;
				float2 panner9_g69 = ( temp_output_7_0_g69 * float2( 0.1,0.1 ) + temp_output_2_0_g69);
				float2 panner13_g69 = ( temp_output_7_0_g69 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g69 + float2( 0.45,0.3 ) ));
				float2 panner18_g69 = ( temp_output_7_0_g69 * float2( -0.1,0.1 ) + ( temp_output_2_0_g69 + float2( 0.85,0.14 ) ));
				float4 temp_cast_0 = (_HeightPower).xxxx;
				float4 vDisplacement160 = ( ( _HeightIntensity * pow( ( ( ( tex2Dlod( _HeightMap, float4( panner9_g69, 0, 0.0) ) + tex2Dlod( _HeightMap, float4( panner13_g69, 0, 0.0) ) ) + tex2Dlod( _HeightMap, float4( panner18_g69, 0, 0.0) ) ) * 0.25 ) , temp_cast_0 ) ) * float4( v.ase_normal , 0.0 ) );
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord3.z = eyeDepth;
				
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.w = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vDisplacement160.rgb;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN  ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float4 screenPos = IN.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth65 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth65 = abs( ( screenDepth65 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _ColorDepthFade ) );
				float4 lerpResult69 = lerp( _ColorShallow , _ColorDeep , saturate( distanceDepth65 ));
				float temp_output_7_0_g69 = ( _HeightRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g68 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g68 = ( _TimeParameters.x * _HeightSpeed + ( _HeightUVTiling * texCoord5_g68 ));
				float2 temp_output_2_0_g69 = panner7_g68;
				float2 panner9_g69 = ( temp_output_7_0_g69 * float2( 0.1,0.1 ) + temp_output_2_0_g69);
				float2 panner13_g69 = ( temp_output_7_0_g69 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g69 + float2( 0.45,0.3 ) ));
				float2 panner18_g69 = ( temp_output_7_0_g69 * float2( -0.1,0.1 ) + ( temp_output_2_0_g69 + float2( 0.85,0.14 ) ));
				float4 temp_cast_0 = (_HeightPower).xxxx;
				float4 vDisplacement160 = ( ( _HeightIntensity * pow( ( ( ( tex2D( _HeightMap, panner9_g69 ) + tex2D( _HeightMap, panner13_g69 ) ) + tex2D( _HeightMap, panner18_g69 ) ) * 0.25 ) , temp_cast_0 ) ) * float4( IN.ase_normal , 0.0 ) );
				float4 lerpResult72 = lerp( lerpResult69 , ( lerpResult69 + float4( 0.5,0.5,0.5,0 ) ) , vDisplacement160);
				float4 vColorWaves73 = lerpResult72;
				float4 vFoamColor169 = ( _WaterFoamColor * _WaterFoamColorIntensity );
				float screenDepth9_g53 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth9_g53 = abs( ( screenDepth9_g53 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _EdgeFoamDepthFade ) );
				float mulTime4_g53 = _TimeParameters.x * 0.1;
				float2 temp_cast_2 = (_EdgeFoamScale).xx;
				float2 texCoord2_g53 = IN.ase_texcoord3.xy * temp_cast_2 + float2( 0,0 );
				float2 panner6_g53 = ( mulTime4_g53 * _EdgeFoamSpeed + texCoord2_g53);
				float simpleNoise13_g53 = SimpleNoise( panner6_g53*50.0 );
				float temp_output_22_0_g53 = ( step( ( saturate( distanceDepth9_g53 ) * _EdgeFoamCutoff ) , simpleNoise13_g53 ) * _EdgeFoamIntensity );
				float vEdgeFoam167 = temp_output_22_0_g53;
				float temp_output_7_0_g65 = ( _FlowRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g64 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g64 = ( _TimeParameters.x * _FlowSpeed + ( _FlowUVTiling * texCoord5_g64 ));
				float2 temp_output_2_0_g65 = panner7_g64;
				float2 panner9_g65 = ( temp_output_7_0_g65 * float2( 0.1,0.1 ) + temp_output_2_0_g65);
				float2 panner13_g65 = ( temp_output_7_0_g65 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g65 + float2( 0.45,0.3 ) ));
				float2 panner18_g65 = ( temp_output_7_0_g65 * float2( -0.1,0.1 ) + ( temp_output_2_0_g65 + float2( 0.85,0.14 ) ));
				float4 temp_cast_3 = (_FlowPower).xxxx;
				float4 vFlow168 = ( _FlowIntensity * pow( ( ( ( tex2D( _FlowMask, panner9_g65 ) + tex2D( _FlowMask, panner13_g65 ) ) + tex2D( _FlowMask, panner18_g65 ) ) * 0.25 ) , temp_cast_3 ) );
				float4 temp_output_37_0 = ( vEdgeFoam167 + vFlow168 );
				float temp_output_7_0_g67 = ( _FoamRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g66 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g66 = ( _TimeParameters.x * _FoamSpeed + ( _FoamUVTiling * texCoord5_g66 ));
				float2 temp_output_2_0_g67 = panner7_g66;
				float2 panner9_g67 = ( temp_output_7_0_g67 * float2( 0.1,0.1 ) + temp_output_2_0_g67);
				float2 panner13_g67 = ( temp_output_7_0_g67 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g67 + float2( 0.45,0.3 ) ));
				float2 panner18_g67 = ( temp_output_7_0_g67 * float2( -0.1,0.1 ) + ( temp_output_2_0_g67 + float2( 0.85,0.14 ) ));
				float4 temp_cast_4 = (_FoamPower).xxxx;
				float4 temp_output_198_0 = ( _FoamIntensity * pow( ( ( ( tex2D( _FoamMask, panner9_g67 ) + tex2D( _FoamMask, panner13_g67 ) ) + tex2D( _FoamMask, panner18_g67 ) ) * 0.25 ) , temp_cast_4 ) );
				float4 vSurfaceFoam166 = temp_output_198_0;
				float4 lerpResult47 = lerp( temp_output_37_0 , float4( 0,0,0,0 ) , vSurfaceFoam166);
				#ifdef _USESTEPFORFLOW_ON
				float staticSwitch185 = ( (step( temp_output_37_0 , vSurfaceFoam166 )).r + vEdgeFoam167 );
				#else
				float staticSwitch185 = (lerpResult47).r;
				#endif
				float clampResult59 = clamp( staticSwitch185 , 0.0 , 1.0 );
				float4 vFoam175 = ( vFoamColor169 * clampResult59 );
				float4 temp_output_77_0 = ( vColorWaves73 + vFoam175 );
				float temp_output_7_0_g71 = ( _NormalRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g70 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g70 = ( _TimeParameters.x * _NormalSpeed + ( _NormalUVTiling * texCoord5_g70 ));
				float2 temp_output_2_0_g71 = panner7_g70;
				float2 panner9_g71 = ( temp_output_7_0_g71 * float2( 0.1,0.1 ) + temp_output_2_0_g71);
				float temp_output_24_0_g71 = _NormalIntensity;
				float3 unpack10_g71 = UnpackNormalScale( tex2D( _NormalMap, panner9_g71 ), temp_output_24_0_g71 );
				unpack10_g71.z = lerp( 1, unpack10_g71.z, saturate(temp_output_24_0_g71) );
				float2 panner13_g71 = ( temp_output_7_0_g71 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g71 + float2( 0.45,0.3 ) ));
				float3 unpack14_g71 = UnpackNormalScale( tex2D( _NormalMap, panner13_g71 ), temp_output_24_0_g71 );
				unpack14_g71.z = lerp( 1, unpack14_g71.z, saturate(temp_output_24_0_g71) );
				float2 panner18_g71 = ( temp_output_7_0_g71 * float2( -0.1,0.1 ) + ( temp_output_2_0_g71 + float2( 0.85,0.14 ) ));
				float3 unpack20_g71 = UnpackNormalScale( tex2D( _NormalMap, panner18_g71 ), temp_output_24_0_g71 );
				unpack20_g71.z = lerp( 1, unpack20_g71.z, saturate(temp_output_24_0_g71) );
				float3 vNormal154 = BlendNormal( BlendNormal( unpack10_g71 , unpack14_g71 ) , unpack20_g71 );
				float eyeDepth = IN.ase_texcoord3.z;
				float eyeDepth28_g72 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float2 temp_output_20_0_g72 = ( (vNormal154).xy * ( _RefractionStrength / max( eyeDepth , 0.1 ) ) * saturate( ( eyeDepth28_g72 - eyeDepth ) ) );
				float eyeDepth2_g72 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ( float4( temp_output_20_0_g72, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float2 temp_output_32_0_g72 = (( float4( ( temp_output_20_0_g72 * saturate( ( eyeDepth2_g72 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				float4 fetchOpaqueVal125 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( temp_output_32_0_g72 ), 1.0 );
				float4 vRefraction126 = fetchOpaqueVal125;
				float4 blendOpSrc131 = temp_output_77_0;
				float4 blendOpDest131 = vRefraction126;
				float screenDepth129 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth129 = abs( ( screenDepth129 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _RefractionDepth ) );
				float4 lerpResult133 = lerp( ( saturate( (( blendOpDest131 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest131 ) * ( 1.0 - blendOpSrc131 ) ) : ( 2.0 * blendOpDest131 * blendOpSrc131 ) ) )) , temp_output_77_0 , saturate( distanceDepth129 ));
				float4 vFinalColor180 = lerpResult133;
				

				float3 BaseColor = vFinalColor180.rgb;
				float Alpha = _Opacity;
				float AlphaClipThreshold = 0.5;

				half4 color = half4(BaseColor, Alpha );

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "DepthNormals"
			Tags { "LightMode"="DepthNormals" }

			ZWrite On
			Blend One Zero
			ZTest LEqual
			ZWrite On

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120108


			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 worldPos : TEXCOORD0;
				#endif
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					float4 shadowCoord : TEXCOORD1;
				#endif
				float3 worldNormal : TEXCOORD2;
				float4 worldTangent : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _ColorShallow;
			float4 _ColorDeep;
			float4 _WaterFoamColor;
			float2 _FlowSpeed;
			float2 _HeightSpeed;
			float2 _HeightUVTiling;
			float2 _FoamSpeed;
			float2 _FoamUVTiling;
			float2 _FlowUVTiling;
			float2 _NormalUVTiling;
			float2 _NormalSpeed;
			float2 _EdgeFoamSpeed;
			float _HeightIntensity;
			float _FoamPower;
			float _NormalIntensity;
			float _RefractionStrength;
			float _RefractionDepth;
			float _Metallic;
			float _NormalRandomizeUV;
			float _FoamRandomizeUV;
			float _FlowRandomizeUV;
			float _FlowPower;
			float _Roughness;
			float _FlowIntensity;
			float _EdgeFoamIntensity;
			float _EdgeFoamScale;
			float _EdgeFoamCutoff;
			float _EdgeFoamDepthFade;
			float _WaterFoamColorIntensity;
			float _ColorDepthFade;
			float _HeightPower;
			float _HeightRandomizeUV;
			float _FoamIntensity;
			float _Opacity;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _HeightMap;
			sampler2D _NormalMap;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float temp_output_7_0_g69 = ( _HeightRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g68 = v.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g68 = ( _TimeParameters.x * _HeightSpeed + ( _HeightUVTiling * texCoord5_g68 ));
				float2 temp_output_2_0_g69 = panner7_g68;
				float2 panner9_g69 = ( temp_output_7_0_g69 * float2( 0.1,0.1 ) + temp_output_2_0_g69);
				float2 panner13_g69 = ( temp_output_7_0_g69 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g69 + float2( 0.45,0.3 ) ));
				float2 panner18_g69 = ( temp_output_7_0_g69 * float2( -0.1,0.1 ) + ( temp_output_2_0_g69 + float2( 0.85,0.14 ) ));
				float4 temp_cast_0 = (_HeightPower).xxxx;
				float4 vDisplacement160 = ( ( _HeightIntensity * pow( ( ( ( tex2Dlod( _HeightMap, float4( panner9_g69, 0, 0.0) ) + tex2Dlod( _HeightMap, float4( panner13_g69, 0, 0.0) ) ) + tex2Dlod( _HeightMap, float4( panner18_g69, 0, 0.0) ) ) * 0.25 ) , temp_cast_0 ) ) * float4( v.ase_normal , 0.0 ) );
				
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vDisplacement160.rgb;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;
				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 normalWS = TransformObjectToWorldNormal( v.ase_normal );
				float4 tangentWS = float4(TransformObjectToWorldDir( v.ase_tangent.xyz), v.ase_tangent.w);
				float4 positionCS = TransformWorldToHClip( positionWS );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					o.worldPos = positionWS;
				#endif

				o.worldNormal = normalWS;
				o.worldTangent = tangentWS;

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

				o.clipPos = positionCS;

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;

				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.ase_texcoord = v.ase_texcoord;
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.ase_texcoord = patch[0].ase_texcoord * bary.x + patch[1].ase_texcoord * bary.y + patch[2].ase_texcoord * bary.z;
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			half4 frag(	VertexOutput IN
						#ifdef ASE_DEPTH_WRITE_ON
						,out float outputDepth : ASE_SV_DEPTH
						#endif
						 ) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
					float3 WorldPosition = IN.worldPos;
				#endif

				float4 ShadowCoords = float4( 0, 0, 0, 0 );
				float3 WorldNormal = IN.worldNormal;
				float4 WorldTangent = IN.worldTangent;

				#if defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
						ShadowCoords = IN.shadowCoord;
					#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
						ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
					#endif
				#endif

				float temp_output_7_0_g71 = ( _NormalRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g70 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g70 = ( _TimeParameters.x * _NormalSpeed + ( _NormalUVTiling * texCoord5_g70 ));
				float2 temp_output_2_0_g71 = panner7_g70;
				float2 panner9_g71 = ( temp_output_7_0_g71 * float2( 0.1,0.1 ) + temp_output_2_0_g71);
				float temp_output_24_0_g71 = _NormalIntensity;
				float3 unpack10_g71 = UnpackNormalScale( tex2D( _NormalMap, panner9_g71 ), temp_output_24_0_g71 );
				unpack10_g71.z = lerp( 1, unpack10_g71.z, saturate(temp_output_24_0_g71) );
				float2 panner13_g71 = ( temp_output_7_0_g71 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g71 + float2( 0.45,0.3 ) ));
				float3 unpack14_g71 = UnpackNormalScale( tex2D( _NormalMap, panner13_g71 ), temp_output_24_0_g71 );
				unpack14_g71.z = lerp( 1, unpack14_g71.z, saturate(temp_output_24_0_g71) );
				float2 panner18_g71 = ( temp_output_7_0_g71 * float2( -0.1,0.1 ) + ( temp_output_2_0_g71 + float2( 0.85,0.14 ) ));
				float3 unpack20_g71 = UnpackNormalScale( tex2D( _NormalMap, panner18_g71 ), temp_output_24_0_g71 );
				unpack20_g71.z = lerp( 1, unpack20_g71.z, saturate(temp_output_24_0_g71) );
				float3 vNormal154 = BlendNormal( BlendNormal( unpack10_g71 , unpack14_g71 ) , unpack20_g71 );
				

				float3 Normal = vNormal154;
				float Alpha = _Opacity;
				float AlphaClipThreshold = 0.5;
				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				#if defined(_GBUFFER_NORMALS_OCT)
					float2 octNormalWS = PackNormalOctQuadEncode(WorldNormal);
					float2 remappedOctNormalWS = saturate(octNormalWS * 0.5 + 0.5);
					half3 packedNormalWS = PackFloat2To888(remappedOctNormalWS);
					return half4(packedNormalWS, 0.0);
				#else
					#if defined(_NORMALMAP)
						#if _NORMAL_DROPOFF_TS
							float crossSign = (WorldTangent.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
							float3 bitangent = crossSign * cross(WorldNormal.xyz, WorldTangent.xyz);
							float3 normalWS = TransformTangentToWorld(Normal, half3x3(WorldTangent.xyz, bitangent, WorldNormal.xyz));
						#elif _NORMAL_DROPOFF_OS
							float3 normalWS = TransformObjectToWorldNormal(Normal);
						#elif _NORMAL_DROPOFF_WS
							float3 normalWS = Normal;
						#endif
					#else
						float3 normalWS = WorldNormal;
					#endif
					return half4(NormalizeNormalPerPixel(normalWS), 0.0);
				#endif
			}
			ENDHLSL
		}

		
		Pass
		{
			
			Name "GBuffer"
			Tags { "LightMode"="UniversalGBuffer" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZWrite Off
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma instancing_options renderinglayer
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120108
			#define REQUIRE_DEPTH_TEXTURE 1
			#define REQUIRE_OPAQUE_TEXTURE 1


			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
			#pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
			#pragma multi_compile_fragment _ _LIGHT_LAYERS
			#pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
			#pragma shader_feature_local _RECEIVE_SHADOWS_OFF
			#pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
			#pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF

			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DYNAMICLIGHTMAP_ON
			#pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_GBUFFER

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
				#define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_FRAG_SCREEN_POSITION
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _USESTEPFORFLOW_ON


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				float4 lightmapUVOrVertexSH : TEXCOORD0;
				half4 fogFactorAndVertexLight : TEXCOORD1;
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord : TEXCOORD2;
				#endif
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
				float4 screenPos : TEXCOORD6;
				#endif
				#if defined(DYNAMICLIGHTMAP_ON)
				float2 dynamicLightmapUV : TEXCOORD7;
				#endif
				float4 ase_texcoord8 : TEXCOORD8;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _ColorShallow;
			float4 _ColorDeep;
			float4 _WaterFoamColor;
			float2 _FlowSpeed;
			float2 _HeightSpeed;
			float2 _HeightUVTiling;
			float2 _FoamSpeed;
			float2 _FoamUVTiling;
			float2 _FlowUVTiling;
			float2 _NormalUVTiling;
			float2 _NormalSpeed;
			float2 _EdgeFoamSpeed;
			float _HeightIntensity;
			float _FoamPower;
			float _NormalIntensity;
			float _RefractionStrength;
			float _RefractionDepth;
			float _Metallic;
			float _NormalRandomizeUV;
			float _FoamRandomizeUV;
			float _FlowRandomizeUV;
			float _FlowPower;
			float _Roughness;
			float _FlowIntensity;
			float _EdgeFoamIntensity;
			float _EdgeFoamScale;
			float _EdgeFoamCutoff;
			float _EdgeFoamDepthFade;
			float _WaterFoamColorIntensity;
			float _ColorDepthFade;
			float _HeightPower;
			float _HeightRandomizeUV;
			float _FoamIntensity;
			float _Opacity;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			sampler2D _HeightMap;
			uniform float4 _CameraDepthTexture_TexelSize;
			sampler2D _FlowMask;
			sampler2D _FoamMask;
			sampler2D _NormalMap;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

			inline float noise_randomValue (float2 uv) { return frac(sin(dot(uv, float2(12.9898, 78.233)))*43758.5453); }
			inline float noise_interpolate (float a, float b, float t) { return (1.0-t)*a + (t*b); }
			inline float valueNoise (float2 uv)
			{
				float2 i = floor(uv);
				float2 f = frac( uv );
				f = f* f * (3.0 - 2.0 * f);
				uv = abs( frac(uv) - 0.5);
				float2 c0 = i + float2( 0.0, 0.0 );
				float2 c1 = i + float2( 1.0, 0.0 );
				float2 c2 = i + float2( 0.0, 1.0 );
				float2 c3 = i + float2( 1.0, 1.0 );
				float r0 = noise_randomValue( c0 );
				float r1 = noise_randomValue( c1 );
				float r2 = noise_randomValue( c2 );
				float r3 = noise_randomValue( c3 );
				float bottomOfGrid = noise_interpolate( r0, r1, f.x );
				float topOfGrid = noise_interpolate( r2, r3, f.x );
				float t = noise_interpolate( bottomOfGrid, topOfGrid, f.y );
				return t;
			}
			
			float SimpleNoise(float2 UV)
			{
				float t = 0.0;
				float freq = pow( 2.0, float( 0 ) );
				float amp = pow( 0.5, float( 3 - 0 ) );
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(1));
				amp = pow(0.5, float(3-1));
				t += valueNoise( UV/freq )*amp;
				freq = pow(2.0, float(2));
				amp = pow(0.5, float(3-2));
				t += valueNoise( UV/freq )*amp;
				return t;
			}
			

			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float temp_output_7_0_g69 = ( _HeightRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g68 = v.texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g68 = ( _TimeParameters.x * _HeightSpeed + ( _HeightUVTiling * texCoord5_g68 ));
				float2 temp_output_2_0_g69 = panner7_g68;
				float2 panner9_g69 = ( temp_output_7_0_g69 * float2( 0.1,0.1 ) + temp_output_2_0_g69);
				float2 panner13_g69 = ( temp_output_7_0_g69 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g69 + float2( 0.45,0.3 ) ));
				float2 panner18_g69 = ( temp_output_7_0_g69 * float2( -0.1,0.1 ) + ( temp_output_2_0_g69 + float2( 0.85,0.14 ) ));
				float4 temp_cast_0 = (_HeightPower).xxxx;
				float4 vDisplacement160 = ( ( _HeightIntensity * pow( ( ( ( tex2Dlod( _HeightMap, float4( panner9_g69, 0, 0.0) ) + tex2Dlod( _HeightMap, float4( panner13_g69, 0, 0.0) ) ) + tex2Dlod( _HeightMap, float4( panner18_g69, 0, 0.0) ) ) * 0.25 ) , temp_cast_0 ) ) * float4( v.ase_normal , 0.0 ) );
				
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord8.z = eyeDepth;
				
				o.ase_texcoord8.xy = v.texcoord.xy;
				o.ase_normal = v.ase_normal;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.w = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vDisplacement160.rgb;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				#if defined(LIGHTMAP_ON)
					OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy);
				#endif

				#if defined(DYNAMICLIGHTMAP_ON)
					o.dynamicLightmapUV.xy = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
				#endif

				#if !defined(LIGHTMAP_ON)
					OUTPUT_SH(normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz);
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					o.lightmapUVOrVertexSH.zw = v.texcoord;
					o.lightmapUVOrVertexSH.xy = v.texcoord * unity_LightmapST.xy + unity_LightmapST.zw;
				#endif

				half3 vertexLight = VertexLighting( positionWS, normalInput.normalWS );

				o.fogFactorAndVertexLight = half4(0, vertexLight);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = positionCS;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif

					o.clipPos = positionCS;

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					o.screenPos = ComputeScreenPos(positionCS);
				#endif

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				o.ase_tangent = v.ase_tangent;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
				o.texcoord = patch[0].texcoord * bary.x + patch[1].texcoord * bary.y + patch[2].texcoord * bary.z;
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			#if defined(ASE_EARLY_Z_DEPTH_OPTIMIZE)
				#define ASE_SV_DEPTH SV_DepthLessEqual
			#else
				#define ASE_SV_DEPTH SV_Depth
			#endif

			FragmentOutput frag ( VertexOutput IN
								#ifdef ASE_DEPTH_WRITE_ON
								,out float outputDepth : ASE_SV_DEPTH
								#endif
								 )
			{
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(IN);

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float2 sampleCoords = (IN.lightmapUVOrVertexSH.zw / _TerrainHeightmapRecipSize.zw + 0.5f) * _TerrainHeightmapRecipSize.xy;
					float3 WorldNormal = TransformObjectToWorldNormal(normalize(SAMPLE_TEXTURE2D(_TerrainNormalmapTexture, sampler_TerrainNormalmapTexture, sampleCoords).rgb * 2 - 1));
					float3 WorldTangent = -cross(GetObjectToWorldMatrix()._13_23_33, WorldNormal);
					float3 WorldBiTangent = cross(WorldNormal, -WorldTangent);
				#else
					float3 WorldNormal = normalize( IN.tSpace0.xyz );
					float3 WorldTangent = IN.tSpace1.xyz;
					float3 WorldBiTangent = IN.tSpace2.xyz;
				#endif

				float3 WorldPosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldViewDirection = _WorldSpaceCameraPos.xyz  - WorldPosition;
				float4 ShadowCoords = float4( 0, 0, 0, 0 );

				#if defined(ASE_NEEDS_FRAG_SCREEN_POSITION)
					float4 ScreenPos = IN.screenPos;
				#endif

				float2 NormalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#else
					ShadowCoords = float4(0, 0, 0, 0);
				#endif

				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float4 ase_screenPosNorm = ScreenPos / ScreenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth65 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth65 = abs( ( screenDepth65 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _ColorDepthFade ) );
				float4 lerpResult69 = lerp( _ColorShallow , _ColorDeep , saturate( distanceDepth65 ));
				float temp_output_7_0_g69 = ( _HeightRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g68 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g68 = ( _TimeParameters.x * _HeightSpeed + ( _HeightUVTiling * texCoord5_g68 ));
				float2 temp_output_2_0_g69 = panner7_g68;
				float2 panner9_g69 = ( temp_output_7_0_g69 * float2( 0.1,0.1 ) + temp_output_2_0_g69);
				float2 panner13_g69 = ( temp_output_7_0_g69 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g69 + float2( 0.45,0.3 ) ));
				float2 panner18_g69 = ( temp_output_7_0_g69 * float2( -0.1,0.1 ) + ( temp_output_2_0_g69 + float2( 0.85,0.14 ) ));
				float4 temp_cast_0 = (_HeightPower).xxxx;
				float4 vDisplacement160 = ( ( _HeightIntensity * pow( ( ( ( tex2D( _HeightMap, panner9_g69 ) + tex2D( _HeightMap, panner13_g69 ) ) + tex2D( _HeightMap, panner18_g69 ) ) * 0.25 ) , temp_cast_0 ) ) * float4( IN.ase_normal , 0.0 ) );
				float4 lerpResult72 = lerp( lerpResult69 , ( lerpResult69 + float4( 0.5,0.5,0.5,0 ) ) , vDisplacement160);
				float4 vColorWaves73 = lerpResult72;
				float4 vFoamColor169 = ( _WaterFoamColor * _WaterFoamColorIntensity );
				float screenDepth9_g53 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth9_g53 = abs( ( screenDepth9_g53 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _EdgeFoamDepthFade ) );
				float mulTime4_g53 = _TimeParameters.x * 0.1;
				float2 temp_cast_2 = (_EdgeFoamScale).xx;
				float2 texCoord2_g53 = IN.ase_texcoord8.xy * temp_cast_2 + float2( 0,0 );
				float2 panner6_g53 = ( mulTime4_g53 * _EdgeFoamSpeed + texCoord2_g53);
				float simpleNoise13_g53 = SimpleNoise( panner6_g53*50.0 );
				float temp_output_22_0_g53 = ( step( ( saturate( distanceDepth9_g53 ) * _EdgeFoamCutoff ) , simpleNoise13_g53 ) * _EdgeFoamIntensity );
				float vEdgeFoam167 = temp_output_22_0_g53;
				float temp_output_7_0_g65 = ( _FlowRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g64 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g64 = ( _TimeParameters.x * _FlowSpeed + ( _FlowUVTiling * texCoord5_g64 ));
				float2 temp_output_2_0_g65 = panner7_g64;
				float2 panner9_g65 = ( temp_output_7_0_g65 * float2( 0.1,0.1 ) + temp_output_2_0_g65);
				float2 panner13_g65 = ( temp_output_7_0_g65 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g65 + float2( 0.45,0.3 ) ));
				float2 panner18_g65 = ( temp_output_7_0_g65 * float2( -0.1,0.1 ) + ( temp_output_2_0_g65 + float2( 0.85,0.14 ) ));
				float4 temp_cast_3 = (_FlowPower).xxxx;
				float4 vFlow168 = ( _FlowIntensity * pow( ( ( ( tex2D( _FlowMask, panner9_g65 ) + tex2D( _FlowMask, panner13_g65 ) ) + tex2D( _FlowMask, panner18_g65 ) ) * 0.25 ) , temp_cast_3 ) );
				float4 temp_output_37_0 = ( vEdgeFoam167 + vFlow168 );
				float temp_output_7_0_g67 = ( _FoamRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g66 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g66 = ( _TimeParameters.x * _FoamSpeed + ( _FoamUVTiling * texCoord5_g66 ));
				float2 temp_output_2_0_g67 = panner7_g66;
				float2 panner9_g67 = ( temp_output_7_0_g67 * float2( 0.1,0.1 ) + temp_output_2_0_g67);
				float2 panner13_g67 = ( temp_output_7_0_g67 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g67 + float2( 0.45,0.3 ) ));
				float2 panner18_g67 = ( temp_output_7_0_g67 * float2( -0.1,0.1 ) + ( temp_output_2_0_g67 + float2( 0.85,0.14 ) ));
				float4 temp_cast_4 = (_FoamPower).xxxx;
				float4 temp_output_198_0 = ( _FoamIntensity * pow( ( ( ( tex2D( _FoamMask, panner9_g67 ) + tex2D( _FoamMask, panner13_g67 ) ) + tex2D( _FoamMask, panner18_g67 ) ) * 0.25 ) , temp_cast_4 ) );
				float4 vSurfaceFoam166 = temp_output_198_0;
				float4 lerpResult47 = lerp( temp_output_37_0 , float4( 0,0,0,0 ) , vSurfaceFoam166);
				#ifdef _USESTEPFORFLOW_ON
				float staticSwitch185 = ( (step( temp_output_37_0 , vSurfaceFoam166 )).r + vEdgeFoam167 );
				#else
				float staticSwitch185 = (lerpResult47).r;
				#endif
				float clampResult59 = clamp( staticSwitch185 , 0.0 , 1.0 );
				float4 vFoam175 = ( vFoamColor169 * clampResult59 );
				float4 temp_output_77_0 = ( vColorWaves73 + vFoam175 );
				float temp_output_7_0_g71 = ( _NormalRandomizeUV * _TimeParameters.x );
				float2 texCoord5_g70 = IN.ase_texcoord8.xy * float2( 1,1 ) + float2( 0,0 );
				float2 panner7_g70 = ( _TimeParameters.x * _NormalSpeed + ( _NormalUVTiling * texCoord5_g70 ));
				float2 temp_output_2_0_g71 = panner7_g70;
				float2 panner9_g71 = ( temp_output_7_0_g71 * float2( 0.1,0.1 ) + temp_output_2_0_g71);
				float temp_output_24_0_g71 = _NormalIntensity;
				float3 unpack10_g71 = UnpackNormalScale( tex2D( _NormalMap, panner9_g71 ), temp_output_24_0_g71 );
				unpack10_g71.z = lerp( 1, unpack10_g71.z, saturate(temp_output_24_0_g71) );
				float2 panner13_g71 = ( temp_output_7_0_g71 * float2( -0.1,-0.1 ) + ( temp_output_2_0_g71 + float2( 0.45,0.3 ) ));
				float3 unpack14_g71 = UnpackNormalScale( tex2D( _NormalMap, panner13_g71 ), temp_output_24_0_g71 );
				unpack14_g71.z = lerp( 1, unpack14_g71.z, saturate(temp_output_24_0_g71) );
				float2 panner18_g71 = ( temp_output_7_0_g71 * float2( -0.1,0.1 ) + ( temp_output_2_0_g71 + float2( 0.85,0.14 ) ));
				float3 unpack20_g71 = UnpackNormalScale( tex2D( _NormalMap, panner18_g71 ), temp_output_24_0_g71 );
				unpack20_g71.z = lerp( 1, unpack20_g71.z, saturate(temp_output_24_0_g71) );
				float3 vNormal154 = BlendNormal( BlendNormal( unpack10_g71 , unpack14_g71 ) , unpack20_g71 );
				float eyeDepth = IN.ase_texcoord8.z;
				float eyeDepth28_g72 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float2 temp_output_20_0_g72 = ( (vNormal154).xy * ( _RefractionStrength / max( eyeDepth , 0.1 ) ) * saturate( ( eyeDepth28_g72 - eyeDepth ) ) );
				float eyeDepth2_g72 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ( float4( temp_output_20_0_g72, 0.0 , 0.0 ) + ase_screenPosNorm ).xy ),_ZBufferParams);
				float2 temp_output_32_0_g72 = (( float4( ( temp_output_20_0_g72 * saturate( ( eyeDepth2_g72 - eyeDepth ) ) ), 0.0 , 0.0 ) + ase_screenPosNorm )).xy;
				float4 fetchOpaqueVal125 = float4( SHADERGRAPH_SAMPLE_SCENE_COLOR( temp_output_32_0_g72 ), 1.0 );
				float4 vRefraction126 = fetchOpaqueVal125;
				float4 blendOpSrc131 = temp_output_77_0;
				float4 blendOpDest131 = vRefraction126;
				float screenDepth129 = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH( ase_screenPosNorm.xy ),_ZBufferParams);
				float distanceDepth129 = abs( ( screenDepth129 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _RefractionDepth ) );
				float4 lerpResult133 = lerp( ( saturate( (( blendOpDest131 > 0.5 ) ? ( 1.0 - 2.0 * ( 1.0 - blendOpDest131 ) * ( 1.0 - blendOpSrc131 ) ) : ( 2.0 * blendOpDest131 * blendOpSrc131 ) ) )) , temp_output_77_0 , saturate( distanceDepth129 ));
				float4 vFinalColor180 = lerpResult133;
				

				float3 BaseColor = vFinalColor180.rgb;
				float3 Normal = vNormal154;
				float3 Emission = 0;
				float3 Specular = 0.5;
				float Metallic = _Metallic;
				float Smoothness = ( 1.0 - _Roughness );
				float Occlusion = 1;
				float Alpha = _Opacity;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef ASE_DEPTH_WRITE_ON
					float DepthValue = 0;
				#endif

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData = (InputData)0;
				inputData.positionWS = WorldPosition;
				inputData.positionCS = IN.clipPos;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
						inputData.normalWS = TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal ));
					#elif _NORMAL_DROPOFF_OS
						inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
						inputData.normalWS = Normal;
					#endif
				#else
					inputData.normalWS = WorldNormal;
				#endif

				inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				inputData.viewDirectionWS = SafeNormalize( WorldViewDirection );

				inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;

				#if defined(ENABLE_TERRAIN_PERPIXEL_NORMAL)
					float3 SH = SampleSH(inputData.normalWS.xyz);
				#else
					float3 SH = IN.lightmapUVOrVertexSH.xyz;
				#endif

				#ifdef ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#else
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, IN.dynamicLightmapUV.xy, SH, inputData.normalWS);
					#else
						inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS );
					#endif
				#endif

				inputData.normalizedScreenSpaceUV = NormalizedScreenSpaceUV;
				inputData.shadowMask = SAMPLE_SHADOWMASK(IN.lightmapUVOrVertexSH.xy);

				#if defined(DEBUG_DISPLAY)
					#if defined(DYNAMICLIGHTMAP_ON)
						inputData.dynamicLightmapUV = IN.dynamicLightmapUV.xy;
						#endif
					#if defined(LIGHTMAP_ON)
						inputData.staticLightmapUV = IN.lightmapUVOrVertexSH.xy;
					#else
						inputData.vertexSH = SH;
					#endif
				#endif

				#ifdef _DBUFFER
					ApplyDecal(IN.clipPos,
						BaseColor,
						Specular,
						inputData.normalWS,
						Metallic,
						Occlusion,
						Smoothness);
				#endif

				BRDFData brdfData;
				InitializeBRDFData
				(BaseColor, Metallic, Specular, Smoothness, Alpha, brdfData);

				Light mainLight = GetMainLight(inputData.shadowCoord, inputData.positionWS, inputData.shadowMask);
				half4 color;
				MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI, inputData.shadowMask);
				color.rgb = GlobalIllumination(brdfData, inputData.bakedGI, Occlusion, inputData.positionWS, inputData.normalWS, inputData.viewDirectionWS);
				color.a = Alpha;

				#ifdef ASE_FINAL_COLOR_ALPHA_MULTIPLY
					color.rgb *= color.a;
				#endif

				#ifdef ASE_DEPTH_WRITE_ON
					outputDepth = DepthValue;
				#endif

				return BRDFDataToGbuffer(brdfData, inputData, Smoothness, Emission + color.rgb);
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "SceneSelectionPass"
			Tags { "LightMode"="SceneSelectionPass" }

			Cull Off

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120108


			#pragma vertex vert
			#pragma fragment frag

			#define SCENESELECTIONPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _ColorShallow;
			float4 _ColorDeep;
			float4 _WaterFoamColor;
			float2 _FlowSpeed;
			float2 _HeightSpeed;
			float2 _HeightUVTiling;
			float2 _FoamSpeed;
			float2 _FoamUVTiling;
			float2 _FlowUVTiling;
			float2 _NormalUVTiling;
			float2 _NormalSpeed;
			float2 _EdgeFoamSpeed;
			float _HeightIntensity;
			float _FoamPower;
			float _NormalIntensity;
			float _RefractionStrength;
			float _RefractionDepth;
			float _Metallic;
			float _NormalRandomizeUV;
			float _FoamRandomizeUV;
			float _FlowRandomizeUV;
			float _FlowPower;
			float _Roughness;
			float _FlowIntensity;
			float _EdgeFoamIntensity;
			float _EdgeFoamScale;
			float _EdgeFoamCutoff;
			float _EdgeFoamDepthFade;
			float _WaterFoamColorIntensity;
			float _ColorDepthFade;
			float _HeightPower;
			float _HeightRandomizeUV;
			float _FoamIntensity;
			float _Opacity;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			

			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			
			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );

				o.clipPos = TransformWorldToHClip(positionWS);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				

				surfaceDescription.Alpha = 1;
				surfaceDescription.AlphaClipThreshold = 0.5;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
					clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;

				#ifdef SCENESELECTIONPASS
					outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				#elif defined(SCENEPICKINGPASS)
					outColor = _SelectionID;
				#endif

				return outColor;
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "ScenePickingPass"
			Tags { "LightMode"="Picking" }

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _SURFACE_TYPE_TRANSPARENT 1
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120108


			#pragma vertex vert
			#pragma fragment frag

		    #define SCENEPICKINGPASS 1

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 clipPos : SV_POSITION;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _ColorShallow;
			float4 _ColorDeep;
			float4 _WaterFoamColor;
			float2 _FlowSpeed;
			float2 _HeightSpeed;
			float2 _HeightUVTiling;
			float2 _FoamSpeed;
			float2 _FoamUVTiling;
			float2 _FlowUVTiling;
			float2 _NormalUVTiling;
			float2 _NormalSpeed;
			float2 _EdgeFoamSpeed;
			float _HeightIntensity;
			float _FoamPower;
			float _NormalIntensity;
			float _RefractionStrength;
			float _RefractionDepth;
			float _Metallic;
			float _NormalRandomizeUV;
			float _FoamRandomizeUV;
			float _FlowRandomizeUV;
			float _FlowPower;
			float _Roughness;
			float _FlowIntensity;
			float _EdgeFoamIntensity;
			float _EdgeFoamScale;
			float _EdgeFoamCutoff;
			float _EdgeFoamDepthFade;
			float _WaterFoamColorIntensity;
			float _ColorDepthFade;
			float _HeightPower;
			float _HeightRandomizeUV;
			float _FoamIntensity;
			float _Opacity;
			#ifdef ASE_TRANSMISSION
				float _TransmissionShadow;
			#endif
			#ifdef ASE_TRANSLUCENCY
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			// Property used by ScenePickingPass
			#ifdef SCENEPICKINGPASS
				float4 _SelectionID;
			#endif

			// Properties used by SceneSelectionPass
			#ifdef SCENESELECTIONPASS
				int _ObjectId;
				int _PassValue;
			#endif

			

			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			
			struct SurfaceDescription
			{
				float Alpha;
				float AlphaClipThreshold;
			};

			VertexOutput VertexFunction(VertexInput v  )
			{
				VertexOutput o;
				ZERO_INITIALIZE(VertexOutput, o);

				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = defaultVertexValue;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.vertex.xyz = vertexValue;
				#else
					v.vertex.xyz += vertexValue;
				#endif

				v.ase_normal = v.ase_normal;

				float3 positionWS = TransformObjectToWorld( v.vertex.xyz );
				o.clipPos = TransformWorldToHClip(positionWS);

				return o;
			}

			#if defined(ASE_TESSELLATION)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct TessellationFactors
			{
				float edge[3] : SV_TessFactor;
				float inside : SV_InsideTessFactor;
			};

			VertexControl vert ( VertexInput v )
			{
				VertexControl o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.vertex = v.vertex;
				o.ase_normal = v.ase_normal;
				
				return o;
			}

			TessellationFactors TessellationFunction (InputPatch<VertexControl,3> v)
			{
				TessellationFactors o;
				float4 tf = 1;
				float tessValue = _TessValue; float tessMin = _TessMin; float tessMax = _TessMax;
				float edgeLength = _TessEdgeLength; float tessMaxDisp = _TessMaxDisp;
				#if defined(ASE_FIXED_TESSELLATION)
				tf = FixedTess( tessValue );
				#elif defined(ASE_DISTANCE_TESSELLATION)
				tf = DistanceBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, tessValue, tessMin, tessMax, GetObjectToWorldMatrix(), _WorldSpaceCameraPos );
				#elif defined(ASE_LENGTH_TESSELLATION)
				tf = EdgeLengthBasedTess(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams );
				#elif defined(ASE_LENGTH_CULL_TESSELLATION)
				tf = EdgeLengthBasedTessCull(v[0].vertex, v[1].vertex, v[2].vertex, edgeLength, tessMaxDisp, GetObjectToWorldMatrix(), _WorldSpaceCameraPos, _ScreenParams, unity_CameraWorldClipPlanes );
				#endif
				o.edge[0] = tf.x; o.edge[1] = tf.y; o.edge[2] = tf.z; o.inside = tf.w;
				return o;
			}

			[domain("tri")]
			[partitioning("fractional_odd")]
			[outputtopology("triangle_cw")]
			[patchconstantfunc("TessellationFunction")]
			[outputcontrolpoints(3)]
			VertexControl HullFunction(InputPatch<VertexControl, 3> patch, uint id : SV_OutputControlPointID)
			{
				return patch[id];
			}

			[domain("tri")]
			VertexOutput DomainFunction(TessellationFactors factors, OutputPatch<VertexControl, 3> patch, float3 bary : SV_DomainLocation)
			{
				VertexInput o = (VertexInput) 0;
				o.vertex = patch[0].vertex * bary.x + patch[1].vertex * bary.y + patch[2].vertex * bary.z;
				o.ase_normal = patch[0].ase_normal * bary.x + patch[1].ase_normal * bary.y + patch[2].ase_normal * bary.z;
				
				#if defined(ASE_PHONG_TESSELLATION)
				float3 pp[3];
				for (int i = 0; i < 3; ++i)
					pp[i] = o.vertex.xyz - patch[i].ase_normal * (dot(o.vertex.xyz, patch[i].ase_normal) - dot(patch[i].vertex.xyz, patch[i].ase_normal));
				float phongStrength = _TessPhongStrength;
				o.vertex.xyz = phongStrength * (pp[0]*bary.x + pp[1]*bary.y + pp[2]*bary.z) + (1.0f-phongStrength) * o.vertex.xyz;
				#endif
				UNITY_TRANSFER_INSTANCE_ID(patch[0], o);
				return VertexFunction(o);
			}
			#else
			VertexOutput vert ( VertexInput v )
			{
				return VertexFunction( v );
			}
			#endif

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				

				surfaceDescription.Alpha = 1;
				surfaceDescription.AlphaClipThreshold = 0.5;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
						clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;

				#ifdef SCENESELECTIONPASS
					outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				#elif defined(SCENEPICKINGPASS)
					outColor = _SelectionID;
				#endif

				return outColor;
			}

			ENDHLSL
		}
		
	}
	
	CustomEditor "UnityEditor.ShaderGraphLitGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback "Hidden/InternalErrorShader"
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.CommentaryNode;164;-5658.45,-1547.011;Inherit;False;1916.581;1245.468;Comment;24;45;43;46;44;126;124;125;53;122;121;5;12;13;26;42;40;163;60;61;62;166;167;169;187;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;58;-3703.036,-653.0001;Inherit;False;1057.686;898.0742;Comment;7;168;27;35;36;32;33;34;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;32;-3547.138,-405.5545;Inherit;False;Property;_FlowUVTiling;Flow UV Tiling;24;1;[Header];Create;True;1;Flow;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;12;-5649.434,-1501.011;Inherit;False;Property;_EdgeFoamDepthFade;Edge Foam Depth Fade;16;0;Create;True;0;0;0;False;0;False;0.19;0.18;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-3642.033,9.798954;Inherit;False;Property;_FlowIntensity;Flow Intensity;26;0;Create;True;0;0;0;False;0;False;1;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-5647.895,-1296.081;Inherit;False;Property;_EdgeFoamScale;Edge Foam Scale;15;1;[Header];Create;True;0;0;0;False;0;False;1;25;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;26;-5570.71,-1420.386;Inherit;False;Property;_EdgeFoamSpeed;Edge Foam Speed;14;1;[Header];Create;True;1;Edge Foam;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;33;-3532.033,-277.2005;Inherit;False;Property;_FlowSpeed;Flow Speed;25;0;Create;True;0;0;0;False;0;False;0,-0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;34;-3644.033,-148.2006;Inherit;False;Property;_FlowPower;Flow Power;27;0;Create;True;0;0;0;False;0;False;1;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-5647.705,-1222.428;Inherit;False;Property;_EdgeFoamCutoff;Edge Foam Cutoff;18;0;Create;True;0;0;0;False;0;False;1;0.77;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-3645.034,-71.20064;Inherit;False;Property;_FlowRandomizeUV;Flow Randomize UV;28;0;Create;True;0;0;0;False;0;False;0.26;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;53;-5646.428,-1144.446;Inherit;False;Property;_EdgeFoamIntensity;Edge Foam Intensity;17;0;Create;True;0;0;0;False;0;False;1;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;27;-3600.034,-595.2007;Inherit;True;Property;_FlowMask;Flow Mask;0;2;[Header];[SingleLineTexture];Create;True;2;Maps;.;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;44;-5609.45,-579.5428;Inherit;False;Property;_FoamPower;Foam Power;22;0;Create;True;0;0;0;False;0;False;1;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;121;-5338.019,-1438.882;Inherit;False;PA_WaterFoam;-1;;53;45531c79858e778408249ff91b3d326d;0;5;14;FLOAT;0.19;False;17;FLOAT2;1,0;False;16;FLOAT2;2,2;False;15;FLOAT;1;False;25;FLOAT;1;False;2;FLOAT;0;FLOAT3;27
Node;AmplifyShaderEditor.RangedFloatNode;45;-5608.45,-501.5429;Inherit;False;Property;_FoamRandomizeUV;Foam Randomize UV;23;0;Create;True;0;0;0;False;0;False;0.26;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;42;-5508.554,-837.8969;Inherit;False;Property;_FoamUVTiling;Foam UV Tiling;19;1;[Header];Create;True;1;Foam;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;40;-5551.45,-1029.543;Inherit;True;Property;_FoamMask;Foam Mask;1;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;46;-5603.45,-419.5429;Inherit;False;Property;_FoamIntensity;Foam Intensity;21;0;Create;True;0;0;0;False;0;False;1;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;43;-5491.45,-715.5427;Inherit;False;Property;_FoamSpeed;Foam Speed;20;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.FunctionNode;197;-3239.115,-593.2136;Inherit;False;PA_WaterSurface;-1;;64;309797113708f534d99b07f41e0dd303;0;7;12;SAMPLER2D;1;False;4;FLOAT2;0,0;False;3;FLOAT2;1,1;False;9;FLOAT2;1,1;False;14;FLOAT;1;False;11;FLOAT;1;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;198;-5220.449,-1024.543;Inherit;False;PA_WaterSurface;-1;;66;309797113708f534d99b07f41e0dd303;0;7;12;SAMPLER2D;1;False;4;FLOAT2;0,0;False;3;FLOAT2;1,1;False;9;FLOAT2;1,1;False;14;FLOAT;1;False;11;FLOAT;1;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;168;-2928.113,-599.2391;Inherit;False;vFlow;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;174;-3711.638,-1549.205;Inherit;False;1840.576;428.1779;Comment;14;184;185;170;59;175;63;49;183;47;37;171;173;172;186;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;167;-4933.25,-1444.725;Inherit;False;vEdgeFoam;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;166;-4693.663,-1031.161;Inherit;False;vSurfaceFoam;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;173;-3664.305,-1324.376;Inherit;False;168;vFlow;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;172;-3675.305,-1404.376;Inherit;False;167;vEdgeFoam;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;159;-3945.669,290.5198;Inherit;False;1314.131;802.2581;Comment;9;102;104;101;105;97;99;100;98;160;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;179;-5570.888,-2255.416;Inherit;False;1822.993;684.874;Comment;10;73;72;71;162;69;66;68;67;65;64;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-3405.075,-1398.271;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;171;-3473.827,-1295.361;Inherit;False;166;vSurfaceFoam;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;98;-3783.184,784.7775;Inherit;False;Property;_HeightPower;Height  Power;36;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;183;-3230.718,-1474.624;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;64;-5548.888,-1750.691;Inherit;False;Property;_ColorDepthFade;Color Depth Fade;8;0;Create;True;0;0;0;False;0;False;0;10.5;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;100;-3843.411,340.5198;Inherit;True;Property;_HeightMap;Height Map;3;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.Vector2Node;97;-3783.41,655.7775;Inherit;False;Property;_HeightSpeed;Height Speed;34;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;102;-3895.669,869.7775;Inherit;False;Property;_HeightRandomizeUV;Height Randomize UV;37;0;Create;True;0;0;0;False;0;False;0.26;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;-5016.286,-222.9044;Inherit;False;960.1057;694.0769;Comment;7;88;87;91;90;154;151;89;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;101;-3799.515,532.4236;Inherit;False;Property;_HeightUVTiling;Height UV Tiling;33;1;[Header];Create;True;1;Displacement;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;99;-3794.411,953.7775;Inherit;False;Property;_HeightIntensity;Height Intensity;35;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;91;-4866.39,18.7414;Inherit;False;Property;_NormalUVTiling;Normal UV Tiling;29;1;[Header];Create;True;1;Normal;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.NormalVertexDataNode;105;-3395.159,568.7344;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DepthFade;65;-5249.888,-1769.691;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;60;-5122.201,-770.6245;Inherit;False;Property;_WaterFoamColor;Water Foam Color;4;0;Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;199;-3506.409,346.7778;Inherit;False;PA_WaterSurface;-1;;68;309797113708f534d99b07f41e0dd303;0;7;12;SAMPLER2D;1;False;4;FLOAT2;0,0;False;3;FLOAT2;1,1;False;9;FLOAT2;1,1;False;14;FLOAT;1;False;11;FLOAT;1;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-4951.286,360.0932;Inherit;False;Property;_NormalIntensity;Normal Intensity;31;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;90;-4856.286,141.0941;Inherit;False;Property;_NormalSpeed;Normal Speed;30;0;Create;True;0;0;0;False;0;False;0,-0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexturePropertyNode;89;-4907.286,-172.9046;Inherit;True;Property;_NormalMap;Normal Map;2;2;[Normal];[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;62;-5118.263,-595.9072;Inherit;False;Property;_WaterFoamColorIntensity;Water Foam Color Intensity;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;47;-3233.531,-1371.303;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;186;-3086.718,-1483.624;Inherit;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-4954.286,278.0938;Inherit;False;Property;_NormalRandomizeUV;Normal Randomize UV;32;0;Create;True;0;0;0;False;0;False;0.26;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;151;-4586.95,-167.7226;Inherit;False;PA_WaterSurfaceNormal;-1;;70;6bbcea883414cce48bb2c0b8ae615409;0;6;12;SAMPLER2D;1;False;4;FLOAT2;0,0;False;3;FLOAT2;1,1;False;9;FLOAT2;1,1;False;11;FLOAT;1;False;2;FLOAT;1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;184;-2864.718,-1453.624;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;49;-3047.04,-1378.539;Inherit;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-3149.01,347.3612;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;68;-5190.072,-2167.416;Inherit;False;Property;_ColorShallow;Color Shallow;6;1;[Header];Create;True;1;Color;0;0;False;0;False;0.5990566,0.9091429,1,0;0,0.4749352,0.6132076,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;61;-4747.263,-767.9075;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;67;-4990.887,-1770.691;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;66;-5197.072,-1988.415;Inherit;False;Property;_ColorDeep;Color Deep;7;0;Create;True;0;0;0;False;0;False;0.1213065,0.347919,0.5471698,0;0,0.2996509,0.4056603,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;169;-4553.818,-773.3498;Inherit;False;vFoamColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;185;-2757.718,-1376.624;Inherit;False;Property;_useStepforFlow;use Step for Flow?;40;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;154;-4255.338,-173.5771;Inherit;False;vNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;160;-2980.228,340.9211;Inherit;False;vDisplacement;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;69;-4770.292,-1908.37;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;162;-4531.424,-1688.542;Inherit;False;160;vDisplacement;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;59;-2499.729,-1371.074;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;187;-4865.044,-1250.447;Inherit;False;154;vNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;71;-4466.237,-1788.761;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0.5,0.5,0.5,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;122;-4939.833,-1335.198;Inherit;False;Property;_RefractionStrength;Refraction Strength;12;0;Create;True;0;0;0;False;1;Header(Refraction);False;1;0.71;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;170;-2529.929,-1466.132;Inherit;False;169;vFoamColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;-2264.049,-1416.626;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;72;-4230.754,-1901.907;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;124;-4664.146,-1415.857;Inherit;False;DepthMaskedRefraction;-1;;72;c805f061214177c42bca056464193f81;2,40,0,103,0;2;35;FLOAT3;0,0,0;False;37;FLOAT;0.02;False;1;FLOAT2;38
Node;AmplifyShaderEditor.ScreenColorNode;125;-4179.483,-1419.541;Inherit;False;Global;_GrabScreen0;Grab Screen 0;4;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-3971.896,-1907.863;Inherit;False;vColorWaves;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;178;-3705.408,-1110.516;Inherit;False;1477.422;426.9905;Comment;10;180;133;131;128;177;176;77;129;132;127;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;175;-2129.504,-1421.906;Inherit;False;vFoam;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-3452.322,-831.0237;Inherit;False;Property;_RefractionDepth;Refraction Depth;13;0;Create;True;0;0;0;False;0;False;1;9.5;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;-3654.408,-1049.314;Inherit;False;73;vColorWaves;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;126;-3965.87,-1419.069;Inherit;False;vRefraction;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;177;-3655.408,-973.314;Inherit;False;175;vFoam;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;128;-3379.037,-943.4351;Inherit;False;126;vRefraction;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-3337.485,-1045.135;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;129;-3140.322,-850.0237;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;132;-2874.822,-849.6246;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;131;-2938.091,-1056.516;Inherit;False;Overlay;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;133;-2636.881,-895.5167;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;180;-2472.005,-900.2159;Inherit;False;vFinalColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;152;-1882.637,-268.7368;Inherit;False;Property;_Roughness;Roughness;39;0;Create;True;0;0;0;False;0;False;0.05;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;156;-5156.218,594.2005;Inherit;False;1166;505.6327;Comment;7;157;82;83;80;81;84;86;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;83;-5012.219,644.2004;Inherit;False;Property;_OpacityShallow;OpacityShallow;9;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;157;-4239.997,642.0432;Inherit;False;vOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-5095.218,866.2004;Inherit;False;Property;_OpacityFade;Opacity Fade;11;0;Create;True;0;0;0;False;0;False;1;0;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;81;-4889.219,848.2004;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;84;-4416.218,648.2004;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;163;-4905.117,-1031.121;Inherit;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;86;-4657.375,847.8332;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-5010,745.3641;Inherit;False;Property;_OpacityDeep;Opacity Deep;10;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-1720.663,-342.019;Inherit;False;Property;_Metallic;Metallic;38;0;Create;True;0;0;0;False;0;False;0.2;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;161;-1641.382,-121.8172;Inherit;False;160;vDisplacement;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;155;-1630.543,-423.7233;Inherit;False;154;vNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.OneMinusNode;153;-1596.928,-263.7368;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;181;-1642.453,-502.4092;Inherit;False;180;vFinalColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;188;-1716.722,-197.7922;Inherit;False;Property;_Opacity;Opacity;41;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;190;-1411.464,-441.9117;Float;False;True;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;Polyart/Dreamscape/URP/Water River;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;19;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;3;True;12;all;0;False;True;1;5;False;;10;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;Hidden/InternalErrorShader;0;0;Standard;41;Workflow;1;0;Surface;1;637931402213719600;  Refraction Model;0;0;  Blend;0;0;Two Sided;1;0;Fragment Normal Space,InvertActionOnDeselection;0;0;Forward Only;0;0;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;0;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;1;0;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;1;0;_FinalColorxAlpha;0;0;Meta Pass;1;0;Override Baked GI;0;0;Extra Pre Pass;0;0;DOTS Instancing;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Write Depth;0;0;  Early Z;0;0;Vertex Position,InvertActionOnDeselection;1;0;Debug Display;0;0;Clear Coat;0;0;0;10;False;True;True;True;True;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;189;-1411.464,-441.9117;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;0;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;195;-1411.464,-441.9117;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormals;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;191;-1411.464,-441.9117;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;194;-1411.464,-441.9117;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;True;1;5;False;;10;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;193;-1411.464,-441.9117;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;192;-1411.464,-441.9117;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;True;1;LightMode=DepthOnly;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;196;-1411.464,-441.9117;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;GBuffer;0;7;GBuffer;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;True;1;5;False;;10;False;;1;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;255;False;;255;False;;255;False;;7;False;;1;False;;1;False;;1;False;;7;False;;1;False;;1;False;;1;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalGBuffer;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;200;-1411.464,-361.9117;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;SceneSelectionPass;0;8;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;201;-1411.464,-361.9117;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ScenePickingPass;0;9;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
WireConnection;121;14;12;0
WireConnection;121;17;26;0
WireConnection;121;16;5;0
WireConnection;121;15;13;0
WireConnection;121;25;53;0
WireConnection;197;12;27;0
WireConnection;197;3;32;0
WireConnection;197;9;33;0
WireConnection;197;14;34;0
WireConnection;197;11;35;0
WireConnection;197;2;36;0
WireConnection;198;12;40;0
WireConnection;198;3;42;0
WireConnection;198;9;43;0
WireConnection;198;14;44;0
WireConnection;198;11;45;0
WireConnection;198;2;46;0
WireConnection;168;0;197;0
WireConnection;167;0;121;0
WireConnection;166;0;198;0
WireConnection;37;0;172;0
WireConnection;37;1;173;0
WireConnection;183;0;37;0
WireConnection;183;1;171;0
WireConnection;65;0;64;0
WireConnection;199;12;100;0
WireConnection;199;3;101;0
WireConnection;199;9;97;0
WireConnection;199;14;98;0
WireConnection;199;11;102;0
WireConnection;199;2;99;0
WireConnection;47;0;37;0
WireConnection;47;2;171;0
WireConnection;186;0;183;0
WireConnection;151;12;89;0
WireConnection;151;3;91;0
WireConnection;151;9;90;0
WireConnection;151;11;88;0
WireConnection;151;2;87;0
WireConnection;184;0;186;0
WireConnection;184;1;172;0
WireConnection;49;0;47;0
WireConnection;104;0;199;0
WireConnection;104;1;105;0
WireConnection;61;0;60;0
WireConnection;61;1;62;0
WireConnection;67;0;65;0
WireConnection;169;0;61;0
WireConnection;185;1;49;0
WireConnection;185;0;184;0
WireConnection;154;0;151;0
WireConnection;160;0;104;0
WireConnection;69;0;68;0
WireConnection;69;1;66;0
WireConnection;69;2;67;0
WireConnection;59;0;185;0
WireConnection;71;0;69;0
WireConnection;63;0;170;0
WireConnection;63;1;59;0
WireConnection;72;0;69;0
WireConnection;72;1;71;0
WireConnection;72;2;162;0
WireConnection;124;35;187;0
WireConnection;124;37;122;0
WireConnection;125;0;124;38
WireConnection;73;0;72;0
WireConnection;175;0;63;0
WireConnection;126;0;125;0
WireConnection;77;0;176;0
WireConnection;77;1;177;0
WireConnection;129;0;127;0
WireConnection;132;0;129;0
WireConnection;131;0;77;0
WireConnection;131;1;128;0
WireConnection;133;0;131;0
WireConnection;133;1;77;0
WireConnection;133;2;132;0
WireConnection;180;0;133;0
WireConnection;157;0;84;0
WireConnection;81;0;80;0
WireConnection;84;0;83;0
WireConnection;84;1;82;0
WireConnection;84;2;86;0
WireConnection;163;0;198;0
WireConnection;86;0;81;0
WireConnection;153;0;152;0
WireConnection;190;0;181;0
WireConnection;190;1;155;0
WireConnection;190;3;79;0
WireConnection;190;4;153;0
WireConnection;190;6;188;0
WireConnection;190;8;161;0
ASEEND*/
//CHKSM=B70244716E73358D31C7FAB8D6CE6A2385330517