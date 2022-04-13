spawn_island_thrasher()
{
	s_loc = function_22338aad();
	var_e3372b59 = zombie_utility::spawn_zombie(level.var_feebf312[0], "thrasher", s_loc);
	if(isdefined(var_e3372b59) && isdefined(s_loc))
	{
		var_e3372b59 ForceTeleport(s_loc.origin, s_loc.angles);
		playsoundatposition("zmb_vocals_thrash_spawn", var_e3372b59.origin);
		if(!var_e3372b59 zm_utility::in_playable_area())
		{
			player = Array::random(level.players);
			if(zm_utility::is_player_valid(player, 0, 1))
			{
				var_e3372b59 thread function_89976d94(player.origin);
			}
		}
		return var_e3372b59;
	}
}

function_89976d94(v_pos)
{
	self endon("death");
	var_2e57f81c = util::spawn_model("tag_origin", self.origin, self.angles);
	var_2e57f81c thread scene::Play("scene_zm_dlc2_thrasher_teleport_out", self);
	self util::waittill_notify_or_timeout("thrasher_teleport_out_done", 4);
    var_948d85e3 = util::spawn_model("tag_origin", v_pos, (0, 0, 0));
    var_2e57f81c scene::stop("scene_zm_dlc2_thrasher_teleport_out");
    var_948d85e3 thread scene::Play("scene_zm_dlc2_thrasher_teleport_in_v1", self);
}

function_22338aad()
{
	var_38efd13c = level.zm_loc_types["thrasher_location"];
	for(i = 0; i < var_38efd13c.size; i++)
	{
		if(isdefined(level.var_46a39590) && level.var_46a39590 == var_38efd13c[i])
		{
			continue;
		}
		s_spawn_loc = var_38efd13c[i];
		level.var_46a39590 = s_spawn_loc;
		return s_spawn_loc;
	}
	s_spawn_loc = var_38efd13c[0];
	level.var_46a39590 = s_spawn_loc;
	return s_spawn_loc;
}