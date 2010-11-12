varying vec3 normal;

vec4 phong_point(in int light, in vec4 base_color, in vec3 normal);

vec4 light_model(in int light, in vec4 base_color)
{
    return phong_point(light, base_color, normal);
}
