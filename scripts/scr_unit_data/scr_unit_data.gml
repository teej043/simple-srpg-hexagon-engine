/// @description Unit data management and templates

// Unit template data stored in JSON format

enum MOVETYPE
{
    GROUND,
	SKYLOW,
	SKYHIGH
}

function get_unit_templates() {
    static unit_templates = {
        "berserker": {
            "name": "Berserker",
            "sprite": spr_berserker_idle,
            "stats": {
                "max_hp": 120,
                "max_sp": 40,
                "attack_power": 25,
                "defense": 8,
                "movement_range": 3,
				"attack_range": 1
            },
			"move_type" : MOVETYPE.GROUND,
            "ability_ids": ["rage", "whirlwind"],
            "passive_trait_ids": ["berserk", "momentum"]
        },
        "mage": {
            "name": "Mage",
            "sprite": spr_mage_idle,
            "stats": {
                "max_hp": 80,
                "max_sp": 80,
                "attack_power": 30,
                "defense": 5,
                "movement_range": 2,
				"attack_range": 2
            },
			"move_type" : MOVETYPE.GROUND,
            "ability_ids": ["fireball"],
            "passive_trait_ids": ["mana_shield", "spell_weaver"]
        },
        "darkknight": {
            "name": "Dark Knight",
            "sprite": spr_darkknight_idle,
            "stats": {
                "max_hp": 100,
                "max_sp": 60,
                "attack_power": 22,
                "defense": 12,
                "movement_range": 3,
				"attack_range": 1
            },
			"move_type" : MOVETYPE.GROUND,
            "ability_ids": ["dark_slash"],
            "passive_trait_ids": ["battle_hardened"]
        },
        "grappler": {
            "name": "Grappler",
            "sprite": spr_grappler_idle,
            "stats": {
                "max_hp": 110,
                "max_sp": 45,
                "attack_power": 20,
                "defense": 10,
                "movement_range": 4,
				"attack_range": 1
            },
			"move_type" : MOVETYPE.GROUND,
            "ability_ids": ["throw"],
            "passive_trait_ids": ["momentum", "battle_hardened"]
        },
        "archer": {
            "name": "Archer",
            "sprite": spr_archer_idle,
            "stats": {
                "max_hp": 90,
                "max_sp": 50,
                "attack_power": 18,
                "defense": 7,
                "movement_range": 3,
				"attack_range": 3
            },
			"move_type" : MOVETYPE.SKYLOW,
            "ability_ids": ["power_shot"],
            "passive_trait_ids": ["long_range"]
        },
        "archer": {
            "name": "Archer",
            "sprite": spr_archer_idle,
            "stats": {
                "max_hp": 90,
                "max_sp": 50,
                "attack_power": 18,
                "defense": 7,
                "movement_range": 3,
				"attack_range": 3
            },
			"move_type" : MOVETYPE.SKYLOW,
            "ability_ids": ["power_shot"],
            "passive_trait_ids": ["long_range"]
        },
        "galura": {
            "name": "Galura",
            "sprite": spr_angel_idle,
            "stats": {
                "max_hp": 90,
                "max_sp": 50,
                "attack_power": 18,
                "defense": 7,
                "movement_range": 3,
				"attack_range": 3
            },
			"move_type" : MOVETYPE.SKYLOW,
            "ability_ids": ["power_shot"],
            "passive_trait_ids": ["long_range"]
        },
        "angel": {
            "name": "Angel",
            "sprite": spr_angel_idle,
            "stats": {
                "max_hp": 90,
                "max_sp": 50,
                "attack_power": 18,
                "defense": 7,
                "movement_range": 4,
				"attack_range": 1
            },
			"move_type" : MOVETYPE.SKYHIGH,
            "ability_ids": ["power_shot"],
            "passive_trait_ids": ["long_range"]
        },
        "demon": {
            "name": "Demon",
            "sprite": spr_demon_idle,
            "stats": {
                "max_hp": 90,
                "max_sp": 50,
                "attack_power": 18,
                "defense": 7,
                "movement_range": 5,
				"attack_range": 1
            },
			"move_type" : MOVETYPE.SKYLOW,
            "ability_ids": ["power_shot"],
            "passive_trait_ids": ["long_range"]
        }
    };
    
    return unit_templates;
}

/// @function get_unit_template(unit_type)
/// @param {String} unit_type The type of unit to get data for
/// @returns {Struct} The unit template data or undefined if not found
function get_unit_template(unit_type) {
    var templates = get_unit_templates();
    return variable_struct_get(templates, unit_type);
}

/// @function get_available_unit_types()
/// @returns {Array} Array of available unit type names
function get_available_unit_types() {
    var templates = get_unit_templates();
    return variable_struct_get_names(templates);
}

/// @function get_unit_abilities(unit_type)
/// @param {String} unit_type The type of unit to get abilities for
/// @returns {Array} Array of ability template data for the unit
function get_unit_abilities(unit_type) {
    var unit_template = get_unit_template(unit_type);
    if (unit_template == undefined) return [];
    
    var abilities = [];
    var ability_ids = unit_template.ability_ids;
    
    for (var i = 0; i < array_length(ability_ids); i++) {
        var ability = get_ability_template(ability_ids[i]);
        if (ability != undefined) {
            array_push(abilities, ability);
        }
    }
    
    return abilities;
}

/// @function get_unit_passive_traits(unit_type)
/// @param {String} unit_type The type of unit to get passive traits for
/// @returns {Array} Array of passive trait template data for the unit
function get_unit_passive_traits(unit_type) {
    var unit_template = get_unit_template(unit_type);
    if (unit_template == undefined) return [];
    
    var traits = [];
    var trait_ids = unit_template.passive_trait_ids;
    
    for (var i = 0; i < array_length(trait_ids); i++) {
        var trait = get_passive_trait_template(trait_ids[i]);
        if (trait != undefined) {
            array_push(traits, trait);
        }
    }
    
    return traits;
} 