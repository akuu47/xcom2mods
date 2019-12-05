class UINewSkirmishScreen extends UITLE_SkirmishModeMenu config(Game);

enum EUISkirmishScreenCustom
{
	EUISkirmishScreenCustom_None, // When this is none, it means we want to look at the base ones
	EUISkirmishScreenCustom_CharacterPool,
	EUISkirmishScreenCustom_WeaponUpgrade,
	EUISkirmishScreenCustom_WeaponChooseUpgrade,
	EUISkirmishScreenCustom_SaveConfig,
	EUISkirmishScreenCustom_LoadConfig,
	EUISkirmishScreenCustom_SetForceLevel,
	EUISkirmishScreenCustom_SetAlertLevel,
	EUISkirmishScreenCustom_SelectMap,
	EUISkirmishScreenCustom_SelectUnitType,
	EUISkirmishScreenCustom_ChosenStrWeak,
	EUISkirmishScreenCustom_AddAWCRolls,
	EUISkirmishScreenCustom_SitReps,
	EUISkirmishScreenCustom_MAX
};

var EUISkirmishScreenCustom m_AdditionalState;

var localized string m_strNoChange;
var localized string m_strLoadCharPool;
var localized string m_strSoldierTypeMismatch;
var localized string m_strUtilityItemConflict;
var localized string m_strWeaponUpgrades;
var localized string m_strEmptyWeaponUpgrade;
var localized string m_strWeaponUpgradeMenu;
var localized string m_strSelectCharacterPool;
var localized string m_strSelectWeaponUpgrade;
var localized string m_strCannotChangeUpgrade;
var localized string m_strSaveConfig;
var localized string m_strNewSave;
var localized string m_strNewSaveName;
var localized string m_strLoadConfig;
var localized string m_strMissingHistoryTitle;
var localized string m_strMissingHistoryText;
var localized string m_strForceLevel;
var localized string m_strAlertLevel;
var localized string m_strDefault;
var localized string m_strSelectMapBase;
var localized string m_strSelectUnitType;
var localized string m_strAddAWCAbility;
var localized string m_strSelectSitRep;
var localized string m_strSitRepIsForced;
var localized string m_strSitRepDisabled;

var config array<name> AlwaysHideTemplates;
var config bool ShowTemplateName;
var config bool HideWeaponEndsWithWPN;
var config int MaxAlertLevel;

var int UpgradeIndex;
var int OverrideForceLevel;
var int OverrideAlertLevel;

var UIPanel EquipmentSelector;
var UIIcon PrimaryWeaponButton, SecondaryWeaponButton, ArmorButton, HeavyWeaponButton, PCSButton;
var UIIcon Utility1Button, Utility2Button, GrenadeButton;
var array<UIIcon> WeaponUpgradesIcons;
var int WeapUpgrIconX, WeapUpgrIconY, WeapUpgrIconScale, WeapUpgrIconOffset;

simulated function UIIcon CreateEquipIcon(int width_icon, int height_icon, int X_icon, int Y_icon)
{
	local UIIcon rIcon;

	rIcon = Spawn(class'UIIconWithClickSound', EquipmentSelector);
	rIcon.bAnimateOnInit = false;
	rIcon.InitIcon();
	rIcon.bDisableSelectionBrackets = true;

	rIcon.SetAlpha(0.01);
	rIcon.SetSize(width_icon, height_icon);
	rIcon.SetPosition(X_icon, Y_icon);

	return rIcon;
}

simulated function OnInit()
{
	super.OnInit();

	EquipmentSelector = Spawn(class'UIPanel', self);
	EquipmentSelector.bIsNavigable = false;
	EquipmentSelector.InitPanel('ClickableEquipments');
	EquipmentSelector.SetPosition(880, 250);
	EquipmentSelector.SetSize(630, 760);
	
	ArmorButton = CreateEquipIcon(620, 195, 10, 90);
	ArmorButton.OnClickedDelegate = OnClickArmor;
	PrimaryWeaponButton = CreateEquipIcon(305, 150, 10, 355);
	PrimaryWeaponButton.OnClickedDelegate = OnClickPrimaryWeapon;
	SecondaryWeaponButton = CreateEquipIcon(305, 150, 325, 355);
	SecondaryWeaponButton.OnClickedDelegate = OnClickSecondaryWeapon;
	PCSButton = CreateEquipIcon(50, 50, 40, 20);
	PCSButton.OnClickedDelegate = OnClickPCS;
	HeavyWeaponButton = CreateEquipIcon(135, 100, 20, 175);
	HeavyWeaponButton.OnClickedDelegate = OnClickHeavyWeapon;

	Utility1Button = CreateEquipIcon(205, 145, 5, 580);
	Utility1Button.OnClickedDelegate = OnClickUtilItem1;
	Utility2Button = CreateEquipIcon(205, 145, 215, 580);
	Utility2Button.OnClickedDelegate = OnClickUtilItem2;
	GrenadeButton = CreateEquipIcon(205, 145, 425, 580);
	GrenadeButton.OnClickedDelegate = OnClickGrenadePocket;

	EquipmentSelector.Hide();
}

simulated function bool FilterTemplateName(name TemplateName)
{
	if (default.HideWeaponEndsWithWPN && Caps(Right(string(TemplateName), 4)) == "_WPN")
	{
		return true;
	}
	return default.AlwaysHideTemplates.Find(TemplateName) != INDEX_NONE;
}

simulated function UpdateDataPrimaryWeapon()
{
	local int i, index;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;
	local array<name> PossibleItems;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	UpdateDataWeapon(eInvSlot_PrimaryWeapon, PossibleItems);

	index = 0;
	for (i = 0; i < PossibleItems.Length; i++)
	{
		EquipmentTemplate = X2EquipmentTemplate(ItemTemplateManager.FindItemTemplate(PossibleItems[i]));

		if (EquipmentTemplate != none && !FilterTemplateName(PossibleItems[i]))
		{
			GetListItem(index).UpdateDataValue(EquipmentTemplate.GetItemFriendlyNameNoStats(), default.ShowTemplateName ? string(EquipmentTemplate.DataName) : "", , , OnClickNewPrimaryWeapon);
			GetListItem(index).metadataString = string(EquipmentTemplate.DataName);
			GetListItem(index++).EnableNavigation();
		}
	}
}

simulated function UpdateDataSecondaryWeapon()
{
	local int i, index;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;
	local array<name> PossibleItems;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	UpdateDataWeapon(eInvSlot_SecondaryWeapon, PossibleItems);

	index = 0;
	for (i = 0; i < PossibleItems.Length; i++)
	{
		EquipmentTemplate = X2EquipmentTemplate(ItemTemplateManager.FindItemTemplate(PossibleItems[i]));

		if (EquipmentTemplate != none && !FilterTemplateName(PossibleItems[i]))
		{
			GetListItem(index).UpdateDataValue(EquipmentTemplate.GetItemFriendlyNameNoStats(), default.ShowTemplateName ? string(EquipmentTemplate.DataName) : "", , , OnClickNewSecondaryWeapon);
			GetListItem(index).metadataString = string(EquipmentTemplate.DataName);
			GetListItem(index++).EnableNavigation();
		}
	}
}

simulated function UpdateDataWeapon(EInventorySlot eEquipmentType, out array<name> PossibleItems)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;
	local X2DataTemplate kEquipmentTemplate;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	foreach ItemTemplateManager.IterateTemplates(kEquipmentTemplate, none)
	{
		EquipmentTemplate = X2EquipmentTemplate(kEquipmentTemplate);
		if (EquipmentTemplate == none)
		{
			continue;
		}
		if( EquipmentTemplate.iItemSize > 0 && EquipmentTemplate.InventorySlot == eEquipmentType && kEquipmentTemplate.IsA('X2WeaponTemplate'))
		{
			if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplate() != None)
			{
				if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplate().IsWeaponAllowedByClass(X2WeaponTemplate(kEquipmentTemplate)))
				{
					PossibleItems.AddItem(EquipmentTemplate.DataName);
				}
			}
			else
			{
				PossibleItems.AddItem(EquipmentTemplate.DataName);
			}
		}
	}
}

simulated function UpdateDataArmor()
{
	local int i, index;
	local array<name> RandomArmors;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	GetArmorTemplates(RandomArmors);

	index = 0;
	for (i = 0; i < RandomArmors.Length; i++)
	{
		EquipmentTemplate = X2EquipmentTemplate(ItemTemplateManager.FindItemTemplate( RandomArmors[i] ) );

		if (EquipmentTemplate != none && !FilterTemplateName(RandomArmors[i]))
		{
			GetListItem(index).UpdateDataValue(EquipmentTemplate.GetItemFriendlyNameNoStats(), default.ShowTemplateName ? string(EquipmentTemplate.DataName) : "", , , OnClickNewArmor);
			GetListItem(index).metadataString = string(EquipmentTemplate.DataName);
			GetListItem(index++).EnableNavigation();
		}
	}
}

simulated function GetArmorTemplates(out array<name> RandomArmors)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;
	local X2DataTemplate kEquipmentTemplate;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	foreach ItemTemplateManager.IterateTemplates(kEquipmentTemplate, none)
	{
		EquipmentTemplate = X2EquipmentTemplate(kEquipmentTemplate);
		if (EquipmentTemplate == none)
		{
			continue;
		}
		if( EquipmentTemplate.iItemSize > 0 && EquipmentTemplate.InventorySlot == eInvSlot_Armor && kEquipmentTemplate.IsA('X2ArmorTemplate'))
		{
			if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplate() != None)
			{
				if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplate().IsArmorAllowedByClass(X2ArmorTemplate(kEquipmentTemplate)))
				{
					RandomArmors.AddItem(EquipmentTemplate.DataName);
				}
			}
			else
			{
				RandomArmors.AddItem(EquipmentTemplate.DataName);
			}
		}
	}
}

simulated function UpdateDataUtilItem1()
{
	local int i, index, EquippedObjectID;
	local array<name> PossibleItems;
	local array<XComGameState_Item> UtilityItems;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	EquippedObjectID = -1;

	UtilityItems = m_CurrentSquad[m_SelectedSoldier].GetAllItemsInSlot(eInvSlot_Utility, StartState, true, true);
	if (UtilityItems.Length > 0)
	{
		EquippedObjectID = UtilityItems[0].GetReference().ObjectID;
	}

	UpdateDataUtilItem(PossibleItems);
	
	index = 0;
	for (i = 0; i < PossibleItems.Length; i++)
	{
		EquipmentTemplate = X2EquipmentTemplate(ItemTemplateManager.FindItemTemplate(PossibleItems[i]));

		if (EquipmentTemplate != none && !FilterTemplateName(PossibleItems[i]))
		{
			GetListItem(index).EnableNavigation();
			GetListItem(index).metadataString = string(EquipmentTemplate.DataName);
			if (!m_CurrentSquad[m_SelectedSoldier].RespectsUniqueRule(EquipmentTemplate, eInvSlot_Utility, , EquippedObjectID))
			{
				GetListItem(index).SetDisabled(true, m_strUtilityItemConflict);
			}
			GetListItem(index++).UpdateDataValue(EquipmentTemplate.GetItemFriendlyNameNoStats(), default.ShowTemplateName ? string(EquipmentTemplate.DataName) : "", , , OnClickNewUtilItem1);
		}
	}
}

simulated function UpdateDataUtilItem2()
{
	local int i, index, EquippedObjectID;
	local array<name> PossibleItems;
	local array<XComGameState_Item> UtilityItems;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	EquippedObjectID = -1;

	UtilityItems = m_CurrentSquad[m_SelectedSoldier].GetAllItemsInSlot(eInvSlot_Utility, StartState, true, true);
	if (UtilityItems.Length > 1)
	{
		EquippedObjectID = UtilityItems[1].GetReference().ObjectID;
	}

	UpdateDataUtilItem(PossibleItems);
	
	index = 0;
	for (i = 0; i < PossibleItems.Length; i++)
	{
		EquipmentTemplate = X2EquipmentTemplate(ItemTemplateManager.FindItemTemplate(PossibleItems[i]));

		if (EquipmentTemplate != none && !FilterTemplateName(PossibleItems[i]))
		{
			GetListItem(index).EnableNavigation();
			GetListItem(index).metadataString = string(EquipmentTemplate.DataName);
			if (!m_CurrentSquad[m_SelectedSoldier].RespectsUniqueRule(EquipmentTemplate, eInvSlot_Utility, , EquippedObjectID))
			{
				GetListItem(index).SetDisabled(true, m_strUtilityItemConflict);
			}
			GetListItem(index++).UpdateDataValue(EquipmentTemplate.GetItemFriendlyNameNoStats(), default.ShowTemplateName ? string(EquipmentTemplate.DataName) : "", , , OnClickNewUtilItem2);
		}
	}
}

