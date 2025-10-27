shader_type canvas_item;

uniform float flash = 0.0;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec4 flash_color : source_color;

void fragment() {
	vec4 color = textureLod(screen_texture, SCREEN_UV, 0.0);

	vec4 final = mix(color, flash_color, flash);
	COLOR = final;
}
