#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init() {
	level thread onPlayerConnect();
}

onPlayerConnect() {
	while(true) {
		level waittill("connected", player);
		player thread onPlayerSpawned();
	}
}

onPlayerSpawned() {
	self endon("disconnect");

	while(true) {
		self waittill("spawned_player");
		self thread onMenuResponse();
	}
}

doShopAction(id) {
	if(isDefined(self.shopItems) && isArray(self.shopItems)) {
		if( (isDefined(self.shopItems[id].item) && self.shopItems[id].item != "")) {
			self thread [[ self.shopItems[id].function ]](self.shopItems[id].item);
		} else {
			self thread [[ self.shopItems[id].function ]](); 
		}
	} else {
		return;
	}
}

onMenuResponse() {
	self endon("death");
	self endon("disconnect");

	while(true) {
		self waittill("menuresponse", menu, response);
		iprintln("^2menu: " + menu + ", response: " + response);

		if(menu != "shopmenu") {
			self notify("shopmenuresp"); //Refresh shop menu items
		}

		//Handle respones from shop
		if(response == "buy_item1") { 
			self doShopAction(0);
		}
		
		if(response == "buy_item2") { 
			self doShopAction(1);
		}

		if(response == "buy_item3") { 
			self doShopAction(2);
		}

		if(response == "buy_item4") { 
			self doShopAction(3);
		}

		if(response == "buy_item5") { 
			self doShopAction(4); 
		}

		if(response == "buy_item6") { 
			self doShopAction(5); 
		}

		if(response == "buy_item7") { 
			self doShopAction(6); 
		}

		if(response == "buy_item8") { 
			self doShopAction(7);
		}

		if(response == "buy_item9") { 
			self doShopAction(8);
		}

		if(response == "buy_item0") { 
			self doShopAction(9);
		}

		if(response == "shopmenu_close") { 
			self notify("shopmenuresp");
		}
		
		if(response == "shopmenu_esc") { 
			ZAMCloseMenus();
		}
	}
}

ZAMCloseMenus() {
	self closeMenu();
	self closeInGameMenu();
    self notify("shopmenuresp");    
}