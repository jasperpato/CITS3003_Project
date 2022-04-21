// PART G

varying vec2 texCoord;  // The third coordinate is always 0.0 and is discarded
uniform sampler2D texture;

varying vec3 vpos;
varying vec3 vnorm;

uniform vec3 AmbientProduct, DiffuseProduct, SpecularProduct;
uniform mat4 ModelView, Projection;

uniform vec4 OriginPosition, LightPosition1, LightPosition2;
uniform vec3 LightRGB1, LightRGB2;
uniform float LightBrightness1, LightBrightness2;

uniform float texScale, Shininess;

vec4 color = vec4(0.0, 0.0, 0.0, 1.0);
vec4 spec = vec4(0.0, 0.0, 0.0, 0.0);

/**
 * Adds light source contribution at position lpos to fragment color
 */
void light_source(vec4 Lpos, vec3 lrgb, float b, vec3 distParam) {

    // Transform vertex position into eye coordinates
    vec3 pos = (ModelView * vec4(vpos, 1.0)).xyz;

    // The vector to the light from the vertex    
    vec3 Lvec = Lpos.xyz - pos;

    // Unit direction vectors for Blinn-Phong shading calculation
    vec3 L = normalize( Lvec );   // Direction to the light source
    vec3 E = normalize( -pos );   // Direction to the eye/camera
    vec3 H = normalize( L + E );  // Halfway vector

    // Transform vertex normal into eye coordinates (assumes scaling
    // is uniform across dimensions)
    vec3 N = normalize( (ModelView * vec4(vnorm, 0.0)).xyz );

    // Compute terms in the illumination equation
    vec3 ambient = AmbientProduct * lrgb * b;

    float Kd = max( dot(L, N), 0.0 );
    vec3  diffuse = Kd * DiffuseProduct * lrgb * b;

    float Ks = pow( max(dot(N, H), 0.0), Shininess );
    vec3  specular = Ks * SpecularProduct * b;
    
    if (dot(L, N) < 0.0 ) {
	    specular = vec3(0.0, 0.0, 0.0);
    } 

    float distFactor = distParam[0] + distParam[1] * length(Lvec) + distParam[2] * pow(length(Lvec), 2.0);
    if (distFactor == 0.0) distFactor = 1.0;

    color += vec4(ambient + diffuse / distFactor, 0.0);
    spec += vec4(specular / distFactor, 0.0);
}

void main()
{
    // vec3 Lvec1 = LightPosition1.xyz - pos;
    vec3 distParams1 = vec3(0.5, 0.5, 0.5);
    
    light_source(LightPosition1, LightRGB1, LightBrightness1, distParams1);

    // vec3 Lvec2 = (OriginPosition - LightPosition2).xyz;
    // vec3 distParams2 = vec3(0.0, 0.0, 0.0);
    // light_source(Lvec2, LightRGB2, LightBrightness2, distParams2); // light source to origin

    // globalAmbient is independent of distance from the light source
    color += vec4(0.1, 0.1, 0.1, 0.0);

    // PART H
    gl_FragColor = color * texture2D( texture, texCoord * texScale ) + spec;
}
