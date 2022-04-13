init_hud(x,y)
{
	hud = NewClientHudElem(self);

	hud.alignX = "left";
	hud.alignY = "top";
	hud.horzAlign = "user_left";
	hud.vertAlign = "user_top";
	hud.foreground = true;
	hud.hidewheninmenu = false;
	hud.x = x;
	hud.y = y;
	hud.alpha = 1;
	hud.font = "default";
	hud.fontScale = 1;
	hud.color = (1,1,1);
	
	return hud;
}