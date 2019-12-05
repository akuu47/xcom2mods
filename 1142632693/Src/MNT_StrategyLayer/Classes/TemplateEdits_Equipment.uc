class TemplateEdits_Equipment extends X2DownloadableContentInfo config(Mint_StrategyOverhaul);

struct WeaponBaseStatChanges
{
    var name WeaponCat;
    var bool Override;
	var bool DamageBonusesScaleWithTech;
    var WeaponDamageValue BaseDamage;
    var int AimBonus;
    var int CritBonus;
    var int ClipSizeBonus;
    var int SoundRangeBonus;
    var int EnvironmentDamageBonus;
    var int MaxRange;
    var string RangeAccuracyTableName;
    var int NumUpgradeSlots;
    var int TypicalActionCost;
    var array<name> RemoveAbilities;
    var array<name> AddAbilities;
    var int MobilityBonusToDisplay;
};
 
var config array<WeaponBaseStatChanges> WeaponBaseChanges;
var config bool ModifyAllWeapons;
var config bool KeepNewWeaponCategories;

static event OnPostTemplatesCreated()
{
	if(default.ModifyAllWeapons)
		UpdateWeaponTemplates();

	//the replaced abilities shouldn't do anything if no second wave options are enabled!
	UpdateArmorTemplates();
	UpdateBaseArmorTemplates();
}

