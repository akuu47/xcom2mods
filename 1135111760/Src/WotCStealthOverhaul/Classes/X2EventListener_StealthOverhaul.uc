class X2EventListener_StealthOverhaul extends X2EventListener;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTacticalHUDReaperUITemplate());
	Templates.AddItem(CreateRetainConcealmentOnActivationTemplate());
	Templates.AddItem(CreateOnTacticalBeginPlayTemplate());

	return Templates;
}

static function CHEventListenerTemplate CreateOnTacticalBeginPlayTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'StealthOverhaulOnTacticalBeginPlay');

	Template.RegisterInTactical = true;

	Template.AddCHEvent('OnTacticalBeginPlay', OnTacticalBeginPlay, ELD_Immediate);
	`LOG("Register Event OnTacticalBeginPlay",, 'StealthOverhaul');

	return Template;
}
static function CHEventListenerTemplate CreateTacticalHUDReaperUITemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'TacticalHUDReaperUI');

	Template.RegisterInTactical = true;

	Template.AddCHEvent('TacticalHUD_RealizeConcealmentStatus', OnReaperUIUpdate, ELD_Immediate);
	`LOG("Register Event TacticalHUD_RealizeConcealmentStatus",, 'StealthOverhaul');

	Template.AddCHEvent('TacticalHUD_UpdateReaperHUD', OnReaperUIUpdate, ELD_Immediate);
	`LOG("Register Event TacticalHUD_UpdateReaperHUD",, 'StealthOverhaul');

	return Template;
}

static function CHEventListenerTemplate CreateRetainConcealmentOnActivationTemplate()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'RetainConcealmentOnActivation');

	Template.RegisterInTactical = true;
	Template.AddCHEvent('RetainConcealmentOnActivation', OnRetainConcealmentOnActivation, ELD_Immediate);

	`LOG("Register Event RetainConcealmentOnActivation",, 'StealthOverhaul');

	return Template;
}


