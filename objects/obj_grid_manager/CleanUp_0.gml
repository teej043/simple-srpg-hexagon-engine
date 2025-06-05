/// @description Clean up surfaces
// You can write your code in this editor

// Free surfaces to prevent memory leaks
if (surface_exists(base_grid_surface)) {
    surface_free(base_grid_surface);
}

if (surface_exists(highlight_surface)) {
    surface_free(highlight_surface);
} 