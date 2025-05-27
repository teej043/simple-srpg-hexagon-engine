// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_unit_deselect(unit){
	/// Deselect this unit
	/// @param {Id.Instance} unit - The unit instance to deselect
	unit.is_selected = false;
	obj_game_manager.selected_unit = noone;
	scr_clear_highlights();
}