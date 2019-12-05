`define CLASSNAME X2DownloadableContentInfo_EUWeaponPack 
class `CLASSNAME() extends X2DownloadableContentInfo implements(OrderControl_Interface) config(EUWeapons);

struct WeaponAttachment {
	var string Type;
	var name AttachSocket;
	var name UIArmoryCameraPointTag;
	var string MeshName;
	var string ProjectileName;
	var name MatchWeaponTemplate;
	var bool AttachToPawn;
	var string IconName;
	var string InventoryIconName;
	var string InventoryCategoryIcon;
	var name AttachmentFn;
};

var config array<WeaponAttachment> Attachements;

var OrderControl_Controller Controller;

static event OnPostTemplatesCreated() {
	local `CLASSNAME() MyInstance;

	MyInstance = `CLASSNAME()(class'OrderControl'.static.GetMyInstance(default.DLCIdentifier));

	MyInstance.AllocateController();
	MyInstance.Controller.Setup(default.DLCIdentifier);

	if (!MyInstance.Controller.IsReady())
		return;

	OC_OnPostTemplatesCreated();

	`log(default.DLCIdentifier $ " ran successfully!");
	MyInstance.Controller.Finished();
}

function AllocateController() {
	if (Controller == none) {
		Controller = new(none, "") class'OrderControl_Controller';
		class'OrderControl'.static.LocalSetup(Controller);
	}
}

function OrderControl_Controller GetController() {
	AllocateController();
	return Controller;
}

static event OC_OnPostTemplatesCreated()
{
	if (class'X2Item_EUWeaponPack'.default.LightPlasmaSMG) {
		class'X2Item_EUWeaponPack'.static.MakeLightPlasmaSomethingElse();
	} else if (class'X2Item_EUWeaponPack'.default.LightPlasmaBullpup) {
		class'X2Item_EUWeaponPack'.static.MakeLightPlasmaSomethingElse(false, 'Bullpup_BM');
	}

	AddAttachments();

	if (class'X2Item_EUWeaponPack'.default.RemoveBeamTierWeapons) {
		class'X2Item_EUWeaponPack'.static.RemoveBeamTierBaseItems();
	}
}

static function AddAttachments()
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

	foreach AttachmentTypes(AttachmentType)
	{
		AddAttachment(AttachmentType, default.Attachements);
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
	
	foreach Attachments(Attachment)
	{
		if (InStr(string(TemplateName), Attachment.Type) != INDEX_NONE)
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
				default:
					CheckFN = none;
					break;
			}
			Template.AddUpgradeAttachment(Attachment.AttachSocket, Attachment.UIArmoryCameraPointTag, Attachment.MeshName, Attachment.ProjectileName, Attachment.MatchWeaponTemplate, Attachment.AttachToPawn, Attachment.IconName, Attachment.InventoryIconName, Attachment.InventoryCategoryIcon, CheckFN);
			`LOG("Attachment for" @ TemplateName @ Attachment.Type @ Attachment.AttachSocket @ Attachment.UIArmoryCameraPointTag @ Attachment.MeshName @ Attachment.MatchWeaponTemplate @ Attachment.AttachToPawn @Attachment.IconName @Attachment.InventoryIconName @Attachment.InventoryCategoryIcon,, 'EUWeaponPack');
		}
	}
}

exec function ForceEUWeaponPackUpdate() 
{
	AddWeaponsToHQ();
}

static event OnLoadedSavedGame()
{
	AddWeaponsToHQ();
}

static function AddWeaponsToHQ()
{
    local XComGameStateHistory History;
    local XComGameState NewGameState;
	local XComGameState_HeadquartersXCom XComHQ;
	local bool SMG_Installed;
	local bool UsingBullpup;
    
    History = `XCOMHISTORY;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating HQ");
    XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
    XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));

	if (class'X2Item_EUWeaponPack'.default.LightPlasmaSMG) {
		if (class'OrderControl'.static.GetMyInstance("LW_SMGPack_WotC") != none) {
			SMG_Installed = true;
		}
	} else if (class'X2Item_EUWeaponPack'.default.LightPlasmaBullpup) {
		UsingBullpup = true;
	}

	SearchAddItem(XComHQ, NewGameState, 'AssaultRifle_BM', 'AssaultRifle_PL');
	SearchAddItem(XComHQ, NewGameState, 'SniperRifle_BM', 'SniperRifle_PL');
	SearchAddItem(XComHQ, NewGameState, 'Cannon_BM', 'Cannon_PL');
	SearchAddItem(XComHQ, NewGameState, 'Shotgun_BM', 'Shotgun_PL');
	SearchAddItem(XComHQ, NewGameState, 'Pistol_BM', 'Pistol_PL');

	if (SMG_Installed) {
		SearchAddItem(XComHQ, NewGameState, 'SMG_BM', 'LightPlasmaRifle_PL');
	} else if (UsingBullpup) {
		SearchAddItem(XComHQ, NewGameState, 'Bullpup_BM', 'LightPlasmaRifle_PL');
	} else {
		SearchAddItem(XComHQ, NewGameState, 'AssaultRifle_BM', 'LightPlasmaRifle_PL');
	}

	History.AddGameStateToHistory(NewGameState);
}

static function SearchAddItem(XComGameState_HeadquartersXCom XComHQ, XComGameState NewGameState, name RequiredItem, name Item)
{
	local X2ItemTemplate Template;
	local X2ItemTemplateManager ItemTemplateManager;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    Template = ItemTemplateManager.FindItemTemplate(RequiredItem);
    if (XComHQ.HasItem(Template))
    {
        AddItemToXComHQ(NewGameState, XComHQ, ItemTemplateManager, Item);
    }
}

static function AddItemToXComHQ(XComGameState NewGameState, XComGameState_HeadquartersXCom XComHQ, X2ItemTemplateManager ItemTemplateManager, name TemplateName)
{
    local X2ItemTemplate Template;
	local XComGameState_Item ItemState;

	Template = ItemTemplateManager.FindItemTemplate(TemplateName);
	if (!XComHQ.HasItem(Template))
		{
			ItemState = Template.CreateInstanceFromTemplate(NewGameState);
			NewGameState.AddStateObject(ItemState);
			XComHQ.AddItemToHQInventory(ItemState);
		}
}
