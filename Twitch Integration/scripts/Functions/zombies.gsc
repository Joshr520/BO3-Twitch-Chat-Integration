spawn_special_boss(num_bosses)
{
    for(i = 0; i < num_bosses; i++)
    {
        switch(level.script)
        {
            case "zm_zod":
                margwa = thread spawn_zod_margwa();
                break;
            case "zm_castle":
                panzer = thread spawn_castle_panzer();
                break;
            case "zm_island":
                thrasher = thread spawn_island_thrasher();
                break;
            case "zm_stalingrad":
                thread spawn_stalingrad_mangler();
                break;
            case "zm_genesis":
                if(randomIntRange(0, 100) < 50) margwa = thread spawn_genesis_margwa();
                else panzer = thread spawn_genesis_panzer();
                break;
            case "zm_tomb":
                panzer = thread spawn_tomb_panzer();
                break;
        }
        wait 0.1;
    }
}

update_zombie_movement(move_speed)
{
    foreach(zombie in GetAITeamArray(level.zombie_team))
    {
        zombie zombie_utility::set_zombie_run_cycle(move_speed);
    }
}

lock_round()
{
    level endon("stop_infinite_round");
    thread unlock_round(level.lock_round_time, level.zombie_total);
    for(;;)
    {
        level.zombie_total = 99;
        wait 0.05;
    }
}

unlock_round(wait_time, zombie_total)
{
    wait(wait_time);
    level notify("stop_infinite_round");
    level.zombie_total = zombie_total;
}

end_round()
{
    playsoundatposition("zmb_bgb_round_robbin", (0, 0, 0));
	wait(0.1);
	zombies = GetAITeamArray(level.zombie_team);
	for(i = 0; i < zombies.size; i++)
	{
		if(is_true(zombies[i].ignore_round_robbin_death))
		{
			ArrayRemoveValue(zombies, zombies[i]);
		}
	}
    level.zombie_total = 0;
    foreach(zombie in zombies)
    {
        zombie DoDamage(zombie.health + 666, zombie.origin);
    }
}

increase_zombie_limit()
{
    level.zombie_ai_limit = 64;
    wait level.increase_zombie_limit_time;
    level.zombie_ai_limit = 24;
}

create_turned_army(team)
{
    for(i = 0; i < 10; i++)
    {
        zombie = spawn_zombie(self);
        if(team == "friendly") zombie thread create_turned_zombie_friendly(self);
        else zombie thread create_turned_zombie_enemy(self);
        wait 0.05;
    }
}

create_turned_zombie_friendly(attacker)
{
    wait 0.5;
    self zombie_utility::set_zombie_run_cycle("sprint");
    wait 0.5;
	self thread clientfield::set("zm_aat_turned", 1);
	self zombie_death_time_limit(attacker);
	self.team = "allies";
	self.aat_turned = true;
	self.n_aat_turned_zombie_kills = 0;
	self.allowDeath = false;
	self.allowpain = false;
	self.no_gib = true; 
	if(math::cointoss())
	{
		if(self.zombie_arms_position == "up") self.variant_type = 7 - 1;
		else self.variant_type = 8 - 1;
	}
	else
	{
		if(self.zombie_arms_position == "up") self.variant_type = 7;
		else self.variant_type = 8;
	}
	self thread zm_aat_turned::zombie_kill_tracker(attacker);
}

create_turned_zombie_enemy(attacker)
{
	self thread clientfield::set("zm_aat_turned", 1);
    wait 0.5;
    self.ignore_enemy_count = true;
    self.health = self.health * 3;
    self zombie_utility::set_zombie_run_cycle("sprint");
}

zombie_death_time_limit(e_attacker)
{
	self endon("death");
	self endon("entityshutdown");
	wait level.zombie_death_time_limit_time;
	
	self clientfield::set("zm_aat_turned", 0);
	self.allowDeath = true;
	self zm_aat_turned::zombie_death_gib(e_attacker);
}

spawn_zombie(player)
{
    if(isdefined(level.zombie_spawners))
    {
        if(isdefined(level.fn_custom_zombie_spawner_selection))
        {
            spawner = [[level.fn_custom_zombie_spawner_selection]]();
        }
        else if(isdefined(level.use_multiple_spawns) && level.use_multiple_spawns)
        {
            if(isdefined(level.spawner_int) && (isdefined(level.zombie_spawn[level.spawner_int].size) && level.zombie_spawn[level.spawner_int].size))
            {
                spawner = Array::random(level.zombie_spawn[level.spawner_int]);
            }
            else
            {
                spawner = Array::random(level.zombie_spawners);
            }
        }
        else
        {
            spawner = Array::random(level.zombie_spawners);
        }
        ai = zombie_utility::spawn_zombie(spawner, spawner.targetname);
    }

    if (isdefined(ai)) return ai;
}

set_invisible_toggle_shoot()
{
    level.invisible_active = 1;
    self thread set_invisible();
    wait level.set_invisible_toggle_shoot_time;
    level.invisible_active = 0;
}

set_invisible()
{
    while(level.invisible_active)
    {
        if(self AttackButtonPressed())
        {
            while(self AttackButtonPressed())
            {
                foreach(zombie in GetAITeamArray(level.zombie_team))
                {
                    zombie SetVisibleToAll();
                }
                wait 1.5;
            }
        }
        foreach(zombie in GetAITeamArray(level.zombie_team))
        {
            zombie SetInvisibleToAll();
        }
        wait 0.05;
    }
    foreach(zombie in GetAITeamArray(level.zombie_team))
    {
        zombie SetInvisibleToAll();
    }
}