simulated function UpdateDataUtilItem(out array<name> PossibleItems)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;
	local X2DataTemplate kEquipmentTemplate;
	local X2WeaponTemplate WeaponTemplate;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	foreach ItemTemplateManager.IterateTemplates(kEquipmentTemplate, none)
	{
		EquipmentTemplate = X2EquipmentTemplate(kEquipmentTemplate);
		if (EquipmentTemplate == none)
		{
			continue;
		}
		if ( X2AmmoTemplate(EquipmentTemplate) != none)
		{
			WeaponTemplate = X2WeaponTemplate(m_CurrentSquad[m_SelectedSoldier].GetItemInSlot(eInvSlot_PrimaryWeapon, StartState).GetMyTemplate());
			if (WeaponTemplate != none && !X2AmmoTemplate(EquipmentTemplate).IsWeaponValidForAmmo(WeaponTemplate))
			{
				continue;
			}
		}
		if( EquipmentTemplate.iItemSize > 0 && EquipmentTemplate.InventorySlot == eInvSlot_Utility)
		{
			if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplate() != None && kEquipmentTemplate.IsA('X2WeaponTemplate'))
			{
				if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplate().IsWeaponAllowedByClass(X2WeaponTemplate(kEquipmentTemplate)))
				{
					PossibleItems.AddItem(EquipmentTemplate.DataName);
				}
			}
			else
			{
				PossibleItems.AddItem(EquipmentTemplate.DataName);
			}
		}
	}
}

simulated function UpdateDataGrenadePocket()
{
	local int i, index;
	local array<name> PossibleItems;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	GetGrenades(PossibleItems);

	index = 0;
	for (i = 0; i < PossibleItems.Length; i++)
	{
		EquipmentTemplate = X2EquipmentTemplate(ItemTemplateManager.FindItemTemplate(PossibleItems[i]));

		if (EquipmentTemplate != none && !FilterTemplateName(PossibleItems[i]))
		{
			GetListItem(index).EnableNavigation();
			GetListItem(index).metadataString = string(EquipmentTemplate.DataName);
			GetListItem(index++).UpdateDataValue(EquipmentTemplate.GetItemFriendlyNameNoStats(), default.ShowTemplateName ? string(EquipmentTemplate.DataName) : "", , , OnClickNewGrenadePocket);
		}
	}
}

simulated function GetGrenades(out array<name> PossibleItems)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;
	local X2DataTemplate kEquipmentTemplate;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	foreach ItemTemplateManager.IterateTemplates(kEquipmentTemplate, none)
	{
		EquipmentTemplate = X2EquipmentTemplate(kEquipmentTemplate);
		if (EquipmentTemplate == none)
		{
			continue;
		}
		if( EquipmentTemplate.iItemSize > 0 && X2GrenadeTemplate(kEquipmentTemplate) != None &&
		 (EquipmentTemplate.InventorySlot == eInvSlot_Utility || EquipmentTemplate.InventorySlot == eInvSlot_GrenadePocket))
		{

			if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplate() != None && kEquipmentTemplate.IsA('X2WeaponTemplate'))
			{
				if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplate().IsWeaponAllowedByClass(X2WeaponTemplate(kEquipmentTemplate)))
				{
					PossibleItems.AddItem(EquipmentTemplate.DataName);
				}
			}
			else
			{
				PossibleItems.AddItem(EquipmentTemplate.DataName);
			}
		}
	}
}

simulated function UpdateDataHeavyWeapon()
{
	local int i, index;
	local array<name> PossibleItems;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	GetHeavyWeapons(PossibleItems);

	index = 0;
	for (i = 0; i < PossibleItems.Length; i++)
	{
		EquipmentTemplate = X2EquipmentTemplate(ItemTemplateManager.FindItemTemplate(PossibleItems[i]));

		if (EquipmentTemplate != none && !FilterTemplateName(PossibleItems[i]))
		{
			GetListItem(index).EnableNavigation();
			GetListItem(index).metadataString = string(EquipmentTemplate.DataName);
			GetListItem(index++).UpdateDataValue(EquipmentTemplate.GetItemFriendlyNameNoStats(), default.ShowTemplateName ? string(EquipmentTemplate.DataName) : "", , , OnClickNewHeavyWeapon);
		}
	}
}

simulated function GetHeavyWeapons(out array<name> PossibleItems)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;
	local X2DataTemplate kEquipmentTemplate;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	foreach ItemTemplateManager.IterateTemplates(kEquipmentTemplate, none)
	{
		EquipmentTemplate = X2EquipmentTemplate(kEquipmentTemplate);
		if (EquipmentTemplate == none)
		{
			continue;
		}
		if( EquipmentTemplate.iItemSize > 0 && EquipmentTemplate.InventorySlot == eInvSlot_HeavyWeapon && kEquipmentTemplate.IsA('X2WeaponTemplate'))
		{
			if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplate() != None)
			{
				if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplate().IsWeaponAllowedByClass(X2WeaponTemplate(kEquipmentTemplate)))
				{
					PossibleItems.AddItem(EquipmentTemplate.DataName);
				}
			}
			else
			{
				PossibleItems.AddItem(EquipmentTemplate.DataName);
			}
		}
	}
}

simulated function UpdateDataSquad()
{
	local int index, loopIndex;
	index = 0;

	GetListItem(index).EnableNavigation();
	GetListItem(index++).UpdateDataValue(m_AddUnit, "", OnClickAddUnit);

	for( loopIndex = 0; loopIndex < m_CurrentSquad.Length; loopIndex++ )
	{
		GetListItem(index).EnableNavigation();
		GetListItem(index++).UpdateDataValue(m_EditUnit, m_CurrentSquad[loopIndex].GetFullName(), , , OnClickEditUnit);
	}

	mc.FunctionVoid("HideAllScreens");
	EquipmentSelector.Hide();

	RefreshSquadDetailsPanel();
}

simulated function GiveUnitBasicEquipment(XComGameState_Unit Unit)
{
	local array<name> PossibleItems;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2EquipmentTemplate EquipmentTemplate;
	local XComGameState_Item NewItem;

	super.GiveUnitBasicEquipment(Unit);

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	
	if (Unit.GetItemInSlot(eInvSlot_Armor, StartState) == none)
	{
		// Get default armor
		PossibleItems.Length = 0;

		GetArmorTemplates(PossibleItems);

		if (PossibleItems.Length > 0)
		{
			EquipmentTemplate = X2EquipmentTemplate(ItemTemplateManager.FindItemTemplate(PossibleItems[0]));
			`assert( EquipmentTemplate != none );
			NewItem = EquipmentTemplate.CreateInstanceFromTemplate(StartState);

			Unit.AddItemToInventory(NewItem, eInvSlot_Armor, StartState);
		}
	}

	if (Unit.GetItemInSlot(eInvSlot_PrimaryWeapon, StartState) == none)
	{
		// Get default primary weapon
		PossibleItems.Length = 0;

		UpdateDataWeapon(eInvSlot_PrimaryWeapon, PossibleItems);

		if (PossibleItems.Length > 0)
		{
			EquipmentTemplate = X2EquipmentTemplate(ItemTemplateManager.FindItemTemplate(PossibleItems[0]));
			`assert( EquipmentTemplate != none );
			NewItem = EquipmentTemplate.CreateInstanceFromTemplate(StartState);

			Unit.AddItemToInventory(NewItem, eInvSlot_PrimaryWeapon, StartState);
		}
	}

	if (Unit.GetSoldierClassTemplate() != none && !Unit.GetSoldierClassTemplate().bNoSecondaryWeapon && 
		Unit.GetItemInSlot(eInvSlot_SecondaryWeapon, StartState) == none)
	{
		// Get default secondary weapon
		PossibleItems.Length = 0;

		UpdateDataWeapon(eInvSlot_SecondaryWeapon, PossibleItems);

		if (PossibleItems.Length > 0)
		{
			EquipmentTemplate = X2EquipmentTemplate(ItemTemplateManager.FindItemTemplate(PossibleItems[0]));
			`assert( EquipmentTemplate != none );
			NewItem = EquipmentTemplate.CreateInstanceFromTemplate(StartState);

			Unit.AddItemToInventory(NewItem, eInvSlot_SecondaryWeapon, StartState);
		}
	}

	if (Unit.HasHeavyWeapon() && 
		Unit.GetItemInSlot(eInvSlot_HeavyWeapon, StartState) == none)
	{
		// Get default secondary weapon
		PossibleItems.Length = 0;

		GetHeavyWeapons(PossibleItems);

		if (PossibleItems.Length > 0)
		{
			EquipmentTemplate = X2EquipmentTemplate(ItemTemplateManager.FindItemTemplate(PossibleItems[0]));
			`assert( EquipmentTemplate != none );
			NewItem = EquipmentTemplate.CreateInstanceFromTemplate(StartState);

			Unit.AddItemToInventory(NewItem, eInvSlot_HeavyWeapon, StartState);
		}
	}
}

simulated function UpdateTraitInfo(int ItemIndex)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local UIMechaListItem ListItem;
	local UISummary_Ability AbilityData;

	MC.FunctionVoid("HideAllScreens");

	ListItem = UIMechaListItem(List.GetItem(ItemIndex));
	
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(name(ListItem.metadataString));

	if (AbilityTemplate == none)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate('StandardShot');
	}
	
	AbilityData = AbilityTemplate.GetUISummary_Ability();

	MC.BeginFunctionOp("SetAbilityData");
	MC.QueueString(AbilityTemplate.IconImage);
	MC.QueueString(AbilityData.Name);
	MC.QueueString(AbilityData.Description);//AbilityTemplate.LocLongDescription);
	MC.QueueString("" /*unlockString*/ );
	MC.QueueString("" /*rank icon*/ );
	MC.EndOp();
}

simulated function UpdateCharacterTemplateInfo(int ItemIndex)
{
	local UIMechaListItem ListItem;
	local X2CharacterTemplate CharTemplate;

	MC.FunctionVoid("HideAllScreens");

	ListItem = UIMechaListItem(List.GetItem(ItemIndex));

	CharTemplate = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager()
						.FindCharacterTemplate(name(ListItem.metadataString));

	if (CharTemplate == none)
	{
		UpdateDataSoldierData();
		return;
	}
		
	mc.BeginFunctionOp("SetSoldierData");
	mc.QueueString(CharTemplate.strSkirmishImage);
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString(CharTemplate.strCharacterName);
	mc.QueueString(string(CharTemplate.DataName));
	mc.EndOp();

	mc.BeginFunctionOp("SetSoldierStats");

	mc.QueueString(m_strHealthLabel);
	mc.QueueString(string(int(CharTemplate.CharacterBaseStats[eStat_HP])));

	mc.QueueString(m_strMobilityLabel);
	mc.QueueString(string(int(CharTemplate.CharacterBaseStats[eStat_Mobility])));

	mc.QueueString(m_strAimLabel);
	mc.QueueString(string(int(CharTemplate.CharacterBaseStats[eStat_Offense])));
	
	mc.QueueString(m_strWillLabel);
	mc.QueueString(string(int(CharTemplate.CharacterBaseStats[eStat_Will])));

	mc.QueueString(m_strArmorLabel);
	mc.QueueString(string(int(CharTemplate.CharacterBaseStats[eStat_ArmorMitigation])));

	mc.QueueString(m_strDodgeLabel);
	mc.QueueString(string(int(CharTemplate.CharacterBaseStats[eStat_Dodge])));

	mc.QueueString(m_strTechLabel);
	mc.QueueString(string(int(CharTemplate.CharacterBaseStats[eStat_Hacking])));

	if (CharTemplate.CharacterBaseStats[eStat_PsiOffense] > 0)
	{
		mc.QueueString(class'UIUtilities_Text'.static.GetColoredText(m_strPsiLabel, eUIState_Psyonic));
		mc.QueueString(class'UIUtilities_Text'.static.GetColoredText(string(int(CharTemplate.CharacterBaseStats[eStat_PsiOffense])), eUIState_Psyonic));
	}
	else
	{
		mc.QueueString(class'X2TacticalGameRulesetDataStructures'.default.m_aCharStatLabels[eStat_Defense]);
		mc.QueueString(string(int(CharTemplate.CharacterBaseStats[eStat_Defense])));
	}

	mc.EndOp();

	mc.BeginFunctionOp("SetSoldierGear");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.QueueString("");
	mc.EndOp();

	MC.FunctionVoid("SetSoldierPrimaryWeapon");
}

