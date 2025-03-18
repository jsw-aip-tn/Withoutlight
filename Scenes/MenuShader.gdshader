shader_type canvas_item;

uniform vec2 mouse_position; // The normalized mouse position (from 0.0 to 1.0)
uniform float pixel_size : hint_range(1.0, 50.0) = 5.0; // The pixel block size (larger = more pixelated)
uniform float threshold : hint_range(0.0, 500.0) = 150.0; // The threshold for the mouse effect

void fragment() {
   // Get normalized pixel coordinates (from 0.0 to 1.0)
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;

    // Default color for the background
    vec3 col = vec3(0.1, 0.1, 0.1);

    // Calculate the block coordinates for pixelation effect
    vec2 pixel_coord = floor(FRAGCOORD.xy / pixel_size) * pixel_size;

    // Calculate the distance from the mouse to the current pixel
    float dist = length(pixel_coord - mouse_position / SCREEN_PIXEL_SIZE);

    // Check if the distance is smaller than the threshold to change the color
    if (dist < threshold) {
        col = vec3(0.9, 0.9, 0.9); // Lighter color when near the mouse
    } else {
        col = vec3(0.1, 0.1, 0.1); // Default darker color
    }

    // Output the final color, with alpha of 1.0 (completely opaque)
   COLOR = vec4(col, dist < threshold ? 0.0 : 1.0);
}
