// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function draw_hexagon(xx, yy, size, filled){
	/// Draw a hexagon at given position
	var points = [];
	for (var i = 0; i < 6; i++) {
	    var angle = i * pi / 3;
	    var px = xx + size * cos(angle);
	    var py = yy + size * sin(angle);
	    array_push(points, [px, py]);
	}

	if (filled) {
	    draw_primitive_begin(pr_trianglefan);
	    draw_vertex(xx, yy);
	    for (var i = 0; i <= 6; i++) {
	        var idx = i % 6;
	        draw_vertex(points[idx][0], points[idx][1]);
	    }
	    draw_primitive_end();
	} else {
	    draw_primitive_begin(pr_linestrip);
	    for (var i = 0; i <= 6; i++) {
	        var idx = i % 6;
	        draw_vertex(points[idx][0], points[idx][1]);
	    }
	    draw_primitive_end();
	}
}