simulated function UpdateSelectedEquipmentInfo(int ItemIndex)
{
	local UIMechaListItem ListItem;
	local X2ItemTemplate Template;

	MC.FunctionVoid("HideAllScreens");

	ListItem = UIMechaListItem(List.GetItem(ItemIndex));

	if (ListItem.metadataString == m_strPCSNone || ListItem.metadataString == "")
	{
		UpdateDataSoldierData();
		return;
	}
	else
	{
		Template = class'X2ItemTemplateManager'.static.GetItemTemplateManager().FindItemTemplate(name(ListItem.metadataString));
	}

	mc.BeginFunctionOp("SetEnemyPodData");

	mc.QueueString(Template.GetItemFriendlyNameNoStats());
	mc.QueueString(Template.GetItemBriefSummary());
	mc.QueueString("");

	mc.QueueString(Template.strImage); // Item Image
	mc.QueueString("");
	mc.EndOp();

}

simulated function OnSetSelectedIndex(UIList ContainerList, int ItemIndex)
{
	if (m_CurrentState == eUISkirmishScreen_Squad)
	{
		m_SelectedSoldier = ItemIndex - 1;
		RefreshSquadDetailsPanel();
	}
	if (m_CurrentState == eUISkirmishScreen_Enemies)
	{
		EquipmentSelector.Hide();
		m_SelectedEnemy = ItemIndex;
		UpdateEnemyPortraits();
	}
	if (( m_CurrentState == eUISkirmishScreen_SoldierAbilities ) ||
		( m_CurrentState == eUISkirmishScreen_MAX && m_AdditionalState == EUISkirmishScreenCustom_AddAWCRolls ))
	{
		EquipmentSelector.Hide();
		UpdateAbilityInfo(ItemIndex);
	}
	if ( m_CurrentState == eUISkirmishScreen_MAX && m_AdditionalState == EUISkirmishScreenCustom_SitReps )
	{
		EquipmentSelector.Hide();
		UpdateSitRepInfo(ItemIndex);
	}
	if( m_CurrentState == eUISkirmishScreen_MAX && m_AdditionalState == EUISkirmishScreenCustom_ChosenStrWeak )
	{
		EquipmentSelector.Hide();
		UpdateTraitInfo(ItemIndex);
	}
	if( m_CurrentState == eUISkirmishScreen_MAX && m_AdditionalState == EUISkirmishScreenCustom_SelectUnitType )
	{
		EquipmentSelector.Hide();
		UpdateCharacterTemplateInfo(ItemIndex);
	}
	if( ( m_CurrentState >= eUISkirmishScreen_PrimaryWeapon && m_CurrentState <= eUISkirmishScreen_HeavyWeapon )
		|| (m_CurrentState == eUISkirmishScreen_MAX && m_AdditionalState == EUISkirmishScreenCustom_WeaponChooseUpgrade) )
	{
		EquipmentSelector.Hide();
		UpdateSelectedEquipmentInfo(ItemIndex);
	}
}

simulated function UpdateDataSoldierData()
{
	local XComGameState_Item equippedItem;
	local int i, currX;
	local array<string> UpgradeIconPaths;
	local UIIcon UpgradeIcon;

	super.UpdateDataSoldierData();

	if (m_CurrentSquad[m_SelectedSoldier].IsSoldier())
	{
		EquipmentSelector.Show();

		if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplateName() != 'Rookie' && m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplateName() != 'Reaper')
		{
			SecondaryWeaponButton.Show();
		}
		else
		{
			SecondaryWeaponButton.Hide();
		}

		if (m_CurrentSquad[m_SelectedSoldier].IsSufficientRankToEquipPCS() && m_CurrentSquad[m_SelectedSoldier].GetCurrentStat(eStat_CombatSims) > 0)
		{
			PCSButton.Show();
		}
		else
		{
			PCSButton.Hide();
		}

		if (m_CurrentSquad[m_SelectedSoldier].GetCurrentStat( eStat_UtilityItems ) > 0)
		{
			Utility1Button.Show();
		}
		else
		{
			Utility1Button.Hide();
		}

		if( m_CurrentSquad[m_SelectedSoldier].HasExtraUtilitySlot() )
		{
			Utility2Button.Show();
		}
		else
		{
			Utility2Button.Hide();
		}

		if (m_CurrentSquad[m_SelectedSoldier].HasGrenadePocket())
		{
			GrenadeButton.Show();
		}
		else
		{
			GrenadeButton.Hide();
		}

		if (m_CurrentSquad[m_SelectedSoldier].HasHeavyWeapon())
		{
			HeavyWeaponButton.Show();
		}
		else
		{
			HeavyWeaponButton.Hide();
		}

		// Populate weapon upgrades
		foreach WeaponUpgradesIcons(UpgradeIcon)
		{
			UpgradeIcon.Hide();
		}

		equippedItem = m_CurrentSquad[m_SelectedSoldier].GetItemInSlot(eInvSlot_PrimaryWeapon, StartState, true);
		UpgradeIconPaths = equippedItem.GetMyWeaponUpgradeTemplatesCategoryIcons();

		for (i = 0; i < UpgradeIconPaths.Length; i++)
		{
			if (WeaponUpgradesIcons.Length <= i)
			{
				currX = WeapUpgrIconX + ((WeapUpgrIconScale + WeapUpgrIconOffset) * WeaponUpgradesIcons.Length);
				UpgradeIcon = CreateEquipIcon(WeapUpgrIconScale, WeapUpgrIconScale, currX, WeapUpgrIconY);
				UpgradeIcon.SetAlpha(100);
				UpgradeIcon.OnClickedDelegate = OnClickUpgradeWeapon;
				WeaponUpgradesIcons.AddItem(UpgradeIcon);
			}
			WeaponUpgradesIcons[i].LoadIcon(UpgradeIconPaths[i]);
			WeaponUpgradesIcons[i].Show();
		}
	}
}

simulated function RefreshSquadDetailsPanel()
{
	mc.FunctionVoid("HideAllScreens");

	if (List.SelectedIndex <= 0)
	{
		UpdateDetailsGeneric();
		EquipmentSelector.Hide();
	}
	else
	{
		UpdateDataSoldierData();
	}
}

simulated function UpdateGeneralMissionInfoPanel()
{
	EquipmentSelector.Hide();
	super.UpdateGeneralMissionInfoPanel();
}

simulated function OnClickRemoveUnit()
{
	local array<XComGameState_Item> inventoryItems;
	local int i;
	local StateObjectReference SoldierRef;

	SoldierRef = m_CurrentSquad[m_SelectedSoldier].GetReference();

	inventoryItems = m_CurrentSquad[m_SelectedSoldier].GetAllInventoryItems(StartState);

	for (i = 0; i < inventoryItems.Length; i++)
	{
		m_CurrentSquad[m_SelectedSoldier].RemoveItemFromInventory(inventoryItems[i], StartState);
	}
	
	m_CurrentSquad.Remove(m_SelectedSoldier, 1);
	m_CurrentState = eUISkirmishScreen_Squad;

	for (i = 0; i < HeadquartersStateObject.Squad.Length; i++)
	{
		if (HeadquartersStateObject.Squad[i].ObjectID == SoldierRef.ObjectID)
		{
			HeadquartersStateObject.Squad.Remove(i, 1);
		}
	}

	HeadquartersStateObject.RemoveFromCrew( SoldierRef );

	StartState.PurgeGameStateForObjectID(SoldierRef.ObjectID, true);

	UpdateData();
}

simulated function OnClickEditUnit(UIMechaListItem MechaItem)
{
	local int selectedIndex;

	for (selectedIndex = 0; selectedIndex < List.ItemContainer.ChildPanels.Length; selectedIndex++)
	{
		if (GetListItem(selectedIndex) == MechaItem)
			break;
	}

	m_SelectedSoldier = selectedIndex - 1;

	m_CurrentState = eUISkirmishScreen_SoldierData;
	UpdateData();
}

simulated function UpdateDataSoldierEquipment()
{
	local XComGameState_Item equippedItem;
	local array<XComGameState_Item> utilItems;
	local array<name> WeaponUpgrades;
	local int i, numUpgrades, numSlots, index;

	UpdateDataSoldierData();

	i = 0;

	equippedItem = m_CurrentSquad[m_SelectedSoldier].GetItemInSlot(eInvSlot_PrimaryWeapon, StartState, true);
	GetListItem(i).EnableNavigation();
	GetListItem(i++).UpdateDataValue(m_PrimaryWeapon, equippedItem.GetMyTemplate().GetItemFriendlyNameNoStats(), OnClickPrimaryWeapon);

	numSlots = 0;


	if (X2WeaponTemplate(equippedItem.GetMyTemplate()) != none)
	{
		numSlots = X2WeaponTemplate(equippedItem.GetMyTemplate()).NumUpgradeSlots;
	}
	
	WeaponUpgrades = equippedItem.GetMyWeaponUpgradeTemplateNames();
	numUpgrades = 0;
		
	for (index = 0; index < WeaponUpgrades.Length; index++)
	{
		if (WeaponUpgrades[index] != '')
		{
			numUpgrades++;
		}
	}

	if (numSlots > 0 || numUpgrades > 0)
	{
		GetListItem(i).EnableNavigation();
		GetListItem(i++).UpdateDataValue(m_strWeaponUpgrades, numUpgrades $ "/" $ numSlots, OnClickUpgradeWeapon);
	}

	if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplateName() != 'Rookie' && m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplateName() != 'Reaper')
	{
		equippedItem = m_CurrentSquad[m_SelectedSoldier].GetItemInSlot(eInvSlot_SecondaryWeapon, StartState, true);
		GetListItem(i).EnableNavigation();
		GetListItem(i++).UpdateDataValue(m_SecondaryWeapon, equippedItem.GetMyTemplate().GetItemFriendlyNameNoStats(), OnClickSecondaryWeapon);
	}

	equippedItem = m_CurrentSquad[m_SelectedSoldier].GetItemInSlot(eInvSlot_Armor, StartState, true);
	GetListItem(i).EnableNavigation();
	GetListItem(i++).UpdateDataValue(m_ArmorLabel, equippedItem.GetMyTemplate().GetItemFriendlyNameNoStats(), OnClickArmor);

	
	if (m_CurrentSquad[m_SelectedSoldier].IsSufficientRankToEquipPCS() && m_CurrentSquad[m_SelectedSoldier].GetCurrentStat(eStat_CombatSims) > 0)
	{
		utilItems = m_CurrentSquad[m_SelectedSoldier].GetAllItemsInSlot(eInvSlot_CombatSim, StartState, , true);
		GetListItem(i).EnableNavigation();
		GetListItem(i++).UpdateDataValue(m_PCSLabel, utilItems[0].GetMyTemplate().GetItemFriendlyNameNoStats(), OnClickPCS);
	}

	if (m_CurrentSquad[m_SelectedSoldier].GetCurrentStat( eStat_UtilityItems ) > 0)
	{
		utilItems = m_CurrentSquad[m_SelectedSoldier].GetAllItemsInSlot(eInvSlot_Utility, StartState, , true);
		GetListItem(i).EnableNavigation();
		GetListItem(i++).UpdateDataValue(m_UtilItem1, utilItems[0].GetMyTemplate().GetItemFriendlyNameNoStats(), OnClickUtilItem1);
	}

	if( m_CurrentSquad[m_SelectedSoldier].HasExtraUtilitySlot() )
	{
		GetListItem(i).EnableNavigation();
		GetListItem(i++).UpdateDataValue(m_UtilItem2, utilItems[1].GetMyTemplate().GetItemFriendlyNameNoStats(), OnClickUtilItem2);
	}

	if (m_CurrentSquad[m_SelectedSoldier].HasGrenadePocket())
	{
		equippedItem = m_CurrentSquad[m_SelectedSoldier].GetItemInSlot(eInvSlot_GrenadePocket, StartState, true);
		GetListItem(i).EnableNavigation();
		GetListItem(i++).UpdateDataValue(m_GrenadierGrenade, equippedItem.GetMyTemplate().GetItemFriendlyNameNoStats(), OnClickGrenadePocket);
	}

	if (m_CurrentSquad[m_SelectedSoldier].HasHeavyWeapon())
	{
		equippedItem = m_CurrentSquad[m_SelectedSoldier].GetItemInSlot(eInvSlot_HeavyWeapon, StartState, true);
		GetListItem(i).EnableNavigation();
		GetListItem(i++).UpdateDataValue(m_HeavyWeaponLabel, equippedItem.GetMyTemplate().GetItemFriendlyNameNoStats(), OnClickHeavyWeapon);
	}
}

simulated function OnClickUpgradeWeapon()
{
	m_CurrentState = eUISkirmishScreen_MAX;
	m_AdditionalState = EUISkirmishScreenCustom_WeaponUpgrade;
	UpdateData();
}

