class RM_SparkUpgrade_Settings extends UIScreenListener config(SPARKUpgradesSettings);

`include(MetalOverFleshRedux/Src/ModConfigMenuAPI/MCM_API_Includes.uci)
`include(MetalOverFleshRedux/Src/ModConfigMenuAPI/MCM_API_CfgHelpers.uci)


var config int Config_Version;

var config int SHIELD_POINTS;

var config int MUSCLE_MOBILITY;

var config int AIM_POINTS;

var config int HEAVY_CHARGES;

var config int ATA_DEFENSE;

var config int UpgradeTime;

var config bool InstantUpgrades;

var config int LowSuppliesCost;

var config int MedSuppliesCost;

var config int HighSuppliesCost;

var config int CorpseCost;

var config int NanoRepair;

var config int SelfAimBonus;

var config int NanoArmour;

var config int CodexDodge;

var config int CodexMax;

event OnInit(UIScreen Screen)
{
    if (MCM_API(Screen) != none)
    {
	  `MCM_API_Register(Screen, ClientModCallback);
	}
}


simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
    local MCM_API_SettingsPage Page;
    local MCM_API_SettingsGroup Group;
    LoadSavedSettings();

	if (GameMode == eGameMode_MainMenu || GameMode == eGameMode_Strategy)
    {

		Page = ConfigAPI.NewSettingsPage("SPARK Upgrades");
		Page.SetPageTitle("SPARK Upgrades Settings");
		Page.SetSaveHandler(SaveButtonClicked);

		Group = Page.AddGroup('Group1', "General Settings");
		Group.AddLabel('label', "Alterations here need a restart of XCOM 2 to take effect", "Alterations here need a restart of XCOM 2 to take effect");
		Group.AddSlider('slider', "SPARK Shield Points", "Sets how many shield points SPARKs get when upgraded with Shields", 0, 100, 1, SHIELD_POINTS, ShieldSliderSaveHandler);
		Group.AddSlider('slider', "SPARK Muscle Mobility", "Sets how much mobility SPARKs gain when upgraded with Nanomuscle Fibre", 0, 10, 1, MUSCLE_MOBILITY, UtilitySliderSaveHandler);
		Group.AddSlider('slider', "SPARK Heavy Weapon Charges", "Sets how many additional heavy weapon charges SPARKs get when upgraded", 0, 10, 1, HEAVY_CHARGES, HeavyChargeSliderSaveHandler);
		Group.AddSlider('slider', "SPARK ATA Defense", "Sets how much defence SPARKs get when upgraded with Automated Threat Assessment", 0, 100, 1, ATA_DEFENSE, ThreatSliderSaveHandler);
		Group.AddSlider('slider', "SPARK Chip Adaptation", "Sets how much aim SPARKs get when upgraded with Chip Adaptation", 0, 100, 1, AIM_POINTS, AimSliderSaveHandler);

		Group = Page.AddGroup('Group2', "Proving Grounds Settings");
		Group.AddLabel('label', "Alterations here need a restart of XCOM 2 to take effect", "Alterations here need a restart of XCOM 2 to take effect");
		Group.AddCheckbox('checkbox', "Instant Upgrades?", "If enabled, allows SPARK Upgrades to take instanteous effect.", InstantUpgrades, InstantCheckboxSaveHandler);
		Group.AddSlider('slider', "Low Supplies Cost", "Sets how much low supply projects cost (Mayhem, PCS Adaptation)", 0, 1000, 1, LowSuppliesCost, LowSupplySliderSaveHandler);
		Group.AddSlider('slider', "Med Supplies Cost", "Sets how much medium supply projects cost (ATA, Rigging, Shields)", 0, 1000, 1, MedSuppliesCost, MedSupplySliderSaveHandler);
		Group.AddSlider('slider', "High Supplies Cost", "Sets how much high supply projects cost (Close Combat, Heavy Weapon)", 0, 1000, 1, HighSuppliesCost, HighSupplySliderSaveHandler);
		Group.AddSlider('slider', "Corpse Cost", "Sets how much corpses are required for projects that require multiple corpses (Suppression, Heavy Weapon, and ATA are not affected by this)", 0, 100, 1, CorpseCost, CorpseSliderSaveHandler);
		Group.AddSlider('slider', "Upgrade Time", "Sets how long Proving Ground Projects take", 0, 12000, 120, UpgradeTime, TimeSliderSaveHandler);
		Group.AddSlider('slider', "Nanomachine Repair", "Sets how much HP Adapative Nanomachines can repair", 0, 100, 1, NanoRepair, NanoSliderSaveHandler);

		Group = Page.AddGroup('Group3', "Utility Items Settings");
		Group.AddLabel('label', "Alterations here need a restart of XCOM 2 to take effect", "Alterations here need a restart of XCOM 2 to take effect");
		Group.AddSlider('slider', "Rounds Aim Bonus", "Sets the aim boost Self-Correcting Rounds gives", 0, 100, 1, SelfAimBonus, SelfAimSliderSaveHandler);
		Group.AddSlider('slider', "Nanoweave Bonus", "Sets how much armour Nanoweave Plate provides", 0, 100, 1, NanoArmour, NanoweaveSliderSaveHandler);
		Group.AddSlider('slider', "Codex Module Dodge", "Sets how much dodge Codex Module provides per enemy", 0, 100, 1, CodexDodge, CodexDodgeSliderSaveHandler);
		Group.AddSlider('slider', "Codex Module Max", "Sets the limit on how much dodge Codex Module can provide in total", 0, 100, 1, CodexMax, CodexMaxSliderSaveHandler);

		
		Page.ShowSettings();
	}
}


`MCM_CH_VersionChecker(class'RM_SPARKUpgrades_DefaultSettings'.default.Version, Config_Version)


static function LoadSavedSettingsInitial()
{
		`log("Saving initial settings");
		default.Config_Version = class'RM_SPARKUpgrades_DefaultSettings'.default.Version;
		default.SHIELD_POINTS = class'RM_SPARKUpgrades_DefaultSettings'.default.SHIELD_POINTS;
		default.MUSCLE_MOBILITY = class'RM_SPARKUpgrades_DefaultSettings'.default.MUSCLE_MOBILITY;
		default.HEAVY_CHARGES = class'RM_SPARKUpgrades_DefaultSettings'.default.HEAVY_CHARGES;
		default.ATA_DEFENSE = class'RM_SPARKUpgrades_DefaultSettings'.default.ATA_DEFENSE;
		default.AIM_POINTS = class'RM_SPARKUpgrades_DefaultSettings'.default.AIM_POINTS;

		default.InstantUpgrades = class'RM_SPARKUpgrades_DefaultSettings'.default.InstantUpgrades;
		default.LowSuppliesCost = class'RM_SPARKUpgrades_DefaultSettings'.default.LowSuppliesCost;
		default.MedSuppliesCost = class'RM_SPARKUpgrades_DefaultSettings'.default.MedSuppliesCost;
		default.HighSuppliesCost = class'RM_SPARKUpgrades_DefaultSettings'.default.HighSuppliesCost;
		default.CorpseCost = class'RM_SPARKUpgrades_DefaultSettings'.default.CorpseCost;
		default.UpgradeTime = class'RM_SPARKUpgrades_DefaultSettings'.default.UpgradeTime;
		default.NanoRepair = class'RM_SPARKUpgrades_DefaultSettings'.default.NanoRepair;

		default.SelfAimBonus = class'RM_SPARKUpgrades_DefaultSettings'.default.SelfAimBonus;
		default.NanoArmour = class'RM_SPARKUpgrades_DefaultSettings'.default.NanoArmour;
		default.CodexDodge = class'RM_SPARKUpgrades_DefaultSettings'.default.CodexDodge;
		default.CodexMax = class'RM_SPARKUpgrades_DefaultSettings'.default.CodexMax;

		class'RM_SparkUpgrade_Settings'.static.StaticSaveConfig();
}


simulated function LoadSavedSettings()
{
	SHIELD_POINTS = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.SHIELD_POINTS, SHIELD_POINTS);
	MUSCLE_MOBILITY = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.MUSCLE_MOBILITY, MUSCLE_MOBILITY);
	HEAVY_CHARGES = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.HEAVY_CHARGES, HEAVY_CHARGES);
	ATA_DEFENSE = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.ATA_DEFENSE, ATA_DEFENSE);
	AIM_POINTS = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.AIM_POINTS, AIM_POINTS);

	InstantUpgrades = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.InstantUpgrades, InstantUpgrades);
	LowSuppliesCost = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.LowSuppliesCost, LowSuppliesCost);
	MedSuppliesCost = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.MedSuppliesCost, MedSuppliesCost);
	HighSuppliesCost = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.HighSuppliesCost, HighSuppliesCost);
	CorpseCost = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.CorpseCost, CorpseCost);
	UpgradeTime = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.UpgradeTime, UpgradeTime);
	NanoRepair = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.NanoRepair, NanoRepair);

	SelfAimBonus = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.SelfAimBonus, SelfAimBonus);
	NanoArmour = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.NanoArmour, NanoArmour);
	CodexDodge = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.CodexDodge, CodexDodge);
	CodexMax = `MCM_CH_GETVALUE(class'RM_SPARKUpgrades_DefaultSettings'.default.CodexMax, CodexMax);
}


`MCM_API_BasicSliderSaveHandler(ShieldSliderSaveHandler, SHIELD_POINTS)
`MCM_API_BasicSliderSaveHandler(UtilitySliderSaveHandler, MUSCLE_MOBILITY)
`MCM_API_BasicSliderSaveHandler(HeavyChargeSliderSaveHandler, HEAVY_CHARGES)
`MCM_API_BasicSliderSaveHandler(ThreatSliderSaveHandler, ATA_DEFENSE)
`MCM_API_BasicSliderSaveHandler(AimSliderSaveHandler, AIM_POINTS)

`MCM_API_BasicCheckboxSaveHandler(InstantCheckboxSaveHandler, InstantUpgrades)
`MCM_API_BasicSliderSaveHandler(LowSupplySliderSaveHandler, LowSuppliesCost)
`MCM_API_BasicSliderSaveHandler(MedSupplySliderSaveHandler, MedSuppliesCost)
`MCM_API_BasicSliderSaveHandler(HighSupplySliderSaveHandler, HighSuppliesCost)
`MCM_API_BasicSliderSaveHandler(CorpseSliderSaveHandler, CorpseCost)
`MCM_API_BasicSliderSaveHandler(TimeSliderSaveHandler, UpgradeTime)
`MCM_API_BasicSliderSaveHandler(NanoSliderSaveHandler, NanoRepair)

`MCM_API_BasicSliderSaveHandler(SelfAimSliderSaveHandler, SelfAimBonus)
`MCM_API_BasicSliderSaveHandler(NanoweaveSliderSaveHandler, NanoArmour)
`MCM_API_BasicSliderSaveHandler(CodexDodgeSliderSaveHandler, CodexDodge)
`MCM_API_BasicSliderSaveHandler(CodexMaxSliderSaveHandler, CodexMax)

simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
    self.CONFIG_VERSION = `MCM_CH_GetCompositeVersion();
    self.SaveConfig();
}


defaultproperties
{
    ScreenClass = none
}