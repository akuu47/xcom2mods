class TemplateEdits_Characters extends X2DownloadableContentInfo config(Mint_StrategyOverhaul);

	var config float SWDS_HEALTH, SWDS_ARMOR, SWDS_SHIELD;
	var config float SWDS_ROBOTIC_HEALTH, SWDS_ROBOTIC_ARMOR, SWDS_ROBOTIC_SHIELD;
	var config float SWDS_PSIONIC_HEALTH, SWDS_PSIONIC_ARMOR, SWDS_PSIONIC_SHIELD;
	var config float SWDS_ALIEN_HEALTH, SWDS_ALIEN_ARMOR, SWDS_ALIEN_SHIELD;
	var config float SWDS_MELEE_HEALTH, SWDS_MELEE_ARMOR, SWDS_MELEE_SHIELD;
	var config float SWDS_RULER_HEALTH, SWDS_RULER_ARMOR, SWDS_RULER_SHIELD;
	var config float SWDS_CHOSEN_HEALTH, SWDS_CHOSEN_ARMOR, SWDS_CHOSEN_SHIELD;
	var config float SWDS_DODGE_HEALTH, SWDS_DODGE;
	var config int	 SWDS_MIN_HEALTH;

	var config float EF_CHANCE;
	var config int EF_TICKS;
	var config float EF_CAP_HP, EF_CAP_AIM, EF_CAP_DEF, EF_CAP_DODGE, EF_CAP_MOB, EF_CAP_WILL, EF_CAP_HACK;

static event OnPostTemplatesCreated()
{
	UpdateCharacterTemplates();
}

