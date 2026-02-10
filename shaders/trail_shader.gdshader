shader_type canvas_item;

uniform vec4 custom_color : source_color;
uniform vec4 glow_color : source_color;

varying vec4 v_modulate;

void vertex() {
    v_modulate = COLOR;
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    if (tex.a <= 0.0) {
        discard;
    }

    COLOR = vec4(custom_color.rgb, custom_color.a * v_modulate.a);
}
