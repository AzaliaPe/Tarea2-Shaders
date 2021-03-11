Shader "Custom/v2fSolidColor"
{
    Properties
    {
        _Albedo("Albedo", Color) = (1,1,1,1)
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry"
        }

        Pass //Capas de color
        {
            //código
            CGPROGRAM
            
                #pragma vertex vertexShader
                #pragma fragment fragmentShader

                //UNIFORM- Marca una variable la cual su data será constante atravez de la ejecución del shader
                //Es una entrada del shader
                uniform fixed4 _Albedo;

                //Todo lo que es una entrada en Vertex Fragment shader es una uniforme. Algo externo del shader que voy a recibir.
                //Funciones básicas de CG para Vertex Fragment
                #include "UnityCG.cginc" //Incluye las funciones de Unity para CG. 

                //VERTEX INPUT
                //Haces una struct que simbolice las inputs que trae, esas inputs tiene valores chiquitos por eso el fixed y es 4 
                //porque traen color, se pide POSITION cuando son entradas para extraer las posiciones de los vertices del modelo 
                //que este pegado en el shader.
                struct vertexInput 
                {
                    fixed4 vertex : POSITION; 
                };
                
                //VERTEX OUTPUT
                //Se necesita fabricar la salida del Vertex Shader porque este le comunica algo al Fragment Shader.
                //Sirve para devolver los vertices dentro del shader SV_POSITION, se da ya convertidos para que el Fragment ya sepa donde 
                //dibujar, el color es para ver los pixeles del color.
                //Funciona de VERTEX ----> FRAGMENT, siempre en ese ordén.
                struct vertexOutput //Que relación habrá entre los vertices y el color
                {
                    fixed4 position: SV_POSITION;
                    fixed4 color: COLOR;
                };

                //Ahora que se tienen las entradas y salidas ahora se le va a poner el color del albedo.

                vertexOutput vertexShader(vertexInput i)
                {
                    vertexOutput o;

                   //Se necesita indicar donde va a estar en la pantalla.

                   //1. Separar todos los vertices que tenemos 
                    float x = i.vertex.x;
                    float y = i.vertex.y;
                    float z = i.vertex.z;
                    float w = 1; //w sirve para no salirse entre 0 y 1, es una coordenada homogénea.

                    //2. Las estructuramos
                    i.vertex= float4(x, y, z, w);

                    //3. Los conviertes a proyección.
                    o.position = mul(unity_ObjectToWorld, i.vertex); //Convierto de posición local a posición de universo.
                    o.position = mul(UNITY_MATRIX_V, o.position); //Se pone a razón de vista de la pantalla.
                    o.position = mul (UNITY_MATRIX_P, o.position); //Se pasa a la cámara.

                    //4. A la "o" le das el color y Listo!.
                    o.color = _Albedo;
                    return o;
                }

                //Se fabrica el pixelOutput
                struct pixelOutput
                {
                    fixed4 pixel : SV_TARGET; //La salida al modelo target que tenemos en este momento (fixed4 RGBA, fixed3 RGB, fixed2 RG)
                };

                pixelOutput fragmentShader (vertexOutput o)
                {
                    pixelOutput p; //p = pixel
                    p.pixel = o.color;
                    return p;
                }
                
            ENDCG
        }
    }

}