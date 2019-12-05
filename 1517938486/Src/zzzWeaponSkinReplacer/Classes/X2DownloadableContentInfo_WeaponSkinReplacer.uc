class X2DownloadableContentInfo_WeaponSkinReplacer extends X2DownloadableContentInfo dependson(XComGameState_HiddenItems) config(WeaponSkinReplacer);// dependson(X2TacticalGameRulesetDataStructures);

// todo
//	replace targeting reticule

const bLog = true;

struct AttachStruct
{
    var name TEMPLATE;
	var name SOCKET;
	var name SOCKET_REPLACEMENT;
	var string TYPE;
	var string ORIGINAL_MESH;
	var string REPLACEMENT_MESH;
};
var config array<AttachStruct> ATTACHMENT_REPLACEMENT;

struct AbilityAnimationStruct
{
    var name ABILITY_NAME;
	var name ANIMATION_NAME;
};

struct CategoryStruct
{
    var name TEMPLATE;

	var name SET_ITEM_CAT;
	var string INVENTORY_IMAGE;
	var name CREATOR_TEMPLATE_NAME;
	var name BASE_ITEM;
	var EInventorySlot SET_INVENTORY_SLOT;
	var int TIER;
	var int SET_INFINITE_ITEM;
	var int SET_CAN_BE_BUILT;

	var name SET_ARMOR_CLASS;
	
	var name SET_WEAPON_CAT;
	var WeaponDamageValue SET_DAMAGE;
	var int AIM;
	var int CRIT;
	var int CLIPSIZE;
	var int ENVIRONMENT_DAMAGE;
	var int SOUND_RANGE;
	var int MAX_RANGE;
	var int RADIUS;
	var int INFINITE_AMMO;
	var array<int> RANGE_ACCURACY;
	var int TYPICAL_ACTION_COST;
	var int NUM_UPGRADE_SLOTS;
	var AbilityAnimationStruct SET_ANIMATION_FOR_ABILITY;
	var ELocation STOWED_LOCATION;
	var name OVERWATCH_ACTION_POINT;

	var StrategyRequirement REQUIREMENTS;
	var bool TECH_TEMPLATE;
	var int PROVING_GROUNDS_PROJECT;

	var array<name>	REWARD_DECKS;

	var bool SCHEMATIC_TEMPLATE;
	var name HIDE_IF_PURCHASED;
	var bool CHANGE_REQUIREMENTS;
	var bool PRESERVE_SPECIAL_REQUIREMENT_FN;
	var int POINTS_TO_COMPLETE;
	var array<ArtifactCost> RESOURCE_COSTS;
	var array<ArtifactCost> ARTIFACT_COSTS;

	//	setting some values to improbable 1337 so that the user can set 0 or -1 if need be
	structdefaultproperties
	{
		TIER = 1337
		SET_INFINITE_ITEM = -1
		SET_CAN_BE_BUILT = -1

		NUM_UPGRADE_SLOTS = -1
		STOWED_LOCATION = -1
		SET_INVENTORY_SLOT=eInvSlot_Unknown
		POINTS_TO_COMPLETE = -1

		SET_DAMAGE = (Damage = -1)
		TYPICAL_ACTION_COST = 1337
		ENVIRONMENT_DAMAGE = 1337
		CRIT = 1337
		AIM  = 1337
		SOUND_RANGE = 1337
		MAX_RANGE = 1337
		RADIUS = 1337
	}
};
var config array<CategoryStruct> CHANGE_TEMPLATE;

/*
struct native StrategyRequirement
{
	var array<Name>			RequiredTechs;
	var bool				bVisibleIfTechsNotMet;
	var array<Name>			RequiredItems;
	var array<Name>         AlternateRequiredItems;
	var array<ArtifactCost> RequiredItemQuantities;
	var bool				bVisibleIfItemsNotMet;
	var array<Name>			RequiredEquipment;
	var bool				bDontRequireAllEquipment;
	var bool				bVisibleIfRequiredEquipmentNotMet;
	var array<Name>			RequiredFacilities;
	var bool				bVisibleIfFacilitiesNotMet;
	var array<Name>			RequiredUpgrades;
	var bool				bVisibleIfUpgradesNotMet;
	var int					RequiredEngineeringScore;
	var int					RequiredScienceScore;
	var bool				bVisibleIfPersonnelGatesNotMet;
	var int					RequiredHighestSoldierRank;
	var Name				RequiredSoldierClass;
	var bool				RequiredSoldierRankClassCombo;
	var bool				bVisibleIfSoldierRankGatesNotMet;
	var array<Name>			RequiredObjectives;
	var bool				bVisibleIfObjectivesNotMet;
*/
/*
struct native ArtifactCost
{
	var name ItemTemplateName;
	var int Quantity;
};*/

struct GiveAbilitiesStruct
{
    var name TEMPLATE;
	var name WEAPON_CAT;
	var name ITEM_CAT;
	var name ARMOR_CLASS;
	var name CHARACTER;

	var name ABILITY;
	var name REMOVE_ABILITY;
	var bool REMOVE_ORIGINAL_ABILITIES;
	var bool ALLOW_DUPLICATES;
};
var config array<GiveAbilitiesStruct> GIVE_ABILITIES;

struct DefaultAttachStruct
{
    var name TEMPLATE;
	var name SOCKET;
	var string MESH;
	var bool REMOVE_ORIGINAL;
};
var config array<DefaultAttachStruct> DEFAULT_ATTACHMENT;

struct WeaponStruct
{
    var name ACCEPTOR_TEMPLATE;
	var name DONOR_TEMPLATE;
	var string DONOR_GAME_ARCHETYPE;
	var string REPLACEMENT_MESH;
	var bool HIDE_DONOR_TEMPLATE;
	var bool HIDE_DONOR_SCHEMATIC;
	var bool COPY_DONOR_ATTACHMENTS;
	var bool HIDE_ACCEPTOR_ATTACHMENTS;
	var bool COPY_LOCALIZATION;
};
var config array<WeaponStruct> WEAPON_REPLACEMENT;

struct WeaponSocketStruct
{
    var name TEMPLATE;
	var name BONE;
	var name SOCKET_NAME;

	var float OFFSET_X;
	var float OFFSET_Y;
	var float OFFSET_Z;

	var float ROLL;
	var float PITCH;
	var float YAW;

	var float dROLL;
	var float dPITCH;
	var float dYAW;
	
	var float SCALE_X;
	var float SCALE_Y;
	var float SCALE_Z;

	structdefaultproperties
	{
		OFFSET_X=0
		OFFSET_Y=0
		OFFSET_Z=0

		ROLL=0
		PITCH=0
		YAW=0
		
		dROLL=0
		dPITCH=0
		dYAW=0

		SCALE_X=1.0f
		SCALE_Y=1.0f
		SCALE_Z=1.0f
	}
};
var config array<WeaponSocketStruct> SOCKETS_TO_ADD;

struct ProjectileStruct
{
    var name ACCEPTOR_TEMPLATE;
	var name DONOR_TEMPLATE;
	var string DONOR_GAME_ARCHETYPE;
	var string PROJECTILE_PATH;
	var float OVERRIDE_PROJECTILE_SPEED;

	structdefaultproperties
	{
		OVERRIDE_PROJECTILE_SPEED = -1;
	}
};
var config array<ProjectileStruct> PROJECTILE_REPLACEMENT;

struct AnimSetStruct
{
    var name ACCEPTOR_TEMPLATE;
	var name DONOR_TEMPLATE;

	var string DONOR_GAME_ARCHETYPE;
	var bool REPLACE_WEAPON_ANIMSETS;
	var bool REPLACE_SOLDIER_ANIMSETS;

	var bool REMOVE_ORIGINAL_SOLDIER_ANIMSETS;
	var bool REMOVE_ORIGINAL_WEAPON_ANIMSETS;

	var array<string> SOLDIER_ANIMSET_PATHS;
	var array<string> SOLDIER_FEMALE_ANIMSET_PATHS;
	var array<string> WEAPON_ANIMSET_PATHS;

	//	leaving this just so Beagle's config doesn't break.
	var name FIRE_SUPPRESSION_ANIM_NAME;	

	var name WeaponFireAnimSequenceName;
	var name WeaponFireKillAnimSequenceName;
	var name WeaponSuppressionFireAnimSequenceName;
	var name WeaponMoveEndFireAnimSequenceName;
	var name WeaponMoveEndFireKillAnimSequenceName;
	var name WeaponMoveEndTurnLeftFireAnimSequenceName;
	var name WeaponMoveEndTurnLeftFireKillAnimSequenceName;
	var name WeaponMoveEndTurnRightFireAnimSequenceName;
	var name WeaponMoveEndTurnRightFireKillAnimSequenceName;
};
var config array<AnimSetStruct> ANIMSET_REPLACEMENT;

var config array<name> SCHEMATICS_TO_HIDE;	
var config array<name> WEAPONS_TO_HIDE;
var config array<name> WEAPONS_TO_HIDE_KEEP_SCHEMATIC;

struct AddWeaponAttachment 
{
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
var config array<AddWeaponAttachment> ADD_ATTACHMENTS;

var config bool ENABLE_LOGGING;

var config bool PRINT_WEAPON_INFO;
var config bool PRINT_SCHEMATIC_NAMES;
var config bool PRINT_GAME_ARCHETYPES;
var config bool PRINT_PROJECTILES;
var config bool PRINT_ANIMSETS;
var config bool PRINT_DEFAULT_ATTACHMENTS;
var config bool PRINT_WEAPON_ATTACHMENTS;
var config bool PRINT_FIRE_ANIMATION_NAMES;

//	Used in DLCAppendWeaponSockets to convert socket rotation in degrees to int value used by the game.
//	Value to this const is assigned in default_properties at the end.
var const float RAD_INTO_DEG;


static event OnPostTemplatesCreated()
{
	local X2ItemTemplateManager	ItemMgr;

	ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.ChangeTemplates(ItemMgr);
	/*
	class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.PrintInfo(ItemMgr);

	class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.ReplaceWeapons(ItemMgr);
	class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.HideSchematics(ItemMgr);
	class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.HideWeapons(ItemMgr);
	class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.HideWeaponsKeepSchematics(ItemMgr);

	class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.CopyAttachments(ItemMgr);
	class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.ReplaceAttachments(ItemMgr);
	class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.AddDefaultAttachments(ItemMgr);

	class'X2DownloadableContentInfo_WeaponSkinReplacer'.static.AddAttachments(ItemMgr);*/
	
}

exec function WSRResetHiddenItemsList()
{
	local XComGameState				NewGameState;
	local XComGameState_HiddenItems NewStateObject;
	local XComGameStateHistory		History;

	`LOG("WSRResetHiddenItemsList activated.", bLog, 'IRIHIDEITEMS');

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("IRIDAR Removing unwanted weapons");
	NewStateObject = XComGameState_HiddenItems(History.GetSingleGameStateObjectForClass(class'XComGameState_HiddenItems'));

	if (NewStateObject == none) 
	{
		`LOG("Error, could not retrieve New State Object.", bLog, 'IRIHIDEITEMS');
		return;
	}
	else
	{
		`LOG("Current Num Hidden Items:" @ NewStateObject.HiddenItems.Length, bLog, 'IRIHIDEITEMS');
	}
	NewStateObject =  XComGameState_HiddenItems(NewGameState.ModifyStateObject( class'XComGameState_HiddenItems', NewStateObject.ObjectID));

	NewStateObject.HiddenItems.Length = 0;
	History.AddGameStateToHistory(NewGameState);
}

static event OnLoadedSavedGame()	//	Triggers when the player loads a save game for the first time after adding this mod
{
	UpdateStorage();
}

static event OnLoadedSavedGameToStrategy()	//	Triggers when you load a saved game
{
	//DeleteHiddenItems();
	UpdateStorage();
}

static function DeleteHiddenItems()
{
	local XComGameState				NewGameState;
	local XComGameState_HiddenItems NewStateObject;
	local bool						bChangedSomething;
	local XComGameState_HeadquartersXCom	XComHQ;
	local array<name>				HiddenItemNames;
	local Name						ItemName;
	local XComGameState_Item		ItemState;
	local XComGameStateHistory		History;
	local X2ItemTemplate			ItemTemplate;
	local bool						bWasInfinite;


	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("IRIDAR Removing unwanted weapons");
	NewStateObject = XComGameState_HiddenItems(History.GetSingleGameStateObjectForClass(class'XComGameState_HiddenItems'));

	if (NewStateObject == none) return;

	HiddenItemNames = NewStateObject.GetHiddenItemNames();

	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', `XCOMHQ.ObjectID));

	`LOG("Num hidden items: " @ HiddenItemNames.Length, bLog, 'IRIHIDEITEMS');

	foreach HiddenItemNames(ItemName)
	{
		`LOG("Hidden Item: " @ ItemName, bLog, 'IRIHIDEITEMS');
		ItemState = XComHQ.GetItemByName(ItemName);
		if (ItemState != none)
		{
			`LOG("Present in the HQ, removing.", bLog, 'IRIHIDEITEMS');
			ItemTemplate = ItemState.GetMyTemplate();
			bWasInfinite = false;
			if (ItemTemplate.bInfiniteItem)
			{
				ItemTemplate.bInfiniteItem = false;
				bWasInfinite = true;
			}

			if (XComHQ.RemoveItemFromInventory(NewGameState, ItemState.GetReference(), ItemState.Quantity))
			{	
				`LOG("Removed successfully.", bLog, 'IRIHIDEITEMS');
				bChangedSomething = true;
				NewGameState.RemoveStateObject(ItemState.ObjectID);
			}
			else
			{
				`LOG("Failed to remove.", bLog, 'IRIHIDEITEMS');
			}

			if (bWasInfinite)
			{
				ItemTemplate.bInfiniteItem = true;
			}
		}
	}

	if (bChangedSomething) 
	{
		`LOG("End list, submitting Game State.", bLog, 'IRIHIDEITEMS');
		History.AddGameStateToHistory(NewGameState);
	}
	else History.CleanupPendingGameState(NewGameState);
}

