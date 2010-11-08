vec4 apply_lighting(in vec4 base_color);
vec4 base_color(void);

void main (void)
{
    gl_FragColor = apply_lighting(base_color());
}