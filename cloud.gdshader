shader_type spatial;
// unshaded ignores the sun, cull_disabled lets you see it from above or below
render_mode blend_mix, unshaded, cull_disabled;

uniform sampler2D cloud_texture : repeat_enable; 
uniform vec3 cloud_color : source_color = vec3(1.0, 1.0, 1.0);

uniform float speed = 0.05;
uniform float density : hint_range(0.0, 1.0) = 0.5; // Slide this to make clouds thicker/thinner
uniform float pixel_density = 64.0;                 // The PS1 chunkiness
uniform float animation_fps = 8.0;                  // The retro stutter

void fragment() {
	// 1. Snapped Retro Time
	float snapped_time = floor(TIME * animation_fps) / animation_fps;
	
	// 2. Pixelate the UV grid to force the chunky PS1 look
	vec2 pixel_uv = floor(UV * pixel_density) / pixel_density;
	
	// 3. Scroll the grid diagonally
	vec2 moving_uv = pixel_uv + vec2(snapped_time * speed, snapped_time * speed * 0.5);
	
	// 4. Read the noise texture
	float noise = texture(cloud_texture, moving_uv).r;
	
	// 5. Sharp Color Cutoff
	// Instead of soft, fuzzy clouds, we aggressively cut them off to make solid shapes
	if (noise > (1.0 - density)) {
		ALBEDO = cloud_color;
		ALPHA = 1.0;  // Draw the cloud
	} else {
		ALPHA = 0.0;  // Make the sky invisible
	}
}