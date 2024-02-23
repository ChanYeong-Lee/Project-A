// Made with Amplify Shader Editor v1.9.1.3
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape/URP/Tree Wind Deferred"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][Enum(Back,2,Front,1,Off,0)]_Culling("Culling", Int) = 2
		[Header(Foliage)][Header(.)][SingleLineTexture]_FoliageColorMap("Foliage Color Map", 2D) = "white" {}
		[Normal][SingleLineTexture]_FoliageNormalMap("Foliage Normal Map", 2D) = "bump" {}
		_FoliageSize("Foliage Size", Float) = 100
		_FoliageColorTop("Foliage Color Top", Color) = (1,1,1,0)
		_FoliageColorBottom("Foliage Color Bottom", Color) = (0,0,0,0)
		_GradientOffset("Gradient Offset", Float) = 0
		_GradientFallout("Gradient Fallout", Float) = 0
		_FoliageEmissiveColor("Foliage Emissive Color", Color) = (0,0,0,0)
		_FoliageNormalIntensity("Foliage Normal Intensity", Range( 0 , 1)) = 1
		_FoliageRoughness("Foliage Roughness", Range( 0 , 1)) = 0.85
		_FoliageEmissiveIntensity("Foliage Emissive Intensity", Range( 0 , 20)) = 0
		[Header (Trunk)][Toggle(_USEDFORTRUNK_ON)] _UsedforTrunk("Used for Trunk?", Float) = 0
		[SingleLineTexture]_ColorMap("Color Map", 2D) = "white" {}
		[SingleLineTexture]_NormalMap("Normal Map", 2D) = "white" {}
		[SingleLineTexture]_ORMMap("ORM Map", 2D) = "white" {}
		[SingleLineTexture]_EmissiveMap("Emissive Map", 2D) = "white" {}
		_TextureSize("Texture Size", Float) = 100
		_ColorTint("Color Tint", Color) = (1,1,1,0)
		_NormalIntensity("Normal Intensity", Range( 0 , 1)) = 1
		_RoughnessIntensity("Roughness Intensity", Range( 0 , 2)) = 1
		_AOIntensity("AO Intensity", Range( 0 , 2)) = 1
		_EmissiveColor("Emissive Color", Color) = (0,0,0,0)
		_EmissiveIntensity("Emissive Intensity", Range( 0 , 20)) = 0
		[Header(WIND RUSTLE)][Toggle(_USEGLOBALWINDSETTINGS_ON)] _UseGlobalWindSettings("Use Global Wind Settings?", Float) = 0
		[HideInInspector][SingleLineTexture]_NoiseTexture("NoiseTexture", 2D) = "white" {}
		_WindScrollSpeed("Wind Scroll Speed", Range( 0 , 0.5)) = 0.05
		_WindJitterSpeed("Wind Jitter Speed", Range( 0 , 0.5)) = 0.05
		[Header(WIND SWAY)][Toggle(_USESGLOBALWINDSETTINGS_ON)] _UsesGlobalWindSettings("Uses Global Wind Settings?", Float) = 0
		_WindSwayDirection("Wind Sway Direction", Vector) = (1,0,0,0)
		_WIndSwayIntensity("WInd Sway Intensity", Float) = 1
		[ASEEnd]_WIndSwayFrequency("WInd Sway Frequency", Float) = 1


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

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }

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

			Blend One Zero, One Zero
			ZWrite On
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
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120108


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
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _USEDFORTRUNK_ON
			#pragma shader_feature_local _USEGLOBALWINDSETTINGS_ON
			#pragma shader_feature_local _USESGLOBALWINDSETTINGS_ON


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
				float4 ase_texcoord9 : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _EmissiveColor;
			float4 _FoliageColorBottom;
			float4 _FoliageColorTop;
			float4 _FoliageEmissiveColor;
			float4 _ColorTint;
			float2 _WindSwayDirection;
			int _Culling;
			float _FoliageRoughness;
			float _EmissiveIntensity;
			float _FoliageEmissiveIntensity;
			float _NormalIntensity;
			float _FoliageNormalIntensity;
			float _FoliageSize;
			float _RoughnessIntensity;
			float _GradientFallout;
			float _GradientOffset;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindJitterSpeed;
			float _WindScrollSpeed;
			float _TextureSize;
			float _AOIntensity;
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

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;
			sampler2D _ColorMap;
			sampler2D _FoliageNormalMap;
			sampler2D _NormalMap;
			sampler2D _EmissiveMap;
			sampler2D _ORMMap;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float temp_output_18_0_g74 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g74 = ( temp_output_18_0_g74 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g74 = temp_output_18_0_g74;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g74 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g74 = ( appendResult4_g74 * 0.035 );
				float2 panner9_g74 = ( ( staticSwitch25_g74 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g74);
				float temp_output_19_0_g74 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g74 = ( temp_output_19_0_g74 * Float0 );
				#else
				float staticSwitch26_g74 = temp_output_19_0_g74;
				#endif
				float2 panner13_g74 = ( ( _TimeParameters.x * staticSwitch26_g74 ) * float2( 1,1 ) + ( temp_output_7_0_g74 * float2( 2,2 ) ));
				float4 lerpResult30_g74 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g74, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g74, 0, 0.0) ) ) , 1.0);
				float temp_output_27_0_g72 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g72 = ( temp_output_27_0_g72 * varWindSwayIntensity );
				#else
				float staticSwitch33_g72 = temp_output_27_0_g72;
				#endif
				float temp_output_14_0_g72 = ( ( v.vertex.xyz.y * ( staticSwitch33_g72 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g72 = ( temp_output_14_0_g72 * temp_output_14_0_g72 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g72 = varWindDirection;
				#else
				float2 staticSwitch41_g72 = _WindSwayDirection;
				#endif
				float2 clampResult10_g72 = clamp( staticSwitch41_g72 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g72 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g72 = (float4(transform1_g72.x , 0.0 , transform1_g72.z , 0.0));
				float dotResult4_g73 = dot( appendResult3_g72.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g73 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g73 ) * 43758.55 ) ));
				float mulTime9_g72 = _TimeParameters.x * lerpResult10_g73;
				float temp_output_29_0_g72 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g72 = ( temp_output_29_0_g72 * varWindSwayFrequency );
				#else
				float staticSwitch34_g72 = temp_output_29_0_g72;
				#endif
				float2 break26_g72 = ( ( ( temp_output_16_0_g72 * temp_output_16_0_g72 ) - temp_output_16_0_g72 ) * ( ( ( staticSwitch41_g72 * float2( 4,4 ) ) + sin( ( ( clampResult10_g72 * mulTime9_g72 ) * staticSwitch34_g72 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g72 = (float4(break26_g72.x , 0.0 , break26_g72.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g72;
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g74 ) + temp_output_246_0 );
				#endif
				float4 vWind116 = staticSwitch100;
				
				o.ase_texcoord8 = v.vertex;
				o.ase_texcoord9.xy = v.texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vWind116.rgb;

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

				float4 lerpResult115 = lerp( _FoliageColorBottom , _FoliageColorTop , saturate( ( ( IN.ase_texcoord8.xyz.y + _GradientOffset ) * ( _GradientFallout * 2 ) ) ));
				float temp_output_235_0 = ( _FoliageSize / 100.0 );
				float2 appendResult234 = (float2(temp_output_235_0 , temp_output_235_0));
				float2 texCoord236 = IN.ase_texcoord9.xy * appendResult234 + float2( 0,0 );
				float4 tex2DNode124 = tex2D( _FoliageColorMap, texCoord236 );
				float4 vFoliageColor172 = ( lerpResult115 * tex2DNode124 );
				float2 texCoord18_g75 = IN.ase_texcoord9.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_output_19_0_g75 = ( texCoord18_g75 / ( _TextureSize / 100.0 ) );
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch82 = ( _ColorTint * tex2D( _ColorMap, temp_output_19_0_g75 ) );
				#else
				float4 staticSwitch82 = vFoliageColor172;
				#endif
				
				float3 unpack176 = UnpackNormalScale( tex2D( _FoliageNormalMap, texCoord236 ), _FoliageNormalIntensity );
				unpack176.z = lerp( 1, unpack176.z, saturate(_FoliageNormalIntensity) );
				float3 vFoliageNormal226 = unpack176;
				float3 unpack26_g75 = UnpackNormalScale( tex2D( _NormalMap, temp_output_19_0_g75 ), _NormalIntensity );
				unpack26_g75.z = lerp( 1, unpack26_g75.z, saturate(_NormalIntensity) );
				#ifdef _USEDFORTRUNK_ON
				float3 staticSwitch97 = unpack26_g75;
				#else
				float3 staticSwitch97 = vFoliageNormal226;
				#endif
				
				float4 vFoliageEmissive225 = ( _FoliageEmissiveColor * _FoliageEmissiveIntensity );
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch228 = ( ( tex2D( _EmissiveMap, temp_output_19_0_g75 ) * _EmissiveColor ) * _EmissiveIntensity );
				#else
				float4 staticSwitch228 = vFoliageEmissive225;
				#endif
				
				float4 tex2DNode9_g76 = tex2D( _ORMMap, temp_output_19_0_g75 );
				#ifdef _USEDFORTRUNK_ON
				float staticSwitch98 = ( 1.0 - ( tex2DNode9_g76.g * _RoughnessIntensity ) );
				#else
				float staticSwitch98 = ( 1.0 - _FoliageRoughness );
				#endif
				
				float lerpResult10_g76 = lerp( 1.0 , tex2DNode9_g76.r , _AOIntensity);
				#ifdef _USEDFORTRUNK_ON
				float staticSwitch99 = lerpResult10_g76;
				#else
				float staticSwitch99 = 1.0;
				#endif
				
				float vFoliageOpacity173 = tex2DNode124.a;
				#ifdef _USEDFORTRUNK_ON
				float staticSwitch182 = 1.0;
				#else
				float staticSwitch182 = vFoliageOpacity173;
				#endif
				

				float3 BaseColor = staticSwitch82.rgb;
				float3 Normal = staticSwitch97;
				float3 Emission = staticSwitch228.rgb;
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = staticSwitch98;
				float Occlusion = staticSwitch99;
				float Alpha = staticSwitch182;
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
			#define _EMISSION
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
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _USEDFORTRUNK_ON
			#pragma shader_feature_local _USEGLOBALWINDSETTINGS_ON
			#pragma shader_feature_local _USESGLOBALWINDSETTINGS_ON


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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _EmissiveColor;
			float4 _FoliageColorBottom;
			float4 _FoliageColorTop;
			float4 _FoliageEmissiveColor;
			float4 _ColorTint;
			float2 _WindSwayDirection;
			int _Culling;
			float _FoliageRoughness;
			float _EmissiveIntensity;
			float _FoliageEmissiveIntensity;
			float _NormalIntensity;
			float _FoliageNormalIntensity;
			float _FoliageSize;
			float _RoughnessIntensity;
			float _GradientFallout;
			float _GradientOffset;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindJitterSpeed;
			float _WindScrollSpeed;
			float _TextureSize;
			float _AOIntensity;
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

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;


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

				float temp_output_18_0_g74 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g74 = ( temp_output_18_0_g74 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g74 = temp_output_18_0_g74;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g74 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g74 = ( appendResult4_g74 * 0.035 );
				float2 panner9_g74 = ( ( staticSwitch25_g74 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g74);
				float temp_output_19_0_g74 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g74 = ( temp_output_19_0_g74 * Float0 );
				#else
				float staticSwitch26_g74 = temp_output_19_0_g74;
				#endif
				float2 panner13_g74 = ( ( _TimeParameters.x * staticSwitch26_g74 ) * float2( 1,1 ) + ( temp_output_7_0_g74 * float2( 2,2 ) ));
				float4 lerpResult30_g74 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g74, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g74, 0, 0.0) ) ) , 1.0);
				float temp_output_27_0_g72 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g72 = ( temp_output_27_0_g72 * varWindSwayIntensity );
				#else
				float staticSwitch33_g72 = temp_output_27_0_g72;
				#endif
				float temp_output_14_0_g72 = ( ( v.vertex.xyz.y * ( staticSwitch33_g72 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g72 = ( temp_output_14_0_g72 * temp_output_14_0_g72 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g72 = varWindDirection;
				#else
				float2 staticSwitch41_g72 = _WindSwayDirection;
				#endif
				float2 clampResult10_g72 = clamp( staticSwitch41_g72 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g72 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g72 = (float4(transform1_g72.x , 0.0 , transform1_g72.z , 0.0));
				float dotResult4_g73 = dot( appendResult3_g72.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g73 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g73 ) * 43758.55 ) ));
				float mulTime9_g72 = _TimeParameters.x * lerpResult10_g73;
				float temp_output_29_0_g72 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g72 = ( temp_output_29_0_g72 * varWindSwayFrequency );
				#else
				float staticSwitch34_g72 = temp_output_29_0_g72;
				#endif
				float2 break26_g72 = ( ( ( temp_output_16_0_g72 * temp_output_16_0_g72 ) - temp_output_16_0_g72 ) * ( ( ( staticSwitch41_g72 * float2( 4,4 ) ) + sin( ( ( clampResult10_g72 * mulTime9_g72 ) * staticSwitch34_g72 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g72 = (float4(break26_g72.x , 0.0 , break26_g72.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g72;
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g74 ) + temp_output_246_0 );
				#endif
				float4 vWind116 = staticSwitch100;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vWind116.rgb;
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

				float temp_output_235_0 = ( _FoliageSize / 100.0 );
				float2 appendResult234 = (float2(temp_output_235_0 , temp_output_235_0));
				float2 texCoord236 = IN.ase_texcoord2.xy * appendResult234 + float2( 0,0 );
				float4 tex2DNode124 = tex2D( _FoliageColorMap, texCoord236 );
				float vFoliageOpacity173 = tex2DNode124.a;
				#ifdef _USEDFORTRUNK_ON
				float staticSwitch182 = 1.0;
				#else
				float staticSwitch182 = vFoliageOpacity173;
				#endif
				

				float Alpha = staticSwitch182;
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
			#define _EMISSION
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
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _USEDFORTRUNK_ON
			#pragma shader_feature_local _USEGLOBALWINDSETTINGS_ON
			#pragma shader_feature_local _USESGLOBALWINDSETTINGS_ON


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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _EmissiveColor;
			float4 _FoliageColorBottom;
			float4 _FoliageColorTop;
			float4 _FoliageEmissiveColor;
			float4 _ColorTint;
			float2 _WindSwayDirection;
			int _Culling;
			float _FoliageRoughness;
			float _EmissiveIntensity;
			float _FoliageEmissiveIntensity;
			float _NormalIntensity;
			float _FoliageNormalIntensity;
			float _FoliageSize;
			float _RoughnessIntensity;
			float _GradientFallout;
			float _GradientOffset;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindJitterSpeed;
			float _WindScrollSpeed;
			float _TextureSize;
			float _AOIntensity;
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

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;


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

				float temp_output_18_0_g74 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g74 = ( temp_output_18_0_g74 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g74 = temp_output_18_0_g74;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g74 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g74 = ( appendResult4_g74 * 0.035 );
				float2 panner9_g74 = ( ( staticSwitch25_g74 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g74);
				float temp_output_19_0_g74 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g74 = ( temp_output_19_0_g74 * Float0 );
				#else
				float staticSwitch26_g74 = temp_output_19_0_g74;
				#endif
				float2 panner13_g74 = ( ( _TimeParameters.x * staticSwitch26_g74 ) * float2( 1,1 ) + ( temp_output_7_0_g74 * float2( 2,2 ) ));
				float4 lerpResult30_g74 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g74, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g74, 0, 0.0) ) ) , 1.0);
				float temp_output_27_0_g72 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g72 = ( temp_output_27_0_g72 * varWindSwayIntensity );
				#else
				float staticSwitch33_g72 = temp_output_27_0_g72;
				#endif
				float temp_output_14_0_g72 = ( ( v.vertex.xyz.y * ( staticSwitch33_g72 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g72 = ( temp_output_14_0_g72 * temp_output_14_0_g72 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g72 = varWindDirection;
				#else
				float2 staticSwitch41_g72 = _WindSwayDirection;
				#endif
				float2 clampResult10_g72 = clamp( staticSwitch41_g72 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g72 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g72 = (float4(transform1_g72.x , 0.0 , transform1_g72.z , 0.0));
				float dotResult4_g73 = dot( appendResult3_g72.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g73 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g73 ) * 43758.55 ) ));
				float mulTime9_g72 = _TimeParameters.x * lerpResult10_g73;
				float temp_output_29_0_g72 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g72 = ( temp_output_29_0_g72 * varWindSwayFrequency );
				#else
				float staticSwitch34_g72 = temp_output_29_0_g72;
				#endif
				float2 break26_g72 = ( ( ( temp_output_16_0_g72 * temp_output_16_0_g72 ) - temp_output_16_0_g72 ) * ( ( ( staticSwitch41_g72 * float2( 4,4 ) ) + sin( ( ( clampResult10_g72 * mulTime9_g72 ) * staticSwitch34_g72 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g72 = (float4(break26_g72.x , 0.0 , break26_g72.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g72;
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g74 ) + temp_output_246_0 );
				#endif
				float4 vWind116 = staticSwitch100;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vWind116.rgb;

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

				float temp_output_235_0 = ( _FoliageSize / 100.0 );
				float2 appendResult234 = (float2(temp_output_235_0 , temp_output_235_0));
				float2 texCoord236 = IN.ase_texcoord2.xy * appendResult234 + float2( 0,0 );
				float4 tex2DNode124 = tex2D( _FoliageColorMap, texCoord236 );
				float vFoliageOpacity173 = tex2DNode124.a;
				#ifdef _USEDFORTRUNK_ON
				float staticSwitch182 = 1.0;
				#else
				float staticSwitch182 = vFoliageOpacity173;
				#endif
				

				float Alpha = staticSwitch182;
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
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120108


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
			#pragma shader_feature_local _USEDFORTRUNK_ON
			#pragma shader_feature_local _USEGLOBALWINDSETTINGS_ON
			#pragma shader_feature_local _USESGLOBALWINDSETTINGS_ON


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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _EmissiveColor;
			float4 _FoliageColorBottom;
			float4 _FoliageColorTop;
			float4 _FoliageEmissiveColor;
			float4 _ColorTint;
			float2 _WindSwayDirection;
			int _Culling;
			float _FoliageRoughness;
			float _EmissiveIntensity;
			float _FoliageEmissiveIntensity;
			float _NormalIntensity;
			float _FoliageNormalIntensity;
			float _FoliageSize;
			float _RoughnessIntensity;
			float _GradientFallout;
			float _GradientOffset;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindJitterSpeed;
			float _WindScrollSpeed;
			float _TextureSize;
			float _AOIntensity;
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

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;
			sampler2D _ColorMap;
			sampler2D _EmissiveMap;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float temp_output_18_0_g74 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g74 = ( temp_output_18_0_g74 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g74 = temp_output_18_0_g74;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g74 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g74 = ( appendResult4_g74 * 0.035 );
				float2 panner9_g74 = ( ( staticSwitch25_g74 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g74);
				float temp_output_19_0_g74 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g74 = ( temp_output_19_0_g74 * Float0 );
				#else
				float staticSwitch26_g74 = temp_output_19_0_g74;
				#endif
				float2 panner13_g74 = ( ( _TimeParameters.x * staticSwitch26_g74 ) * float2( 1,1 ) + ( temp_output_7_0_g74 * float2( 2,2 ) ));
				float4 lerpResult30_g74 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g74, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g74, 0, 0.0) ) ) , 1.0);
				float temp_output_27_0_g72 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g72 = ( temp_output_27_0_g72 * varWindSwayIntensity );
				#else
				float staticSwitch33_g72 = temp_output_27_0_g72;
				#endif
				float temp_output_14_0_g72 = ( ( v.vertex.xyz.y * ( staticSwitch33_g72 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g72 = ( temp_output_14_0_g72 * temp_output_14_0_g72 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g72 = varWindDirection;
				#else
				float2 staticSwitch41_g72 = _WindSwayDirection;
				#endif
				float2 clampResult10_g72 = clamp( staticSwitch41_g72 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g72 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g72 = (float4(transform1_g72.x , 0.0 , transform1_g72.z , 0.0));
				float dotResult4_g73 = dot( appendResult3_g72.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g73 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g73 ) * 43758.55 ) ));
				float mulTime9_g72 = _TimeParameters.x * lerpResult10_g73;
				float temp_output_29_0_g72 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g72 = ( temp_output_29_0_g72 * varWindSwayFrequency );
				#else
				float staticSwitch34_g72 = temp_output_29_0_g72;
				#endif
				float2 break26_g72 = ( ( ( temp_output_16_0_g72 * temp_output_16_0_g72 ) - temp_output_16_0_g72 ) * ( ( ( staticSwitch41_g72 * float2( 4,4 ) ) + sin( ( ( clampResult10_g72 * mulTime9_g72 ) * staticSwitch34_g72 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g72 = (float4(break26_g72.x , 0.0 , break26_g72.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g72;
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g74 ) + temp_output_246_0 );
				#endif
				float4 vWind116 = staticSwitch100;
				
				o.ase_texcoord4 = v.vertex;
				o.ase_texcoord5.xy = v.texcoord0.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord5.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vWind116.rgb;

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

				float4 lerpResult115 = lerp( _FoliageColorBottom , _FoliageColorTop , saturate( ( ( IN.ase_texcoord4.xyz.y + _GradientOffset ) * ( _GradientFallout * 2 ) ) ));
				float temp_output_235_0 = ( _FoliageSize / 100.0 );
				float2 appendResult234 = (float2(temp_output_235_0 , temp_output_235_0));
				float2 texCoord236 = IN.ase_texcoord5.xy * appendResult234 + float2( 0,0 );
				float4 tex2DNode124 = tex2D( _FoliageColorMap, texCoord236 );
				float4 vFoliageColor172 = ( lerpResult115 * tex2DNode124 );
				float2 texCoord18_g75 = IN.ase_texcoord5.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_output_19_0_g75 = ( texCoord18_g75 / ( _TextureSize / 100.0 ) );
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch82 = ( _ColorTint * tex2D( _ColorMap, temp_output_19_0_g75 ) );
				#else
				float4 staticSwitch82 = vFoliageColor172;
				#endif
				
				float4 vFoliageEmissive225 = ( _FoliageEmissiveColor * _FoliageEmissiveIntensity );
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch228 = ( ( tex2D( _EmissiveMap, temp_output_19_0_g75 ) * _EmissiveColor ) * _EmissiveIntensity );
				#else
				float4 staticSwitch228 = vFoliageEmissive225;
				#endif
				
				float vFoliageOpacity173 = tex2DNode124.a;
				#ifdef _USEDFORTRUNK_ON
				float staticSwitch182 = 1.0;
				#else
				float staticSwitch182 = vFoliageOpacity173;
				#endif
				

				float3 BaseColor = staticSwitch82.rgb;
				float3 Emission = staticSwitch228.rgb;
				float Alpha = staticSwitch182;
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

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			HLSLPROGRAM

			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#define ASE_FOG 1
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120108


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
			#pragma shader_feature_local _USEDFORTRUNK_ON
			#pragma shader_feature_local _USEGLOBALWINDSETTINGS_ON
			#pragma shader_feature_local _USESGLOBALWINDSETTINGS_ON


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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _EmissiveColor;
			float4 _FoliageColorBottom;
			float4 _FoliageColorTop;
			float4 _FoliageEmissiveColor;
			float4 _ColorTint;
			float2 _WindSwayDirection;
			int _Culling;
			float _FoliageRoughness;
			float _EmissiveIntensity;
			float _FoliageEmissiveIntensity;
			float _NormalIntensity;
			float _FoliageNormalIntensity;
			float _FoliageSize;
			float _RoughnessIntensity;
			float _GradientFallout;
			float _GradientOffset;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindJitterSpeed;
			float _WindScrollSpeed;
			float _TextureSize;
			float _AOIntensity;
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

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;
			sampler2D _ColorMap;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"

			//#ifdef HAVE_VFX_MODIFICATION
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
			//#endif

			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float temp_output_18_0_g74 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g74 = ( temp_output_18_0_g74 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g74 = temp_output_18_0_g74;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g74 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g74 = ( appendResult4_g74 * 0.035 );
				float2 panner9_g74 = ( ( staticSwitch25_g74 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g74);
				float temp_output_19_0_g74 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g74 = ( temp_output_19_0_g74 * Float0 );
				#else
				float staticSwitch26_g74 = temp_output_19_0_g74;
				#endif
				float2 panner13_g74 = ( ( _TimeParameters.x * staticSwitch26_g74 ) * float2( 1,1 ) + ( temp_output_7_0_g74 * float2( 2,2 ) ));
				float4 lerpResult30_g74 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g74, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g74, 0, 0.0) ) ) , 1.0);
				float temp_output_27_0_g72 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g72 = ( temp_output_27_0_g72 * varWindSwayIntensity );
				#else
				float staticSwitch33_g72 = temp_output_27_0_g72;
				#endif
				float temp_output_14_0_g72 = ( ( v.vertex.xyz.y * ( staticSwitch33_g72 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g72 = ( temp_output_14_0_g72 * temp_output_14_0_g72 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g72 = varWindDirection;
				#else
				float2 staticSwitch41_g72 = _WindSwayDirection;
				#endif
				float2 clampResult10_g72 = clamp( staticSwitch41_g72 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g72 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g72 = (float4(transform1_g72.x , 0.0 , transform1_g72.z , 0.0));
				float dotResult4_g73 = dot( appendResult3_g72.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g73 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g73 ) * 43758.55 ) ));
				float mulTime9_g72 = _TimeParameters.x * lerpResult10_g73;
				float temp_output_29_0_g72 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g72 = ( temp_output_29_0_g72 * varWindSwayFrequency );
				#else
				float staticSwitch34_g72 = temp_output_29_0_g72;
				#endif
				float2 break26_g72 = ( ( ( temp_output_16_0_g72 * temp_output_16_0_g72 ) - temp_output_16_0_g72 ) * ( ( ( staticSwitch41_g72 * float2( 4,4 ) ) + sin( ( ( clampResult10_g72 * mulTime9_g72 ) * staticSwitch34_g72 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g72 = (float4(break26_g72.x , 0.0 , break26_g72.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g72;
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g74 ) + temp_output_246_0 );
				#endif
				float4 vWind116 = staticSwitch100;
				
				o.ase_texcoord2 = v.vertex;
				o.ase_texcoord3.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord3.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vWind116.rgb;

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

				float4 lerpResult115 = lerp( _FoliageColorBottom , _FoliageColorTop , saturate( ( ( IN.ase_texcoord2.xyz.y + _GradientOffset ) * ( _GradientFallout * 2 ) ) ));
				float temp_output_235_0 = ( _FoliageSize / 100.0 );
				float2 appendResult234 = (float2(temp_output_235_0 , temp_output_235_0));
				float2 texCoord236 = IN.ase_texcoord3.xy * appendResult234 + float2( 0,0 );
				float4 tex2DNode124 = tex2D( _FoliageColorMap, texCoord236 );
				float4 vFoliageColor172 = ( lerpResult115 * tex2DNode124 );
				float2 texCoord18_g75 = IN.ase_texcoord3.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_output_19_0_g75 = ( texCoord18_g75 / ( _TextureSize / 100.0 ) );
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch82 = ( _ColorTint * tex2D( _ColorMap, temp_output_19_0_g75 ) );
				#else
				float4 staticSwitch82 = vFoliageColor172;
				#endif
				
				float vFoliageOpacity173 = tex2DNode124.a;
				#ifdef _USEDFORTRUNK_ON
				float staticSwitch182 = 1.0;
				#else
				float staticSwitch182 = vFoliageOpacity173;
				#endif
				

				float3 BaseColor = staticSwitch82.rgb;
				float Alpha = staticSwitch182;
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
			#define _EMISSION
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
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _USEDFORTRUNK_ON
			#pragma shader_feature_local _USEGLOBALWINDSETTINGS_ON
			#pragma shader_feature_local _USESGLOBALWINDSETTINGS_ON


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
			float4 _EmissiveColor;
			float4 _FoliageColorBottom;
			float4 _FoliageColorTop;
			float4 _FoliageEmissiveColor;
			float4 _ColorTint;
			float2 _WindSwayDirection;
			int _Culling;
			float _FoliageRoughness;
			float _EmissiveIntensity;
			float _FoliageEmissiveIntensity;
			float _NormalIntensity;
			float _FoliageNormalIntensity;
			float _FoliageSize;
			float _RoughnessIntensity;
			float _GradientFallout;
			float _GradientOffset;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindJitterSpeed;
			float _WindScrollSpeed;
			float _TextureSize;
			float _AOIntensity;
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

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageNormalMap;
			sampler2D _NormalMap;
			sampler2D _FoliageColorMap;


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

				float temp_output_18_0_g74 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g74 = ( temp_output_18_0_g74 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g74 = temp_output_18_0_g74;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g74 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g74 = ( appendResult4_g74 * 0.035 );
				float2 panner9_g74 = ( ( staticSwitch25_g74 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g74);
				float temp_output_19_0_g74 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g74 = ( temp_output_19_0_g74 * Float0 );
				#else
				float staticSwitch26_g74 = temp_output_19_0_g74;
				#endif
				float2 panner13_g74 = ( ( _TimeParameters.x * staticSwitch26_g74 ) * float2( 1,1 ) + ( temp_output_7_0_g74 * float2( 2,2 ) ));
				float4 lerpResult30_g74 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g74, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g74, 0, 0.0) ) ) , 1.0);
				float temp_output_27_0_g72 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g72 = ( temp_output_27_0_g72 * varWindSwayIntensity );
				#else
				float staticSwitch33_g72 = temp_output_27_0_g72;
				#endif
				float temp_output_14_0_g72 = ( ( v.vertex.xyz.y * ( staticSwitch33_g72 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g72 = ( temp_output_14_0_g72 * temp_output_14_0_g72 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g72 = varWindDirection;
				#else
				float2 staticSwitch41_g72 = _WindSwayDirection;
				#endif
				float2 clampResult10_g72 = clamp( staticSwitch41_g72 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g72 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g72 = (float4(transform1_g72.x , 0.0 , transform1_g72.z , 0.0));
				float dotResult4_g73 = dot( appendResult3_g72.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g73 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g73 ) * 43758.55 ) ));
				float mulTime9_g72 = _TimeParameters.x * lerpResult10_g73;
				float temp_output_29_0_g72 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g72 = ( temp_output_29_0_g72 * varWindSwayFrequency );
				#else
				float staticSwitch34_g72 = temp_output_29_0_g72;
				#endif
				float2 break26_g72 = ( ( ( temp_output_16_0_g72 * temp_output_16_0_g72 ) - temp_output_16_0_g72 ) * ( ( ( staticSwitch41_g72 * float2( 4,4 ) ) + sin( ( ( clampResult10_g72 * mulTime9_g72 ) * staticSwitch34_g72 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g72 = (float4(break26_g72.x , 0.0 , break26_g72.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g72;
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g74 ) + temp_output_246_0 );
				#endif
				float4 vWind116 = staticSwitch100;
				
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vWind116.rgb;

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

				float temp_output_235_0 = ( _FoliageSize / 100.0 );
				float2 appendResult234 = (float2(temp_output_235_0 , temp_output_235_0));
				float2 texCoord236 = IN.ase_texcoord4.xy * appendResult234 + float2( 0,0 );
				float3 unpack176 = UnpackNormalScale( tex2D( _FoliageNormalMap, texCoord236 ), _FoliageNormalIntensity );
				unpack176.z = lerp( 1, unpack176.z, saturate(_FoliageNormalIntensity) );
				float3 vFoliageNormal226 = unpack176;
				float2 texCoord18_g75 = IN.ase_texcoord4.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_output_19_0_g75 = ( texCoord18_g75 / ( _TextureSize / 100.0 ) );
				float3 unpack26_g75 = UnpackNormalScale( tex2D( _NormalMap, temp_output_19_0_g75 ), _NormalIntensity );
				unpack26_g75.z = lerp( 1, unpack26_g75.z, saturate(_NormalIntensity) );
				#ifdef _USEDFORTRUNK_ON
				float3 staticSwitch97 = unpack26_g75;
				#else
				float3 staticSwitch97 = vFoliageNormal226;
				#endif
				
				float4 tex2DNode124 = tex2D( _FoliageColorMap, texCoord236 );
				float vFoliageOpacity173 = tex2DNode124.a;
				#ifdef _USEDFORTRUNK_ON
				float staticSwitch182 = 1.0;
				#else
				float staticSwitch182 = vFoliageOpacity173;
				#endif
				

				float3 Normal = staticSwitch97;
				float Alpha = staticSwitch182;
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

			Blend One Zero, One Zero
			ZWrite On
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
			#define _EMISSION
			#define _NORMALMAP 1
			#define ASE_SRP_VERSION 120108


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
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _USEDFORTRUNK_ON
			#pragma shader_feature_local _USEGLOBALWINDSETTINGS_ON
			#pragma shader_feature_local _USESGLOBALWINDSETTINGS_ON


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
				float4 ase_texcoord9 : TEXCOORD9;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _EmissiveColor;
			float4 _FoliageColorBottom;
			float4 _FoliageColorTop;
			float4 _FoliageEmissiveColor;
			float4 _ColorTint;
			float2 _WindSwayDirection;
			int _Culling;
			float _FoliageRoughness;
			float _EmissiveIntensity;
			float _FoliageEmissiveIntensity;
			float _NormalIntensity;
			float _FoliageNormalIntensity;
			float _FoliageSize;
			float _RoughnessIntensity;
			float _GradientFallout;
			float _GradientOffset;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindJitterSpeed;
			float _WindScrollSpeed;
			float _TextureSize;
			float _AOIntensity;
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

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;
			sampler2D _ColorMap;
			sampler2D _FoliageNormalMap;
			sampler2D _NormalMap;
			sampler2D _EmissiveMap;
			sampler2D _ORMMap;


			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"

			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float temp_output_18_0_g74 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g74 = ( temp_output_18_0_g74 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g74 = temp_output_18_0_g74;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g74 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g74 = ( appendResult4_g74 * 0.035 );
				float2 panner9_g74 = ( ( staticSwitch25_g74 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g74);
				float temp_output_19_0_g74 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g74 = ( temp_output_19_0_g74 * Float0 );
				#else
				float staticSwitch26_g74 = temp_output_19_0_g74;
				#endif
				float2 panner13_g74 = ( ( _TimeParameters.x * staticSwitch26_g74 ) * float2( 1,1 ) + ( temp_output_7_0_g74 * float2( 2,2 ) ));
				float4 lerpResult30_g74 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g74, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g74, 0, 0.0) ) ) , 1.0);
				float temp_output_27_0_g72 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g72 = ( temp_output_27_0_g72 * varWindSwayIntensity );
				#else
				float staticSwitch33_g72 = temp_output_27_0_g72;
				#endif
				float temp_output_14_0_g72 = ( ( v.vertex.xyz.y * ( staticSwitch33_g72 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g72 = ( temp_output_14_0_g72 * temp_output_14_0_g72 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g72 = varWindDirection;
				#else
				float2 staticSwitch41_g72 = _WindSwayDirection;
				#endif
				float2 clampResult10_g72 = clamp( staticSwitch41_g72 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g72 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g72 = (float4(transform1_g72.x , 0.0 , transform1_g72.z , 0.0));
				float dotResult4_g73 = dot( appendResult3_g72.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g73 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g73 ) * 43758.55 ) ));
				float mulTime9_g72 = _TimeParameters.x * lerpResult10_g73;
				float temp_output_29_0_g72 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g72 = ( temp_output_29_0_g72 * varWindSwayFrequency );
				#else
				float staticSwitch34_g72 = temp_output_29_0_g72;
				#endif
				float2 break26_g72 = ( ( ( temp_output_16_0_g72 * temp_output_16_0_g72 ) - temp_output_16_0_g72 ) * ( ( ( staticSwitch41_g72 * float2( 4,4 ) ) + sin( ( ( clampResult10_g72 * mulTime9_g72 ) * staticSwitch34_g72 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g72 = (float4(break26_g72.x , 0.0 , break26_g72.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g72;
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g74 ) + temp_output_246_0 );
				#endif
				float4 vWind116 = staticSwitch100;
				
				o.ase_texcoord8 = v.vertex;
				o.ase_texcoord9.xy = v.texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord9.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vWind116.rgb;

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

				float4 lerpResult115 = lerp( _FoliageColorBottom , _FoliageColorTop , saturate( ( ( IN.ase_texcoord8.xyz.y + _GradientOffset ) * ( _GradientFallout * 2 ) ) ));
				float temp_output_235_0 = ( _FoliageSize / 100.0 );
				float2 appendResult234 = (float2(temp_output_235_0 , temp_output_235_0));
				float2 texCoord236 = IN.ase_texcoord9.xy * appendResult234 + float2( 0,0 );
				float4 tex2DNode124 = tex2D( _FoliageColorMap, texCoord236 );
				float4 vFoliageColor172 = ( lerpResult115 * tex2DNode124 );
				float2 texCoord18_g75 = IN.ase_texcoord9.xy * float2( 1,1 ) + float2( 0,0 );
				float2 temp_output_19_0_g75 = ( texCoord18_g75 / ( _TextureSize / 100.0 ) );
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch82 = ( _ColorTint * tex2D( _ColorMap, temp_output_19_0_g75 ) );
				#else
				float4 staticSwitch82 = vFoliageColor172;
				#endif
				
				float3 unpack176 = UnpackNormalScale( tex2D( _FoliageNormalMap, texCoord236 ), _FoliageNormalIntensity );
				unpack176.z = lerp( 1, unpack176.z, saturate(_FoliageNormalIntensity) );
				float3 vFoliageNormal226 = unpack176;
				float3 unpack26_g75 = UnpackNormalScale( tex2D( _NormalMap, temp_output_19_0_g75 ), _NormalIntensity );
				unpack26_g75.z = lerp( 1, unpack26_g75.z, saturate(_NormalIntensity) );
				#ifdef _USEDFORTRUNK_ON
				float3 staticSwitch97 = unpack26_g75;
				#else
				float3 staticSwitch97 = vFoliageNormal226;
				#endif
				
				float4 vFoliageEmissive225 = ( _FoliageEmissiveColor * _FoliageEmissiveIntensity );
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch228 = ( ( tex2D( _EmissiveMap, temp_output_19_0_g75 ) * _EmissiveColor ) * _EmissiveIntensity );
				#else
				float4 staticSwitch228 = vFoliageEmissive225;
				#endif
				
				float4 tex2DNode9_g76 = tex2D( _ORMMap, temp_output_19_0_g75 );
				#ifdef _USEDFORTRUNK_ON
				float staticSwitch98 = ( 1.0 - ( tex2DNode9_g76.g * _RoughnessIntensity ) );
				#else
				float staticSwitch98 = ( 1.0 - _FoliageRoughness );
				#endif
				
				float lerpResult10_g76 = lerp( 1.0 , tex2DNode9_g76.r , _AOIntensity);
				#ifdef _USEDFORTRUNK_ON
				float staticSwitch99 = lerpResult10_g76;
				#else
				float staticSwitch99 = 1.0;
				#endif
				
				float vFoliageOpacity173 = tex2DNode124.a;
				#ifdef _USEDFORTRUNK_ON
				float staticSwitch182 = 1.0;
				#else
				float staticSwitch182 = vFoliageOpacity173;
				#endif
				

				float3 BaseColor = staticSwitch82.rgb;
				float3 Normal = staticSwitch97;
				float3 Emission = staticSwitch228.rgb;
				float3 Specular = 0.5;
				float Metallic = 0;
				float Smoothness = staticSwitch98;
				float Occlusion = staticSwitch99;
				float Alpha = staticSwitch182;
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
			#define _EMISSION
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

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _USEDFORTRUNK_ON
			#pragma shader_feature_local _USEGLOBALWINDSETTINGS_ON
			#pragma shader_feature_local _USESGLOBALWINDSETTINGS_ON


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
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _EmissiveColor;
			float4 _FoliageColorBottom;
			float4 _FoliageColorTop;
			float4 _FoliageEmissiveColor;
			float4 _ColorTint;
			float2 _WindSwayDirection;
			int _Culling;
			float _FoliageRoughness;
			float _EmissiveIntensity;
			float _FoliageEmissiveIntensity;
			float _NormalIntensity;
			float _FoliageNormalIntensity;
			float _FoliageSize;
			float _RoughnessIntensity;
			float _GradientFallout;
			float _GradientOffset;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindJitterSpeed;
			float _WindScrollSpeed;
			float _TextureSize;
			float _AOIntensity;
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

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;


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

				float temp_output_18_0_g74 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g74 = ( temp_output_18_0_g74 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g74 = temp_output_18_0_g74;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g74 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g74 = ( appendResult4_g74 * 0.035 );
				float2 panner9_g74 = ( ( staticSwitch25_g74 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g74);
				float temp_output_19_0_g74 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g74 = ( temp_output_19_0_g74 * Float0 );
				#else
				float staticSwitch26_g74 = temp_output_19_0_g74;
				#endif
				float2 panner13_g74 = ( ( _TimeParameters.x * staticSwitch26_g74 ) * float2( 1,1 ) + ( temp_output_7_0_g74 * float2( 2,2 ) ));
				float4 lerpResult30_g74 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g74, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g74, 0, 0.0) ) ) , 1.0);
				float temp_output_27_0_g72 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g72 = ( temp_output_27_0_g72 * varWindSwayIntensity );
				#else
				float staticSwitch33_g72 = temp_output_27_0_g72;
				#endif
				float temp_output_14_0_g72 = ( ( v.vertex.xyz.y * ( staticSwitch33_g72 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g72 = ( temp_output_14_0_g72 * temp_output_14_0_g72 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g72 = varWindDirection;
				#else
				float2 staticSwitch41_g72 = _WindSwayDirection;
				#endif
				float2 clampResult10_g72 = clamp( staticSwitch41_g72 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g72 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g72 = (float4(transform1_g72.x , 0.0 , transform1_g72.z , 0.0));
				float dotResult4_g73 = dot( appendResult3_g72.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g73 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g73 ) * 43758.55 ) ));
				float mulTime9_g72 = _TimeParameters.x * lerpResult10_g73;
				float temp_output_29_0_g72 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g72 = ( temp_output_29_0_g72 * varWindSwayFrequency );
				#else
				float staticSwitch34_g72 = temp_output_29_0_g72;
				#endif
				float2 break26_g72 = ( ( ( temp_output_16_0_g72 * temp_output_16_0_g72 ) - temp_output_16_0_g72 ) * ( ( ( staticSwitch41_g72 * float2( 4,4 ) ) + sin( ( ( clampResult10_g72 * mulTime9_g72 ) * staticSwitch34_g72 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g72 = (float4(break26_g72.x , 0.0 , break26_g72.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g72;
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g74 ) + temp_output_246_0 );
				#endif
				float4 vWind116 = staticSwitch100;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vWind116.rgb;

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

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float temp_output_235_0 = ( _FoliageSize / 100.0 );
				float2 appendResult234 = (float2(temp_output_235_0 , temp_output_235_0));
				float2 texCoord236 = IN.ase_texcoord.xy * appendResult234 + float2( 0,0 );
				float4 tex2DNode124 = tex2D( _FoliageColorMap, texCoord236 );
				float vFoliageOpacity173 = tex2DNode124.a;
				#ifdef _USEDFORTRUNK_ON
				float staticSwitch182 = 1.0;
				#else
				float staticSwitch182 = vFoliageOpacity173;
				#endif
				

				surfaceDescription.Alpha = staticSwitch182;
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
			#define _EMISSION
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

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#pragma shader_feature_local _USEDFORTRUNK_ON
			#pragma shader_feature_local _USEGLOBALWINDSETTINGS_ON
			#pragma shader_feature_local _USESGLOBALWINDSETTINGS_ON


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
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _EmissiveColor;
			float4 _FoliageColorBottom;
			float4 _FoliageColorTop;
			float4 _FoliageEmissiveColor;
			float4 _ColorTint;
			float2 _WindSwayDirection;
			int _Culling;
			float _FoliageRoughness;
			float _EmissiveIntensity;
			float _FoliageEmissiveIntensity;
			float _NormalIntensity;
			float _FoliageNormalIntensity;
			float _FoliageSize;
			float _RoughnessIntensity;
			float _GradientFallout;
			float _GradientOffset;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindJitterSpeed;
			float _WindScrollSpeed;
			float _TextureSize;
			float _AOIntensity;
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

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;


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

				float temp_output_18_0_g74 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g74 = ( temp_output_18_0_g74 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g74 = temp_output_18_0_g74;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g74 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g74 = ( appendResult4_g74 * 0.035 );
				float2 panner9_g74 = ( ( staticSwitch25_g74 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g74);
				float temp_output_19_0_g74 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g74 = ( temp_output_19_0_g74 * Float0 );
				#else
				float staticSwitch26_g74 = temp_output_19_0_g74;
				#endif
				float2 panner13_g74 = ( ( _TimeParameters.x * staticSwitch26_g74 ) * float2( 1,1 ) + ( temp_output_7_0_g74 * float2( 2,2 ) ));
				float4 lerpResult30_g74 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g74, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g74, 0, 0.0) ) ) , 1.0);
				float temp_output_27_0_g72 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g72 = ( temp_output_27_0_g72 * varWindSwayIntensity );
				#else
				float staticSwitch33_g72 = temp_output_27_0_g72;
				#endif
				float temp_output_14_0_g72 = ( ( v.vertex.xyz.y * ( staticSwitch33_g72 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g72 = ( temp_output_14_0_g72 * temp_output_14_0_g72 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g72 = varWindDirection;
				#else
				float2 staticSwitch41_g72 = _WindSwayDirection;
				#endif
				float2 clampResult10_g72 = clamp( staticSwitch41_g72 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g72 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g72 = (float4(transform1_g72.x , 0.0 , transform1_g72.z , 0.0));
				float dotResult4_g73 = dot( appendResult3_g72.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g73 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g73 ) * 43758.55 ) ));
				float mulTime9_g72 = _TimeParameters.x * lerpResult10_g73;
				float temp_output_29_0_g72 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g72 = ( temp_output_29_0_g72 * varWindSwayFrequency );
				#else
				float staticSwitch34_g72 = temp_output_29_0_g72;
				#endif
				float2 break26_g72 = ( ( ( temp_output_16_0_g72 * temp_output_16_0_g72 ) - temp_output_16_0_g72 ) * ( ( ( staticSwitch41_g72 * float2( 4,4 ) ) + sin( ( ( clampResult10_g72 * mulTime9_g72 ) * staticSwitch34_g72 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g72 = (float4(break26_g72.x , 0.0 , break26_g72.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g72;
				#ifdef _USEDFORTRUNK_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g74 ) + temp_output_246_0 );
				#endif
				float4 vWind116 = staticSwitch100;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;

				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.vertex.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif

				float3 vertexValue = vWind116.rgb;

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

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				SurfaceDescription surfaceDescription = (SurfaceDescription)0;

				float temp_output_235_0 = ( _FoliageSize / 100.0 );
				float2 appendResult234 = (float2(temp_output_235_0 , temp_output_235_0));
				float2 texCoord236 = IN.ase_texcoord.xy * appendResult234 + float2( 0,0 );
				float4 tex2DNode124 = tex2D( _FoliageColorMap, texCoord236 );
				float vFoliageOpacity173 = tex2DNode124.a;
				#ifdef _USEDFORTRUNK_ON
				float staticSwitch182 = 1.0;
				#else
				float staticSwitch182 = vFoliageOpacity173;
				#endif
				

				surfaceDescription.Alpha = staticSwitch182;
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
	
	Fallback Off
}
/*ASEBEGIN
Version=19103
Node;AmplifyShaderEditor.RangedFloatNode;233;-3416.064,-1881.969;Inherit;False;Property;_FoliageSize;Foliage Size;4;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;235;-3240.15,-1876.368;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;234;-3105.964,-1883.67;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;122;-3064.14,916.776;Inherit;False;1419.315;573.4131;Comment;8;104;102;101;116;100;194;212;77;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-3364.521,-2127.726;Inherit;False;Property;_GradientOffset;Gradient Offset;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-3366.52,-2044.726;Inherit;False;Property;_GradientFallout;Gradient Fallout;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-3028.178,997.6157;Inherit;False;Property;_WindScrollSpeed;Wind Scroll Speed;35;0;Create;True;0;0;0;False;0;False;0.05;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;212;-3027.043,1081.038;Inherit;False;Property;_WindJitterSpeed;Wind Jitter Speed;36;0;Create;True;0;0;0;False;0;False;0.05;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;112;-3015.271,-2301.595;Inherit;False;Property;_FoliageColorTop;Foliage Color Top;5;1;[Header];Create;True;0;0;0;False;0;False;1,1,1,0;1,0,0.7909455,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;104;-2955.226,1335.112;Inherit;False;Property;_WindSwayDirection;Wind Sway Direction;39;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;236;-2948.401,-1905.561;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;114;-3026.939,-2483.921;Inherit;False;Property;_FoliageColorBottom;Foliage Color Bottom;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0.7909455,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;123;-2704.77,-2184.466;Inherit;True;Property;_FoliageColorMap;Foliage Color Map;1;2;[Header];[SingleLineTexture];Create;True;2;Foliage;.;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;174;-2688.444,-1929.97;Inherit;True;Property;_FoliageNormalMap;Foliage Normal Map;2;2;[Normal];[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;bump;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;101;-2954.226,1176.111;Inherit;False;Property;_WIndSwayIntensity;WInd Sway Intensity;40;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-2968.226,1257.111;Inherit;False;Property;_WIndSwayFrequency;WInd Sway Frequency;41;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;131;-3076.101,-2118.791;Inherit;False;PA_SF_ObjectGradient;-1;;52;f7566061dd2a41c4bbc5f0e0ea7b5f5b;0;2;8;FLOAT;0;False;9;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;246;-2714.226,1192.111;Inherit;False;PA_SF_WindSway;37;;72;bc8ec8a781a3c384e9042e29b2eae6d5;0;3;27;FLOAT;0;False;29;FLOAT;1;False;30;FLOAT2;1,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;124;-2448.591,-2185.154;Inherit;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;224;-2686.941,-1481.076;Inherit;False;Property;_FoliageEmissiveIntensity;Foliage Emissive Intensity;12;0;Create;True;0;0;0;False;0;False;0;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;175;-2432.265,-1930.658;Inherit;True;Property;_TextureSample3;Texture Sample 3;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;115;-2669.975,-2319.941;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;245;-2711.583,1063.127;Inherit;False;PA_SF_WindRustleNoise;32;;74;7733c52bc6ce2e94b9c81cb72dee5854;0;4;18;FLOAT;0;False;33;FLOAT;1;False;35;FLOAT;0.035;False;19;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-2412.641,-1743.529;Inherit;False;Property;_FoliageNormalIntensity;Foliage Normal Intensity;10;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;222;-2686.453,-1661.345;Inherit;False;Property;_FoliageEmissiveColor;Foliage Emissive Color;9;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;83;-3049.222,-875.8011;Inherit;False;1072.199;1674.577;Comment;13;96;95;94;93;92;91;90;89;88;87;86;85;84;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;93;-2985.696,191.0175;Inherit;False;Property;_AOIntensity;AO Intensity;29;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-2980.222,106.1985;Inherit;False;Property;_RoughnessIntensity;Roughness Intensity;27;0;Create;True;0;0;0;False;0;False;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;-2104.469,-2320.945;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;223;-2381.069,-1656.414;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.UnpackScaleNormalNode;176;-2091.523,-1925.919;Inherit;False;Tangent;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TexturePropertyNode;84;-2941.222,-738.8015;Inherit;True;Property;_ColorMap;Color Map;20;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RangedFloatNode;91;-2982.374,268.7941;Inherit;False;Property;_MetallicIntensity;Metallic Intensity;28;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-2881.222,-826.8011;Inherit;False;Property;_TextureSize;Texture Size;24;0;Create;True;0;0;0;False;0;False;100;100;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;94;-2936.834,349.4665;Inherit;True;Property;_EmissiveMap;Emissive Map;23;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.TexturePropertyNode;85;-2937.222,-372.8016;Inherit;True;Property;_NormalMap;Normal Map;21;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;True;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.ColorNode;92;-2919.356,540.1759;Inherit;False;Property;_EmissiveColor;Emissive Color;30;0;Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-2377.781,1061.776;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;88;-2984.222,-173.8012;Inherit;False;Property;_NormalIntensity;Normal Intensity;26;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-2911.356,713.1755;Inherit;False;Property;_EmissiveIntensity;Emissive Intensity;31;0;Create;True;0;0;0;False;0;False;0;0;0;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;95;-2918.222,-546.8016;Inherit;False;Property;_ColorTint;Color Tint;25;0;Create;True;0;0;0;False;0;False;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;89;-2938.222,-98.80125;Inherit;True;Property;_ORMMap;ORM Map;22;1;[SingleLineTexture];Create;True;0;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.RegisterLocalVarNode;173;-2071.848,-2087.301;Inherit;False;vFoliageOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;100;-2206.438,1162.627;Inherit;False;Property;_TrunkMaterial;Trunk Material?;13;0;Create;True;0;0;0;False;1;Header(TRUNK);False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;82;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;96;-2387.722,-259.9431;Inherit;False;PA_SF_BasePBR_OpaqueORM;14;;75;a21dcaebf1379e5439b421c5da1cd710;0;12;20;FLOAT;100;False;9;SAMPLER2D;0;False;15;COLOR;0,0,0,0;False;22;SAMPLER2D;;False;28;FLOAT;1;False;59;SAMPLER2D;;False;38;FLOAT;1;False;73;FLOAT;0;False;39;FLOAT;0;False;52;SAMPLER2D;;False;53;COLOR;0,0,0,0;False;54;FLOAT;0;False;6;COLOR;0;FLOAT3;7;COLOR;6;FLOAT;5;FLOAT;3;FLOAT;8
Node;AmplifyShaderEditor.RegisterLocalVarNode;172;-1890.849,-2326.3;Inherit;False;vFoliageColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;226;-1863.922,-1931.901;Inherit;False;vFoliageNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;220;-1830.553,34.33481;Inherit;False;Property;_FoliageRoughness;Foliage Roughness;11;0;Create;True;0;0;0;False;0;False;0.85;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;225;-2175.064,-1660.412;Inherit;False;vFoliageEmissive;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;-619.5778,71.2254;Inherit;False;173;vFoliageOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;187;-554.4885,146.7166;Inherit;False;Constant;_Float1;Float 1;34;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;227;-1586.681,-288.1677;Inherit;False;226;vFoliageNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;-1946.439,1163.627;Inherit;False;vWind;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;230;-1559.062,40.15799;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;237;-1831.389,-49.0491;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;232;-1865.879,90.96267;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;221;-1527.62,162.4118;Inherit;False;Constant;_AO;AO;34;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;229;-1722.231,-128.673;Inherit;False;225;vFoliageEmissive;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;231;-1890.55,167.2511;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;181;-1580.058,-441.5723;Inherit;False;172;vFoliageColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.IntNode;109;-704.7553,-965.1958;Inherit;False;Property;_Culling;Culling;0;1;[Enum];Create;True;0;3;Back;2;Front;1;Off;0;0;True;0;False;2;0;True;0;1;INT;0
Node;AmplifyShaderEditor.StaticSwitch;228;-1386.606,-89.33887;Inherit;False;Property;_TrunkMaterial;Trunk Material?;13;0;Create;True;0;0;0;False;1;Header(TRUNK);False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;82;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;-304.8967,175.2606;Inherit;False;116;vWind;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-706.6788,-1057.925;Inherit;False;Property;_MaskClipValue;Mask Clip Value;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;97;-1388.557,-270.4312;Inherit;False;Property;_TrunkMaterial;Trunk Material?;13;0;Create;True;0;0;0;False;1;Header(TRUNK);False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;82;True;True;All;9;1;FLOAT3;0,0,0;False;0;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StaticSwitch;82;-1388.657,-440.5339;Inherit;False;Property;_UsedforTrunk;Used for Trunk?;13;0;Create;True;0;0;0;False;1;Header (Trunk);False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;99;-1387.107,162.772;Inherit;False;Property;_TrunkMaterial;Trunk Material?;13;0;Create;True;0;0;0;False;1;Header(TRUNK);False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;82;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;98;-1389.094,36.90163;Inherit;False;Property;_TrunkMaterial;Trunk Material?;13;0;Create;True;0;0;0;False;1;Header(TRUNK);False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;82;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;182;-369.5775,72.2254;Inherit;False;Property;_TrunkMaterial;Trunk Material?;13;0;Create;True;0;0;0;False;1;Header(TRUNK);False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;82;True;True;All;9;1;FLOAT;0;False;0;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;253;-16.38549,-289.9302;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;0;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;254;-16.38549,-289.9302;Float;False;True;-1;2;UnityEditor.ShaderGraphLitGUI;0;12;Polyart/Dreamscape/URP/Tree Wind Deferred;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;19;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;;0;0;Standard;41;Workflow;1;0;Surface;0;0;  Refraction Model;0;0;  Blend;0;0;Two Sided;1;0;Fragment Normal Space,InvertActionOnDeselection;0;0;Forward Only;0;0;Transmission;0;0;  Transmission Shadow;0.5,False,;0;Translucency;0;0;  Translucency Strength;1,False,;0;  Normal Distortion;0.5,False,;0;  Scattering;2,False,;0;  Direct;0.9,False,;0;  Ambient;0.1,False,;0;  Shadow;0.5,False,;0;Cast Shadows;1;0;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;1;0;Built-in Fog;1;0;_FinalColorxAlpha;0;0;Meta Pass;1;0;Override Baked GI;0;0;Extra Pre Pass;0;0;DOTS Instancing;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Write Depth;0;0;  Early Z;0;0;Vertex Position,InvertActionOnDeselection;1;0;Debug Display;0;0;Clear Coat;0;0;0;10;False;True;True;True;True;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;255;-16.38549,-289.9302;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;256;-16.38549,-289.9302;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;True;1;LightMode=DepthOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;257;-16.38549,-289.9302;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;258;-16.38549,-289.9302;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;259;-16.38549,-289.9302;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthNormals;0;6;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormals;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;260;-16.38549,-289.9302;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;GBuffer;0;7;GBuffer;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalGBuffer;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;261;-16.38549,-289.9302;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;SceneSelectionPass;0;8;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;262;-16.38549,-289.9302;Float;False;False;-1;2;UnityEditor.ShaderGraphLitGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ScenePickingPass;0;9;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
WireConnection;235;0;233;0
WireConnection;234;0;235;0
WireConnection;234;1;235;0
WireConnection;236;0;234;0
WireConnection;131;8;110;0
WireConnection;131;9;111;0
WireConnection;246;27;101;0
WireConnection;246;29;102;0
WireConnection;246;30;104;0
WireConnection;124;0;123;0
WireConnection;124;1;236;0
WireConnection;175;0;174;0
WireConnection;175;1;236;0
WireConnection;115;0;114;0
WireConnection;115;1;112;0
WireConnection;115;2;131;0
WireConnection;245;18;194;0
WireConnection;245;19;212;0
WireConnection;125;0;115;0
WireConnection;125;1;124;0
WireConnection;223;0;222;0
WireConnection;223;1;224;0
WireConnection;176;0;175;0
WireConnection;176;1;177;0
WireConnection;77;0;245;0
WireConnection;77;1;246;0
WireConnection;173;0;124;4
WireConnection;100;1;77;0
WireConnection;100;0;246;0
WireConnection;96;20;87;0
WireConnection;96;9;84;0
WireConnection;96;15;95;0
WireConnection;96;22;85;0
WireConnection;96;28;88;0
WireConnection;96;59;89;0
WireConnection;96;38;86;0
WireConnection;96;73;93;0
WireConnection;96;39;91;0
WireConnection;96;52;94;0
WireConnection;96;53;92;0
WireConnection;96;54;90;0
WireConnection;172;0;125;0
WireConnection;226;0;176;0
WireConnection;225;0;223;0
WireConnection;116;0;100;0
WireConnection;230;0;220;0
WireConnection;237;0;96;6
WireConnection;232;0;96;5
WireConnection;231;0;96;8
WireConnection;228;1;229;0
WireConnection;228;0;237;0
WireConnection;97;1;227;0
WireConnection;97;0;96;7
WireConnection;82;1;181;0
WireConnection;82;0;96;0
WireConnection;99;1;221;0
WireConnection;99;0;231;0
WireConnection;98;1;230;0
WireConnection;98;0;232;0
WireConnection;182;1;183;0
WireConnection;182;0;187;0
WireConnection;254;0;82;0
WireConnection;254;1;97;0
WireConnection;254;2;228;0
WireConnection;254;4;98;0
WireConnection;254;5;99;0
WireConnection;254;6;182;0
WireConnection;254;8;117;0
ASEEND*/
//CHKSM=FF4A45F6EF0AF72EA26C24050EA1C694A7D70B0A