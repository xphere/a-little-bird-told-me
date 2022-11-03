shader_type canvas_item;
render_mode blend_mix;

uniform bool inverted = false;
uniform float amount : hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float diffusion : hint_range(0.0, 1.0, 0.01) = 0.1;
uniform float displacement : hint_range(0.0, 0.1, 0.005) = 0.01;
uniform sampler2D transition : hint_white;

float invsmoothstep(float edge0, float edge1, float value) {
        return 1.0 - smoothstep(1.0 - edge1, 1.0 - edge0, value);
}

void fragment() {
        float value = texture(transition, UV).r;
        float threshold = diffusion;
		float current = inverted ? 1.0 - amount : amount;
        threshold *= smoothstep(0.0, diffusion, current);
        threshold *= invsmoothstep(0.0, diffusion, current);
        value = clamp(value, displacement, 1.0 - displacement);
        value = smoothstep(current - threshold, current + threshold, value);
        COLOR.a = inverted ? value : 1.0 - value;
}