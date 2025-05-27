// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function hex_round(q, r){
	/// Round fractional hex coordinates to nearest hex
	var s = -q - r;
	var rq = round(q);
	var rr = round(r);
	var rs = round(s);

	var q_diff = abs(rq - q);
	var r_diff = abs(rr - r);
	var s_diff = abs(rs - s);

	if (q_diff > r_diff && q_diff > s_diff) {
	    rq = -rr - rs;
	} else if (r_diff > s_diff) {
	    rr = -rq - rs;
	}

	return [rq, rr];
}