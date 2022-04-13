random_gun_aat()
{
    self thread AAT::acquire(self GetCurrentWeapon());
}

remove_aat()
{
    current_weapon = self GetCurrentWeapon();
    while(!isdefined(AAT::getAATOnWeapon(current_weapon))) wait 0.5;
    self thread AAT::remove(current_weapon);
    self clientfield::set_to_player("aat_current", 0);
}

drop_weapon()
{
    while(!self take_Weapon_validation() || is_true(self.altbody) || is_true(self.b_teleporting) || is_true(self.teleporting) || level flag::get("dragon_full") || level.sewer_active || level.entering_boss || self clientfield::get_to_player("flinger_flying_postfx") || level flag::get("flag_sewer_in_use_interior") || level flag::get("flag_sewer_in_use_exterior") || level flag::get("flag_zipline_in_use") || level flag::get("elevator_in_use") || self IsTouching(GetEnt("samanthas_room_zone", "targetname")) || is_true(self.in_giant_robot_head) || level flag::get("lander_inuse")) wait 0.05;
    self DropItem(self GetCurrentWeapon());
}

give_wonder_weapon(upgraded)
{
    wait_state_change = 0;
    while(is_true(self.altbody) || is_true(self.b_teleporting) || is_true(self.teleporting))
    {
        wait_state_change = 1;
        wait 0.05;
    }
    if(wait_state_change) wait 2;
    wait_state_change = 0;
    while(!self take_Weapon_validation())
    {
        wait_state_change = 1;
        wait 0.5;
    }
    if(wait_state_change) wait 1;
    switch(level.script)
    {
        case "zm_zod":
            if(upgraded) zm_weapons::weapon_give(GetWeapon("idgun_upgraded_0"));
            else zm_weapons::weapon_give(GetWeapon("idgun_0"));
            break;
		case "zm_factory":
            if(upgraded) zm_weapons::weapon_give(level.weaponZMTeslaGunUpgraded);
            else zm_weapons::weapon_give(level.weaponZMTeslaGun);
			break;
		case "zm_castle":
            if(upgraded) zm_weapons::weapon_give(Array::random(array(level.var_e93874ed, level.var_edf1e590, level.var_fb620116, level.var_16e90d5f)));
            else zm_weapons::weapon_give(level.var_be94cdb);
			break;
		case "zm_island":
            if(upgraded) zm_weapons::weapon_give(level.var_a4052592);
            else zm_weapons::weapon_give(level.var_5e75629a);
			break;
		case "zm_stalingrad":
            if(upgraded) zm_weapons::weapon_give(level.w_raygun_mark3);
            else zm_weapons::weapon_give(level.w_raygun_mark3_upgraded);
			break;
		case "zm_genesis":
            if(math::cointoss())
            {
                if(upgraded) zm_weapons::weapon_give(level.weaponZMThunderGunUpgraded);
                else zm_weapons::weapon_give(level.weaponZMThunderGun);
            }
            else
            {
                if(upgraded) zm_weapons::weapon_give(level.var_9727e47e);
                else zm_weapons::weapon_give(level.var_ed2646a1);
            }
            break;
		case "zm_prototype":
            if(math::cointoss())
            {
                if(upgraded) zm_weapons::weapon_give(GetWeapon("raygun_mark2_upgraded"));
                else zm_weapons::weapon_give(GetWeapon("raygun_mark2"));
            }
            else
            {
                if(upgraded) zm_weapons::weapon_give(level.weaponZMThunderGunUpgraded);
                else zm_weapons::weapon_give(level.weaponZMThunderGun);
            }
            break;
		case "zm_asylum":
            if(math::cointoss())
            {
                if(upgraded) zm_weapons::weapon_give(GetWeapon("raygun_mark2_upgraded"));
                else zm_weapons::weapon_give(GetWeapon("raygun_mark2"));
            }
            else
            {
                if(upgraded) zm_weapons::weapon_give(level.weaponZMTeslaGunUpgraded);
                else zm_weapons::weapon_give(level.weaponZMTeslaGun);
            }
			break;
		case "zm_sumpf":
            if(math::cointoss())
            {
                if(upgraded) zm_weapons::weapon_give(GetWeapon("raygun_mark2_upgraded"));
                else zm_weapons::weapon_give(GetWeapon("raygun_mark2"));
            }
            else
            {
                if(upgraded) zm_weapons::weapon_give(level.weaponZMTeslaGunUpgraded);
                else zm_weapons::weapon_give(level.weaponZMTeslaGun);
            }
			break;
		case "zm_theater":
            if(math::cointoss())
            {
                if(upgraded) zm_weapons::weapon_give(GetWeapon("raygun_mark2_upgraded"));
                else zm_weapons::weapon_give(GetWeapon("raygun_mark2"));
            }
            else
            {
                if(upgraded) zm_weapons::weapon_give(level.weaponZMThunderGunUpgraded);
                else zm_weapons::weapon_give(level.weaponZMThunderGun);
            }
            break;
		case "zm_cosmodrome":
            if(math::cointoss())
            {
                if(upgraded) zm_weapons::weapon_give(GetWeapon("raygun_mark2_upgraded"));
                else zm_weapons::weapon_give(GetWeapon("raygun_mark2"));
            }
            else
            {
                if(upgraded) zm_weapons::weapon_give(level.weaponZMThunderGunUpgraded);
                else zm_weapons::weapon_give(level.weaponZMThunderGun);
            }
            break;
		case "zm_temple":
            if(math::cointoss())
            {
                if(upgraded) zm_weapons::weapon_give(GetWeapon("raygun_mark2_upgraded"));
                else zm_weapons::weapon_give(GetWeapon("raygun_mark2"));
            }
            else
            {
                if(upgraded) zm_weapons::weapon_give(level.var_953f69a0);
                else zm_weapons::weapon_give(level.var_f812085);
            }
            break;
		case "zm_moon":
            if(math::cointoss())
            {
                if(upgraded) zm_weapons::weapon_give(GetWeapon("raygun_mark2_upgraded"));
                else zm_weapons::weapon_give(GetWeapon("raygun_mark2"));
            }
            else
            {
                if(upgraded) zm_weapons::weapon_give(level.var_5736548e);
                else zm_weapons::weapon_give(level.var_9c43352b);
            }
            break;
		case "zm_tomb":
            if(upgraded) zm_weapons::weapon_give(Array::random(array(level._limited_equipment[1], level._limited_equipment[2], level._limited_equipment[3], level._limited_equipment[4])));
            else
            {
                zm_weapons::weapon_give(Array::random(array(GetWeapon("staff_air_upgraded"), GetWeapon("staff_fire_upgraded"), GetWeapon("staff_lightning_upgraded"), GetWeapon("staff_water_upgraded"))));
            }
            break;
    }
    wait 0.1;
    self GiveMaxAmmo(self GetCurrentWeapon());
}

