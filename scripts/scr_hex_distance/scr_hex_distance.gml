// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_hex_distance(q1, r1, q2, r2){
	/// Calculate distance between two hex coordinates
	/// @param {Real} q1, r1 - First hex coordinates
	/// @param {Real} q2, r2 - Second hex coordinates
	/// @return {Real} - Distance between hexes
	return (abs(q1 - q2) + abs(q1 + r1 - q2 - r2) + abs(r1 - r2)) / 2;
}