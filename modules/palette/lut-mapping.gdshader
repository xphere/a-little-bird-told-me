shader_type canvas_item;
render_mode unshaded;

uniform sampler2D lut : hint_albedo;
uniform float lut_size = 32.0;

vec3 to_srgb(vec3 linear_color)
{
	return pow(linear_color.rgb, vec3(1.0 / 2.2));
}

vec4 get_lut_mapping(vec4 color)
{
	vec3 rounded_color = round((lut_size - 1.0) * color.rgb);
	ivec2 position = ivec2(
		int(rounded_color.r + lut_size * rounded_color.b),
		int(rounded_color.g)
	);
	return vec4(to_srgb(texelFetch(lut, position, 0).rgb), color.a);
}

void fragment()
{
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR = get_lut_mapping(color);
}