give_random_weapon(upgraded)
{
    if(!upgraded) weapons = Array::randomize(GetArrayKeys(level.zombie_weapons));
    else weapons = Array::randomize(GetArrayKeys(level.zombie_weapons_upgraded));
    excluded_weapons = array("none", "frag_grenade", "knife", "cymbal_monkey", "cymbal_monkey_upgraded", "bouncingbetty", "bouncingbetty_devil", "bouncingbetty_holly", "octobomb", "octobomb_upgraded", "hero_gravityspikes", "hero_gravityspikes_melee", "castle_riotshield", "skull_gun", "launcher_dragon_fire", "launcher_dragon_strike", "dragon_gauntlet_flamethrower", "hero_annihilator", "quantum_bomb", "black_hole_bomb", "staff_water_upgraded", "staff_lightning_upgraded", "staff_fire_upgraded", "staff_air_upgraded", "beacon");
    no_switch_take = array("bowie_knife");
    foreach(weapon in weapons)
    {
        if(IsInArray(excluded_weapons, weapon.name) || self HasWeapon(weapon, 1)) continue;
        weapon = self GetBuildKitWeapon(weapon, upgraded);
		if(upgraded) weapon_options = self GetBuildKitWeaponOptions(weapon, zm_weapons::get_pack_a_punch_camo_index(weapon.pap_camo_to_use));
        else weapon_options = self GetBuildKitWeaponOptions(weapon);
		acvi = self GetBuildKitAttachmentCosmeticVariantIndexes(weapon, 0);
        wait 1;
        wait_state_change = 0;
        while(is_true(self.altbody) || is_true(self.b_teleporting) || is_true(self.teleporting))
        {
            wait_state_change = 1;
            wait 0.05;
        }
        if(wait_state_change) wait 2;
        if(!IsInArray(no_switch_take, weapon.name) && self GetWeaponsListPrimaries().size >= zm_utility::get_player_weapon_limit(self))
        {
            wait_state_change = 0;
            while(!self take_Weapon_validation())
            {
                wait_state_change = 1;
                wait 0.5;
            }
            if(wait_state_change) wait 1;
            if(!level.drop_weapon_no_take) self TakeWeapon(self GetCurrentWeapon());
            else self DropItem(self GetCurrentWeapon());
        }
        self GiveWeapon(weapon, weapon_options, acvi);
        self GiveMaxAmmo(weapon);
        if(!IsInArray(no_switch_take, weapon.name)) self SwitchToWeaponImmediate(weapon);
        return;
    }
}

