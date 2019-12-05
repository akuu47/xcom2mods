class TemplateEdits_Facilities extends X2DownloadableContentInfo;
 
static event OnPostTemplatesCreated()
{
	local X2StrategyElementTemplateManager	StrategyElementTemplateManager;
	local X2FacilityTemplate				Facility;
	local array<X2FacilityTemplate>			FacilityTemplates;
	local X2SoldierAbilityUnlockTemplate	Template;
	local array<X2StrategyElementTemplate>	UnlockTemplates;
	local X2StrategyElementTemplate			UnlockTemplate;
	local Name								TemplateName; 
	local bool								LWSecondaries;
	local StaffSlotDefinition				StaffSlotDef;

	StrategyElementTemplateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	UnlockTemplates = StrategyElementTemplateManager.GetAllTemplatesOfClass(class'X2SoldierAbilityUnlockTemplate');
	LWSecondaries = LWSecondariesPresent();
		
	foreach UnlockTemplates(UnlockTemplate){
		Template = X2SoldierAbilityUnlockTemplate(UnlockTemplate);
		TemplateName = Template.DataName;

		//remove all the base game unlocks
		switch(TemplateName)
		{
			case 'BiggestBoomsUnlock':
			case 'HuntersInstinctUnlock':
			case 'CoolUnderPressureUnlock':
			case 'HitWhereItHurtsUnlock':
			case 'ParkourUnlock':
			case 'MeditationPreparationUnlock':
			case 'InfiltrationUnlock':
				Template.Requirements.RequiredTechs.AddItem('NullTech');
				break;
			default:
				break;
		}
	}

	FindFacilityTemplateAllDifficulties('OfficerTrainingSchool', FacilityTemplates, StrategyElementTemplateManager);
	foreach FacilityTemplates(Facility)
	{
		StaffSlotDef.StaffSlotTemplateName = 'GTSStaffSlot';
		Facility.StaffSlotDefs.AddItem(StaffSlotDef);

		//StaffSlotDef.StaffSlotTemplateName = 'GTSStaffSlot';
		//StaffSlotDef.bStartsLocked = true;
		//FacilityTemplate.StaffSlotDefs.AddItem(StaffSlotDef);

		Facility.SoldierUnlockTemplates.Length = 0;
		Facility.SoldierUnlockTemplates.AddItem('SquadSizeIUnlock');
		Facility.SoldierUnlockTemplates.AddItem('SquadSizeIIUnlock');
		Facility.SoldierUnlockTemplates.AddItem('SwordBasicUnlock');
		Facility.SoldierUnlockTemplates.AddItem('SwordIntermediateUnlock');
		Facility.SoldierUnlockTemplates.AddItem('SwordExpertUnlock');
		Facility.SoldierUnlockTemplates.AddItem('PistolBasicUnlock');
		Facility.SoldierUnlockTemplates.AddItem('PistolIntermediateUnlock');
		Facility.SoldierUnlockTemplates.AddItem('PistolExpertUnlock');
			
		//Add secondary unlocks if needed for LW Secondaries
		if(LWSecondaries){
			Facility.SoldierUnlockTemplates.AddItem('PumpActionUnlock');
			Facility.SoldierUnlockTemplates.AddItem('CombativesUnlock');
			Facility.SoldierUnlockTemplates.AddItem('ArcThrowerBasicUnlock');
			Facility.SoldierUnlockTemplates.AddItem('ArcThrowerIntermediateUnlock');
			Facility.SoldierUnlockTemplates.AddItem('ArcThrowerExpertUnlock');
			Facility.SoldierUnlockTemplates.AddItem('HolotargeterBasicUnlock');
			Facility.SoldierUnlockTemplates.AddItem('HolotargeterIntermediateUnlock');
			Facility.SoldierUnlockTemplates.AddItem('HolotargeterExpertUnlock');
		}
	}

	FindFacilityTemplateAllDifficulties('PsiChamber', FacilityTemplates);
	foreach FacilityTemplates(Facility)
	{
		//Removes the existing staff slots
		Facility.StaffSlotDefs.Length = 1;

		StaffSlotDef.StaffSlotTemplateName = 'PsionStaffSlot';
		Facility.StaffSlotDefs.AddItem(StaffSlotDef);

		StaffSlotDef.StaffSlotTemplateName = 'PsionStaffSlot';
		StaffSlotDef.bStartsLocked = true;
		Facility.StaffSlotDefs.AddItem(StaffSlotDef);

		/*
		StaffSlotDef.StaffSlotTemplateName = 'PsionStaffSlot';
		Facility.StaffSlotDefs[1] = StaffSlotDef;
		Facility.StaffSlotDefs[2] = StaffSlotDef;
		*/
	}
	
			
}


//retrieves all difficulty variants of a given facility template
static function FindFacilityTemplateAllDifficulties(name DataName, out array<X2FacilityTemplate> FacilityTemplates, optional X2StrategyElementTemplateManager StrategyTemplateMgr)
{
	local array<X2DataTemplate> DataTemplates;
	local X2DataTemplate DataTemplate;
	local X2FacilityTemplate FacilityTemplate;

	if(StrategyTemplateMgr == none)
		StrategyTemplateMgr = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	StrategyTemplateMgr.FindDataTemplateAllDifficulties(DataName, DataTemplates);
	FacilityTemplates.Length = 0;
	foreach DataTemplates(DataTemplate)
	{
		FacilityTemplate = X2FacilityTemplate(DataTemplate);
		if( FacilityTemplate != none )
		{
			FacilityTemplates.AddItem(FacilityTemplate);
		}
	}
}

//Checks for the existence of LW2 Secondary weapons
static function bool LWSecondariesPresent(){
	local X2ItemTemplateManager				ItemTemplateManager;
	
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	if(ItemTemplateManager.FindItemTemplate('Arcthrower_CV') != none)
		return true;
	else
		return false;
}