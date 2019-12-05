class X2Item_MutonEliteGrenade extends X2Item config(MutonElite);

var config WeaponDamageValue MUTONELITE_GRENADE_BASEDAMAGE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Grenades;

	Grenades.AddItem(CreateMutonEliteGrenade());

	return Grenades;
}


static function X2DataTemplate CreateMutonEliteGrenade()
{
	local X2GrenadeTemplate Template;
	local X2Effect_ApplyWeaponDamage WeaponDamageEffect;

	`CREATE_X2TEMPLATE(class'X2GrenadeTemplate', Template, 'MutonEliteGrenade');

	Template.strImage = "img:///UILibrary_StrategyImages.InventoryIcons.Inv_AlienGrenade";
	Template.EquipSound = "StrategyUI_Grenade_Equip";
	Template.BaseDamage = default.MUTONELITE_GRENADE_BASEDAMAGE;
	Template.iEnvironmentDamage = class'X2Item_DefaultGrenades'.default.ALIENGRENADE_IENVIRONMENTDAMAGE;
	Template.iRange = 12;
	Template.iRadius = 4;
	Template.iClipSize = 1;
	Template.iSoundRange = class'X2Item_DefaultGrenades'.default.GRENADE_SOUND_RANGE;
	Template.DamageTypeTemplateName = 'Explosion';
	
	Template.Abilities.AddItem('ThrowGrenade');
	Template.Abilities.AddItem('GrenadeFuse');

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bExplosiveDamage = true;
	Template.ThrownGrenadeEffects.AddItem(WeaponDamageEffect);
	Template.LaunchedGrenadeEffects.AddItem(WeaponDamageEffect);
	
	Template.GameArchetype = "WP_Grenade_Alien.WP_Grenade_Alien";

	Template.iPhysicsImpulse = 10;

	Template.CanBeBuilt = false;
	Template.TradingPostValue = 50;

	return Template;
}
