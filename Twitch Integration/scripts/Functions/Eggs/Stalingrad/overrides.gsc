randomize_valves()
{
	if(level.script != "zm_stalingrad") return;
    level.var_57f8b6c5[0].var_1f3c0ca7 = randomInt(3);
    level.var_57f8b6c5[1].var_1f3c0ca7 = randomInt(3);
    level.var_57f8b6c5[2].var_1f3c0ca7 = randomInt(3);
    level.var_57f8b6c5[3].var_1f3c0ca7 = randomInt(3);
    level.var_57f8b6c5[4].var_1f3c0ca7 = randomInt(3);
    level.var_57f8b6c5[5].var_1f3c0ca7 = randomInt(3);
    array::run_all(level.var_57f8b6c5, ::function_450d606e);
}

function_450d606e()
{
	var_367b15e7 = GetEnt(self.target, "targetname");
	v_origin = self GetTagOrigin("tag_lever");
	v_angles = self GetTagAngles("tag_lever");
	var_367b15e7.origin = v_origin;
	var_367b15e7.angles = v_angles;
	if(self.var_1f3c0ca7 == 0)
	{
		var_367b15e7 RotatePitch(240, 0.1);
	}
	else if(self.var_1f3c0ca7 == 2)
	{
		var_367b15e7 RotatePitch(120, 0.1);
	}
	var_6403853b = function_d6953423(self.var_cd705a9[self.var_1f3c0ca7]);
	var_6403853b.var_59c68a0b++;
}

function_797708de()
{
	var_a95dc9d9 = level.var_57f8b6c5[0];
	var_70172e4a = [];
	for(i = 0; i < 6; i++)
	{
		Array::add(var_70172e4a, var_a95dc9d9, 0);
		var_a95dc9d9 = function_d6953423(var_a95dc9d9.var_cd705a9[var_a95dc9d9.var_1f3c0ca7]);
	}
	if(var_70172e4a.size != 6)
	{
		return 0;
	}
	if(var_70172e4a[5] != level.var_57f8b6c5[5])
	{
		return 0;
	}
	return 1;
}

function_d6953423(str_location)
{
	foreach(var_beb54dbd in level.var_57f8b6c5)
	{
		if(var_beb54dbd.script_label == str_location)
		{
			return var_beb54dbd;
		}
	}
}

randomize_password()
{
	if(level.script != "zm_stalingrad") return;
	level flag::wait_till("ee_cylinder_acquired");
	while(level.var_4c56821d.size != 6)	wait 0.05;
	foreach(index, letter in level.var_4c56821d)
	{
		letter thread move_letter(index);
	}
}

move_letter(num_letter)
{
	while(!isdefined(self.var_c957db9f)) wait 0.05;
    num = randomInt(8);
	while(self.var_c957db9f != num)
	{
		self.var_c957db9f++;
		if(self.var_c957db9f == 8)
		{
			self.var_c957db9f = 0;
		}
		self RotateYaw(45, 0.5);
		self waittill("rotatedone");
	}
}