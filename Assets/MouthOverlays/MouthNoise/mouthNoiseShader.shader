// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MouthOverlay/mouthNoiseShader"
{
	Properties
	{
		_Alpha("Alpha", Float) = 1
		_mouthTextue("mouthTextue", 2D) = "white" {}
		_tileSize("tileSize", Vector) = (50,50,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float2 _tileSize;
		uniform sampler2D _mouthTextue;
		uniform float4 _mouthTextue_ST;
		uniform float _Alpha;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float mulTime40 = _Time.y * 20.0;
			float temp_output_25_0 = ( floor( mulTime40 ) % (float)6 );
			float temp_output_45_0 = ( temp_output_25_0 - (float)3 );
			float ifLocalVar43 = 0;
			if( temp_output_25_0 >= 3 )
				ifLocalVar43 = temp_output_45_0;
			else
				ifLocalVar43 = temp_output_25_0;
			float2 uv_TexCoord8 = i.uv_texcoord * _tileSize;
			float simplePerlin2D15 = snoise( (uv_TexCoord8*1.0 + 88.0) );
			float simplePerlin2D2 = snoise( uv_TexCoord8 );
			float simplePerlin2D14 = snoise( (uv_TexCoord8*1.0 + 15.4) );
			float2 uv_mouthTextue = i.uv_texcoord * _mouthTextue_ST.xy + _mouthTextue_ST.zw;
			float4 tex2DNode38 = tex2D( _mouthTextue, uv_mouthTextue );
			float ifLocalVar46 = 0;
			if( temp_output_25_0 >= 3 )
				ifLocalVar46 = -1.0;
			else
				ifLocalVar46 = 1.0;
			o.Emission = ( ( ifLocalVar43 == 0.0 ? simplePerlin2D15 : ( ifLocalVar43 == (float)1 ? simplePerlin2D2 : simplePerlin2D14 ) ) * tex2DNode38 * ifLocalVar46 ).rgb;
			o.Alpha = ( tex2DNode38.a * _Alpha );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18100
81;418;1822;1021;1428.587;962.4172;1.274333;True;True
Node;AmplifyShaderEditor.RangedFloatNode;47;-957.0837,-733.0372;Inherit;False;Constant;_Float4;Float 4;3;0;Create;True;0;0;False;0;False;20;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;40;-1016.563,-898.7924;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;28;-699.6274,-795.8824;Inherit;False;Constant;_Int0;Int 0;2;0;Create;True;0;0;False;0;False;6;0;0;1;INT;0
Node;AmplifyShaderEditor.FloorOpNode;48;-778.6771,-878.3112;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;4;-845,-607;Inherit;False;Property;_tileSize;tileSize;2;0;Create;True;0;0;False;0;False;50,50;50,50;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-621,-534;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;18;-872.8433,-341.3586;Inherit;False;Constant;_Float1;Float 1;2;0;Create;True;0;0;False;0;False;15.4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;44;-318.8717,-706.2122;Inherit;False;Constant;_Int3;Int 3;3;0;Create;True;0;0;False;0;False;3;0;0;1;INT;0
Node;AmplifyShaderEditor.SimpleRemainderNode;25;-374.9975,-932.618;Inherit;True;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;16;-445.9316,-351.5383;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-625.7939,-141.1356;Inherit;False;Constant;_Float2;Float 2;2;0;Create;True;0;0;False;0;False;88;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;45;-155.0717,-859.6123;Inherit;False;2;0;FLOAT;0;False;1;INT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;33;62.59541,-596.0135;Inherit;False;Constant;_Int2;Int 2;2;0;Create;True;0;0;False;0;False;1;0;0;1;INT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;2;-75,-687;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;43;171.2715,-914.4418;Inherit;False;False;5;0;FLOAT;0;False;1;INT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;14;-76.93164,-456.5383;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;19;-435.9316,-198.5383;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;15;-80.93164,-230.5383;Inherit;True;Simplex2D;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;29;271.1067,-632.4437;Inherit;False;0;4;0;FLOAT;0;False;1;INT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;206.8927,-1077.61;Inherit;False;Constant;_Float3;Float 0;3;0;Create;True;0;0;False;0;False;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;28.71899,-1066.589;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Compare;35;469.6613,-556.7219;Inherit;False;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;38;-682.243,-19.8287;Inherit;True;Property;_mouthTextue;mouthTextue;1;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;6;-489,258;Inherit;False;Property;_Alpha;Alpha;0;0;Create;True;0;0;False;0;False;1;0.85;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ConditionalIfNode;46;424.7287,-985.7132;Inherit;False;False;5;0;FLOAT;0;False;1;INT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;648.9539,-149.1167;Inherit;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-254,196;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.IntNode;32;162.0684,-115.5383;Inherit;False;Constant;_Int1;Int 1;2;0;Create;True;0;0;False;0;False;2;0;0;1;INT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;MouthOverlay/mouthNoiseShader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;40;0;47;0
WireConnection;48;0;40;0
WireConnection;8;0;4;0
WireConnection;25;0;48;0
WireConnection;25;1;28;0
WireConnection;16;0;8;0
WireConnection;16;2;18;0
WireConnection;45;0;25;0
WireConnection;45;1;44;0
WireConnection;2;0;8;0
WireConnection;43;0;25;0
WireConnection;43;1;44;0
WireConnection;43;2;45;0
WireConnection;43;3;45;0
WireConnection;43;4;25;0
WireConnection;14;0;16;0
WireConnection;19;0;8;0
WireConnection;19;2;20;0
WireConnection;15;0;19;0
WireConnection;29;0;43;0
WireConnection;29;1;33;0
WireConnection;29;2;2;0
WireConnection;29;3;14;0
WireConnection;35;0;43;0
WireConnection;35;2;15;0
WireConnection;35;3;29;0
WireConnection;46;0;25;0
WireConnection;46;1;44;0
WireConnection;46;2;42;0
WireConnection;46;3;42;0
WireConnection;46;4;41;0
WireConnection;3;0;35;0
WireConnection;3;1;38;0
WireConnection;3;2;46;0
WireConnection;7;0;38;4
WireConnection;7;1;6;0
WireConnection;0;2;3;0
WireConnection;0;9;7;0
ASEEND*/
//CHKSM=910914092E8E4D20F927F108CAEBD0D368A812E9