simulated function UpdateDataWeaponUpgrades()
{
	local XComGameState_Item equippedItem;
	local int i, index, UpgradeSlots;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2WeaponUpgradeTemplate UpgradeTemplate;
	local array<name> UpgradeNames;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	equippedItem = m_CurrentSquad[m_SelectedSoldier].GetItemInSlot(eInvSlot_PrimaryWeapon, StartState, true);

	UpgradeSlots = X2WeaponTemplate(equippedItem.GetMyTemplate()).NumUpgradeSlots;
	UpgradeNames = equippedItem.GetMyWeaponUpgradeTemplateNames();

	i = 0;
	for (index = 0; index < UpgradeSlots || index < UpgradeNames.Length; index++)
	{
		if (index < UpgradeNames.Length)
		{
			UpgradeTemplate = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate(UpgradeNames[index]));

			if (UpgradeTemplate != none)
			{
				GetListItem(i).EnableNavigation();
				if (index >= UpgradeSlots)
				{
					GetListItem(i).SetDisabled(true, m_strCannotChangeUpgrade);
				}
				GetListItem(i++).UpdateDataValue(UpgradeTemplate.GetItemFriendlyNameNoStats(), "",,, OnClickSelectUpgradeSlot);
				continue;
			}
		}
		GetListItem(i).EnableNavigation();
		if (index >= UpgradeSlots)
		{
			GetListItem(i).SetDisabled(true, m_strCannotChangeUpgrade);
		}
		GetListItem(i++).UpdateDataValue(m_strEmptyWeaponUpgrade, "",,, OnClickSelectUpgradeSlot);
	}
}

simulated function OnClickSelectUpgradeSlot(UIMechaListItem MechaItem)
{
	local int selectedIndex;

	for (selectedIndex = 0; selectedIndex < List.ItemContainer.ChildPanels.Length; selectedIndex++)
	{
		if (GetListItem(selectedIndex) == MechaItem)
			break;
	}

	UpgradeIndex = selectedIndex;

	m_CurrentState = eUISkirmishScreen_MAX;
	m_AdditionalState = EUISkirmishScreenCustom_WeaponChooseUpgrade;
	UpdateData();
}

simulated function UpdateDataChooseWeaponUpgrades()
{
	local X2ItemTemplateManager ItemTemplateManager;
	local array<X2WeaponUpgradeTemplate> WeaponUpgrades;
	local X2WeaponUpgradeTemplate EquipmentTemplate;
	local XComGameState_Item equippedItem;
	local int index;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	WeaponUpgrades = ItemTemplateManager.GetAllUpgradeTemplates();	

	equippedItem = m_CurrentSquad[m_SelectedSoldier].GetItemInSlot(eInvSlot_PrimaryWeapon, StartState, true);

	index = 0;

	GetListItem(index).EnableNavigation();
	GetListItem(index).metadataString = "";
	GetListItem(index++).UpdateDataValue(m_strEmptyWeaponUpgrade, "", , , OnClickChooseWeaponUpgrade);

	foreach WeaponUpgrades(EquipmentTemplate)
	{
		if (!FilterTemplateName(EquipmentTemplate.DataName))
		{
			GetListItem(index).EnableNavigation();
			GetListItem(index).metadataString = string(EquipmentTemplate.DataName);
			if( !EquipmentTemplate.CanApplyUpgradeToWeapon(equippedItem, UpgradeIndex) )
			{
				GetListItem(index).SetDisabled(true, class'UIArmory_WeaponUpgrade'.default.m_strInvalidUpgrade);
			}
			GetListItem(index++).UpdateDataValue(EquipmentTemplate.GetItemFriendlyNameNoStats(), default.ShowTemplateName ? string(EquipmentTemplate.DataName) : "", , , OnClickChooseWeaponUpgrade);
		}
	}
}

simulated function OnClickChooseWeaponUpgrade(UIMechaListItem MechaItem)
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2WeaponUpgradeTemplate EquipmentTemplate;
	local XComGameState_Item equippedItem;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	equippedItem = m_CurrentSquad[m_SelectedSoldier].GetItemInSlot(eInvSlot_PrimaryWeapon, StartState, true);
	equippedItem.DeleteWeaponUpgradeTemplate(UpgradeIndex);

	if (MechaItem.metadataString != "")
	{
		EquipmentTemplate = X2WeaponUpgradeTemplate(ItemTemplateManager.FindItemTemplate( name(MechaItem.metadataString) ));
		if (EquipmentTemplate != none)
		{
			equippedItem.ApplyWeaponUpgradeTemplate(EquipmentTemplate, UpgradeIndex);
		}
	}
	
	m_AdditionalState = EUISkirmishScreenCustom_WeaponUpgrade;
	UpdateData();
	UpdateDataSoldierData();
}

simulated function UpdateDataSoldierAbilities()
{
	local int index;
	local X2SoldierClassTemplate SoldierClassTemplate;
	local array<SoldierRankAbilities> AbilityTree;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local SCATProgression Progression;
	local string Display;
	local int j, k;
	local bool Earned;
	local X2StrategyElementTemplateManager TemplateMan;
	local X2SoldierAbilityUnlockTemplate Template;
	local UIMechaListItem ListItem;
	local ClassAgnosticAbility AWC;
	local bool bIsPsiOp; 

	index = 0;

	SoldierClassTemplate = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager().FindSoldierClassTemplate(m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplateName());
	bIsPsiOp = (SoldierClassTemplate.DataName == 'PsiOperative');

	AbilityTree = m_CurrentSquad[m_SelectedSoldier].AbilityTree;

	m_arrProgression = m_CurrentSquad[m_SelectedSoldier].m_SoldierProgressionAbilties;
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	for (j = 0; j < AbilityTree.Length; ++j)
	{
		for (k = 0; k < AbilityTree[j].Abilities.Length; ++k)
		{
			if (AbilityTree[j].Abilities[k].AbilityName != '')
			{
				AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate( AbilityTree[j].Abilities[k].AbilityName );
				Display = AbilityTemplate.LocFriendlyName;
				Earned = false;

				foreach m_arrProgression(Progression)
				{
					if (Progression.iRank == j && Progression.iBranch == k && m_CurrentSquad[m_SelectedSoldier].MeetsAbilityPrerequisites(AbilityTree[j].Abilities[k].AbilityName))
					{
						Earned = true;
						break;
					}
				}

				ListItem = GetListItem(index++);

				ListItem.UpdateDataCheckbox(Display, "", Earned, OnAbilityCheckboxChanged);
				ListItem.metadataString = string(AbilityTemplate.DataName);
				ListItem.metadataInt = (j * 10) + k;

				if ((j == 0 && !bIsPsiOp) || !m_CurrentSquad[m_SelectedSoldier].MeetsAbilityPrerequisites(AbilityTree[j].Abilities[k].AbilityName)) // show but don't allow interaction with base class abilities, except PsiOp 
					ListItem.SetDisabled( true );
			}
		}
	}

	TemplateMan = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	UnlockTemplates = TemplateMan.GetAllTemplatesOfClass( class'X2SoldierAbilityUnlockTemplate' );

	for (j = 0; j < UnlockTemplates.Length; ++j)
	{
		Template = X2SoldierAbilityUnlockTemplate( UnlockTemplates[ j ] );
		if (Template.AllowedClasses.Find( SoldierClassTemplate.DataName ) != INDEX_NONE)
		{
			AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate( Template.AbilityName );
			Display = AbilityTemplate.LocFriendlyName;
			Earned = false;

			foreach m_CurrentSquad[m_SelectedSoldier].AWCAbilities( AWC )
			{
				if (AWC.AbilityType.AbilityName == Template.AbilityName)
				{
					Earned = true;
					break;
				}
			}

			GetListItem(index).UpdateDataCheckbox(Display, "", Earned, OnAbilityCheckboxChanged);
			GetListItem(index).metadataString = string(Template.AbilityName);
			GetListItem(index++).metadataInt = -j;
		}
	}

	GetListItem(index).EnableNavigation();
	GetListItem(index++).UpdateDataValue(m_strAddAWCAbility, "", OnClickAddAbilities);
}

simulated function OnAbilityCheckboxChanged(UICheckbox CheckboxControl)
{
	local int checkboxIndex, i;
	local SCATProgression Progression;
	local bool bFoundAbility;
	local UIMechaListItem ListItem;
	local ClassAgnosticAbility AWCAbility;

	Progression.iRank = 0;
	bFoundAbility = false;
	for (checkboxIndex = 0; checkboxIndex < List.ItemCount; checkboxIndex++)
	{
		ListItem = GetListItem(checkboxIndex);

		if (ListItem.Checkbox == CheckboxControl)
		{
			if (ListItem.metadataInt >= 0)
			{
				Progression.iRank = ListItem.metadataInt / 10;
				Progression.iBranch = ListItem.metadataInt % 10;

				for (i = 0; i < m_arrProgression.Length; i++)
				{
					if (m_arrProgression[i] == Progression)
					{
						if (!CheckboxControl.bChecked)
						{
							m_arrProgression.Remove(i, 1);
						}
						bFoundAbility = true;
						break;
					}
				}

				if (!bFoundAbility && CheckboxControl.bChecked)
				{
					m_arrProgression.AddItem(Progression);
				}
			}
			else
			{
				for (i = 0; i < m_CurrentSquad[m_SelectedSoldier].AWCAbilities.Length; ++i)
				{
					if (m_CurrentSquad[m_SelectedSoldier].AWCAbilities[i].AbilityType.AbilityName == name(ListItem.metadataString))
					{
						if (!CheckboxControl.bChecked)
						{
							m_CurrentSquad[m_SelectedSoldier].AWCAbilities.Remove(i, 1);
						}
						bFoundAbility = true;
						break;
					}
				}

				if (!bFoundAbility && CheckboxControl.bChecked)
				{
					AWCAbility.bUnlocked = true;
					AWCAbility.AbilityType.AbilityName = name(ListItem.metadataString);

					m_CurrentSquad[m_SelectedSoldier].AWCAbilities.AddItem( AWCAbility );
				}
			}

			break;
		}
	}

	m_CurrentSquad[m_SelectedSoldier].SetSoldierProgression(m_arrProgression);
	RefreshDataSoldierAbilities();
}

simulated function RefreshDataSoldierAbilities()
{
	local int index;
	local X2SoldierClassTemplate SoldierClassTemplate;
	local array<SoldierRankAbilities> AbilityTree;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local SCATProgression Progression;
	local string Display;
	local int j, k;
	local bool Earned;
	local X2StrategyElementTemplateManager TemplateMan;
	local X2SoldierAbilityUnlockTemplate Template;
	local UIMechaListItem ListItem;
	local ClassAgnosticAbility AWC;
	local bool bIsPsiOp;

	index = 0;

	SoldierClassTemplate = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager().FindSoldierClassTemplate(m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplateName());
	bIsPsiOp = (SoldierClassTemplate.DataName == 'PsiOperative');

	AbilityTree = m_CurrentSquad[m_SelectedSoldier].AbilityTree;

	m_arrProgression = m_CurrentSquad[m_SelectedSoldier].m_SoldierProgressionAbilties;
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	for (j = 0; j < AbilityTree.Length; ++j)
	{
		for (k = 0; k < AbilityTree[j].Abilities.Length; ++k)
		{
			if (AbilityTree[j].Abilities[k].AbilityName != '')
			{
				AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilityTree[j].Abilities[k].AbilityName);
				Display = AbilityTemplate.LocFriendlyName;
				Earned = false;

				foreach m_arrProgression(Progression)
				{
					if (Progression.iRank == j && Progression.iBranch == k && m_CurrentSquad[m_SelectedSoldier].MeetsAbilityPrerequisites(AbilityTree[j].Abilities[k].AbilityName))
					{
						Earned = true;
						break;
					}
				}

				ListItem = GetListItem(index++);

				ListItem.UpdateDataCheckbox(Display, "", Earned, OnAbilityCheckboxChanged);
				ListItem.metadataString = string(AbilityTemplate.DataName);
				ListItem.metadataInt = (j * 10) + k;

				if ((j == 0 && !bIsPsiOp) || !m_CurrentSquad[m_SelectedSoldier].MeetsAbilityPrerequisites(AbilityTree[j].Abilities[k].AbilityName)) // show but don't allow interaction with base class abilities, except PsiOp 
					ListItem.SetDisabled(true);
				else
					ListItem.SetDisabled(false);
			}
		}
	}

	TemplateMan = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	UnlockTemplates = TemplateMan.GetAllTemplatesOfClass(class'X2SoldierAbilityUnlockTemplate');

	for (j = 0; j < UnlockTemplates.Length; ++j)
	{
		Template = X2SoldierAbilityUnlockTemplate(UnlockTemplates[j]);
		if (Template.AllowedClasses.Find(SoldierClassTemplate.DataName) != INDEX_NONE)
		{
			AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(Template.AbilityName);
			Display = AbilityTemplate.LocFriendlyName;
			Earned = false;

			foreach m_CurrentSquad[m_SelectedSoldier].AWCAbilities(AWC)
			{
				if (AWC.AbilityType.AbilityName == Template.AbilityName)
				{
					Earned = true;
					break;
				}
			}

			GetListItem(index).UpdateDataCheckbox(Display, "", Earned, OnAbilityCheckboxChanged);
			GetListItem(index).metadataString = string(Template.AbilityName);
			GetListItem(index++).metadataInt = -j;
		}
	}
}

