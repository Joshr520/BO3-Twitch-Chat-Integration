init()
{
}

on_player_connect()
{
    SetDvar("sv_cheats", 1);
    SetDvar("scr_firstGumFree",1);
	SetDvar("zm_private_rankedmatch",1);
    level.player_out_of_playable_area_monitor = 0;
    level.perk_purchase_limit = 20;
}

on_player_spawned()
{
    //self.score = 50000;
    //self EnableInvulnerability();

    if(level.script == "zm_stalingrad")
    {
        level.sewer_active = 0;
        level.entering_boss = 0;
        self thread stalingrad_sewer_check();
        self thread stalingrad_boss_check();
    }
    if(level.script == "zm_tomb")
    {
        self thread watch_upgraded_staff();
    }

    level flag::wait_till("initial_blackscreen_passed");

    thread twitch_chat_watcher();
}

twitch_chat_watcher()
{
    for(;;)
    {
        choose_event = compiler::returnFileInt();
        
        switch(choose_event)
        {
            case 0:
                break;
            case 1:
                self thread spawn_special_boss(1);
                break;
            case 2:
                self thread spawn_special_boss(3);
                break;
            case 3:
                self thread spawn_special_boss(6);
                break;
            case 4:
                self thread spawn_special_boss(15);
                break;
            case 5:
                self thread remove_random_perk();
                break;
            case 6:
                self thread zm_perks::give_random_perk();
                break;
            case 7:
                self thread remove_all_perks();
                break;
            case 8:
                self thread give_all_perks();
                break;
            case 9:
                self thread random_gun_aat();
                break;
            case 10:
                self thread remove_aat();
                break;
            case 11:
                self thread give_random_weapon(0);
                break;
            case 12:
                self thread give_random_weapon(1);
                break;
            case 13:
                self thread drop_weapon();
                break;
            case 14:
                self thread random_teleport();
                break;
            case 15:
                self thread low_gravity();
                break;
            case 16:
                self thread ignore_player();
                break;
            case 17:
                self thread set_timescale(3);
                break;
            case 18:
                self thread set_timescale(0.33);
                break;
            case 19:
                self thread set_player_speed(5);
                break;
            case 20:
                self thread set_player_speed(0.5);
                break;
            case 21:
                self thread set_infinite_ammo();
                break;
            case 22:
                self thread update_zombie_movement("walk");
                break;
            case 23:
                self thread update_zombie_movement("run");
                break;
            case 24:
                self thread update_zombie_movement("sprint");
                break;
            case 25:
                self thread lock_round();
                break;
            case 26:
                self thread increase_zombie_limit();
                break;
            case 27:
                self thread create_turned_army("friendly");
                break;
            case 28:
                self thread create_turned_army("enemy");
                break;
            case 29:
                self thread set_third_person();
                break;
            case 30:
                self thread set_fov(65);
                break;
            case 31:
                self.score += 1000;
                break;
            case 32:
                self.score += 5000;
                break;
            case 33:
                self.score += 15000;
                break;
            case 34:
                self.score += 50000;
                break;
            case 35:
                self.score -= 1000;
                break;
            case 36:
                self.score -= 5000;
                break;
            case 37:
                self.score -= 15000;
                break;
            case 38:
                self.score = 0;
                break;
            case 39:
                Map_Restart(0);
                break;
            case 40:
                self thread give_bgb(1);
                break;
            case 41:
                self thread give_bgb(0);
                break;
            case 42:
                self thread take_bgb();
                break;
            case 43:
                self thread give_wonder_weapon(1);
                break;
            case 44:
                self thread give_wonder_weapon(0);
                break;
            case 45:
                self thread upgrade_weapon();
                break;
            case 46:
                self thread downgrade_weapon();
                break;
            case 47:
                self thread enter_beast_mode();
                break;
            case 48:
                self thread exit_beast_mode();
                break;
            case 49:
                self thread end_round();
                break;
            case 50:
                self thread disable_ads();
                break;
            case 51:
                self thread disable_crouch();
                break;
            case 52:
                self thread enable_double_jump();
                break;
            case 53:
                self thread disable_jump();
                break;
            case 54:
                self thread disable_melee();
                break;
            case 55:
                self thread disable_prone();
                break;
            case 56:
                self thread disable_slide();
                break;
            case 57:
                self thread disable_sprint();
                break;
            case 58:
                self thread rapidly_misplace_character();
                break;
            case 59:
                self SetWeaponAmmoStock(self GetCurrentWeapon(), 0);
                break;
            case 60:
                self thread random_blackscreens();
                break;
            case 61:
                level.var_de98a8ad = 1;
                break;
            case 62:
                level.var_de98a8ad = 0;
                break;
            case 63:
                self thread randomize_valves();
                break;
            case 64:
                self thread randomize_password();
                break;
            case 65:
                self thread down_player();
                break;
            case 66:
                self notify("bgb_activation_request");
                break;
            case 67:
                self thread give_riotshield();
                break;
            case 68:
                self thread set_invisible_toggle_shoot();
                break;
            case 69:
                self thread spawn_drop_on_player();
                break;
            case 70:
                self thread give_hero_weapon();
                break;
            case 71:
                self thread give_equipment();
                break;
        }
        wait 0.05;
    }
}