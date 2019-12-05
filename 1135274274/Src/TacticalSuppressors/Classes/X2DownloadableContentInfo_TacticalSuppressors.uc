//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_TacticalSuppressors.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_TacticalSuppressors extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
	PatchTemplates();
}

static function PatchTemplates()
{
	local X2ItemTemplateManager		 ItemTemplateMgr;
	local X2AbilityTemplateManager   AbilityTemplateManager;
	local X2AbilityTemplate          AbilityTemplate;
	local Array<name>				 TemplateNames;
	local name						 TemplateName;
	local array<X2WeaponUpgradeTemplate> ItemTemplates;
	local array<Name>				 PatchTemplates;
	local int i, a;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	ItemTemplates = ItemTemplateMgr.GetAllUpgradeTemplates();

	PatchTemplates.AddItem('FreeKillUpgrade');
	PatchTemplates.AddItem('FreeKillUpgrade_Bsc');
	PatchTemplates.AddItem('FreeKillUpgrade_Adv');
	PatchTemplates.AddItem('FreeKillUpgrade_Sup');

	for (i = 0; i < ItemTemplates.Length; ++i)
	{
		if(ItemTemplates[i] != none && PatchTemplates.Find(ItemTemplates[i].DataName) != INDEX_NONE)
		{
			ItemTemplates[i].BonusAbilities.AddItem('MusashiSilencer');
			ItemTemplates[i].BonusAbilities.AddItem('MusashiAmbushSilencer');
			ItemTemplates[i].BonusAbilities.AddItem('SilentKillPassive');

			ItemTemplates[i].FreeKillChance = 0;
			ItemTemplates[i].FreeKillFn = none;
			ItemTemplates[i].GetBonusAmountFn = none;
		}
	}
}

exec function DebugProjectiles()
{
	local X2ItemTemplateManager		 ItemTemplateMgr;
	local array<X2WeaponTemplate>	 WeaponTemplates;
	local X2WeaponTemplate			 WeaponTemplate;
	local array<X2UnifiedProjectileElement> PJElements;
	local X2UnifiedProjectileElement PJ;
	local XComWeapon Weapon;
	local XGItem CreatedItem;
	local XGWeapon CreatedWeapon;
	local array<string> PathnamesDeath;
	local array<string> PathnamesFire;
	local string Path;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	WeaponTemplates = ItemTemplateMgr.GetAllWeaponTemplates();

	foreach WeaponTemplates(WeaponTemplate)
	{
		Weapon = XComWeapon(`CONTENT.RequestGameArchetype(WeaponTemplate.GameArchetype));
		PJElements = Weapon.DefaultProjectileTemplate.ProjectileElements;
		
		//`Log(String(WeaponTemplate.DataName) @ PJElements.Length, , 'LWTacticalSuppressors');
		
		foreach PJElements(PJ)
		{
			if (PJ.DeathSound != none)
			{
				if (PathnamesDeath.Find(PathName(PJ)) == INDEX_NONE)
				{
					PathnamesDeath.AddItem(PathName(PJ));
				}
			}

			if (PJ.FireSound != none)
			{
				if (PathnamesFire.Find(PathName(PJ)) == INDEX_NONE)
				{
					PathnamesFire.AddItem(PathName(PJ));
				}
			}
		}
	}

	foreach PathnamesDeath(Path)
	{
		`LOG("DeathSound	" @ Path,, 'TacticalSuppressors');
	}
	
	foreach PathnamesFire(Path)
	{
		`LOG("FireSound	" @ Path,, 'TacticalSuppressors');
	}
}