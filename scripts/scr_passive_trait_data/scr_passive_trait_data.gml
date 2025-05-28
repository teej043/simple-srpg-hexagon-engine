/// @description Passive trait data management and templates

function get_passive_trait_templates() {
    static passive_trait_templates = {
        "berserk": {
            "name": "Berserk",
            "description": "Increases attack power when HP is low",
            "trigger": "hp_below_30_percent",
            "effects": [
                {"stat": "attack_power", "modifier": 1.3}
            ]
        },
        "mana_shield": {
            "name": "Mana Shield",
            "description": "Reduces damage by spending SP",
            "trigger": "when_damaged",
            "sp_cost_per_damage": 2,
            "damage_reduction": 0.5
        },
        "long_range": {
            "name": "Long Range Mastery",
            "description": "Increases damage based on distance to target",
            "trigger": "on_attack",
            "bonus_damage_per_tile": 5,
            "max_bonus": 20
        },
        "battle_hardened": {
            "name": "Battle Hardened",
            "description": "Gains defense when taking damage",
            "trigger": "when_damaged",
            "effects": [
                {"stat": "defense", "modifier": 1.1, "duration": 2, "stacks": true, "max_stacks": 3}
            ]
        },
        "spell_weaver": {
            "name": "Spell Weaver",
            "description": "Reduces SP cost of subsequent spells",
            "trigger": "on_spell_cast",
            "effects": [
                {"type": "sp_cost_reduction", "amount": 5, "duration": 2}
            ]
        },
        "momentum": {
            "name": "Momentum",
            "description": "Gains movement after defeating an enemy",
            "trigger": "on_kill",
            "effects": [
                {"type": "reset_movement", "chance": 0.5}
            ]
        }
    };
    
    return passive_trait_templates;
}

/// @function get_passive_trait_template(trait_id)
/// @param {String} trait_id The ID of the passive trait to get data for
/// @returns {Struct} The passive trait template data or undefined if not found
function get_passive_trait_template(trait_id) {
    var templates = get_passive_trait_templates();
    return variable_struct_get(templates, trait_id);
}

/// @function get_available_passive_traits()
/// @returns {Array} Array of available passive trait IDs
function get_available_passive_traits() {
    var templates = get_passive_trait_templates();
    return variable_struct_get_names(templates);
}