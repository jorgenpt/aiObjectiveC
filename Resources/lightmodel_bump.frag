uniform sampler2D normalMap;
varying mat3 bumpNormalMatrix;

vec4 phong_point(in int light, in vec4 base_color, in vec3 normal);

vec4 light_model(in int light, in vec4 base_color)
{
    // Look up point in normalmap.
    vec3 bumpNormal = (texture2D(normalMap, gl_TexCoord[0].st).xyz - vec3(0.5)) * 2.0;
    // Convert from normalmap to eyespace.
    bumpNormal = normalize(bumpNormalMatrix * bumpNormal);

    // Apply lighting
    return phong_point(light, base_color, bumpNormal);
}
