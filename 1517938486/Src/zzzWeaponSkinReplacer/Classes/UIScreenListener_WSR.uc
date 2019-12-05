class UIScreenListener_WSR extends UIScreenListener;

var bool InventoryProcessed;
var bool ItemsDeleted;

function bool IsInStrategy()
{
	return `HQGAME  != none && `HQPC != None && `HQPRES != none;
}

event OnInit(UIScreen Screen)
{
	local X2ItemTemplateManager	ItemMgr;

	//`LOG("UISL WSR Triggered by screen: " @  Screen.Class,, 'WSR1');

	//RefreshRemoveWeaponButton(Screen);

	if (UIShell(Screen) != none) 
	{
		ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

		class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.PrintInfo(ItemMgr);

		class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.ReplaceWeapons(ItemMgr);
		class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.HideSchematics(ItemMgr);
		class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.HideWeapons(ItemMgr);
		class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.HideWeaponsKeepSchematics(ItemMgr);

		class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.CopyAttachments(ItemMgr);
		class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.ReplaceAttachments(ItemMgr);
		class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.AddDefaultAttachments(ItemMgr);
		class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.AddAttachments(ItemMgr);


		//	called in OPTC instead to make sure changes to PointsToComplete get grabbed by the game at the right time.
		//	I guess the PointsToComplete is used by native code at some point after OPTC to calculate actual research time 
		//class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.ChangeTemplates(ItemMgr);	 
		
		class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.GiveAbilities(ItemMgr);
		
		return;
	}

	if (UIFacilityGrid(Screen) != none && !ItemsDeleted)
	{
		class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.DeleteHiddenItems();
		ItemsDeleted = true;
	}
	
	if(IsInStrategy() && !InventoryProcessed)
	{
		//`LOG("Processing storage.",, 'WSR1');
		class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.UpdateStorage();
		InventoryProcessed = true;
	}
}

/*
event OnReceiveFocus(UIScreen Screen)
{
	RefreshRemoveWeaponButton(Screen);
}

simulated function RefreshRemoveWeaponButton(UIScreen Screen)
{
	if (UIArmory_Loadout(Screen) != none && `XCOMHQ != none)
	{
		AddRemoveWeaponButton();
	}
}

simulated function AddRemoveWeaponButton()
{
	local UISquadSelect Screen;
	local UINavigationHelp NavHelp;

	Screen = UISquadSelect(`SCREENSTACK.GetCurrentScreen());
	
	if (Screen != none)
	{
		NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;
		if(NavHelp.m_arrButtonClickDelegates.Length > 0 && NavHelp.m_arrButtonClickDelegates.Find(OnStripUpgrades) == INDEX_NONE)
		{
			NavHelp.AddCenterHelp(m_strStripUpgrades,, OnStripUpgrades, false, m_strStripUpgradesTooltip);
		}
		Screen.SetTimer(1.0f, false, nameof(AddHelp), self);
	}
}*/

defaultproperties
{
	InventoryProcessed=false
}