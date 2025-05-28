/// @description Skip AI unit animation
// Find the currently moving AI unit and skip its animation
with (obj_unit) {
    if (team == 1 && is_moving) {
        skip_animation = true;
    }
} 