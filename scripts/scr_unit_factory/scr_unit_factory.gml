/// @description Unit factory and data transformation utilities

/// @function create_unit_from_template(unit_type, grid_x, grid_y, team)
/// @param {String} unit_type The type of unit to create
/// @param {Real} grid_x The grid x position
/// @param {Real} grid_y The grid y position
/// @param {Real} team The team number (0 = player, 1 = enemy)
/// @returns {Id.Instance} The created unit instance or noone if failed
function create_unit_from_template(unit_type, grid_x, grid_y, team) {
    var template = get_unit_template(unit_type);
    if (template == undefined) return noone;
    
    // Create the unit instance
    var unit = instance_create_layer(0, 0, "Instances", obj_unit);
    if (unit == noone) return noone;
    
    // Apply template data
    with (unit) {
        // Set unit type
        self.unit_type = unit_type;
        
        // Set position
        self.grid_x = grid_x;
        self.grid_y = grid_y;
        var pos = hex_to_pixel(grid_x, grid_y);
        x = pos[0];
        y = pos[1];
        actual_x = x;
        actual_y = y;
        
        // Set team
        self.team = team;
        
        // Set sprite
        sprite_index = template.sprite;
        
        // Apply stats
        var stats = template.stats;
        max_hp = stats.max_hp;
        current_hp = max_hp;
        max_sp = stats.max_sp;
        current_sp = max_sp;
        attack_power = stats.attack_power;
        defense = stats.defense;
        movement_range = stats.movement_range;
        attack_range = stats.attack_range;
        
        // Initialize other properties
        has_moved = false;
        has_acted = false;
        is_selected = false;
        movement_path = ds_list_create();
        current_path_position = 0;
        is_moving = false;
        move_progress = 0;
        move_speed = 0.1;
        skip_animation = false;
        current_action = "none";
        target_x = 0;
        target_y = 0;
    }
    
    return unit;
}

/// @function export_unit_data_to_json(unit)
/// @param {Id.Instance} unit The unit instance to export
/// @returns {String} JSON string representation of the unit's data
function export_unit_data_to_json(unit) {
    var data = {
        grid_position: {
            x: unit.grid_x,
            y: unit.grid_y
        },
        stats: {
            max_hp: unit.max_hp,
            current_hp: unit.current_hp,
            max_sp: unit.max_sp,
            current_sp: unit.current_sp,
            attack_power: unit.attack_power,
            defense: unit.defense,
            movement_range: unit.movement_range,
            attack_range: unit.attack_range
        },
        state: {
            team: unit.team,
            has_moved: unit.has_moved,
            has_acted: unit.has_acted,
            is_selected: unit.is_selected,
            current_action: unit.current_action
        }
    };
    
    return json_stringify(data);
}

/// @function import_unit_data_from_json(unit, json_string)
/// @param {Id.Instance} unit The unit instance to update
/// @param {String} json_string The JSON data to import
/// @returns {Bool} True if import was successful
function import_unit_data_from_json(unit, json_string) {
    try {
        var data = json_parse(json_string);
        
        // Update position
        unit.grid_x = data.grid_position.x;
        unit.grid_y = data.grid_position.y;
        var pos = hex_to_pixel(unit.grid_x, unit.grid_y);
        unit.x = pos[0];
        unit.y = pos[1];
        unit.actual_x = unit.x;
        unit.actual_y = unit.y;
        
        // Update stats
        unit.max_hp = data.stats.max_hp;
        unit.current_hp = data.stats.current_hp;
        unit.max_sp = data.stats.max_sp;
        unit.current_sp = data.stats.current_sp;
        unit.attack_power = data.stats.attack_power;
        unit.defense = data.stats.defense;
        unit.movement_range = data.stats.movement_range;
        unit.attack_range = data.stats.attack_range;
        
        // Update state
        unit.team = data.state.team;
        unit.has_moved = data.state.has_moved;
        unit.has_acted = data.state.has_acted;
        unit.is_selected = data.state.is_selected;
        unit.current_action = data.state.current_action;
        
        return true;
    } catch(e) {
        if (DEBUG) {
            show_debug_message("Error importing unit data: " + string(e));
        }
        return false;
    }
} 