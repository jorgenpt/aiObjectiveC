varying mat3 bumpNormalMatrix;

void main (void)
{
    gl_TexCoord[0] = gl_MultiTexCoord0;
    bumpNormalMatrix = gl_NormalMatrix * mat3(gl_MultiTexCoord1.xyz, gl_MultiTexCoord2.xyz, gl_Normal);
    gl_Position = ftransform();
}