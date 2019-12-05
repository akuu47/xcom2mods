//  FILE:   X2Item_Global_Upgrades.uc
//  AUTHOR: Musashi, E3245
//
// Upgrade code derived from Musashi's Primary Pistol mod, edited by me
//

class X2Item_Global_Upgrades extends X2Item config(_GlobalUpgrades);

struct WeaponAttachment {
	var() string Type;
	var() string Tier;
	var() name AttachSocket;
	var() name UIArmoryCameraPointTag;
	var() string MeshName;
	var() string ProjectileName;
	var() name MatchWeaponTemplate;
	var() bool AttachToPawn;
	var() string IconName;
	var() string InventoryIconName;
	var() string InventoryCategoryIcon;
	var() name AttachmentFn;
};

var config array<WeaponAttachment> WeaponAttachments;

static function AddAllAttachments()
{
	local array<name> AttachmentTypes;
	local name AttachmentType;

	AttachmentTypes.AddItem('CritUpgrade_Bsc');
	AttachmentTypes.AddItem('CritUpgrade_Adv');
	AttachmentTypes.AddItem('CritUpgrade_Sup');
	AttachmentTypes.AddItem('AimUpgrade_Bsc');
	AttachmentTypes.AddItem('AimUpgrade_Adv');
	AttachmentTypes.AddItem('AimUpgrade_Sup');
	AttachmentTypes.AddItem('ClipSizeUpgrade_Bsc');
	AttachmentTypes.AddItem('ClipSizeUpgrade_Adv');
	AttachmentTypes.AddItem('ClipSizeUpgrade_Sup');
	AttachmentTypes.AddItem('FreeFireUpgrade_Bsc');
	AttachmentTypes.AddItem('FreeFireUpgrade_Adv');
	AttachmentTypes.AddItem('FreeFireUpgrade_Sup');
	AttachmentTypes.AddItem('ReloadUpgrade_Bsc');
	AttachmentTypes.AddItem('ReloadUpgrade_Adv');
	AttachmentTypes.AddItem('ReloadUpgrade_Sup');
	AttachmentTypes.AddItem('MissDamageUpgrade_Bsc');
	AttachmentTypes.AddItem('MissDamageUpgrade_Adv');
	AttachmentTypes.AddItem('MissDamageUpgrade_Sup');
	AttachmentTypes.AddItem('FreeKillUpgrade_Bsc');
	AttachmentTypes.AddItem('FreeKillUpgrade_Adv');
	AttachmentTypes.AddItem('FreeKillUpgrade_Sup');
	AttachmentTypes.AddItem('UBGL_Conv');
	AttachmentTypes.AddItem('UBGL_Mag');
	AttachmentTypes.AddItem('UBGL_Beam');
	AttachmentTypes.AddItem('UBS_Conv');
	AttachmentTypes.AddItem('UBS_Mag');
	AttachmentTypes.AddItem('UBS_Beam');
	AttachmentTypes.AddItem('UBFlame_Conv');

	foreach AttachmentTypes(AttachmentType)
	{
		AddAttachment(AttachmentType, default.WeaponAttachments);
	}
}

static function AddAttachment(name TemplateName, array<WeaponAttachment> Attachments) 
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2WeaponUpgradeTemplate Template;
	local WeaponAttachment Attachment;
	local delegate<X2TacticalGameRulesetDataStructures.CheckUpgradeStatus> CheckFN;
	
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Template = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(TemplateName));
	
	if (Template != none)
	{
		foreach Attachments(Attachment)
		{
			if (InStr(string(TemplateName), Attachment.Type) != INDEX_NONE && InStr(string(TemplateName), Attachment.Tier) != INDEX_NONE)
			{
				switch(Attachment.AttachmentFn) 
				{
					case ('NoReloadUpgradePresent'): 
						CheckFN = class'X2Item_DefaultUpgrades'.static.NoReloadUpgradePresent; 
						break;
					case ('ReloadUpgradePresent'): 
						CheckFN = class'X2Item_DefaultUpgrades'.static.ReloadUpgradePresent; 
						break;
					case ('NoClipSizeUpgradePresent'): 
						CheckFN = class'X2Item_DefaultUpgrades'.static.NoClipSizeUpgradePresent; 
						break;
					case ('ClipSizeUpgradePresent'): 
						CheckFN = class'X2Item_DefaultUpgrades'.static.ClipSizeUpgradePresent; 
						break;
					case ('NoFreeFireUpgradePresent'): 
						CheckFN = class'X2Item_DefaultUpgrades'.static.NoFreeFireUpgradePresent; 
						break;
					case ('FreeFireUpgradePresent'): 
						CheckFN = class'X2Item_DefaultUpgrades'.static.FreeFireUpgradePresent; 
						break;
					case ('NoMissDamageUpgradePresent'): 
						CheckFN = NoMissDamageUpgradePresent; 
						break;
					case ('MissDamageUpgradePresent'): 
						CheckFN = MissDamageUpgradePresent; 
						break;
					case ('NoFreeKillUpgradePresent'): 
						CheckFN = NoFreeKillUpgradePresent; 
						break;
					case ('FreeKillUpgradePresent'): 
						CheckFN = FreeKillUpgradePresent; 
						break;
					case ('AimUpgradePresent'): 
						CheckFN = AimUpgradePresent; 
						break;
					case ('NoAimUpgradePresent'): 
						CheckFN = NoAimUpgradePresent; 
						break;
					case ('CritUpgradePresent'): 
						CheckFN = CritUpgradePresent; 
						break;
					case ('NoCritUpgradePresent'): 
						CheckFN = NoCritUpgradePresent; 
						break;
					case ('NoAnyAimUpgradePresent'): 
						CheckFN = NoAnyAimUpgradePresent; 
						break;
					case ('AnyAimUpgradePresent'): 
						CheckFN = AnyAimUpgradePresent; 
						break;
					default:
						CheckFN = none;
						break;
				}

				Template.AddUpgradeAttachment(Attachment.AttachSocket, Attachment.UIArmoryCameraPointTag, Attachment.MeshName, Attachment.ProjectileName, Attachment.MatchWeaponTemplate, Attachment.AttachToPawn, Attachment.IconName, Attachment.InventoryIconName, Attachment.InventoryCategoryIcon, CheckFN);
			}
		}
	}
}

