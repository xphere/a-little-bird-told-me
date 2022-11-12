shader_type canvas_item;
render_mode blend_mix;

uniform bool enabled = false;
uniform bool is_v8 = false;
uniform vec4 border_color : hint_color = vec4(vec3(1.0), 1.0);
uniform float alpha_threshold : hint_range(0.0, 1.0, 0.001) = 0.75;
uniform float neighbourhood_threshold : hint_range(0.0, 1.0, 0.001) = 0.75;

void vertex() {
	vec2 scale = vec2(1.0) + 2.0 * TEXTURE_PIXEL_SIZE;
	VERTEX *= scale;
}

bool is_transparent(vec4 color) {
	return color.a <= alpha_threshold;
}

bool is_border(vec2 uv) {
	float is_border =
		1.0 - step(0.0, uv.x) +
		0.0 + step(1.0, uv.x) + 
		1.0 - step(0.0, uv.y) +
		0.0 + step(1.0, uv.y)
	;

	return is_border < 1.0;
}

vec4 outline(vec2 uv, vec4 color, sampler2D source, vec2 size) {
	vec4 diff = vec4(size, 0.0, -size.y);
	float neighbours = (
		texture(source, uv - diff.xz).a +
		texture(source, uv + diff.xz).a +
		texture(source, uv - diff.zy).a +
		texture(source, uv + diff.zy).a +
		0.0
	);
	if (is_v8) {
		neighbours += (
			texture(source, uv - diff.xy).a +
			texture(source, uv + diff.xy).a +
			texture(source, uv - diff.xw).a +
			texture(source, uv + diff.xw).a +
			0.0
		);
	}
	float alpha = neighbours > neighbourhood_threshold ? border_color.a : 0.0;

	return vec4(border_color.rgb, alpha);
}

void fragment() {
	vec2 uv = UV * (vec2(1.0) + 2.0 * TEXTURE_PIXEL_SIZE) - TEXTURE_PIXEL_SIZE;
	vec4 color = texture(TEXTURE, uv);

	if (enabled && is_transparent(color) && is_border(uv)) {
		COLOR = outline(uv, color, TEXTURE, TEXTURE_PIXEL_SIZE);
	} else {
		COLOR = color;
	}
}