// #######################################################################################;
// ------------------------UPDATE CHARACTERS ---------------------------------------------;
// #######################################################################################;
static function UpdateCharacterTemplates()
{
	local X2CharacterTemplateManager	CharacterTemplateManager;
    local X2CharacterTemplate			CharTemplate;
    local array<X2DataTemplate>			DataTemplates;
    local X2DataTemplate				Template, DiffTemplate;

	//Just for debugging purposes if something turns out weird
	if(class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod != 2.0)
		`Log("SWDS: Detected Beta Strike modified to " $ class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod);

    CharacterTemplateManager = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

    foreach CharacterTemplateManager.IterateTemplates(Template, None)
    {
        CharacterTemplateManager.FindDataTemplateAllDifficulties(Template.DataName, DataTemplates);
        foreach DataTemplates(DiffTemplate)
        {
            CharTemplate = X2CharacterTemplate(DiffTemplate);

			//XCOM SOLDIER - DO NOTHING, CHANGES ARE IN ITEMS
            if (CharTemplate.bIsSoldier){
				if(CharTemplate.DataName != 'SparkSoldier')
					CharTemplate.bIsResistanceHero = true;
					CharTemplate.OnStatAssignmentCompleteFn = EarthsFinestAssignStats;
				}

			//IS AN ENEMY - THIS SHOULD CATCH ALL ENEMIES
            if (CharTemplate.bIsAdvent || CharTemplate.bIsAlien)
            {
				//Easier to add abilities now
				if(CharTemplate.bIsRobotic)
					CharTemplate.Abilities.AddItem('SWDS_ReactiveArmor');
				if(CharTemplate.bIsPsionic)
					CharTemplate.Abilities.AddItem('SWDS_ForceField');
				if(CharTemplate.bIsAdvent && !CharTemplate.bIsRobotic)
					CharTemplate.Abilities.AddItem('SWDS_AdrenalineRush');
				if(CharTemplate.bIsMeleeOnly)
					CharTemplate.Abilities.AddItem('SWDS_HyperRegen');
	
				// Assign Stats
				CharTemplate.OnStatAssignmentCompleteFn = DeltaStrikeAssignStats;
			}	}	}	}


// #######################################################################################;
// ------------------------UPDATE STATS --------------------------------------------------;
// #######################################################################################;
function DeltaStrikeAssignStats(XComGameState_Unit Unit)
{
	local float HealthMod, ArmorMod, ShieldMod;
	local int DefaultMaxHP, DefaultArmor, DefaultShield, DefaultDodge;

	// Exit if Delta Strike is not enabled
	if (!`SecondWaveEnabled('DeltaStrike'))
		return;
	
	// Taken from shiremct 'Point-Based NCE'
	// Exit if the function is being called a second time from ApplyFirstTimeStatModifiers()
	if (Unit.bGotFreeFireAction)
	{
		Unit.bGotFreeFireAction = false;
		return;
	}

	`Log("SWDS: Delta Strike enabled, beginning modification of " $ Unit.GetMyTemplateName());
	
	//This is the number we're converting and modifying
	DefaultMaxHP = Unit.GetMyTemplate().GetCharacterBaseStat(eStat_HP);
	DefaultArmor = Unit.GetMyTemplate().GetCharacterBaseStat(eStat_ArmorMitigation);
	DefaultShield = Unit.GetMyTemplate().GetCharacterBaseStat(eStat_ShieldHP);
	DefaultDodge = Unit.GetMyTemplate().GetCharacterBaseStat(eStat_Dodge);
	
	HealthMod	=	default.SWDS_HEALTH;
	ArmorMod	=	default.SWDS_ARMOR;
	ShieldMod	=	default.SWDS_SHIELD;

	if(Unit.IsAlien()){
		HealthMod	*= default.SWDS_ALIEN_HEALTH;
		ArmorMod	*= default.SWDS_ALIEN_ARMOR;
		ShieldMod	*= default.SWDS_ALIEN_SHIELD;
	}

	//Robotic aliens have no shields
	if(Unit.IsRobotic()){
		HealthMod	*= default.SWDS_ROBOTIC_HEALTH;
		ArmorMod	*= default.SWDS_ROBOTIC_ARMOR;
		ShieldMod	*= default.SWDS_ROBOTIC_SHIELD;
	}

	//Psionic aliens have halved armor bonuses
	if(Unit.IsPsionic()){
		HealthMod	*= default.SWDS_PSIONIC_HEALTH;
		ArmorMod	*= default.SWDS_PSIONIC_ARMOR;
		ShieldMod	*= default.SWDS_PSIONIC_SHIELD;
	}

	//Melee aliens don't have shields and have halved armor bonuses
	if(Unit.IsMeleeOnly()){
		HealthMod	*= default.SWDS_MELEE_HEALTH;
		ArmorMod	*= default.SWDS_MELEE_ARMOR;
		ShieldMod	*= default.SWDS_MELEE_SHIELD;
	}

	//Reduce health of dodgy aliens, because...they're annoying
	if(DefaultDodge > 0)
		HealthMod	*= default.SWDS_DODGE_HEALTH;

	// Alien Ruler override
	if(Unit.GetMyTemplateName() == 'ViperKing' || Unit.GetMyTemplateName() == 'BerserkerQueen' || Unit.GetMyTemplateName() == 'ArchonKing'){
		HealthMod	= default.SWDS_RULER_HEALTH;
		ArmorMod	= default.SWDS_RULER_ARMOR;
		ShieldMod	= default.SWDS_RULER_SHIELD;
	}

	// Chosen override
	if(Unit.IsChosen()){
		HealthMod	= default.SWDS_CHOSEN_HEALTH;
		ArmorMod	= default.SWDS_CHOSEN_ARMOR;
		ShieldMod	= default.SWDS_CHOSEN_SHIELD;
	}


	//Set the stats! Health is easy, but if it's less than MINHEALTH, set to minhealth.
	if (!`SecondWaveEnabled('BetaStrike'))
		Unit.SetBaseMaxStat(eStat_HP, Max(Round(DefaultMaxHP * HealthMod), default.SWDS_MIN_HEALTH));
	else if (Unit.IsMeleeOnly())
		Unit.SetBaseMaxStat(eStat_HP, Round((DefaultMaxHP * HealthMod) / class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod));
	else
		Unit.SetBaseMaxStat(eStat_HP, Round(default.SWDS_MIN_HEALTH / class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod));

	//Rounding time, nothing should have less than 2 health innately, so armor for erryone that isn't modded further
	Unit.SetBaseMaxStat(eStat_ArmorMitigation, Round(DefaultArmor + (DefaultMaxHP * ArmorMod)));

	//Nothing innately has shield, so set the shield. Easy!
	Unit.SetBaseMaxStat(eStat_ShieldHP, DefaultShield + Round(DefaultMaxHP * ShieldMod));

	//Increase dodge if it exists
	Unit.SetBaseMaxStat(eStat_Dodge, DefaultDodge * default.SWDS_DODGE);

	`Log("SWDS:" @ Unit.GetMyTemplateName());
	`Log("SWDS: HP" @ Unit.GetBaseStat(eStat_HP) @ "Armor" @ Unit.GetBaseStat(eStat_ArmorMitigation) @ "Shield" @ Unit.GetBaseStat(eStat_ShieldHP));

	Unit.bGotFreeFireAction = true;
}

