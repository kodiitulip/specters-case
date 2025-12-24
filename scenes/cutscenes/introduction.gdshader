shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

uniform float filtro_strength : hint_range(0.0, 1.0) = 0.8;
uniform float darkness : hint_range(0.8, 1.2) = 0.95;
uniform float contrast : hint_range(0.8, 1.5) = 1.15;
uniform float saturation : hint_range(0.5, 1.3) = 1.05;

void fragment() {
    vec4 col = texture(screen_texture, SCREEN_UV);

    // luminância
    float gray = dot(col.rgb, vec3(0.299, 0.587, 0.114));

    // sépia clássico
    vec3 filtro;
    filtro.r = dot(col.rgb, vec3(0.393, 0.769, 0.189));
    filtro.g = dot(col.rgb, vec3(0.349, 0.686, 0.168));
    filtro.b = dot(col.rgb, vec3(0.272, 0.534, 0.131));

    // mistura sépia
    vec3 color = mix(col.rgb, filtro, filtro_strength);

    // saturação
    color = mix(vec3(gray), color, saturation);

    // contraste
    color = (color - 0.5) * contrast + 0.5;

    // escurecimento final
    color *= darkness;

    COLOR = vec4(color, col.a);
}