static event InstallNewCampaign(XComGameState StartState)
{	
	//local XComGameState_HiddenItems HiddenItemsStateObject;

	//HiddenItemsStateObject = new class'XComGameState_HiddenItems';

	`LOG("New campaign start, adding Hidden Item State Object.",, 'IRIHIDEITEMS');

	//HiddenItemsStateObject = XComGameState_HiddenItems(StartState.CreateNewStateObject(class'XComGameState_HiddenItems'));
	if (XComGameState_HiddenItems(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HiddenItems')) == none)
	StartState.CreateNewStateObject(class'XComGameState_HiddenItems');

	//StartState.AddStateObject(HiddenItemsStateObject);
}

static function ReplaceWeapons(X2ItemTemplateManager ItemMgr)
{
	local X2WeaponTemplate		Template;	//	Acceptor template
	local X2WeaponTemplate		DonorTemplate;	//	Donor template
	local XComContentManager	Content;
	local int i;

	Content = `CONTENT;

	`LOG("==========================================", default.ENABLE_LOGGING, 'WSR');
	`LOG("WEAPON_REPLACEMENT Start..................", default.ENABLE_LOGGING, 'WSR');

	for (i=0;i<default.WEAPON_REPLACEMENT.Length;i++)
	{
		Template = X2WeaponTemplate(ItemMgr.FindItemTemplate(default.WEAPON_REPLACEMENT[i].ACCEPTOR_TEMPLATE));
		if(Template == None)
		{
			`LOG("WEAPON_REPLACEMENT Error, could not find the Acceptor Template: " @ default.WEAPON_REPLACEMENT[i].ACCEPTOR_TEMPLATE, default.ENABLE_LOGGING, 'WSR');
			continue;
		}

		if (default.WEAPON_REPLACEMENT[i].DONOR_TEMPLATE != '')
		{
			DonorTemplate = X2WeaponTemplate(ItemMgr.FindItemTemplate(default.WEAPON_REPLACEMENT[i].DONOR_TEMPLATE));
			if(DonorTemplate == None)
			{
				`LOG("WEAPON_REPLACEMENT Error, could not find the Donor Template: " @ default.WEAPON_REPLACEMENT[i].DONOR_TEMPLATE, default.ENABLE_LOGGING, 'WSR');
				continue;
			}

			`LOG("WEAPON_REPLACEMENT Success, replacing" @ Template.DataName @ "with Donor Template: " @ default.WEAPON_REPLACEMENT[i].DONOR_TEMPLATE, default.ENABLE_LOGGING, 'WSR');

			//	copy the weapon's appearance
			Template.DefaultAttachments = DonorTemplate.DefaultAttachments;
			Template.GameArchetype = DonorTemplate.GameArchetype;
			Template.strImage = DonorTemplate.strImage;
			Template.WeaponPanelImage = DonorTemplate.WeaponPanelImage;
			Template.EquipSound = DonorTemplate.EquipSound;
			Template.UIArmoryCameraPointTag = DonorTemplate.UIArmoryCameraPointTag;

			//	localization
			//	note: building this requires to unprotect localized vars in X2ItemTemplate
			if (default.WEAPON_REPLACEMENT[i].COPY_LOCALIZATION)
			{
				Template.FriendlyName = DonorTemplate.FriendlyName;
				Template.FriendlyNamePlural = DonorTemplate.FriendlyNamePlural;
				Template.BriefSummary = DonorTemplate.BriefSummary;
				Template.TacticalText = DonorTemplate.TacticalText;
				Template.AbilityDescName = DonorTemplate.AbilityDescName;
				Template.BlackMarketTexts = DonorTemplate.BlackMarketTexts;
				Template.LootTooltip = DonorTemplate.LootTooltip;
			}
		}
		if (default.WEAPON_REPLACEMENT[i].DONOR_GAME_ARCHETYPE != "")
		{
			if (XComWeapon(Content.RequestGameArchetype(default.WEAPON_REPLACEMENT[i].DONOR_GAME_ARCHETYPE)) != none) 
			{
				`LOG("WEAPON_REPLACEMENT Success, replacing Game Archetype for " @ Template.DataName @ "with" @ default.WEAPON_REPLACEMENT[i].DONOR_GAME_ARCHETYPE, default.ENABLE_LOGGING, 'WSR');
				Template.GameArchetype = default.WEAPON_REPLACEMENT[i].DONOR_GAME_ARCHETYPE;
			}
			else `LOG("WEAPON_REPLACEMENT Error, could not find the Donor Game Archetype: " @ default.WEAPON_REPLACEMENT[i].DONOR_GAME_ARCHETYPE, default.ENABLE_LOGGING, 'WSR');
		}

		if(default.WEAPON_REPLACEMENT[i].HIDE_DONOR_TEMPLATE)
		{
			DonorTemplate.StartingItem = false;	//	This is enough to hide weapons from new game
			DonorTemplate.CanBeBuilt = false;	
			//DonorTemplate.bInfiniteItem = false;	//	Thought this would help, but it doesn't do anything on loading a save game
		}

		if(default.WEAPON_REPLACEMENT[i].HIDE_DONOR_SCHEMATIC)
		{
			//	Hide the creator schematic for the donor weapon
			if (ItemMgr.FindItemTemplate(DonorTemplate.CreatorTemplateName) != none)
			{
				X2SchematicTemplate(ItemMgr.FindItemTemplate(DonorTemplate.CreatorTemplateName)).CanBeBuilt = false;
			}
			else `LOG("WEAPON_REPLACEMENT Error, could not find the Donor Schematic to hide: " @ default.WEAPON_REPLACEMENT[i].DONOR_TEMPLATE, default.ENABLE_LOGGING, 'WSR');
		}
	}
}

