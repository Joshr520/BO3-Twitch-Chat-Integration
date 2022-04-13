give_bgb(bgb_mega)
{
    if(!isdefined(level.bgb_mega_array)) init_mega_bgb();
    bgb = array::random(level.bgb).name;
    if(bgb_mega)
    {
        while(!IsInArray(level.bgb_mega_array, bgb))
        {
            bgb = array::random(level.bgb).name;
            wait 0.05;
        }
    }
    else
    {
        while(IsInArray(level.bgb_mega_array, bgb))
        {
            bgb = array::random(level.bgb).name;
            wait 0.05;
        }
    }
    self thread bgb::give(bgb);
}

take_bgb()
{
    self thread bgb::take();
}

init_mega_bgb()
{
    level.bgb_mega_array = array("zm_bgb_aftertaste", "zm_bgb_board_games", "zm_bgb_board_to_death", "zm_bgb_bullet_boost", "zm_bgb_burned_out", "zm_bgb_cache_back", "zm_bgb_crate_power", "zm_bgb_crawl_space", "zm_bgb_dead_of_nuclear_winter", "zm_bgb_disorderly_combat", "zm_bgb_ephemeral_enhancement", "zm_bgb_extra_credit", "zm_bgb_eye_candy", "zm_bgb_fatal_contraption", "zm_bgb_fear_in_headlights", "zm_bgb_flavor_hexed", "zm_bgb_head_drama", "zm_bgb_idle_eyes", "zm_bgb_im_feeling_lucky", "zm_bgb_immolation_liquidation", "zm_bgb_kill_joy", "zm_bgb_killing_time", "zm_bgb_licensed_contractor", "zm_bgb_mind_blown", "zm_bgb_near_death_experience", "zm_bgb_newtonian_negation", "zm_bgb_on_the_house", "zm_bgb_perkaholic", "zm_bgb_phoenix_up", "zm_bgb_pop_shocks", "zm_bgb_power_vacuum", "zm_bgb_profit_sharing", "zm_bgb_projectile_vomiting", "zm_bgb_reign_drops", "zm_bgb_respin_cycle", "zm_bgb_round_robbin", "zm_bgb_secret_shopper", "zm_bgb_self_medication", "zm_bgb_shopping_free", "zm_bgb_slaughter_slide", "zm_bgb_soda_fountain", "zm_bgb_temporal_gift", "zm_bgb_unbearable", "zm_bgb_undead_man_walking", "zm_bgb_unquenchable", "zm_bgb_wall_power", "zm_bgb_whos_keeping_score");
}

verify_bgb_use(var_5827b083 = 0)
{
	var_bb1d9487 = isdefined(level.bgb[self.bgb].validation_func) && !self [[level.bgb[self.bgb].validation_func]]();
	var_847ec8da = isdefined(level.var_9cef605e) && !self [[level.var_9cef605e]]();
	if(!var_5827b083 && (is_true(self.is_drinking)) || (is_true(self.bgb_activation_in_progress)) || self laststand::player_is_in_laststand() || var_bb1d9487 || var_847ec8da)
	{
		self clientfield::increment_uimodel("bgb_invalid_use");
		self playlocalsound("zmb_bgb_deny_plr");
		return false;
	}
	return true;
}