static function EventListenerReturn OnTacticalBeginPlay(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	`LOG(GetFuncName(),, 'StealthOverhaul');
	class'X2StealthOverhaul'.static.CreateStealthGameState(GameState);
	return ELR_NoInterrupt;
}

static function EventListenerReturn OnReaperUIUpdate(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local UITacticalHUD TacticalHUD;
	local XComLWTuple Tuple;
	local float CurrentConcealLoss, ModifiedLoss;
	local int ConcealedModifier;
	local XComGameState_Unit UnitState;
	local UnitValue UsesStealthOverhaul;
	local AvailableAction SelectedAction;
	local XComGameState_Ability SelectedAbilityState;
	local XComGameState_Stealth StealthGameState;
	local bool bIsValidStealthAbility, bMayBreakConcealmentOnActivation, bHasStealthEffect;

	TacticalHUD = `PRES.GetTacticalHUD();
	Tuple = XComLWTuple(EventData);
	UnitState = XComGameState_Unit(EventSource);
	StealthGameState = class'X2StealthOverhaul'.static.GetStealthGameState();
	UnitState.GetUnitValue('StealthOverhaul', UsesStealthOverhaul);
	bIsValidStealthAbility = false;
	bMayBreakConcealmentOnActivation = false;
	//`LOG(Event @ UnitState.AffectedByEffectNames.Find('SilentKillEffect') != INDEX_NONE @ TacticalHUD,, 'StealthOverhaul');

	if (TacticalHUD == none || UnitState.IsSuperConcealed() || !UnitState.IsConcealed())
		return ELR_NoInterrupt;

	SelectedAction = TacticalHUD.GetSelectedAction();
	
	if (SelectedAction.AbilityObjectRef.ObjectID > 0)
	{
		SelectedAbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(SelectedAction.AbilityObjectRef.ObjectID));
		bIsValidStealthAbility = class'X2StealthOverhaul'.static.ValidateStealthAbilityActivation(UnitState, SelectedAbilityState);
		bMayBreakConcealmentOnActivation = SelectedAbilityState.MayBreakConcealmentOnActivation(TacticalHUD.CurrentTargetID);
	}

	bHasStealthEffect = UnitState.AffectedByEffectNames.Find('SilentKillEffect') != INDEX_NONE;

	if (bHasStealthEffect &&
		bMayBreakConcealmentOnActivation &&
		bIsValidStealthAbility
	)
	{
		if (SelectedAbilityState != none && 'AA_Success' == SelectedAbilityState.CanActivateAbility(UnitState))
		{
			ConcealedModifier = class'X2StealthOverhaul'.static.GetSuperConcealedModifier(UnitState, SelectedAbilityState, , TacticalHUD.CurrentTargetID);
			class'X2StealthOverhaul'.static.ModifyConcealmentChance(ConcealedModifier, UnitState, SelectedAbilityState);
			//`LOG(GetFuncName() @ "ConcealedModifier" @ ConcealedModifier,, 'StealthOverhaul');
		}
		//else
		//{
		//	TacticalHUD.MC.FunctionVoid("SetReaperHUDTactical");
		//}
	
		ConcealedModifier += StealthGameState.GetConcealmentLoss();

		if (ConcealedModifier > class'X2AbilityTemplateManager'.default.SuperConcealShotMax)
			ConcealedModifier = class'X2AbilityTemplateManager'.default.SuperConcealShotMax;

		if (ConcealedModifier < 0)
			ConcealedModifier = 0;
	
		ModifiedLoss = ConcealedModifier / 100.0f;
		CurrentConcealLoss = StealthGameState.GetConcealmentLoss() / 100.0f;
		
		// Highjack Reaper UI
		Tuple.Data[0].b = true;
		Tuple.Data[1].f = CurrentConcealLoss + 0.00001f;
		Tuple.Data[2].f = ModifiedLoss + 0.00001f;
		//ShowReaperHUD(Event, TacticalHUD);
		`lOG(Event @ "Final modifier" @ ConcealedModifier @ "Base Loss" @ StealthGameState.GetConcealmentLoss(),, 'StealthOverhaul');
	}
	else if (bHasStealthEffect)
	{
		`LOG(Event @ "Has Stealth Effect",, 'StealthOverhaul');
		//TacticalHUD.MC.FunctionVoid("HardHideRevealedHUD");
		Tuple.Data[0].b = true;
		if (Tuple.Data.Length > 3)
		{
			Tuple.Data[3].b = false;
		}
		else
		{
			Tuple.Data[1].f = 0.0f;
			Tuple.Data[2].f = 1.0f;
		}
	}
	else if(Event != 'TacticalHUD_RealizeConcealmentStatus')
	{
		`LOG(Event @ "No HUD Interception. Cleanup Tactical HUD / bMayBreakConcealmentOnActivation" @ bMayBreakConcealmentOnActivation @ "bIsValidStealthAbility" @ bIsValidStealthAbility,, 'StealthOverhaul');
		HideReaperHUD(TacticalHUD);
		Tuple.Data[0].b = false;
	}

	EventData = Tuple;

	return ELR_NoInterrupt;
}

static function ShowReaperHUD(name Event, UITacticalHUD TacticalHUD)
{
	if (Event == 'TacticalHUD_UpdateReaperHUD')
	{
		TacticalHUD.MC.FunctionVoid("SetReaperHUDShotHUD");
		TacticalHUD.MC.FunctionVoid("ShowReaperTech");
	}

	if (Event == 'TacticalHUD_RealizeConcealmentStatus')
	{
		TacticalHUD.m_bShowingReaperHUD = true;
		TacticalHUD.MC.FunctionVoid("HardHideRevealedHUD");
		TacticalHUD.MC.FunctionVoid("HideConcealmentHUD");
		TacticalHUD.MC.FunctionVoid("SetReaperHUDTactical");
	}
}

static function HideReaperHUD(UITacticalHUD TacticalHUD)
{
	TacticalHUD.m_bShowingReaperHUD = false;
	TacticalHUD.MC.FunctionVoid("HideReaperHUD");
	TacticalHUD.MC.FunctionVoid("HideReaperTech");
	TacticalHUD.MC.FunctionVoid("HardHideRevealedHUD");
	//TacticalHUD.MC.FunctionVoid("HideConcealmentHUD");
	
	//TacticalHUD.m_currentScopeOn = class'X2SoldierClass_DefaultChampionClasses'.default.ShadowScopePostProcessOn;
	//TacticalHUD.m_currentScopeOff = class'X2SoldierClass_DefaultChampionClasses'.default.ShadowScopePostProcessOff;
	`Pres.EnablePostProcessEffect(TacticalHUD.m_currentScopeOff, true, true);
	`Pres.EnablePostProcessEffect(TacticalHUD.m_currentScopeOn, false);
	`Pres.EnablePostProcessEffect('ShadowModeOn', false);
}

static function EventListenerReturn OnRetainConcealmentOnActivation(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Ability AbilityState;
	local XComLWTuple Tuple;
	local XComGameState_Unit UnitState;
	local UnitValue UsesStealthOverhaul;
	local bool bRetainConcealment;

	Tuple = XComLWTuple(EventData);
	AbilityContext = XComGameStateContext_Ability(EventSource);
	AbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityContext.InputContext.SourceObject.ObjectID));
	UnitState.GetUnitValue('StealthOverhaul', UsesStealthOverhaul);
	bRetainConcealment = Tuple.Data[0].b;

	if (UnitState.AffectedByEffectNames.Find('SilentKillEffect') != INDEX_NONE && !bRetainConcealment)
	{
		`LOG(GetFuncName() @ UnitState.GetFullName() @ AbilityState.GetMyTemplateName() @ "bRetainConcealment"  @ bRetainConcealment,, 'StealthOverhaul');
		bRetainConcealment = class'X2StealthOverhaul'.static.ValidateStealthAbilityActivation(UnitState, AbilityState);
		Tuple.Data[0].b = bRetainConcealment && class'X2StealthOverhaul'.static.RollConcealment(UnitState, AbilityContext, GameState);
		EventSource = Tuple;
	}

	return ELR_NoInterrupt;
}

