set_timescale(value)
{
    SetDvar("timescale", value);
    wait level.set_timescale_time;
    SetDvar("timescale", 1);
}

set_player_speed(value)
{
    SetDvar("g_speed", value);
    wait level.set_player_speed_time;
    SetDvar("g_speed", 190);
}

set_infinite_ammo()
{
    SetDvar("player_sustainAmmo", 1);
    wait level.set_infinite_ammo_time;
    SetDvar("player_sustainAmmo", 0);
}

set_third_person()
{
    SetDvar("cg_thirdperson", 1);
    wait level.set_third_person_time;
    SetDvar("cg_thirdperson", 0);
}

set_fov(value)
{
    old_value = GetDvarInt("cg_fov_default");
    SetDvar("cg_fov_default", value);
    wait level.set_fov_time;
    SetDvar("cg_fov_default", old_value);
}