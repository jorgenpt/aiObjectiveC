vec4 phong_point(in int light, in vec4 base_color, in vec3 normal)
{
    vec3 N = normalize(normal);
    vec3 H = normalize(gl_LightSource[0].halfVector.xyz);
    vec3 L = normalize(gl_LightSource[0].position.xyz);

    vec4 ambient = gl_FrontLightProduct[0].ambient + gl_FrontLightProduct[1].ambient;
    vec4 diffuse = gl_FrontLightProduct[0].diffuse * max(dot(L, N), 0.0);
    vec4 specular = gl_FrontLightProduct[0].specular * pow(max(dot(H, N), 0.0), gl_FrontMaterial.shininess);
	
    return gl_FrontLightModelProduct.sceneColor + ambient + diffuse * base_color + specular;
}