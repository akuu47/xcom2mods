//---------------------------------------------------------------------------------------
//  FILE:    TemplateEdits_Weapons.uc
//  DEPRECATED TEMPLATE EDITOR that works fine but is ugly         
//---------------------------------------------------------------------------------------

class TemplateEdits_Weapons extends X2DownloadableContentInfo config(Mint_StrategyOverhaul);
 
var config int								WEAPON_RANGE_CV, WEAPON_RANGE_MG, WEAPON_RANGE_BM;
var config int								WEAPON_RANGE_PENALTY_SHORT, WEAPON_RANGE_BONUS_LONG;
var config int								RIFLE_AIM, RIFLE_CRIT, RIFLE_CLIP, RIFLE_PIERCE, RIFLE_SHRED;
var config int								SHOTGUN_AIM, SHOTGUN_CRIT, SHOTGUN_CLIP, SHOTGUN_PIERCE, SHOTGUN_SHRED;
var config int								SNIPER_AIM, SNIPER_CRIT, SNIPER_CLIP, SNIPER_PIERCE, SNIPER_SHRED;
var config int								CANNON_AIM, CANNON_CRIT, CANNON_CLIP, CANNON_PIERCE, CANNON_SHRED;
var config int								BULLPUP_AIM, BULLPUP_CRIT, BULLPUP_CLIP, BULLPUP_PIERCE, BULLPUP_SHRED;
var config int								VEKTOR_AIM, VEKTOR_CRIT, VEKTOR_CLIP, VEKTOR_PIERCE, VEKTOR_SHRED;
var config bool								UPDATE_ALL_WEAPONS;
var config bool								UPDATE_ALL_STATS;
var config bool								ALL_SECONDARY_PERKS;

