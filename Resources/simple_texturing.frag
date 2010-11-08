uniform sampler2D tex;

vec4 base_color (void)
{
    return texture2D(tex, gl_TexCoord[0].st);
}