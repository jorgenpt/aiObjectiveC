attribute float boneweights0,  boneweights1,  boneweights2,  boneweights3;
attribute float boneweights4,  boneweights5,  boneweights6,  boneweights7;
attribute float boneweights8,  boneweights9,  boneweights10, boneweights11;
attribute float boneweights12, boneweights13, boneweights14, boneweights15;

varying mat3 bumpNormalMatrix;

void main (void)
{
    gl_TexCoord[0] = gl_MultiTexCoord0;
    bumpNormalMatrix = gl_NormalMatrix * mat3(gl_MultiTexCoord1.xyz, gl_MultiTexCoord2.xyz, gl_Normal);
    gl_Position = ftransform();
}