simulated function UpdateAbilityInfo(int ItemIndex)
{
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local UIMechaListItem ListItem;
	local UISummary_Ability AbilityData;

	MC.FunctionVoid("HideAllScreens");

	ListItem = UIMechaListItem(List.GetItem(ItemIndex));
	
	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	if (ListItem.metadataString != "")
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(name(ListItem.metadataString));
	
		AbilityData = AbilityTemplate.GetUISummary_Ability();

		MC.BeginFunctionOp("SetAbilityData");
		MC.QueueString(AbilityTemplate.IconImage);
		MC.QueueString(AbilityData.Name);
		MC.QueueString(AbilityData.Description);//AbilityTemplate.LocLongDescription);
		MC.QueueString("" /*unlockString*/ );
		MC.QueueString("" /*rank icon*/ );
		MC.EndOp();
	}
	else
	{
		MC.BeginFunctionOp("SetAbilityData");
		MC.QueueString("");
		MC.QueueString("");
		MC.QueueString("");//AbilityTemplate.LocLongDescription);
		MC.QueueString("" /*unlockString*/ );
		MC.QueueString("" /*rank icon*/ );
		MC.EndOp();
	}
}

simulated function UpdateAWCAbility()
{
	local array<SoldierClassAbilityType> EligibleAbilities;
	local int Idx, RemIdx, index, j, k;
	local X2SoldierClassTemplate SoldierClassTemplate;
	local array<SoldierRankAbilities> AbilityTree;
	local array<name> EarnedAbilities;
	local ClassAgnosticAbility AWC;
	local X2AbilityTemplate AbilityTemplate;
	local X2AbilityTemplateManager AbilityTemplateManager;
	local array<SoldierClassRandomAbilityDeck> RandomAbilityDecks;
	local SoldierClassRandomAbilityDeck RandomAbilityDeck;
	local SoldierClassAbilityType Ability;

	SoldierClassTemplate = m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplate();
	if (SoldierClassTemplate.bAllowAWCAbilities)
	{
		EligibleAbilities = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager().GetCrossClassAbilities(SoldierClassTemplate);
	}
	RandomAbilityDecks = SoldierClassTemplate.RandomAbilityDecks;
	AbilityTree = m_CurrentSquad[m_SelectedSoldier].AbilityTree;

	foreach RandomAbilityDecks(RandomAbilityDeck)
	{
		foreach RandomAbilityDeck.Abilities(Ability)
		{
			if (Ability.AbilityName != '' && EligibleAbilities.Find('AbilityName', Ability.AbilityName) == INDEX_NONE)
			{
				EligibleAbilities.AddItem(Ability);
			}
		}
	}

	for (j = 0; j < AbilityTree.Length; ++j)
	{
		for (k = 0; k < AbilityTree[j].Abilities.Length; ++k)
		{
			if (AbilityTree[j].Abilities[k].AbilityName != '')
			{
				EarnedAbilities.AddItem(AbilityTree[j].Abilities[k].AbilityName);
			}
		}
	}

	foreach m_CurrentSquad[m_SelectedSoldier].AWCAbilities(AWC)
	{
		if (AWC.AbilityType.AbilityName != '')
		{
			EarnedAbilities.AddItem(AWC.AbilityType.AbilityName);
		}
	}

	for (Idx = 0; Idx < SoldierClassTemplate.ExcludedAbilities.Length; ++Idx)
	{
		RemIdx = EligibleAbilities.Find('AbilityName', SoldierClassTemplate.ExcludedAbilities[Idx]);
		if (RemIdx != INDEX_NONE)
			EligibleAbilities.Remove(RemIdx, 1);
	}

	index = 0;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	if (EligibleAbilities.Length > 0)
	{
		for(Idx = 0; Idx < EligibleAbilities.Length; Idx++)
		{
			if (EarnedAbilities.Find(EligibleAbilities[idx].AbilityName) == INDEX_NONE)
			{
				AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(EligibleAbilities[idx].AbilityName);

				GetListItem(index).EnableNavigation();
				GetListItem(index).metadataString = string(EligibleAbilities[idx].AbilityName);
				GetListItem(index).metadataInt = EligibleAbilities[idx].ApplyToWeaponSlot;
				GetListItem(index++).UpdateDataValue(AbilityTemplate.LocFriendlyName, "",,, OnClickSelectNewAbility);
			}
		}
	}
}

simulated function OnClickSelectNewAbility(UIMechaListItem MechaItem)
{
	local int selectedIndex, Idx;
	local int NumRanks, MinRankIdx, SmallestRank;
	local array<SoldierRankAbilities> AbilityTree;
	local SoldierClassAbilityType AbilityToAdd;
	local SCATProgression Progression;

	for (selectedIndex = 0; selectedIndex < List.ItemContainer.ChildPanels.Length; selectedIndex++)
	{
		if (GetListItem(selectedIndex) == MechaItem)
			break;
	}

	AbilityTree = m_CurrentSquad[m_SelectedSoldier].AbilityTree;

	NumRanks = m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplate().GetMaxConfiguredRank();
	SmallestRank = AbilityTree[1].Abilities.Length;
	MinRankIdx = 1;
	for (Idx = 2; Idx < NumRanks; Idx++)
	{
		if (AbilityTree[Idx].Abilities.Length < SmallestRank)
		{
			SmallestRank = AbilityTree[Idx].Abilities.Length;
			MinRankIdx = Idx;
		}
	}
	
	AbilityToAdd.AbilityName = name(GetListItem(selectedIndex).metadataString);
	AbilityToAdd.ApplyToWeaponSlot = EInventorySlot(GetListItem(selectedIndex).metadataInt);

	if (SmallestRank < 9)
	{
	m_arrProgression = m_CurrentSquad[m_SelectedSoldier].m_SoldierProgressionAbilties;
	m_CurrentSquad[m_SelectedSoldier].AbilityTree[MinRankIdx].Abilities.AddItem(AbilityToAdd);
	Progression.iRank = MinRankIdx;
	Progression.iBranch = m_CurrentSquad[m_SelectedSoldier].AbilityTree[MinRankIdx].Abilities.Length - 1;
	m_arrProgression.AddItem(Progression);

	m_CurrentSquad[m_SelectedSoldier].SetSoldierProgression(m_arrProgression);
	}
	
	m_AdditionalState = EUISkirmishScreenCustom_None;
	m_CurrentState = eUISkirmishScreen_SoldierAbilities;
	UpdateData();
}

simulated function UpdateEditSoldierMenuItems()
{
	local int index;
	index = 0;

	GetListItem(index).EnableNavigation();
	GetListItem(index++).UpdateDataValue(m_RemoveUnit, "", RemoveSoldierPopup);

	GetListItem(index).EnableNavigation();
	GetListItem(index++).UpdateDataValue(m_strSelectUnitType, "", OnClickEditUnitType);
	if (m_CurrentSquad[m_SelectedSoldier].IsSoldier()) // Soldier class
	{
		GetListItem(index).EnableNavigation();
		GetListItem(index++).UpdateDataValue(m_ChangeClass, "", OnClickChangeClass);
		if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplateName() != 'Rookie')
		{
			GetListItem(index).EnableNavigation();
			GetListItem(index++).UpdateDataValue(m_EditAbilities, "", OnClickEditAbilities);
		}
		GetListItem(index).EnableNavigation();
		GetListItem(index++).UpdateDataValue(m_EditEquipment, "", OnClickEditEquipment);

		if (m_CurrentSquad[m_SelectedSoldier].GetSoldierClassTemplateName() != 'Rookie')
		{
			GetListItem(index).EnableNavigation();
			GetListItem(index++).UpdateDataValue(m_EditRank, "", OnClickEditRank);
		}

		GetListItem(index).EnableNavigation();
		GetListItem(index++).UpdateDataValue(m_strLoadCharPool, "", OnClickCharacterPool);
	}
	else // Alien class
	{
		if (m_CurrentSquad[m_SelectedSoldier].IsChosen())
		{
			GetListItem(index).EnableNavigation();
			GetListItem(index++).UpdateDataValue(m_EditAbilities, "", OnClickEditChosenStrWeak);
		}
	}
}

simulated function OnClickAddAbilities()
{
	m_CurrentState = eUISkirmishScreen_MAX;
	m_AdditionalState = EUISkirmishScreenCustom_AddAWCRolls;
	UpdateData();
}

simulated function OnClickCharacterPool()
{
	m_CurrentState = eUISkirmishScreen_MAX;
	m_AdditionalState = EUISkirmishScreenCustom_CharacterPool;
	UpdateData();
}

simulated function OnClickEditUnitType()
{
	m_CurrentState = eUISkirmishScreen_MAX;
	m_AdditionalState = EUISkirmishScreenCustom_SelectUnitType;
	UpdateData();
}

simulated function OnClickEditChosenStrWeak()
{
	m_CurrentState = eUISkirmishScreen_MAX;
	m_AdditionalState = EUISkirmishScreenCustom_ChosenStrWeak;
	UpdateData();
}

simulated function UpdateCharacterPool()
{
	local int index, loopIndex;
	local XComGameState_Unit Soldier;
	local CharacterPoolManager CharacterPoolMgr;
	local string soldierName;

	CharacterPoolMgr = CharacterPoolManager(`XENGINE.GetCharacterPoolManager());

	index = 0;

	GetListItem(index).EnableNavigation();
	GetListItem(index++).UpdateDataValue(m_strNoChange, "", , , OnClickCharacterPoolUnit);

	for( loopIndex = 0; loopIndex < CharacterPoolMgr.CharacterPool.Length; loopIndex++ )
	{
		Soldier = CharacterPoolMgr.CharacterPool[loopIndex];

		if( Soldier.GetNickName() != "" )
			soldierName = Soldier.GetFirstName() @ Soldier.GetNickName() @ Soldier.GetLastName();
		else
			soldierName = Soldier.GetFirstName() @ Soldier.GetLastName();

		GetListItem(index).EnableNavigation();
		if (Soldier.GetMyTemplate().DataName != m_CurrentSquad[m_SelectedSoldier].GetMyTemplate().DataName)
		{
			GetListItem(index).SetDisabled(true, m_strSoldierTypeMismatch);
		}
		GetListItem(index++).UpdateDataValue(soldierName, "", , , OnClickCharacterPoolUnit);
	}
}

simulated function OnClickCharacterPoolUnit(UIMechaListItem MechaItem)
{
	local XComGameState_Unit Unit;
	local int selectedIndex;
	local XComGameState_Unit Soldier;
	local CharacterPoolManager CharacterPoolMgr;

	for (selectedIndex = 0; selectedIndex < List.ItemContainer.ChildPanels.Length; selectedIndex++)
	{
		if (GetListItem(selectedIndex) == MechaItem)
			break;
	}


	CharacterPoolMgr = CharacterPoolManager(`XENGINE.GetCharacterPoolManager());
	
	if (selectedIndex > 0 && selectedIndex < CharacterPoolMgr.CharacterPool.Length + 1)
	{
		Soldier = CharacterPoolMgr.CharacterPool[selectedIndex - 1];
		Unit = m_CurrentSquad[m_SelectedSoldier];

		Unit.SetTAppearance(Soldier.kAppearance);
		Unit.SetCharacterName(Soldier.GetFirstName(), Soldier.GetLastName(), Soldier.GetNickName(true));
		Unit.SetCountry(Soldier.GetCountry());
		Unit.SetBackground(Soldier.GetBackground());
	}

	m_CurrentState = eUISkirmishScreen_SoldierData;
	UpdateData();
}

simulated static function QuickSort(int start_idx, int len, out array<name> NameList)
{
	local int pivot, i, len_tmp;
	local name nameEntry;
	if (len <= 1) // Smallest unit, break
		return;
	len_tmp = len;
	pivot = start_idx + (len / 2);
	for ( i = start_idx; i < start_idx + len_tmp; i++ )
	{
		if (i < pivot)
		{
			if (string(NameList[i]) > string(NameList[pivot]))
			{
				nameEntry = NameList[i];
				NameList.Remove(i, 1);
				i--;
				pivot--;
				NameList.InsertItem(start_idx + len_tmp - 1, nameEntry);
				len_tmp--;
			}
		}
		else if (i > pivot)
		{
			if (string(NameList[i]) < string(NameList[pivot]))
			{
				nameEntry = NameList[i];
				NameList.Remove(i, 1);
				NameList.InsertItem(start_idx, nameEntry);
				pivot++;
			}
		}
	}
	QuickSort(start_idx, pivot - start_idx, NameList);
	QuickSort(pivot + 1, start_idx + len - pivot - 1, NameList);
}

