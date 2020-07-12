shader_type canvas_item;

const bool flashing = false;
uniform float flashing_time = 0.0;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    COLOR = vec4(color.r + flashing_time, color.g + flashing_time, color.b + flashing_time, color.a);
}