// #######################################################################################;
// -------------------------------- EARTH'S FINEST ---------------------------------------;
// #######################################################################################;

function EarthsFinestAssignStats(XComGameState_Unit Unit)
{
	local float CHANCE, Mod_HP, Mod_Mob, Mod_Aim, Mod_Def, Mod_Dge, Mod_Wll, Mod_Hck;
	local int idx;

	// Exit if Earth's Finest is not enabled
	if (!`SecondWaveEnabled('EarthsFinest'))
	{
		//Set BS+DS health modifier either way though!
		if (`SecondWaveEnabled('BetaStrike') && `SecondWaveEnabled('DeltaStrike'))
			Unit.SetBaseMaxStat(eStat_HP, 1);
		return;
	}
	
	// Taken from shiremct 'Point-Based NCE'
	// Exit if the function is being called a second time from ApplyFirstTimeStatModifiers()
	if (Unit.bGotFreeFireAction)
	{
		Unit.bGotFreeFireAction = false;
		return;
	}

	`Log("SWDS: Earth's Finest enabled, beginning modification of " $ Unit.GetMyTemplateName());
	
	//This is the chance that they'll get a statup. They roll this chance until they fail
	CHANCE		=	default.EF_CHANCE;


	//Keep rollin. Ints are truncated at the end, so HP/Mobility are hard to raise
	for(idx = 0; idx < default.EF_TICKS; ++idx)
	{
		// HP
		if(`SYNC_FRAND() < CHANCE)
			Mod_HP+= default.EF_CAP_HP / default.EF_TICKS;

		// Mobility
		if(`SYNC_FRAND() < CHANCE)
			Mod_Mob+= default.EF_CAP_MOB / default.EF_TICKS;

		// Aim
		if(`SYNC_FRAND() < CHANCE)
			Mod_Aim+= default.EF_CAP_AIM / default.EF_TICKS;

		// Defense
		if(`SYNC_FRAND() < CHANCE)
			Mod_Def+= default.EF_CAP_DEF / default.EF_TICKS;

		// Dodge
		if(`SYNC_FRAND() < CHANCE)
			Mod_Dge+= default.EF_CAP_DODGE / default.EF_TICKS;

		// Will
		if(`SYNC_FRAND() < CHANCE)
			Mod_Wll+= default.EF_CAP_WILL / default.EF_TICKS;

		// Hack
		if(`SYNC_FRAND() < CHANCE)
			Mod_Hck+= default.EF_CAP_HACK / default.EF_TICKS;

	}

	
	//Set the stats! If Beta Strike and Delta Strike are on at the same time, set HP to 1 since beta strike will cover the base stats
	if (!(`SecondWaveEnabled('BetaStrike') && `SecondWaveEnabled('DeltaStrike')))
		Unit.SetBaseMaxStat(eStat_HP, Unit.GetMyTemplate().GetCharacterBaseStat(eStat_HP) + int(Mod_HP));
	else 
		Unit.SetBaseMaxStat(eStat_HP, int((default.SWDS_MIN_HEALTH / class'X2StrategyGameRulesetDataStructures'.default.SecondWaveBetaStrikeHealthMod) + Mod_HP));
	
	//Everything else is safe though!
	Unit.SetBaseMaxStat(eStat_Offense, Unit.GetMyTemplate().GetCharacterBaseStat(eStat_Offense) + int(Mod_Aim));
	Unit.SetBaseMaxStat(eStat_Defense, Unit.GetMyTemplate().GetCharacterBaseStat(eStat_Defense) + int(Mod_Def));
	Unit.SetBaseMaxStat(eStat_Dodge, Unit.GetMyTemplate().GetCharacterBaseStat(eStat_Dodge) + int(Mod_Dge));
	Unit.SetBaseMaxStat(eStat_Mobility, Unit.GetMyTemplate().GetCharacterBaseStat(eStat_Mobility) + int(Mod_Mob));
	Unit.SetBaseMaxStat(eStat_Will, Unit.GetMyTemplate().GetCharacterBaseStat(eStat_Will) + int(Mod_Wll));
	Unit.SetBaseMaxStat(eStat_Hacking, Unit.GetMyTemplate().GetCharacterBaseStat(eStat_Hacking) + int(Mod_Hck));


	Unit.bGotFreeFireAction = true;
}