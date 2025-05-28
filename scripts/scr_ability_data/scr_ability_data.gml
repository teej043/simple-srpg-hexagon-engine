/// @description Ability data management and templates

function get_ability_templates() {
    static ability_templates = {
        // Berserker Tree
        "rage": {
            "name": "Rage",
            "sp_cost": 20,
            "type": "buff",
            "tier": 1,
            "prerequisites": [],
            "effects": [
                {"stat": "attack_power", "modifier": 1.3, "duration": 3},
                {"stat": "defense", "modifier": 0.8, "duration": 3}
            ]
        },
        "enhanced_rage": {
            "name": "Enhanced Rage",
            "sp_cost": 25,
            "type": "buff",
            "tier": 2,
            "prerequisites": ["rage"],
            "effects": [
                {"stat": "attack_power", "modifier": 1.5, "duration": 3},
                {"stat": "defense", "modifier": 0.9, "duration": 3}
            ]
        },
        "unstoppable_rage": {
            "name": "Unstoppable Rage",
            "sp_cost": 35,
            "type": "buff",
            "tier": 3,
            "prerequisites": ["enhanced_rage"],
            "effects": [
                {"stat": "attack_power", "modifier": 1.8, "duration": 3},
                {"stat": "defense", "modifier": 1.0, "duration": 3},
                {"type": "status_immunity", "duration": 3}
            ]
        },
        "whirlwind": {
            "name": "Whirlwind",
            "sp_cost": 35,
            "type": "attack",
            "tier": 1,
            "prerequisites": [],
            "damage_multiplier": 0.8,
            "targets": ["adjacent_enemies"]
        },
        "brutal_whirlwind": {
            "name": "Brutal Whirlwind",
            "sp_cost": 45,
            "type": "attack",
            "tier": 2,
            "prerequisites": ["whirlwind"],
            "damage_multiplier": 1.0,
            "targets": ["adjacent_enemies"],
            "effects": [
                {"type": "bleed", "damage": 10, "duration": 2}
            ]
        },

        // Mage Fire Tree
        "fireball": {
            "name": "Fireball",
            "sp_cost": 25,
            "type": "spell",
            "element": "fire",
            "tier": 1,
            "prerequisites": [],
            "range": 3,
            "damage_type": "magical",
            "effects": [
                {"type": "damage", "power": 40},
                {"type": "status", "name": "burn", "duration": 2}
            ]
        },
        "inferno": {
            "name": "Inferno",
            "sp_cost": 40,
            "type": "spell",
            "element": "fire",
            "tier": 2,
            "prerequisites": ["fireball"],
            "range": 3,
            "damage_type": "magical",
            "effects": [
                {"type": "damage", "power": 60},
                {"type": "status", "name": "burn", "duration": 3},
                {"type": "area_effect", "radius": 1}
            ]
        },
        "meteor": {
            "name": "Meteor",
            "sp_cost": 60,
            "type": "spell",
            "element": "fire",
            "tier": 3,
            "prerequisites": ["inferno"],
            "range": 4,
            "damage_type": "magical",
            "effects": [
                {"type": "damage", "power": 100},
                {"type": "status", "name": "burn", "duration": 3},
                {"type": "area_effect", "radius": 2},
                {"type": "terrain_effect", "type": "scorched", "duration": 3}
            ]
        },

        // Mage Ice Tree
        "frost_bolt": {
            "name": "Frost Bolt",
            "sp_cost": 20,
            "type": "spell",
            "element": "ice",
            "tier": 1,
            "prerequisites": [],
            "range": 3,
            "damage_type": "magical",
            "effects": [
                {"type": "damage", "power": 35},
                {"type": "status", "name": "slow", "movement_penalty": 1, "duration": 2}
            ]
        },
        "ice_wall": {
            "name": "Ice Wall",
            "sp_cost": 35,
            "type": "spell",
            "element": "ice",
            "tier": 2,
            "prerequisites": ["frost_bolt"],
            "range": 2,
            "damage_type": "magical",
            "effects": [
                {"type": "terrain_effect", "type": "ice_wall", "duration": 2},
                {"type": "block_movement"},
                {"type": "damage", "power": 20, "trigger": "when_crossed"}
            ]
        },
        "blizzard": {
            "name": "Blizzard",
            "sp_cost": 55,
            "type": "spell",
            "element": "ice",
            "tier": 3,
            "prerequisites": ["ice_wall"],
            "range": 4,
            "damage_type": "magical",
            "effects": [
                {"type": "damage", "power": 70},
                {"type": "area_effect", "radius": 2},
                {"type": "status", "name": "freeze", "duration": 1},
                {"type": "terrain_effect", "type": "frozen_ground", "duration": 2}
            ]
        },

        // Mage Wind Tree
        "gust": {
            "name": "Gust",
            "sp_cost": 20,
            "type": "spell",
            "element": "wind",
            "tier": 1,
            "prerequisites": [],
            "range": 2,
            "damage_type": "magical",
            "effects": [
                {"type": "damage", "power": 25},
                {"type": "knockback", "distance": 2}
            ]
        },
        "wind_barrier": {
            "name": "Wind Barrier",
            "sp_cost": 30,
            "type": "spell",
            "element": "wind",
            "tier": 2,
            "prerequisites": ["gust"],
            "range": 3,
            "damage_type": "magical",
            "effects": [
                {"type": "buff", "stat": "defense", "modifier": 1.3, "duration": 3},
                {"type": "status", "name": "deflect_projectiles", "duration": 2}
            ]
        },
        "tornado": {
            "name": "Tornado",
            "sp_cost": 50,
            "type": "spell",
            "element": "wind",
            "tier": 3,
            "prerequisites": ["wind_barrier"],
            "range": 3,
            "damage_type": "magical",
            "effects": [
                {"type": "damage", "power": 60},
                {"type": "area_effect", "radius": 1, "movement": "linear"},
                {"type": "pull", "strength": 2},
                {"type": "status", "name": "airborne", "duration": 1}
            ]
        },

        // Mage Light Tree
        "divine_light": {
            "name": "Divine Light",
            "sp_cost": 25,
            "type": "spell",
            "element": "light",
            "tier": 1,
            "prerequisites": [],
            "range": 3,
            "damage_type": "magical",
            "effects": [
                {"type": "heal", "power": 30},
                {"type": "status_clear", "types": ["blind", "curse"]}
            ]
        },
        "holy_shield": {
            "name": "Holy Shield",
            "sp_cost": 35,
            "type": "spell",
            "element": "light",
            "tier": 2,
            "prerequisites": ["divine_light"],
            "range": 3,
            "damage_type": "magical",
            "effects": [
                {"type": "buff", "stat": "defense", "modifier": 1.4, "duration": 3},
                {"type": "status", "name": "holy_protection", "duration": 2},
                {"type": "status_immunity", "duration": 2}
            ]
        },
        "judgement": {
            "name": "Judgement",
            "sp_cost": 60,
            "type": "spell",
            "element": "light",
            "tier": 3,
            "prerequisites": ["holy_shield"],
            "range": 4,
            "damage_type": "magical",
            "effects": [
                {"type": "damage", "power": 80},
                {"type": "bonus_vs_type", "target_type": "undead", "modifier": 2.0},
                {"type": "area_effect", "radius": 2},
                {"type": "heal", "power": 40, "targets": "allies"}
            ]
        },

        // Dark Knight Tree
        "dark_slash": {
            "name": "Dark Slash",
            "sp_cost": 30,
            "type": "attack",
            "tier": 1,
            "prerequisites": [],
            "effects": [
                {"type": "damage", "power": 35},
                {"type": "lifesteal", "percentage": 0.3}
            ]
        },
        "soul_drain": {
            "name": "Soul Drain",
            "sp_cost": 45,
            "type": "attack",
            "tier": 2,
            "prerequisites": ["dark_slash"],
            "effects": [
                {"type": "damage", "power": 45},
                {"type": "lifesteal", "percentage": 0.5},
                {"type": "sp_drain", "amount": 15}
            ]
        },
        "death_blade": {
            "name": "Death Blade",
            "sp_cost": 60,
            "type": "attack",
            "tier": 3,
            "prerequisites": ["soul_drain"],
            "effects": [
                {"type": "damage", "power": 70},
                {"type": "lifesteal", "percentage": 0.6},
                {"type": "execute", "threshold": 0.3}
            ]
        },

        // Grappler Tree
        "throw": {
            "name": "Throw",
            "sp_cost": 25,
            "type": "utility",
            "tier": 1,
            "prerequisites": [],
            "effects": [
                {"type": "move_target", "range": 2},
                {"type": "damage", "power": 15}
            ]
        },
        "mighty_throw": {
            "name": "Mighty Throw",
            "sp_cost": 35,
            "type": "utility",
            "tier": 2,
            "prerequisites": ["throw"],
            "effects": [
                {"type": "move_target", "range": 3},
                {"type": "damage", "power": 25},
                {"type": "stun", "duration": 1}
            ]
        },
        "chain_throw": {
            "name": "Chain Throw",
            "sp_cost": 50,
            "type": "utility",
            "tier": 3,
            "prerequisites": ["mighty_throw"],
            "effects": [
                {"type": "move_target", "range": 3},
                {"type": "damage", "power": 35},
                {"type": "stun", "duration": 1},
                {"type": "extra_action", "condition": "if_kills_target"}
            ]
        },

        // Archer Tree
        "power_shot": {
            "name": "Power Shot",
            "sp_cost": 30,
            "type": "attack",
            "tier": 1,
            "prerequisites": [],
            "range": 4,
            "effects": [
                {"type": "damage", "power": 45},
                {"type": "knockback", "distance": 1}
            ]
        },
        "piercing_shot": {
            "name": "Piercing Shot",
            "sp_cost": 40,
            "type": "attack",
            "tier": 2,
            "prerequisites": ["power_shot"],
            "range": 5,
            "effects": [
                {"type": "damage", "power": 55},
                {"type": "pierce", "targets": 2},
                {"type": "defense_reduction", "amount": 0.2, "duration": 2}
            ]
        },
        "rain_of_arrows": {
            "name": "Rain of Arrows",
            "sp_cost": 55,
            "type": "attack",
            "tier": 3,
            "prerequisites": ["piercing_shot"],
            "range": 6,
            "effects": [
                {"type": "damage", "power": 35},
                {"type": "area_effect", "radius": 2},
                {"type": "terrain_effect", "type": "difficult_terrain", "duration": 2}
            ]
        }
    };
    
    return ability_templates;
}