//**********************************************************************
// This section is solely for the addition of AttachmentFn requirements.
//**********************************************************************
static function bool NoMissDamageUpgradePresent(array<X2WeaponUpgradeTemplate> AllUpgradeTemplates)
{
	return !MissDamageUpgradePresent(AllUpgradeTemplates);
}

static function bool MissDamageUpgradePresent(array<X2WeaponUpgradeTemplate> AllUpgradeTemplates)
{
	local X2WeaponUpgradeTemplate TestTemplate;

	foreach AllUpgradeTemplates(TestTemplate)
	{
		if (TestTemplate.DataName == 'MissDamageUpgrade' ||
			TestTemplate.DataName == 'MissDamageUpgrade_Bsc' ||
			TestTemplate.DataName == 'MissDamageUpgrade_Adv' ||
			TestTemplate.DataName == 'MissDamageUpgrade_Sup')
		{
			return true;
		}
	}

	return false;
}


static function bool NoFreeKillUpgradePresent(array<X2WeaponUpgradeTemplate> AllUpgradeTemplates)
{
	return !FreeKillUpgradePresent(AllUpgradeTemplates);
}

static function bool FreeKillUpgradePresent(array<X2WeaponUpgradeTemplate> AllUpgradeTemplates)
{
	local X2WeaponUpgradeTemplate TestTemplate;

	foreach AllUpgradeTemplates(TestTemplate)
	{
		if (TestTemplate.DataName == 'FreeKillUpgrade' ||
			TestTemplate.DataName == 'FreeKillUpgrade_Bsc' ||
			TestTemplate.DataName == 'FreeKillUpgrade_Adv' ||
			TestTemplate.DataName == 'FreeKillUpgrade_Sup')
		{
			return true;
		}
	}

	return false;
}

static function bool NoFreeFireUpgradePresent(array<X2WeaponUpgradeTemplate> AllUpgradeTemplates)
{
	return !FreeFireUpgradePresent(AllUpgradeTemplates);
}

static function bool FreeFireUpgradePresent(array<X2WeaponUpgradeTemplate> AllUpgradeTemplates)
{
	local X2WeaponUpgradeTemplate TestTemplate;

	foreach AllUpgradeTemplates(TestTemplate)
	{
		if (TestTemplate.DataName == 'FreeFireUpgrade' ||
			TestTemplate.DataName == 'FreeFireUpgrade_Bsc' ||
			TestTemplate.DataName == 'FreeFireUpgrade_Adv' ||
			TestTemplate.DataName == 'FreeFireUpgrade_Sup')
		{
			return true;
		}
	}

	return false;
}

/*
	Added 10/3/18
	Checks if there exist the Aim Upgrade. Return true if it does exist, false otherwise
*/

static function bool NoAimUpgradePresent(array<X2WeaponUpgradeTemplate> AllUpgradeTemplates)
{
	return !AimUpgradePresent(AllUpgradeTemplates);
}

static function bool AimUpgradePresent(array<X2WeaponUpgradeTemplate> AllUpgradeTemplates)
{
	local X2WeaponUpgradeTemplate TestTemplate;

	foreach AllUpgradeTemplates(TestTemplate)
	{
		if (TestTemplate.DataName == 'AimUpgrade' ||
			TestTemplate.DataName == 'AimUpgrade_Bsc' ||
			TestTemplate.DataName == 'AimUpgrade_Adv' ||
			TestTemplate.DataName == 'AimUpgrade_Sup' ||
			TestTemplate.DataName == 'AimBetterUpgrade')
		{
			return true;
		}
	}

	return false;
}
/*
	Added 12/27/18
	Checks if there exist the Crit Upgrade. Return true if it does exist, false otherwise
*/

static function bool NoCritUpgradePresent(array<X2WeaponUpgradeTemplate> AllUpgradeTemplates)
{
	return !CritUpgradePresent(AllUpgradeTemplates);
}

static function bool CritUpgradePresent(array<X2WeaponUpgradeTemplate> AllUpgradeTemplates)
{
	local X2WeaponUpgradeTemplate TestTemplate;

	foreach AllUpgradeTemplates(TestTemplate)
	{
		if (TestTemplate.DataName == 'CritUpgrade_Bsc' ||
			TestTemplate.DataName == 'CritUpgrade_Adv' ||
			TestTemplate.DataName == 'CritUpgrade_Sup')
		{
			return true;
		}
	}

	return false;
}

static function bool NoAnyAimUpgradePresent(array<X2WeaponUpgradeTemplate> AllUpgradeTemplates)
{
	return !AnyAimUpgradePresent(AllUpgradeTemplates);
}

static function bool AnyAimUpgradePresent(array<X2WeaponUpgradeTemplate> AllUpgradeTemplates)
{
	if ( CritUpgradePresent(AllUpgradeTemplates) || AimUpgradePresent(AllUpgradeTemplates) )
		return true;
	else
		return false;
}