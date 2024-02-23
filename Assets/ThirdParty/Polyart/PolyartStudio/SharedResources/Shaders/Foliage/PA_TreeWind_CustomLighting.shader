// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Polyart/Dreamscape/URP/Tree Wind Custom Lighting"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][Header(Foliage)][Header(.)][SingleLineTexture]_FoliageColorMap("Foliage Color Map", 2D) = "white" {}
		_MaskClipValue("Mask Clip Value", Range( 0 , 1)) = 0.5
		_FoliageSize("Foliage Size", Float) = 100
		_FoliageColorTop("Foliage Color Top", Color) = (1,1,1,0)
		_FoliageColorBottom("Foliage Color Bottom", Color) = (0,0,0,0)
		_GradientOffset("Gradient Offset", Float) = 0
		_GradientFallout("Gradient Fallout", Float) = 0
		[Header(WIND RUSTLE)][Toggle(_USEGLOBALWINDSETTINGS_ON)] _UseGlobalWindSettings("Use Global Wind Settings?", Float) = 0
		[HideInInspector][SingleLineTexture]_NoiseTexture("NoiseTexture", 2D) = "white" {}
		_WindScrollSpeed("Wind Scroll Speed", Range( 0 , 0.5)) = 0.05
		_WindJitterSpeed("Wind Jitter Speed", Range( 0 , 0.5)) = 0.05
		[Header(TRUNK)][Toggle(_TRUNKMATERIAL_ON)] _TrunkMaterial("Trunk Material?", Float) = 0
		_WindOffsetIntensity("Wind Offset Intensity", Range( 0 , 1)) = 1
		_WindRustleSize("Wind Rustle Size", Range( 0 , 0.2)) = 0.035
		[Header(WIND SWAY)][Toggle(_USESGLOBALWINDSETTINGS_ON)] _UsesGlobalWindSettings("Uses Global Wind Settings?", Float) = 0
		_WindSwayDirection("Wind Sway Direction", Vector) = (1,0,0,0)
		_WIndSwayIntensity("WInd Sway Intensity", Float) = 1
		_WIndSwayFrequency("WInd Sway Frequency", Float) = 1
		[Header(Lighting Settings)][Space(5)]_LightOffset("Light Offset", Range( 0 , 1)) = 0
		_DirectLightInt("Direct Light Int", Range( 1 , 10)) = 1
		_IndirectLightningIntensity("Indirect Lightning Intensity", Range( 1 , 10)) = 1
		_SubsurfaceIntensity("Subsurface Intensity", Range( 0 , 100)) = 10
		[ASEEnd]_SubsurfaceFadeDistance("Subsurface Fade Distance", Float) = 200


		//_TessPhongStrength( "Tess Phong Strength", Range( 0, 1 ) ) = 0.5
		//_TessValue( "Tess Max Tessellation", Range( 1, 32 ) ) = 16
		//_TessMin( "Tess Min Distance", Float ) = 10
		//_TessMax( "Tess Max Distance", Float ) = 25
		//_TessEdgeLength ( "Tess Edge length", Range( 2, 50 ) ) = 16
		//_TessMaxDisp( "Tess Max Displacement", Float ) = 25

		[HideInInspector] _QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector] _QueueControl("_QueueControl", Float) = -1

        [HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" "UniversalMaterialType"="Unlit" }

		Cull Off
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
			Tags { "LightMode"="UniversalForwardOnly" }

			Blend One Zero, One Zero
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA

			

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120108


			#pragma multi_compile _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3

			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma shader_feature _ _SAMPLE_GI
			#pragma multi_compile _ DEBUG_DISPLAY

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS SHADERPASS_UNLIT

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging3D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceData.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
			#define ASE_NEEDS_FRAG_WORLD_POSITION
			#define ASE_NEEDS_FRAG_SHADOWCOORDS
			#pragma shader_feature_local _USEGLOBALWINDSETTINGS_ON
			#pragma shader_feature_local _USESGLOBALWINDSETTINGS_ON
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS


			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
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
				#ifdef ASE_FOG
					float fogFactor : TEXCOORD2;
				#endif
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 lightmapUVOrVertexSH : TEXCOORD5;
				float4 ase_texcoord6 : TEXCOORD6;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _FoliageColorTop;
			float4 _FoliageColorBottom;
			float2 _WindSwayDirection;
			float _SubsurfaceIntensity;
			float _DirectLightInt;
			float _LightOffset;
			float _IndirectLightningIntensity;
			float _FoliageSize;
			float _GradientFallout;
			float _WindScrollSpeed;
			float _SubsurfaceFadeDistance;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindOffsetIntensity;
			float _WindJitterSpeed;
			float _WindRustleSize;
			float _GradientOffset;
			float _MaskClipValue;
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;


			float3 AdditionalLightsFlat12x( float3 WorldPosition )
			{
				float3 Color = 0;
				#ifdef _ADDITIONAL_LIGHTS
					uint lightCount = GetAdditionalLightsCount();
					LIGHT_LOOP_BEGIN( lightCount )
						Light light = GetAdditionalLight(lightIndex, WorldPosition);
						Color += light.color *(light.distanceAttenuation * light.shadowAttenuation);	
					LIGHT_LOOP_END
				#endif
				return Color;
			}
			
			float3 ASEIndirectDiffuse( float2 uvStaticLightmap, float3 normalWS )
			{
			#ifdef LIGHTMAP_ON
				return SampleLightmap( uvStaticLightmap, normalWS );
			#else
				return SampleSH(normalWS);
			#endif
			}
			

			VertexOutput VertexFunction ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float temp_output_18_0_g87 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g87 = ( temp_output_18_0_g87 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g87 = temp_output_18_0_g87;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g87 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g87 = ( appendResult4_g87 * _WindRustleSize );
				float2 panner9_g87 = ( ( staticSwitch25_g87 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g87);
				float temp_output_19_0_g87 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g87 = ( temp_output_19_0_g87 * Float0 );
				#else
				float staticSwitch26_g87 = temp_output_19_0_g87;
				#endif
				float2 panner13_g87 = ( ( _TimeParameters.x * staticSwitch26_g87 ) * float2( 1,1 ) + ( temp_output_7_0_g87 * float2( 2,2 ) ));
				float4 lerpResult30_g87 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g87, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g87, 0, 0.0) ) ) , _WindOffsetIntensity);
				float temp_output_27_0_g88 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g88 = ( temp_output_27_0_g88 * varWindSwayIntensity );
				#else
				float staticSwitch33_g88 = temp_output_27_0_g88;
				#endif
				float temp_output_14_0_g88 = ( ( v.vertex.xyz.y * ( staticSwitch33_g88 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g88 = ( temp_output_14_0_g88 * temp_output_14_0_g88 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g88 = varWindDirection;
				#else
				float2 staticSwitch41_g88 = _WindSwayDirection;
				#endif
				float2 clampResult10_g88 = clamp( staticSwitch41_g88 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g88 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g88 = (float4(transform1_g88.x , 0.0 , transform1_g88.z , 0.0));
				float dotResult4_g89 = dot( appendResult3_g88.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g89 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g89 ) * 43758.55 ) ));
				float mulTime9_g88 = _TimeParameters.x * lerpResult10_g89;
				float temp_output_29_0_g88 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g88 = ( temp_output_29_0_g88 * varWindSwayFrequency );
				#else
				float staticSwitch34_g88 = temp_output_29_0_g88;
				#endif
				float2 break26_g88 = ( ( ( temp_output_16_0_g88 * temp_output_16_0_g88 ) - temp_output_16_0_g88 ) * ( ( ( staticSwitch41_g88 * float2( 4,4 ) ) + sin( ( ( clampResult10_g88 * mulTime9_g88 ) * staticSwitch34_g88 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g88 = (float4(break26_g88.x , 0.0 , break26_g88.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g88;
				#ifdef _TRUNKMATERIAL_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g87 ) + temp_output_246_0 );
				#endif
				float4 vWind116 = staticSwitch100;
				
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH( ase_worldNormal, o.lightmapUVOrVertexSH.xyz );
				o.ase_texcoord6.xyz = ase_worldNormal;
				
				o.ase_texcoord3 = v.vertex;
				o.ase_texcoord4.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord4.zw = 0;
				o.ase_texcoord6.w = 0;

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

				#ifdef ASE_FOG
					o.fogFactor = ComputeFogFactor( positionCS.z );
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
				float4 texcoord1 : TEXCOORD1;

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
				o.texcoord1 = v.texcoord1;
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
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
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

			half4 frag ( VertexOutput IN  ) : SV_Target
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

				float4 lerpResult115 = lerp( _FoliageColorBottom , _FoliageColorTop , saturate( ( ( IN.ase_texcoord3.xyz.y + _GradientOffset ) * ( _GradientFallout * 2 ) ) ));
				float temp_output_235_0 = ( _FoliageSize / 100.0 );
				float2 appendResult234 = (float2(temp_output_235_0 , temp_output_235_0));
				float2 texCoord236 = IN.ase_texcoord4.xy * appendResult234 + float2( 0,0 );
				float4 tex2DNode124 = tex2D( _FoliageColorMap, texCoord236 );
				float4 vFoliageColor172 = ( lerpResult115 * tex2DNode124 );
				float3 worldPosValue44_g92 = WorldPosition;
				float3 WorldPosition8_g92 = worldPosValue44_g92;
				float3 localAdditionalLightsFlat12x8_g92 = AdditionalLightsFlat12x( WorldPosition8_g92 );
				float3 FlatResult29_g92 = localAdditionalLightsFlat12x8_g92;
				float3 ase_worldNormal = IN.ase_texcoord6.xyz;
				float3 bakedGI301 = ASEIndirectDiffuse( IN.lightmapUVOrVertexSH.xy, ase_worldNormal);
				Light ase_mainLight = GetMainLight( ShadowCoords );
				MixRealtimeAndBakedGI(ase_mainLight, ase_worldNormal, bakedGI301, half4(0,0,0,0));
				float4 vIndirectLightning310 = ( ( float4( bakedGI301 , 0.0 ) * vFoliageColor172 ) * _IndirectLightningIntensity );
				float3 normalizedWorldNormal = normalize( ase_worldNormal );
				float dotResult4_g91 = dot( SafeNormalize(_MainLightPosition.xyz) , normalizedWorldNormal );
				float ase_lightAtten = 0;
				ase_lightAtten = ase_mainLight.distanceAttenuation * ase_mainLight.shadowAttenuation;
				float4 DirectLight312 = ( ( ( ( saturate( (dotResult4_g91*1.0 + _LightOffset) ) * ase_lightAtten ) * _MainLightColor ) * vFoliageColor172 ) * _DirectLightInt );
				float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - WorldPosition );
				ase_worldViewDir = SafeNormalize( ase_worldViewDir );
				float dotResult11_g90 = dot( SafeNormalize(_MainLightPosition.xyz) , ase_worldViewDir );
				float dotResult4_g90 = dot( SafeNormalize(_MainLightPosition.xyz) , normalizedWorldNormal );
				float clampResult9_g95 = clamp( pow( ( distance( WorldPosition , _WorldSpaceCameraPos ) / _SubsurfaceFadeDistance ) , 2.0 ) , 0.0 , 1.0 );
				float lerpResult402 = lerp( _SubsurfaceIntensity , 0.0 , clampResult9_g95);
				float4 vSubsurface322 = saturate( ( ( (( dotResult11_g90 * -1.0 )*1.0 + -0.25) * ( ( ( (dotResult4_g90*1.0 + 1.0) * ase_lightAtten ) * _MainLightColor * vFoliageColor172 ) * 0.235 ) ) * lerpResult402 ) );
				
				float vFoliageOpacity173 = tex2DNode124.a;
				
				float3 BakedAlbedo = 0;
				float3 BakedEmission = 0;
				float3 Color = ( ( vFoliageColor172 * float4( FlatResult29_g92 , 0.0 ) ) + ( vIndirectLightning310 + DirectLight312 + vSubsurface322 ) ).rgb;
				float Alpha = vFoliageOpacity173;
				float AlphaClipThreshold = _MaskClipValue;
				float AlphaClipThresholdShadow = 0.5;

				#ifdef _ALPHATEST_ON
					clip( Alpha - AlphaClipThreshold );
				#endif

				#if defined(_DBUFFER)
					ApplyDecalToBaseColor(IN.clipPos, Color);
				#endif

				#if defined(_ALPHAPREMULTIPLY_ON)
				Color *= Alpha;
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				#ifdef ASE_FOG
					Color = MixFog( Color, IN.fogFactor );
				#endif

				return half4( Color, Alpha );
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

			#pragma multi_compile_instancing
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120108


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ _CASTING_PUNCTUAL_LIGHT_SHADOW

			#define SHADERPASS SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
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
			float4 _FoliageColorTop;
			float4 _FoliageColorBottom;
			float2 _WindSwayDirection;
			float _SubsurfaceIntensity;
			float _DirectLightInt;
			float _LightOffset;
			float _IndirectLightningIntensity;
			float _FoliageSize;
			float _GradientFallout;
			float _WindScrollSpeed;
			float _SubsurfaceFadeDistance;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindOffsetIntensity;
			float _WindJitterSpeed;
			float _WindRustleSize;
			float _GradientOffset;
			float _MaskClipValue;
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;


			
			float3 _LightDirection;
			float3 _LightPosition;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				float temp_output_18_0_g87 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g87 = ( temp_output_18_0_g87 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g87 = temp_output_18_0_g87;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g87 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g87 = ( appendResult4_g87 * _WindRustleSize );
				float2 panner9_g87 = ( ( staticSwitch25_g87 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g87);
				float temp_output_19_0_g87 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g87 = ( temp_output_19_0_g87 * Float0 );
				#else
				float staticSwitch26_g87 = temp_output_19_0_g87;
				#endif
				float2 panner13_g87 = ( ( _TimeParameters.x * staticSwitch26_g87 ) * float2( 1,1 ) + ( temp_output_7_0_g87 * float2( 2,2 ) ));
				float4 lerpResult30_g87 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g87, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g87, 0, 0.0) ) ) , _WindOffsetIntensity);
				float temp_output_27_0_g88 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g88 = ( temp_output_27_0_g88 * varWindSwayIntensity );
				#else
				float staticSwitch33_g88 = temp_output_27_0_g88;
				#endif
				float temp_output_14_0_g88 = ( ( v.vertex.xyz.y * ( staticSwitch33_g88 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g88 = ( temp_output_14_0_g88 * temp_output_14_0_g88 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g88 = varWindDirection;
				#else
				float2 staticSwitch41_g88 = _WindSwayDirection;
				#endif
				float2 clampResult10_g88 = clamp( staticSwitch41_g88 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g88 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g88 = (float4(transform1_g88.x , 0.0 , transform1_g88.z , 0.0));
				float dotResult4_g89 = dot( appendResult3_g88.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g89 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g89 ) * 43758.55 ) ));
				float mulTime9_g88 = _TimeParameters.x * lerpResult10_g89;
				float temp_output_29_0_g88 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g88 = ( temp_output_29_0_g88 * varWindSwayFrequency );
				#else
				float staticSwitch34_g88 = temp_output_29_0_g88;
				#endif
				float2 break26_g88 = ( ( ( temp_output_16_0_g88 * temp_output_16_0_g88 ) - temp_output_16_0_g88 ) * ( ( ( staticSwitch41_g88 * float2( 4,4 ) ) + sin( ( ( clampResult10_g88 * mulTime9_g88 ) * staticSwitch34_g88 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g88 = (float4(break26_g88.x , 0.0 , break26_g88.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g88;
				#ifdef _TRUNKMATERIAL_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g87 ) + temp_output_246_0 );
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

				float3 normalWS = TransformObjectToWorldDir( v.ase_normal );

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

				float temp_output_235_0 = ( _FoliageSize / 100.0 );
				float2 appendResult234 = (float2(temp_output_235_0 , temp_output_235_0));
				float2 texCoord236 = IN.ase_texcoord2.xy * appendResult234 + float2( 0,0 );
				float4 tex2DNode124 = tex2D( _FoliageColorMap, texCoord236 );
				float vFoliageOpacity173 = tex2DNode124.a;
				

				float Alpha = vFoliageOpacity173;
				float AlphaClipThreshold = _MaskClipValue;
				float AlphaClipThresholdShadow = 0.5;

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

			#pragma multi_compile_instancing
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120108


			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
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
			float4 _FoliageColorTop;
			float4 _FoliageColorBottom;
			float2 _WindSwayDirection;
			float _SubsurfaceIntensity;
			float _DirectLightInt;
			float _LightOffset;
			float _IndirectLightningIntensity;
			float _FoliageSize;
			float _GradientFallout;
			float _WindScrollSpeed;
			float _SubsurfaceFadeDistance;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindOffsetIntensity;
			float _WindJitterSpeed;
			float _WindRustleSize;
			float _GradientOffset;
			float _MaskClipValue;
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float temp_output_18_0_g87 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g87 = ( temp_output_18_0_g87 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g87 = temp_output_18_0_g87;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g87 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g87 = ( appendResult4_g87 * _WindRustleSize );
				float2 panner9_g87 = ( ( staticSwitch25_g87 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g87);
				float temp_output_19_0_g87 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g87 = ( temp_output_19_0_g87 * Float0 );
				#else
				float staticSwitch26_g87 = temp_output_19_0_g87;
				#endif
				float2 panner13_g87 = ( ( _TimeParameters.x * staticSwitch26_g87 ) * float2( 1,1 ) + ( temp_output_7_0_g87 * float2( 2,2 ) ));
				float4 lerpResult30_g87 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g87, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g87, 0, 0.0) ) ) , _WindOffsetIntensity);
				float temp_output_27_0_g88 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g88 = ( temp_output_27_0_g88 * varWindSwayIntensity );
				#else
				float staticSwitch33_g88 = temp_output_27_0_g88;
				#endif
				float temp_output_14_0_g88 = ( ( v.vertex.xyz.y * ( staticSwitch33_g88 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g88 = ( temp_output_14_0_g88 * temp_output_14_0_g88 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g88 = varWindDirection;
				#else
				float2 staticSwitch41_g88 = _WindSwayDirection;
				#endif
				float2 clampResult10_g88 = clamp( staticSwitch41_g88 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g88 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g88 = (float4(transform1_g88.x , 0.0 , transform1_g88.z , 0.0));
				float dotResult4_g89 = dot( appendResult3_g88.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g89 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g89 ) * 43758.55 ) ));
				float mulTime9_g88 = _TimeParameters.x * lerpResult10_g89;
				float temp_output_29_0_g88 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g88 = ( temp_output_29_0_g88 * varWindSwayFrequency );
				#else
				float staticSwitch34_g88 = temp_output_29_0_g88;
				#endif
				float2 break26_g88 = ( ( ( temp_output_16_0_g88 * temp_output_16_0_g88 ) - temp_output_16_0_g88 ) * ( ( ( staticSwitch41_g88 * float2( 4,4 ) ) + sin( ( ( clampResult10_g88 * mulTime9_g88 ) * staticSwitch34_g88 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g88 = (float4(break26_g88.x , 0.0 , break26_g88.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g88;
				#ifdef _TRUNKMATERIAL_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g87 ) + temp_output_246_0 );
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

				o.clipPos = TransformWorldToHClip( positionWS );
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
				

				float Alpha = vFoliageOpacity173;
				float AlphaClipThreshold = _MaskClipValue;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif
				return 0;
			}
			ENDHLSL
		}

		
		Pass
		{
			
            Name "SceneSelectionPass"
            Tags { "LightMode"="SceneSelectionPass" }

			Cull Off

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120108


			#pragma vertex vert
			#pragma fragment frag

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
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
			float4 _FoliageColorTop;
			float4 _FoliageColorBottom;
			float2 _WindSwayDirection;
			float _SubsurfaceIntensity;
			float _DirectLightInt;
			float _LightOffset;
			float _IndirectLightningIntensity;
			float _FoliageSize;
			float _GradientFallout;
			float _WindScrollSpeed;
			float _SubsurfaceFadeDistance;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindOffsetIntensity;
			float _WindJitterSpeed;
			float _WindRustleSize;
			float _GradientOffset;
			float _MaskClipValue;
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;


			
			int _ObjectId;
			int _PassValue;

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

				float temp_output_18_0_g87 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g87 = ( temp_output_18_0_g87 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g87 = temp_output_18_0_g87;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g87 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g87 = ( appendResult4_g87 * _WindRustleSize );
				float2 panner9_g87 = ( ( staticSwitch25_g87 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g87);
				float temp_output_19_0_g87 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g87 = ( temp_output_19_0_g87 * Float0 );
				#else
				float staticSwitch26_g87 = temp_output_19_0_g87;
				#endif
				float2 panner13_g87 = ( ( _TimeParameters.x * staticSwitch26_g87 ) * float2( 1,1 ) + ( temp_output_7_0_g87 * float2( 2,2 ) ));
				float4 lerpResult30_g87 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g87, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g87, 0, 0.0) ) ) , _WindOffsetIntensity);
				float temp_output_27_0_g88 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g88 = ( temp_output_27_0_g88 * varWindSwayIntensity );
				#else
				float staticSwitch33_g88 = temp_output_27_0_g88;
				#endif
				float temp_output_14_0_g88 = ( ( v.vertex.xyz.y * ( staticSwitch33_g88 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g88 = ( temp_output_14_0_g88 * temp_output_14_0_g88 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g88 = varWindDirection;
				#else
				float2 staticSwitch41_g88 = _WindSwayDirection;
				#endif
				float2 clampResult10_g88 = clamp( staticSwitch41_g88 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g88 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g88 = (float4(transform1_g88.x , 0.0 , transform1_g88.z , 0.0));
				float dotResult4_g89 = dot( appendResult3_g88.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g89 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g89 ) * 43758.55 ) ));
				float mulTime9_g88 = _TimeParameters.x * lerpResult10_g89;
				float temp_output_29_0_g88 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g88 = ( temp_output_29_0_g88 * varWindSwayFrequency );
				#else
				float staticSwitch34_g88 = temp_output_29_0_g88;
				#endif
				float2 break26_g88 = ( ( ( temp_output_16_0_g88 * temp_output_16_0_g88 ) - temp_output_16_0_g88 ) * ( ( ( staticSwitch41_g88 * float2( 4,4 ) ) + sin( ( ( clampResult10_g88 * mulTime9_g88 ) * staticSwitch34_g88 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g88 = (float4(break26_g88.x , 0.0 , break26_g88.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g88;
				#ifdef _TRUNKMATERIAL_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g87 ) + temp_output_246_0 );
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
				

				surfaceDescription.Alpha = vFoliageOpacity173;
				surfaceDescription.AlphaClipThreshold = _MaskClipValue;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
					clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				return outColor;
			}
			ENDHLSL
		}

		
		Pass
		{
			
            Name "ScenePickingPass"
            Tags { "LightMode"="Picking" }

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120108


			#pragma vertex vert
			#pragma fragment frag

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define SHADERPASS SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
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
			float4 _FoliageColorTop;
			float4 _FoliageColorBottom;
			float2 _WindSwayDirection;
			float _SubsurfaceIntensity;
			float _DirectLightInt;
			float _LightOffset;
			float _IndirectLightningIntensity;
			float _FoliageSize;
			float _GradientFallout;
			float _WindScrollSpeed;
			float _SubsurfaceFadeDistance;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindOffsetIntensity;
			float _WindJitterSpeed;
			float _WindRustleSize;
			float _GradientOffset;
			float _MaskClipValue;
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;


			
			float4 _SelectionID;


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

				float temp_output_18_0_g87 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g87 = ( temp_output_18_0_g87 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g87 = temp_output_18_0_g87;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g87 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g87 = ( appendResult4_g87 * _WindRustleSize );
				float2 panner9_g87 = ( ( staticSwitch25_g87 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g87);
				float temp_output_19_0_g87 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g87 = ( temp_output_19_0_g87 * Float0 );
				#else
				float staticSwitch26_g87 = temp_output_19_0_g87;
				#endif
				float2 panner13_g87 = ( ( _TimeParameters.x * staticSwitch26_g87 ) * float2( 1,1 ) + ( temp_output_7_0_g87 * float2( 2,2 ) ));
				float4 lerpResult30_g87 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g87, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g87, 0, 0.0) ) ) , _WindOffsetIntensity);
				float temp_output_27_0_g88 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g88 = ( temp_output_27_0_g88 * varWindSwayIntensity );
				#else
				float staticSwitch33_g88 = temp_output_27_0_g88;
				#endif
				float temp_output_14_0_g88 = ( ( v.vertex.xyz.y * ( staticSwitch33_g88 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g88 = ( temp_output_14_0_g88 * temp_output_14_0_g88 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g88 = varWindDirection;
				#else
				float2 staticSwitch41_g88 = _WindSwayDirection;
				#endif
				float2 clampResult10_g88 = clamp( staticSwitch41_g88 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g88 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g88 = (float4(transform1_g88.x , 0.0 , transform1_g88.z , 0.0));
				float dotResult4_g89 = dot( appendResult3_g88.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g89 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g89 ) * 43758.55 ) ));
				float mulTime9_g88 = _TimeParameters.x * lerpResult10_g89;
				float temp_output_29_0_g88 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g88 = ( temp_output_29_0_g88 * varWindSwayFrequency );
				#else
				float staticSwitch34_g88 = temp_output_29_0_g88;
				#endif
				float2 break26_g88 = ( ( ( temp_output_16_0_g88 * temp_output_16_0_g88 ) - temp_output_16_0_g88 ) * ( ( ( staticSwitch41_g88 * float2( 4,4 ) ) + sin( ( ( clampResult10_g88 * mulTime9_g88 ) * staticSwitch34_g88 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g88 = (float4(break26_g88.x , 0.0 , break26_g88.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g88;
				#ifdef _TRUNKMATERIAL_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g87 ) + temp_output_246_0 );
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
				

				surfaceDescription.Alpha = vFoliageOpacity173;
				surfaceDescription.AlphaClipThreshold = _MaskClipValue;

				#if _ALPHATEST_ON
					float alphaClipThreshold = 0.01f;
					#if ALPHA_CLIP_THRESHOLD
						alphaClipThreshold = surfaceDescription.AlphaClipThreshold;
					#endif
					clip(surfaceDescription.Alpha - alphaClipThreshold);
				#endif

				half4 outColor = 0;
				outColor = _SelectionID;

				return outColor;
			}

			ENDHLSL
		}

		
		Pass
		{
			
            Name "DepthNormals"
            Tags { "LightMode"="DepthNormalsOnly" }

			ZTest LEqual
			ZWrite On


			HLSLPROGRAM

			#pragma multi_compile_instancing
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120108


			#pragma vertex vert
			#pragma fragment frag

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define VARYINGS_NEED_NORMAL_WS

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
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
				float3 normalWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _FoliageColorTop;
			float4 _FoliageColorBottom;
			float2 _WindSwayDirection;
			float _SubsurfaceIntensity;
			float _DirectLightInt;
			float _LightOffset;
			float _IndirectLightningIntensity;
			float _FoliageSize;
			float _GradientFallout;
			float _WindScrollSpeed;
			float _SubsurfaceFadeDistance;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindOffsetIntensity;
			float _WindJitterSpeed;
			float _WindRustleSize;
			float _GradientOffset;
			float _MaskClipValue;
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END

			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;


			
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

				float temp_output_18_0_g87 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g87 = ( temp_output_18_0_g87 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g87 = temp_output_18_0_g87;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g87 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g87 = ( appendResult4_g87 * _WindRustleSize );
				float2 panner9_g87 = ( ( staticSwitch25_g87 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g87);
				float temp_output_19_0_g87 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g87 = ( temp_output_19_0_g87 * Float0 );
				#else
				float staticSwitch26_g87 = temp_output_19_0_g87;
				#endif
				float2 panner13_g87 = ( ( _TimeParameters.x * staticSwitch26_g87 ) * float2( 1,1 ) + ( temp_output_7_0_g87 * float2( 2,2 ) ));
				float4 lerpResult30_g87 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g87, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g87, 0, 0.0) ) ) , _WindOffsetIntensity);
				float temp_output_27_0_g88 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g88 = ( temp_output_27_0_g88 * varWindSwayIntensity );
				#else
				float staticSwitch33_g88 = temp_output_27_0_g88;
				#endif
				float temp_output_14_0_g88 = ( ( v.vertex.xyz.y * ( staticSwitch33_g88 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g88 = ( temp_output_14_0_g88 * temp_output_14_0_g88 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g88 = varWindDirection;
				#else
				float2 staticSwitch41_g88 = _WindSwayDirection;
				#endif
				float2 clampResult10_g88 = clamp( staticSwitch41_g88 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g88 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g88 = (float4(transform1_g88.x , 0.0 , transform1_g88.z , 0.0));
				float dotResult4_g89 = dot( appendResult3_g88.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g89 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g89 ) * 43758.55 ) ));
				float mulTime9_g88 = _TimeParameters.x * lerpResult10_g89;
				float temp_output_29_0_g88 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g88 = ( temp_output_29_0_g88 * varWindSwayFrequency );
				#else
				float staticSwitch34_g88 = temp_output_29_0_g88;
				#endif
				float2 break26_g88 = ( ( ( temp_output_16_0_g88 * temp_output_16_0_g88 ) - temp_output_16_0_g88 ) * ( ( ( staticSwitch41_g88 * float2( 4,4 ) ) + sin( ( ( clampResult10_g88 * mulTime9_g88 ) * staticSwitch34_g88 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g88 = (float4(break26_g88.x , 0.0 , break26_g88.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g88;
				#ifdef _TRUNKMATERIAL_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g87 ) + temp_output_246_0 );
				#endif
				float4 vWind116 = staticSwitch100;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
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
				float3 normalWS = TransformObjectToWorldNormal(v.ase_normal);

				o.clipPos = TransformWorldToHClip(positionWS);
				o.normalWS.xyz =  normalWS;

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
				float2 texCoord236 = IN.ase_texcoord1.xy * appendResult234 + float2( 0,0 );
				float4 tex2DNode124 = tex2D( _FoliageColorMap, texCoord236 );
				float vFoliageOpacity173 = tex2DNode124.a;
				

				surfaceDescription.Alpha = vFoliageOpacity173;
				surfaceDescription.AlphaClipThreshold = _MaskClipValue;

				#if _ALPHATEST_ON
					clip(surfaceDescription.Alpha - surfaceDescription.AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				float3 normalWS = IN.normalWS;

				return half4(NormalizeNormalPerPixel(normalWS), 0.0);
			}

			ENDHLSL
		}

		
		Pass
		{
			
            Name "DepthNormalsOnly"
            Tags { "LightMode"="DepthNormalsOnly" }

			ZTest LEqual
			ZWrite On

			HLSLPROGRAM

			#pragma multi_compile_instancing
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _ALPHATEST_ON 1
			#define ASE_SRP_VERSION 120108


			#pragma exclude_renderers glcore gles gles3 
			#pragma vertex vert
			#pragma fragment frag

			#define ATTRIBUTES_NEED_NORMAL
			#define ATTRIBUTES_NEED_TANGENT
			#define ATTRIBUTES_NEED_TEXCOORD1
			#define VARYINGS_NEED_NORMAL_WS
			#define VARYINGS_NEED_TANGENT_WS

			#define SHADERPASS SHADERPASS_DEPTHNORMALSONLY

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			#define ASE_NEEDS_VERT_NORMAL
			#define ASE_NEEDS_VERT_POSITION
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
				float3 normalWS : TEXCOORD0;
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _FoliageColorTop;
			float4 _FoliageColorBottom;
			float2 _WindSwayDirection;
			float _SubsurfaceIntensity;
			float _DirectLightInt;
			float _LightOffset;
			float _IndirectLightningIntensity;
			float _FoliageSize;
			float _GradientFallout;
			float _WindScrollSpeed;
			float _SubsurfaceFadeDistance;
			float _WIndSwayFrequency;
			float _WIndSwayIntensity;
			float _WindOffsetIntensity;
			float _WindJitterSpeed;
			float _WindRustleSize;
			float _GradientOffset;
			float _MaskClipValue;
			#ifdef ASE_TESSELLATION
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _NoiseTexture;
			float varWindRustleScrollSpeed;
			float Float0;
			float varWindSwayIntensity;
			float2 varWindDirection;
			float varWindSwayFrequency;
			sampler2D _FoliageColorMap;


			
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

				float temp_output_18_0_g87 = _WindScrollSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch25_g87 = ( temp_output_18_0_g87 * varWindRustleScrollSpeed );
				#else
				float staticSwitch25_g87 = temp_output_18_0_g87;
				#endif
				float3 ase_worldPos = TransformObjectToWorld( (v.vertex).xyz );
				float2 appendResult4_g87 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 temp_output_7_0_g87 = ( appendResult4_g87 * _WindRustleSize );
				float2 panner9_g87 = ( ( staticSwitch25_g87 * _TimeParameters.x ) * float2( 1,1 ) + temp_output_7_0_g87);
				float temp_output_19_0_g87 = _WindJitterSpeed;
				#ifdef _USEGLOBALWINDSETTINGS_ON
				float staticSwitch26_g87 = ( temp_output_19_0_g87 * Float0 );
				#else
				float staticSwitch26_g87 = temp_output_19_0_g87;
				#endif
				float2 panner13_g87 = ( ( _TimeParameters.x * staticSwitch26_g87 ) * float2( 1,1 ) + ( temp_output_7_0_g87 * float2( 2,2 ) ));
				float4 lerpResult30_g87 = lerp( float4( float3(0,0,0) , 0.0 ) , ( pow( tex2Dlod( _NoiseTexture, float4( panner9_g87, 0, 0.0) ) , 1.0 ) * tex2Dlod( _NoiseTexture, float4( panner13_g87, 0, 0.0) ) ) , _WindOffsetIntensity);
				float temp_output_27_0_g88 = _WIndSwayIntensity;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch33_g88 = ( temp_output_27_0_g88 * varWindSwayIntensity );
				#else
				float staticSwitch33_g88 = temp_output_27_0_g88;
				#endif
				float temp_output_14_0_g88 = ( ( v.vertex.xyz.y * ( staticSwitch33_g88 / 100.0 ) ) + 1.0 );
				float temp_output_16_0_g88 = ( temp_output_14_0_g88 * temp_output_14_0_g88 );
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float2 staticSwitch41_g88 = varWindDirection;
				#else
				float2 staticSwitch41_g88 = _WindSwayDirection;
				#endif
				float2 clampResult10_g88 = clamp( staticSwitch41_g88 , float2( -1,-1 ) , float2( 1,1 ) );
				float4 transform1_g88 = mul(GetObjectToWorldMatrix(),float4( 0,0,0,1 ));
				float4 appendResult3_g88 = (float4(transform1_g88.x , 0.0 , transform1_g88.z , 0.0));
				float dotResult4_g89 = dot( appendResult3_g88.xy , float2( 12.9898,78.233 ) );
				float lerpResult10_g89 = lerp( 1.0 , 1.01 , frac( ( sin( dotResult4_g89 ) * 43758.55 ) ));
				float mulTime9_g88 = _TimeParameters.x * lerpResult10_g89;
				float temp_output_29_0_g88 = _WIndSwayFrequency;
				#ifdef _USESGLOBALWINDSETTINGS_ON
				float staticSwitch34_g88 = ( temp_output_29_0_g88 * varWindSwayFrequency );
				#else
				float staticSwitch34_g88 = temp_output_29_0_g88;
				#endif
				float2 break26_g88 = ( ( ( temp_output_16_0_g88 * temp_output_16_0_g88 ) - temp_output_16_0_g88 ) * ( ( ( staticSwitch41_g88 * float2( 4,4 ) ) + sin( ( ( clampResult10_g88 * mulTime9_g88 ) * staticSwitch34_g88 ) ) ) / float2( 4,4 ) ) );
				float4 appendResult25_g88 = (float4(break26_g88.x , 0.0 , break26_g88.y , 0.0));
				float4 temp_output_246_0 = appendResult25_g88;
				#ifdef _TRUNKMATERIAL_ON
				float4 staticSwitch100 = temp_output_246_0;
				#else
				float4 staticSwitch100 = ( ( float4( v.ase_normal , 0.0 ) * lerpResult30_g87 ) + temp_output_246_0 );
				#endif
				float4 vWind116 = staticSwitch100;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
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
				float3 normalWS = TransformObjectToWorldNormal(v.ase_normal);

				o.clipPos = TransformWorldToHClip(positionWS);
				o.normalWS.xyz =  normalWS;

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
				float2 texCoord236 = IN.ase_texcoord1.xy * appendResult234 + float2( 0,0 );
				float4 tex2DNode124 = tex2D( _FoliageColorMap, texCoord236 );
				float vFoliageOpacity173 = tex2DNode124.a;
				

				surfaceDescription.Alpha = vFoliageOpacity173;
				surfaceDescription.AlphaClipThreshold = _MaskClipValue;

				#if _ALPHATEST_ON
					clip(surfaceDescription.Alpha - surfaceDescription.AlphaClipThreshold);
				#endif

				#ifdef LOD_FADE_CROSSFADE
					LODDitheringTransition( IN.clipPos.xyz, unity_LODFade.x );
				#endif

				float3 normalWS = IN.normalWS;

				return half4(NormalizeNormalPerPixel(normalWS), 0.0);
			}

			ENDHLSL
		}
		
	}
	
	CustomEditor "UnityEditor.ShaderGraphUnlitGUI"
	FallBack "Hidden/Shader Graph/FallbackError"
	
	Fallback Off
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.RangedFloatNode;111;-3366.52,-2044.726;Inherit;False;Property;_GradientFallout;Gradient Fallout;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-3364.521,-2127.726;Inherit;False;Property;_GradientOffset;Gradient Offset;7;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;123;-2704.77,-2184.466;Inherit;True;Property;_FoliageColorMap;Foliage Color Map;2;2;[Header];[SingleLineTexture];Create;True;2;Foliage;.;0;0;False;0;False;None;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.FunctionNode;131;-3076.101,-2118.791;Inherit;False;PA_SF_ObjectGradient;-1;;52;f7566061dd2a41c4bbc5f0e0ea7b5f5b;0;2;8;FLOAT;0;False;9;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;124;-2448.591,-2185.154;Inherit;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Instance;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;115;-2669.975,-2319.941;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;125;-2104.469,-2320.945;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;172;-1890.849,-2326.3;Inherit;False;vFoliageColor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;259;-3522.616,-862.6478;Inherit;False;958.9546;897.2181;;14;312;325;300;283;298;310;323;303;322;324;307;279;297;301;Custom Lighting;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;122;-1209.571,1348.299;Inherit;False;1580.315;688.4131;Wind;12;194;212;116;100;246;77;101;104;102;252;256;257;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;297;-3449.756,-446.9383;Inherit;False;172;vFoliageColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;256;-1021.847,1545.175;Inherit;False;Property;_WindRustleSize;Wind Rustle Size;15;0;Create;True;0;0;0;False;0;False;0.035;0;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;194;-1024.609,1387.139;Inherit;False;Property;_WindScrollSpeed;Wind Scroll Speed;12;0;Create;True;0;0;0;False;0;False;0.05;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-1023.142,1470.882;Inherit;False;Property;_WindOffsetIntensity;Wind Offset Intensity;14;0;Create;True;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-972.6572,1786.634;Inherit;False;Property;_WIndSwayFrequency;WInd Sway Frequency;20;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-958.6573,1705.634;Inherit;False;Property;_WIndSwayIntensity;WInd Sway Intensity;19;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;104;-959.6573,1864.635;Inherit;False;Property;_WindSwayDirection;Wind Sway Direction;18;0;Create;True;0;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.IndirectDiffuseLighting;301;-3448.753,-539.937;Inherit;False;Tangent;1;0;FLOAT3;0,0,1;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;212;-1019.474,1626.56;Inherit;False;Property;_WindJitterSpeed;Wind Jitter Speed;13;0;Create;True;0;0;0;False;0;False;0.05;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;303;-3288.529,-363.8424;Inherit;False;Property;_IndirectLightningIntensity;Indirect Lightning Intensity;23;0;Create;True;0;0;0;False;0;False;1;0;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;257;-710.6141,1493.55;Inherit;False;PA_SF_WindRustleNoise;9;;87;7733c52bc6ce2e94b9c81cb72dee5854;0;4;18;FLOAT;0;False;33;FLOAT;1;False;35;FLOAT;0.035;False;19;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;298;-3418.625,-248.9114;Inherit;False;172;vFoliageColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;279;-3458.255,-766.8471;Inherit;False;172;vFoliageColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;283;-3501.57,-160.0811;Inherit;False;Property;_LightOffset;Light Offset;21;0;Create;True;0;0;0;False;2;Header(Lighting Settings);Space(5);False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;300;-3502.948,-60.73007;Inherit;False;Property;_DirectLightInt;Direct Light Int;22;0;Create;True;0;0;0;False;0;False;1;0;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;307;-3151.009,-466.4042;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;246;-699.9568,1632.734;Inherit;False;PA_SF_WindSway;16;;88;bc8ec8a781a3c384e9042e29b2eae6d5;0;3;27;FLOAT;0;False;29;FLOAT;1;False;30;FLOAT2;1,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.FunctionNode;324;-3151.632,-761.2469;Inherit;False;PA_SF_Subsurface;0;;90;8f5ee1ef24284b9448f8c4a7274f8883;0;2;23;FLOAT4;0,0,0,0;False;24;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;77;-362.2125,1493.299;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;323;-2980.28,-465.283;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;325;-3182.808,-177.1063;Inherit;False;PA_SF_CustomLightning;-1;;91;898d5a8db4cd68548bb7f6d6ea6222d8;0;3;15;FLOAT4;0,0,0,0;False;16;FLOAT;1;False;17;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;310;-2813.299,-469.4492;Inherit;False;vIndirectLightning;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;322;-2812.493,-767.5549;Inherit;False;vSubsurface;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;312;-2907.118,-182.0311;Inherit;False;DirectLight;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;100;-185.6695,1601.949;Inherit;False;Property;_TrunkMaterial;Trunk Material?;13;0;Create;True;0;0;0;False;1;Header(TRUNK);False;0;0;0;True;;Toggle;2;Key0;Key1;Reference;-1;True;True;All;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;116;63.9295,1601.649;Inherit;False;vWind;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;173;-2059.848,-2090.301;Inherit;False;vFoliageOpacity;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;183;934.7533,1017.369;Inherit;False;173;vFoliageOpacity;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;861.2644,1098.013;Inherit;False;Property;_MaskClipValue;Mask Clip Value;3;0;Create;True;0;0;0;False;0;False;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;117;971.1143,1177.033;Inherit;False;116;vWind;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;318;458.9124,1050.601;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;315;-109.8926,1187.443;Inherit;False;322;vSubsurface;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;316;-100.8076,1107.025;Inherit;False;312;DirectLight;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;314;-140.9006,1015.151;Inherit;False;310;vIndirectLightning;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;359;696.9216,886.3589;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;326;48.68359,926.2839;Inherit;False;SRP Additional Light;-1;;92;6c86746ad131a0a408ca599df5f40861;7,6,0,9,0,23,0,27,0,25,0,24,0,26,0;6;2;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;15;FLOAT3;0,0,0;False;14;FLOAT3;1,1,1;False;18;FLOAT;0.5;False;32;FLOAT4;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;317;87.9624,820.736;Inherit;False;172;vFoliageColor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;327;507.6836,887.2839;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;233;-3168.68,-1908.24;Inherit;False;Property;_FoliageSize;Foliage Size;4;0;Create;True;0;0;0;False;0;False;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;235;-2992.766,-1902.639;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;100;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;234;-2858.58,-1909.941;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;236;-2701.017,-1931.832;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;112;-3015.271,-2301.595;Inherit;False;Property;_FoliageColorTop;Foliage Color Top;5;1;[Header];Create;True;0;0;0;False;0;False;1,1,1,0;1,0,0.7909455,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;114;-3026.939,-2483.921;Inherit;False;Property;_FoliageColorBottom;Foliage Color Bottom;6;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,0,0.7909455,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;391;1411.169,889.1141;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;0;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;393;1411.169,889.1141;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=ShadowCaster;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;394;1411.169,889.1141;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;False;False;True;False;False;False;False;0;False;;False;False;False;False;False;False;False;False;False;True;1;False;;False;False;True;1;LightMode=DepthOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;395;1411.169,889.1141;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;396;1411.169,889.1141;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;0;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;397;1411.169,889.1141;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;SceneSelectionPass;0;6;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;398;1411.169,889.1141;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;ScenePickingPass;0;7;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;399;1411.169,889.1141;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthNormals;0;8;DepthNormals;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormalsOnly;False;False;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;400;1411.169,889.1141;Float;False;False;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;1;New Amplify Shader;2992e84f91cbeb14eab234972e07ea9d;True;DepthNormalsOnly;0;9;DepthNormalsOnly;0;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;3;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;False;;True;3;False;;False;True;1;LightMode=DepthNormalsOnly;False;True;9;d3d11;metal;vulkan;xboxone;xboxseries;playstation;ps4;ps5;switch;0;;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;392;1411.169,889.1141;Float;False;True;-1;2;UnityEditor.ShaderGraphUnlitGUI;0;13;Polyart/Dreamscape/URP/Tree Wind Custom Lighting;2992e84f91cbeb14eab234972e07ea9d;True;Forward;0;1;Forward;8;False;False;False;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;2;False;;False;False;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;False;False;False;True;4;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;UniversalMaterialType=Unlit;True;3;True;12;all;0;False;True;1;1;False;;0;False;;1;1;False;;0;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForwardOnly;False;False;0;;0;0;Standard;23;Surface;0;0;  Blend;0;0;Two Sided;0;638099232587446857;Forward Only;0;0;Cast Shadows;1;0;  Use Shadow Threshold;0;0;Receive Shadows;1;0;GPU Instancing;1;0;LOD CrossFade;0;0;Built-in Fog;1;638126632095055901;DOTS Instancing;0;0;Meta Pass;0;0;Extra Pre Pass;0;0;Tessellation;0;0;  Phong;0;0;  Strength;0.5,False,;0;  Type;0;0;  Tess;16,False,;0;  Min;10,False,;0;  Max;25,False,;0;  Edge Length;16,False,;0;  Max Displacement;25,False,;0;Vertex Position,InvertActionOnDeselection;1;0;0;10;False;True;True;True;False;False;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;401;-4557.155,-686.1132;Inherit;False;Property;_SubsurfaceFadeDistance;Subsurface Fade Distance;25;0;Create;True;0;0;0;False;0;False;200;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;402;-3840.689,-776.2373;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;404;-4245.709,-680.3781;Inherit;False;PA_SF_DistanceBlend;-1;;95;35a1c16c00037ed46b6114de6dd42a44;0;2;6;FLOAT;200;False;8;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;296;-4316.761,-869.2956;Inherit;False;Property;_SubsurfaceIntensity;Subsurface Intensity;24;0;Create;True;0;0;0;False;0;False;10;0;0;100;0;1;FLOAT;0
WireConnection;131;8;110;0
WireConnection;131;9;111;0
WireConnection;124;0;123;0
WireConnection;124;1;236;0
WireConnection;115;0;114;0
WireConnection;115;1;112;0
WireConnection;115;2;131;0
WireConnection;125;0;115;0
WireConnection;125;1;124;0
WireConnection;172;0;125;0
WireConnection;257;18;194;0
WireConnection;257;33;252;0
WireConnection;257;35;256;0
WireConnection;257;19;212;0
WireConnection;307;0;301;0
WireConnection;307;1;297;0
WireConnection;246;27;101;0
WireConnection;246;29;102;0
WireConnection;246;30;104;0
WireConnection;324;23;279;0
WireConnection;324;24;402;0
WireConnection;77;0;257;0
WireConnection;77;1;246;0
WireConnection;323;0;307;0
WireConnection;323;1;303;0
WireConnection;325;15;298;0
WireConnection;325;16;283;0
WireConnection;325;17;300;0
WireConnection;310;0;323;0
WireConnection;322;0;324;0
WireConnection;312;0;325;0
WireConnection;100;1;77;0
WireConnection;100;0;246;0
WireConnection;116;0;100;0
WireConnection;173;0;124;4
WireConnection;318;0;314;0
WireConnection;318;1;316;0
WireConnection;318;2;315;0
WireConnection;359;0;327;0
WireConnection;359;1;318;0
WireConnection;327;0;317;0
WireConnection;327;1;326;0
WireConnection;235;0;233;0
WireConnection;234;0;235;0
WireConnection;234;1;235;0
WireConnection;236;0;234;0
WireConnection;392;2;359;0
WireConnection;392;3;183;0
WireConnection;392;4;107;0
WireConnection;392;5;117;0
WireConnection;402;0;296;0
WireConnection;402;2;404;0
WireConnection;404;6;401;0
ASEEND*/
//CHKSM=798E0FEC104DBD55991FDD7C6BC14FA97BBC339E