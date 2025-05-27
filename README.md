# GameMaker Tactical Turn-Based System Engine

## Overview

This is a complete tactical turn-based strategy (TBS) game engine built for GameMaker Studio 2 (v2024.6.2.162 to v2024.13.1.193). The engine provides a solid foundation for creating tactical RPGs, strategy games, or board game adaptations with hexagonal grid-based combat.

## Core Features

### ⬡ Hexagonal Grid System

- **15x12 hexagonal grid** with proper coordinate conversion
- **Axial coordinate system** for consistent neighbor calculations
- **Visual grid highlighting** for movement (blue), attacks (red), and selection (green)
- **Flood-fill pathfinding** for accurate movement range calculation

### 🎮 Turn-Based Combat

- **Alternating team turns** (Player vs Enemy)
- **Flexible action system** - units can move and attack in any order
- **Individual unit management** with persistent action states
- **Win/lose conditions** with proper game over handling

### 👥 Unit Management

- **Up to 10 units per side** (easily expandable)
- **Core unit attributes**: Health Points, Skill Points, Attack, Defense, Movement Range
- **Action tracking**: Move, Attack, Wait actions with independent execution
- **Team-based combat** with visual team indicators

### 🧠 AI System

- **Basic enemy AI** that moves toward and attacks player units
- **Pathfinding integration** for intelligent movement decisions
- **Turn management** with automatic AI execution
- **Expandable framework** for more complex AI behaviors

## Technical Architecture

### Core Objects

#### `obj_grid_manager`

- **Purpose**: Manages the hexagonal grid, pathfinding, and visual highlights
- **Key Responsibilities**:
  - Grid coordinate conversion (hex ↔ pixel)
  - Movement range calculation using flood-fill algorithm
  - Attack range determination
  - Visual highlighting system
  - Grid state management

#### `obj_game_manager`

- **Purpose**: Controls game flow, turn management, and win conditions
- **Key Responsibilities**:
  - Turn alternation between teams
  - Unit list management (player/enemy arrays)
  - Win/lose condition checking
  - AI turn triggering
  - Game state management (playing/victory/defeat)

#### `obj_unit`

- **Purpose**: Individual unit behavior and state management
- **Key Responsibilities**:
  - Unit statistics and health management
  - Action state tracking (moved/acted flags)
  - Input handling for selection and commands
  - Visual representation with health bars and team colors

### Script Architecture

The engine uses a modular script-based approach with clear separation of concerns:

#### Grid Management Scripts

- `hex_to_pixel()` - Convert hex coordinates to screen position
- `pixel_to_hex()` - Convert mouse/screen position to hex coordinates
- `place_unit_on_grid()` - Position units on the grid safely
- `get_unit_at()` - Retrieve unit at specific grid position
- `is_valid_position()` - Validate grid coordinates

#### Movement & Combat Scripts

- `calculate_movement_range()` - Flood-fill pathfinding for movement
- `calculate_attack_range()` - Determine valid attack targets
- `execute_attack()` - Handle combat resolution and damage
- `get_hex_neighbors()` - Get adjacent hexagonal tiles

#### Unit Control Scripts

- `scr_unit_select()` - Unit selection with action highlighting
- `scr_unit_handle_action()` - Process movement and attack commands
- `scr_unit_update_pixel_position()` - Sync unit visual position
- `scr_unit_wait()` - End unit turn early

#### Game Flow Scripts

- `scr_game_initialize()` - Set up initial unit placement
- `scr_game_end_turn()` - Handle turn transitions
- `scr_game_check_win_condition()` - Evaluate victory/defeat
- `scr_game_simple_ai()` - Basic enemy AI behavior

#### AI Helper Scripts

- `scr_ai_find_nearest_enemy()` - Target selection for AI
- `scr_ai_move_towards()` - Pathfinding movement for AI
- `scr_hex_distance()` - Calculate distance between hexes

## Gameplay Mechanics

### Unit Actions

Each unit can perform **two independent actions per turn**:

1. **Move** - Relocate within movement range (blue highlighted tiles)
2. **Attack** - Damage adjacent enemy units (red highlighted tiles)
3. **Wait** - End turn early (right-click)

**Key Features:**

- ✅ **Flexible action order** - attack first then move, or move first then attack
- ✅ **Action independence** - can perform only one action if desired
- ✅ **Visual feedback** - clear indicators for available actions
- ✅ **Persistent selection** - unit stays selected until both actions used

### Combat System

- **Adjacent-only attacks** (traditional tactical RPG style)
- **Damage calculation**: `max(1, Attack - Defense)`
- **Health management** with visual health bars
- **Unit elimination** with proper cleanup and team list management

### Turn Management

- **Player Phase**: Interactive unit selection and command input
- **Enemy Phase**: Automated AI decision making
- **Turn Counter**: Tracks game progression
- **Space Bar**: Manual turn ending

### Win Conditions

- **Player Victory**: Eliminate all enemy units
- **Player Defeat**: Lose all player units
- **Game Over Screen**: Victory/defeat display with restart options

