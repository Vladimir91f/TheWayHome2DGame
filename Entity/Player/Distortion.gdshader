shader_type canvas_item;

uniform float strength: hint_range(0.0, 0.1, 0.001) = 0.08;
uniform float radius: hint_range(0.0, 1.93, 0.001) = 0.25;

uniform float aberration: hint_range(0.0, 1.0, 0.001) = 0.425;
uniform float width: hint_range(0.0, 0.1, 0.0001) = 0.04;
uniform float feather: hint_range(0.0, 1.0, 0.001) = 0.135;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec2 center = -1.0 + 2.0 * UV / (1.0 / TEXTURE_PIXEL_SIZE);
	vec2 st = SCREEN_UV;
	float aspect_ratio = SCREEN_PIXEL_SIZE.y/SCREEN_PIXEL_SIZE.x;
	vec2 scaled_st = FRAGCOORD.xy / (1.0 / SCREEN_PIXEL_SIZE);
	vec2 dist_center = center;
	float mask =  (1.0 - smoothstep(radius-feather, radius, length(dist_center))) * smoothstep(radius - width - feather, radius-width , length(dist_center));
	vec2 offset = normalize(dist_center)*strength*mask;
	vec2 biased_st = scaled_st - offset;

	vec2 abber_vec = offset*aberration*mask;

	vec2 final_st = st*(1.0-mask) + biased_st*mask;

	vec4 red = texture(SCREEN_TEXTURE, final_st + abber_vec);
	vec4 blue = texture(SCREEN_TEXTURE, final_st - abber_vec);
	vec4 ori = texture(SCREEN_TEXTURE, final_st);
	COLOR = vec4(red.r, ori.g, blue.b, 1.0);
}