/// @function get_ability_template(ability_id)
/// @param {String} ability_id The ID of the ability to get data for
/// @returns {Struct} The ability template data or undefined if not found
function get_ability_template(ability_id) {
    var templates = get_ability_templates();
    return variable_struct_get(templates, ability_id);
}

/// @function get_available_abilities()
/// @returns {Array} Array of available ability IDs
function get_available_abilities() {
    var templates = get_ability_templates();
    return variable_struct_get_names(templates);
}

/// @function get_abilities_by_tier(tier)
/// @param {Real} tier The tier number to filter by
/// @returns {Array} Array of ability IDs in the specified tier
function get_abilities_by_tier(tier) {
    var templates = get_ability_templates();
    var tier_abilities = [];
    
    var ability_ids = variable_struct_get_names(templates);
    for (var i = 0; i < array_length(ability_ids); i++) {
        var ability = templates[$ ability_ids[i]];
        if (ability.tier == tier) {
            array_push(tier_abilities, ability_ids[i]);
        }
    }
    
    return tier_abilities;
}

/// @function get_abilities_by_element(element)
/// @param {String} element The element to filter by ("fire", "ice", "wind", "light")
/// @returns {Array} Array of ability IDs for the specified element
function get_abilities_by_element(element) {
    var templates = get_ability_templates();
    var element_abilities = [];
    
    var ability_ids = variable_struct_get_names(templates);
    for (var i = 0; i < array_length(ability_ids); i++) {
        var ability = templates[$ ability_ids[i]];
        if (variable_struct_exists(ability, "element") && ability.element == element) {
            array_push(element_abilities, ability_ids[i]);
        }
    }
    
    return element_abilities;
}

/// @function can_learn_ability(unit_type, ability_id)
/// @param {String} unit_type The type of unit to check
/// @param {String} ability_id The ability to check if learnable
/// @returns {Bool} Whether the unit can learn this ability
function can_learn_ability(unit_type, ability_id) {
    var unit_template = get_unit_template(unit_type);
    if (unit_template == undefined) return false;
    
    var ability = get_ability_template(ability_id);
    if (ability == undefined) return false;
    
    // Check if unit has all prerequisites
    var prerequisites = ability.prerequisites;
    for (var i = 0; i < array_length(prerequisites); i++) {
        var prereq_id = prerequisites[i];
        if (!array_contains(unit_template.ability_ids, prereq_id)) {
            return false;
        }
    }
    
    return true;
}