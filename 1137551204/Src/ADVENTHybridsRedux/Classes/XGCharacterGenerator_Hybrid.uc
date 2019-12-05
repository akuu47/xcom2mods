class XGCharacterGenerator_Hybrid extends XGCharacterGenerator_Skirmisher
	dependson(X2StrategyGameRulesetDataStructures);

function X2CharacterTemplate SetCharacterTemplate(name CharacterTemplateName, name ArmorName)
{
	MatchArmorTemplateForTorso = (ArmorName == '') ? 'KevlarArmor' : ArmorName;
	MatchCharacterTemplateForTorso = 'NoCharacterTemplateName'; //Force the selector to use the armor type to filter torsos

	return class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager().FindCharacterTemplate('RM_HybridSoldier');
}

function TSoldier CreateTSoldier(optional name CharacterTemplateName, optional EGender eForceGender, optional name nmCountry = '', optional int iRace = -1, optional name ArmorName)
{
	local X2SoldierClassTemplateManager ClassMgr;
	local X2SoldierClassTemplate ClassTemplate;

	kSoldier = super.CreateTSoldier('SkirmisherSoldier', eForceGender, nmCountry, iRace, ArmorName);
	SetCountry('Country_Skirmisher');
	GenerateName(kSoldier.kAppearance.iGender, kSoldier.nmCountry, kSoldier.strFirstName, kSoldier.strLastName, kSoldier.kAppearance.iRace);
	ClassMgr = class'X2SoldierClassTemplateManager'.static.GetSoldierClassTemplateManager();
	ClassTemplate = ClassMgr.FindSoldierClassTemplate('Skirmisher');
	kSoldier.strNickName = GenerateNickname(ClassTemplate, kSoldier.kAppearance.iGender);

	return kSoldier;
}

function SetAccessories(X2SimpleBodyPartFilter BodyPartFilter, name CharacterTemplateName)
{
	local X2BodyPartTemplateManager PartTemplateManager;

	PartTemplateManager = class'X2BodyPartTemplateManager'.static.GetBodyPartTemplateManager();
	
	//Turn off most customization options for Skirmishers
	RandomizeSetBodyPart(PartTemplateManager, kSoldier.kAppearance.nmPatterns, "Patterns", BodyPartFilter.FilterAny);
	RandomizeSetBodyPart(PartTemplateManager, kSoldier.kAppearance.nmWeaponPattern, "Patterns", BodyPartFilter.FilterAny);
	RandomizeSetBodyPart(PartTemplateManager, kSoldier.kAppearance.nmTattoo_LeftArm, "Tattoos", BodyPartFilter.FilterAny);
	RandomizeSetBodyPart(PartTemplateManager, kSoldier.kAppearance.nmTattoo_RightArm, "Tattoos", BodyPartFilter.FilterAny);
	SetBodyPartToFirstInArray(PartTemplateManager, kSoldier.kAppearance.nmHaircut, "Hair", BodyPartFilter.FilterAny);
	SetBodyPartToFirstInArray(PartTemplateManager, kSoldier.kAppearance.nmBeard, "Beards", BodyPartFilter.FilterAny);
	RandomizeSetBodyPart(PartTemplateManager, kSoldier.kAppearance.nmHelmet, "Helmets", BodyPartFilter.FilterAny);
	SetBodyPartToFirstInArray(PartTemplateManager, kSoldier.kAppearance.nmFacePropLower, "FacePropsLower", BodyPartFilter.FilterAny);
	SetBodyPartToFirstInArray(PartTemplateManager, kSoldier.kAppearance.nmFacePropUpper, "FacePropsUpper", BodyPartFilter.FilterAny);
	
	// Randomly choose a Skirmisher scar
	RandomizeSetBodyPart(PartTemplateManager, kSoldier.kAppearance.nmScars, "Scars", BodyPartFilter.FilterByCharacter);
}

function SetArmorTints(X2CharacterTemplate CharacterTemplate)
{
	super.SetArmorTints(CharacterTemplate);

	kSoldier.kAppearance.iArmorTint = default.PrimaryArmorColors[`SYNC_RAND(default.PrimaryArmorColors.Length)];
	kSoldier.kAppearance.iArmorTintSecondary = default.SecondaryArmorColors[`SYNC_RAND(default.SecondaryArmorColors.Length)];
}

function SetVoice(name CharacterTemplateName, name CountryName)
{
	if (IsSoldier(CharacterTemplateName))
	{
		kSoldier.kAppearance.nmVoice = GetVoiceFromCountryAndGenderAndCharacter(CountryName, kSoldier.kAppearance.iGender, CharacterTemplateName);

		if (kSoldier.kAppearance.nmVoice == '')
		{
			if (kSoldier.kAppearance.iGender == eGender_Male)
			{
				kSoldier.kAppearance.nmVoice = 'HybridMaleVoice1_Localized';
			}
			else
			{
				kSoldier.kAppearance.nmVoice = 'HybridFemaleVoice1_Localized';
			}
		}
	}
}