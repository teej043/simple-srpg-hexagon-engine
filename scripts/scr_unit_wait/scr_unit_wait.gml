// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_unit_wait(unit){
	/// Make unit wait (skip turn)
	/// @param {Id.Instance} unit - The unit instance
	unit.has_moved = true;
	unit.has_acted = true;
	scr_unit_deselect(unit);
}