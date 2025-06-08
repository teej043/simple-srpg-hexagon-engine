// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function get_hex_positions_at_range(center_q, center_r, range){
    /// Get all hex positions at exactly range distance from the center
    /// @param {Real} center_q - The q coordinate of the center hex
    /// @param {Real} center_r - The r coordinate of the center hex
    /// @param {Real} range - The exact range to get positions for
    /// @returns {Array<Array<Real>>} Array of [q, r] positions
    
    var positions = [];
    
    if (range == 0) {
        // For range 0, just return the center position
        if (is_valid_position(center_q, center_r)) {
            array_push(positions, [center_q, center_r]);
        }
        return positions;
    }
    
    // Start at the top-right hex at the given range
    var q = center_q + range;
    var r = center_r - range;
    
    // For each of the six sides of the hex ring
    for (var side = 0; side < 6; side++) {
        // Move range steps along this side
        for (var step = 0; step <= range; step++) { // Changed from < to <= to include last position
            // Add the current position if it's valid
            if (is_valid_position(q, r)) {
                array_push(positions, [q, r]);
            }
            
            // Move to next position based on which side we're traversing
            // Only move if we're not at the last step
            if (step < range) {
                switch(side) {
                    case 0: q--; r++; break;  // Move down-right
                    case 1: r++; break;       // Move down
                    case 2: q--; break;       // Move down-left
                    case 3: r--; break;       // Move up-left
                    case 4: q++; r--; break;  // Move up
                    case 5: q++; break;       // Move up-right
                }
            }
        }
    }
    
    if (DEBUG) {
        show_debug_message("[RANGE] Found " + string(array_length(positions)) + " positions at range " + string(range));
    }
    return positions;
} 