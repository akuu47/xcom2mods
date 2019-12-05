class CAEventListenerTemplate extends X2EventListenerTemplate;

// Hack in here to start the actor as early as possible in tactical game
function RegisterForEvents()
{
	`log("Spawn WotC_Armory_GripFix_BattleRifles.DropShipMatinee_Actor", class'X2DownloadableContentInfo_WotC_Armory_GripFix_BTR'.default.bLog, name("WotC_Armory_GripFix_BattleRifles" @ default.Class.name));
	`XCOMGAME.Spawn(class'WotC_Armory_GripFix_BattleRifles.DropShipMatinee_Actor');
}