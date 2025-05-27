/// @description Draw a hexagon in 3D space
/// @param {Real} xx X position in world space
/// @param {Real} yy Y position in world space
/// @param {Real} zz Z position in world space
/// @param {Real} size Size of the hexagon
/// @param {Real} height Height of the hexagon walls (for 3D effect)
/// @param {Bool} filled Whether to fill the hexagon
/// @param {Real} color Color of the hexagon
function draw_hexagon_3d(xx, yy, zz, size, height, filled, color) {
    // Store original color and enable alpha blending
    var original_color = draw_get_color();
    draw_set_color(color);
    gpu_set_alphatestenable(true);
    
    // Create the world matrix for this hexagon
    var world_matrix = matrix_build(xx, yy, zz, 0, 0, 0, 1, 1, 1);
    matrix_set(matrix_world, world_matrix);
    
    // Generate hex points
    var top_points = array_create(6);
    var bottom_points = array_create(6);
    
    // Calculate vertices for top and bottom faces
    for (var i = 0; i < 6; i++) {
        var angle = i * pi / 3;
        var px = size * cos(angle);
        var py = size * sin(angle);
        
        top_points[i] = [px, py, height];
        bottom_points[i] = [px, py, 0];
    }
    
    // Draw the hexagon faces
    if (filled) {
        // Draw top face
        vertex_begin(global.vbuff, global.vformat);
        
        vertex_position_3d(global.vbuff, 0, 0, height); // Center point
        vertex_color(global.vbuff, color, draw_get_alpha());
        
        for (var i = 0; i <= 6; i++) {
            var idx = i % 6;
            vertex_position_3d(global.vbuff, top_points[idx][0], top_points[idx][1], top_points[idx][2]);
            vertex_color(global.vbuff, color, draw_get_alpha());
        }
        
        vertex_end(global.vbuff);
        vertex_submit(global.vbuff, pr_trianglefan, -1);
        
        // Draw bottom face
        vertex_begin(global.vbuff, global.vformat);
        
        vertex_position_3d(global.vbuff, 0, 0, 0); // Center point
        vertex_color(global.vbuff, color, draw_get_alpha());
        
        for (var i = 0; i <= 6; i++) {
            var idx = i % 6;
            vertex_position_3d(global.vbuff, bottom_points[idx][0], bottom_points[idx][1], bottom_points[idx][2]);
            vertex_color(global.vbuff, color, draw_get_alpha());
        }
        
        vertex_end(global.vbuff);
        vertex_submit(global.vbuff, pr_trianglefan, -1);
        
        // Draw walls
        vertex_begin(global.vbuff, global.vformat);
        
        for (var i = 0; i <= 6; i++) {
            var idx = i % 6;
            vertex_position_3d(global.vbuff, top_points[idx][0], top_points[idx][1], top_points[idx][2]);
            vertex_color(global.vbuff, color, draw_get_alpha());
            vertex_position_3d(global.vbuff, bottom_points[idx][0], bottom_points[idx][1], bottom_points[idx][2]);
            vertex_color(global.vbuff, color, draw_get_alpha());
        }
        
        vertex_end(global.vbuff);
        vertex_submit(global.vbuff, pr_trianglestrip, -1);
    } else {
        // Draw outline of top face
        vertex_begin(global.vbuff, global.vformat);
        
        for (var i = 0; i <= 6; i++) {
            var idx = i % 6;
            vertex_position_3d(global.vbuff, top_points[idx][0], top_points[idx][1], top_points[idx][2]);
            vertex_color(global.vbuff, color, draw_get_alpha());
        }
        
        vertex_end(global.vbuff);
        vertex_submit(global.vbuff, pr_linestrip, -1);
        
        // Draw vertical lines at corners
        vertex_begin(global.vbuff, global.vformat);
        
        for (var i = 0; i < 6; i++) {
            vertex_position_3d(global.vbuff, top_points[i][0], top_points[i][1], top_points[i][2]);
            vertex_color(global.vbuff, color, draw_get_alpha());
            vertex_position_3d(global.vbuff, bottom_points[i][0], bottom_points[i][1], bottom_points[i][2]);
            vertex_color(global.vbuff, color, draw_get_alpha());
        }
        
        vertex_end(global.vbuff);
        vertex_submit(global.vbuff, pr_linelist, -1);
    }
    
    // Reset world matrix and color
    matrix_set(matrix_world, matrix_build_identity());
    draw_set_color(original_color);
} 