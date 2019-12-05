class RM_SPARKTechs_Helpers extends Object config(SPARKUpgradesSettings);

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

static function SetValues()
{
	local RM_SparkUpgrade_Settings Settings;

	//if(!AlreadyRan())
	//{
		Settings = new class'RM_SparkUpgrade_Settings';

		default.HEAVY_CHARGES = Settings.HEAVY_CHARGES;

		default.AIM_POINTS = Settings.AIM_POINTS;

		default.MUSCLE_MOBILITY = Settings.MUSCLE_MOBILITY;

		default.SHIELD_POINTS = Settings.SHIELD_POINTS;

		default.ATA_DEFENSE = Settings.ATA_DEFENSE;

		default.UpgradeTime = Settings.UpgradeTime;

		default.InstantUpgrades = Settings.InstantUpgrades;

		default.LowSuppliesCost = Settings.LowSuppliesCost;

		default.MedSuppliesCost = Settings.MedSuppliesCost;

		default.HighSuppliesCost = Settings.HighSuppliesCost;

		default.CorpseCost = Settings.CorpseCost;

		default.NanoRepair = Settings.NanoRepair;

		default.SelfAimBonus = Settings.SelfAimBonus;

		default.NanoArmour = Settings.NanoArmour;

		default.CodexDodge = Settings.CodexDodge;

		default.CodexMax = Settings.CodexMax;

		//`log("Mobility points are  " $ default.MUSCLE_MOBILITY $ " and aim points are " $ default.AIM_POINTS);
	//}

}

//static function bool AlreadyRan()
//{
//		local RM_SparkUpgrade_Settings Settings;
//		local RM_SPARKUpgrades_DefaultSettings DefaultSettings;

//		Settings = new class'RM_SparkUpgrade_Settings';
//		DefaultSettings = new class'RM_SPARKUpgrades_DefaultSettings';

//		if(DefaultSettings.default.VERSION <= Settings.default.Config_Version)
//		{
//			return true;
//		}

//		return false;

//}