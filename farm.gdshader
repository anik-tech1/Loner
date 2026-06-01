shader_type spatial;
// Unshaded and cull_disabled ensure it works flawlessly on any Godot renderer
render_mode blend_mix, unshaded, cull_disabled; 

// Lake color palette (Murky greens and deep teals instead of bright blues)
uniform vec3 deep_water : source_color = vec3(0.10, 0.25, 0.20);
uniform vec3 shallow_water : source_color = vec3(0.20, 0.35, 0.30);
uniform vec3 ripple_highlight : source_color = vec3(0.35, 0.50, 0.45);

uniform float chunk_size = 1.0;        // Size of the PS1 pixels
uniform float animation_fps = 8.0;     // Retro stutter rate
uniform float water_speed = 0.15;      // VERY slow for a calm lake

varying vec3 world_position;

void vertex() {
    // Lock the texture to the actual world coordinates to prevent stretching
    world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
    // 1. Snapped Retro Time
    float snapped_time = floor(TIME * animation_fps) / animation_fps;
    
    // 2. Pixelate based on chunk size
    vec2 grid_uv = world_position.xz / chunk_size;
    vec2 pixel_uv = floor(grid_uv) * chunk_size;
    
    // 3. The "Lake Swirl" Math
    // By using three overlapping waves moving in different directions, 
    // it creates a gentle, bobbing surface instead of a flowing river.
    float wave_1 = sin(pixel_uv.x * 0.2 + snapped_time * water_speed);
    float wave_2 = cos(pixel_uv.y * 0.2 - snapped_time * water_speed * 0.8);
    float wave_3 = sin((pixel_uv.x + pixel_uv.y) * 0.15 + snapped_time * water_speed * 1.2);
    
    // Average them together and normalize the math
    float combined_pattern = (wave_1 + wave_2 + wave_3) / 3.0;
    combined_pattern = combined_pattern * 0.5 + 0.5;
               
    // 4. Three-Tier Color Banding
    // No harsh white foam. Just gentle transitions between deep, shallow, and ripples.
    if (combined_pattern > 0.70) {
        ALBEDO = ripple_highlight;
    } else if (combined_pattern > 0.40) {
        ALBEDO = shallow_water;
    } else {
        ALBEDO = deep_water;
    }
}