//Courtesy of Kyuubicle! I'm sorry for mangling your code ;_;
static function UpdateWeaponTemplates()
{
    local X2ItemTemplateManager             ItemTemplateManager;
    local X2WeaponTemplate                  WeaponTemplate, Template;
    local array<X2WeaponTemplate>           WeaponTemplates;
    local array<X2DataTemplate>             TemplateAllDifficulties;
    local X2DataTemplate                    DifficultyTemplate;
    local name                              TemplateName;
    local WeaponBaseStatChanges             WeaponChanges;
	local int								TechFactor, i;
 
    ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
 
    WeaponTemplates = ItemTemplateManager.GetAllWeaponTemplates();
    foreach WeaponTemplates(WeaponTemplate)
    {
        ItemTemplateManager.FindDataTemplateAllDifficulties(WeaponTemplate.DataName, TemplateAllDifficulties);
       
        // Okay, time to start modifying the weapons already
        foreach TemplateAllDifficulties(DifficultyTemplate)
        {
            Template = X2WeaponTemplate(DifficultyTemplate);
           
            //Reapers can equip the Boltcaster but not rifles
            //And Skirmishers can equip the Boltcaster and Rifle
            //Neither can equip SMGs, so... gotta change the weapon categories a bit.
            if(Template.WeaponCat == 'rifle' && Template.iClipSize == 1 && Template.bCanBeDodged == false)
            {
                Template.WeaponCat = 'boltcaster';
            }
            else if (Template.WeaponCat == 'rifle' && Template.iClipSize < 4)
            {
                //Extra testing.
                If(Template.Abilities.Find('SMG_CV_StatBonus') != INDEX_NONE || Template.Abilities.Find('SMG_MG_StatBonus') != INDEX_NONE || Template.Abilities.Find('SMG_BM_StatBonus') != INDEX_NONE)
                    Template.WeaponCat = 'smg';
            }
 
            foreach default.WeaponBaseChanges(WeaponChanges)
            {
                if(Template.WeaponCat != WeaponChanges.WeaponCat)
                {
                    //`log("Template's WeaponCat = " @ Template.WeaponCat);
                    //`log("WeaponChanges's WeaponCat = " @ WeaponChanges.WeaponCat);
                    continue;
                }
                
				//If there is no equip sound, it's likely a non-player weapon, so skip it.
                else if (Template.EquipSound != "")
                {
                    //`Log("Found a compatible WeaponChanges Template!");
 
 					TechFactor = 1;

					//If it scales with tech, adjust tech factor
					if(WeaponChanges.DamageBonusesScaleWithTech)
					{
						switch(Template.WeaponTech)
						{
							case 'coil':
							case 'beam':
								TechFactor = 3;
								break;
							case 'laser':
							case 'magnetic':
								TechFactor = 2;
								break;
							case 'conventional':
							default:
								TechFactor = 1;
								break;
						}

					}

                    if (!WeaponChanges.Override)
                    {
						//Modify that many times
						for(i = 0; i < TechFactor; ++i){
							Template.BaseDamage.Damage += WeaponChanges.BaseDamage.Damage;
							Template.BaseDamage.Spread += WeaponChanges.BaseDamage.Spread;
							Template.BaseDamage.PlusOne += WeaponChanges.BaseDamage.PlusOne;
							Template.BaseDamage.Crit += WeaponChanges.BaseDamage.Crit;
							Template.BaseDamage.Pierce += WeaponChanges.BaseDamage.Pierce;
							Template.BaseDamage.Shred += WeaponChanges.BaseDamage.Shred;
						}

						Template.Aim += WeaponChanges.AimBonus;
						Template.CritChance += WeaponChanges.CritBonus;
						Template.iClipSize += WeaponChanges.ClipSizeBonus;
						Template.iSoundRange += WeaponChanges.SoundRangeBonus;
						Template.iEnvironmentDamage += WeaponChanges.EnvironmentDamageBonus;
                    }
                    else
                    {
                        Template.Aim = WeaponChanges.AimBonus;
                        Template.CritChance = WeaponChanges.CritBonus;
                        Template.iClipSize = WeaponChanges.ClipSizeBonus;
                        Template.iSoundRange = WeaponChanges.SoundRangeBonus;
                        Template.iEnvironmentDamage = WeaponChanges.EnvironmentDamageBonus;
 
						for(i = 0; i < TechFactor; ++i){
							Template.BaseDamage.Damage = WeaponChanges.BaseDamage.Damage;
							Template.BaseDamage.Spread = WeaponChanges.BaseDamage.Spread;
							Template.BaseDamage.PlusOne = WeaponChanges.BaseDamage.PlusOne;
							Template.BaseDamage.Crit = WeaponChanges.BaseDamage.Crit;
							Template.BaseDamage.Pierce = WeaponChanges.BaseDamage.Pierce;
							Template.BaseDamage.Shred = WeaponChanges.BaseDamage.Shred;
						}
                    }
 
                    if(WeaponChanges.NumUpgradeSlots > 0)
                        Template.NumUpgradeSlots = WeaponChanges.NumUpgradeSlots;
                    if(WeaponChanges.TypicalActionCost > 0)
                        Template.iTypicalActionCost = WeaponChanges.TypicalActionCost;
                    if(WeaponChanges.MaxRange > 0)
                        Template.iRange = WeaponChanges.MaxRange;
 
                    if(WeaponChanges.RangeAccuracyTableName != "")
                    {
						switch(WeaponChanges.RangeAccuracyTableName)
						{
							case "medium":
								if(Template.WeaponTech == 'conventional')
									Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_CONVENTIONAL_RANGE;
								else if (Template.WeaponTech == 'magnetic')
									Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_MAGNETIC_RANGE;
								else if (Template.WeaponTech == 'beam')
									Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_BEAM_RANGE;
								break;
							case "short":
							    if(Template.WeaponTech == 'conventional')
									Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
								else if (Template.WeaponTech == 'magnetic')
									Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_MAGNETIC_RANGE;
								else if (Template.WeaponTech == 'beam')
									Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_BEAM_RANGE;
								break;
							case "long":
								if(Template.WeaponTech == 'conventional')
									Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_CONVENTIONAL_RANGE;
								else if (Template.WeaponTech == 'magnetic')
									Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_MAGNETIC_RANGE;
								else if (Template.WeaponTech == 'beam')
									Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.LONG_BEAM_RANGE;
								break;
							case "vektor":
								if(Template.WeaponTech == 'conventional')
									Template.RangeAccuracy = class'X2Item_XpackWeapons'.default.VEKTOR_CONVENTIONAL_RANGE;
								else if (Template.WeaponTech == 'magnetic')
									Template.RangeAccuracy = class'X2Item_XpackWeapons'.default.VEKTOR_MAGNETIC_RANGE;
								else if (Template.WeaponTech == 'beam')
									Template.RangeAccuracy = class'X2Item_XpackWeapons'.default.VEKTOR_BEAM_RANGE;
								break;
							default:
								`LOG("MNT: Invalid weapon range table" @ WeaponChanges.RangeAccuracyTableName @ ", no edits made.");
						}

                    }
 
                    //Update UI elements if needed so far.
                    if(Template.BaseDamage.Pierce != 0)
                        Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel,, Template.BaseDamage.Pierce);
                    if(Template.BaseDamage.Shred != 0)
                        Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,, Template.BaseDamage.Shred);
                   
                    //Remove abilities here
                    foreach WeaponChanges.RemoveAbilities(TemplateName)
                    {
                        Template.Abilities.RemoveItem(TemplateName);
                    }
 
                    //Add abilities here
                    foreach WeaponChanges.AddAbilities(TemplateName)
                    {
                        Template.Abilities.AddItem(TemplateName);
                    }
 
                    if(WeaponChanges.MobilityBonusToDisplay != 0)
                        Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, WeaponChanges.MobilityBonusToDisplay);
 
                    if(default.KeepNewWeaponCategories == false && Template.WeaponCat == 'boltcaster')
                        Template.WeaponCat = 'rifle';
                    else if(default.KeepNewWeaponCategories == false && Template.WeaponCat == 'smg')
                        Template.WeaponCat = 'rifle';

					//GREMLIN EXCEPTION HERE - just granting scaling upgrade slots
					if(Template.WeaponCat == 'gremlin'){
						Template.NumUpgradeSlots = 0;

						for(i = 0; i < TechFactor; ++i)
							Template.NumUpgradeSlots += WeaponChanges.NumUpgradeSlots;
					}

					//RIPJACK EXCEPTION HERE - otherwise we get duplicate abilities, one for each arm
					if(Template.WeaponCat == 'wristblade' && Template.InventorySlot != eInvSlot_SecondaryWeapon){
						foreach WeaponChanges.AddAbilities(TemplateName)
						{
							Template.Abilities.RemoveItem(TemplateName);
						}
					}
                }
                else
                {
                    //`log("Template.WeaponTech = " @ Template.WeaponTech);
                    //`log("WeaponChanges.WeaponTech = " @ WeaponChanges.WeaponTech);
                    //`log("WeaponChanges.ApplyToAllTechLevels = " @ WeaponChanges.ApplyToAllTechLevels);
                    continue;
                }		}		}		}		}


// Modify every armor statup ability ?.?
static function UpdateArmorTemplates()
{
    local array<X2AbilityTemplate>          TemplateAllDifficulties;
    local X2AbilityTemplateManager			AbilityTemplateManager;
	local X2AbilityTemplate                 Template;
	local array<name>						TemplateNames;
	local name                              TemplateName;
	local array<StatChange>					ArmorStatChanges;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	local X2Effect_ArmorStatChange			NewArmorEffect;
	local int								HPMod, ArmorMod, ShieldMod;

	AbilityTemplateManager	= class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplateManager.GetTemplateNames(TemplateNames);

	foreach TemplateNames(TemplateName)
    {
		//If the ability has armor stats as the last 10 characters, should be a statup ability
		if(name(Right(TemplateName,10)) != 'ArmorStats')
			continue;

		AbilityTemplateManager.FindAbilityTemplateAllDifficulties(TemplateName, TemplateAllDifficulties);
		foreach TemplateAllDifficulties(Template)
		{
			//Specifically, it should only have a single PersistentStatChange Effect as a target effect		
			PersistentStatChangeEffect = X2Effect_PersistentStatChange(Template.AbilityTargetEffects[0]);

			//Grab all the stat modifications that are being used in this effect
			ArmorStatChanges = PersistentStatChangeEffect.m_aStatChanges;
			
			//Create a new ArmorStatChangeEffect (that converts for second wave options within)
			NewArmorEffect = new class'X2Effect_ArmorStatChange';
			NewArmorEffect.BuildPersistentEffect(1, true, false, false);
			NewArmorEffect.SetStatArray(ArmorStatChanges);

			
			HPMod = Template.GetUIStatMarkUP(eStat_HP);
			ArmorMod = Template.GetUIStatMarkUp(eStat_ArmorMitigation) + Round(HPMod * class'X2Effect_ArmorStatChange'.default.ArmorModifier);
			ShieldMod = Round(HPMod * class'X2Effect_ArmorStatChange'.default.ShieldModifier);

			Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, 0, false, IsDeltaStrikeOn);
			Template.SetUIStatMarkup(class'XLocalizedData'.default.ArmorLabel, eStat_ArmorMitigation, ArmorMod, true, IsDeltaStrikeOn);
			Template.SetUIStatMarkup("Shields", eStat_ShieldHP, ShieldMod, true, IsDeltaStrikeOn);
			

			//Zero out the old effects
			Template.AbilityTargetEffects.Length = 0;
			Template.AddTargetEffect(NewArmorEffect);
		}		}		}



// Update Kevlar/Base SPARK
static function UpdateBaseArmorTemplates()
{
	local X2ItemTemplateManager			ArmorTemplateManager;
    local X2ArmorTemplate				Template;
    local array<X2DataTemplate>			DataTemplates;
    local X2DataTemplate				DiffTemplate;

    ArmorTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

    ArmorTemplateManager.FindDataTemplateAllDifficulties('KevlarArmor', DataTemplates);
    foreach DataTemplates(DiffTemplate)
    {
		Template = X2ArmorTemplate(DiffTemplate);
		Template.Abilities.AddItem('SWDS_ArmorStats_Kevlar');
	}

	ArmorTemplateManager.FindDataTemplateAllDifficulties('ReaperArmor', DataTemplates);
    foreach DataTemplates(DiffTemplate)
    {
		Template = X2ArmorTemplate(DiffTemplate);
		Template.Abilities.AddItem('SWDS_ArmorStats_Kevlar');
	}

	ArmorTemplateManager.FindDataTemplateAllDifficulties('SkirmisherArmor', DataTemplates);
    foreach DataTemplates(DiffTemplate)
    {
		Template = X2ArmorTemplate(DiffTemplate);
		Template.Abilities.AddItem('SWDS_ArmorStats_Kevlar');
	}

	ArmorTemplateManager.FindDataTemplateAllDifficulties('TemplarArmor', DataTemplates);
    foreach DataTemplates(DiffTemplate)
    {
		Template = X2ArmorTemplate(DiffTemplate);
		Template.Abilities.AddItem('SWDS_ArmorStats_Kevlar');
	}

	ArmorTemplateManager.FindDataTemplateAllDifficulties('SparkArmor', DataTemplates);
    foreach DataTemplates(DiffTemplate)
    {
		Template = X2ArmorTemplate(DiffTemplate);
		Template.Abilities.AddItem('SWDS_ArmorStats_SPARK');
	}

}

static function bool IsDeltaStrikeOn(){
	return `SecondWaveEnabled('DeltaStrike');
}