upgrade_weapon()
{
    wait_state_change = 0;
    while(is_true(self.altbody) || is_true(self.b_teleporting) || is_true(self.teleporting))
    {
        wait_state_change = 1;
        wait 0.05;
    }
    if(wait_state_change) wait 2;
    wait_state_change = 0;
    while(!self take_Weapon_validation())
    {
        wait_state_change = 1;
        wait 0.5;
    }
    if(wait_state_change) wait 1;
    weapon = zm_weapons::get_upgrade_weapon(self GetCurrentWeapon(), 0);
    if(isdefined(weapon))
    {
        weapon = self GetBuildKitWeapon(weapon, 1);
        weapon_options = self GetBuildKitWeaponOptions(weapon, zm_weapons::get_pack_a_punch_camo_index(weapon.pap_camo_to_use));
        acvi = self GetBuildKitAttachmentCosmeticVariantIndexes(weapon, 0);
        self TakeWeapon(self GetCurrentWeapon());
        self GiveWeapon(weapon, weapon_options, acvi);
        self GiveMaxAmmo(weapon);
        self SwitchToWeaponImmediate(weapon);
    }
}

downgrade_weapon()
{
    wait_state_change = 0;
    while(is_true(self.altbody) || is_true(self.b_teleporting) || is_true(self.teleporting))
    {
        wait_state_change = 1;
        wait 0.05;
    }
    if(wait_state_change) wait 2;
    wait_state_change = 0;
    while(!self take_Weapon_validation())
    {
        wait_state_change = 1;
        wait 0.5;
    }
    if(wait_state_change) wait 1;
    weapon = zm_weapons::get_base_weapon(self GetCurrentWeapon());
    if(isdefined(weapon))
    {
        weapon = self GetBuildKitWeapon(weapon, 0);
        weapon_options = self GetBuildKitWeaponOptions(weapon);
        acvi = self GetBuildKitAttachmentCosmeticVariantIndexes(weapon, 0);
        self TakeWeapon(self GetCurrentWeapon());
        self GiveWeapon(weapon, weapon_options, acvi);
        self GiveMaxAmmo(weapon);
        self SwitchToWeaponImmediate(weapon);
    }
}

take_Weapon_validation()
{
    if(!isdefined(level.vehicle_watcher)) self thread vehicle_watcher();
    if(level.using_vehicle) return 0;
    if(isdefined(level.zombie_hero_weapon_list[self GetCurrentWeapon()])) return 0;
    excluded_weapons = array(level.weaponRiotshield, "launcher_dragon_strike", "launcher_dragon_strike_upgraded");
    if(IsInArray(excluded_weapons, self GetCurrentWeapon().rootweapon.name)) return 0;
    if(is_true(self.is_drinking)) return 0;
    if(self zm_utility::is_player_offhand_weapon(self GetCurrentWeapon())) return 0;
    if(self GetCurrentWeapon() == level.weaponNone) return 0;
    return 1;
}

vehicle_watcher()
{
    level.using_vehicle = 0;
    for(;;)
    {
        self waittill("enter_vehicle");
        level.using_vehicle = 1;
        self waittill("exit_vehicle");
        level.using_vehicle = 0;
    }
}