## User Interface

### HUD Elements

- **Turn Information**: Current turn number and active team
- **Unit Statistics**: HP, SP, Attack, Defense, Movement for selected unit
- **Action Status**: Visual indicators for completed/available actions
- **Unit Counters**: Live count of remaining units per team

### Visual Feedback

- **Grid Highlighting**:
  - 🔵 Blue: Valid movement positions
  - 🔴 Red: Valid attack targets
  - 🟢 Green: Currently selected unit
- **Unit Indicators**:
  - Health bars above units
  - Team color markers (blue/red dots)
  - Selection highlight rings

### Controls

- **Left Click**: Select units, move, attack
- **Right Click**: Wait (end unit turn early)
- **Space Bar**: End current team's turn
- **R Key**: Restart game (when game over)
- **ESC Key**: Quit game (when game over)

## Technical Implementation Details

### Coordinate System

Uses **axial coordinates** for hexagonal grids:

- More consistent than offset coordinates
- Simplified neighbor calculations
- Single direction array for all hexes
- Proper distance calculations

### GameMaker Integration

- **Avoids built-in variable conflicts** (renamed `speed` to `movement_range`)
- **Proper object creation order** (grid manager → game manager → units)
- **Layer management** for visual depth sorting
- **Memory cleanup** for destroyed units

### Performance Considerations

- **Efficient pathfinding** with early termination
- **Minimal redraw operations** for grid highlights
- **Object pooling ready** architecture for larger games
- **Debug output** removable for production builds

## Extensibility

The engine is designed for easy expansion:

### Adding New Unit Types

```gml
// Create specialized unit objects inheriting from obj_unit
// Override movement_range, attack_power, special abilities
```

### Enhanced AI

```gml
// Extend AI scripts with:
// - Formation tactics
// - Ability usage
// - Defensive positioning
// - Multi-turn planning
```

### Additional Mechanics

- **Terrain effects** (movement cost, defense bonuses)
- **Special abilities** (healing, ranged attacks, area effects)
- **Equipment system** (weapons, armor, items)
- **Experience/leveling** (stat progression)
- **Multiple win conditions** (objectives, time limits)

### Visual Enhancements

- **Animated units** (movement interpolation, attack animations)
- **Particle effects** (combat effects, spell casting)
- **Advanced UI** (drag-and-drop, tooltips, detailed panels)

## Setup Instructions

### Requirements

- GameMaker Studio 2 (v2024.6.2.162 or later)
- Basic sprite: `spr_unit` (32x32 recommended)

### Installation Steps

1. **Create Objects** (in order):

   - `obj_grid_manager`
   - `obj_game_manager`
   - `obj_unit`

2. **Import Scripts**: Copy all provided scripts into your project

3. **Setup Room**:

   - Create layers: "Grid", "Units", "UI"
   - Place one `obj_grid_manager` instance
   - Place one `obj_game_manager` instance
   - Set **Instance Creation Order**: grid manager first, then game manager
   - Do not manually place unit instances (auto-created)

4. **Configure Sprites**: Ensure `spr_unit` exists with proper origin point

### First Run

- Game automatically creates 5 player units (blue) and 5 enemy units (red)
- Player units start at top row, enemies at bottom row
- Click units to select, click tiles to move/attack
- Press Space to end turns, right-click to wait

## Development History & Lessons Learned

This engine was developed through iterative problem-solving, addressing common GameMaker gotchas:

### Key Challenges Solved

1. **Variable Name Conflicts**: GameMaker's built-in `speed` variable caused unwanted movement
2. **Object Creation Order**: Grid manager must exist before units for proper positioning
3. **Coordinate System Complexity**: Switched from offset to axial coordinates for consistency
4. **Action System Design**: Evolved from rigid to flexible action ordering
5. **Win Condition Handling**: Proper game state management prevents post-victory issues

### Best Practices Applied

- **Script-based architecture** over embedded object methods
- **Proper `with` statements** for cross-object variable access
- **Defensive programming** with validation and fallbacks
- **Clear separation of concerns** between objects and scripts
- **Comprehensive debugging output** during development

## Future Development

Potential areas for enhancement:

### Immediate Improvements

- **Save/Load system** for game persistence
- **Multiple maps/scenarios** with different layouts
- **Unit customization** interface
- **Sound effects and music** integration

### Advanced Features

- **Multiplayer support** (local or networked)
- **Campaign mode** with story progression
- **Level editor** for custom maps
- **Mod support** for community content

### Performance Optimization

- **Object pooling** for large battles
- **Spatial partitioning** for collision detection
- **Asset streaming** for memory management
- **Mobile optimization** for touch controls

---

## Conclusion

This tactical turn-based system provides a robust foundation for strategy games in GameMaker Studio 2. The modular architecture, comprehensive feature set, and extensible design make it suitable for both learning purposes and production game development.

The engine successfully demonstrates key concepts in game development including grid-based movement, turn management, AI implementation, and user interface design while maintaining clean, maintainable code structure.

**Ready to create your tactical masterpiece!** ⚔️🎮