simulated function UpdateUnitTypes()
{
	local X2CharacterTemplateManager CharMgr;
	local X2CharacterTemplate CharTemplate;
	local array<name> arrNames;
	local int i, index, charIndex;
	local string CharNames, DupeName, DupeDataName, TempName;

	`log("===Start populating units===",, 'SkirmishMode');
	CharMgr = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	CharMgr.GetTemplateNames(arrNames);

	arrNames.RemoveItem('Soldier');
	arrNames.RemoveItem('TutorialCentral'); // This template counts as soldier but has no default class

	`log("got all units, proceed to sort",, 'SkirmishMode');

	// sort the templates by alphabetical order, to make searching them faster.
	QuickSort(0, arrNames.Length, arrNames);

	arrNames.InsertItem(0, 'Soldier');
	`log("===unit list populateds===",, 'SkirmishMode');

	index = 0;

	DupeName = "";
	DupeDataName = "";

	for (i = 0; i < arrNames.Length; ++i)
	{
		CharTemplate = CharMgr.FindCharacterTemplate(arrNames[i]);
		if (CharTemplate == none
			|| CharTemplate.CharacterGroupName == 'Speaker'
			|| CharTemplate.bIsCivilian
			|| CharTemplate.bIsEngineer
			|| CharTemplate.bIsScientist
			|| CharTemplate.bIsCosmetic
			|| CharTemplate.bIsTurret) // remove speaker templates from TQL, since they aren't meant to be playable
			continue;

		CharNames = CharTemplate.strCharacterName;

		if (CharNames == "")
		{
			CharNames = string(CharTemplate.DataName);
		}

		if (CharNames == DupeName)
		{
			charIndex = Len(DupeDataName);
			if (Len(string(CharTemplate.DataName)) > charIndex && 
				DupeDataName == Left(string(CharTemplate.DataName), charIndex))
			{
				TempName = Mid(string(CharTemplate.DataName), charIndex);
				if (Left(TempName, 1) == "_")
				{
					TempName = Mid(TempName, 1);
				}
			}
			else
			{
				TempName = Right(string(CharTemplate.DataName), 3);
				charIndex = InStr(TempName, "M");
				if (charIndex > 0)
				{
					TempName = Mid(TempName, charIndex);
				}
			}
			CharNames @= TempName;
		}
		else
		{
			DupeName = CharNames;
			DupeDataName = string(CharTemplate.DataName);
		}

		GetListItem(index).EnableNavigation();
		GetListItem(index).metadataString = string(arrNames[i]);
		GetListItem(index++).UpdateDataValue(CharNames, (default.ShowTemplateName && CharTemplate.strCharacterName != string(CharTemplate.DataName)) ? string(CharTemplate.DataName) : "", , , OnClickSetUnitType);
	}
}

simulated function XComGameState_Unit CreateNonSoldier(name CharTemplateName)
{
	local X2CharacterTemplate CharTemplate;
	local XComGameState_Unit BuildUnit;
	local name RequiredLoadout;

	CharTemplate = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate(CharTemplateName);
	`assert(CharTemplate != none);

	BuildUnit = CharTemplate.CreateInstanceFromTemplate(StartState);
	BuildUnit.SetControllingPlayer(XComPlayerState.GetReference());

	HeadquartersStateObject.AddToCrewNoStrategy(BuildUnit);
	HeadquartersStateObject.Squad.AddItem(BuildUnit.GetReference());

	RequiredLoadout = CharTemplate.RequiredLoadout;
	if (RequiredLoadout != '')
	{
		BuildUnit.ApplyInventoryLoadout(StartState, RequiredLoadout);
	}
	else
	{
		BuildUnit.ApplyInventoryLoadout(StartState);
	}

	return BuildUnit;
}

simulated function OnClickSetUnitType(UIMechaListItem MechaItem)
{
	local XComGameState_Unit Unit;
	local name OldTemplate, NewTemplate;
	local int i;
	local array<XComGameState_Item> InventoryItems;
	local X2CharacterTemplate CharTemplate;

	Unit = m_CurrentSquad[m_SelectedSoldier];
	OldTemplate = Unit.GetMyTemplateName();
	NewTemplate = name(MechaItem.metadataString);

	CharTemplate = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate(NewTemplate);

	if (CharTemplate != none && OldTemplate != NewTemplate)
	{
		InventoryItems = Unit.GetAllInventoryItems( StartState );
		for (i = 0; i < InventoryItems.Length; i++)
		{
			Unit.RemoveItemFromInventory( InventoryItems[ i ], StartState );
		}
		StartState.PurgeGameStateForObjectID( Unit.ObjectID, true );

		HeadquartersStateObject.Squad.RemoveItem( Unit.GetReference( ) );
		HeadquartersStateObject.RemoveFromCrew( Unit.GetReference( ) );

		i = m_CurrentSquad.Find( Unit );
		m_CurrentSquad[ i ] = none;
		Unit = none;

		if (CharTemplate.bIsSoldier)
		{
			Unit = CreateUnit( CharTemplate.DefaultSoldierClass );
			GiveUnitBasicEquipment( Unit );
		}
		else
		{
			Unit = CreateNonSoldier( NewTemplate );
		}
		m_CurrentSquad[ i ] = Unit;
	}

	m_CurrentState = eUISkirmishScreen_SoldierData;
	UpdateData();
}

function FilterTraitList(XComGameState_AdventChosen ChosenState, out array<name> TraitList)
{
	local name TraitName, ExcludeTraitName;
	local X2AbilityTemplate TraitTemplate;
	local X2AbilityTemplateManager AbilityMgr;

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	
	foreach ChosenState.Strengths(TraitName)
	{
		TraitTemplate = AbilityMgr.FindAbilityTemplate(TraitName);

		if(TraitTemplate != none)
		{
			foreach TraitTemplate.ChosenExcludeTraits(ExcludeTraitName)
			{
				TraitList.RemoveItem(ExcludeTraitName);
			}
		}
	}

	foreach ChosenState.Weaknesses(TraitName)
	{
		TraitTemplate = AbilityMgr.FindAbilityTemplate(TraitName);

		if(TraitTemplate != none)
		{
			foreach TraitTemplate.ChosenExcludeTraits(ExcludeTraitName)
			{
				TraitList.RemoveItem(ExcludeTraitName);
			}
		}
	}
}

simulated function UpdateDataChosenStrWeak()
{
	local XComGameState_AdventChosen ChosenState;
	local array<X2AbilityTemplate> AllTraits;
	local array<name> EnabledTraits;
	local X2AbilityTemplateManager AbilityMgr;
	local name DataName;
	local X2AbilityTemplate Ability;
	local int index;
	local UIMechaListItem ListItem;
	local bool Earned;

	ChosenState = m_CurrentSquad[m_SelectedSoldier].GetChosenGameState();
	ChosenState = XComGameState_AdventChosen(StartState.GetGameStateForObjectID(ChosenState.ObjectID));

	AbilityMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	`assert(ChosenState != none);

	foreach ChosenState.default.ChosenStrengths(DataName)
	{
		AllTraits.AddItem(AbilityMgr.FindAbilityTemplate(DataName));
		EnabledTraits.AddItem(DataName);
	}

	foreach ChosenState.default.ChosenWeaknesses(DataName)
	{
		AllTraits.AddItem(AbilityMgr.FindAbilityTemplate(DataName));
		EnabledTraits.AddItem(DataName);
	}

	FilterTraitList(ChosenState, EnabledTraits);

	index = 0;

	foreach AllTraits(Ability)
	{
		ListItem = GetListItem(index++);

		Earned = ChosenState.Strengths.Find(Ability.DataName) != INDEX_NONE || ChosenState.Weaknesses.Find(Ability.DataName) != INDEX_NONE;

		ListItem.UpdateDataCheckbox(Ability.LocFriendlyName, "", Earned, OnChosenCheckboxChanged);
		ListItem.metadataString = string(Ability.DataName);

		if (!Earned && EnabledTraits.Find(Ability.DataName) == INDEX_NONE)
		{
			ListItem.SetDisabled( true );
		}
	}
}

simulated function OnChosenCheckboxChanged(UICheckbox CheckboxControl)
{
	local int checkboxIndex;
	local UIMechaListItem ListItem;
	local XComGameState_AdventChosen ChosenState;
	local array<name> EnabledTraits;

	ChosenState = m_CurrentSquad[m_SelectedSoldier].GetChosenGameState();
	ChosenState = XComGameState_AdventChosen(StartState.GetGameStateForObjectID(ChosenState.ObjectID));
	`assert(ChosenState != none);

	for (checkboxIndex = 0; checkboxIndex < List.ItemCount; checkboxIndex++)
	{
		ListItem = GetListItem(checkboxIndex);

		if (ListItem.Checkbox == CheckboxControl)
		{
			if (CheckboxControl.bChecked)
			{
				ChosenState.AddTrait(name(ListItem.metadataString));
			}
			else
			{
				ChosenState.RemoveTrait(name(ListItem.metadataString));
			}
		}
	}

	
	for (checkboxIndex = 0; checkboxIndex < List.ItemCount; checkboxIndex++)
	{
		ListItem = GetListItem(checkboxIndex);
		EnabledTraits.AddItem(name(ListItem.metadataString));
	}

	FilterTraitList(ChosenState, EnabledTraits);

	for (checkboxIndex = 0; checkboxIndex < List.ItemCount; checkboxIndex++)
	{
		ListItem = GetListItem(checkboxIndex);
		if (!ListItem.Checkbox.bChecked && EnabledTraits.Find(name(ListItem.metadataString)) == INDEX_NONE)
		{
			ListItem.SetDisabled(true);
		}
		else
		{
			ListItem.SetDisabled(false);
		}
	}
}

simulated function UpdateDataSelectBaseMap()
{
	local int index;
	local array<PlotDefinition> ValidPlots;
	local PlotDefinition NewPlot;

	index = 0;

	ParcelManager.GetValidPlotsForMission(ValidPlots, BattleDataState.MapData.ActiveMission);


	foreach ValidPlots(NewPlot)
	{
		if (NewPlot.strType == MapTypeString)
		{
			GetListItem(index).EnableNavigation();
			GetListItem(index).metadataString = NewPlot.MapName;
			GetListItem(index++).UpdateDataValue(NewPlot.MapName, "", , , OnClickNewMapBase);
		}
	}
}

simulated function OnClickNewMapBase(UIMechaListItem MechaItem)
{
	BattleDataState.MapData.PlotMapName = MechaItem.metadataString;
	BattleDataState.m_strMapCommand = "open" @ BattleDataState.MapData.PlotMapName $ "?game=XComGame.XComTacticalGame";

	m_AdditionalState = EUISkirmishScreenCustom_None;
	m_CurrentState = eUISkirmishScreen_MapData;
	UpdateData();
}

