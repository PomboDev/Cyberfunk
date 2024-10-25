shader_type canvas_item;

uniform bool whiten = false;
uniform float mix_weight = 1;

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
    vec4 final_color = texture_color * COLOR;
    
    if (whiten) {
        vec3 white = vec3(1,1,1);
        vec3 whitened_texture_rgb = mix(final_color.rgb, white, mix_weight);
        COLOR = vec4(whitened_texture_rgb, final_color.a);
    } else {
        COLOR = final_color;
    }
}