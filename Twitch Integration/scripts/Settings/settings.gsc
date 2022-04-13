autoexec initialize_settings()
{
    level.drop_weapon_no_take = 0;                              // 1 = drop weapon instead of taking it - only works for give random weapon
    level.increase_zombie_limit_time = 90;                      // How long to increase zombie limit for
    level.zombie_death_time_limit_time = 40;                    // How long to wait before killing turned army
    level.set_invisible_toggle_shoot_time = 45;                 // How long to toggle zombies invisible unless shooting
    level.set_timescale_time = 20   ;                           // How long until disabling timescale
    level.set_player_speed_time = 30;                           // How long to enable new player speed
    level.set_infinite_ammo_time = 30;                          // How long to enable infinite ammo for
    level.set_third_person_time = 20;                           // How long to enable third person for
    level.set_fov_time = 15;                                    // How long until disabling low fov
    level.ignore_player_time = 20;                              // How long for zombies to ignore player
    level.low_gravity_time = 30;                                // How long until disabling low gravity
    level.disable_ads_time = 30;                                // How long to disable ads for
    level.disable_crouch_time = 30;                             // How long to disable crouch for
    level.enable_double_jump_time = 60;                         // How long to enable double jump for
    level.disable_jump_time = 30;                               // How long to disable jump for
    level.disable_melee_time = 30;                              // How long to disable melee for
    level.disable_prone_time = 30;                              // How long to disable prone for
    level.disable_slide_time = 30;                              // How long to disable slide for
    level.disable_sprint_time = 30;                             // How long to disable sprint for
    level.lock_round_time = 180;                                // How long to lock the current round
}