watch_upgraded_staff()
{
    while(!self HasWeapon(GetWeapon("staff_air_upgraded")) || !self HasWeapon(GetWeapon("staff_fire_upgraded")) || !self HasWeapon(GetWeapon("staff_lightning_upgraded")) || !self HasWeapon(GetWeapon("staff_water_upgraded"))) wait 0.05;
    if(!self HasWeapon(level.var_2b2f83e5))
    {
        self SetActionSlot(3, "weapon", level.var_2b2f83e5);
        self GiveWeapon(level.var_2b2f83e5);
    }
}

give_riotshield()
{
    if(isdefined(level.weaponriotshieldupgraded)) self zm_equipment::buy(level.weaponriotshieldupgraded);
    else if(isdefined(level.weaponRiotshield)) self zm_equipment::buy(level.weaponRiotshield);
}

give_hero_weapon()
{
    switch(level.script)
    {
        case "zm_zod":
            self give_sword();
            break;
        case "zm_castle":
        case "zm_genesis":
            self give_rags();
            break;
        case "zm_island":
            self give_skull();
            break;
        case "zm_stalingrad":
            self give_welp();
            break;
        default:
            self give_annihilator();
            break;
    }
}

give_sword()
{
    wpn_sword = level.sword_quest.weapons[self.characterindex][1];
    self zm_weapons::weapon_give(wpn_sword, 0, 0, 1);
	self.current_sword = self.current_hero_weapon;
	self.sword_power = 1;
	self gadgetpowerset(0, 100);
}

give_rags()
{
    if(level.script == "zm_genesis") while(self HasWeapon(level.ballweapon)) wait 0.05;
    wpn_gravityspikes = getweapon("hero_gravityspikes_melee");
    self zm_weapons::weapon_give(wpn_gravityspikes, 0, 1);
    self thread zm_equipment::show_hint_text(&"ZM_CASTLE_GRAVITYSPIKE_USE_HINT", 3);
    self gadgetpowerset(self gadgetgetslot(wpn_gravityspikes), 100);
    self.gravityspikes_state = 2;
}

give_skull()
{
    self zm_weapons::weapon_give(level.var_c003f5b, undefined, undefined, 1);
	self gadgetpowerset(0, 100);
    self notify("hash_ae5d6003");
	level flag::set("a_player_got_skullgun");
    self flag::set("has_skull");

}

give_welp()
{
    self zm_weapons::weapon_give(self.weapon_dragon_gauntlet, 0, 1);
	self thread zm_equipment::show_hint_text(&"DLC3_WEAP_DRAGON_GAUNTLET_USE_HINT", 3);
	self.var_8afc8427 = 100;
	self.hero_power = 100;
	self gadgetpowerset(0, 100);
	self zm_hero_weapon::set_hero_weapon_state(self.weapon_dragon_gauntlet, 2);
	self setweaponammoclip(self.weapon_dragon_gauntlet, self.weapon_dragon_gauntlet.clipsize);
	self.var_fd007e55 = 1;
}

give_annihilator()
{
    self zm_weapons::weapon_give(level.weaponannihilator);
    self gadgetpowerset(0, 100);
}

give_equipment()
{
    if(isdefined(level.weaponzmcymbalmonkey))
    {
        if(isdefined(level.w_beacon)) [[level.zombie_weapons_callbacks[level.w_beacon]]]();
        else [[level.zombie_weapons_callbacks[level.weaponzmcymbalmonkey]]]();
    }
    else if(isdefined(level.w_octobomb)) [[level.zombie_weapons_callbacks[level.w_octobomb]]]();
    else if(isdefined(level.w_nesting_dolls))
    {
        if(math::cointoss()) self zm_weapons::weapon_give(level.w_nesting_dolls);
        else zm_weapons::weapon_give(level.w_black_hole_bomb);
    }
    else if(isdefined(level.w_quantum_bomb))
    {
        if(math::cointoss()) self zm_weapons::weapon_give(level.w_quantum_bomb);
        else zm_weapons::weapon_give(level.w_black_hole_bomb);
    }
    
}