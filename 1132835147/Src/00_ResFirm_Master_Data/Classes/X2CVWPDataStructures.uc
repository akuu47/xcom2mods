// File: X2CVWPDataStructures.uc
// AUTHOR:  Krakah

class X2CVWPDataStructures extends Object;

struct CVWP_WepAttachment
{
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

struct CVWP_DefaultWepAttachment
{
	var() name AttachSocket;
	var() string MeshName;
	var() string IconName;
};

struct CVWP_ResourceTypeCost
{
	var() name ResourceName;
	var() int ResourceQuantity;
};

struct CVWP_AbilityBonus
{
	var() name AbilityTemplate;
	var() int MobilityBonus;
	var() float DetectionRadius;
};

struct CVWP_HideIfResearched
{
	var() bool bOnOffToggle;
	var() name HideIfResearched;
};

struct CVWP_HideIfPurchased
{
	var() bool bOnOffToggle;
	var() name HideIfPurchased;
};

struct CVWP_SetAnimationNameForAbility
{
	var() name AbilityName;
	var() name AnimSequenceName;
};

//This function checks if a mod is installed
static function bool CheckForActiveMod(string DLCName) {
    local string CurrentMod;

    foreach class'XComModOptions'.default.ActiveMods(CurrentMod) {
        if (CurrentMod == DLCName) {
            return true;
        }
    }

    return false;
}