static event OnPostTemplatesCreated()
{
	local X2ItemTemplateManager				ItemTemplateManager;
	local X2WeaponTemplate					WeaponTemplate, Template;
	local array<X2WeaponTemplate>			WeaponTemplates;
	local array<X2DataTemplate>				TemplateAllDifficulties;
	local X2DataTemplate					DifficultyTemplate;
		
	local name								WeaponCat; 
	local name								WeaponTier;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	WeaponTemplates = ItemTemplateManager.GetAllWeaponTemplates();

	if(default.UPDATE_ALL_WEAPONS)
	{
		// Iterate through every weapon type and update accordingly
		foreach WeaponTemplates(WeaponTemplate)
		{
			WeaponCat = WeaponTemplate.WeaponCat;
			WeaponTier = WeaponTemplate.WeaponTech;

			ItemTemplateManager.FindDataTemplateAllDifficulties(WeaponTemplate.DataName, TemplateAllDifficulties);
 	
			foreach TemplateAllDifficulties(DifficultyTemplate)
			{
				Template = X2WeaponTemplate(DifficultyTemplate);

				if(Template.EquipSound == "")
				{
					//`Log("Found something that's likely an alien weapon. Skipping...");
					continue;
				}

				switch(WeaponCat)
				{
					//BULLPUPS
					case 'bullpup':	
						Template.Abilities.AddItem('Marauder_Mint');
						Template.Abilities.AddItem('WeaponEffect_Light');

						if(default.UPDATE_ALL_STATS == true)
						{
							if(WeaponTier == 'conventional')	
								Template.iRange = default.WEAPON_RANGE_CV - default.WEAPON_RANGE_PENALTY_SHORT;
							else if (WeaponTier == 'magnetic')	
								Template.iRange = default.WEAPON_RANGE_MG - default.WEAPON_RANGE_PENALTY_SHORT;
							else if (WeaponTier == 'beam')
								Template.iRange = default.WEAPON_RANGE_BM - default.WEAPON_RANGE_PENALTY_SHORT;

							Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.MEDIUM_CONVENTIONAL_RANGE;

							Template.iClipSize = default.BULLPUP_CLIP;
							Template.CritChance = default.BULLPUP_CRIT;
							Template.Aim = default.BULLPUP_AIM;
							Template.BaseDamage.Pierce = default.BULLPUP_PIERCE;
							Template.BaseDamage.Shred = default.BULLPUP_SHRED;

							//Only update labels if they're not zero
							if(default.BULLPUP_SHRED != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,,  default.BULLPUP_SHRED);
							if(default.BULLPUP_PIERCE != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel,, default.BULLPUP_PIERCE);
							if(default.BULLPUP_AIM != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,, default.BULLPUP_AIM);
	
							Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, 1);
						}
						break;

					//VEKTOR RIFLES
					case 'vektor_rifle':
						Template.Abilities.AddItem('DepthPerception');

						if(default.UPDATE_ALL_STATS == true)
						{
							if(WeaponTier == 'conventional')	
								Template.iRange = default.WEAPON_RANGE_CV + default.WEAPON_RANGE_BONUS_LONG;
							else if (WeaponTier == 'magnetic')	
								Template.iRange = default.WEAPON_RANGE_MG + default.WEAPON_RANGE_BONUS_LONG;
							else if (WeaponTier == 'beam')
								Template.iRange = default.WEAPON_RANGE_BM + default.WEAPON_RANGE_BONUS_LONG;

							Template.iClipSize = default.VEKTOR_CLIP;
							Template.CritChance = default.VEKTOR_CRIT;
							Template.Aim = default.VEKTOR_AIM;
							Template.BaseDamage.Pierce = default.VEKTOR_PIERCE;
							Template.BaseDamage.Shred = default.VEKTOR_SHRED;
							
							if(default.VEKTOR_SHRED != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,,  default.VEKTOR_SHRED);
							if(default.VEKTOR_PIERCE != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel,, default.VEKTOR_PIERCE);
							if(default.VEKTOR_AIM != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,, default.VEKTOR_AIM);
						}
						break;
					//RIFLES
					case 'rifle':
						//Check if it's the boltcaster
						if(Template.iClipSize == 1)
							break; // Don't do anything for the moment?
						
						//Check if it's a SMG
						if(Template.iClipSize < 4){
							//It's probably already statted out about right anyways
							Template.Abilities.AddItem('HitAndRun');
							break;
						}
						
						//We're fairly sure this is a regular rifle at this point?
						
						Template.Abilities.AddItem('HailofBullets_Mint');
					
						if(default.UPDATE_ALL_STATS == true)
						{
							Template.iClipSize = default.RIFLE_CLIP;
							Template.CritChance = default.RIFLE_CRIT;
							Template.Aim = default.RIFLE_AIM;
							Template.BaseDamage.Pierce = default.RIFLE_PIERCE;
							Template.BaseDamage.Shred = default.RIFLE_SHRED;

							if(WeaponTier == 'conventional')	
								Template.iRange = default.WEAPON_RANGE_CV;
							else if (WeaponTier == 'magnetic')	
								Template.iRange = default.WEAPON_RANGE_MG;
							else if (WeaponTier == 'beam')
								Template.iRange = default.WEAPON_RANGE_BM;

							if(default.RIFLE_SHRED != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,,  default.RIFLE_SHRED);
							if(default.RIFLE_PIERCE != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel,, default.RIFLE_PIERCE);
							if(default.RIFLE_AIM != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,, default.RIFLE_AIM);
						}
						break;
					//SNIPERS
					case 'sniper_rifle':
						Template.Abilities.AddItem('WeaponEffect_Heavy');
						Template.Abilities.AddItem('Squadsight');
						Template.Abilities.AddItem('Longwatch');
						Template.Abilities.AddItem('DepthPerception');

						if(default.UPDATE_ALL_STATS == true)
						{
							Template.iRange = -1;
							Template.iClipSize = default.SNIPER_CLIP;
							Template.CritChance = default.SNIPER_CRIT;
							Template.Aim = default.SNIPER_AIM;
							Template.BaseDamage.Pierce = default.SNIPER_PIERCE;
							Template.BaseDamage.Shred = default.SNIPER_SHRED;

							if(default.SNIPER_SHRED != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,,  default.SNIPER_SHRED);
							if(default.SNIPER_PIERCE != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel,, default.SNIPER_PIERCE);
							if(default.SNIPER_AIM != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,, default.SNIPER_AIM);
						}
						break;
					//CANNONS
					case 'cannon':
						Template.Abilities.RemoveItem('StandardShot');
						Template.Abilities.AddItem('SniperStandardFire');
						Template.Abilities.AddItem('Suppression');
						Template.Abilities.AddItem('Demolition');
						Template.Abilities.AddItem('SteadyFire');
						Template.iTypicalActionCost = 2;

						if(default.UPDATE_ALL_STATS == true)
						{
							if(WeaponTier == 'conventional')	
								Template.iRange = default.WEAPON_RANGE_CV + default.WEAPON_RANGE_BONUS_LONG;
							else if (WeaponTier == 'magnetic')	
								Template.iRange = default.WEAPON_RANGE_MG + default.WEAPON_RANGE_BONUS_LONG;
							else if (WeaponTier == 'beam')
								Template.iRange = default.WEAPON_RANGE_BM + default.WEAPON_RANGE_BONUS_LONG;

							Template.iClipSize = default.CANNON_CLIP;
							Template.CritChance = default.CANNON_CRIT;
							Template.Aim = default.CANNON_AIM;
							Template.BaseDamage.Pierce = default.CANNON_PIERCE;
							Template.BaseDamage.Shred = default.CANNON_SHRED;

							if(default.CANNON_SHRED != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,,  default.CANNON_SHRED);
							if(default.CANNON_PIERCE != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel,, default.CANNON_PIERCE);
							if(default.CANNON_AIM != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,, default.CANNON_AIM);

						}
						break;
					//SHOTGUNS
					case 'shotgun':
						if(Template.iClipSize == -1)
							break;

						Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, 1);
		
						Template.Abilities.AddItem('WeaponEffect_Light');
						Template.Abilities.AddItem('Buckshot');
					
						if(default.UPDATE_ALL_STATS == true)
						{
							if(WeaponTier == 'conventional')	
								Template.iRange = default.WEAPON_RANGE_CV - default.WEAPON_RANGE_PENALTY_SHORT;
							else if (WeaponTier == 'magnetic')	
								Template.iRange = default.WEAPON_RANGE_MG - default.WEAPON_RANGE_PENALTY_SHORT;
							else if (WeaponTier == 'beam')
								Template.iRange = default.WEAPON_RANGE_BM - default.WEAPON_RANGE_PENALTY_SHORT;

							Template.iClipSize = default.SHOTGUN_CLIP;
							Template.CritChance = default.SHOTGUN_CRIT;
							Template.Aim = default.SHOTGUN_AIM;
							Template.BaseDamage.Pierce = default.SHOTGUN_PIERCE;
							Template.BaseDamage.Shred = default.SHOTGUN_SHRED;

							if(default.SHOTGUN_SHRED != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,,  default.SHOTGUN_SHRED);
							if(default.SHOTGUN_PIERCE != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel,, default.SHOTGUN_PIERCE);
							if(default.SHOTGUN_AIM != 0)
								Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,, default.SHOTGUN_AIM);
						}
						break;
					//PISTOLS
					case 'pistol':
						Template.Abilities.AddItem('PistolStandardShot');
					
						if(WeaponTier == 'conventional')	
							Template.iRange = default.WEAPON_RANGE_CV - default.WEAPON_RANGE_PENALTY_SHORT;
						else if (WeaponTier == 'magnetic')	
							Template.iRange = default.WEAPON_RANGE_MG - default.WEAPON_RANGE_PENALTY_SHORT;
						else if (WeaponTier == 'beam')
							Template.iRange = default.WEAPON_RANGE_BM - default.WEAPON_RANGE_PENALTY_SHORT;

						if(default.ALL_SECONDARY_PERKS)
						{
							switch(WeaponTier)
							{
								case 'beam':
								case 'magnetic':
									Template.Abilities.AddItem('LightningHands');
								default:
									break;
							}
						}
						break;
					//SWORDS
					case 'sword':
						Template.Abilities.AddItem('SwordSlice');

						if(default.ALL_SECONDARY_PERKS)
						{
							switch(WeaponTier)
							{
								case 'beam':
								case 'magnetic':
									Template.Abilities.AddItem('SwiftStrike');
								default:
									break;
							}
						}
						break;
					//GREMLINS
					case 'gremlin':
						Template.Abilities.AddItem('IntrusionProtocol');
						Template.Abilities.AddItem('HaywireProtocol');
						Template.Abilities.AddItem('ReverseEngineering');
						Template.Abilities.AddItem('IntrusionProtocolFix');

						switch(WeaponTier)
						{
							case 'conventional':
								Template.NumUpgradeSlots = 1;
								break;
							case 'magnetic':
								Template.NumUpgradeSlots = 2;
								break;
							case 'beam':
								Template.NumUpgradeSlots = 3;
								break;
							default:
								break;
						}
						break;
					//LAUNCHERS
					case 'grenade_launcher':
						Template.Abilities.AddItem('WeaponEffect_Heavy_Really');
						Template.Abilities.AddItem('LaunchGrenade');
						Template.Abilities.AddItem('LaunchGrenadeFix');
						Template.Abilities.AddItem('HeavyOrdnance_Mint');
						Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, -2);

						if(default.ALL_SECONDARY_PERKS)
						{
							if(WeaponTier == 'magnetic')
							{
								Template.Abilities.AddItem('BiggestBooms');
								Template.Abilities.AddItem('Launcher_MG');
							}
						}

						break;
					//RIPJACKS
					case 'wristblade':
						//if you don't specify this, it'll give your ripjacks a Reckoning for each hand, lol
						if(Template.InventorySlot == eInvSlot_SecondaryWeapon)
							Template.Abilities.AddItem('Reckoning');

						if(WeaponTier == 'beam')
							Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 0));
						break;
					
					case 'psiamp':
						if(Template.ArmoryDisplayRequirements.RequiredTechs.Length > 0)
							Template.ArmoryDisplayRequirements.RequiredTechs.Length = 0;
						break;
					// LW 2 SECONDARIES //
					case 'sawedoffshotgun':
						//Template.Abilities.AddItem('PointBlank');

						if(WeaponTier == 'magnetic' || WeaponTier == 'beam')
							Template.Abilities.AddItem('BothBarrels');
						break;

					// LW 2 SECONDARIES //
					case 'arcthrower':
						//Template.Abilities.AddItem('ArcThrowerStun');

						if(default.ALL_SECONDARY_PERKS)
						{
							switch(WeaponTier)
							{
								case 'beam':
								case 'magnetic':
									Template.Abilities.AddItem('EMPulser');
								default:
									break;
							}
						}
						break;

					// LW 2 SECONDARIES //
					case 'combatknife':
						//Template.Abilities.AddItem('KnifeFighter');

						if(WeaponTier == 'magnetic' || WeaponTier == 'beam')
							Template.Abilities.AddItem('Combatives');
						break;

					// LW 2 SECONDARIES //
					case 'holotargeter':
						//Template.Abilities.AddItem('Holotarget');

						if(default.ALL_SECONDARY_PERKS)
						{
							switch(WeaponTier)
							{
								case 'beam':
									Template.Abilities.AddItem('IndependentTracking');
								case 'magnetic':
									Template.Abilities.AddItem('RapidTargeting');
								default:
									break;
							}
						}
						break;
					default:
						break;
				}

			}
		}
	}

}