shader_type canvas_item;

uniform vec4 custom_color : source_color = vec4(1.0);
uniform vec4 glow_color : source_color = vec4(1.0);

varying vec4 v_modulate;

void vertex() {
    v_modulate = COLOR;
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    if (tex.a <= 0.0) {
        discard;
    }

    // Multiply texture by your custom color
    vec3 final_rgb = tex.rgb * custom_color.rgb;

    // Preserve original texture alpha for proper progress masking
    float final_alpha = tex.a * custom_color.a * v_modulate.a;

    COLOR = vec4(final_rgb, final_alpha);
}