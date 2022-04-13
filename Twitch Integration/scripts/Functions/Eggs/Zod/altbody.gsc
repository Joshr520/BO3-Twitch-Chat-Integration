player_altbody(name, trigger)
{
	self.altbody = 1;
	self thread function_1f9554ce();
	self player_enter_altbody(name, trigger);
	self waittill("altbody_end");
	self player_exit_altbody(name, trigger);
	self.altbody = 0;
}

function_1f9554ce()
{
	self endon("disconnect");
	was_inv = self enableinvulnerability();
	wait(1);
	if(isdefined(self) && (!(is_true(was_inv))))
	{
		self disableinvulnerability();
	}
}

player_enter_altbody(name, trigger)
{
	charindex = level.altbody_charindexes[name];
	self.var_b2356a6c = self.origin;
	self.var_227fe352 = self.angles;
	self setperk("specialty_playeriszombie");
	self thread function_72c3fae0(1);
	self setcharacterbodytype(charindex);
	self setcharacterbodystyle(0);
	self setcharacterhelmetstyle(0);
	clientfield::set_to_player("player_in_afterlife", 1);
	self player_apply_loadout(name);
	self thread player_apply_visionset(name);
	callback = level.altbody_enter_callbacks[name];
	if(isdefined(callback))
	{
		self [[callback]](name, trigger);
	}
	clientfield::set("player_altbody", 1);
}

function_72c3fae0(washuman)
{
	if(washuman)
	{
		playfx(level._effect["human_disappears"], self.origin);
	}
	else
	{
		playfx(level._effect["zombie_disappears"], self.origin);
		playsoundatposition("zmb_player_disapparate", self.origin);
		self playlocalsound("zmb_player_disapparate_2d");
	}
}

player_apply_loadout(name)
{
	self bgb::suspend_weapon_cycling();
	loadout = level.altbody_loadouts[name];
	if(isdefined(loadout))
	{
		self disableweaponcycling();
		self.get_player_weapon_limit = 16;
		self.altbody_loadout[name] = zm_weapons::player_get_loadout();
		self zm_weapons::player_give_loadout(loadout, 0, 1);
		if(!isdefined(self.altbody_loadout_ever_had))
		{
			self.altbody_loadout_ever_had = [];
		}
		if(isdefined(self.altbody_loadout_ever_had[name]) && self.altbody_loadout_ever_had[name])
		{
			self seteverhadweaponall(1);
		}
		self.altbody_loadout_ever_had[name] = 1;
		self util::waittill_any_timeout(1, "weapon_change_complete");
		self resetanimations();
	}
}

player_apply_visionset(name)
{
	if(!isdefined(self.altbody_visionset))
	{
		self.altbody_visionset = [];
	}
	visionset = level.altbody_visionsets[name];
	if(isdefined(visionset))
	{
		if(isdefined(self.altbody_visionset[name]) && self.altbody_visionset[name])
		{
			visionset_mgr::deactivate("visionset", visionset, self);
			util::wait_network_frame();
			util::wait_network_frame();
			if(!isdefined(self))
			{
				return;
			}
		}
		visionset_mgr::activate("visionset", visionset, self);
		self.altbody_visionset[name] = 1;
	}
}

player_exit_altbody(name, trigger)
{
	clientfield::set("player_altbody", 0);
	clientfield::set_to_player("player_in_afterlife", 0);
	callback = level.altbody_exit_callbacks[name];
	if(isdefined(callback))
	{
		self [[callback]](name, trigger);
	}
	if(!isdefined(self.altbody_visionset))
	{
		self.altbody_visionset = [];
	}
	visionset = level.altbody_visionsets[name];
	if(isdefined(visionset))
	{
		visionset_mgr::deactivate("visionset", visionset, self);
		self.altbody_visionset[name] = 0;
	}
	self thread player_restore_loadout(name);
	self unsetperk("specialty_playeriszombie");
	self detachall();
	self thread function_72c3fae0(0);
	self [[level.givecustomcharacters]]();
}

player_restore_loadout(name, trigger)
{
	loadout = level.altbody_loadouts[name];
	if(isdefined(loadout))
	{
		if(isdefined(self.altbody_loadout[name]))
		{
			self zm_weapons::switch_back_primary_weapon(self.altbody_loadout[name].current, 1);
			self.altbody_loadout[name] = undefined;
			self util::waittill_any_timeout(1, "weapon_change_complete");
		}
		self zm_weapons::player_take_loadout(loadout);
		self.get_player_weapon_limit = undefined;
		self resetanimations();
		self enableweaponcycling();
	}
	self bgb::resume_weapon_cycling();
}