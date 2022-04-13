detour zm_utility<scripts\zm\_zm_utility.gsc>::give_start_weapon(b_switch_weapon)
{
    self zm_weapons::weapon_give(level.start_weapon, 0, 0, 1, 0);
    self giveMaxAmmo(level.start_weapon);
    self zm_weapons::weapon_give(level.super_ee_weapon, 0, 0, 1, b_switch_weapon);
}