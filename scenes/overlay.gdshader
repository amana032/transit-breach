shader_type spatial;
render_mode unshaded, fog_disabled;

uniform sampler2D screen_texture : hint_screen_texture; // frame buffer 
uniform float pixel_size : hint_range(0.0, 20.0, 1.0);

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0); // set position of quad to cover the screen 
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 tex_size = vec2(textureSize(screen_texture, 0)); // get resolution of screen
	vec2 pixel_count = tex_size / pixel_size; // total number of pixels

	// blow up pixel, floor to remove smoothing, then scale back down
	// effectively sample the same spot across multiple pixels
	vec2 pixelated_uv = floor(SCREEN_UV * pixel_count) / pixel_count;  
	

	vec4 color = texture(screen_texture, pixelated_uv);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}
