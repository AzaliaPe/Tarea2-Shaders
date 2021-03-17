Shader "Custom/SolidTextureColor"
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

    Pass
    {
      CGPROGRAM

      #pragma vertex vertexShader
      #pragma fragment fragmentShader

      uniform fixed4 _Albedo;
      uniform sampler2D _MainTexture; //Se declara la textura
      uniform float4 _MainTexture_ST; //Sin esto no va a detectar la entrada del Tiling y Offset "x" y "y".

      //Funciones básicas de CG para Vertex Fragment
      #include "UnityCG.cginc"

      struct vertexInput
      {
        fixed4 vertex : POSITION;
        float2 uv : TEXCOORD0; //Lo ideal es tener solo un uv para que no pese tanto, pero se puede tener hasta 19.
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
        /*float x = i.vertex.x;
        float y = i.vertex.y;
        float z = i.vertex.z;
        float w = 1;

        i.vertex = float4(x, y, z, w);*/

        /*o.position = mul(unity_ObjectToWorld, i.vertex);
        o.position = mul(UNITY_MATRIX_V, o.position);
        o.position = mul(UNITY_MATRIX_P, o.position);*/
        o.position = UnityObjectToClipPos(i.vertex);
        o.uv = TRANSFORM_TEX(i.uv, _MainTexture);//Necesitamos poner de que forma se va a poner la textura.

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
        p.pixel = o.color * tex2D(_MainTexture, o.uv);  //Esta operación es para sacarle el color.
        return p;
      }

      ENDCG
    }
  }
}