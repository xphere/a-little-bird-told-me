shader_type canvas_item;
render_mode blend_mix;

uniform vec2 speed = vec2(0, 0);

void fragment() {
	COLOR = texture(TEXTURE, UV + TIME * speed);
}