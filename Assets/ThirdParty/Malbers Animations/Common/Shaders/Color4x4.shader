// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Malbers/Color4x4"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		[ASEBegin][Header(Row 1)]_Color1("Color 1", Color) = (1,0.1544118,0.1544118,0.291)
		_Color2("Color 2", Color) = (1,0.1544118,0.8017241,0.253)
		_Color3("Color 3", Color) = (0.2535501,0.1544118,1,0.541)
		_Color4("Color 4", Color) = (0.1544118,0.5451319,1,0.253)
		[Header(Row 2)]_Color5("Color 5", Color) = (0.9533468,1,0.1544118,0.553)
		_Color6("Color 6", Color) = (0.2720588,0.1294625,0,0.097)
		_Color7("Color 7", Color) = (0.1544118,0.6151115,1,0.178)
		_Color8("Color 8", Color) = (0.4849697,0.5008695,0.5073529,0.078)
		[Header(Row 3)]_Color9("Color 9", Color) = (0.3164301,0,0.7058823,0.134)
		_Color10("Color 10", Color) = (0.362069,0.4411765,0,0.759)
		_Color11("Color 11", Color) = (0.6691177,0.6691177,0.6691177,0.647)
		_Color12("Color 12", Color) = (0.5073529,0.1574544,0,0.128)
		[Header(Row 4)]_Color13("Color 13", Color) = (1,0.5586207,0,0.272)
		_Color14("Color 14", Color) = (0,0.8025862,0.875,0.047)
		_Color15("Color 15", Color) = (1,0,0,0.391)
		_Color16("Color 16", Color) = (0.4080882,0.75,0.4811866,0.134)
		[HDR][Header(Emmision)]_Color15Emmision("Color 15 Emmision", Color) = (0,0,0,1)
		[HDR]_Color16Emmision("Color 16 Emmision", Color) = (0,0,0,1)
		[Header(Smoothness (Alphas))]_Smoothness("Smoothness", Range( 0 , 1)) = 1
		_Metallic("Metallic", Range( 0 , 1)) = 0
		[Header(Gradient)]_Gradient("Gradient", 2D) = "white" {}
		_GradientIntensity("Gradient Intensity", Range( 0 , 1)) = 0.75
		_GradientColor("Gradient Color", Color) = (0,0,0,0)
		_GradientScale("Gradient Scale", Float) = 1
		_GradientOffset("Gradient Offset", Float) = 0
		[ASEEnd]_GradientPower("Gradient Power", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

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
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Opaque" "Queue"="Geometry" }
		Cull Back
		AlphaToMask Off
		HLSLINCLUDE
		#pragma target 2.0

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
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70301

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
			#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
			#pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile _ _SHADOWS_SOFT
			#pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
			
			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_FORWARD

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			#if ASE_SRP_VERSION <= 70108
			#define REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR
			#endif

			#if defined(UNITY_INSTANCING_ENABLED) && defined(_TERRAIN_INSTANCED_PERPIXEL_NORMAL)
			    #define ENABLE_TERRAIN_PERPIXEL_NORMAL
			#endif

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord : TEXCOORD0;
				
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
				float4 ase_texcoord7 : TEXCOORD7;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			CBUFFER_START(UnityPerMaterial)
			float4 _Gradient_ST;
			float4 _Color16Emmision;
			float4 _Color15Emmision;
			float4 _Color16;
			float4 _Color15;
			float4 _Color14;
			float4 _Color13;
			float4 _Color12;
			float4 _Color11;
			float4 _Color10;
			float4 _Color9;
			float4 _Color8;
			float4 _Color7;
			float4 _Color6;
			float4 _Color5;
			float4 _Color4;
			float4 _Color3;
			float4 _Color2;
			float4 _Color1;
			float4 _GradientColor;
			float _GradientPower;
			float _GradientOffset;
			float _GradientScale;
			float _GradientIntensity;
			float _Metallic;
			float _Smoothness;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Gradient;


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord7.xy = v.texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.zw = 0;
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
				float3 positionVS = TransformWorldToView( positionWS );
				float4 positionCS = TransformWorldToHClip( positionWS );

				VertexNormalInputs normalInput = GetVertexNormalInputs( v.ase_normal, v.ase_tangent );

				o.tSpace0 = float4( normalInput.normalWS, positionWS.x);
				o.tSpace1 = float4( normalInput.tangentWS, positionWS.y);
				o.tSpace2 = float4( normalInput.bitangentWS, positionWS.z);

				OUTPUT_LIGHTMAP_UV( v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy );
				OUTPUT_SH( normalInput.normalWS.xyz, o.lightmapUVOrVertexSH.xyz );

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
			
			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 ase_tangent : TANGENT;
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
				o.ase_tangent = v.ase_tangent;
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
				o.ase_tangent = patch[0].ase_tangent * bary.x + patch[1].ase_tangent * bary.y + patch[2].ase_tangent * bary.z;
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

				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
					ShadowCoords = IN.shadowCoord;
				#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
					ShadowCoords = TransformWorldToShadowCoord( WorldPosition );
				#endif
	
				WorldViewDirection = SafeNormalize( WorldViewDirection );

				float2 uv_Gradient = IN.ase_texcoord7.xy * _Gradient_ST.xy + _Gradient_ST.zw;
				float4 clampResult234 = clamp( ( ( tex2D( _Gradient, uv_Gradient ) + _GradientColor ) + ( 1.0 - _GradientIntensity ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_cast_0 = (_GradientPower).xxxx;
				float2 texCoord2_g481 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g481 = 1.0;
				float temp_output_7_0_g481 = 4.0;
				float temp_output_9_0_g481 = 4.0;
				float temp_output_8_0_g481 = 4.0;
				float2 texCoord2_g479 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g479 = 2.0;
				float temp_output_7_0_g479 = 4.0;
				float temp_output_9_0_g479 = 4.0;
				float temp_output_8_0_g479 = 4.0;
				float2 texCoord2_g477 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g477 = 3.0;
				float temp_output_7_0_g477 = 4.0;
				float temp_output_9_0_g477 = 4.0;
				float temp_output_8_0_g477 = 4.0;
				float2 texCoord2_g482 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g482 = 4.0;
				float temp_output_7_0_g482 = 4.0;
				float temp_output_9_0_g482 = 4.0;
				float temp_output_8_0_g482 = 4.0;
				float2 texCoord2_g474 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g474 = 1.0;
				float temp_output_7_0_g474 = 4.0;
				float temp_output_9_0_g474 = 3.0;
				float temp_output_8_0_g474 = 4.0;
				float2 texCoord2_g486 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g486 = 2.0;
				float temp_output_7_0_g486 = 4.0;
				float temp_output_9_0_g486 = 3.0;
				float temp_output_8_0_g486 = 4.0;
				float2 texCoord2_g483 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g483 = 3.0;
				float temp_output_7_0_g483 = 4.0;
				float temp_output_9_0_g483 = 3.0;
				float temp_output_8_0_g483 = 4.0;
				float2 texCoord2_g490 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g490 = 4.0;
				float temp_output_7_0_g490 = 4.0;
				float temp_output_9_0_g490 = 3.0;
				float temp_output_8_0_g490 = 4.0;
				float2 texCoord2_g487 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g487 = 1.0;
				float temp_output_7_0_g487 = 4.0;
				float temp_output_9_0_g487 = 2.0;
				float temp_output_8_0_g487 = 4.0;
				float2 texCoord2_g478 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g478 = 2.0;
				float temp_output_7_0_g478 = 4.0;
				float temp_output_9_0_g478 = 2.0;
				float temp_output_8_0_g478 = 4.0;
				float2 texCoord2_g484 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g484 = 3.0;
				float temp_output_7_0_g484 = 4.0;
				float temp_output_9_0_g484 = 2.0;
				float temp_output_8_0_g484 = 4.0;
				float2 texCoord2_g488 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g488 = 4.0;
				float temp_output_7_0_g488 = 4.0;
				float temp_output_9_0_g488 = 2.0;
				float temp_output_8_0_g488 = 4.0;
				float2 texCoord2_g491 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g491 = 1.0;
				float temp_output_7_0_g491 = 4.0;
				float temp_output_9_0_g491 = 1.0;
				float temp_output_8_0_g491 = 4.0;
				float2 texCoord2_g485 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g485 = 2.0;
				float temp_output_7_0_g485 = 4.0;
				float temp_output_9_0_g485 = 1.0;
				float temp_output_8_0_g485 = 4.0;
				float2 texCoord2_g480 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g480 = 3.0;
				float temp_output_7_0_g480 = 4.0;
				float temp_output_9_0_g480 = 1.0;
				float temp_output_8_0_g480 = 4.0;
				float2 texCoord2_g489 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g489 = 4.0;
				float temp_output_7_0_g489 = 4.0;
				float temp_output_9_0_g489 = 1.0;
				float temp_output_8_0_g489 = 4.0;
				float4 temp_output_155_0 = ( ( ( _Color1 * ( ( ( 1.0 - step( texCoord2_g481.x , ( ( temp_output_3_0_g481 - 1.0 ) / temp_output_7_0_g481 ) ) ) * ( step( texCoord2_g481.x , ( temp_output_3_0_g481 / temp_output_7_0_g481 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g481.y , ( ( temp_output_9_0_g481 - 1.0 ) / temp_output_8_0_g481 ) ) ) * ( step( texCoord2_g481.y , ( temp_output_9_0_g481 / temp_output_8_0_g481 ) ) * 1.0 ) ) ) ) + ( _Color2 * ( ( ( 1.0 - step( texCoord2_g479.x , ( ( temp_output_3_0_g479 - 1.0 ) / temp_output_7_0_g479 ) ) ) * ( step( texCoord2_g479.x , ( temp_output_3_0_g479 / temp_output_7_0_g479 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g479.y , ( ( temp_output_9_0_g479 - 1.0 ) / temp_output_8_0_g479 ) ) ) * ( step( texCoord2_g479.y , ( temp_output_9_0_g479 / temp_output_8_0_g479 ) ) * 1.0 ) ) ) ) + ( _Color3 * ( ( ( 1.0 - step( texCoord2_g477.x , ( ( temp_output_3_0_g477 - 1.0 ) / temp_output_7_0_g477 ) ) ) * ( step( texCoord2_g477.x , ( temp_output_3_0_g477 / temp_output_7_0_g477 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g477.y , ( ( temp_output_9_0_g477 - 1.0 ) / temp_output_8_0_g477 ) ) ) * ( step( texCoord2_g477.y , ( temp_output_9_0_g477 / temp_output_8_0_g477 ) ) * 1.0 ) ) ) ) + ( _Color4 * ( ( ( 1.0 - step( texCoord2_g482.x , ( ( temp_output_3_0_g482 - 1.0 ) / temp_output_7_0_g482 ) ) ) * ( step( texCoord2_g482.x , ( temp_output_3_0_g482 / temp_output_7_0_g482 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g482.y , ( ( temp_output_9_0_g482 - 1.0 ) / temp_output_8_0_g482 ) ) ) * ( step( texCoord2_g482.y , ( temp_output_9_0_g482 / temp_output_8_0_g482 ) ) * 1.0 ) ) ) ) ) + ( ( _Color5 * ( ( ( 1.0 - step( texCoord2_g474.x , ( ( temp_output_3_0_g474 - 1.0 ) / temp_output_7_0_g474 ) ) ) * ( step( texCoord2_g474.x , ( temp_output_3_0_g474 / temp_output_7_0_g474 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g474.y , ( ( temp_output_9_0_g474 - 1.0 ) / temp_output_8_0_g474 ) ) ) * ( step( texCoord2_g474.y , ( temp_output_9_0_g474 / temp_output_8_0_g474 ) ) * 1.0 ) ) ) ) + ( _Color6 * ( ( ( 1.0 - step( texCoord2_g486.x , ( ( temp_output_3_0_g486 - 1.0 ) / temp_output_7_0_g486 ) ) ) * ( step( texCoord2_g486.x , ( temp_output_3_0_g486 / temp_output_7_0_g486 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g486.y , ( ( temp_output_9_0_g486 - 1.0 ) / temp_output_8_0_g486 ) ) ) * ( step( texCoord2_g486.y , ( temp_output_9_0_g486 / temp_output_8_0_g486 ) ) * 1.0 ) ) ) ) + ( _Color7 * ( ( ( 1.0 - step( texCoord2_g483.x , ( ( temp_output_3_0_g483 - 1.0 ) / temp_output_7_0_g483 ) ) ) * ( step( texCoord2_g483.x , ( temp_output_3_0_g483 / temp_output_7_0_g483 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g483.y , ( ( temp_output_9_0_g483 - 1.0 ) / temp_output_8_0_g483 ) ) ) * ( step( texCoord2_g483.y , ( temp_output_9_0_g483 / temp_output_8_0_g483 ) ) * 1.0 ) ) ) ) + ( _Color8 * ( ( ( 1.0 - step( texCoord2_g490.x , ( ( temp_output_3_0_g490 - 1.0 ) / temp_output_7_0_g490 ) ) ) * ( step( texCoord2_g490.x , ( temp_output_3_0_g490 / temp_output_7_0_g490 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g490.y , ( ( temp_output_9_0_g490 - 1.0 ) / temp_output_8_0_g490 ) ) ) * ( step( texCoord2_g490.y , ( temp_output_9_0_g490 / temp_output_8_0_g490 ) ) * 1.0 ) ) ) ) ) + ( ( _Color9 * ( ( ( 1.0 - step( texCoord2_g487.x , ( ( temp_output_3_0_g487 - 1.0 ) / temp_output_7_0_g487 ) ) ) * ( step( texCoord2_g487.x , ( temp_output_3_0_g487 / temp_output_7_0_g487 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g487.y , ( ( temp_output_9_0_g487 - 1.0 ) / temp_output_8_0_g487 ) ) ) * ( step( texCoord2_g487.y , ( temp_output_9_0_g487 / temp_output_8_0_g487 ) ) * 1.0 ) ) ) ) + ( _Color10 * ( ( ( 1.0 - step( texCoord2_g478.x , ( ( temp_output_3_0_g478 - 1.0 ) / temp_output_7_0_g478 ) ) ) * ( step( texCoord2_g478.x , ( temp_output_3_0_g478 / temp_output_7_0_g478 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g478.y , ( ( temp_output_9_0_g478 - 1.0 ) / temp_output_8_0_g478 ) ) ) * ( step( texCoord2_g478.y , ( temp_output_9_0_g478 / temp_output_8_0_g478 ) ) * 1.0 ) ) ) ) + ( _Color11 * ( ( ( 1.0 - step( texCoord2_g484.x , ( ( temp_output_3_0_g484 - 1.0 ) / temp_output_7_0_g484 ) ) ) * ( step( texCoord2_g484.x , ( temp_output_3_0_g484 / temp_output_7_0_g484 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g484.y , ( ( temp_output_9_0_g484 - 1.0 ) / temp_output_8_0_g484 ) ) ) * ( step( texCoord2_g484.y , ( temp_output_9_0_g484 / temp_output_8_0_g484 ) ) * 1.0 ) ) ) ) + ( _Color12 * ( ( ( 1.0 - step( texCoord2_g488.x , ( ( temp_output_3_0_g488 - 1.0 ) / temp_output_7_0_g488 ) ) ) * ( step( texCoord2_g488.x , ( temp_output_3_0_g488 / temp_output_7_0_g488 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g488.y , ( ( temp_output_9_0_g488 - 1.0 ) / temp_output_8_0_g488 ) ) ) * ( step( texCoord2_g488.y , ( temp_output_9_0_g488 / temp_output_8_0_g488 ) ) * 1.0 ) ) ) ) ) + ( ( _Color13 * ( ( ( 1.0 - step( texCoord2_g491.x , ( ( temp_output_3_0_g491 - 1.0 ) / temp_output_7_0_g491 ) ) ) * ( step( texCoord2_g491.x , ( temp_output_3_0_g491 / temp_output_7_0_g491 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g491.y , ( ( temp_output_9_0_g491 - 1.0 ) / temp_output_8_0_g491 ) ) ) * ( step( texCoord2_g491.y , ( temp_output_9_0_g491 / temp_output_8_0_g491 ) ) * 1.0 ) ) ) ) + ( _Color14 * ( ( ( 1.0 - step( texCoord2_g485.x , ( ( temp_output_3_0_g485 - 1.0 ) / temp_output_7_0_g485 ) ) ) * ( step( texCoord2_g485.x , ( temp_output_3_0_g485 / temp_output_7_0_g485 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g485.y , ( ( temp_output_9_0_g485 - 1.0 ) / temp_output_8_0_g485 ) ) ) * ( step( texCoord2_g485.y , ( temp_output_9_0_g485 / temp_output_8_0_g485 ) ) * 1.0 ) ) ) ) + ( _Color15 * ( ( ( 1.0 - step( texCoord2_g480.x , ( ( temp_output_3_0_g480 - 1.0 ) / temp_output_7_0_g480 ) ) ) * ( step( texCoord2_g480.x , ( temp_output_3_0_g480 / temp_output_7_0_g480 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g480.y , ( ( temp_output_9_0_g480 - 1.0 ) / temp_output_8_0_g480 ) ) ) * ( step( texCoord2_g480.y , ( temp_output_9_0_g480 / temp_output_8_0_g480 ) ) * 1.0 ) ) ) ) + ( _Color16 * ( ( ( 1.0 - step( texCoord2_g489.x , ( ( temp_output_3_0_g489 - 1.0 ) / temp_output_7_0_g489 ) ) ) * ( step( texCoord2_g489.x , ( temp_output_3_0_g489 / temp_output_7_0_g489 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g489.y , ( ( temp_output_9_0_g489 - 1.0 ) / temp_output_8_0_g489 ) ) ) * ( step( texCoord2_g489.y , ( temp_output_9_0_g489 / temp_output_8_0_g489 ) ) * 1.0 ) ) ) ) ) );
				float4 temp_output_236_0 = ( pow( (clampResult234*_GradientScale + _GradientOffset) , temp_cast_0 ) * temp_output_155_0 );
				
				float2 texCoord2_g492 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g492 = 3.0;
				float temp_output_7_0_g492 = 4.0;
				float temp_output_9_0_g492 = 1.0;
				float temp_output_8_0_g492 = 4.0;
				float2 texCoord2_g493 = IN.ase_texcoord7.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g493 = 4.0;
				float temp_output_7_0_g493 = 4.0;
				float temp_output_9_0_g493 = 1.0;
				float temp_output_8_0_g493 = 4.0;
				
				float3 Albedo = temp_output_236_0.rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Emission = ( ( _Color15Emmision * ( ( ( 1.0 - step( texCoord2_g492.x , ( ( temp_output_3_0_g492 - 1.0 ) / temp_output_7_0_g492 ) ) ) * ( step( texCoord2_g492.x , ( temp_output_3_0_g492 / temp_output_7_0_g492 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g492.y , ( ( temp_output_9_0_g492 - 1.0 ) / temp_output_8_0_g492 ) ) ) * ( step( texCoord2_g492.y , ( temp_output_9_0_g492 / temp_output_8_0_g492 ) ) * 1.0 ) ) ) ) + ( _Color16Emmision * ( ( ( 1.0 - step( texCoord2_g493.x , ( ( temp_output_3_0_g493 - 1.0 ) / temp_output_7_0_g493 ) ) ) * ( step( texCoord2_g493.x , ( temp_output_3_0_g493 / temp_output_7_0_g493 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g493.y , ( ( temp_output_9_0_g493 - 1.0 ) / temp_output_8_0_g493 ) ) ) * ( step( texCoord2_g493.y , ( temp_output_9_0_g493 / temp_output_8_0_g493 ) ) * 1.0 ) ) ) ) ).rgb;
				float3 Specular = 0.5;
				float Metallic = _Metallic;
				float Smoothness = ( (temp_output_155_0).a * _Smoothness );
				float Occlusion = 1;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
				float AlphaClipThresholdShadow = 0.5;
				float3 BakedGI = 0;
				float3 RefractionColor = 1;
				float RefractionIndex = 1;
				float3 Transmission = 1;
				float3 Translucency = 1;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				InputData inputData;
				inputData.positionWS = WorldPosition;
				inputData.viewDirectionWS = WorldViewDirection;
				inputData.shadowCoord = ShadowCoords;

				#ifdef _NORMALMAP
					#if _NORMAL_DROPOFF_TS
					inputData.normalWS = TransformTangentToWorld(Normal, half3x3( WorldTangent, WorldBiTangent, WorldNormal ));
					#elif _NORMAL_DROPOFF_OS
					inputData.normalWS = TransformObjectToWorldNormal(Normal);
					#elif _NORMAL_DROPOFF_WS
					inputData.normalWS = Normal;
					#endif
					inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
				#else
					inputData.normalWS = WorldNormal;
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

				inputData.bakedGI = SAMPLE_GI( IN.lightmapUVOrVertexSH.xy, SH, inputData.normalWS );
				#ifdef _ASE_BAKEDGI
					inputData.bakedGI = BakedGI;
				#endif
				half4 color = UniversalFragmentPBR(
					inputData, 
					Albedo, 
					Metallic, 
					Specular, 
					Smoothness, 
					Occlusion, 
					Emission, 
					Alpha);

				#ifdef _TRANSMISSION_ASE
				{
					float shadow = _TransmissionShadow;

					Light mainLight = GetMainLight( inputData.shadowCoord );
					float3 mainAtten = mainLight.color * mainLight.distanceAttenuation;
					mainAtten = lerp( mainAtten, mainAtten * mainLight.shadowAttenuation, shadow );
					half3 mainTransmission = max(0 , -dot(inputData.normalWS, mainLight.direction)) * mainAtten * Transmission;
					color.rgb += Albedo * mainTransmission;

					#ifdef _ADDITIONAL_LIGHTS
						int transPixelLightCount = GetAdditionalLightsCount();
						for (int i = 0; i < transPixelLightCount; ++i)
						{
							Light light = GetAdditionalLight(i, inputData.positionWS);
							float3 atten = light.color * light.distanceAttenuation;
							atten = lerp( atten, atten * light.shadowAttenuation, shadow );

							half3 transmission = max(0 , -dot(inputData.normalWS, light.direction)) * atten * Transmission;
							color.rgb += Albedo * transmission;
						}
					#endif
				}
				#endif

				#ifdef _TRANSLUCENCY_ASE
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
					color.rgb += Albedo * mainTranslucency * strength;

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
							color.rgb += Albedo * translucency * strength;
						}
					#endif
				}
				#endif

				#ifdef _REFRACTION_ASE
					float4 projScreenPos = ScreenPos / ScreenPos.w;
					float3 refractionOffset = ( RefractionIndex - 1.0 ) * mul( UNITY_MATRIX_V, WorldNormal ).xyz * ( 1.0 - dot( WorldNormal, WorldViewDirection ) );
					projScreenPos.xy += refractionOffset.xy;
					float3 refraction = SHADERGRAPH_SAMPLE_SCENE_COLOR( projScreenPos ) * RefractionColor;
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

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70301

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_SHADOWCASTER

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
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
			float4 _Gradient_ST;
			float4 _Color16Emmision;
			float4 _Color15Emmision;
			float4 _Color16;
			float4 _Color15;
			float4 _Color14;
			float4 _Color13;
			float4 _Color12;
			float4 _Color11;
			float4 _Color10;
			float4 _Color9;
			float4 _Color8;
			float4 _Color7;
			float4 _Color6;
			float4 _Color5;
			float4 _Color4;
			float4 _Color3;
			float4 _Color2;
			float4 _Color1;
			float4 _GradientColor;
			float _GradientPower;
			float _GradientOffset;
			float _GradientScale;
			float _GradientIntensity;
			float _Metallic;
			float _Smoothness;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			
			float3 _LightDirection;

			VertexOutput VertexFunction( VertexInput v )
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				
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
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif
				float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

				float4 clipPos = TransformWorldToHClip( ApplyShadowBias( positionWS, normalWS, _LightDirection ) );

				#if UNITY_REVERSED_Z
					clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
				#else
					clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
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

			#if defined(TESSELLATION_ON)
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

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;
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
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70301

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_DEPTHONLY

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
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
			float4 _Gradient_ST;
			float4 _Color16Emmision;
			float4 _Color15Emmision;
			float4 _Color16;
			float4 _Color15;
			float4 _Color14;
			float4 _Color13;
			float4 _Color12;
			float4 _Color11;
			float4 _Color10;
			float4 _Color9;
			float4 _Color8;
			float4 _Color7;
			float4 _Color6;
			float4 _Color5;
			float4 _Color4;
			float4 _Color3;
			float4 _Color2;
			float4 _Color1;
			float4 _GradientColor;
			float _GradientPower;
			float _GradientOffset;
			float _GradientScale;
			float _GradientIntensity;
			float _Metallic;
			float _Smoothness;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			

			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
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

			#if defined(TESSELLATION_ON)
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

				
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

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
			
			Name "Meta"
			Tags { "LightMode"="Meta" }

			Cull Off

			HLSLPROGRAM
			#define _NORMAL_DROPOFF_TS 1
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70301

			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_META

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			

			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

			struct VertexInput
			{
				float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
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
			float4 _Gradient_ST;
			float4 _Color16Emmision;
			float4 _Color15Emmision;
			float4 _Color16;
			float4 _Color15;
			float4 _Color14;
			float4 _Color13;
			float4 _Color12;
			float4 _Color11;
			float4 _Color10;
			float4 _Color9;
			float4 _Color8;
			float4 _Color7;
			float4 _Color6;
			float4 _Color5;
			float4 _Color4;
			float4 _Color3;
			float4 _Color2;
			float4 _Color1;
			float4 _GradientColor;
			float _GradientPower;
			float _GradientOffset;
			float _GradientScale;
			float _GradientIntensity;
			float _Metallic;
			float _Smoothness;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Gradient;


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				
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
				#if defined(ASE_NEEDS_FRAG_WORLD_POSITION)
				o.worldPos = positionWS;
				#endif

				o.clipPos = MetaVertexPosition( v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST, unity_DynamicLightmapST );
				#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR) && defined(ASE_NEEDS_FRAG_SHADOWCOORDS)
					VertexPositionInputs vertexInput = (VertexPositionInputs)0;
					vertexInput.positionWS = positionWS;
					vertexInput.positionCS = o.clipPos;
					o.shadowCoord = GetShadowCoord( vertexInput );
				#endif
				return o;
			}

			#if defined(TESSELLATION_ON)
			struct VertexControl
			{
				float4 vertex : INTERNALTESSPOS;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 texcoord2 : TEXCOORD2;
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
				o.texcoord1 = v.texcoord1;
				o.texcoord2 = v.texcoord2;
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
				o.texcoord1 = patch[0].texcoord1 * bary.x + patch[1].texcoord1 * bary.y + patch[2].texcoord1 * bary.z;
				o.texcoord2 = patch[0].texcoord2 * bary.x + patch[1].texcoord2 * bary.y + patch[2].texcoord2 * bary.z;
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

				float2 uv_Gradient = IN.ase_texcoord2.xy * _Gradient_ST.xy + _Gradient_ST.zw;
				float4 clampResult234 = clamp( ( ( tex2D( _Gradient, uv_Gradient ) + _GradientColor ) + ( 1.0 - _GradientIntensity ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_cast_0 = (_GradientPower).xxxx;
				float2 texCoord2_g481 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g481 = 1.0;
				float temp_output_7_0_g481 = 4.0;
				float temp_output_9_0_g481 = 4.0;
				float temp_output_8_0_g481 = 4.0;
				float2 texCoord2_g479 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g479 = 2.0;
				float temp_output_7_0_g479 = 4.0;
				float temp_output_9_0_g479 = 4.0;
				float temp_output_8_0_g479 = 4.0;
				float2 texCoord2_g477 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g477 = 3.0;
				float temp_output_7_0_g477 = 4.0;
				float temp_output_9_0_g477 = 4.0;
				float temp_output_8_0_g477 = 4.0;
				float2 texCoord2_g482 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g482 = 4.0;
				float temp_output_7_0_g482 = 4.0;
				float temp_output_9_0_g482 = 4.0;
				float temp_output_8_0_g482 = 4.0;
				float2 texCoord2_g474 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g474 = 1.0;
				float temp_output_7_0_g474 = 4.0;
				float temp_output_9_0_g474 = 3.0;
				float temp_output_8_0_g474 = 4.0;
				float2 texCoord2_g486 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g486 = 2.0;
				float temp_output_7_0_g486 = 4.0;
				float temp_output_9_0_g486 = 3.0;
				float temp_output_8_0_g486 = 4.0;
				float2 texCoord2_g483 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g483 = 3.0;
				float temp_output_7_0_g483 = 4.0;
				float temp_output_9_0_g483 = 3.0;
				float temp_output_8_0_g483 = 4.0;
				float2 texCoord2_g490 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g490 = 4.0;
				float temp_output_7_0_g490 = 4.0;
				float temp_output_9_0_g490 = 3.0;
				float temp_output_8_0_g490 = 4.0;
				float2 texCoord2_g487 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g487 = 1.0;
				float temp_output_7_0_g487 = 4.0;
				float temp_output_9_0_g487 = 2.0;
				float temp_output_8_0_g487 = 4.0;
				float2 texCoord2_g478 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g478 = 2.0;
				float temp_output_7_0_g478 = 4.0;
				float temp_output_9_0_g478 = 2.0;
				float temp_output_8_0_g478 = 4.0;
				float2 texCoord2_g484 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g484 = 3.0;
				float temp_output_7_0_g484 = 4.0;
				float temp_output_9_0_g484 = 2.0;
				float temp_output_8_0_g484 = 4.0;
				float2 texCoord2_g488 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g488 = 4.0;
				float temp_output_7_0_g488 = 4.0;
				float temp_output_9_0_g488 = 2.0;
				float temp_output_8_0_g488 = 4.0;
				float2 texCoord2_g491 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g491 = 1.0;
				float temp_output_7_0_g491 = 4.0;
				float temp_output_9_0_g491 = 1.0;
				float temp_output_8_0_g491 = 4.0;
				float2 texCoord2_g485 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g485 = 2.0;
				float temp_output_7_0_g485 = 4.0;
				float temp_output_9_0_g485 = 1.0;
				float temp_output_8_0_g485 = 4.0;
				float2 texCoord2_g480 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g480 = 3.0;
				float temp_output_7_0_g480 = 4.0;
				float temp_output_9_0_g480 = 1.0;
				float temp_output_8_0_g480 = 4.0;
				float2 texCoord2_g489 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g489 = 4.0;
				float temp_output_7_0_g489 = 4.0;
				float temp_output_9_0_g489 = 1.0;
				float temp_output_8_0_g489 = 4.0;
				float4 temp_output_155_0 = ( ( ( _Color1 * ( ( ( 1.0 - step( texCoord2_g481.x , ( ( temp_output_3_0_g481 - 1.0 ) / temp_output_7_0_g481 ) ) ) * ( step( texCoord2_g481.x , ( temp_output_3_0_g481 / temp_output_7_0_g481 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g481.y , ( ( temp_output_9_0_g481 - 1.0 ) / temp_output_8_0_g481 ) ) ) * ( step( texCoord2_g481.y , ( temp_output_9_0_g481 / temp_output_8_0_g481 ) ) * 1.0 ) ) ) ) + ( _Color2 * ( ( ( 1.0 - step( texCoord2_g479.x , ( ( temp_output_3_0_g479 - 1.0 ) / temp_output_7_0_g479 ) ) ) * ( step( texCoord2_g479.x , ( temp_output_3_0_g479 / temp_output_7_0_g479 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g479.y , ( ( temp_output_9_0_g479 - 1.0 ) / temp_output_8_0_g479 ) ) ) * ( step( texCoord2_g479.y , ( temp_output_9_0_g479 / temp_output_8_0_g479 ) ) * 1.0 ) ) ) ) + ( _Color3 * ( ( ( 1.0 - step( texCoord2_g477.x , ( ( temp_output_3_0_g477 - 1.0 ) / temp_output_7_0_g477 ) ) ) * ( step( texCoord2_g477.x , ( temp_output_3_0_g477 / temp_output_7_0_g477 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g477.y , ( ( temp_output_9_0_g477 - 1.0 ) / temp_output_8_0_g477 ) ) ) * ( step( texCoord2_g477.y , ( temp_output_9_0_g477 / temp_output_8_0_g477 ) ) * 1.0 ) ) ) ) + ( _Color4 * ( ( ( 1.0 - step( texCoord2_g482.x , ( ( temp_output_3_0_g482 - 1.0 ) / temp_output_7_0_g482 ) ) ) * ( step( texCoord2_g482.x , ( temp_output_3_0_g482 / temp_output_7_0_g482 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g482.y , ( ( temp_output_9_0_g482 - 1.0 ) / temp_output_8_0_g482 ) ) ) * ( step( texCoord2_g482.y , ( temp_output_9_0_g482 / temp_output_8_0_g482 ) ) * 1.0 ) ) ) ) ) + ( ( _Color5 * ( ( ( 1.0 - step( texCoord2_g474.x , ( ( temp_output_3_0_g474 - 1.0 ) / temp_output_7_0_g474 ) ) ) * ( step( texCoord2_g474.x , ( temp_output_3_0_g474 / temp_output_7_0_g474 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g474.y , ( ( temp_output_9_0_g474 - 1.0 ) / temp_output_8_0_g474 ) ) ) * ( step( texCoord2_g474.y , ( temp_output_9_0_g474 / temp_output_8_0_g474 ) ) * 1.0 ) ) ) ) + ( _Color6 * ( ( ( 1.0 - step( texCoord2_g486.x , ( ( temp_output_3_0_g486 - 1.0 ) / temp_output_7_0_g486 ) ) ) * ( step( texCoord2_g486.x , ( temp_output_3_0_g486 / temp_output_7_0_g486 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g486.y , ( ( temp_output_9_0_g486 - 1.0 ) / temp_output_8_0_g486 ) ) ) * ( step( texCoord2_g486.y , ( temp_output_9_0_g486 / temp_output_8_0_g486 ) ) * 1.0 ) ) ) ) + ( _Color7 * ( ( ( 1.0 - step( texCoord2_g483.x , ( ( temp_output_3_0_g483 - 1.0 ) / temp_output_7_0_g483 ) ) ) * ( step( texCoord2_g483.x , ( temp_output_3_0_g483 / temp_output_7_0_g483 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g483.y , ( ( temp_output_9_0_g483 - 1.0 ) / temp_output_8_0_g483 ) ) ) * ( step( texCoord2_g483.y , ( temp_output_9_0_g483 / temp_output_8_0_g483 ) ) * 1.0 ) ) ) ) + ( _Color8 * ( ( ( 1.0 - step( texCoord2_g490.x , ( ( temp_output_3_0_g490 - 1.0 ) / temp_output_7_0_g490 ) ) ) * ( step( texCoord2_g490.x , ( temp_output_3_0_g490 / temp_output_7_0_g490 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g490.y , ( ( temp_output_9_0_g490 - 1.0 ) / temp_output_8_0_g490 ) ) ) * ( step( texCoord2_g490.y , ( temp_output_9_0_g490 / temp_output_8_0_g490 ) ) * 1.0 ) ) ) ) ) + ( ( _Color9 * ( ( ( 1.0 - step( texCoord2_g487.x , ( ( temp_output_3_0_g487 - 1.0 ) / temp_output_7_0_g487 ) ) ) * ( step( texCoord2_g487.x , ( temp_output_3_0_g487 / temp_output_7_0_g487 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g487.y , ( ( temp_output_9_0_g487 - 1.0 ) / temp_output_8_0_g487 ) ) ) * ( step( texCoord2_g487.y , ( temp_output_9_0_g487 / temp_output_8_0_g487 ) ) * 1.0 ) ) ) ) + ( _Color10 * ( ( ( 1.0 - step( texCoord2_g478.x , ( ( temp_output_3_0_g478 - 1.0 ) / temp_output_7_0_g478 ) ) ) * ( step( texCoord2_g478.x , ( temp_output_3_0_g478 / temp_output_7_0_g478 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g478.y , ( ( temp_output_9_0_g478 - 1.0 ) / temp_output_8_0_g478 ) ) ) * ( step( texCoord2_g478.y , ( temp_output_9_0_g478 / temp_output_8_0_g478 ) ) * 1.0 ) ) ) ) + ( _Color11 * ( ( ( 1.0 - step( texCoord2_g484.x , ( ( temp_output_3_0_g484 - 1.0 ) / temp_output_7_0_g484 ) ) ) * ( step( texCoord2_g484.x , ( temp_output_3_0_g484 / temp_output_7_0_g484 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g484.y , ( ( temp_output_9_0_g484 - 1.0 ) / temp_output_8_0_g484 ) ) ) * ( step( texCoord2_g484.y , ( temp_output_9_0_g484 / temp_output_8_0_g484 ) ) * 1.0 ) ) ) ) + ( _Color12 * ( ( ( 1.0 - step( texCoord2_g488.x , ( ( temp_output_3_0_g488 - 1.0 ) / temp_output_7_0_g488 ) ) ) * ( step( texCoord2_g488.x , ( temp_output_3_0_g488 / temp_output_7_0_g488 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g488.y , ( ( temp_output_9_0_g488 - 1.0 ) / temp_output_8_0_g488 ) ) ) * ( step( texCoord2_g488.y , ( temp_output_9_0_g488 / temp_output_8_0_g488 ) ) * 1.0 ) ) ) ) ) + ( ( _Color13 * ( ( ( 1.0 - step( texCoord2_g491.x , ( ( temp_output_3_0_g491 - 1.0 ) / temp_output_7_0_g491 ) ) ) * ( step( texCoord2_g491.x , ( temp_output_3_0_g491 / temp_output_7_0_g491 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g491.y , ( ( temp_output_9_0_g491 - 1.0 ) / temp_output_8_0_g491 ) ) ) * ( step( texCoord2_g491.y , ( temp_output_9_0_g491 / temp_output_8_0_g491 ) ) * 1.0 ) ) ) ) + ( _Color14 * ( ( ( 1.0 - step( texCoord2_g485.x , ( ( temp_output_3_0_g485 - 1.0 ) / temp_output_7_0_g485 ) ) ) * ( step( texCoord2_g485.x , ( temp_output_3_0_g485 / temp_output_7_0_g485 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g485.y , ( ( temp_output_9_0_g485 - 1.0 ) / temp_output_8_0_g485 ) ) ) * ( step( texCoord2_g485.y , ( temp_output_9_0_g485 / temp_output_8_0_g485 ) ) * 1.0 ) ) ) ) + ( _Color15 * ( ( ( 1.0 - step( texCoord2_g480.x , ( ( temp_output_3_0_g480 - 1.0 ) / temp_output_7_0_g480 ) ) ) * ( step( texCoord2_g480.x , ( temp_output_3_0_g480 / temp_output_7_0_g480 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g480.y , ( ( temp_output_9_0_g480 - 1.0 ) / temp_output_8_0_g480 ) ) ) * ( step( texCoord2_g480.y , ( temp_output_9_0_g480 / temp_output_8_0_g480 ) ) * 1.0 ) ) ) ) + ( _Color16 * ( ( ( 1.0 - step( texCoord2_g489.x , ( ( temp_output_3_0_g489 - 1.0 ) / temp_output_7_0_g489 ) ) ) * ( step( texCoord2_g489.x , ( temp_output_3_0_g489 / temp_output_7_0_g489 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g489.y , ( ( temp_output_9_0_g489 - 1.0 ) / temp_output_8_0_g489 ) ) ) * ( step( texCoord2_g489.y , ( temp_output_9_0_g489 / temp_output_8_0_g489 ) ) * 1.0 ) ) ) ) ) );
				float4 temp_output_236_0 = ( pow( (clampResult234*_GradientScale + _GradientOffset) , temp_cast_0 ) * temp_output_155_0 );
				
				float2 texCoord2_g492 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g492 = 3.0;
				float temp_output_7_0_g492 = 4.0;
				float temp_output_9_0_g492 = 1.0;
				float temp_output_8_0_g492 = 4.0;
				float2 texCoord2_g493 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g493 = 4.0;
				float temp_output_7_0_g493 = 4.0;
				float temp_output_9_0_g493 = 1.0;
				float temp_output_8_0_g493 = 4.0;
				
				
				float3 Albedo = temp_output_236_0.rgb;
				float3 Emission = ( ( _Color15Emmision * ( ( ( 1.0 - step( texCoord2_g492.x , ( ( temp_output_3_0_g492 - 1.0 ) / temp_output_7_0_g492 ) ) ) * ( step( texCoord2_g492.x , ( temp_output_3_0_g492 / temp_output_7_0_g492 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g492.y , ( ( temp_output_9_0_g492 - 1.0 ) / temp_output_8_0_g492 ) ) ) * ( step( texCoord2_g492.y , ( temp_output_9_0_g492 / temp_output_8_0_g492 ) ) * 1.0 ) ) ) ) + ( _Color16Emmision * ( ( ( 1.0 - step( texCoord2_g493.x , ( ( temp_output_3_0_g493 - 1.0 ) / temp_output_7_0_g493 ) ) ) * ( step( texCoord2_g493.x , ( temp_output_3_0_g493 / temp_output_7_0_g493 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g493.y , ( ( temp_output_9_0_g493 - 1.0 ) / temp_output_8_0_g493 ) ) ) * ( step( texCoord2_g493.y , ( temp_output_9_0_g493 / temp_output_8_0_g493 ) ) * 1.0 ) ) ) ) ).rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				MetaInput metaInput = (MetaInput)0;
				metaInput.Albedo = Albedo;
				metaInput.Emission = Emission;
				
				return MetaFragment(metaInput);
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
			#pragma multi_compile_instancing
			#pragma multi_compile _ LOD_FADE_CROSSFADE
			#pragma multi_compile_fog
			#define ASE_FOG 1
			#define _EMISSION
			#define ASE_SRP_VERSION 70301

			#pragma enable_d3d11_debug_symbols
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers d3d11_9x

			#pragma vertex vert
			#pragma fragment frag

			#define SHADERPASS_2D

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			
			

			#pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

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
			float4 _Gradient_ST;
			float4 _Color16Emmision;
			float4 _Color15Emmision;
			float4 _Color16;
			float4 _Color15;
			float4 _Color14;
			float4 _Color13;
			float4 _Color12;
			float4 _Color11;
			float4 _Color10;
			float4 _Color9;
			float4 _Color8;
			float4 _Color7;
			float4 _Color6;
			float4 _Color5;
			float4 _Color4;
			float4 _Color3;
			float4 _Color2;
			float4 _Color1;
			float4 _GradientColor;
			float _GradientPower;
			float _GradientOffset;
			float _GradientScale;
			float _GradientIntensity;
			float _Metallic;
			float _Smoothness;
			#ifdef _TRANSMISSION_ASE
				float _TransmissionShadow;
			#endif
			#ifdef _TRANSLUCENCY_ASE
				float _TransStrength;
				float _TransNormal;
				float _TransScattering;
				float _TransDirect;
				float _TransAmbient;
				float _TransShadow;
			#endif
			#ifdef TESSELLATION_ON
				float _TessPhongStrength;
				float _TessValue;
				float _TessMin;
				float _TessMax;
				float _TessEdgeLength;
				float _TessMaxDisp;
			#endif
			CBUFFER_END
			sampler2D _Gradient;


			
			VertexOutput VertexFunction( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				
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

			#if defined(TESSELLATION_ON)
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

				float2 uv_Gradient = IN.ase_texcoord2.xy * _Gradient_ST.xy + _Gradient_ST.zw;
				float4 clampResult234 = clamp( ( ( tex2D( _Gradient, uv_Gradient ) + _GradientColor ) + ( 1.0 - _GradientIntensity ) ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float4 temp_cast_0 = (_GradientPower).xxxx;
				float2 texCoord2_g481 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g481 = 1.0;
				float temp_output_7_0_g481 = 4.0;
				float temp_output_9_0_g481 = 4.0;
				float temp_output_8_0_g481 = 4.0;
				float2 texCoord2_g479 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g479 = 2.0;
				float temp_output_7_0_g479 = 4.0;
				float temp_output_9_0_g479 = 4.0;
				float temp_output_8_0_g479 = 4.0;
				float2 texCoord2_g477 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g477 = 3.0;
				float temp_output_7_0_g477 = 4.0;
				float temp_output_9_0_g477 = 4.0;
				float temp_output_8_0_g477 = 4.0;
				float2 texCoord2_g482 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g482 = 4.0;
				float temp_output_7_0_g482 = 4.0;
				float temp_output_9_0_g482 = 4.0;
				float temp_output_8_0_g482 = 4.0;
				float2 texCoord2_g474 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g474 = 1.0;
				float temp_output_7_0_g474 = 4.0;
				float temp_output_9_0_g474 = 3.0;
				float temp_output_8_0_g474 = 4.0;
				float2 texCoord2_g486 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g486 = 2.0;
				float temp_output_7_0_g486 = 4.0;
				float temp_output_9_0_g486 = 3.0;
				float temp_output_8_0_g486 = 4.0;
				float2 texCoord2_g483 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g483 = 3.0;
				float temp_output_7_0_g483 = 4.0;
				float temp_output_9_0_g483 = 3.0;
				float temp_output_8_0_g483 = 4.0;
				float2 texCoord2_g490 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g490 = 4.0;
				float temp_output_7_0_g490 = 4.0;
				float temp_output_9_0_g490 = 3.0;
				float temp_output_8_0_g490 = 4.0;
				float2 texCoord2_g487 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g487 = 1.0;
				float temp_output_7_0_g487 = 4.0;
				float temp_output_9_0_g487 = 2.0;
				float temp_output_8_0_g487 = 4.0;
				float2 texCoord2_g478 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g478 = 2.0;
				float temp_output_7_0_g478 = 4.0;
				float temp_output_9_0_g478 = 2.0;
				float temp_output_8_0_g478 = 4.0;
				float2 texCoord2_g484 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g484 = 3.0;
				float temp_output_7_0_g484 = 4.0;
				float temp_output_9_0_g484 = 2.0;
				float temp_output_8_0_g484 = 4.0;
				float2 texCoord2_g488 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g488 = 4.0;
				float temp_output_7_0_g488 = 4.0;
				float temp_output_9_0_g488 = 2.0;
				float temp_output_8_0_g488 = 4.0;
				float2 texCoord2_g491 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g491 = 1.0;
				float temp_output_7_0_g491 = 4.0;
				float temp_output_9_0_g491 = 1.0;
				float temp_output_8_0_g491 = 4.0;
				float2 texCoord2_g485 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g485 = 2.0;
				float temp_output_7_0_g485 = 4.0;
				float temp_output_9_0_g485 = 1.0;
				float temp_output_8_0_g485 = 4.0;
				float2 texCoord2_g480 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g480 = 3.0;
				float temp_output_7_0_g480 = 4.0;
				float temp_output_9_0_g480 = 1.0;
				float temp_output_8_0_g480 = 4.0;
				float2 texCoord2_g489 = IN.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float temp_output_3_0_g489 = 4.0;
				float temp_output_7_0_g489 = 4.0;
				float temp_output_9_0_g489 = 1.0;
				float temp_output_8_0_g489 = 4.0;
				float4 temp_output_155_0 = ( ( ( _Color1 * ( ( ( 1.0 - step( texCoord2_g481.x , ( ( temp_output_3_0_g481 - 1.0 ) / temp_output_7_0_g481 ) ) ) * ( step( texCoord2_g481.x , ( temp_output_3_0_g481 / temp_output_7_0_g481 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g481.y , ( ( temp_output_9_0_g481 - 1.0 ) / temp_output_8_0_g481 ) ) ) * ( step( texCoord2_g481.y , ( temp_output_9_0_g481 / temp_output_8_0_g481 ) ) * 1.0 ) ) ) ) + ( _Color2 * ( ( ( 1.0 - step( texCoord2_g479.x , ( ( temp_output_3_0_g479 - 1.0 ) / temp_output_7_0_g479 ) ) ) * ( step( texCoord2_g479.x , ( temp_output_3_0_g479 / temp_output_7_0_g479 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g479.y , ( ( temp_output_9_0_g479 - 1.0 ) / temp_output_8_0_g479 ) ) ) * ( step( texCoord2_g479.y , ( temp_output_9_0_g479 / temp_output_8_0_g479 ) ) * 1.0 ) ) ) ) + ( _Color3 * ( ( ( 1.0 - step( texCoord2_g477.x , ( ( temp_output_3_0_g477 - 1.0 ) / temp_output_7_0_g477 ) ) ) * ( step( texCoord2_g477.x , ( temp_output_3_0_g477 / temp_output_7_0_g477 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g477.y , ( ( temp_output_9_0_g477 - 1.0 ) / temp_output_8_0_g477 ) ) ) * ( step( texCoord2_g477.y , ( temp_output_9_0_g477 / temp_output_8_0_g477 ) ) * 1.0 ) ) ) ) + ( _Color4 * ( ( ( 1.0 - step( texCoord2_g482.x , ( ( temp_output_3_0_g482 - 1.0 ) / temp_output_7_0_g482 ) ) ) * ( step( texCoord2_g482.x , ( temp_output_3_0_g482 / temp_output_7_0_g482 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g482.y , ( ( temp_output_9_0_g482 - 1.0 ) / temp_output_8_0_g482 ) ) ) * ( step( texCoord2_g482.y , ( temp_output_9_0_g482 / temp_output_8_0_g482 ) ) * 1.0 ) ) ) ) ) + ( ( _Color5 * ( ( ( 1.0 - step( texCoord2_g474.x , ( ( temp_output_3_0_g474 - 1.0 ) / temp_output_7_0_g474 ) ) ) * ( step( texCoord2_g474.x , ( temp_output_3_0_g474 / temp_output_7_0_g474 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g474.y , ( ( temp_output_9_0_g474 - 1.0 ) / temp_output_8_0_g474 ) ) ) * ( step( texCoord2_g474.y , ( temp_output_9_0_g474 / temp_output_8_0_g474 ) ) * 1.0 ) ) ) ) + ( _Color6 * ( ( ( 1.0 - step( texCoord2_g486.x , ( ( temp_output_3_0_g486 - 1.0 ) / temp_output_7_0_g486 ) ) ) * ( step( texCoord2_g486.x , ( temp_output_3_0_g486 / temp_output_7_0_g486 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g486.y , ( ( temp_output_9_0_g486 - 1.0 ) / temp_output_8_0_g486 ) ) ) * ( step( texCoord2_g486.y , ( temp_output_9_0_g486 / temp_output_8_0_g486 ) ) * 1.0 ) ) ) ) + ( _Color7 * ( ( ( 1.0 - step( texCoord2_g483.x , ( ( temp_output_3_0_g483 - 1.0 ) / temp_output_7_0_g483 ) ) ) * ( step( texCoord2_g483.x , ( temp_output_3_0_g483 / temp_output_7_0_g483 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g483.y , ( ( temp_output_9_0_g483 - 1.0 ) / temp_output_8_0_g483 ) ) ) * ( step( texCoord2_g483.y , ( temp_output_9_0_g483 / temp_output_8_0_g483 ) ) * 1.0 ) ) ) ) + ( _Color8 * ( ( ( 1.0 - step( texCoord2_g490.x , ( ( temp_output_3_0_g490 - 1.0 ) / temp_output_7_0_g490 ) ) ) * ( step( texCoord2_g490.x , ( temp_output_3_0_g490 / temp_output_7_0_g490 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g490.y , ( ( temp_output_9_0_g490 - 1.0 ) / temp_output_8_0_g490 ) ) ) * ( step( texCoord2_g490.y , ( temp_output_9_0_g490 / temp_output_8_0_g490 ) ) * 1.0 ) ) ) ) ) + ( ( _Color9 * ( ( ( 1.0 - step( texCoord2_g487.x , ( ( temp_output_3_0_g487 - 1.0 ) / temp_output_7_0_g487 ) ) ) * ( step( texCoord2_g487.x , ( temp_output_3_0_g487 / temp_output_7_0_g487 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g487.y , ( ( temp_output_9_0_g487 - 1.0 ) / temp_output_8_0_g487 ) ) ) * ( step( texCoord2_g487.y , ( temp_output_9_0_g487 / temp_output_8_0_g487 ) ) * 1.0 ) ) ) ) + ( _Color10 * ( ( ( 1.0 - step( texCoord2_g478.x , ( ( temp_output_3_0_g478 - 1.0 ) / temp_output_7_0_g478 ) ) ) * ( step( texCoord2_g478.x , ( temp_output_3_0_g478 / temp_output_7_0_g478 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g478.y , ( ( temp_output_9_0_g478 - 1.0 ) / temp_output_8_0_g478 ) ) ) * ( step( texCoord2_g478.y , ( temp_output_9_0_g478 / temp_output_8_0_g478 ) ) * 1.0 ) ) ) ) + ( _Color11 * ( ( ( 1.0 - step( texCoord2_g484.x , ( ( temp_output_3_0_g484 - 1.0 ) / temp_output_7_0_g484 ) ) ) * ( step( texCoord2_g484.x , ( temp_output_3_0_g484 / temp_output_7_0_g484 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g484.y , ( ( temp_output_9_0_g484 - 1.0 ) / temp_output_8_0_g484 ) ) ) * ( step( texCoord2_g484.y , ( temp_output_9_0_g484 / temp_output_8_0_g484 ) ) * 1.0 ) ) ) ) + ( _Color12 * ( ( ( 1.0 - step( texCoord2_g488.x , ( ( temp_output_3_0_g488 - 1.0 ) / temp_output_7_0_g488 ) ) ) * ( step( texCoord2_g488.x , ( temp_output_3_0_g488 / temp_output_7_0_g488 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g488.y , ( ( temp_output_9_0_g488 - 1.0 ) / temp_output_8_0_g488 ) ) ) * ( step( texCoord2_g488.y , ( temp_output_9_0_g488 / temp_output_8_0_g488 ) ) * 1.0 ) ) ) ) ) + ( ( _Color13 * ( ( ( 1.0 - step( texCoord2_g491.x , ( ( temp_output_3_0_g491 - 1.0 ) / temp_output_7_0_g491 ) ) ) * ( step( texCoord2_g491.x , ( temp_output_3_0_g491 / temp_output_7_0_g491 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g491.y , ( ( temp_output_9_0_g491 - 1.0 ) / temp_output_8_0_g491 ) ) ) * ( step( texCoord2_g491.y , ( temp_output_9_0_g491 / temp_output_8_0_g491 ) ) * 1.0 ) ) ) ) + ( _Color14 * ( ( ( 1.0 - step( texCoord2_g485.x , ( ( temp_output_3_0_g485 - 1.0 ) / temp_output_7_0_g485 ) ) ) * ( step( texCoord2_g485.x , ( temp_output_3_0_g485 / temp_output_7_0_g485 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g485.y , ( ( temp_output_9_0_g485 - 1.0 ) / temp_output_8_0_g485 ) ) ) * ( step( texCoord2_g485.y , ( temp_output_9_0_g485 / temp_output_8_0_g485 ) ) * 1.0 ) ) ) ) + ( _Color15 * ( ( ( 1.0 - step( texCoord2_g480.x , ( ( temp_output_3_0_g480 - 1.0 ) / temp_output_7_0_g480 ) ) ) * ( step( texCoord2_g480.x , ( temp_output_3_0_g480 / temp_output_7_0_g480 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g480.y , ( ( temp_output_9_0_g480 - 1.0 ) / temp_output_8_0_g480 ) ) ) * ( step( texCoord2_g480.y , ( temp_output_9_0_g480 / temp_output_8_0_g480 ) ) * 1.0 ) ) ) ) + ( _Color16 * ( ( ( 1.0 - step( texCoord2_g489.x , ( ( temp_output_3_0_g489 - 1.0 ) / temp_output_7_0_g489 ) ) ) * ( step( texCoord2_g489.x , ( temp_output_3_0_g489 / temp_output_7_0_g489 ) ) * 1.0 ) ) * ( ( 1.0 - step( texCoord2_g489.y , ( ( temp_output_9_0_g489 - 1.0 ) / temp_output_8_0_g489 ) ) ) * ( step( texCoord2_g489.y , ( temp_output_9_0_g489 / temp_output_8_0_g489 ) ) * 1.0 ) ) ) ) ) );
				float4 temp_output_236_0 = ( pow( (clampResult234*_GradientScale + _GradientOffset) , temp_cast_0 ) * temp_output_155_0 );
				
				
				float3 Albedo = temp_output_236_0.rgb;
				float Alpha = 1;
				float AlphaClipThreshold = 0.5;

				half4 color = half4( Albedo, Alpha );

				#ifdef _ALPHATEST_ON
					clip(Alpha - AlphaClipThreshold);
				#endif

				return color;
			}
			ENDHLSL
		}
		
	}
	/*ase_lod*/
	CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
	
	
}
/*ASEBEGIN
Version=18500
-1536;57;1536;843;-730.4301;929.9561;3.1;True;False
Node;AmplifyShaderEditor.ColorNode;229;966.8561,-113.2386;Float;False;Property;_GradientColor;Gradient Color;22;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;230;931.2261,-351.7579;Inherit;True;Property;_Gradient;Gradient;20;0;Create;True;0;0;False;1;Header(Gradient);False;-1;0f424a347039ef447a763d3d4b4782b0;0f424a347039ef447a763d3d4b4782b0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;228;1005.463,185.5694;Float;False;Property;_GradientIntensity;Gradient Intensity;21;0;Create;True;0;0;False;0;False;0.75;0.75;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;231;1300.521,-108.6907;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;232;1295.804,136.3911;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;150;-207.7412,-66.93771;Float;False;Property;_Color2;Color 2;1;0;Create;True;0;0;False;0;False;1,0.1544118,0.8017241,0.253;0.1624164,0.416,0.06244594,0.091;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;233;1481.021,-139.1108;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;159;-187.9672,688.0273;Float;False;Property;_Color5;Color 5;4;0;Create;True;0;0;False;1;Header(Row 2);False;0.9533468,1,0.1544118,0.553;0.6323529,0.5688611,0.2138841,0.259;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;213;-234.6901,2683.007;Float;False;Property;_Color13;Color 13;12;0;Create;True;0;0;False;1;Header(Row 4);False;1,0.5586207,0,0.272;0.8745099,0.6980392,0.4745098,0.272;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;152;-194.2135,166.9271;Float;False;Property;_Color3;Color 3;2;0;Create;True;0;0;False;0;False;0.2535501,0.1544118,1,0.541;0.6323529,0.5688611,0.2138841,0.259;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;157;-182.3802,1181.25;Float;False;Property;_Color7;Color 7;6;0;Create;True;0;0;False;0;False;0.1544118,0.6151115,1,0.178;0.6343814,0.75,0.3088235,0.559;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;181;-218.8154,2174.284;Float;False;Property;_Color11;Color 11;10;0;Create;True;0;0;False;0;False;0.6691177,0.6691177,0.6691177,0.647;0.3888796,0.4705882,0.100346,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;158;-183.7895,1424.406;Float;False;Property;_Color8;Color 8;7;0;Create;True;0;0;False;0;False;0.4849697,0.5008695,0.5073529,0.078;0.4868408,0.6691177,0.280439,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;214;-242.6307,2942.365;Float;False;Property;_Color14;Color 14;13;0;Create;True;0;0;False;0;False;0,0.8025862,0.875,0.047;0.09411766,0.1294118,0.1372549,0.047;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;180;-232.3431,1940.419;Float;False;Property;_Color10;Color 10;9;0;Create;True;0;0;False;0;False;0.362069,0.4411765,0,0.759;0.1231535,0.3088235,0.04995674,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;154;-195.6228,411.2479;Float;False;Property;_Color4;Color 4;3;0;Create;True;0;0;False;0;False;0.1544118,0.5451319,1,0.253;0.09991348,0.1029412,0.10244,0.253;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;217;-264.3738,3419.386;Float;False;Property;_Color16;Color 16;15;0;Create;True;0;0;False;0;False;0.4080882,0.75,0.4811866,0.134;0.1215686,0.2784314,0.05882353,0.134;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;183;-224.4024,1681.061;Float;False;Property;_Color9;Color 9;8;0;Create;True;0;0;False;1;Header(Row 3);False;0.3164301,0,0.7058823,0.134;0.08028764,0.1789584,0.1985294,0.391;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;218;-229.103,3176.23;Float;False;Property;_Color15;Color 15;14;0;Create;True;0;0;False;0;False;1,0,0,0.391;0.07450981,0.172549,0.1921569,0.391;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;156;-195.9079,947.3851;Float;False;Property;_Color6;Color 6;5;0;Create;True;0;0;False;0;False;0.2720588,0.1294625,0,0.097;0.1624164,0.416,0.06244594,0.091;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;23;-199.8005,-326.2955;Float;False;Property;_Color1;Color 1;0;0;Create;True;0;0;False;1;Header(Row 1);False;1,0.1544118,0.1544118,0.291;0.1231535,0.3088235,0.04995674,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;182;-220.2247,2417.44;Float;False;Property;_Color12;Color 12;11;0;Create;True;0;0;False;0;False;0.5073529,0.1574544,0,0.128;0.6911765,0.3944388,0.3709991,0.734;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;188;91.31517,1685.902;Inherit;True;ColorShartSlot;-1;;487;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;1;False;9;FLOAT;2;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;222;87.12894,3424.227;Inherit;True;ColorShartSlot;-1;;489;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;4;False;9;FLOAT;1;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;162;133.8517,1429.247;Inherit;True;ColorShartSlot;-1;;490;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;4;False;9;FLOAT;3;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;216;81.02762,2687.848;Inherit;True;ColorShartSlot;-1;;491;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;1;False;9;FLOAT;1;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;239;1791.499,239.074;Float;False;Property;_GradientOffset;Gradient Offset;24;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;234;1765.769,-101.2706;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;160;119.8096,952.2258;Inherit;True;ColorShartSlot;-1;;486;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;2;False;9;FLOAT;3;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;238;1784.681,146.3308;Float;False;Property;_GradientScale;Gradient Scale;23;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;223;73.08682,2945.046;Inherit;True;ColorShartSlot;-1;;485;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;2;False;9;FLOAT;1;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;185;97.41646,2422.281;Inherit;True;ColorShartSlot;-1;;488;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;4;False;9;FLOAT;2;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;161;133.3375,1186.091;Inherit;True;ColorShartSlot;-1;;483;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;3;False;9;FLOAT;3;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;153;122.0185,414.924;Inherit;True;ColorShartSlot;-1;;482;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;4;False;9;FLOAT;4;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;186;96.90227,2179.125;Inherit;True;ColorShartSlot;-1;;484;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;3;False;9;FLOAT;2;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;145;115.9171,-321.4549;Inherit;True;ColorShartSlot;-1;;481;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;1;False;9;FLOAT;4;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;224;86.61465,3181.071;Inherit;True;ColorShartSlot;-1;;480;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;3;False;9;FLOAT;1;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;149;107.9764,-62.09709;Inherit;True;ColorShartSlot;-1;;479;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;2;False;9;FLOAT;4;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;187;83.37437,1945.26;Inherit;True;ColorShartSlot;-1;;478;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;2;False;9;FLOAT;2;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;151;121.5042,171.7677;Inherit;True;ColorShartSlot;-1;;477;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;3;False;9;FLOAT;4;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;163;127.7504,692.868;Inherit;True;ColorShartSlot;-1;;474;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;1;False;9;FLOAT;3;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;146;1539.255,777.6315;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;225;1534.365,1575.009;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;1539.944,1043.66;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;184;1537.758,1310.802;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;245;1807.933,349.2413;Float;False;Property;_GradientPower;Gradient Power;25;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;237;2134.751,-6.152725;Inherit;True;3;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;246;2330.054,313.4161;Inherit;True;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;155;1914.739,1110.013;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;253;2944.54,171.518;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;250;3217.498,244.4228;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;212;3115.522,1442.756;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;244;3477.393,838.282;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;247;2435.541,-52.01904;Inherit;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;240;2745.767,1001.892;Float;False;Property;_Color16Emmision;Color 16 Emmision;17;1;[HDR];Create;True;0;0;False;0;False;0,0,0,1;0,0,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;254;2699.768,187.571;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;165;3079.922,1286.956;Float;False;Property;_Metallic;Metallic;19;0;Create;True;0;0;False;0;False;0;0.25;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;236;2689.934,325.3839;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;227;2503.989,1371.3;Inherit;True;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;243;3074.475,998.5919;Inherit;True;ColorShartSlot;-1;;493;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;4;False;9;FLOAT;1;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.FunctionNode;242;3073.961,755.4349;Inherit;True;ColorShartSlot;-1;;492;231fe18505db4a84b9c478d379c9247d;0;5;38;COLOR;0.7843138,0.3137255,0,0;False;3;FLOAT;3;False;9;FLOAT;1;False;7;FLOAT;4;False;8;FLOAT;4;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;166;2465.406,1571.782;Float;False;Property;_Smoothness;Smoothness;18;0;Create;True;0;0;False;1;Header(Smoothness (Alphas));False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;241;2755,750.5939;Float;False;Property;_Color15Emmision;Color 15 Emmision;16;1;[HDR];Create;True;0;0;False;1;Header(Emmision);False;0,0,0,1;0,0,0,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;249;2399.374,204.8652;Float;False;Property;_VCIntensity;VC Intensity;26;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;257;3680.683,780.2685;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ShadowCaster;0;2;ShadowCaster;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;258;3680.683,780.2685;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;DepthOnly;0;3;DepthOnly;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;True;0;False;-1;False;True;False;False;False;False;0;False;-1;False;False;False;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;259;3680.683,780.2685;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Meta;0;4;Meta;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;False;False;False;False;False;False;False;False;False;True;2;False;-1;False;False;False;False;False;False;False;False;True;1;LightMode=Meta;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;255;3680.683,780.2685;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;ExtraPrePass;0;0;ExtraPrePass;5;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;0;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;256;3680.683,780.2685;Float;False;True;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;11;Malbers/Color4x4;94348b07e5e8bab40bd6c8a1e3df54cd;True;Forward;0;1;Forward;17;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=UniversalForward;False;0;;0;0;Standard;36;Workflow;1;Surface;0;  Refraction Model;0;  Blend;0;Two Sided;1;Fragment Normal Space,InvertActionOnDeselection;0;Transmission;0;  Transmission Shadow;0.5,False,-1;Translucency;0;  Translucency Strength;1,False,-1;  Normal Distortion;0.5,False,-1;  Scattering;2,False,-1;  Direct;0.9,False,-1;  Ambient;0.1,False,-1;  Shadow;0.5,False,-1;Cast Shadows;1;  Use Shadow Threshold;0;Receive Shadows;1;GPU Instancing;1;LOD CrossFade;1;Built-in Fog;1;_FinalColorxAlpha;0;Meta Pass;1;Override Baked GI;0;Extra Pre Pass;0;DOTS Instancing;0;Tessellation;0;  Phong;0;  Strength;0.5,False,-1;  Type;0;  Tess;16,False,-1;  Min;10,False,-1;  Max;25,False,-1;  Edge Length;16,False,-1;  Max Displacement;25,False,-1;Vertex Position,InvertActionOnDeselection;1;0;6;False;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;260;3680.683,780.2685;Float;False;False;-1;2;UnityEditor.ShaderGraph.PBRMasterGUI;0;1;New Amplify Shader;94348b07e5e8bab40bd6c8a1e3df54cd;True;Universal2D;0;5;Universal2D;0;False;False;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;False;False;False;False;False;False;False;False;True;3;RenderPipeline=UniversalPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;0;0;True;1;1;False;-1;0;False;-1;1;1;False;-1;0;False;-1;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;-1;False;False;False;False;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=Universal2D;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;231;0;230;0
WireConnection;231;1;229;0
WireConnection;232;0;228;0
WireConnection;233;0;231;0
WireConnection;233;1;232;0
WireConnection;188;38;183;0
WireConnection;222;38;217;0
WireConnection;162;38;158;0
WireConnection;216;38;213;0
WireConnection;234;0;233;0
WireConnection;160;38;156;0
WireConnection;223;38;214;0
WireConnection;185;38;182;0
WireConnection;161;38;157;0
WireConnection;153;38;154;0
WireConnection;186;38;181;0
WireConnection;145;38;23;0
WireConnection;224;38;218;0
WireConnection;149;38;150;0
WireConnection;187;38;180;0
WireConnection;151;38;152;0
WireConnection;163;38;159;0
WireConnection;146;0;145;0
WireConnection;146;1;149;0
WireConnection;146;2;151;0
WireConnection;146;3;153;0
WireConnection;225;0;216;0
WireConnection;225;1;223;0
WireConnection;225;2;224;0
WireConnection;225;3;222;0
WireConnection;164;0;163;0
WireConnection;164;1;160;0
WireConnection;164;2;161;0
WireConnection;164;3;162;0
WireConnection;184;0;188;0
WireConnection;184;1;187;0
WireConnection;184;2;186;0
WireConnection;184;3;185;0
WireConnection;237;0;234;0
WireConnection;237;1;238;0
WireConnection;237;2;239;0
WireConnection;246;0;237;0
WireConnection;246;1;245;0
WireConnection;155;0;146;0
WireConnection;155;1;164;0
WireConnection;155;2;184;0
WireConnection;155;3;225;0
WireConnection;253;0;247;0
WireConnection;253;1;254;0
WireConnection;250;0;253;0
WireConnection;250;1;236;0
WireConnection;212;0;227;0
WireConnection;212;1;166;0
WireConnection;244;0;242;0
WireConnection;244;1;243;0
WireConnection;254;0;249;0
WireConnection;236;0;246;0
WireConnection;236;1;155;0
WireConnection;227;0;155;0
WireConnection;243;38;240;0
WireConnection;242;38;241;0
WireConnection;256;0;236;0
WireConnection;256;2;244;0
WireConnection;256;3;165;0
WireConnection;256;4;212;0
ASEEND*/
//CHKSM=B5F37EAE492F62FC3C52632A5AED551E3481AC63