simulated function UpdateSitRep()
{
	local int index, MissionDefIndex;
	local array<name> SitReps;
	local array<X2SitRepTemplate> SitRepTemplates;
	local string SitRep;
	local XComGameState_HeadquartersAlien AlienHQ; 
	local X2SitRepTemplateManager SitRepMgr;
	local X2DataTemplate DataTemplate;
	local X2SitRepTemplate SitRepTemplate;

	AlienHQ = XComGameState_HeadquartersAlien(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersAlien'));

	SitReps = TacticalMissionManager.arrMissions[BattleDataState.m_iMissionType].ForcedSitreps;

	SitRepMgr = class'X2SitRepTemplateManager'.static.GetSitRepTemplateManager();

	index = 0;

	SitRepTemplate = SitRepMgr.FindSitRepTemplate('ChallengeNoReinforcements');
	
	GetListItem(index).EnableNavigation();
	GetListItem(index).metadataString = string(SitRepTemplate.DataName);
	GetListItem(index).UpdateDataCheckbox(SitRepTemplate.GetFriendlyName(), "", true, OnClickNewSitRep);
	GetListItem(index++).SetDisabled(true, m_strSitRepDisabled);

	foreach SitRepMgr.IterateTemplates(DataTemplate, class'X2StrategyElement_DefaultMissionSources'.static.StrategySitrepsFilter)
	{
		SitRepTemplate = X2SitRepTemplate(DataTemplate);

		if (SitRepTemplate != none)
		{
			AlienHQ.ForceLevel = SitRepTemplate.MinimumForceLevel;
			if (SitReps.Find(SitRepTemplate.DataName) != INDEX_NONE) 
			{
				GetListItem(index).EnableNavigation();
				GetListItem(index).metadataString = string(SitRepTemplate.DataName);
				GetListItem(index).UpdateDataCheckbox(SitRepTemplate.GetFriendlyName(), "", true, OnClickNewSitRep);
				GetListItem(index++).SetDisabled(true, m_strSitRepIsForced);
			}
			else if (SitRepTemplate.MeetsRequirements(ChallengeMissionSite))
			{
				GetListItem(index).EnableNavigation();
				GetListItem(index).metadataString = string(SitRepTemplate.DataName);
				GetListItem(index++).UpdateDataCheckbox(SitRepTemplate.GetFriendlyName(), "", BattleDataState.ActiveSitReps.Find(SitRepTemplate.DataName) != INDEX_NONE, OnClickNewSitRep);
			}
			else
			{
				GetListItem(index).EnableNavigation();
				GetListItem(index).metadataString = string(SitRepTemplate.DataName);
				GetListItem(index).UpdateDataCheckbox(SitRepTemplate.GetFriendlyName(), "", false, OnClickNewSitRep);
				GetListItem(index++).SetDisabled(true, m_strSitRepDisabled);
			}
		}
	}
}

simulated function OnClickNewSitRep(UICheckbox CheckboxControl)
{
	local int checkboxIndex;
	local UIMechaListItem ListItem;

	for (checkboxIndex = 0; checkboxIndex < List.ItemCount; checkboxIndex++)
	{
		ListItem = GetListItem(checkboxIndex);

		if (ListItem.Checkbox == CheckboxControl)
		{
			if (CheckboxControl.bChecked)
			{
				BattleDataState.ActiveSitReps.AddItem(name(ListItem.metadataString));
			}
			else 
			{
				BattleDataState.ActiveSitReps.RemoveItem(name(ListItem.metadataString));
			}	
			ChallengeMissionSite.GeneratedMission.SitReps = BattleDataState.ActiveSitReps;
		}
	}
}

simulated function UpdateSitRepInfo(int ItemIndex)
{
	local X2SitRepTemplate SitRepTemplate;
	local X2SitRepTemplateManager SitRepMgr;
	local UIMechaListItem ListItem;

	MC.FunctionVoid("HideAllScreens");
	SitRepMgr = class'X2SitRepTemplateManager'.static.GetSitRepTemplateManager();

	ListItem = UIMechaListItem(List.GetItem(ItemIndex));
	if (ListItem.metadataString != "")
	{
		SitRepTemplate = SitRepMgr.FindSitRepTemplate(name(ListItem.metadataString));

		MC.BeginFunctionOp("SetAbilityData");
		MC.QueueString("img:///UILibrary_XPACK_Common.PerkIcons.str_mechlord");
		MC.QueueString(SitRepTemplate.GetFriendlyName());
		MC.QueueString(SitRepTemplate.Description);//AbilityTemplate.LocLongDescription);
		MC.QueueString("" /*unlockString*/ );
		MC.QueueString("" /*rank icon*/ );
		MC.EndOp();
	}
	else
	{
		MC.BeginFunctionOp("SetAbilityData");
		MC.QueueString("");
		MC.QueueString("");
		MC.QueueString("");//AbilityTemplate.LocLongDescription);
		MC.QueueString("" /*unlockString*/ );
		MC.QueueString("" /*rank icon*/ );
		MC.EndOp();
	}
}

simulated function OnClickSelectMap()
{
	m_CurrentState = eUISkirmishScreen_MAX;
	m_AdditionalState = EUISkirmishScreenCustom_SelectMap;
	UpdateData();
}

simulated function OnClickSelectSitRep()
{
	m_CurrentState = eUISkirmishScreen_MAX;
	m_AdditionalState = EUISkirmishScreenCustom_SitReps;
	UpdateData();
}

simulated function UpdateDataMapData()
{
	local int i;

	super.UpdateDataMapData();

	i = List.ItemContainer.ChildPanels.Length;

	GetListItem(i).EnableNavigation();
	GetListItem(i++).UpdateDataValue(m_strSelectMapBase, "", OnClickSelectMap);

	GetListItem(i).EnableNavigation();
	GetListItem(i++).UpdateDataValue(m_strSelectSitRep, string(BattleDataState.ActiveSitReps.Length), OnClickSelectSitRep);
}

simulated function UpdateLoadConfig()
{
	local array<string> SaveDisplay;
	local array<name> SaveFileName;
	local int i, index;

	class'HistorySavePairs'.static.GetHistory(SaveFileName, SaveDisplay);

	
	index = 0;

	for (i = 0; i < SaveFileName.Length; i++)
	{
		GetListItem(index).EnableNavigation();
		GetListItem(index).metadataString = string(SaveFileName[i]);
		GetListItem(index++).UpdateDataValue(SaveDisplay[i], "", , , OnClickLoadSkirmishSave);
	}
}

simulated function OnClickLoadSkirmishSave(UIMechaListItem MechaItem)
{
	local TDialogueBoxData  kDialogData;
	local PlotDefinition NewPlot;
	local XComGameState_Player PlayerState;	
	local X2MissionTemplateManager MissionTemplateManager;
	local int i;	
	local array<name> missionNames;
	local StateObjectReference SoldierRef;
	local bool bWildernessMap;
	local MissionDefinition MissionDef;
	local PlotTypeDefinition PlotType;

	MissionTemplateManager = class'X2MissionTemplateManager'.static.GetMissionTemplateManager();
	MissionTemplateManager.GetTemplateNames(missionNames);
	
	for (i = 0; i < m_FilteredMissions.Length; i++)
	{
		missionNames.RemoveItem(m_FilteredMissions[i]);
	}
	`log("missionNames length:" @ missionNames.Length,, 'SkirmishMode');

	`log("loading:" @ MechaItem.metadataString,, 'SkirmishMode');

	if (`XCOMHISTORY.ReadHistoryFromFile("Skirmishes/", MechaItem.metadataString $ ".x2hist"))
	{
		// Properly re-assign variables
		StartState = `XCOMHISTORY.GetStartState();
		BattleDataState = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
		NewPlot = ParcelManager.GetPlotDefinition(BattleDataState.PlotData.strType, BattleDataState.MapData.Biome);
		PlotType = ParcelManager.GetPlotTypeDefinition(BattleDataState.PlotData.strType);

		`log("loading map:" @ BattleDataState.PlotData.strType,, 'SkirmishMode');

		m_SelectedEnemy = class'HistorySavePairs'.static.GetEnemyIndex(name(MechaItem.metadataString));
		`log("loading enemy:" @ m_SelectedEnemy,, 'SkirmishMode');

		for (m_SelectedMissionType = 0; m_SelectedMissionType < missionNames.Length; m_SelectedMissionType++)
		{
			`log("iter mission type:" @ missionNames[m_SelectedMissionType],, 'SkirmishMode');
			if (missionNames[i] == TacticalMissionManager.arrMissions[BattleDataState.m_iMissionType].MissionName)
			{
				break;
			}
		}

		MapTypeString = BattleDataState.PlotData.strType;
		bWildernessMap = MapTypeString == "Wilderness";

		i = 0;

		for (m_currentBiome = 0; i + m_currentBiome < NewPlot.ValidBiomes.Length; m_currentBiome++)
		{
			`log("idx currbiome:" @ m_currentBiome @ "i:" @ i @ NewPlot.ValidBiomes[i + m_currentBiome],, 'SkirmishMode');
			if(!bWildernessMap && NewPlot.ValidBiomes[i + m_currentBiome] == "Xenoform")
			{
				i++;
				m_currentBiome--;
			}
			else if (NewPlot.ValidBiomes[i + m_currentBiome] == BattleDataState.MapData.Biome)
			{
				break;
			}
		}

		BiomeTypeString = BattleDataState.MapData.Biome;
		MapImagePath = `MAPS.SelectMapImage(MapTypeString, BiomeTypeString);

		foreach StartState.IterateByClassType(class'XComGameState_Player', PlayerState)
		{
			switch(PlayerState.TeamFlag)
			{
				case eTeam_XCom:
					XComPlayerState = PlayerState;
					break;
				default:
					break;
			}
		}

		CampaignSettings = XComGameState_CampaignSettings(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
		HeadquartersStateObject = XComGameState_HeadquartersXCom(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
		ChallengeMissionSite = XComGameState_MissionSite(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_MissionSite'));

		BattleDataState.m_nQuestItem = class'XComGameState_LadderProgress'.static.SelectQuestItem(TacticalMissionManager.arrMissions[BattleDataState.m_iMissionType].sType);
		ChallengeMissionSite.GeneratedMission.MissionQuestItemTemplate = BattleDataState.m_nQuestItem;

		if (!TacticalMissionManager.GetMissionDefinitionForType(TacticalMissionManager.arrMissions[BattleDataState.m_iMissionType].sType, MissionDef))
		{
			`Redscreen("CreateNewLadder(): Mission Type " $ TacticalMissionManager.arrMissions[BattleDataState.m_iMissionType].sType $ " has no definition!");
				return;
		}

		BattleDataState.MapData.ActiveMission = MissionDef;
		TacticalMissionManager.ForceMission = MissionDef;
		ChallengeMissionSite.GeneratedMission.Mission = MissionDef;
	
		BattleDataState.ActiveSitReps = MissionDef.ForcedSitreps;
		class'XComGameState_LadderProgress'.static.AppendNames( BattleDataState.ActiveSitReps, PlotType.ForcedSitReps );
		ChallengeMissionSite.GeneratedMission.SitReps = BattleDataState.ActiveSitReps;


		m_CurrentSquad.Length = 0; 
		foreach HeadquartersStateObject.Squad(SoldierRef)
		{
			m_CurrentSquad.AddItem(XComGameState_Unit(StartState.GetGameStateForObjectID(SoldierRef.ObjectID)));
		}

		UpdateDataSquad();
	}
	else
	{
		class'HistorySavePairs'.static.DeleteHistory(name(MechaItem.metadataString));

		// Add Alert
		kDialogData.eType = eDialog_Alert;
		kDialogData.strTitle = m_strMissingHistoryTitle;
		kDialogData.strText = m_strMissingHistoryText $ "\nSkirmishes\\" $ MechaItem.metadataString $ ".x2hist"; 

		Movie.Pres.UIRaiseDialog( kDialogData );
	}

	m_AdditionalState = EUISkirmishScreenCustom_None;
	m_CurrentState = eUISkirmishScreen_Base;
	UpdateData();
}

simulated function UpdateSaveConfig()
{
	local array<string> SaveDisplay;
	local array<name> SaveFileName;
	local int i, index;

	class'HistorySavePairs'.static.GetHistory(SaveFileName, SaveDisplay);

	
	index = 0;

	GetListItem(index).EnableNavigation();
	GetListItem(index).metadataString = "";
	GetListItem(index++).UpdateDataValue(m_strNewSave, "", , , OnClickNewSkirmishSave);

	for (i = 0; i < SaveFileName.Length; i++)
	{
		GetListItem(index).EnableNavigation();
		GetListItem(index).metadataString = SaveDisplay[i];
		GetListItem(index++).UpdateDataValue(SaveDisplay[i], "", , , OnClickNewSkirmishSave);
	}
}

simulated function OnClickNewSkirmishSave(UIMechaListItem MechaItem)
{
	local int selectedIndex;
	local TInputDialogData kData;

	for (selectedIndex = 0; selectedIndex < List.ItemContainer.ChildPanels.Length; selectedIndex++)
	{
		if (GetListItem(selectedIndex) == MechaItem)
			break;
	}

	if (selectedIndex > 0)
	{
		BattleDataState.PlotData.strType = MapTypeString;
		class'HistorySavePairs'.static.SaveHistory(`XCOMHISTORY, MechaItem.metadataString, m_SelectedEnemy);

		m_AdditionalState = EUISkirmishScreenCustom_None;
		m_CurrentState = eUISkirmishScreen_Base;
		UpdateData();
	}
	else
	{
		// SAVE ALERT
		kData.strTitle = m_strNewSaveName;
		kData.iMaxChars = class'XComCharacterCustomization'.const.NICKNAME_NAME_MAX_CHARS;
		kData.strInputBoxText = "Save" @ (class'HistorySavePairs'.default.HistorySaveIndex + 1);
		kData.fnCallback = OnNameInputBoxClosed;

		Movie.Pres.UIInputDialog(kData);
	}
}

function OnNameInputBoxClosed(string text)
{
	if (text != "")
	{
		BattleDataState.PlotData.strType = MapTypeString;
		class'HistorySavePairs'.static.SaveHistory(`XCOMHISTORY, text, m_SelectedEnemy);

		m_AdditionalState = EUISkirmishScreenCustom_None;
		m_CurrentState = eUISkirmishScreen_Base;
		UpdateData();
	}
}

simulated function UpdateSetForceOrAlertLevel()
{
	local int max_level, i;

	if (m_AdditionalState == EUISkirmishScreenCustom_SetForceLevel)
	{
		max_level = class'XComGameState_HeadquartersAlien'.default.AlienHeadquarters_MaxForceLevel;
	}
	else
	{
		max_level = default.MaxAlertLevel;
	}

	i = 0;

	GetListItem(i).EnableNavigation();
	GetListItem(i++).UpdateDataValue(m_strDefault, "", , , OnClickSetForceOrAlertLevel);

	while(i <= max_level)
	{
		GetListItem(i).EnableNavigation();
		GetListItem(i++).UpdateDataValue(string(i - 1), "", , , OnClickSetForceOrAlertLevel);
	}
}

