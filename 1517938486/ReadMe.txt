Created by Iridar:
http://iridar.net/xcom2/
https://www.patreon.com/Iridar

Weapon Skin Replacer Documentation:
https://steamcommunity.com/sharedfiles/filedetails/?id=1689878874

################################################
##											####
##		INFORMATION FOR YOUR REFERENCE		####
##											####
################################################

########################################################
##													####
##	SOCKET NAMES FOR DEFAULT WEAPONS' ATTACHMENTS	####
##													####
########################################################

List of common weapon attachment sockets for reference:

	Suppressor
	Optic
	Mag
	Foregrip
	Reargrip
	Trigger
	Core_Left
	Core_Right
	Core_Teeth
	Core_Center
	AutoLoader
	Stock
	Crossbar
	HeatSink
	StockSupport

To find out which sockets are used by which attachments on what weapons, simply search for this socket in this file.

Keep in mind that mod-added weapons can use their own socket names. Visual attachments are usually added to weapons in the X2DownloadableContentInfo_ModName.uc file in the Src\..\Classes folder of the mod.

Usually you can find lines like this one:

Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_OpticB", "", 'AssaultRifle_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

The first argument is attachment socket name, then which camera angle should be used while you preview that attachment on the weapon in the armory, then skeleton mesh for that attachment, then which weapon template name this attachment applies to, then a couple of 2d images of that attachment.

################################################
##											####
##		TEMPLATE NAMES FOR DEFAULT WEAPONS	####
##											####
################################################

List of weapon templates for reference: 

Present in vanilla XCOM2:

AssaultRifle_CV
AssaultRifle_MG
AssaultRifle_BM
MilitiaRifle_CV
MilitiaRifle_MG
MilitiaRifle_BM
Pistol_CV
Pistol_MG
Pistol_BM
Shotgun_CV
Shotgun_MG
Shotgun_BM
Cannon_CV
Cannon_MG
Cannon_BM
SniperRifle_CV
SniperRifle_MG
SniperRifle_BM
Sword_CV
Sword_MG
Sword_BM
PsiAmp_CV
PsiAmp_MG
PsiAmp_BM
XComTurretM1_WPN
XComTurretM2_WPN
AssaultRifle_Central
AssaultRifle_MG_Advent
AdvCaptainM1_WPN
AdvCaptainM2_WPN
AdvCaptainM3_WPN
AdvMEC_M2_WPN
AdvMEC_M2_Shoulder_WPN
AdvMEC_M1_WPN
AdvMEC_M1_Shoulder_WPN
AdvPsiWitchM2_WPN
AdvPsiWitchM2_PsiAmp
AdvPsiWitchM3_WPN
AdvPsiWitchM3_PsiAmp
AdvShieldBearerM2_WPN
AdvShieldBearerM3_WPN
AdvStunLancerM1_WPN
AdvStunLancerM2_WPN
AdvStunLancerM3_WPN
AdvTrooperM1_WPN
AdvTrooperM2_WPN
AdvTrooperM3_WPN
AdvTurretM1_WPN
AdvShortTurretM1_WPN
AdvTurretM2_WPN
AdvTurretM3_WPN
AdvCounterOpM1_WPN
AdvCounterOpM2_WPN
AdvCounterOpM3_WPN
Andromedon_WPN
AndromedonRobot_WPN
Archon_WPN
Archon_Blazing_Pinions_WPN
Cyberus_WPN
Gatekeeper_WPN
Muton_WPN
Sectoid_WPN
Sectopod_WPN
Sectopod_Wrathcannon_WPN
PrototypeSectopod_WPN
PrototypeSectopod_Wrathcannon_WPN
Viper_WPN
Viper_Tongue_WPN
ArchonStaff
AndromedonRobot_MeleeAttack
Faceless_MeleeAoE
Muton_MeleeAttack
PsiZombie_MeleeAttack
AdvStunLancerM1_StunLance
AdvStunLancerM2_StunLance
AdvStunLancerM3_StunLance
AdvTrooperMP_WPN
AdvCaptainMP_WPN
AdvStunLancerMP_WPN
AdvShieldBearerMP_WPN
AdvMEC_MP_WPN
SectoidMP_WPN
ViperMP_WPN
MutonMP_WPN
CyberusMP_WPN
ArchonMP_WPN
AndromedonMP_WPN
SectopodMP_WPN
GatekeeperMP_WPN
PsiZombieMP_MeleeAttack
RocketLauncher
ShredderGun
Flamethrower
FlamethrowerMk2
BlasterLauncher
PlasmaBlaster
ShredstormCannon

Added in Alien Hunters DLC:

AlienHunterRifle_CV
AlienHunterRifle_MG
AlienHunterRifle_BM
AlienHunterPistol_CV
AlienHunterPistol_MB
AlienHunterPistol_BM
AlienHunterAxe_CV
AlienHunterAxe_MB
AlienHunterAxe_BM

Added in Shen's Last Gift DLC:

SparkRifle_CV
SparkRifle_MG
SparkRifle_BM

Added in WOTC:

