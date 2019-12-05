class X2DownloadableContentInfo_InfiniteStartingItems extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated()
{
	InfiniteMedikits();
	InfiniteNanoMedikits();
	InfiniteFlashbangGrenades();
	InfiniteSmokeGrenades();
	InfiniteSmokeBombs();
	InfiniteSmokeWarheads();
}

static function InfiniteMedikits()
{
	local X2ItemTemplateManager			ItemTemplateMgr;
	local array<X2DataTemplate>			TemplateAllDifficulties;
	local X2DataTemplate				Template;

	local X2WeaponTemplate				WeaponTemplate;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplateMgr.FindDataTemplateAllDifficulties('Medikit', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		WeaponTemplate = X2WeaponTemplate(Template);
		WeaponTemplate.StartingItem = true;
		WeaponTemplate.CanBeBuilt = false;
		WeaponTemplate.bInfiniteItem = true;

		WeaponTemplate.Cost.ResourceCosts.Length = 0;
	}
}

static function InfiniteNanoMedikits()
{
	local X2ItemTemplateManager			ItemTemplateMgr;
	local array<X2DataTemplate>			TemplateAllDifficulties;
	local X2DataTemplate				Template;

	local X2WeaponTemplate				WeaponTemplate;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplateMgr.FindDataTemplateAllDifficulties('NanoMedikit', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		WeaponTemplate = X2WeaponTemplate(Template);
		WeaponTemplate.CanBeBuilt = false;
		WeaponTemplate.bInfiniteItem = true;

		WeaponTemplate.Cost.ResourceCosts.Length = 0;

		WeaponTemplate.Cost.ArtifactCosts.Length = 0;
	}
}

static function InfiniteFlashbangGrenades()
{
	local X2ItemTemplateManager			ItemTemplateMgr;
	local array<X2DataTemplate>			TemplateAllDifficulties;
	local X2DataTemplate				Template;

	local X2GrenadeTemplate				GrenadeTemplate;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplateMgr.FindDataTemplateAllDifficulties('FlashbangGrenade', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		GrenadeTemplate = X2GrenadeTemplate(Template);
		GrenadeTemplate.CanBeBuilt = false;
		GrenadeTemplate.StartingItem = true;
		GrenadeTemplate.bInfiniteItem = true;

		GrenadeTemplate.Cost.ResourceCosts.Length = 0;
	}
}

static function InfiniteSmokeGrenades()
{
	local X2ItemTemplateManager			ItemTemplateMgr;
	local array<X2DataTemplate>			TemplateAllDifficulties;
	local X2DataTemplate				Template;

	local X2GrenadeTemplate				GrenadeTemplate;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplateMgr.FindDataTemplateAllDifficulties('SmokeGrenade', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		GrenadeTemplate = X2GrenadeTemplate(Template);
		GrenadeTemplate.CanBeBuilt = false;
		GrenadeTemplate.StartingItem = true;
		GrenadeTemplate.bInfiniteItem = true;

		GrenadeTemplate.Cost.ResourceCosts.Length = 0;
	}
}

static function InfiniteSmokeBombs()
{
	local X2ItemTemplateManager			ItemTemplateMgr;
	local array<X2DataTemplate>			TemplateAllDifficulties;
	local X2DataTemplate				Template;

	local X2GrenadeTemplate				GrenadeTemplate;

	ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplateMgr.FindDataTemplateAllDifficulties('SmokeGrenadeMk2', TemplateAllDifficulties);

	foreach TemplateAllDifficulties(Template)
	{
		GrenadeTemplate = X2GrenadeTemplate(Template);
		GrenadeTemplate.CanBeBuilt = false;
		GrenadeTemplate.bInfiniteItem = true;

		GrenadeTemplate.Cost.ResourceCosts.Length = 0;
	}
}

static function InfiniteSmokeWarheads()
{
	local X2ItemTemplateManager			ItemTemplateMgr;
	local array<X2DataTemplate>			TemplateAllDifficulties;
	local X2DataTemplate				Template;

	local X2GrenadeTemplate				GrenadeTemplate;

	if (ModInstalled('Tier3Grenades_WoTC'))
	{
		ItemTemplateMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
		ItemTemplateMgr.FindDataTemplateAllDifficulties('SmokeGrenadeM3', TemplateAllDifficulties);

		foreach TemplateAllDifficulties(Template)
		{
			GrenadeTemplate = X2GrenadeTemplate(Template);
			GrenadeTemplate.CanBeBuilt = false;
			GrenadeTemplate.bInfiniteItem = true;

			GrenadeTemplate.Cost.ResourceCosts.Length = 0;
		}
	}
}

static function bool ModInstalled(name ModName)
{
	local XComOnlineEventMgr EventManager;
	local int i;

	EventManager = `ONLINEEVENTMGR;
	for (i = EventManager.GetNumDLC() - 1; i >= 0; i--)
	{
		if (EventManager.GetDLCNames(i) == ModName)
		{
			return true;
		}
	}
	return false;
}