simulated function OnClickSetForceOrAlertLevel(UIMechaListItem MechaItem)
{
	local int selectedIndex;

	for (selectedIndex = 0; selectedIndex < List.ItemContainer.ChildPanels.Length; selectedIndex++)
	{
		if (GetListItem(selectedIndex) == MechaItem)
			break;
	}
	
	if (m_AdditionalState == EUISkirmishScreenCustom_SetForceLevel)
	{
		OverrideForceLevel = selectedIndex;
	}
	else
	{
		OverrideAlertLevel = selectedIndex;
	}

	m_AdditionalState = EUISkirmishScreenCustom_None;
	m_CurrentState = eUISkirmishScreen_Base;
	UpdateData();
}

function string GetAlertLevel(out int AlertLevel)
{
	local int ForceLevel;
	local X2ChallengeAlertForce AlertForceSelector;

	if (OverrideAlertLevel > 0)
	{
		AlertLevel = OverrideAlertLevel;
		return string(AlertLevel);
	}

	AlertForceSelector = X2ChallengeAlertForce( ChallengeTemplateManager.FindChallengeTemplate( 'ChallengeCalculatedLevels' ) );
	class'X2ChallengeAlertForce'.static.SelectAlertAndForceLevels( AlertForceSelector, StartState, HeadquartersStateObject, AlertLevel, ForceLevel );

	return AlertLevel @ "[" $ m_strDefault $ "]";
}

function string GetForceLevel(out int ForceLevel)
{
	local int AlertLevel;
	local X2ChallengeAlertForce AlertForceSelector;

	if (OverrideForceLevel > 0)
	{
		ForceLevel = OverrideForceLevel;
		return string(ForceLevel);
	}

	AlertForceSelector = X2ChallengeAlertForce( ChallengeTemplateManager.FindChallengeTemplate( 'ChallengeCalculatedLevels' ) );
	class'X2ChallengeAlertForce'.static.SelectAlertAndForceLevels( AlertForceSelector, StartState, HeadquartersStateObject, AlertLevel, ForceLevel );

	return ForceLevel @ "[" $ m_strDefault $ "]";
}

simulated function OnClickSaveConfig()
{
	m_CurrentState = eUISkirmishScreen_MAX;
	m_AdditionalState = EUISkirmishScreenCustom_SaveConfig;
	UpdateData();
}

simulated function OnClickLoadConfig()
{
	m_CurrentState = eUISkirmishScreen_MAX;
	m_AdditionalState = EUISkirmishScreenCustom_LoadConfig;
	UpdateData();
}

simulated function OnClickSetForceLevel()
{
	m_CurrentState = eUISkirmishScreen_MAX;
	m_AdditionalState = EUISkirmishScreenCustom_SetForceLevel;
	UpdateData();
}

simulated function OnClickSetAlertLevel()
{
	m_CurrentState = eUISkirmishScreen_MAX;
	m_AdditionalState = EUISkirmishScreenCustom_SetAlertLevel;
	UpdateData();
}

simulated function UpdateDataBase()
{
	local int i, a;

	super.UpdateDataBase();

	i = List.ItemContainer.ChildPanels.Length;

	GetListItem(i).EnableNavigation();
	GetListItem(i++).UpdateDataValue(m_strForceLevel, GetForceLevel(a), OnClickSetForceLevel);

	GetListItem(i).EnableNavigation();
	GetListItem(i++).UpdateDataValue(m_strAlertLevel, GetAlertLevel(a), OnClickSetAlertLevel);

	GetListItem(i).EnableNavigation();
	GetListItem(i++).UpdateDataValue(m_strSaveConfig, "", OnClickSaveConfig);

	GetListItem(i).EnableNavigation();
	GetListItem(i++).UpdateDataValue(m_strLoadConfig, "", OnClickLoadConfig);
}

simulated function CreateNewLadder(int LadderDifficulty)
{
	local X2ChallengeEnemyForces EnemyForcesTemplate;
	local int Index;
	local int AlertLevel, ForceLevel;
	local X2ChallengeAlertForce AlertForceSelector;
	local XComOnlineProfileSettings ProfileSettings;

	if (ChallengeMissionSite != none)
	{
		if (BattleDataState.TQLEnemyForcesSelection == "")
		{
			BattleDataState.TQLEnemyForcesSelection = "ChallengeStandardSchedule";
		}

		AlertForceSelector = X2ChallengeAlertForce( ChallengeTemplateManager.FindChallengeTemplate( 'ChallengeCalculatedLevels' ) );
		class'X2ChallengeAlertForce'.static.SelectAlertAndForceLevels( AlertForceSelector, StartState, HeadquartersStateObject, AlertLevel, ForceLevel );
		if (OverrideForceLevel > 0)
		{
			ForceLevel = OverrideForceLevel;
		}
		if (OverrideAlertLevel > 0)
		{
			AlertLevel = OverrideAlertLevel;
		}
		BattleDataState.SetAlertLevel( AlertLevel );
		BattleDataState.SetForceLevel( ForceLevel );

		ChallengeMissionSite.SelectedMissionData.AlertLevel = AlertLevel;
		ChallengeMissionSite.SelectedMissionData.ForceLevel = ForceLevel;

		EnemyForcesTemplate = X2ChallengeEnemyForces(ChallengeTemplateManager.FindChallengeTemplate(name(BattleDataState.TQLEnemyForcesSelection)));
		if (EnemyForcesTemplate != none)
		{
			// Reset the encounter list to force the AI spawn manager to reselect the spawns based on the active forces selector.
			ChallengeMissionSite.SelectedMissionData.SelectedEncounters.Length = 0;

			// Add any tactical gameplay tags required by the enemy forces selector
			if (EnemyForcesTemplate.AdditionalTacticalGameplayTags.Length > 0)
			{
				for (Index = 0; Index < EnemyForcesTemplate.AdditionalTacticalGameplayTags.Length; ++Index)
				{
					HeadquartersStateObject.TacticalGameplayTags.AddItem(EnemyForcesTemplate.AdditionalTacticalGameplayTags[Index]);
					HeadquartersStateObject.CleanUpTacticalTags();
				}
			}
			class'X2ChallengeEnemyForces'.static.SelectEnemyForces(EnemyForcesTemplate, ChallengeMissionSite, BattleDataState, BattleDataState.GetParentGameState());

		}

		ChallengeMissionSite.UpdateSitrepTags( );
		HeadquartersStateObject.AddMissionTacticalTags( ChallengeMissionSite );
	}

	class'X2SitRepTemplate'.static.ModifyPreMissionBattleDataState(BattleDataState, BattleDataState.ActiveSitReps);

	ProfileSettings = `XPROFILESETTINGS;

	++ProfileSettings.Data.HubStats.NumSkirmishes;

	`ONLINEEVENTMGR.SaveProfileSettings();

	ConsoleCommand(BattleDataState.m_strMapCommand);
}

simulated public function OnCancel()
{
	super.OnCancel();

	if (m_CurrentState == eUISkirmishScreen_MAX)
	{
		switch(m_AdditionalState)
		{
			case EUISkirmishScreenCustom_SelectUnitType:
			case EUISkirmishScreenCustom_CharacterPool:
			case EUISkirmishScreenCustom_ChosenStrWeak:
				Movie.Pres.PlayUISound(eSUISound_MenuSelect);
				m_AdditionalState = EUISkirmishScreenCustom_None;
				m_CurrentState = eUISkirmishScreen_SoldierData;
				UpdateData();
				break;
			case EUISkirmishScreenCustom_WeaponUpgrade:
				Movie.Pres.PlayUISound(eSUISound_MenuSelect);
				m_AdditionalState = EUISkirmishScreenCustom_None;
				m_CurrentState = eUISkirmishScreen_SoldierEquipment;
				UpdateData();
				break;
			case EUISkirmishScreenCustom_WeaponChooseUpgrade:
				Movie.Pres.PlayUISound(eSUISound_MenuSelect);
				m_AdditionalState = EUISkirmishScreenCustom_WeaponUpgrade;
				UpdateData();
				break;
			case EUISkirmishScreenCustom_SaveConfig:
			case EUISkirmishScreenCustom_LoadConfig:
			case EUISkirmishScreenCustom_SetForceLevel:
			case EUISkirmishScreenCustom_SetAlertLevel:
				Movie.Pres.PlayUISound(eSUISound_MenuSelect);
				m_AdditionalState = EUISkirmishScreenCustom_None;
				m_CurrentState = eUISkirmishScreen_Base;
				UpdateData();
				break;
			case EUISkirmishScreenCustom_SelectMap:
				Movie.Pres.PlayUISound(eSUISound_MenuSelect);
				m_AdditionalState = EUISkirmishScreenCustom_None;
				m_CurrentState = eUISkirmishScreen_MapData;
				UpdateData();
				break;
			case EUISkirmishScreenCustom_AddAWCRolls:
				Movie.Pres.PlayUISound(eSUISound_MenuSelect);
				m_AdditionalState = EUISkirmishScreenCustom_None;
				m_CurrentState = eUISkirmishScreen_SoldierAbilities;
				UpdateData();
				break;
			case EUISkirmishScreenCustom_SitReps:
				Movie.Pres.PlayUISound(eSUISound_MenuSelect);
				m_AdditionalState = EUISkirmishScreenCustom_None;
				m_CurrentState = eUISkirmishScreen_MapData;
				UpdateData();
				break;
			default:
				break;
		}
	}
}

simulated function UpdateData()
{
	local XComGameState_Item equippedItem;
	super.UpdateData();

	if (m_CurrentState == eUISkirmishScreen_MAX)
	{
		switch(m_AdditionalState)
		{
			case EUISkirmishScreenCustom_CharacterPool:
				UpdateCharacterPool();
				mc.FunctionString("SetScreenSubtitle", m_strSelectCharacterPool);
				break;
			case EUISkirmishScreenCustom_WeaponUpgrade:
				UpdateDataWeaponUpgrades();
				equippedItem = m_CurrentSquad[m_SelectedSoldier].GetItemInSlot(eInvSlot_PrimaryWeapon, StartState, true);
				mc.FunctionString("SetScreenSubtitle", m_strWeaponUpgradeMenu @ equippedItem.GetMyTemplate().GetItemFriendlyName(equippedItem.ObjectID));
				break;
			case EUISkirmishScreenCustom_WeaponChooseUpgrade:
				UpdateDataChooseWeaponUpgrades();
				mc.FunctionString("SetScreenSubtitle", m_strSelectWeaponUpgrade);
				break;
			case EUISkirmishScreenCustom_SaveConfig:
				UpdateSaveConfig();
				mc.FunctionString("SetScreenSubtitle", m_strSaveConfig);
				break;
			case EUISkirmishScreenCustom_LoadConfig:
				UpdateLoadConfig();
				mc.FunctionString("SetScreenSubtitle", m_strLoadConfig);
				break;
			case EUISkirmishScreenCustom_SetForceLevel:
				UpdateSetForceOrAlertLevel();
				mc.FunctionString("SetScreenSubtitle", m_strForceLevel);
				break;
			case EUISkirmishScreenCustom_SetAlertLevel:
				UpdateSetForceOrAlertLevel();
				mc.FunctionString("SetScreenSubtitle", m_strAlertLevel);
				break;
			case EUISkirmishScreenCustom_SelectMap:
				UpdateDataSelectBaseMap();
				mc.FunctionString("SetScreenSubtitle", m_strSelectMapBase $ ": " $ BattleDataState.MapData.PlotMapName);
				break;
			case EUISkirmishScreenCustom_SelectUnitType:
				UpdateUnitTypes();
				mc.FunctionString("SetScreenSubtitle", m_strSelectUnitType);
				break;
			case EUISkirmishScreenCustom_ChosenStrWeak:
				UpdateDataChosenStrWeak();
				mc.FunctionString("SetScreenSubtitle", m_arrSubtitles[eUISkirmishScreen_SoldierAbilities]);
				break;
			case EUISkirmishScreenCustom_AddAWCRolls:
				UpdateAWCAbility();
				mc.FunctionString("SetScreenSubtitle", m_strAddAWCAbility);
				break;
			case EUISkirmishScreenCustom_SitReps:
				UpdateSitRep();
				mc.FunctionString("SetScreenSubtitle", m_strSelectSitRep);
				break;
			default:
				break;
		}

		if( List.IsSelectedNavigation() )
			List.Navigator.SelectFirstAvailable();
	}
}

defaultproperties
{
	WeapUpgrIconX=30;
	WeapUpgrIconY=465;
	WeapUpgrIconScale=30;
	WeapUpgrIconOffset=10;
}