VektorRifle_CV
VektorRifle_MG
VektorRifle_BM
Bullpup_CV
Bullpup_MG
Bullpup_BM
WristBlade_CV
WristBlade_MG
WristBlade_BM
WristBladeLeft_CV
WristBladeLeft_MG
WristBladeLeft_BM
ShardGauntlet_CV
ShardGauntlet_MG
ShardGauntlet_BM
ShardGauntletLeft_CV
ShardGauntletLeft_MG
ShardGauntletLeft_BM
Sidearm_CV
Sidearm_MG
Sidearm_BM
ChosenRifle_CV
ChosenRifle_MG
ChosenRifle_BM
ChosenRifle_T4
ChosenRifle_XCOM
ChosenShotgun_CV
ChosenShotgun_MG
ChosenShotgun_BM
ChosenShotgun_T4
ChosenShotgun_XCOM
ChosenSword_CV
ChosenSword_MG
ChosenSword_BM
ChosenSword_T4
ChosenSword_XCOM
ChosenSniperRifle_CV
ChosenSniperRifle_MG
ChosenSniperRifle_BM
ChosenSniperRifle_T4
ChosenSniperRifle_XCOM
ChosenSniperPistol_CV
ChosenSniperPistol_MG
ChosenSniperPistol_BM
ChosenSniperPistol_T4
ChosenSniperPistol_XCOM
PsionicSoldier_PsiAmp
SpectreM1_PsiAttack
SpectreM1_WPN
SpectreM2_PsiAttack
SpectreM2_WPN
AdvPurifierFlamethrower
AdvPriestM1_WPN
AdvPriestM2_WPN
AdvPriestM3_WPN
AdvPriestM1_PsiAmp
AdvPriestM2_PsiAmp
AdvPriestM3_PsiAmp
Reaper_Claymore
AdvPurifierFlamethrowerMP
AdvPriestMP_WPN
AdvPriestMP_PsiAmp
SpectreMP_PsiAttack
SpectreMP_WPN

Added in TLP:

TLE_AssaultRifle_CV
TLE_AssaultRifle_MG
TLE_AssaultRifle_BM
TLE_Cannon_CV
TLE_Cannon_MG
TLE_Cannon_BM
TLE_Pistol_CV
TLE_Pistol_MG
TLE_Pistol_BM
TLE_SniperRifle_CV
TLE_SniperRifle_MG
TLE_SniperRifle_BM
TLE_Shotgun_CV
TLE_Shotgun_MG
TLE_Shotgun_BM
TLE_Sword_CV
TLE_Sword_MG
TLE_Sword_BM


########################################################
##													####
##		MESH NAMES FOR DEFAULT WEAPONS' ATTACHMENTS	####
##													####
########################################################

List of attachment meshes for reference. Keep in mind modded weapons can use their own attachment meshes.

// #######################################################################################
// -------------------- LASER SIGHT ----------------------------------------------------
// #######################################################################################

