vec4 light_model(in int light, in vec4 base_color);

vec4 apply_lighting(in vec4 base_color)
{
    return light_model(0, base_color);
}