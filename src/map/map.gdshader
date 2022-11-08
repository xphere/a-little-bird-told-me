shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D reveal : hint_normal;
uniform sampler2D bump : hint_albedo;
uniform vec2 selected = vec2(0.5);
uniform vec4 same_country : hint_color;
uniform vec4 same_province : hint_color;
uniform bool enabled = false;

varying vec4 current;

void vertex()
{
	current = texture(reveal, selected);
}

void fragment()
{
	vec4 color = texture(TEXTURE, UV);
	if (enabled && color.g > 0.1 && current.b > 0.0) {
		vec4 revealed = texture(reveal, UV);
		if (revealed.r == current.r) {
			color = same_country;
			if (revealed.g == current.g) {
				color = same_province;
			}
		}
	}
	COLOR = color * vec4(texture(bump, UV).rgb, 1.0);
}