remove_random_perk()
{
    if(!isdefined(self.perks_active)) return;
    perk = array::random(self.perks_active);
    self remove_perk(perk);
}

remove_all_perks()
{
    foreach(perk in self.perks_active)
    {
        self remove_perk(perk);
    }
}

give_all_perks()
{
	perks = GetArrayKeys(level._custom_perks);
	foreach(player in level.players)
	{
		foreach(perk in perks)
		{
			if(!player hasPerk(perk)) player zm_perks::give_perk(perk, 0);
		}
	}
}

remove_perk(perk)
{
    self unsetPerk(perk);
    self.num_perks--;
    if(isdefined(level._custom_perks[perk]) && isdefined(level._custom_perks[perk].player_thread_take))
    {
        self thread [[level._custom_perks[perk].player_thread_take]](0, perk, perk);
    }
    self zm_perks::set_perk_clientfield(perk, 0);
    self.perk_purchased = undefined;
    if(isdefined(level.perk_lost_func))
    {
        self [[level.perk_lost_func]](perk);
    }
    if(isdefined(self.perks_active) && IsInArray(self.perks_active, perk))
    {
        ArrayRemoveValue(self.perks_active, perk, 0);
    }
    self notify("perk_lost");
}