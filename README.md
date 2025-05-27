# simple-srpg-hexagon-engine

## Setup Instructions

### Create the required sprites:

spr_unit: A simple 32x32 sprite for units

Create the required objects IN THIS ORDER:

obj_grid_manager (create first)
obj_game_manager
obj_unit

### Create the required scripts with the code provided above

Set up your room with CREATION ORDER:

One instance of obj_grid_manager (Instance Creation Order: 0)
One instance of obj_game_manager (Instance Creation Order: 1)
Create layers: "Grid", "Units", "UI"
Do NOT manually place obj_unit instances - they are created by the game manager

IMPORTANT: Set the Instance Creation Order in your room:

Right-click in the room editor
Go to "Instance Creation Order"
Make sure obj_grid_manager is created before obj_game_manager

## The system supports:

Hexagonal grid movement
Turn-based gameplay
Unit selection and movement
Basic combat system
Up to 10 units per side (easily expandable)

## Usage

Left-click to select units
Left-click on highlighted tiles to move or attack
Press SPACE to end your turn
Blue highlights show movement range
Red highlights show attack targets

This engine provides a solid foundation that you can expand with additional features like different unit types, special abilities, terrain effects, and more complex AI.
