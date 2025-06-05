/// @description Insert description here
// You can write your code in this editor
draw_clear(#4E9943);

// Draw sprite-based hexagon grid first (behind everything)
draw_hex_grid_sprite(grid_width, grid_height, hex_size, spr_hex);

// Surface-based rendering for highlights and outlines
// Recreate base surface if needed
//if (surface_needs_update || !surface_exists(base_grid_surface)) {
//    base_grid_surface = create_base_grid_surface(base_grid_surface, grid_width, grid_height, hex_size, room_width, room_height);
//    surface_needs_update = false;
//}

// Update highlight surface if needed
// Alternative optimization using is_highlights_changed function:
// if (is_highlights_changed(grid_width, grid_height, highlight_grid, prev_highlight_grid) || !surface_exists(highlight_surface)) {
if (highlight_needs_update || !surface_exists(highlight_surface)) {
    highlight_surface = create_highlight_surface(highlight_surface, grid_width, grid_height, hex_size, highlight_grid, room_width, room_height);
    update_prev_highlights_array(grid_width, grid_height, highlight_grid, prev_highlight_grid); // Update the previous state after creating highlight surface
    highlight_needs_update = false;
}

// Draw the base grid (white outlines)
//if (surface_exists(base_grid_surface)) {
//    draw_surface(base_grid_surface, 0, 0);
//}

// Draw the highlights
if (surface_exists(highlight_surface)) {
    draw_surface(highlight_surface, 0, 0);
}