static function SetUpCritUpgrade(out X2WeaponUpgradeTemplate Template)
{
	SetUpWeaponUpgrade(Template);

	Template.AddCritChanceModifierFn = CritUpgradeModifier;
	Template.GetBonusAmountFn = GetCritBonusAmount;

	Template.MutuallyExclusiveUpgrades.AddItem('AimBetterUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('CritUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('CritUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('CritUpgrade_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('AimUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('AimUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('AimUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('AimUpgrade_Sup');

	// Assault Rifles
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_OpticB", "", 'AssaultRifle_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_OpticB", "", 'AssaultRifle_MG', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticB", "", 'AssaultRifle_BM', , "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_OpticA", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_OpticA_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', '', "", "", 'AssaultRifle_Central', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	
	// Shotguns
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "ConvShotgun.Meshes.SM_ConvShotgun_OpticB", "", 'Shotgun_CV', , "img:///UILibrary_Common.ConvShotgun.ConvShotgun_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvShotgun_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "MagShotgun.Meshes.SM_MagShotgun_OpticB", "", 'Shotgun_MG', , "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagShotgun_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "BeamShotgun.Meshes.SM_BeamShotgun_OpticB", "", 'Shotgun_BM', , "img:///UILibrary_Common.UI_BeamShotgun.BeamShotgun_OpticA", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamShotgun_OpticA_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Sniper Rifles
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "ConvSniper.Meshes.SM_ConvSniper_OpticB", "", 'SniperRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "MagSniper.Meshes.SM_MagSniper_OpticB", "", 'SniperRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticB", "", 'SniperRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Cannons
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "ConvCannon.Meshes.SM_ConvCannon_OpticB", "", 'Cannon_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "MagCannon.Meshes.SM_MagCannon_OpticB", "", 'Cannon_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "BeamCannon.Meshes.SM_BeamCannon_OpticB", "", 'Cannon_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_OpticA", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_OpticA_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Bullpups
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_OpticB", "", 'Bullpup_CV', , "img:///UILibrary_XPACK_Common.ConvSMG_OpticB", "img:///UILibrary_XPACK_StrategyImages.ConvSMG_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "MagSMG.Meshes.SM_HOR_Mag_SMG_OpticB", "", 'Bullpup_MG', , "img:///UILibrary_XPACK_Common.MagSMG_OpticB", "img:///UILibrary_XPACK_StrategyImages.MagSMG_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "BemSMG.Meshes.SM_HOR_Bem_SMG_OpticB", "", 'Bullpup_BM', , "img:///UILibrary_XPACK_Common.BeamSMG_OpticB", "img:///UILibrary_XPACK_StrategyImages.BeamSMG_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Vektor Rifles
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_OpticB", "", 'VektorRifle_CV', , "img:///UILibrary_XPACK_Common.ConvVektor_OpticB", "img:///UILibrary_XPACK_StrategyImages.ConvVektor_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "MagReaperRifle.Meshes.SM_HOR_Mag_ReaperRifle_OpticB", "", 'VektorRifle_MG', , "img:///UILibrary_XPACK_Common.MagVektor_OpticB", "img:///UILibrary_XPACK_StrategyImages.MagVektor_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BemReaperRifle.Meshes.SM_HOR_Bem_ReaperRifle_OpticB", "", 'VektorRifle_BM', , "img:///UILibrary_XPACK_Common.BeamVektor_OpticB", "img:///UILibrary_XPACK_StrategyImages.BeamVektor_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Chosen Weapons
	Template.AddUpgradeAttachment('Optic', '', "", "", 'ChosenRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', '', "", "", 'ChosenSniperRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', '', "", "", 'ChosenShotgun_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
}

// #######################################################################################
// -------------------- SCOPE ----------------------------------------------------
// #######################################################################################

static function SetUpAimBonusUpgrade(out X2WeaponUpgradeTemplate Template)
{
	SetUpWeaponUpgrade(Template);

	Template.AddHitChanceModifierFn = AimUpgradeHitModifier;
	Template.GetBonusAmountFn = GetAimBonusAmount;

	Template.MutuallyExclusiveUpgrades.AddItem('AimUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('AimUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('AimUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('AimUpgrade_Sup');
	Template.MutuallyExclusiveUpgrades.AddItem('AimBetterUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('CritUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('CritUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('CritUpgrade_Sup');
	
	// Assault Rifles
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_OpticC", "", 'AssaultRifle_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_OpticC", "", 'AssaultRifle_MG', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_OpticC", "", 'AssaultRifle_BM', , "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', '', "", "", 'AssaultRifle_Central', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Shotguns
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "ConvShotgun.Meshes.SM_ConvShotgun_OpticC", "", 'Shotgun_CV', , "img:///UILibrary_Common.ConvShotgun.ConvShotgun_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvShotgun_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "MagShotgun.Meshes.SM_MagShotgun_OpticC", "", 'Shotgun_MG', , "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagShotgun_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "BeamShotgun.Meshes.SM_BeamShotgun_OpticC", "", 'Shotgun_BM', , "img:///UILibrary_Common.UI_BeamShotgun.BeamShotgun_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamShotgun_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	
	// Sniper Rifles
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "ConvSniper.Meshes.SM_ConvSniper_OpticC", "", 'SniperRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "MagSniper.Meshes.SM_MagSniper_OpticC", "", 'SniperRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticC", "", 'SniperRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Cannons
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "ConvCannon.Meshes.SM_ConvCannon_OpticC", "", 'Cannon_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_OpticsC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_OpticsC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "MagCannon.Meshes.SM_MagCannon_OpticC", "", 'Cannon_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_OpticC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Cannon_Optic', "BeamCannon.Meshes.SM_BeamCannon_OpticC", "", 'Cannon_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_OpticB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_OpticB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Bullpups
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_OpticC", "", 'Bullpup_CV', , "img:///UILibrary_XPACK_Common.ConvSMG_OpticC", "img:///UILibrary_XPACK_StrategyImages.ConvSMG_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "MagSMG.Meshes.SM_HOR_Mag_SMG_OpticC", "", 'Bullpup_MG', , "img:///UILibrary_XPACK_Common.MagSMG_OpticC", "img:///UILibrary_XPACK_StrategyImages.MagSMG_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "BemSMG.Meshes.SM_HOR_Bem_SMG_OpticC", "", 'Bullpup_BM', , "img:///UILibrary_XPACK_Common.BeamSMG_OpticC", "img:///UILibrary_XPACK_StrategyImages.BeamSMG_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Vektor Rifles
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_OpticC", "", 'VektorRifle_CV', , "img:///UILibrary_XPACK_Common.ConvVektor_OpticC", "img:///UILibrary_XPACK_StrategyImages.ConvVektor_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "MagReaperRifle.Meshes.SM_HOR_Mag_ReaperRifle_OpticC", "", 'VektorRifle_MG', , "img:///UILibrary_XPACK_Common.MagVektor_OpticC", "img:///UILibrary_XPACK_StrategyImages.MagVektor_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BemReaperRifle.Meshes.SM_HOR_Bem_ReaperRifle_OpticC", "", 'VektorRifle_BM', , "img:///UILibrary_XPACK_Common.BeamVektor_OpticC", "img:///UILibrary_XPACK_StrategyImages.BeamVektor_OpticC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");

	// Chosen Weapons
	Template.AddUpgradeAttachment('Optic', '', "", "", 'ChosenRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', '', "", "", 'ChosenSniperRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
	Template.AddUpgradeAttachment('Optic', '', "", "", 'ChosenShotgun_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_scope");
}

// #######################################################################################
// -------------------- EXTENDED MAGAZINE ----------------------------------------------------
// #######################################################################################

static function SetUpClipSizeBonusUpgrade(X2WeaponUpgradeTemplate Template)
{
	SetUpWeaponUpgrade(Template);

	Template.AdjustClipSizeFn = AdjustClipSize;
	Template.GetBonusAmountFn = GetClipSizeBonusAmount;

	Template.MutuallyExclusiveUpgrades.AddItem('ClipSizeUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('ClipSizeUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('ClipSizeUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('ClipSizeUpgrade_Sup');

	// Assault Rifles
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_MagB", "", 'AssaultRifle_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagB", "", 'AssaultRifle_MG', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_MagB", "", 'AssaultRifle_BM', , "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', '', "", "", 'AssaultRifle_Central', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// Shotguns
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "ConvShotgun.Meshes.SM_ConvShotgun_MagB", "", 'Shotgun_CV', , "img:///UILibrary_Common.ConvShotgun.ConvShotgun_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvShotgun_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Foregrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "ConvShotgun.Meshes.SM_ConvShotgun_ForegripB", "", 'Shotgun_CV');
	
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "MagShotgun.Meshes.SM_MagShotgun_MagB", "", 'Shotgun_MG', , "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagShotgun_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Foregrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "MagShotgun.Meshes.SM_MagShotgun_ForegripB", "", 'Shotgun_MG');
	
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "BeamShotgun.Meshes.SM_BeamShotgun_MagB", "", 'Shotgun_BM', , "img:///UILibrary_Common.UI_BeamShotgun.BeamShotgun_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamShotgun_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);

	// Sniper Rifles
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "ConvSniper.Meshes.SM_ConvSniper_MagB", "", 'SniperRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "MagSniper.Meshes.SM_MagSniper_MagB", "", 'SniperRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "BeamSniper.Meshes.SM_BeamSniper_MagB", "", 'SniperRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// Cannons
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "ConvCannon.Meshes.SM_ConvCannon_MagB", "", 'Cannon_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "MagCannon.Meshes.SM_MagCannon_MagB", "", 'Cannon_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "BeamCannon.Meshes.SM_BeamCannon_MagB", "", 'Cannon_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_MagB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// Bullpups
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_MagB", "", 'Bullpup_CV', , "img:///UILibrary_XPACK_Common.ConvSMG_MagazineB", "img:///UILibrary_XPACK_StrategyImages.ConvSMG_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "MagSMG.Meshes.SM_HOR_Mag_SMG_MagB", "", 'Bullpup_MG', , "img:///UILibrary_XPACK_Common.MagSMG_MagazineB", "img:///UILibrary_XPACK_StrategyImages.MagSMG_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "BemSMG.Meshes.SM_HOR_Bem_SMG_MagB", "", 'Bullpup_BM', , "img:///UILibrary_XPACK_Common.BeamSMG_MagazineB", "img:///UILibrary_XPACK_StrategyImages.BeamSMG_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// Vektor Rifles
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_MagB", "", 'VektorRifle_CV', , "img:///UILibrary_XPACK_Common.ConvVektor_MagazineB", "img:///UILibrary_XPACK_StrategyImages.ConvVektor_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "MagReaperRifle.Meshes.SM_HOR_Mag_ReaperRifle_MagB", "", 'VektorRifle_MG', , "img:///UILibrary_XPACK_Common.MagVektor_MagazineB", "img:///UILibrary_XPACK_StrategyImages.MagVektor_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoReloadUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "BemReaperRifle.Meshes.SM_HOR_Bem_ReaperRifle_MagB", "", 'VektorRifle_BM', , "img:///UILibrary_XPACK_Common.BeamVektor_MagazineB", "img:///UILibrary_XPACK_StrategyImages.BeamVektor_MagB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// Chosen Weapons
	Template.AddUpgradeAttachment('Mag', '', "", "", 'ChosenRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', '', "", "", 'ChosenSniperRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', '', "", "", 'ChosenShotgun_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
}

// #######################################################################################
// -------------------- AUTO LOADER ----------------------------------------------------
// #######################################################################################

static function SetUpReloadUpgrade(out X2WeaponUpgradeTemplate Template)
{
	SetUpWeaponUpgrade(Template);

	Template.FreeReloadCostFn = FreeReloadCost;
	Template.FriendlyRenameFn = Reload_FriendlyRenameAbilityDelegate;
	Template.GetBonusAmountFn = GetReloadBonusAmount;

	Template.MutuallyExclusiveUpgrades.AddItem('ReloadUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('ReloadUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('ReloadUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('ReloadUpgrade_Sup');

	// Assault Rifles
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_MagC", "", 'AssaultRifle_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_MagD", "", 'AssaultRifle_CV', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagC", "", 'AssaultRifle_MG', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_MagD", "", 'AssaultRifle_MG', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('AutoLoader', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_MagC", "", 'AssaultRifle_BM', , "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_AutoLoader", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_AutoLoader_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', '', "", "", 'AssaultRifle_Central', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	
	// Shotguns
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "ConvShotgun.Meshes.SM_ConvShotgun_MagC", "", 'Shotgun_CV', , "img:///UILibrary_Common.ConvShotgun.ConvShotgun_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvShotgun_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "ConvShotgun.Meshes.SM_ConvShotgun_MagD", "", 'Shotgun_CV', , "img:///UILibrary_Common.ConvShotgun.ConvShotgun_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvShotgun_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "MagShotgun.Meshes.SM_MagShotgun_MagC", "", 'Shotgun_MG', , "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagShotgun_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "MagShotgun.Meshes.SM_MagShotgun_MagD", "", 'Shotgun_MG', , "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagShotgun_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "BeamShotgun.Meshes.SM_BeamShotgun_MagC", "", 'Shotgun_BM', , "img:///UILibrary_Common.UI_BeamShotgun.BeamShotgun_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamShotgun_AutoLoader_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "BeamShotgun.Meshes.SM_BeamShotgun_MagD", "", 'Shotgun_BM', , "img:///UILibrary_Common.UI_BeamShotgun.BeamShotgun_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamShotgun_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);

	// Sniper Rifles
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "ConvSniper.Meshes.SM_ConvSniper_MagC", "", 'SniperRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "ConvSniper.Meshes.SM_ConvSniper_MagD", "", 'SniperRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "MagSniper.Meshes.SM_MagSniper_MagC", "", 'SniperRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "MagSniper.Meshes.SM_MagSniper_MagD", "", 'SniperRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('AutoLoader', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "BeamSniper.Meshes.SM_BeamSniper_MagC", "", 'SniperRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_AutoLoader", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_AutoLoader_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	
	// Cannons
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "ConvCannon.Meshes.SM_ConvCannon_MagC", "", 'Cannon_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "ConvCannon.Meshes.SM_ConvCannon_MagD", "", 'Cannon_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "MagCannon.Meshes.SM_MagCannon_MagC", "", 'Cannon_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_MagC", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "MagCannon.Meshes.SM_MagCannon_MagD", "", 'Cannon_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_MagD", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('AutoLoader', 'UIPawnLocation_WeaponUpgrade_Cannon_Mag', "BeamCannon.Meshes.SM_BeamCannon_MagC", "", 'Cannon_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_AutoLoader", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_AutoLoader_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// Bullpups
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_MagC", "", 'Bullpup_CV', , "img:///UILibrary_XPACK_Common.ConvSMG_MagazineC", "img:///UILibrary_XPACK_StrategyImages.ConvSMG_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_MagD", "", 'Bullpup_CV', , "img:///UILibrary_XPACK_Common.ConvSMG_MagazineD", "img:///UILibrary_XPACK_StrategyImages.ConvSMG_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "MagSMG.Meshes.SM_HOR_Mag_SMG_MagC", "", 'Bullpup_MG', , "img:///UILibrary_XPACK_Common.MagSMG_MagazineC", "img:///UILibrary_XPACK_StrategyImages.MagSMG_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "MagSMG.Meshes.SM_HOR_Mag_SMG_MagD", "", 'Bullpup_MG', , "img:///UILibrary_XPACK_Common.MagSMG_MagazineD", "img:///UILibrary_XPACK_StrategyImages.MagSMG_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Autoloader', 'UIPawnLocation_WeaponUpgrade_Shotgun_Mag', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_MagC", "", 'Bullpup_BM', , "img:///UILibrary_XPACK_Common.BeamSMG_MagazineC", "img:///UILibrary_XPACK_StrategyImages.BeamSMG_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// Vektor Rifles
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_MagC", "", 'VektorRifle_CV', , "img:///UILibrary_XPACK_Common.ConvVektor_MagazineC", "img:///UILibrary_XPACK_StrategyImages.ConvVektor_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_MagD", "", 'VektorRifle_CV', , "img:///UILibrary_XPACK_Common.ConvVektor_MagazineD", "img:///UILibrary_XPACK_StrategyImages.ConvVektor_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "MagReaperRifle.Meshes.SM_HOR_Mag_ReaperRifle_MagC", "", 'VektorRifle_MG', , "img:///UILibrary_XPACK_Common.MagVektor_MagazineC", "img:///UILibrary_XPACK_StrategyImages.MagVektor_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", NoClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('Mag', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "MagReaperRifle.Meshes.SM_HOR_Mag_ReaperRifle_MagD", "", 'VektorRifle_MG', , "img:///UILibrary_XPACK_Common.MagVektor_MagazineD", "img:///UILibrary_XPACK_StrategyImages.MagVektor_MagD_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip", ClipSizeUpgradePresent);
	Template.AddUpgradeAttachment('AutoLoader', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_MagC", "", 'VektorRifle_BM', , "img:///UILibrary_XPACK_Common.BeamVektor_MagazineC", "img:///UILibrary_XPACK_StrategyImages.BeamVektor_MagC_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");

	// Chosen Weapons
	Template.AddUpgradeAttachment('Mag', '', "", "", 'ChosenRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', '', "", "", 'ChosenSniperRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
	Template.AddUpgradeAttachment('Mag', '', "", "", 'ChosenShotgun_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_clip");
}

// #######################################################################################
// -------------------- HAIR TRIGGER ----------------------------------------------------
// #######################################################################################

static function SetUpFreeFireBonusUpgrade(out X2WeaponUpgradeTemplate Template)
{
	SetUpWeaponUpgrade(Template);

	Template.FreeFireCostFn = FreeFireCost;
	Template.GetBonusAmountFn = GetFreeFireBonusAmount;

	Template.MutuallyExclusiveUpgrades.AddItem('FreeFireUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('FreeFireUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('FreeFireUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('FreeFireUpgrade_Sup');

	// Assault Rifles
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "ConvAttachments.Meshes.SM_ConvReargripB", "", 'AssaultRifle_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_ReargripB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_ReargripB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "ConvAttachments.Meshes.SM_ConvTriggerB", "", 'AssaultRifle_CV');
	
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Mag', "MagAttachments.Meshes.SM_MagReargripB", "", 'AssaultRifle_MG', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "MagAttachments.Meshes.SM_MagTriggerB", "", 'AssaultRifle_MG');
	
	Template.AddUpgradeAttachment('Core', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Optic', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_CoreB", "", 'AssaultRifle_BM', , "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_CoreB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_CoreB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Core_Teeth', '', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_TeethA", "", 'AssaultRifle_BM', , "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_Teeth", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_Teeth_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Reargrip', '', "", "", 'AssaultRifle_Central', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
		
	// Shotguns
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "ConvAttachments.Meshes.SM_ConvReargripB", "", 'Shotgun_CV', , "img:///UILibrary_Common.ConvShotgun.ConvShotgun_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvShotgun_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "ConvAttachments.Meshes.SM_ConvTriggerB", "", 'Shotgun_CV');
	
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "MagAttachments.Meshes.SM_MagReargripB", "", 'Shotgun_MG', , "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagShotgun_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "MagAttachments.Meshes.SM_MagTriggerB", "", 'Shotgun_MG');
	
	Template.AddUpgradeAttachment('Core_Left', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "BeamShotgun.Meshes.SM_BeamShotgun_CoreB", "", 'Shotgun_BM', , "img:///UILibrary_Common.UI_BeamShotgun.BeamShotgun_CoreB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamShotgun_CoreB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Core_Right', '', "BeamShotgun.Meshes.SM_BeamShotgun_CoreB", "", 'Shotgun_BM');
	Template.AddUpgradeAttachment('Core_Teeth', '', "BeamShotgun.Meshes.SM_BeamShotgun_TeethA", "", 'Shotgun_BM', , "img:///UILibrary_Common.UI_BeamShotgun.BeamShotgun_Teeth", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamShotgun_Teeth_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	
	// Sniper Rifles
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "ConvAttachments.Meshes.SM_ConvReargripB", "", 'SniperRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "ConvAttachments.Meshes.SM_ConvTriggerB", "", 'SniperRifle_CV');
	
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Sniper_Mag', "MagSniper.Meshes.SM_MagSniper_ReargripB", "", 'SniperRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "MagAttachments.Meshes.SM_MagTriggerB", "", 'SniperRifle_MG');
	
	Template.AddUpgradeAttachment('Core', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BeamSniper.Meshes.SM_BeamSniper_CoreB", "", 'SniperRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_CoreB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_CoreB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Core_Teeth', '', "BeamSniper.Meshes.SM_BeamSniper_TeethA", "", 'SniperRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_Teeth", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_Teeth_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	// Cannons
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Cannon_Stock', "ConvCannon.Meshes.SM_ConvCannon_ReargripB", "", 'Cannon_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "ConvCannon.Meshes.SM_ConvCannon_TriggerB", "", 'Cannon_CV');
	
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Cannon_Stock', "MagCannon.Meshes.SM_MagCannon_ReargripB", "", 'Cannon_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_TriggerB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "MagCannon.Meshes.SM_MagCannon_TriggerB", "", 'Cannon_MG');
	
	Template.AddUpgradeAttachment('Core', 'UIPawnLocation_WeaponUpgrade_Cannon_Suppressor', "BeamCannon.Meshes.SM_BeamCannon_CoreB", "", 'Cannon_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_CoreB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_CoreB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Core_Center', '', "BeamCannon.Meshes.SM_BeamCannon_CoreB_Center", "", 'Cannon_BM');
	Template.AddUpgradeAttachment('Core_Teeth', '', "BeamCannon.Meshes.SM_BeamCannon_TeethA", "", 'Cannon_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_Teeth", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_Teeth_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");

	// Bullpups
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_ReargripB", "", 'Bullpup_CV', , "img:///UILibrary_XPACK_Common.ConvSMG_TriggerB", "img:///UILibrary_XPACK_StrategyImages.ConvSMG_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_TriggerB", "", 'Bullpup_CV');

	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_ReargripB", "", 'Bullpup_MG', , "img:///UILibrary_XPACK_Common.MagSMG_TriggerB", "img:///UILibrary_XPACK_StrategyImages.MagSMG_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_TriggerB", "", 'Bullpup_MG');

	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Shotgun_Optic', "BemSMG.Meshes.SM_HOR_Bem_SMG_ReargripB", "", 'Bullpup_BM', , "img:///UILibrary_XPACK_Common.BeamSMG_TriggerB", "img:///UILibrary_XPACK_StrategyImages.BeamSMG_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_TriggerB", "", 'Bullpup_BM');

	// Vektor Rifles
	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_ReargripB", "", 'VektorRifle_CV', , "img:///UILibrary_XPACK_Common.ConvVektor_TriggerB", "img:///UILibrary_XPACK_StrategyImages.ConvVektor_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_TriggerB", "", 'VektorRifle_CV');

	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_ReargripB", "", 'VektorRifle_MG', , "img:///UILibrary_XPACK_Common.MagVektor_TriggerB", "img:///UILibrary_XPACK_StrategyImages.MagVektor_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_TriggerB", "", 'VektorRifle_MG');

	Template.AddUpgradeAttachment('Reargrip', 'UIPawnLocation_WeaponUpgrade_Sniper_Optic', "BemReaperRifle.Meshes.SM_HOR_Bem_ReaperRifle_ReargripB", "", 'VektorRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_CoreB", "img:///UILibrary_XPACK_StrategyImages.BeamVektor_TriggerB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Trigger', '', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_TriggerB", "", 'VektorRifle_BM');

	// Chosen Weapons
	Template.AddUpgradeAttachment('Reargrip', '', "", "", 'ChosenRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Reargrip', '', "", "", 'ChosenSniperRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
	Template.AddUpgradeAttachment('Reargrip', '', "", "", 'ChosenShotgun_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_trigger");
}

// #######################################################################################
// -------------------- STOCK ----------------------------------------------------
// #######################################################################################

static function SetUpMissDamageUpgrade(out X2WeaponUpgradeTemplate Template)
{
	SetUpWeaponUpgrade(Template);

	Template.GetBonusAmountFn = GetDamageBonusAmount;

	Template.MutuallyExclusiveUpgrades.AddItem('MissDamageUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('MissDamageUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('MissDamageUpgrade_Sup');

	// Assault Rifles
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_StockB", "", 'AssaultRifle_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Crossbar', '', "ConvAttachments.Meshes.SM_ConvCrossbar", "", 'AssaultRifle_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_CrossbarA", , , FreeFireUpgradePresent);
	
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_StockB", "", 'AssaultRifle_MG', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Crossbar', '', "MagAttachments.Meshes.SM_MagCrossbar", "", 'AssaultRifle_MG', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_Crossbar", , , FreeFireUpgradePresent);
	
	Template.AddUpgradeAttachment('HeatSink', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Stock', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_HeatsinkB", "", 'AssaultRifle_BM', , "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_HeatsinkB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_HeatsinkB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Stock', '', "", "", 'AssaultRifle_Central', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	
	// Shotguns
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "ConvShotgun.Meshes.SM_ConvShotgun_StockB", "", 'Shotgun_CV', , "img:///UILibrary_Common.ConvShotgun.ConvShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvShotgun_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Crossbar', '', "ConvAttachments.Meshes.SM_ConvCrossbar", "", 'Shotgun_CV', , "img:///UILibrary_Common.ConvShotgun.ConvShotgun_CrossbarA", , , FreeFireUpgradePresent);
	
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "MagShotgun.Meshes.SM_MagShotgun_StockB", "", 'Shotgun_MG', , "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagShotgun_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Crossbar', '', "MagAttachments.Meshes.SM_MagCrossbar", "", 'Shotgun_MG', , "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_Crossbar", , , FreeFireUpgradePresent);
	
	Template.AddUpgradeAttachment('HeatSink', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "BeamShotgun.Meshes.SM_BeamShotgun_HeatsinkB", "", 'Shotgun_BM', , "img:///UILibrary_Common.UI_BeamShotgun.BeamShotgun_HeatsinkB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamShotgun_HeatsinkB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Sniper Rifles
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "ConvSniper.Meshes.SM_ConvSniper_StockB", "", 'SniperRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Crossbar', '', "ConvAttachments.Meshes.SM_ConvCrossbar", "", 'SniperRifle_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_CrossbarA", , , FreeFireUpgradePresent);
	
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "MagSniper.Meshes.SM_MagSniper_StockB", "", 'SniperRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Crossbar', '', "MagAttachments.Meshes.SM_MagCrossbar", "", 'SniperRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_Crossbar", , , FreeFireUpgradePresent);
	
	Template.AddUpgradeAttachment('HeatSink', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "BeamSniper.Meshes.SM_BeamSniper_HeatsinkB", "", 'SniperRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_HeatsinkB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_HeatsinkB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Cannons
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Cannon_Stock', "ConvCannon.Meshes.SM_ConvCannon_StockB", "", 'Cannon_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('StockSupport', '', "ConvCannon.Meshes.SM_ConvCannon_StockB_Support", "", 'Cannon_CV');
	
	Template.AddUpgradeAttachment('Foregrip', 'UIPawnLocation_WeaponUpgrade_Cannon_Stock', "MagCannon.Meshes.SM_MagCannon_StockB", "", 'Cannon_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_StockB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('StockSupport', '', "MagCannon.Meshes.SM_MagCannon_StockB_Support", "", 'Cannon_MG');
	
	Template.AddUpgradeAttachment('HeatSink', 'UIPawnLocation_WeaponUpgrade_Cannon_Stock', "BeamCannon.Meshes.SM_BeamCannon_HeatsinkB", "", 'Cannon_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_HeatsinkB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_HeatsinkB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Bullpups
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_StockB", "", 'Bullpup_CV', , "img:///UILibrary_XPACK_Common.ConvSMG_StockB", "img:///UILibrary_XPACK_StrategyImages.ConvSMG_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_StockB", "", 'Bullpup_MG', , "img:///UILibrary_XPACK_Common.ConvSMG_StockB", "img:///UILibrary_XPACK_StrategyImages.MagSMG_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Shotgun_Stock', "BemSMG.Meshes.SM_HOR_Bem_SMG_StockB", "", 'Bullpup_BM', , "img:///UILibrary_XPACK_Common.BeamSMG_StockB", "img:///UILibrary_XPACK_StrategyImages.BeamSMG_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Vektor Rifles
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_StockB", "", 'VektorRifle_CV', , "img:///UILibrary_XPACK_Common.ConvVektor_StockB", "img:///UILibrary_XPACK_StrategyImages.ConvVektor_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_StockB", "", 'VektorRifle_MG', , "img:///UILibrary_XPACK_Common.MagVektor_StockB", "img:///UILibrary_XPACK_StrategyImages.MagVektor_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Stock', 'UIPawnLocation_WeaponUpgrade_Sniper_Stock', "BemReaperRifle.Meshes.SM_HOR_Bem_ReaperRifle_StockB", "", 'VektorRifle_BM', , "img:///UILibrary_XPACK_Common.BeamVektor_StockB", "img:///UILibrary_XPACK_StrategyImages.BeamVektor_StockB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");

	// Chosen Weapons
	Template.AddUpgradeAttachment('Stock', '', "", "", 'ChosenRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Stock', '', "", "", 'ChosenSniperRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
	Template.AddUpgradeAttachment('Stock', '', "", "", 'ChosenShotgun_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_stock");
}

// #######################################################################################
// -------------------- SUPPRESSOR / REPEATER ----------------------------------------------------
// #######################################################################################

static function SetUpFreeKillUpgrade(out X2WeaponUpgradeTemplate Template)
{
	SetUpWeaponUpgrade(Template);

	Template.FreeKillFn = FreeKillChance;
	Template.GetBonusAmountFn = GetFreeKillBonusAmount;

	Template.MutuallyExclusiveUpgrades.AddItem('FreeKillUpgrade');
	Template.MutuallyExclusiveUpgrades.AddItem('FreeKillUpgrade_Bsc');
	Template.MutuallyExclusiveUpgrades.AddItem('FreeKillUpgrade_Adv');
	Template.MutuallyExclusiveUpgrades.AddItem('FreeKillUpgrade_Sup');
	
	// Assault Rifles
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "ConvAssaultRifle.Meshes.SM_ConvAssaultRifle_SuppressorB", "", 'AssaultRifle_CV', , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "MagAssaultRifle.Meshes.SM_MagAssaultRifle_SuppressorB", "", 'AssaultRifle_MG', , "img:///UILibrary_Common.UI_MagAssaultRifle.MagAssaultRifle_SupressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagAssaultRifle_SupressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_AssaultRifle_Suppressor', "BeamAssaultRifle.Meshes.SM_BeamAssaultRifle_SuppressorB", "", 'AssaultRifle_BM', , "img:///UILibrary_Common.UI_BeamAssaultRifle.BeamAssaultRifle_SupressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamAssaultRifle_SupressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', '', "", "", 'AssaultRifle_Central', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Shotguns
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Shotgun_Suppressor', "ConvShotgun.Meshes.SM_ConvShotgun_SuppressorB", "", 'Shotgun_CV', , "img:///UILibrary_Common.ConvShotgun.ConvShotgun_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvShotgun_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Shotgun_Suppressor', "MagShotgun.Meshes.SM_MagShotgun_SuppressorB", "", 'Shotgun_MG', , "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagShotgun_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Shotgun_Suppressor', "BeamShotgun.Meshes.SM_BeamShotgun_SuppressorB", "", 'Shotgun_BM', , "img:///UILibrary_Common.UI_BeamShotgun.BeamShotgun_SupressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamShotgun_SupressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Sniper Rifles
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "ConvSniper.Meshes.SM_ConvSniper_SuppressorB", "", 'SniperRifle_CV', , "img:///UILibrary_Common.ConvSniper.ConvSniper_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvSniper_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "MagSniper.Meshes.SM_MagSniper_SuppressorB", "", 'SniperRifle_MG', , "img:///UILibrary_Common.UI_MagSniper.MagSniper_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagSniper_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "BeamSniper.Meshes.SM_BeamSniper_SuppressorB", "", 'SniperRifle_BM', , "img:///UILibrary_Common.UI_BeamSniper.BeamSniper_SupressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamSniper_SupressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Cannons
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Cannon_Suppressor', "ConvCannon.Meshes.SM_ConvCannon_SuppressorB", "", 'Cannon_CV', , "img:///UILibrary_Common.ConvCannon.ConvCannon_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvCannon_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Cannon_Suppressor', "MagCannon.Meshes.SM_MagCannon_SuppressorB", "", 'Cannon_MG', , "img:///UILibrary_Common.UI_MagCannon.MagCannon_SuppressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.MagCannon_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Cannon_Suppressor', "BeamCannon.Meshes.SM_BeamCannon_SuppressorB", "", 'Cannon_BM', , "img:///UILibrary_Common.UI_BeamCannon.BeamCannon_SupressorB", "img:///UILibrary_StrategyImages.X2InventoryIcons.BeamCannon_SupressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Bullpups
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Shotgun_Suppressor', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_SuppressorB", "", 'Bullpup_CV', , "img:///UILibrary_XPACK_Common.ConvSMG_SuppressorB", "img:///UILibrary_XPACK_StrategyImages.ConvSMG_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Shotgun_Suppressor', "MagSMG.Meshes.SM_HOR_Mag_SMG_SuppressorB", "", 'Bullpup_MG', , "img:///UILibrary_XPACK_Common.MagSMG_SuppressorB", "img:///UILibrary_XPACK_StrategyImages.MagSMG_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Shotgun_Suppressor', "BemSMG.Meshes.SM_HOR_Bem_SMG_SuppressorB", "", 'Bullpup_BM', , "img:///UILibrary_XPACK_Common.BeamSMG_SuppressorB", "img:///UILibrary_XPACK_StrategyImages.BeamSMG_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Vektor Rifles
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_SuppressorB", "", 'VektorRifle_CV', , "img:///UILibrary_XPACK_Common.ConvVektor_SuppressorB", "img:///UILibrary_XPACK_StrategyImages.ConvVektor_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "MagReaperRifle.Meshes.SM_HOR_Mag_ReaperRifle_SuppressorB", "", 'VektorRifle_MG', , "img:///UILibrary_XPACK_Common.MagVektor_SuppressorB", "img:///UILibrary_XPACK_StrategyImages.MagVektor_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', 'UIPawnLocation_WeaponUpgrade_Sniper_Suppressor', "BemReaperRifle.Meshes.SM_HOR_Bem_ReaperRifle_SuppressorB", "", 'VektorRifle_BM', , "img:///UILibrary_XPACK_Common.BeamVektor_SuppressorB", "img:///UILibrary_XPACK_StrategyImages.BeamVektor_SuppressorB_inv", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");

	// Chosen Weapons
	Template.AddUpgradeAttachment('Suppressor', '', "", "", 'ChosenRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', '', "", "", 'ChosenSniperRifle_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
	Template.AddUpgradeAttachment('Suppressor', '', "", "", 'ChosenShotgun_XCOM', , "", "", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponIcon_barrel");
}