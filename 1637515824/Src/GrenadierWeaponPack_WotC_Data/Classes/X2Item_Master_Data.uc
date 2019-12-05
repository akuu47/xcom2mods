class X2Item_Master_Data extends X2Item;

//Engineering Definitions
struct EngineeringBuildDefs
{
	var name RequiredTech1;
	var name RequiredTech2;
	var int RequiredEngineeringScore;
	var int PointsToComplete;
	var int SupplyCost;
	var int AlloyCost;
	var int CrystalCost;
	var int CoreCost;
	var name SpecialItemTemplateName;
	var int SpecialItemCost;
	var int TradingPostValue;


	structdefaultproperties
	{
		RequiredTech1 = none;
		RequiredTech2 = none;
		RequiredEngineeringScore = 0;
		PointsToComplete = 0;
		SupplyCost = 0;
		AlloyCost = 0;
		CrystalCost = 0;
		CoreCost = 0;
		SpecialItemTemplateName = 0;
		SpecialItemCost = 0;
		TradingPostValue = 0;
	}
};

struct GrenadeAbilitiesDefs
{
	var name AbilityName;
	var string IconOverrideName;

	structdefaultproperties
	{
		AbilityName = none;
		IconOverrideName = "";
	}
};

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> ModGrenades;

	ModGrenades.AddItem(class'X2Item_Grenade_Frag_M67_T1'.static.CreateM67FragGrenade());
	ModGrenades.AddItem(class'X2Item_Grenade_Frag_M67_T2'.static.CreateM67FragGrenade());

	ModGrenades.AddItem(class'X2Item_Grenade_Smoke_M18_T1'.static.CreateM18SmokeGrenade());
	ModGrenades.AddItem(class'X2Item_Grenade_Smoke_M18_T2'.static.CreateM18SmokeGrenade());

	ModGrenades.AddItem(class'X2Item_Grenade_Stun_M84'.static.CreateM84StunGrenade());

	ModGrenades.AddItem(class'X2Item_Grenade_EMP_IW_T1'.static.CreateEMPIWGrenade());
	ModGrenades.AddItem(class'X2Item_Grenade_EMP_IW_T2'.static.CreateEMPIWGrenade());

	ModGrenades.AddItem(class'X2Item_Grenade_Frag_IW'.static.CreateIWFragGrenade());

	ModGrenades.AddItem(class'X2Item_Weapon_GL_M79_Standard_XCOM'.static.CreateItem_T1());
	ModGrenades.AddItem(class'X2Item_Weapon_GL_M79_Standard_XCOM'.static.CreateItem_T2());
	ModGrenades.AddItem(class'X2Item_Weapon_GL_ChinaLake_Standard_XCOM'.static.CreateItem_T1());
	ModGrenades.AddItem(class'X2Item_Weapon_GL_ChinaLake_Standard_XCOM'.static.CreateItem_T2());
	ModGrenades.AddItem(class'X2Item_Weapon_GL_Howitzer_Standard_XCOM'.static.CreateItem_T1());
	ModGrenades.AddItem(class'X2Item_Weapon_GL_Howitzer_Standard_XCOM'.static.CreateItem_T2());
	ModGrenades.AddItem(class'X2Item_Weapon_GL_MGL140_Standard_XCOM'.static.CreateItem_T1());
	ModGrenades.AddItem(class'X2Item_Weapon_GL_MGL140_Standard_XCOM'.static.CreateItem_T2());

	class'X2DownloadableContentInfo_WotC_GrenadierWeaponPack'.static.RemoveWeaponTemplateFromGame(ModGrenades);

	return ModGrenades;
}