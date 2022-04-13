ignore_player()
{
    self.ignoreme = 1;
    wait level.ignore_player_time;
    self.ignoreme = 0;
}

low_gravity()
{
    self setPerk("specialty_lowgravity");
    wait level.low_gravity_time;
    self unsetPerk("specialty_lowgravity");
}

random_teleport()
{
    if(!isdefined(level.random_tp_locations)) add_random_tp_locations();
    while(!teleport_validation()) wait 0.05;
}

teleport_validation()
{
    if(is_true(self.b_teleporting) || is_true(self.teleporting)) return 0;
    if(level flag::get("boss_fight_begin") && !level flag::get("boss_fight_completed")) return 0;
    if(self clientfield::get_to_player("flinger_flying_postfx")) return 0;
    if(level flag::get("flag_sewer_in_use_interior") || level flag::get("flag_sewer_in_use_exterior") || level flag::get("flag_zipline_in_use") || level flag::get("elevator_in_use")) return 0;
    if(isdefined(level flag::get("takeo_freed")) && !level flag::get("takeo_freed")) return 0;
    if(level flag::get("dragon_full") || level.sewer_active || level.entering_boss) return 0;
    if(level flag::get("lockdown_active") || level flag::get("players_in_arena")) return 0;
    if(level flag::get("boss_fight") || level flag::get("arena_occupied_by_player")) return 0;
    if(self IsTouching(GetEnt("samanthas_room_zone", "targetname"))) return 0;
    if(is_true(self.in_giant_robot_head)) return 0;
    if(level flag::get("lander_inuse")) return 0;
    return 1;
}

stalingrad_sewer_check()
{
    sewer = GetEnt("transport_pavlovs_to_fountain", "targetname");
    for(;;)
    {
        sewer waittill("trigger", e_who);
        level waittill("player_exited_sewer");
        level.sewer_active = 0;
    }
}

stalingrad_boss_check()
{
    sewer = GetEnt("ee_sewer_to_arena_trig", "targetname");
    sewer waittill("trigger", e_who);
    level.entering_boss = 1;
    self thread perma_qr();
    level waittill("player_enter_boss_arena");
    level.entering_boss = 0;
}

perma_qr()
{
    while(level.entering_boss)
    {
        if(!self HasPerk("specialty_quickrevive")) self zm_perks::give_perk("specialty_quickrevive", 0);
        wait 1;
    }
}

enter_beast_mode()
{
    if(level.script != "zm_zod") return;
    while(self.altbody) wait 0.05;
    self thread player_altbody("beast_mode", spawnstruct());
}

exit_beast_mode()
{
    if(level.script != "zm_zod") return;
    while(!self.altbody) wait 0.05;
    self notify("altbody_end");
}

disable_ads()
{
    self AllowAds(false);
    wait level.disable_ads_time;
    self AllowAds(true);
}

disable_crouch()
{
    self AllowCrouch(false);
    wait level.disable_crouch_time;
    self AllowCrouch(true);
}

enable_double_jump()
{
    self AllowDoubleJump(true);
    wait level.enable_double_jump_time;
    self AllowDoubleJump(false);
}

disable_jump()
{
    self AllowJump(false);
    wait level.disable_jump_time;
    self AllowJump(true);
}

disable_melee()
{
    self AllowMelee(false);
    wait level.disable_melee_time;
    self AllowMelee(true);
}

disable_prone()
{
    self AllowProne(false);
    wait level.disable_prone_time;
    self AllowProne(true);
}

disable_slide()
{
    self AllowSlide(false);
    wait level.disable_slide_time;
    self AllowSlide(true);
}

disable_sprint()
{
    self AllowSprint(false);
    wait level.disable_sprint_time;
    self AllowSprint(true);
}

rapidly_misplace_character()
{
    for(i = 0; i < 10; i++)
    {
        if(math::cointoss())
        {
            if(math::cointoss()) self ApplyKnockBack(99, AnglesToForward(self.angles));
            else self ApplyKnockBack(99, AnglesToForward(self.angles) * -1);
        }
        else
        {
            if(math::cointoss()) self ApplyKnockBack(99, AnglesToRight(self.angles));
            else self ApplyKnockBack(99, AnglesToRight(self.angles) * -1);
        }
        wait 0.05;
    }
}

random_blackscreens()
{
    for(i = 0; i < 5; i++)
    {
        self thread lui::screen_flash(0.15, 0.75, 0.35, 0.95, "black");
        wait randomFloatRange(0.9, 2.5);
    }
}

down_player()
{
    if(!self HasPerk("specialty_quickrevive")) self zm_perks::give_perk("specialty_quickrevive", 0);
    self DoDamage(self.health + 100, self.origin);
}

spawn_drop_on_player()
{
    powerup = array::random(level.zombie_powerup_array);
    spawn_powerup = zm_powerups::specific_powerup_drop(powerup, self.origin);
}