static function HideSchematics(X2ItemTemplateManager ItemMgr)
{
	local X2SchematicTemplate	Template;
	local X2TechTemplate		TechTemplate;
	local name					TemplateName;

	`LOG("==========================================", default.ENABLE_LOGGING, 'WSR');
	`LOG("SCHEMATICS_TO_HIDE Start..................", default.ENABLE_LOGGING, 'WSR');
	//	Additionally hide any schematics specified in the config
	foreach default.SCHEMATICS_TO_HIDE(TemplateName)
	{
		Template = X2SchematicTemplate(ItemMgr.FindItemTemplate(TemplateName));
		if (Template == None)
		{
			TechTemplate = X2TechTemplate(class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager().FindStrategyElementTemplate(TemplateName));
			
			if (TechTemplate == none)
			{
				//`LOG("SCHEMATICS_TO_HIDE Error, could not find the Weapon Schematic to hide: " @ TemplateName, default.ENABLE_LOGGING, 'WSR');
				continue;
			}
			else 
			{
				//`LOG("SCHEMATICS_TO_HIDE Success, hiding schematic from Proving Ground: " @ TemplateName, default.ENABLE_LOGGING, 'WSR');
				//TechTemplate.bProvingGround = false;	//makes it appear as research instead
				//TechTemplate.Requirements.RequiredTechs.AddItem('ImpossibleTech');
				//TechTemplate.Requirements.bVisibleIfTechsNotMet = false;
			}
		}
		else
		{	
			`LOG("SCHEMATICS_TO_HIDE Success, hiding schematic: " @ TemplateName, default.ENABLE_LOGGING, 'WSR');
			Template.CanBeBuilt = false;	
		}
	}
}

static function HideWeapons(X2ItemTemplateManager ItemMgr)
{
	local name				TemplateName;
	local X2WeaponTemplate	Template;
	local X2SchematicTemplate SchematicTemplate;
	
	`LOG("==========================================", default.ENABLE_LOGGING, 'WSR');
	`LOG("WEAPONS_TO_HIDE Start.....................", default.ENABLE_LOGGING, 'WSR');
	//	Additionally hide any weapons specified in the config
	foreach default.WEAPONS_TO_HIDE(TemplateName)
	{
		Template = X2WeaponTemplate(ItemMgr.FindItemTemplate(TemplateName));
		if(Template == None)
		{
			`LOG("WEAPONS_TO_HIDE Error, could not find the Weapon Template to hide: " @ TemplateName, default.ENABLE_LOGGING, 'WSR');
			continue;
		}
		Template.BaseItem = '';
		Template.StartingItem = false;
		Template.CanBeBuilt = false;	

		//	and their templates
		if (Template.CreatorTemplateName != '')
		{
			SchematicTemplate = X2SchematicTemplate(ItemMgr.FindItemTemplate(Template.CreatorTemplateName));

			if (SchematicTemplate != none)
			{
				SchematicTemplate.CanBeBuilt = false;	
				Template.CreatorTemplateName = '';
			}
			else
			{
				`LOG("WEAPONS_TO_HIDE Error, could not find the Weapon Schematic to hide: " @ Template.CreatorTemplateName, default.ENABLE_LOGGING, 'WSR');
			}
		}
	}
}

static function GiveAbilities(X2ItemTemplateManager ItemMgr)
{
	local X2EquipmentTemplate	EqTemplate;
	local X2DataTemplate		DataTemplate;
	local X2ArmorTemplate		ArmorTemplate;
	local X2WeaponTemplate		Template;
	local array<X2EquipmentTemplate>	EqTemplates;
	local array<X2WeaponTemplate>		Templates;
	local int i;

	local X2CharacterTemplateManager	CharMgr;
	local X2CharacterTemplate			CharTemplate;

	`LOG("==========================================", default.ENABLE_LOGGING, 'WSR');
	`LOG("GIVE_ABILITIES Start.....................", default.ENABLE_LOGGING, 'WSR');
	//	Additionally hide any weapons specified in the config

	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	for (i=0; i < default.GIVE_ABILITIES.Length; i++)
	{
		// Give abilities to specific items by template name
		if (default.GIVE_ABILITIES[i].TEMPLATE != '')
		{
			EqTemplate = X2EquipmentTemplate(ItemMgr.FindItemTemplate(default.GIVE_ABILITIES[i].TEMPLATE));
			if (EqTemplate == None)
			{
				`LOG("GIVE_ABILITIES Error, could not find the Equipment Template to give an ability to: " @ default.GIVE_ABILITIES[i].TEMPLATE, default.ENABLE_LOGGING, 'WSR');
				continue;
			}
			else
			{	
				if (default.GIVE_ABILITIES[i].ALLOW_DUPLICATES || EqTemplate.Abilities.Find(default.GIVE_ABILITIES[i].ABILITY) == INDEX_NONE) 
				{
					`LOG("GIVE_ABILITIES Success, adding" @ default.GIVE_ABILITIES[i].ABILITY @ "to Equipment Template: " @ default.GIVE_ABILITIES[i].TEMPLATE, default.ENABLE_LOGGING, 'WSR');

					if (default.GIVE_ABILITIES[i].REMOVE_ORIGINAL_ABILITIES)
					{
						EqTemplate.Abilities.Length = 0;
					}
					if (default.GIVE_ABILITIES[i].ABILITY != '') EqTemplate.Abilities.AddItem(default.GIVE_ABILITIES[i].ABILITY);
				}
				if (default.GIVE_ABILITIES[i].REMOVE_ABILITY != '') EqTemplate.Abilities.RemoveItem(default.GIVE_ABILITIES[i].REMOVE_ABILITY);
			}
		}
		//	give abilties to weapons by weapon category
		if (default.GIVE_ABILITIES[i].WEAPON_CAT != '')
		{
			if (ItemMgr.WeaponCategories.Find(default.GIVE_ABILITIES[i].WEAPON_CAT) == INDEX_NONE)
			{
				`LOG("GIVE_ABILITIES Warning, " @ default.GIVE_ABILITIES[i].WEAPON_CAT @ "is not a valid Weapon Category", default.ENABLE_LOGGING, 'WSR');
			}

			Templates = ItemMgr.GetAllWeaponTemplates();
			foreach Templates(Template)
			{
				if(Template.WeaponCat == default.GIVE_ABILITIES[i].WEAPON_CAT)
				{
					if (default.GIVE_ABILITIES[i].ALLOW_DUPLICATES || Template.Abilities.Find(default.GIVE_ABILITIES[i].ABILITY) == INDEX_NONE) 
					{
						if (default.GIVE_ABILITIES[i].REMOVE_ORIGINAL_ABILITIES)
						{
							Template.Abilities.Length = 0;
						}
						if (default.GIVE_ABILITIES[i].ABILITY != '') 
						{
							Template.Abilities.AddItem(default.GIVE_ABILITIES[i].ABILITY);
							`LOG("GIVE_ABILITIES Success, adding ability" @ default.GIVE_ABILITIES[i].ABILITY @ "to" @ Template.DataName @ "by Weapon Cat: " @ default.GIVE_ABILITIES[i].WEAPON_CAT, default.ENABLE_LOGGING, 'WSR');
						}
					}
					if (default.GIVE_ABILITIES[i].REMOVE_ABILITY != '') 
					{
						Template.Abilities.RemoveItem(default.GIVE_ABILITIES[i].REMOVE_ABILITY);
						`LOG("GIVE_ABILITIES Success, removing ability" @ default.GIVE_ABILITIES[i].REMOVE_ABILITY @ "from" @ Template.DataName @ "by Weapon Cat: " @ default.GIVE_ABILITIES[i].WEAPON_CAT, default.ENABLE_LOGGING, 'WSR');
					}
				}
			}
		}

		//	give abilities to items by item category
		if (default.GIVE_ABILITIES[i].ITEM_CAT != '')
		{
			foreach ItemMgr.IterateTemplates(DataTemplate, none)
			{
				EqTemplate = X2EquipmentTemplate(DataTemplate);

				if (EqTemplate != none)
				{
					if (EqTemplate.ItemCat == default.GIVE_ABILITIES[i].ITEM_CAT)
					{
						if (default.GIVE_ABILITIES[i].ALLOW_DUPLICATES || EqTemplate.Abilities.Find(default.GIVE_ABILITIES[i].ABILITY) == INDEX_NONE) 
						{
							//`LOG("GIVE_ABILITIES Success, adding" @ default.GIVE_ABILITIES[i].ABILITY @ "to Item Template: " @ EqTemplate.DataName, default.ENABLE_LOGGING, 'WSR');
							if (default.GIVE_ABILITIES[i].REMOVE_ORIGINAL_ABILITIES)
							{
								EqTemplate.Abilities.Length = 0;
							}
							if (default.GIVE_ABILITIES[i].ABILITY != '') EqTemplate.Abilities.AddItem(default.GIVE_ABILITIES[i].ABILITY);
						}
						if (default.GIVE_ABILITIES[i].REMOVE_ABILITY != '') EqTemplate.Abilities.RemoveItem(default.GIVE_ABILITIES[i].REMOVE_ABILITY);
					}
				}
			}
		}

		//	give abilities to armors by armor class
		EqTemplates = ItemMgr.GetAllArmorTemplates();
		foreach EqTemplates(EqTemplate)
		{
			ArmorTemplate = X2ArmorTemplate(EqTemplate);
			if (ArmorTemplate != none)
			{
				if (ArmorTemplate.ArmorClass == default.GIVE_ABILITIES[i].ARMOR_CLASS)
				{
					if (default.GIVE_ABILITIES[i].ALLOW_DUPLICATES || ArmorTemplate.Abilities.Find(default.GIVE_ABILITIES[i].ABILITY) == INDEX_NONE) 
					{
						if (default.GIVE_ABILITIES[i].REMOVE_ORIGINAL_ABILITIES)
						{
							ArmorTemplate.Abilities.Length = 0;
						}
						if (default.GIVE_ABILITIES[i].ABILITY != '') ArmorTemplate.Abilities.AddItem(default.GIVE_ABILITIES[i].ABILITY);
					}
					if (default.GIVE_ABILITIES[i].REMOVE_ABILITY != '') ArmorTemplate.Abilities.RemoveItem(default.GIVE_ABILITIES[i].REMOVE_ABILITY);
				}
			}
		}

		//	give abilties to characters by their character template name
		if (default.GIVE_ABILITIES[i].CHARACTER != '')
		{
			CharTemplate = CharMgr.FindCharacterTemplate(default.GIVE_ABILITIES[i].CHARACTER);
			if (CharTemplate != none)
			{
				if (default.GIVE_ABILITIES[i].REMOVE_ORIGINAL_ABILITIES)
				{
					 CharTemplate.Abilities.Length = 0;
				}
				if (default.GIVE_ABILITIES[i].ABILITY != '') 
				{
					if (default.GIVE_ABILITIES[i].ALLOW_DUPLICATES || CharTemplate.Abilities.Find(default.GIVE_ABILITIES[i].ABILITY) == INDEX_NONE) 
					{
						CharTemplate.Abilities.AddItem(default.GIVE_ABILITIES[i].ABILITY);
					}
				}
				if (default.GIVE_ABILITIES[i].REMOVE_ABILITY != '') CharTemplate.Abilities.RemoveItem(default.GIVE_ABILITIES[i].REMOVE_ABILITY);
			}
			else `LOG("GIVE_ABILITIES Error, could not find character template to give abilities to: " @ default.GIVE_ABILITIES[i].CHARACTER,, 'WSR');
		}

	}
}

static function ChangeTemplates(X2ItemTemplateManager ItemMgr)
{
	local X2DataTemplate        DataTemplate;
	local array<X2DataTemplate> DifficultyVariants;
	local int i;

	`LOG("==========================================", default.ENABLE_LOGGING, 'WSR');
	`LOG("CHANGE_TEMPLATE Start................", default.ENABLE_LOGGING, 'WSR');
	//	Additionally hide any weapons specified in the config

	for (i=0; i < default.CHANGE_TEMPLATE.Length; i++)
	{
		// Give abilities to specific items by template name
		if (default.CHANGE_TEMPLATE[i].TEMPLATE != '')
		{
			DataTemplate = ItemMgr.FindItemTemplate(default.CHANGE_TEMPLATE[i].TEMPLATE);
			if (DataTemplate.bShouldCreateDifficultyVariants)
			{
				ItemMgr.FindDataTemplateAllDifficulties(DataTemplate.DataName, DifficultyVariants);
				foreach DifficultyVariants(DataTemplate)
				{
					ProcessTemplate(DataTemplate, i, ItemMgr);
				}
			}
			else
			{
				ProcessTemplate(DataTemplate, i, ItemMgr);
			}
		}
	}
}

static function ProcessTemplate(X2DataTemplate DataTemplate, int i, X2ItemTemplateManager ItemMgr)
{
	local X2ItemTemplate		ItemTemplate;
	local X2ArmorTemplate		ArmorTemplate;
	local X2WeaponTemplate		WeaponTemplate;
	local X2EquipmentTemplate	EquipmentTemplate;
	local X2SchematicTemplate	SchematicTemplate;

	local X2StrategyElementTemplateManager	TechMgr;
	local X2TechTemplate					TechTemplate;
	local StrategyRequirement				DelegateHolder;

	ItemTemplate = X2ItemTemplate(DataTemplate);
	WeaponTemplate = X2WeaponTemplate(ItemTemplate);
	ArmorTemplate = X2ArmorTemplate(ItemTemplate);
	EquipmentTemplate = X2EquipmentTemplate(ItemTemplate);

	//	=================================================================
	//	ITEM TEMPLATES
	if (ItemTemplate != none)
	{
		//	set CreatorTemplateName
		if (default.CHANGE_TEMPLATE[i].CREATOR_TEMPLATE_NAME != '')
		{
			`LOG("CHANGE_TEMPLATE Success, changing CreatorTemplateName for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to" @ default.CHANGE_TEMPLATE[i].CREATOR_TEMPLATE_NAME, default.ENABLE_LOGGING, 'WSR');
			ItemTemplate.CreatorTemplateName = default.CHANGE_TEMPLATE[i].CREATOR_TEMPLATE_NAME;
		}

		//	set BaseItem
		if (default.CHANGE_TEMPLATE[i].BASE_ITEM != '')
		{
			`LOG("CHANGE_TEMPLATE Success, changing Base Item for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to" @ default.CHANGE_TEMPLATE[i].BASE_ITEM, default.ENABLE_LOGGING, 'WSR');
			ItemTemplate.BaseItem = default.CHANGE_TEMPLATE[i].BASE_ITEM;
		}

		//	set Item Category by Template Name
		if (default.CHANGE_TEMPLATE[i].SET_ITEM_CAT != '')
		{
			`LOG("CHANGE_TEMPLATE Success, changing Item Category for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to" @ default.CHANGE_TEMPLATE[i].SET_ITEM_CAT, default.ENABLE_LOGGING, 'WSR');
			ItemTemplate.ItemCat = default.CHANGE_TEMPLATE[i].SET_ITEM_CAT;
		}
		if (default.CHANGE_TEMPLATE[i].SET_INFINITE_ITEM != -1)
		{
			if (default.CHANGE_TEMPLATE[i].SET_INFINITE_ITEM == 0)
			{
				`LOG("CHANGE_TEMPLATE Success, changing Infinite Item for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to NOT infinite.", default.ENABLE_LOGGING, 'WSR');
				ItemTemplate.bInfiniteItem = false;
			}
			if (default.CHANGE_TEMPLATE[i].SET_INFINITE_ITEM > 0)
			{
				`LOG("CHANGE_TEMPLATE Success, changing Infinite Item for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to TRUE and CanBeBuilt to FALSE.", default.ENABLE_LOGGING, 'WSR');
				ItemTemplate.bInfiniteItem = true;
				ItemTemplate.CanBeBuilt = false;
			}	
		}
		if (default.CHANGE_TEMPLATE[i].SET_CAN_BE_BUILT != -1)
		{
			if (default.CHANGE_TEMPLATE[i].SET_CAN_BE_BUILT == 0)
			{
				`LOG("CHANGE_TEMPLATE Success, changing Can Be Built for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to FALSE.", default.ENABLE_LOGGING, 'WSR');
				ItemTemplate.CanBeBuilt = false;
			}
			if (default.CHANGE_TEMPLATE[i].SET_CAN_BE_BUILT > 0)
			{
				`LOG("CHANGE_TEMPLATE Success, changing Can Be Built for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to TRUE and Infinite Item to FALSE.", default.ENABLE_LOGGING, 'WSR');
				ItemTemplate.CanBeBuilt = true;
				ItemTemplate.bInfiniteItem = false;
			}	
		}		

		//	Change Inventory Image
		if (default.CHANGE_TEMPLATE[i].INVENTORY_IMAGE != "")
		{
			`LOG("CHANGE_TEMPLATE Success, changing Inventory Image for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to" @ default.CHANGE_TEMPLATE[i].INVENTORY_IMAGE, default.ENABLE_LOGGING, 'WSR');
			ItemTemplate.strImage = default.CHANGE_TEMPLATE[i].INVENTORY_IMAGE;
		}
		//	Change Tier
		if (default.CHANGE_TEMPLATE[i].TIER != 1337)
		{
			`LOG("CHANGE_TEMPLATE Success, changing Tier for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to" @ default.CHANGE_TEMPLATE[i].TIER, default.ENABLE_LOGGING, 'WSR');
			ItemTemplate.Tier = default.CHANGE_TEMPLATE[i].TIER;
		}

		//	Change Reward Decks
		if (default.CHANGE_TEMPLATE[i].REWARD_DECKS.Length > 0)
		{
			ItemTemplate.RewardDecks = default.CHANGE_TEMPLATE[i].REWARD_DECKS;
		}		

		//	Change resource costs
		if (default.CHANGE_TEMPLATE[i].RESOURCE_COSTS.Length > 0)
		{
			ItemTemplate.Cost.ResourceCosts = default.CHANGE_TEMPLATE[i].RESOURCE_COSTS;
		}
		if (default.CHANGE_TEMPLATE[i].ARTIFACT_COSTS.Length > 0)
		{
			ItemTemplate.Cost.ArtifactCosts = default.CHANGE_TEMPLATE[i].ARTIFACT_COSTS;
		}
		//	Change strategic requirements
		if (default.CHANGE_TEMPLATE[i].CHANGE_REQUIREMENTS)
		{
			//	can't assign delegates via .ini files, so just at least trying to preserve the original delegate if its there by storing it temporarily in another variable
			DelegateHolder.SpecialRequirementsFn = ItemTemplate.Requirements.SpecialRequirementsFn;
			ItemTemplate.Requirements = default.CHANGE_TEMPLATE[i].REQUIREMENTS;

			if (default.CHANGE_TEMPLATE[i].PRESERVE_SPECIAL_REQUIREMENT_FN) 
			{
				ItemTemplate.Requirements.SpecialRequirementsFn = DelegateHolder.SpecialRequirementsFn;
			}
			else
			{
				ItemTemplate.Requirements.SpecialRequirementsFn = none;
			}

			DelegateHolder.SpecialRequirementsFn = none;
		}
	}
	else
	{
		`LOG("CHANGE_TEMPLATE Error, could not find the Item Template: " @ default.CHANGE_TEMPLATE[i].TEMPLATE, default.ENABLE_LOGGING, 'WSR');
	}

	//	=================================================================
	//	ARMOR TEMPLATES
	if (ArmorTemplate != none)
	{
		//	Set Armor Class
		if (default.CHANGE_TEMPLATE[i].SET_ARMOR_CLASS != '')
		{
			`LOG("CHANGE_TEMPLATE Success, changing Armor Class for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to" @ default.CHANGE_TEMPLATE[i].SET_ARMOR_CLASS, default.ENABLE_LOGGING, 'WSR');
			ArmorTemplate.ArmorClass = default.CHANGE_TEMPLATE[i].SET_ITEM_CAT;
		}
	}
	else
	{
		`LOG("CHANGE_TEMPLATE Not an Armor Template: " @ default.CHANGE_TEMPLATE[i].TEMPLATE, default.ENABLE_LOGGING, 'WSR');
	}

	//	=================================================================
	//	WEAPON TEMPLATES
	if (WeaponTemplate != none)
	{
		//	Change Weapon Cat
		if (default.CHANGE_TEMPLATE[i].SET_WEAPON_CAT != '')
		{
			`LOG("CHANGE_TEMPLATE Success, changing Weapon Category for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to" @ default.CHANGE_TEMPLATE[i].SET_WEAPON_CAT, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.WeaponCat = default.CHANGE_TEMPLATE[i].SET_WEAPON_CAT;
		}

		//	set damage
		if (default.CHANGE_TEMPLATE[i].SET_DAMAGE.Damage != -1)
		{
			`LOG("CHANGE_TEMPLATE Success, changing Damage for" @ default.CHANGE_TEMPLATE[i].TEMPLATE, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.BaseDamage = default.CHANGE_TEMPLATE[i].SET_DAMAGE;
			WeaponTemplate.DamageTypeTemplateName = default.CHANGE_TEMPLATE[i].SET_DAMAGE.DamageType;
		}

		//	set range accuracy
		if (default.CHANGE_TEMPLATE[i].RANGE_ACCURACY.Length > 0)
		{
			`LOG("CHANGE_TEMPLATE Success, changing Range Accuracy and Range for" @ default.CHANGE_TEMPLATE[i].TEMPLATE, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.RangeAccuracy = default.CHANGE_TEMPLATE[i].RANGE_ACCURACY; 
		}

		//	Typical Action Cost
		if (default.CHANGE_TEMPLATE[i].TYPICAL_ACTION_COST != 1337)
		{
			`LOG("CHANGE_TEMPLATE Success: " @ default.CHANGE_TEMPLATE[i].TEMPLATE @ " will now have Typical Action Cost of: " @ default.CHANGE_TEMPLATE[i].TYPICAL_ACTION_COST, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.iTypicalActionCost = default.CHANGE_TEMPLATE[i].TYPICAL_ACTION_COST;
		}

		//	Set Max Range
		if (default.CHANGE_TEMPLATE[i].MAX_RANGE != 1337)
		{
			`LOG("CHANGE_TEMPLATE Success, changing Range Accuracy and Range for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ ", new Range: " @ default.CHANGE_TEMPLATE[i].MAX_RANGE, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.iRange = default.CHANGE_TEMPLATE[i].MAX_RANGE;
		}

		//	Set Max Range
		if (default.CHANGE_TEMPLATE[i].RADIUS != 1337)
		{
			`LOG("CHANGE_TEMPLATE Success, changing Range Accuracy and Range for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ ", new Radius: " @ default.CHANGE_TEMPLATE[i].RADIUS, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.iRadius = default.CHANGE_TEMPLATE[i].RADIUS;
		}			

		//	Aim
		if (default.CHANGE_TEMPLATE[i].AIM != 1337)
		{
			`LOG("CHANGE_TEMPLATE Success: " @ default.CHANGE_TEMPLATE[i].TEMPLATE @ " will now have Aim: " @ default.CHANGE_TEMPLATE[i].AIM, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.Aim = default.CHANGE_TEMPLATE[i].AIM;
		}

		//	Crit
		if (default.CHANGE_TEMPLATE[i].CRIT != 1337)
		{
			`LOG("CHANGE_TEMPLATE Success: " @ default.CHANGE_TEMPLATE[i].TEMPLATE @ " will now have Crit: " @ default.CHANGE_TEMPLATE[i].CRIT, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.CritChance = default.CHANGE_TEMPLATE[i].CRIT;
		}
				
		//	Environmental Damage
		if (default.CHANGE_TEMPLATE[i].ENVIRONMENT_DAMAGE != 1337)
		{
			`LOG("CHANGE_TEMPLATE Success: " @ default.CHANGE_TEMPLATE[i].TEMPLATE @ " will now have Environmental Damage: " @ default.CHANGE_TEMPLATE[i].ENVIRONMENT_DAMAGE, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.iEnvironmentDamage = default.CHANGE_TEMPLATE[i].ENVIRONMENT_DAMAGE;
		}

		//	SOUND_RANGE
		if (default.CHANGE_TEMPLATE[i].SOUND_RANGE != 1337)
		{
			`LOG("CHANGE_TEMPLATE Success: " @ default.CHANGE_TEMPLATE[i].TEMPLATE @ " will now have Sound Range: " @ default.CHANGE_TEMPLATE[i].SOUND_RANGE, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.iSoundRange = default.CHANGE_TEMPLATE[i].SOUND_RANGE;
		}

		
		if (default.CHANGE_TEMPLATE[i].OVERWATCH_ACTION_POINT != '')
		{
			`LOG("CHANGE_TEMPLATE Success: " @ default.CHANGE_TEMPLATE[i].TEMPLATE @ " will now use Overwatch Action Point: " @ default.CHANGE_TEMPLATE[i].OVERWATCH_ACTION_POINT, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.OverwatchActionPoint = default.CHANGE_TEMPLATE[i].OVERWATCH_ACTION_POINT;
		}

		// STOWED_LOCATION
		if (default.CHANGE_TEMPLATE[i].STOWED_LOCATION != -1)
		{
			`LOG("CHANGE_TEMPLATE Success: " @ default.CHANGE_TEMPLATE[i].TEMPLATE @ " will now have Stowed Location: " @ default.CHANGE_TEMPLATE[i].STOWED_LOCATION @ "from" @ WeaponTemplate.StowedLocation, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.StowedLocation = default.CHANGE_TEMPLATE[i].STOWED_LOCATION;
		}
								
		//	Clipsize
		if (default.CHANGE_TEMPLATE[i].CLIPSIZE != 0)
		{
			`LOG("CHANGE_TEMPLATE Success: " @ default.CHANGE_TEMPLATE[i].TEMPLATE @ " will now have Clipsize: " @ default.CHANGE_TEMPLATE[i].CLIPSIZE, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.iClipSize = default.CHANGE_TEMPLATE[i].CLIPSIZE;
		}

		//NUM_UPGRADE_SLOTS
		if (default.CHANGE_TEMPLATE[i].NUM_UPGRADE_SLOTS != -1)
		{
			`LOG("CHANGE_TEMPLATE Success: " @ default.CHANGE_TEMPLATE[i].TEMPLATE @ " will now have Upgrade Slots: " @ default.CHANGE_TEMPLATE[i].NUM_UPGRADE_SLOTS, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.NumUpgradeSlots = default.CHANGE_TEMPLATE[i].NUM_UPGRADE_SLOTS;
		}

		//	Infinite Ammo
		if (default.CHANGE_TEMPLATE[i].INFINITE_AMMO != 0)
		{
			if (default.CHANGE_TEMPLATE[i].INFINITE_AMMO > 0)
			{
				`LOG("CHANGE_TEMPLATE Success: " @ default.CHANGE_TEMPLATE[i].TEMPLATE @ " will now have Infinite Ammo.", default.ENABLE_LOGGING, 'WSR');
				WeaponTemplate.InfiniteAmmo = true;
			}
			else
			{
				`LOG("CHANGE_TEMPLATE Success: " @ default.CHANGE_TEMPLATE[i].TEMPLATE @ " will no longer have Infinite Ammo.", default.ENABLE_LOGGING, 'WSR');
				WeaponTemplate.InfiniteAmmo = false;
			}
		}
				
		//	Set Animations for abilities
		if (default.CHANGE_TEMPLATE[i].SET_ANIMATION_FOR_ABILITY.ABILITY_NAME != '')
		{
			`LOG("CHANGE_TEMPLATE Success: " @ default.CHANGE_TEMPLATE[i].TEMPLATE @ " will now use animation: " @ default.CHANGE_TEMPLATE[i].SET_ANIMATION_FOR_ABILITY.ANIMATION_NAME @ "with ability:" @ default.CHANGE_TEMPLATE[i].SET_ANIMATION_FOR_ABILITY.ABILITY_NAME, default.ENABLE_LOGGING, 'WSR');
			WeaponTemplate.SetAnimationNameForAbility(default.CHANGE_TEMPLATE[i].SET_ANIMATION_FOR_ABILITY.ABILITY_NAME, default.CHANGE_TEMPLATE[i].SET_ANIMATION_FOR_ABILITY.ANIMATION_NAME);
		}				
	}
	else
	{
		`LOG("CHANGE_TEMPLATE Not a Weapon Template: " @ default.CHANGE_TEMPLATE[i].TEMPLATE, default.ENABLE_LOGGING, 'WSR');
	}

	//	=================================================================
	//	EQUIPMENT TEMPLATES
	if (EquipmentTemplate != none)
	{
		//	set Inventory Slot
		if (default.CHANGE_TEMPLATE[i].SET_INVENTORY_SLOT != eInvSlot_Unknown)
		{
			`LOG("CHANGE_TEMPLATE Success, changing Inventory Slot for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to" @ default.CHANGE_TEMPLATE[i].SET_INVENTORY_SLOT, default.ENABLE_LOGGING, 'WSR');
			EquipmentTemplate.InventorySlot = default.CHANGE_TEMPLATE[i].SET_INVENTORY_SLOT;
		}
	}
	else
	{
		`LOG("CHANGE_TEMPLATE Not an Equipment Template: " @ default.CHANGE_TEMPLATE[i].TEMPLATE, default.ENABLE_LOGGING, 'WSR');
	}

	//	Change tech templates, which is research and proving grounds projects
	if (default.CHANGE_TEMPLATE[i].TECH_TEMPLATE)
	{
		TechMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

		TechTemplate = X2TechTemplate(TechMgr.FindStrategyElementTemplate(default.CHANGE_TEMPLATE[i].TEMPLATE));

		if (TechTemplate != none)
		{
			`LOG("CHANGE_TEMPLATE Success, found Tech Template to change:" @ default.CHANGE_TEMPLATE[i].TEMPLATE, default.ENABLE_LOGGING, 'WSR');


			if (default.CHANGE_TEMPLATE[i].PROVING_GROUNDS_PROJECT != 0)
			{
				if (default.CHANGE_TEMPLATE[i].PROVING_GROUNDS_PROJECT > 0)
				{
					`LOG("CHANGE_TEMPLATE Success, Tech Template:" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "will now be a Proving Grounds project.", default.ENABLE_LOGGING, 'WSR');
					TechTemplate.bProvingGround = true;
				}
				else
				{
					`LOG("CHANGE_TEMPLATE Success, Tech Template:" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "will now be a Research project.", default.ENABLE_LOGGING, 'WSR');
					TechTemplate.bProvingGround = false;
				}
			}

			if (default.CHANGE_TEMPLATE[i].CHANGE_REQUIREMENTS)
			{
				//	can't assign delegates via .ini files, so just at least trying to preserve the original delegate if its there by storing it temporarily in another variable
				DelegateHolder.SpecialRequirementsFn = TechTemplate.Requirements.SpecialRequirementsFn;

				TechTemplate.Requirements = default.CHANGE_TEMPLATE[i].REQUIREMENTS;

				if (default.CHANGE_TEMPLATE[i].PRESERVE_SPECIAL_REQUIREMENT_FN) 
				{
					TechTemplate.Requirements.SpecialRequirementsFn = DelegateHolder.SpecialRequirementsFn;
				}
				else
				{
					TechTemplate.Requirements.SpecialRequirementsFn = none;
				}
				DelegateHolder.SpecialRequirementsFn = none;
			}
			if (default.CHANGE_TEMPLATE[i].POINTS_TO_COMPLETE != -1)
			{
				TechTemplate.PointsToComplete = default.CHANGE_TEMPLATE[i].POINTS_TO_COMPLETE;
				`LOG("CHANGE_TEMPLATE Success, changed Points-to-Complete for Tech Template:" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to" @ default.CHANGE_TEMPLATE[i].POINTS_TO_COMPLETE, default.ENABLE_LOGGING, 'WSR');
			}
			if (default.CHANGE_TEMPLATE[i].RESOURCE_COSTS.Length > 0)
			{
				TechTemplate.Cost.ResourceCosts = default.CHANGE_TEMPLATE[i].RESOURCE_COSTS;
			}
			if (default.CHANGE_TEMPLATE[i].ARTIFACT_COSTS.Length > 0)
			{
				TechTemplate.Cost.ArtifactCosts = default.CHANGE_TEMPLATE[i].ARTIFACT_COSTS;
			}

			if (default.CHANGE_TEMPLATE[i].INVENTORY_IMAGE != "")
			{
				`LOG("CHANGE_TEMPLATE Success, changing Inventory Image for" @ default.CHANGE_TEMPLATE[i].TEMPLATE @ "to" @ default.CHANGE_TEMPLATE[i].INVENTORY_IMAGE, default.ENABLE_LOGGING, 'WSR');
				TechTemplate.strImage = default.CHANGE_TEMPLATE[i].INVENTORY_IMAGE;
			}
		}
		else
		{
			`LOG("CHANGE_TEMPLATE Error, could not find the Tech Template to change: " @ default.CHANGE_TEMPLATE[i].TEMPLATE, default.ENABLE_LOGGING, 'WSR');
		}
	}

	//	Change schematic templates, which is (mostly?) engineering unlocks
	if (default.CHANGE_TEMPLATE[i].SCHEMATIC_TEMPLATE)
	{
		SchematicTemplate = X2SchematicTemplate(ItemMgr.FindItemTemplate(default.CHANGE_TEMPLATE[i].TEMPLATE));

		if (SchematicTemplate != none)
		{
			`LOG("CHANGE_TEMPLATE Success, found Schematic Template to change:" @ default.CHANGE_TEMPLATE[i].TEMPLATE, default.ENABLE_LOGGING, 'WSR');
			if (default.CHANGE_TEMPLATE[i].CHANGE_REQUIREMENTS)
			{
				//	can't assign delegates via .ini files, so just at least trying to preserve the original delegate if its there by storing it temporarily in another variable
				DelegateHolder.SpecialRequirementsFn = SchematicTemplate.Requirements.SpecialRequirementsFn;
				SchematicTemplate.Requirements = default.CHANGE_TEMPLATE[i].REQUIREMENTS;

				if (default.CHANGE_TEMPLATE[i].PRESERVE_SPECIAL_REQUIREMENT_FN) 
				{
					SchematicTemplate.Requirements.SpecialRequirementsFn = DelegateHolder.SpecialRequirementsFn;
				}
				else
				{
					SchematicTemplate.Requirements.SpecialRequirementsFn = none;
				}

				DelegateHolder.SpecialRequirementsFn = none;
			}
			/*
			if (default.CHANGE_TEMPLATE[i].POINTS_TO_COMPLETE != -1)
			{
				SchematicTemplate.PointsToComplete = default.CHANGE_TEMPLATE[i].POINTS_TO_COMPLETE;
			}*/
			if (default.CHANGE_TEMPLATE[i].RESOURCE_COSTS.Length > 0)
			{
				SchematicTemplate.Cost.ResourceCosts = default.CHANGE_TEMPLATE[i].RESOURCE_COSTS;
			}
			if (default.CHANGE_TEMPLATE[i].ARTIFACT_COSTS.Length > 0)
			{
				SchematicTemplate.Cost.ArtifactCosts = default.CHANGE_TEMPLATE[i].ARTIFACT_COSTS;
			}
			if (default.CHANGE_TEMPLATE[i].HIDE_IF_PURCHASED != '')
			{
				SchematicTemplate.HideIfPurchased = default.CHANGE_TEMPLATE[i].HIDE_IF_PURCHASED;
			}
					
		}
		else
		{
			`LOG("CHANGE_TEMPLATE Error, could not find the Schematic Template to change: " @ default.CHANGE_TEMPLATE[i].TEMPLATE, default.ENABLE_LOGGING, 'WSR');
		}
	}
}

static function HideWeaponsKeepSchematics(X2ItemTemplateManager ItemMgr)
{
	local name				TemplateName;
	local X2WeaponTemplate	Template;

	`LOG("==========================================", default.ENABLE_LOGGING, 'WSR');
	`LOG("WEAPONS_TO_HIDE_KEEP_SCHEMATIC Start......", default.ENABLE_LOGGING, 'WSR');
		//	Additionally hide any weapons specified in the config
	foreach default.WEAPONS_TO_HIDE_KEEP_SCHEMATIC(TemplateName)
	{
		Template = X2WeaponTemplate(ItemMgr.FindItemTemplate(TemplateName));
		if(Template == None)
		{
			`LOG("WEAPONS_TO_HIDE_KEEP_SCHEMATIC Error, could not find the Weapon Template to hide: " @ TemplateName, default.ENABLE_LOGGING, 'WSR');
			continue;
		}
		else
		{
			`LOG("WEAPONS_TO_HIDE_KEEP_SCHEMATIC Success, hiding the Weapon Template: " @ TemplateName, default.ENABLE_LOGGING, 'WSR');
			Template.BaseItem = '';
			Template.CreatorTemplateName = '';
			Template.StartingItem = false;
			Template.CanBeBuilt = false;	
		}
	}
}

static function PrintInfo(X2ItemTemplateManager ItemMgr)
{
	local X2DataTemplate		DataTemplate;
	local X2WeaponTemplate		Template;
	local XComWeapon			GameArchetype;
	local XComContentManager	Content;
	local SkeletalMeshComponent	WeaponMesh;
	local int i;

	local array<X2WeaponUpgradeTemplate>	UpgradeTemplates;
	local X2WeaponUpgradeTemplate			UpgradeTemplate;

	if (!default.PRINT_WEAPON_INFO) return;

	Content = `CONTENT;

	//	Print intro
	`LOG("==========================================",, 'WSR');
	`LOG("",, 'WSR');
	`LOG("BEGIN WEAPON SKIN REPLACER PRINT OUT",, 'WSR');
	`LOG("",, 'WSR');
	`LOG("==========================================",, 'WSR');
	`LOG("",, 'WSR');

	foreach ItemMgr.IterateTemplates(DataTemplate)
	{
		Template = X2WeaponTemplate(DataTemplate);
		if (Template != none)
		{
			`LOG("-----------------",, 'WSR');
			`LOG("Found weapon: " @ Template.GetItemFriendlyName(),, 'WSR');
			`LOG("Template Name: " @ Template.DataName,, 'WSR');

			if (default.PRINT_SCHEMATIC_NAMES)
			`LOG("Engineering Schematic Name: " @ Template.CreatorTemplateName,, 'WSR');

			if (default.PRINT_GAME_ARCHETYPES)
			`LOG("Game Archetype: " @ Template.GameArchetype,, 'WSR');

			GameArchetype = XComWeapon(Content.RequestGameArchetype(Template.GameArchetype));
			if (GameArchetype == none)
			{
				`LOG("Could not access the Game Archetype.",, 'WSR');
			}
			else 
			{
				//	Projectile Path
				if (default.PRINT_PROJECTILES)
				`LOG("Projectile: " @ PathName(GameArchetype.DefaultProjectileTemplate),, 'WSR');

				if (default.PRINT_ANIMSETS)
				{
					//	Soldier Animsets
					for (i = 0; i < GameArchetype.CustomUnitPawnAnimsets.Length; i++)
					`LOG("AnimSets - Soldier: " @ PathName(GameArchetype.CustomUnitPawnAnimsets[i]),, 'WSR');

					for (i = 0; i < GameArchetype.CustomUnitPawnAnimsetsFemale.Length; i++)
					`LOG("AnimSets - Female: " @ PathName(GameArchetype.CustomUnitPawnAnimsetsFemale[i]),, 'WSR');

					//	Weapon's Animsets
					WeaponMesh = SkeletalMeshComponent(GameArchetype.Mesh);
					if (WeaponMesh != none)
					{
						for (i = 0; i < WeaponMesh.AnimSets.Length; i++)
						`LOG("Weapon AnimSets: " @ PathName(WeaponMesh.AnimSets[i]),, 'WSR');
					}
				}
				if (default.PRINT_FIRE_ANIMATION_NAMES)
				{
					`LOG("--WeaponFireAnimSequenceName: " @ GameArchetype.WeaponFireAnimSequenceName,, 'WSR');
					`LOG("--WeaponFireKillAnimSequenceName: " @ GameArchetype.WeaponFireKillAnimSequenceName,, 'WSR');
					`LOG("--WeaponFireKillAnimSequenceName: " @ GameArchetype.WeaponFireKillAnimSequenceName,, 'WSR');
					`LOG("--WeaponSuppressionFireAnimSequenceName: " @ GameArchetype.WeaponSuppressionFireAnimSequenceName,, 'WSR');
					`LOG("--WeaponMoveEndFireAnimSequenceName: " @ GameArchetype.WeaponMoveEndFireAnimSequenceName,, 'WSR');
					`LOG("--WeaponMoveEndFireKillAnimSequenceName: " @ GameArchetype.WeaponMoveEndFireKillAnimSequenceName,, 'WSR');
					`LOG("--WeaponMoveEndTurnLeftFireAnimSequenceName: " @ GameArchetype.WeaponMoveEndTurnLeftFireAnimSequenceName,, 'WSR');
					`LOG("--WeaponMoveEndTurnLeftFireKillAnimSequenceName: " @ GameArchetype.WeaponMoveEndTurnLeftFireKillAnimSequenceName,, 'WSR');
					`LOG("--WeaponMoveEndTurnRightFireAnimSequenceName: " @ GameArchetype.WeaponMoveEndTurnRightFireAnimSequenceName,, 'WSR');
					`LOG("--WeaponMoveEndTurnRightFireKillAnimSequenceName: " @ GameArchetype.WeaponMoveEndTurnRightFireKillAnimSequenceName,, 'WSR');
				}
			}
			if (default.PRINT_DEFAULT_ATTACHMENTS)
			{
				//	Weapon's Default Attachments
				for (i = 0; i < Template.DefaultAttachments.Length; i++)
				{
					`LOG("--Default Attachment in socket: " @ Template.DefaultAttachments[i].AttachSocket @ ", mesh: " @ Template.DefaultAttachments[i].AttachMeshName,, 'WSR');
				}
			}
		}
	}		

	if (default.PRINT_WEAPON_ATTACHMENTS)
	{
		`LOG("==========================================",, 'WSR');
		`LOG("",, 'WSR');
		`LOG("WEAPON ATTACHMENTS",, 'WSR');
		`LOG("",, 'WSR');
		`LOG("==========================================",, 'WSR');
		`LOG("",, 'WSR');

		UpgradeTemplates = ItemMgr.GetAllUpgradeTemplates();

		foreach UpgradeTemplates(UpgradeTemplate)
		{
			`LOG("------------------------------------------------------------------------------------------------------",, 'WSR');
			`LOG("Found upgrade: " @ UpgradeTemplate.GetItemFriendlyName(),, 'WSR');
			`LOG("Template Name: " @ UpgradeTemplate.DataName,, 'WSR');
			`LOG("",, 'WSR');
			for (i = 0; i < UpgradeTemplate.UpgradeAttachments.Length; i++)
			{
				`LOG("Attached to Weapon Template: " @ UpgradeTemplate.UpgradeAttachments[i].ApplyToWeaponTemplate,, 'WSR');
				`LOG("Socket: " @ UpgradeTemplate.UpgradeAttachments[i].AttachSocket,, 'WSR');
				`LOG("Mesh: " @ UpgradeTemplate.UpgradeAttachments[i].AttachMeshName,, 'WSR');
				`LOG("",, 'WSR');
			}
		}
	}

	//	Print Outro
	`LOG("",, 'WSR');
	`LOG("==========================================",, 'WSR');
	`LOG("",, 'WSR');
	`LOG("FINISH WEAPON SKIN REPLACER OUTPUT",, 'WSR');
	`LOG("",, 'WSR');
	`LOG("==========================================",, 'WSR');
}
/*
struct native WeaponAttachment
{
	var() name AttachSocket;
	var() name UIArmoryCameraPointTag;
	var() string AttachMeshName;
	var() EGender RequiredGender; // if gender is specified, only apply the attachment for characters of that gender
	var() string AttachIconName;
	var() string InventoryIconName;
	var() string InventoryCategoryIcon;
	var() string AttachProjectileName <ToolTip="Specifies additional projectile content that will play when a weapon with this upgrade is fired">;
	var() name ApplyToWeaponTemplate;
	var() bool AttachToPawn;
	var Object LoadedObject;
	var Object LoadedProjectileTemplate;
	var delegate<CheckUpgradeStatus>			ValidateAttachmentFn;
};*/

static function CopyAttachments(X2ItemTemplateManager ItemMgr)
{										
	local array<X2WeaponUpgradeTemplate>	UpgradeTemplates;
	local X2WeaponUpgradeTemplate			UpgradeTemplate;
	local WeaponStruct						WeaponReplacement;
	local bool								FoundAttachments;
	local int i;
	
	`LOG("==========================================", default.ENABLE_LOGGING, 'WSR');
	`LOG("Copying weapon attachments................", default.ENABLE_LOGGING, 'WSR');

	UpgradeTemplates = ItemMgr.GetAllUpgradeTemplates();

	//	Remove attachments from acceptor weapons, if they already have them configured
	foreach UpgradeTemplates(UpgradeTemplate)
	{
		for (i = 0; i < UpgradeTemplate.UpgradeAttachments.Length; i++)
		{
			foreach default.WEAPON_REPLACEMENT(WeaponReplacement)
			{
				if (WeaponReplacement.HIDE_ACCEPTOR_ATTACHMENTS)
				{
					if (UpgradeTemplate.UpgradeAttachments[i].ApplyToWeaponTemplate == WeaponReplacement.ACCEPTOR_TEMPLATE)
					{
						UpgradeTemplate.UpgradeAttachments.RemoveItem(UpgradeTemplate.UpgradeAttachments[i]);
						i--;
					}
				}
			}
		}
	}
	//	for each upgrade attachment, go through config array.
	foreach default.WEAPON_REPLACEMENT(WeaponReplacement)
	{
		if (WeaponReplacement.COPY_DONOR_ATTACHMENTS)
		{
			FoundAttachments = false;
			//	go through all Weapon Upgrade Templates. There's one for each of the upgrade items you see equippable in the armory, such as Basic Scope or Superior Laser Sight.
			foreach UpgradeTemplates(UpgradeTemplate)
			{
				//	go through all Upgrade Attachments in the Weapon Upgrade Template. There's one for each weapon this Upgrade can be applied to.
				for (i = 0; i < UpgradeTemplate.UpgradeAttachments.Length; i++)
				{
					//	if we find an attachment configured for the donor weapon, we copy it over for the acceptor weapon
					if (UpgradeTemplate.UpgradeAttachments[i].ApplyToWeaponTemplate == WeaponReplacement.DONOR_TEMPLATE)
					{
						FoundAttachments = true;
						UpgradeTemplate.AddUpgradeAttachment(UpgradeTemplate.UpgradeAttachments[i].AttachSocket, UpgradeTemplate.UpgradeAttachments[i].UIArmoryCameraPointTag, UpgradeTemplate.UpgradeAttachments[i].AttachMeshName, UpgradeTemplate.UpgradeAttachments[i].AttachProjectileName, WeaponReplacement.ACCEPTOR_TEMPLATE, UpgradeTemplate.UpgradeAttachments[i].AttachToPawn, UpgradeTemplate.UpgradeAttachments[i].AttachIconName, UpgradeTemplate.UpgradeAttachments[i].InventoryIconName, UpgradeTemplate.UpgradeAttachments[i].InventoryCategoryIcon, UpgradeTemplate.UpgradeAttachments[i].ValidateAttachmentFn);
					}
				}
			}
			if (!FoundAttachments) `LOG("Warning, WSR was unable to find Weapon Attachments to copy them from: " @ WeaponReplacement.DONOR_TEMPLATE @ " to " @ WeaponReplacement.ACCEPTOR_TEMPLATE, default.ENABLE_LOGGING, 'WSR');
		}
	}
}


static function AddDefaultAttachments(X2ItemTemplateManager ItemMgr)
{										
	local DefaultAttachStruct		DefStruct;
	local X2WeaponTemplate			Template;	

	`LOG("==========================================", default.ENABLE_LOGGING, 'WSR');
	`LOG("DEFAULT_ATTACHMENT Start..................", default.ENABLE_LOGGING, 'WSR');

	foreach default.DEFAULT_ATTACHMENT(DefStruct)
	{
		Template = X2WeaponTemplate(ItemMgr.FindItemTemplate(DefStruct.TEMPLATE));
		if(Template != none)
		{	
			if(DefStruct.REMOVE_ORIGINAL)
			{
				Template.DefaultAttachments.Length = 0;
			}
			//Template.DefaultAttachments.Length=0;	//	seems to work with this commented out
			Template.AddDefaultAttachment(DefStruct.SOCKET, DefStruct.MESH, , "");
		}
		else
		{
			`LOG("DEFAULT_ATTACHMENT Error, could not find the Weapon Template to add default attachments to: " @ DefStruct.TEMPLATE, default.ENABLE_LOGGING, 'WSR');
		}
	}
}

static function ReplaceAttachments(X2ItemTemplateManager ItemMgr)
{										
	local array<X2WeaponUpgradeTemplate>	Templates;
	local int i,j,z;

	`LOG("==========================================", default.ENABLE_LOGGING, 'WSR');
	`LOG("ATTACHMENT_REPLACEMENT Start..............", default.ENABLE_LOGGING, 'WSR');

	Templates = ItemMgr.GetAllUpgradeTemplates();

	//	For every upgrade template
	for (i=0; i < Templates.Length; i++)
	{	//	For each attachment in that upgrade template
		for (j = 0; j < Templates[i].UpgradeAttachments.Length; j++)
		{
			//	For every config array element
			for (z=0; z < default.ATTACHMENT_REPLACEMENT.Length; z++)
			{
				//	If the weapon upgrade type was specified, and there's not even a partial match for the current Weapon Upgrade, we skip to the next ATTACHMENT REPLACEMENT.
				if (default.ATTACHMENT_REPLACEMENT[z].TYPE != "" && InStr(string(Templates[i].DataName), default.ATTACHMENT_REPLACEMENT[z].TYPE) == INDEX_NONE)
				{
					continue;
				}
				//	If the attachment's weapon is the one we're looking for
				if(Templates[i].UpgradeAttachments[j].ApplyToWeaponTemplate == default.ATTACHMENT_REPLACEMENT[z].TEMPLATE && //	if the attachment matches the specified socket or if the socket is not specified
				(Templates[i].UpgradeAttachments[j].AttachSocket == default.ATTACHMENT_REPLACEMENT[z].SOCKET || default.ATTACHMENT_REPLACEMENT[z].SOCKET == ''))
				{	
					//	If the user is trying to hide ALL attachments in a specific socket
					if (default.ATTACHMENT_REPLACEMENT[z].ORIGINAL_MESH == "")
					{	
						//	We instead "detach" it from the weapon						
						Templates[i].UpgradeAttachments[j].AttachMeshName = default.ATTACHMENT_REPLACEMENT[z].REPLACEMENT_MESH;
					}
					else	//	If the user is trying to replace a specific attachment mesh with his own, or hide it
					{
						//	If this attachment doesn't have the specific mesh we're looking for, go to the next config array member
						if (Templates[i].UpgradeAttachments[j].AttachMeshName != default.ATTACHMENT_REPLACEMENT[z].ORIGINAL_MESH) continue;
						else	//	This IS the attachment mesh we're looking for
						{	
							//	The user is trying to hide it
							if(default.ATTACHMENT_REPLACEMENT[z].REPLACEMENT_MESH == "")
							{															
								//	We detach it from the weapon instead
								Templates[i].UpgradeAttachments[j].ApplyToWeaponTemplate='';
							}
							else	//	The user specified a replacement mesh
							{
								//	We replace the attachment's mesh with the specified one.
								Templates[i].UpgradeAttachments[j].AttachMeshName = default.ATTACHMENT_REPLACEMENT[z].REPLACEMENT_MESH;

								if(default.ATTACHMENT_REPLACEMENT[z].SOCKET_REPLACEMENT != '')	Templates[i].UpgradeAttachments[j].AttachSocket = default.ATTACHMENT_REPLACEMENT[z].SOCKET_REPLACEMENT;
							}						
						}
					}
				}
			}
		}
	}
}

static function UpdateStorage()
{
	local XComGameState NewGameState;
	local XComGameStateHistory History;
	local XComGameState_HeadquartersXCom XComHQ;
	local int i;
	local bool RemovedSomething, RemovedSomethingThisTime;
	local X2WeaponTemplate MusashiRage;

	`LOG("==========================================", default.ENABLE_LOGGING, 'WSR');
	`LOG("Removing items from HQ Inventory..........", default.ENABLE_LOGGING, 'WSR');

	History = `XCOMHISTORY;
	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("IRIDAR Removing unwanted weapons");
	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', XComHQ.ObjectID));
	//NewGameState.AddStateObject(XComHQ);

	for (i=0;i<default.WEAPON_REPLACEMENT.Length;i++)
	{
		if (!default.WEAPON_REPLACEMENT[i].HIDE_DONOR_TEMPLATE) continue;

		//	Remove items from armory inventory

		//	Items with their quantity set to zero remain in the inventory, though their in-game quantity meter disappears.
		//XComHQ.GetItemByName(default.WEAPON_REPLACEMENT[i].DONOR_TEMPLATE).Quantity = 0;

		//	Make them not infinite - that's usually enough to remove infinite items by itself, since their default quantity is zero anyway

		MusashiRage = X2WeaponTemplate(XComHQ.GetItemByName(default.WEAPON_REPLACEMENT[i].DONOR_TEMPLATE).GetMyTemplate());	//	Thanks Musashi, where I'd be without ya
		if(MusashiRage != None) MusashiRage.bInfiniteItem = false;	

		//	Supposedly should make weapon template unavailable, but does absolutely nothing in practice
		//X2WeaponTemplate(XComHQ.GetItemByName(default.WEAPON_REPLACEMENT[i].DONOR_TEMPLATE).GetMyTemplate()).SetTemplateAvailablility(0);	

		//	Literally remove them from HQ inventory - this removes a specified quantity, so it would work only on non-infinite items
		RemovedSomethingThisTime = XComHQ.RemoveItemFromInventory(NewGameState, XComHQ.GetItemByName(default.WEAPON_REPLACEMENT[i].DONOR_TEMPLATE).GetReference(), XComHQ.GetNumItemInInventory(default.WEAPON_REPLACEMENT[i].DONOR_TEMPLATE));
		
		//	Need the flag to decide whether to submit a new game state or not
		if(RemovedSomething != True && RemovedSomethingThisTime == True) RemovedSomething = True;
	}
	//	Repeat the same process for another config array
	for (i=0;i<default.WEAPONS_TO_HIDE.Length;i++)
	{
		MusashiRage = X2WeaponTemplate(XComHQ.GetItemByName(default.WEAPONS_TO_HIDE[i]).GetMyTemplate());
		if(MusashiRage != None) MusashiRage.bInfiniteItem = false;

		RemovedSomethingThisTime = XComHQ.RemoveItemFromInventory(NewGameState, XComHQ.GetItemByName(default.WEAPONS_TO_HIDE[i]).GetReference(), XComHQ.GetNumItemInInventory(default.WEAPONS_TO_HIDE[i]));
		if(RemovedSomething != True && RemovedSomethingThisTime == True) RemovedSomething = True;
	}
	for (i=0;i<default.WEAPONS_TO_HIDE_KEEP_SCHEMATIC.Length;i++)
	{
		MusashiRage = X2WeaponTemplate(XComHQ.GetItemByName(default.WEAPONS_TO_HIDE_KEEP_SCHEMATIC[i]).GetMyTemplate());
		if(MusashiRage != None) MusashiRage.bInfiniteItem = false;

		RemovedSomethingThisTime = XComHQ.RemoveItemFromInventory(NewGameState, XComHQ.GetItemByName(default.WEAPONS_TO_HIDE_KEEP_SCHEMATIC[i]).GetReference(), XComHQ.GetNumItemInInventory(default.WEAPONS_TO_HIDE_KEEP_SCHEMATIC[i]));
		if(RemovedSomething != True && RemovedSomethingThisTime == True) RemovedSomething = True;
	}

	//	Subming new game state if something actually changed
	if (RemovedSomething) History.AddGameStateToHistory(NewGameState);
	else History.CleanupPendingGameState(NewGameState);	//	otherwise scrap the newly created gamestate
}


static function WeaponInitialized(XGWeapon WeaponArchetype, XComWeapon Weapon, optional XComGameState_Item ItemState=none)
{
	local X2WeaponTemplate		DonorTemplate;
	local XComWeapon			DonorWeapon;
	local X2ItemTemplateManager	ItemMgr;
	local name					TemplateName;
	local ProjectileStruct		ProjectileReplacement;
	local AnimSetStruct			AnimSetReplacement;
	local XComContentManager	Content;
	local string				AnimSetName;
	local X2UnifiedProjectile	DonorProjectile;
	local AnimSet				AddAnimSet;
	local SkeletalMesh			SkelMesh;
	local int i;

    if (ItemState != none)
    {
		TemplateName = ItemState.GetMyTemplateName();
		Content = `CONTENT;

		`LOG("======= Weapon Skin Replacer =============", default.ENABLE_LOGGING, 'WSR');
		`LOG("Weapon Initialized: " @ TemplateName @ " for unit: " @ XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ItemState.OwnerStateObject.ObjectID)).GetFullName(), default.ENABLE_LOGGING, 'WSR');
		
		//	Replace weapon projectile
		//	cycle through all Projectile Replacement entries in the config file
		foreach default.PROJECTILE_REPLACEMENT(ProjectileReplacement)
		{	//	if this initialized weapon is specified in the entry
			if (TemplateName == ProjectileReplacement.ACCEPTOR_TEMPLATE)
			{
				//	replace projectile by path and exit cycle
				if (ProjectileReplacement.PROJECTILE_PATH != "") 
				{
					DonorProjectile = X2UnifiedProjectile(Content.RequestGameArchetype(ProjectileReplacement.PROJECTILE_PATH));
					if (DonorProjectile != none) 
					{
						Weapon.DefaultProjectileTemplate = DonorProjectile;
						`LOG("PROJECTILE_REPLACEMENT Success, replacing the projectile for: " @ ProjectileReplacement.ACCEPTOR_TEMPLATE @ "with" @ ProjectileReplacement.PROJECTILE_PATH, default.ENABLE_LOGGING, 'WSR');
					}
					else `LOG("PROJECTILE_REPLACEMENT Error, could not find the Donor Projectile: " @ ProjectileReplacement.PROJECTILE_PATH, default.ENABLE_LOGGING, 'WSR');
				}
				//	replace projectile from game archetype and exit cycle
				if (ProjectileReplacement.DONOR_GAME_ARCHETYPE != "") 
				{
					DonorWeapon = XComWeapon(Content.RequestGameArchetype(ProjectileReplacement.DONOR_GAME_ARCHETYPE));
					if (DonorWeapon != none) 
					{
						Weapon.DefaultProjectileTemplate = DonorWeapon.DefaultProjectileTemplate;
						`LOG("PROJECTILE_REPLACEMENT Success, replacing the projectile for: " @ ProjectileReplacement.ACCEPTOR_TEMPLATE @ "with projectile from" @ ProjectileReplacement.DONOR_GAME_ARCHETYPE, default.ENABLE_LOGGING, 'WSR');
					}
					else `LOG("PROJECTILE_REPLACEMENT Error, could not find the Donor Game Archetype: " @ ProjectileReplacement.DONOR_GAME_ARCHETYPE, default.ENABLE_LOGGING, 'WSR');
				}
				//	relace projectile from game archetype that we grab from donor template, then exit cycle
				if (ProjectileReplacement.DONOR_TEMPLATE != '') 
				{
					ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
					DonorTemplate = X2WeaponTemplate(ItemMgr.FindItemTemplate(ProjectileReplacement.DONOR_TEMPLATE));

					if (DonorTemplate != none)
					{
						DonorWeapon = XComWeapon(Content.RequestGameArchetype(DonorTemplate.GameArchetype));
						if (DonorWeapon != none) 
						{
							Weapon.DefaultProjectileTemplate = DonorWeapon.DefaultProjectileTemplate;
							`LOG("PROJECTILE_REPLACEMENT Success, replacing the projectile for: " @ ProjectileReplacement.ACCEPTOR_TEMPLATE @ "with projectile from" @ ProjectileReplacement.DONOR_TEMPLATE, default.ENABLE_LOGGING, 'WSR');
						}
						else `LOG("PROJECTILE_REPLACEMENT Error, could not find the Donor Game Archetype for Donor Weapon Template: " @ ProjectileReplacement.DONOR_TEMPLATE, default.ENABLE_LOGGING, 'WSR');
					}
					else `LOG("PROJECTILE_REPLACEMENT Error, could not find the Donor Weapon Template: " @ ProjectileReplacement.DONOR_TEMPLATE, default.ENABLE_LOGGING, 'WSR');
				}

				//	override projectile speed for all projectile elements in the weapon's projectile
				if (ProjectileReplacement.OVERRIDE_PROJECTILE_SPEED != -1)
				{
					for (i = 0; i < Weapon.DefaultProjectileTemplate.ProjectileElements.Length; i++)
					{
						Weapon.DefaultProjectileTemplate.ProjectileElements[i].TravelSpeed = ProjectileReplacement.OVERRIDE_PROJECTILE_SPEED;
					}
					`LOG("PROJECTILE_REPLACEMENT Success, overriding projectile speed for: " @ ProjectileReplacement.ACCEPTOR_TEMPLATE @ ", new speed: " @ ProjectileReplacement.OVERRIDE_PROJECTILE_SPEED, default.ENABLE_LOGGING, 'WSR');
				}

				//	stop cycling through PROJECTILE_REPLACEMENT array, because we've already done everything that needed to be done with this weapon that just got Initialized
				break;
			}
		}
		//	Replace animsets for weapon and soldier
		foreach default.ANIMSET_REPLACEMENT(AnimSetReplacement)
		{
			if (TemplateName == AnimSetReplacement.ACCEPTOR_TEMPLATE)
			{
				//	conditionally remove and add animsets
				if (AnimSetReplacement.REMOVE_ORIGINAL_SOLDIER_ANIMSETS)
				{	
					Weapon.CustomUnitPawnAnimsets.Length = 0;
					Weapon.CustomUnitPawnAnimsetsFemale.Length = 0;
				}
				if (AnimSetReplacement.REMOVE_ORIGINAL_WEAPON_ANIMSETS)
				{	
					SkeletalMeshComponent(Weapon.Mesh).AnimSets.Length = 0;
				}

				//	replace animsets from specified Game Archetype
				if (AnimSetReplacement.DONOR_GAME_ARCHETYPE != "")
				{
					DonorWeapon = XComWeapon(Content.RequestGameArchetype(AnimSetReplacement.DONOR_GAME_ARCHETYPE));

					if (DonorWeapon != none)
					{
						if (AnimSetReplacement.REPLACE_WEAPON_ANIMSETS)
						{
							SkeletalMeshComponent(Weapon.Mesh).AnimSets = SkeletalMeshComponent(DonorWeapon.Mesh).AnimSets;
						}
						if (AnimSetReplacement.REPLACE_SOLDIER_ANIMSETS)
						{
							Weapon.CustomUnitPawnAnimsets = DonorWeapon.CustomUnitPawnAnimsets;
							Weapon.CustomUnitPawnAnimsetsFemale = DonorWeapon.CustomUnitPawnAnimsetsFemale;
						}

						if (AnimSetReplacement.REPLACE_WEAPON_ANIMSETS && AnimSetReplacement.REPLACE_SOLDIER_ANIMSETS)
						{	
							Weapon.WeaponFireAnimSequenceName =  DonorWeapon.WeaponFireAnimSequenceName;
							Weapon.WeaponFireKillAnimSequenceName =  DonorWeapon.WeaponFireKillAnimSequenceName;
							Weapon.WeaponSuppressionFireAnimSequenceName =  DonorWeapon.WeaponSuppressionFireAnimSequenceName;
							Weapon.WeaponMoveEndFireAnimSequenceName =  DonorWeapon.WeaponMoveEndFireAnimSequenceName;
							Weapon.WeaponMoveEndFireKillAnimSequenceName =  DonorWeapon.WeaponMoveEndFireKillAnimSequenceName;
							Weapon.WeaponMoveEndTurnLeftFireAnimSequenceName =  DonorWeapon.WeaponMoveEndTurnLeftFireAnimSequenceName;
							Weapon.WeaponMoveEndTurnLeftFireKillAnimSequenceName =  DonorWeapon.WeaponMoveEndTurnLeftFireKillAnimSequenceName;
							Weapon.WeaponMoveEndTurnRightFireAnimSequenceName =  DonorWeapon.WeaponMoveEndTurnRightFireAnimSequenceName;
							Weapon.WeaponMoveEndTurnRightFireKillAnimSequenceName =  DonorWeapon.WeaponMoveEndTurnRightFireKillAnimSequenceName;
						}
					}
					else `LOG("ANIMSET_REPLACEMENT Error, could not find the Donor Game Archetype: " @ AnimSetReplacement.DONOR_GAME_ARCHETYPE, default.ENABLE_LOGGING, 'WSR');
				}

				//	replace animsets from specified weapon template
				if (AnimSetReplacement.DONOR_TEMPLATE != '')
				{
					ItemMgr = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

					DonorTemplate = X2WeaponTemplate(ItemMgr.FindItemTemplate(AnimSetReplacement.DONOR_TEMPLATE));

					if (DonorTemplate != none)
					{
						DonorWeapon = XComWeapon(Content.RequestGameArchetype(DonorTemplate.GameArchetype));

						if (DonorWeapon != none)
						{
							if (AnimSetReplacement.REPLACE_WEAPON_ANIMSETS)
							{
								SkeletalMeshComponent(Weapon.Mesh).AnimSets = SkeletalMeshComponent(DonorWeapon.Mesh).AnimSets;
							}
							if (AnimSetReplacement.REPLACE_SOLDIER_ANIMSETS)
							{
								Weapon.CustomUnitPawnAnimsets = DonorWeapon.CustomUnitPawnAnimsets;
								Weapon.CustomUnitPawnAnimsetsFemale = DonorWeapon.CustomUnitPawnAnimsetsFemale;

								`LOG("ANIMSET_REPLACEMENT Success, copying Soldier Animations from: " @ AnimSetReplacement.DONOR_TEMPLATE @ " to: " @ AnimSetReplacement.ACCEPTOR_TEMPLATE, default.ENABLE_LOGGING, 'WSR');
							}

							if (AnimSetReplacement.REPLACE_WEAPON_ANIMSETS && AnimSetReplacement.REPLACE_SOLDIER_ANIMSETS)
							{	
								Weapon.WeaponFireAnimSequenceName =  DonorWeapon.WeaponFireAnimSequenceName;
								Weapon.WeaponFireKillAnimSequenceName =  DonorWeapon.WeaponFireKillAnimSequenceName;
								Weapon.WeaponSuppressionFireAnimSequenceName =  DonorWeapon.WeaponSuppressionFireAnimSequenceName;
								Weapon.WeaponMoveEndFireAnimSequenceName =  DonorWeapon.WeaponMoveEndFireAnimSequenceName;
								Weapon.WeaponMoveEndFireKillAnimSequenceName =  DonorWeapon.WeaponMoveEndFireKillAnimSequenceName;
								Weapon.WeaponMoveEndTurnLeftFireAnimSequenceName =  DonorWeapon.WeaponMoveEndTurnLeftFireAnimSequenceName;
								Weapon.WeaponMoveEndTurnLeftFireKillAnimSequenceName =  DonorWeapon.WeaponMoveEndTurnLeftFireKillAnimSequenceName;
								Weapon.WeaponMoveEndTurnRightFireAnimSequenceName =  DonorWeapon.WeaponMoveEndTurnRightFireAnimSequenceName;
								Weapon.WeaponMoveEndTurnRightFireKillAnimSequenceName =  DonorWeapon.WeaponMoveEndTurnRightFireKillAnimSequenceName;
							}
						}
						else `LOG("ANIMSET_REPLACEMENT Error, could not find the Game Archetype for Donor Weapon Template: " @ AnimSetReplacement.DONOR_TEMPLATE, default.ENABLE_LOGGING, 'WSR');
					}
					else `LOG("ANIMSET_REPLACEMENT Error, could not find the Donor Weapon Template: " @ AnimSetReplacement.DONOR_TEMPLATE, default.ENABLE_LOGGING, 'WSR');
				}

				foreach AnimSetReplacement.SOLDIER_ANIMSET_PATHS(AnimSetName)
				{
					AddAnimSet = AnimSet(Content.RequestGameArchetype(AnimSetName));
					if (AddAnimSet != none)
					{	
						Weapon.CustomUnitPawnAnimsets.RemoveItem(AddAnimSet);	//	make sure the AnimSet is not already there before adding it
						Weapon.CustomUnitPawnAnimsets.AddItem(AddAnimSet);		//	this has a nice side effect in the sense that if we try to re-add an animse
																				//	it gets pushed to end of the array, allowing us to control anim set order, somewhat
						`LOG("ANIMSET_REPLACEMENT Success, added Soldier AnimSet: " @ AnimSetName, default.ENABLE_LOGGING, 'WSR');
					}
					else `LOG("ANIMSET_REPLACEMENT Error, could not find the AnimSet: " @ AnimSetName, default.ENABLE_LOGGING, 'WSR');

				}
				foreach AnimSetReplacement.SOLDIER_FEMALE_ANIMSET_PATHS(AnimSetName)
				{
					AddAnimSet = AnimSet(Content.RequestGameArchetype(AnimSetName));
					if (AddAnimSet != none)
					{	
						Weapon.CustomUnitPawnAnimsetsFemale.RemoveItem(AddAnimSet);
						Weapon.CustomUnitPawnAnimsetsFemale.AddItem(AddAnimSet);
						`LOG("ANIMSET_REPLACEMENT Success, added Female Soldier AnimSet: " @ AnimSetName, default.ENABLE_LOGGING, 'WSR');
					}
					else `LOG("ANIMSET_REPLACEMENT Error, could not find the AnimSet: " @ AnimSetName, default.ENABLE_LOGGING, 'WSR');
				}
				foreach AnimSetReplacement.WEAPON_ANIMSET_PATHS(AnimSetName)
				{
					AddAnimSet = AnimSet(Content.RequestGameArchetype(AnimSetName));
					if (AddAnimSet != none)
					{
						SkeletalMeshComponent(Weapon.Mesh).AnimSets.RemoveItem(AddAnimSet);
						SkeletalMeshComponent(Weapon.Mesh).AnimSets.AddItem(AddAnimSet);
						`LOG("ANIMSET_REPLACEMENT Success, added Weapon AnimSet: " @ AnimSetName, default.ENABLE_LOGGING, 'WSR');
					}
					else `LOG("ANIMSET_REPLACEMENT Error, could not find the AnimSet: " @ AnimSetName, default.ENABLE_LOGGING, 'WSR');
				}

				if (AnimSetReplacement.WeaponFireAnimSequenceName != '')
				{
					Weapon.WeaponSuppressionFireAnimSequenceName = AnimSetReplacement.WeaponFireAnimSequenceName;
				}
				if (AnimSetReplacement.WeaponFireKillAnimSequenceName != '')
				{
					Weapon.WeaponFireKillAnimSequenceName = AnimSetReplacement.WeaponFireKillAnimSequenceName;
				}
				if (AnimSetReplacement.WeaponSuppressionFireAnimSequenceName != '')
				{
					Weapon.WeaponSuppressionFireAnimSequenceName = AnimSetReplacement.WeaponSuppressionFireAnimSequenceName;
				}
				if (AnimSetReplacement.FIRE_SUPPRESSION_ANIM_NAME != '')	// legacy for Beagle
				{
					Weapon.WeaponSuppressionFireAnimSequenceName = AnimSetReplacement.FIRE_SUPPRESSION_ANIM_NAME;
				}
				
				if (AnimSetReplacement.WeaponMoveEndFireAnimSequenceName != '')
				{
					Weapon.WeaponMoveEndFireAnimSequenceName = AnimSetReplacement.WeaponMoveEndFireAnimSequenceName;
				}
				if (AnimSetReplacement.WeaponMoveEndFireKillAnimSequenceName != '')
				{
					Weapon.WeaponMoveEndFireKillAnimSequenceName = AnimSetReplacement.WeaponMoveEndFireKillAnimSequenceName;
				}
				if (AnimSetReplacement.WeaponMoveEndTurnLeftFireAnimSequenceName != '')
				{
					Weapon.WeaponMoveEndTurnLeftFireAnimSequenceName = AnimSetReplacement.WeaponMoveEndTurnLeftFireAnimSequenceName;
				}
				if (AnimSetReplacement.WeaponMoveEndTurnLeftFireKillAnimSequenceName != '')
				{
					Weapon.WeaponMoveEndTurnLeftFireKillAnimSequenceName = AnimSetReplacement.WeaponMoveEndTurnLeftFireKillAnimSequenceName;
				}
				if (AnimSetReplacement.WeaponMoveEndTurnRightFireAnimSequenceName != '')
				{
					Weapon.WeaponMoveEndTurnRightFireAnimSequenceName = AnimSetReplacement.WeaponMoveEndTurnRightFireAnimSequenceName;
				}
				if (AnimSetReplacement.WeaponMoveEndTurnRightFireKillAnimSequenceName != '')
				{
					Weapon.WeaponMoveEndTurnRightFireKillAnimSequenceName = AnimSetReplacement.WeaponMoveEndTurnRightFireKillAnimSequenceName;
				}

				break;
			}
		}
		for (i=0;i<default.WEAPON_REPLACEMENT.Length;i++)
		{
			if (default.WEAPON_REPLACEMENT[i].ACCEPTOR_TEMPLATE == TemplateName)
			{
				if (default.WEAPON_REPLACEMENT[i].REPLACEMENT_MESH != "")
				{
					SkelMesh = SkeletalMesh(Content.RequestGameArchetype(default.WEAPON_REPLACEMENT[i].REPLACEMENT_MESH));
					if (SkelMesh != none)
					{
						`LOG("WEAPON_REPLACEMENT Success, replacing Weapon Mesh " @ ItemState.GetMyTemplateName @ "with" @ default.WEAPON_REPLACEMENT[i].REPLACEMENT_MESH, default.ENABLE_LOGGING, 'WSR');
						SkeletalMeshComponent(Weapon.Mesh).SkeletalMesh = SkelMesh;
					}
					else `LOG("WEAPON_REPLACEMENT Error, could not find the Skeletal Mesh: " @ default.WEAPON_REPLACEMENT[i].REPLACEMENT_MESH, default.ENABLE_LOGGING, 'WSR');
				}
				break;
			}
		}
	}
}

static function DLCAppendWeaponSockets(out array<SkeletalMeshSocket> NewSockets, XComWeapon Weapon, XComGameState_Item ItemState)
{
	local X2WeaponTemplate		WeaponTemplate;
    local vector                RelativeLocation;
	local rotator				RelativeRotation;
	local vector				RelativeScale;
    local SkeletalMeshSocket    Socket;
	local int i;

	if (ItemState != none)
	{
		WeaponTemplate = X2WeaponTemplate(ItemState.GetMyTemplate());
		if (WeaponTemplate != none)
		{
			for(i=0;i<default.SOCKETS_TO_ADD.Length;i++)
			{
				if(default.SOCKETS_TO_ADD[i].TEMPLATE == WeaponTemplate.DataName)
				{
					Socket = new class'SkeletalMeshSocket';

					Socket.SocketName = default.SOCKETS_TO_ADD[i].SOCKET_NAME;

					if(default.SOCKETS_TO_ADD[i].BONE == '') Socket.BoneName = 'root';
					else Socket.BoneName = default.SOCKETS_TO_ADD[i].BONE;

					RelativeLocation.X = default.SOCKETS_TO_ADD[i].OFFSET_X;
					RelativeLocation.Y = default.SOCKETS_TO_ADD[i].OFFSET_Y;
					RelativeLocation.Z = default.SOCKETS_TO_ADD[i].OFFSET_Z;
					Socket.RelativeLocation = RelativeLocation;

					//	In code, socket rotation is recorded as an int value [-65536; 65536], so if we're using degrees we need to convert them first.
					RelativeRotation.Pitch = default.SOCKETS_TO_ADD[i].PITCH + default.SOCKETS_TO_ADD[i].dPITCH * default.RAD_INTO_DEG;
					RelativeRotation.Yaw = default.SOCKETS_TO_ADD[i].YAW + default.SOCKETS_TO_ADD[i].dYAW * default.RAD_INTO_DEG;
					RelativeRotation.Roll = default.SOCKETS_TO_ADD[i].ROLL + default.SOCKETS_TO_ADD[i].dROLL * default.RAD_INTO_DEG;
					Socket.RelativeRotation = RelativeRotation;

					RelativeScale.X = default.SOCKETS_TO_ADD[i].SCALE_X;
					RelativeScale.Y = default.SOCKETS_TO_ADD[i].SCALE_Y;
					RelativeScale.Z = default.SOCKETS_TO_ADD[i].SCALE_Z;
					Socket.RelativeScale = RelativeScale;

					NewSockets.AddItem(Socket);
				}
			}
		}
	}
}

//Stole from Musashi's Primary Secondaries
static function AddAttachments(X2ItemTemplateManager ItemMgr)
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
		AddAttachment(AttachmentType, default.ADD_ATTACHMENTS, ItemMgr);
	}
}

static function AddAttachment(name TemplateName, array<AddWeaponAttachment> Attachments, X2ItemTemplateManager ItemMgr) 
{
	local X2WeaponUpgradeTemplate Template;
	local AddWeaponAttachment Attachment;
	local delegate<X2TacticalGameRulesetDataStructures.CheckUpgradeStatus> CheckFN;
	
	Template = X2WeaponUpgradeTemplate(ItemMgr.FindItemTemplate(TemplateName));
	
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
		}
	}
}


exec function WSRAddItem(string strItemTemplate, optional int Quantity = 1, optional bool bLoot = false)
{
	local X2ItemTemplateManager ItemManager;
	local X2ItemTemplate ItemTemplate;
	local XComGameState NewGameState;
	local XComGameState_Item ItemState;
	local XComGameState_HeadquartersXCom HQState;
	local XComGameStateHistory History;
	local bool bWasInfinite;

	ItemManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	ItemTemplate = ItemManager.FindItemTemplate(name(strItemTemplate));

	if (ItemTemplate == none)
	{
		`log("No item template named" @ strItemTemplate @ "was found.");
		return;
	}

	if (ItemTemplate.bInfiniteItem)
	{
		bWasInfinite = true;
		ItemTemplate.bInfiniteItem = false;
	}

	History = `XCOMHISTORY;
	HQState = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));

	`assert(HQState != none);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add Item Cheat: Create Item");
	ItemState = ItemTemplate.CreateInstanceFromTemplate(NewGameState);
	ItemState.Quantity = Quantity;

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Add Item Cheat: Complete");
	HQState = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(HQState.Class, HQState.ObjectID));
	HQState.PutItemInInventory(NewGameState, ItemState, bLoot);

	`XCOMGAME.GameRuleset.SubmitGameState(NewGameState);
	`log("Added item" @ strItemTemplate @ "object id" @ ItemState.ObjectID);

	if (bWasInfinite)
	{
		ItemTemplate.bInfiniteItem = true;
	}
}

exec function HasSoldierAbility(string UnitName, name AbilityName)
{	
	local XComGameState_Unit				UnitState;
	local XComGameState_HeadquartersXCom	XComHQ;
	local XComGameStateHistory				History;
	local int idx;

	History = `XCOMHISTORY;
	XComHQ = `XCOMHQ;

	for (idx = 0; idx < XComHQ.Crew.Length; idx++)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));
				
		if (UnitState != none && UnitState.GetMyTemplateName() == 'Soldier' && UnitState.GetFullName() == UnitName)
		{
			`LOG("Unit " @ UnitName @ " has ability " @ AbilityName @ ":" @ UnitState.HasSoldierAbility(AbilityName, true),, 'WSRCHEAT');
			return;	
		}
	}
	`LOG("Unit " @ UnitName @ "not found.",, 'WSRCHEAT');
}

/* Too late to do during Weapon Initialized
struct ParticleSystemStruct
{
    var name TEMPLATE;
	var name SOCKET;
	var name BONE;
	var bool REMOVE_ORIGINAL;
	var string PARTICLE_SYSTEM;
};
var config array<ParticleSystemStruct> PARTICLE_SYSTEM;

local ParticleSystemStruct	ParticleAddition;
local AnimNotify_PlayParticleEffect	AddedParticleEffect;

	// Adding or replacing Persistent Particle Effects on the weapon
foreach default.PARTICLE_SYSTEM(ParticleAddition)
{
	if (TemplateName == ParticleAddition.TEMPLATE)
	{
		`LOG("Replacing particle for: " @ TemplateName,, 'IRIDARWSR');

		if (ParticleAddition.REMOVE_ORIGINAL) 
		{
			`LOG("Weapon.m_arrParticleEffects.Length: " @ Weapon.m_arrParticleEffects.Length,, 'IRIDARWSR');
			Weapon.m_arrParticleEffects.Length = 0;
			`LOG("Weapon.m_arrParticleEffects.Length: " @ Weapon.m_arrParticleEffects.Length,, 'IRIDARWSR');
		}

		AddedParticleEffect = new class'AnimNotify_PlayParticleEffect';
					
		AddedParticleEffect.bIsWeaponEffect = true;
		AddedParticleEffect.bAttach = true;
		if (ParticleAddition.SOCKET != '') AddedParticleEffect.SocketName = ParticleAddition.SOCKET;
		if (ParticleAddition.BONE != '') AddedParticleEffect.SocketName = ParticleAddition.BONE;
		AddedParticleEffect.PSTemplate = ParticleSystem(Content.RequestGameArchetype(ParticleAddition.PARTICLE_SYSTEM));

		if (AddedParticleEffect.PSTemplate != none)	Weapon.m_arrParticleEffects.AddItem(AddedParticleEffect); 
		else `LOG("Failed to create a proper Particle System",, 'IRIDARWSR');

		break;
	}
}*/

/*
static function CopyAttachments()
{										
	local X2ItemTemplateManager				TemplateManager;
	local array<X2WeaponUpgradeTemplate>	Templates;
	local int i,j,z;

	TemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	Templates = TemplateManager.GetAllUpgradeTemplates();

	`LOG("Function name: " @ GetFuncName(),, 'WeaponSkinReplacer');

	for (i=0; i < Templates.Length; i++)
	{
		for (j = 0; j < Templates[i].UpgradeAttachments.Length; j++)
		{
			for (z=0; z < default.WEAPON_REPLACEMENT.Length; z++)
			{
				//	if the config says to not copy donor attachments for this weapon, we move on to the next weapon
				if(!default.WEAPON_REPLACEMENT[z].COPY_DONOR_ATTACHMENTS) continue;

				if(default.WEAPON_REPLACEMENT[z].HIDE_ACCEPTOR_ATTACHMENTS && Templates[i].UpgradeAttachments[j].ApplyToWeaponTemplate == default.WEAPON_REPLACEMENT[z].ACCEPTOR_TEMPLATE)
				{
					Templates[i].UpgradeAttachments[j].ApplyToWeaponTemplate='';
				}

				if(Templates[i].UpgradeAttachments[j].ApplyToWeaponTemplate == default.WEAPON_REPLACEMENT[z].DONOR_TEMPLATE)
				{
					Templates[i].UpgradeAttachments[j].ApplyToWeaponTemplate = default.WEAPON_REPLACEMENT[z].ACCEPTOR_TEMPLATE;
					if(default.ENABLE_LOGGING) 
					{
						`LOG("IRIDAR Replacing attachment for weapon: " @ default.WEAPON_REPLACEMENT[z].ACCEPTOR_TEMPLATE,, 'WeaponSkinReplacer');
						`LOG("IRIDAR From weapon: " @ default.WEAPON_REPLACEMENT[z].DONOR_TEMPLATE,, 'WeaponSkinReplacer');
					}
				}
			}
		}
	}
}*/

defaultproperties
{
	RAD_INTO_DEG = 182.0416f;
}