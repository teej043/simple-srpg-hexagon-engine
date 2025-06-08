// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

/// Global hexagon vertex arrays for performance (calculated once)
global.hex_vertices_outline = [];
global.hex_vertices_filled = [];
global.hex_vertices_calculated = false;

/// Calculate hexagon vertices once for performance
function calculate_hex_vertices() {
    if (global.hex_vertices_calculated) return;
    
    global.hex_vertices_outline = [];
    global.hex_vertices_filled = [];
    
    // Calculate vertices for a unit hexagon (size 1)
    for (var i = 0; i < 6; i++) {
        var angle = (i * pi / 3) + (pi / 6); // Rotate by 30 degrees to make flat-topped
        var px = cos(angle);
        var py = sin(angle);
        array_push(global.hex_vertices_outline, [px, py]);
    }
    
    // For filled hexagon, we need center + vertices
    array_push(global.hex_vertices_filled, [0, 0]); // Center point
    for (var i = 0; i <= 6; i++) {
        var idx = i % 6;
        array_push(global.hex_vertices_filled, global.hex_vertices_outline[idx]);
    }
    
    global.hex_vertices_calculated = true;
}

function draw_hexagon(xx, yy, size, filled){
	/// Draw a flat-topped hexagon at given position
	calculate_hex_vertices(); // Ensure vertices are calculated
	
	if (filled) {
	    draw_primitive_begin(pr_trianglefan);
	    draw_vertex(xx, yy); // Center
	    for (var i = 0; i <= 6; i++) {
	        var idx = i % 6;
	        var vertex = global.hex_vertices_outline[idx];
	        draw_vertex(xx + vertex[0] * size, yy + vertex[1] * size);
	    }
	    draw_primitive_end();
	} else {
	    draw_primitive_begin(pr_linestrip);
	    for (var i = 0; i <= 6; i++) {
	        var idx = i % 6;
	        var vertex = global.hex_vertices_outline[idx];
	        draw_vertex(xx + vertex[0] * size, yy + vertex[1] * size);
	    }
	    draw_primitive_end();
	}
}

/// Optimized function to draw multiple hexagons in a single batch
function draw_hexagons_batch(positions, size, filled, color, alpha) {
    calculate_hex_vertices(); // Ensure vertices are calculated
    
    if (array_length(positions) == 0) return;
    
    draw_set_color(color);
    draw_set_alpha(alpha);
    
    if (filled) {
        draw_primitive_begin(pr_trianglelist);
        for (var p = 0; p < array_length(positions); p++) {
            var xx = positions[p][0];
            var yy = positions[p][1];
            
            // Draw triangles from center to each edge
            for (var i = 0; i < 6; i++) {
                var v1 = global.hex_vertices_outline[i];
                var v2 = global.hex_vertices_outline[(i + 1) % 6];
                
                // Triangle: center, vertex1, vertex2
                draw_vertex(xx, yy);
                draw_vertex(xx + v1[0] * size, yy + v1[1] * size);
                draw_vertex(xx + v2[0] * size, yy + v2[1] * size);
            }
        }
        draw_primitive_end();
    } else {
        draw_primitive_begin(pr_linelist);
        for (var p = 0; p < array_length(positions); p++) {
            var xx = positions[p][0];
            var yy = positions[p][1];
            
            // Draw lines for hexagon outline
            for (var i = 0; i < 6; i++) {
                var v1 = global.hex_vertices_outline[i];
                var v2 = global.hex_vertices_outline[(i + 1) % 6];
                
                draw_vertex(xx + v1[0] * size, yy + v1[1] * size);
                draw_vertex(xx + v2[0] * size, yy + v2[1] * size);
            }
        }
        draw_primitive_end();
    }
}