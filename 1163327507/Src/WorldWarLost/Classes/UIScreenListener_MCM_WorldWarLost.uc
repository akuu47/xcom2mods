class UIScreenListener_MCM_WorldWarLost extends Object config(WorldWarLost_NullConfig);

`include(WorldWarLost/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(WorldWarLost/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)

var config bool CFG_CLICKED;
var config int CONFIG_VERSION;

//================================
//========Checkbox Parameters=====
//================================
var config bool bChildrenEnabled, bHalloweenEnabled, bPoliceForceEnabled, bResistanceEnabled, bClownEnabled, bMilitaryEnabled, bSportsEnabled, bHealthcareEnabled, bGovernmentEnabled, bGenericEnabled, bTLEEnabled;
var MCM_API_Checkbox ArchetypeBox1, ArchetypeBox2, ArchetypeBox3, ArchetypeBox4, ArchetypeBox5, ArchetypeBox6, ArchetypeBox7, ArchetypeBox8, ArchetypeBox9, ArchetypeBox10, ArchetypeBox11;

var localized string MOD_NAME;
var localized string ARCHETYPES_HEADER, ARCHETYPES_DESCRIPTION, ARCHETYPES_LABEL1, ARCHETYPES_LABEL2, ARCHETYPES_LABEL3, ARCHETYPES_LABEL4, ARCHETYPES_LABEL5, ARCHETYPES_LABEL6, ARCHETYPES_LABEL7, ARCHETYPES_LABEL8, ARCHETYPES_LABEL9, ARCHETYPES_LABEL10, ARCHETYPES_LABEL11;

`MCM_CH_VersionChecker(class'X2Character_Lost'.default.Version,CONFIG_VERSION)

function OnInit(UIScreen Screen)
{
	`MCM_API_Register(Screen, ClientModCallback);
}

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
	local MCM_API_SettingsPage Page;
	local MCM_API_SettingsGroup ArchetypeGroup;

	// Workaround that's needed in order to be able to "save" files.
	LoadInitialValues();

	Page = ConfigAPI.NewSettingsPage(MOD_NAME);
	Page.SetPageTitle(MOD_NAME);
	Page.SetSaveHandler(SaveButtonClicked);
	Page.SetCancelHandler(RevertButtonClicked);
	Page.EnableResetButton(ResetButtonClicked);
	
	ArchetypeGroup = Page.AddGroup('MCDT1', ARCHETYPES_HEADER);
	
	ArchetypeBox1 = ArchetypeGroup.AddCheckbox('checkbox', ARCHETYPES_LABEL1, ARCHETYPES_DESCRIPTION, bChildrenEnabled, Archetype1SaveLogger/*, optional delegate<BoolSettingHandler> ChangeHandler*/);
	ArchetypeBox2 = ArchetypeGroup.AddCheckbox('checkbox', ARCHETYPES_LABEL2, ARCHETYPES_DESCRIPTION, bHalloweenEnabled, Archetype2SaveLogger/*, optional delegate<BoolSettingHandler> ChangeHandler*/);
	ArchetypeBox3 = ArchetypeGroup.AddCheckbox('checkbox', ARCHETYPES_LABEL3, ARCHETYPES_DESCRIPTION, bPoliceForceEnabled, Archetype3SaveLogger/*, optional delegate<BoolSettingHandler> ChangeHandler*/);
	ArchetypeBox4 = ArchetypeGroup.AddCheckbox('checkbox', ARCHETYPES_LABEL4, ARCHETYPES_DESCRIPTION, bResistanceEnabled, Archetype4SaveLogger/*, optional delegate<BoolSettingHandler> ChangeHandler*/);
	ArchetypeBox5 = ArchetypeGroup.AddCheckbox('checkbox', ARCHETYPES_LABEL5, ARCHETYPES_DESCRIPTION, bClownEnabled, Archetype5SaveLogger/*, optional delegate<BoolSettingHandler> ChangeHandler*/);
	ArchetypeBox6 = ArchetypeGroup.AddCheckbox('checkbox', ARCHETYPES_LABEL6, ARCHETYPES_DESCRIPTION, bMilitaryEnabled, Archetype6SaveLogger/*, optional delegate<BoolSettingHandler> ChangeHandler*/);
	ArchetypeBox7 = ArchetypeGroup.AddCheckbox('checkbox', ARCHETYPES_LABEL7, ARCHETYPES_DESCRIPTION, bSportsEnabled, Archetype7SaveLogger/*, optional delegate<BoolSettingHandler> ChangeHandler*/);
	ArchetypeBox8 = ArchetypeGroup.AddCheckbox('checkbox', ARCHETYPES_LABEL8, ARCHETYPES_DESCRIPTION, bHealthcareEnabled, Archetype8SaveLogger/*, optional delegate<BoolSettingHandler> ChangeHandler*/);
	ArchetypeBox9 = ArchetypeGroup.AddCheckbox('checkbox', ARCHETYPES_LABEL9, ARCHETYPES_DESCRIPTION, bGovernmentEnabled, Archetype9SaveLogger/*, optional delegate<BoolSettingHandler> ChangeHandler*/);
	ArchetypeBox10 = ArchetypeGroup.AddCheckbox('checkbox', ARCHETYPES_LABEL10, ARCHETYPES_DESCRIPTION, bGenericEnabled, Archetype10SaveLogger/*, optional delegate<BoolSettingHandler> ChangeHandler*/);
	ArchetypeBox11 = ArchetypeGroup.AddCheckbox('checkbox', ARCHETYPES_LABEL11, ARCHETYPES_DESCRIPTION, bTLEEnabled, Archetype11SaveLogger/*, optional delegate<BoolSettingHandler> ChangeHandler*/);
	
	

	Page.ShowSettings();
}

`MCM_API_BasicCheckboxSaveHandler(Archetype1SaveLogger, bChildrenEnabled)
`MCM_API_BasicCheckboxSaveHandler(Archetype2SaveLogger, bHalloweenEnabled)
`MCM_API_BasicCheckboxSaveHandler(Archetype3SaveLogger, bPoliceForceEnabled)
`MCM_API_BasicCheckboxSaveHandler(Archetype4SaveLogger, bResistanceEnabled)
`MCM_API_BasicCheckboxSaveHandler(Archetype5SaveLogger, bClownEnabled)
`MCM_API_BasicCheckboxSaveHandler(Archetype6SaveLogger, bMilitaryEnabled)
`MCM_API_BasicCheckboxSaveHandler(Archetype7SaveLogger, bSportsEnabled)
`MCM_API_BasicCheckboxSaveHandler(Archetype8SaveLogger, bHealthcareEnabled)
`MCM_API_BasicCheckboxSaveHandler(Archetype9SaveLogger, bGovernmentEnabled)
`MCM_API_BasicCheckboxSaveHandler(Archetype10SaveLogger, bGenericEnabled)
`MCM_API_BasicCheckboxSaveHandler(Archetype11SaveLogger, bTLEEnabled)

`MCM_API_BasicButtonHandler(ButtonClickedHandler)
{
	CFG_CLICKED = true;
}

simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
	self.CONFIG_VERSION = `MCM_CH_GetCompositeVersion();
	self.SaveConfig();
}

simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
	CFG_CLICKED = false;
	bChildrenEnabled = class'X2Character_Lost'.default.EnableChildren;
	bHalloweenEnabled = class'X2Character_Lost'.default.EnableHalloween;
	bPoliceForceEnabled = class'X2Character_Lost'.default.EnablePoliceForce;
	bResistanceEnabled = class'X2Character_Lost'.default.EnableResistance;
	bClownEnabled = class'X2Character_Lost'.default.EnableClown;
	bMilitaryEnabled = class'X2Character_Lost'.default.EnableMilitary;
	bSportsEnabled = class'X2Character_Lost'.default.EnableSports;
	bHealthcareEnabled = class'X2Character_Lost'.default.EnableHealthcare;
	bGovernmentEnabled = class'X2Character_Lost'.default.EnableGovernment;
	bGenericEnabled = class'X2Character_Lost'.default.EnableGeneric;
	bTLEEnabled = class'X2Character_Lost'.default.EnableTLE;
	ArchetypeBox1.SetValue(bChildrenEnabled, true);
	ArchetypeBox2.SetValue(bHalloweenEnabled, true);
	ArchetypeBox3.SetValue(bPoliceForceEnabled, true);
	ArchetypeBox4.SetValue(bResistanceEnabled, true);
	ArchetypeBox5.SetValue(bClownEnabled, true);
	ArchetypeBox6.SetValue(bMilitaryEnabled, true);
	ArchetypeBox7.SetValue(bSportsEnabled, true);
	ArchetypeBox8.SetValue(bHealthcareEnabled, true);
	ArchetypeBox9.SetValue(bGovernmentEnabled, true);
	ArchetypeBox10.SetValue(bGenericEnabled, true);
	ArchetypeBox11.SetValue(bTLEEnabled, true);
}

simulated function RevertButtonClicked(MCM_API_SettingsPage Page)
{
	// Don't need to do anything since values aren't written until at save-time when you use save handlers.
}

// This shows how to either pull default values from a source config, or to use more user-defined values, gated by a version number mechanism.
simulated function LoadInitialValues()
{
	CFG_CLICKED = false; 
	bChildrenEnabled = `MCM_CH_GetValue(class'X2Character_Lost'.default.EnableChildren,bChildrenEnabled);
	bHalloweenEnabled = `MCM_CH_GetValue(class'X2Character_Lost'.default.EnableHalloween,bHalloweenEnabled);
	bPoliceForceEnabled = `MCM_CH_GetValue(class'X2Character_Lost'.default.EnablePoliceForce,bPoliceForceEnabled);
	bResistanceEnabled = `MCM_CH_GetValue(class'X2Character_Lost'.default.EnableResistance,bResistanceEnabled);
	bClownEnabled = `MCM_CH_GetValue(class'X2Character_Lost'.default.EnableClown,bClownEnabled);
	bMilitaryEnabled = `MCM_CH_GetValue(class'X2Character_Lost'.default.EnableMilitary,bMilitaryEnabled);
	bSportsEnabled = `MCM_CH_GetValue(class'X2Character_Lost'.default.EnableSports,bSportsEnabled);
	bHealthcareEnabled = `MCM_CH_GetValue(class'X2Character_Lost'.default.EnableHealthcare,bHealthcareEnabled);
	bGovernmentEnabled = `MCM_CH_GetValue(class'X2Character_Lost'.default.EnableGovernment,bGovernmentEnabled);
	bGenericEnabled = `MCM_CH_GetValue(class'X2Character_Lost'.default.EnableGeneric,bGenericEnabled);
	bTLEEnabled = `MCM_CH_GetValue(class'X2Character_Lost'.default.EnableTLE,bTLEEnabled);
}

defaultproperties
{
}