shader_type spatial;
render_mode blend_mix, unshaded, cull_disabled; 

uniform vec3 water_color : source_color = vec3(0.05, 0.45, 0.55);
uniform vec3 wave_color : source_color = vec3(0.85, 0.95, 0.95);

uniform float chunk_size = 1.0;        // Size of the PS1 pixels (1.0 = 1 meter chunks)
uniform float animation_fps = 8.0;     // Retro stutter
uniform float wave_speed = 0.5;        // Much slower, relaxed current

varying vec3 world_position;

void vertex() {
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    // 1. Snapped Retro Time
    float snapped_time = floor(TIME * animation_fps) / animation_fps;
    
    // 2. Pixelate based on chunk size
    vec2 grid_uv = world_position.xz / chunk_size;
    vec2 pixel_uv = floor(grid_uv) * chunk_size;
    
    // 3. MASSIVE, stretched-out sine waves
    // Multiplying by 0.1 forces the waves to be 10x wider, killing the static
    float wave_a = sin(pixel_uv.x * 0.15 + snapped_time * wave_speed);
    float wave_b = cos(pixel_uv.y * 0.15 - snapped_time * wave_speed * 0.8);
    
    float combined_pattern = (wave_a + wave_b) * 0.5 + 0.5;
               
    // 4. Reduce the foam density
    // Setting this to 0.90 means the ocean is 90% blue, and only 10% white streaks
    if (combined_pattern > 0.90) {
        ALBEDO = wave_color;
    } else {
        ALBEDO = water_color;
    }
}