Shader "Custom/CullingEffect"
{
  Properties
  {
    _Albedo("Albedo", Color) = (1, 1, 1, 1)
    _MainTexture("Main Texture", 2D) = "white" {}
  }

  SubShader
  {
    Tags
    {
      "RenderType" = "Opaque"
      "Queue" = "Geometry"
    }

    //Cull Back //Se ve lo de afuera pero si te vas hacia adentro no se ve nada. En un plano se ve lo de atrás.
    // Cull Front //Se usa para presentaciones, como cuando en un cubo solo quieres ver lo de adentro y se ve como paredes. En un plano no se ve el frente.
    Cull Off //Esto hace que todo sea visible.

    Pass
    {
      CGPROGRAM

      #pragma vertex vertexShader
      #pragma fragment fragmentShader

      uniform fixed4 _Albedo;
      uniform sampler2D _MainTexture;
      uniform float4 _MainTexture_ST;

      //Funciones basicas de CG para Vertex Fragment
      #include "UnityCG.cginc"

      struct vertexInput
      {
        fixed4 vertex : POSITION;
        float2 uv : TEXCOORD0;
      };

      struct vertexOutput
      {
        fixed4 position : SV_POSITION;
        fixed4 color : COLOR;
        float2 uv : TEXCOORD0;
      };

      vertexOutput vertexShader(vertexInput i)
      {
        vertexOutput o;

        o.position = UnityObjectToClipPos(i.vertex);
        o.uv = TRANSFORM_TEX(i.uv, _MainTexture);

        o.color = _Albedo;

        return o;
      }

      struct pixelOutput
      {
        fixed4 pixel : SV_TARGET;
      };

      pixelOutput fragmentShader(vertexOutput o)
      {
        pixelOutput p;
        p.pixel = o.color * tex2D(_MainTexture, o.uv);
        return p;
      }

      ENDCG
    }
  }
}