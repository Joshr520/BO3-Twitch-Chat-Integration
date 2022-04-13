spawn_tomb_panzer()
{
    s_loc = function_27b9fdd3();
    if(!isdefined(s_loc))
    {
        IPrintLnBold("Spawn Error");
    }
    ai = spawn_mechz(s_loc, 1);
	ai clientfield::set("tomb_mech_eye", 1);
	ai thread mechz_death();
    ai.no_widows_wine = 1;
    ai thread mechz_hint_vo();
}

function_27b9fdd3()
{
	var_fffe05f0 = Array::randomize(level.mechz_locations);
	var_1fae6c0 = [];
	for(i = 0; i < var_fffe05f0.size; i++)
	{
		s_loc = var_fffe05f0[i];
		str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 1);
		if(isdefined(str_zone) && level.zones[str_zone].is_occupied)
		{
			var_1fae6c0[var_1fae6c0.size] = s_loc;
		}
	}
	if(var_1fae6c0.size == 0)
	{
		for(i = 0; i < var_fffe05f0.size; i++)
		{
			s_loc = var_fffe05f0[i];
			str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 1);
			if(isdefined(str_zone) && level.zones[str_zone].is_active)
			{
				var_1fae6c0[var_1fae6c0.size] = s_loc;
			}
		}
	}
	else if(var_1fae6c0.size > 0)
	{
		return var_1fae6c0[0];
	}
	foreach(s_loc in var_fffe05f0)
	{
		str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 0);
		if(isdefined(str_zone))
		{
			return s_loc;
		}
	}
	return var_fffe05f0[0];
}

mechz_death()
{
	self waittill("hash_46c1e51d");
	self clientfield::set("tomb_mech_eye", 0);
	level notify("mechz_killed", self.origin);
	if(level flag::get("zombie_drop_powerups") && (!is_true(self.no_powerups)))
	{
		var_d54b1ec = Array("double_points", "insta_kill", "full_ammo", "nuke");
		str_type = Array::random(var_d54b1ec);
		zm_powerups::specific_powerup_drop(str_type, self.origin);
	}
}

mechz_hint_vo()
{
	self endon("death");
}