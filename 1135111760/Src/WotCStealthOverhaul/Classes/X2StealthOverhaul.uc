class X2StealthOverhaul extends Object config (StealthOverhaul);

struct StealthAttachement
{
	var name AttachementTemplate;
	var int ConcealmentLoss;
};

struct WeaponCategory
{
	var string Category;
	var int ConcealmentLossModifier;
};

struct StealthAbility
{
	var name AbilityName;
	var int ConcealmentLossOverride;
	var bool bIncreasesConcealmentLoss;
	var bool bAlwaysBreakConcealment;
	var bool bAlwaysKeepConcealment;
	var array<name> ItemRequirements;
	var array<name> WeaponCategoryRequirements;
	var array<name> WeaponAttachementRequirements;

	structdefaultproperties
	{
		ConcealmentLossOverride = -1
		bIncreasesConcealmentLoss = true
		bAlwaysBreakConcealment = false
		bAlwaysKeepConcealment = false
	}
};

var config array<WeaponCategory> WeaponCategories;
var config array<StealthAbility> StealthAbilities;
var config array<StealthAttachement> GlobalStealthWeaponAttachements;

static function bool ValidateStealthAbilityActivation(XComGameState_Unit SourceUnitState, XComGameState_Ability AbilityState)
{
	local XComGameState_Item SourceWeapon;
	local bool bIsWeaponValid, bIsItemValid, bIsWeaponAttachementValid;
	local X2AbilityTemplate AbilityTemplate;

	SourceWeapon = AbilityState.GetSourceWeapon();
	AbilityTemplate = AbilityState.GetMyTemplate();

	if (AlwaysBreaksConcealment(AbilityTemplate.DataName))
	{
		//`LOG(GetFuncName() @ "AlwaysBreaksConcealment" @ AlwaysBreaksConcealment(AbilityTemplate.DataName),, 'StealthOverhaul');
		return false;
	}

	if (AlwaysRetainConcealment(AbilityTemplate.DataName))
	{
		//`LOG(GetFuncName() @ "AlwaysRetainConcealment" @ AlwaysRetainConcealment(AbilityTemplate.DataName),, 'StealthOverhaul');
		return true;
	}

	if (AbilityTemplate.IsMelee() && SourceUnitState.AffectedByEffectNames.Find('SilentMeleeEffect') == INDEX_NONE)
	{
		//`LOG(GetFuncName() @ "Invalid Melee",, 'StealthOverhaul');
		return false;
	}

	bIsItemValid = MeetsItemRequirements(SourceUnitState, AbilityTemplate.DataName);
	bIsWeaponValid = MeetsWeaponCategoryRequirements(SourceWeapon, AbilityTemplate.DataName);
	bIsWeaponAttachementValid = MeetsWeaponAttachementsRequirements(SourceWeapon, AbilityTemplate.DataName);

	`LOG(GetFuncName() @ "bIsItemValid" @ bIsItemValid @ "bIsWeaponValid" @ bIsWeaponValid @ "bIsWeaponAttachementValid" @ bIsWeaponAttachementValid,, 'StealthOverhaul');
	`LOG(GetFuncName() @ "HasGlobalStealthAttachment" @ HasGlobalStealthAttachment(SourceWeapon),, 'StealthOverhaul');
	
	return (bIsItemValid && bIsWeaponValid && bIsWeaponAttachementValid) || (HasGlobalStealthAttachment(SourceWeapon) && AbilityTemplate.SuperConcealmentLoss > 0);
}

static function int GetGlobalStealthAttachmentConcealmentLoss(XComGameState_Item SourceWeapon)
{
	local int Index;

	Index = GetGlobalStealthAttachmentIndex(SourceWeapon);
	if (Index != INDEX_NONE)
	{
		`LOG(GetFuncName() @ default.GlobalStealthWeaponAttachements[Index].ConcealmentLoss,, 'StealthOverhaul');
		return default.GlobalStealthWeaponAttachements[Index].ConcealmentLoss;
	}
}

static function bool HasGlobalStealthAttachment(XComGameState_Item SourceWeapon)
{
	return GetGlobalStealthAttachmentIndex(SourceWeapon) != INDEX_NONE;
}

static function int GetGlobalStealthAttachmentIndex(XComGameState_Item SourceWeapon)
{
	local array<name> WeaponAttachements;
	local name WeaponAttachement;
	local int Index;

	WeaponAttachements = SourceWeapon.GetMyWeaponUpgradeTemplateNames();
	foreach WeaponAttachements(WeaponAttachement)
	{
		Index = default.GlobalStealthWeaponAttachements.Find('AttachementTemplate', WeaponAttachement);
		if (Index != INDEX_NONE)
		{
			return Index;
		}
	}

	return INDEX_NONE;
}

static function bool RollConcealment(XComGameState_Unit SourceUnitState, XComGameStateContext_Ability AbilityContext, XComGameState GameState)
{
	local XComGameState ConcealedState;
	local XComGameState_Ability AbilityState;
	local XComGameState_Stealth StealthGameState;
	local int RandRoll, ConcealedModifier, FinalConcealmentLoss;

	AbilityState = XComGameState_Ability(GameState.GetGameStateForObjectID(AbilityContext.InputContext.AbilityRef.ObjectID));
	StealthGameState = GetStealthGameState();
	ConcealedState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("StealthOverhaulConcealmentLossChance Modified");
	StealthGameState = XComGameState_Stealth(ConcealedState.ModifyStateObject(StealthGameState.Class, StealthGameState.ObjectID));
	
	FinalConcealmentLoss = StealthGameState.GetConcealmentLoss();

	ConcealedModifier = GetSuperConcealedModifier(SourceUnitState, AbilityState, GameState);
	
	if (ConcealedModifier > 0)
	{
		`log(GetFuncName() @ "Base Concealment Loss" @ FinalConcealmentLoss @ "+ ConcealedModifier" @ ConcealedModifier @ "=" @ (FinalConcealmentLoss + ConcealedModifier),, 'StealthOverhaul');
		FinalConcealmentLoss += ConcealedModifier;
	}

	ModifyConcealmentChance(FinalConcealmentLoss, SourceUnitState, AbilityState, AbilityContext);
	`log(GetFuncName() @ "Modified FinalConcealmentLoss" @ FinalConcealmentLoss, ,, 'StealthOverhaul');

	if (!class'Helpers'.static.IsObjectiveTarget(AbilityContext.InputContext.PrimaryTarget.ObjectID, GameState))
	{
		if (AbilityState.IsAbilityInputTriggered())
		{
			if (FinalConcealmentLoss > class'X2AbilityTemplateManager'.default.SuperConcealShotMax)
			{
				StealthGameState.SetConcealmentLoss(class'X2AbilityTemplateManager'.default.SuperConcealShotMax);
				FinalConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealShotMax;
				`log(GetFuncName() @ "Capping loss to" @ class'X2AbilityTemplateManager'.default.SuperConcealShotMax,, 'StealthOverhaul');
			}
		}
	}

	if (GetAbilityAddConcealment(AbilityState.GetMyTemplateName()))
	{
		StealthGameState.SetConcealmentLoss(FinalConcealmentLoss);
	}

	`TACTICALRULES.SubmitGameState(ConcealedState);

	RandRoll = class'Engine'.static.GetEngine().SyncRand(100, string(GetFuncName()));

	ConcealedState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("StealthOverhaulConcealmentLossChance Roll");
	SourceUnitState = XComGameState_Unit(ConcealedState.ModifyStateObject(SourceUnitState.Class, SourceUnitState.ObjectID));
	SourceUnitState.LastSuperConcealmentRoll = RandRoll;
	SourceUnitState.LastSuperConcealmentValue = FinalConcealmentLoss;
	SourceUnitState.LastSuperConcealmentResult = RandRoll < FinalConcealmentLoss;
	XComGameStateContext_ChangeContainer(ConcealedState.GetContext()).BuildVisualizationFn = SuperConcealmentRollVisualization;
	ConcealedState.GetContext().SetAssociatedPlayTiming(SPT_AfterSequential);
	`TACTICALRULES.SubmitGameState(ConcealedState);
		
	`log(GetFuncName() @ SourceUnitState.GetFullName() @ "SuperConcealementLoss=" $ FinalConcealmentLoss @ "d100=" $ RandRoll,,'StealthOverhaul');
	
	if (RandRoll < FinalConcealmentLoss)
	{
		`log("Concealment lost!",,'StealthOverhaul');
		return false;
	}
	else
	{
		`log("Concealment retained.",,'StealthOverhaul'); 
		return true;
	}
}

static function int GetSuperConcealedModifier(XComGameState_Unit UnitState, XComGameState_Ability SelectedAbilityState, optional XComGameState GameState = none, optional int PotentialTarget)
{
	local XComGameStateHistory History;
	local X2AbilityTemplate AbilityTemplate;
	local int BaseModifier, SuperConcealedModifier;
	local StateObjectReference EffectRef;
	local XComGameState_Effect EffectState;

	History = `XCOMHISTORY;

	AbilityTemplate = SelectedAbilityState.GetMyTemplate();

	BaseModifier = GetAbilityConcealmeantLossOverride(AbilityTemplate.DataName);

	if (BaseModifier == -1)
	{
		BaseModifier = AbilityTemplate.SuperConcealmentLoss;
		if (BaseModifier == -1)
			BaseModifier = class'X2AbilityTemplateManager'.default.SuperConcealmentNormalLoss;
	}

	SuperConcealedModifier = BaseModifier;

	`LOG(GetFuncName() @ "Base" @ SuperConcealedModifier,, 'StealthOverhaul');

	foreach UnitState.AffectedByEffects(EffectRef)
	{
		EffectState = XComGameState_Effect(History.GetGameStateForObjectID(EffectRef.ObjectID));
		if (EffectState != none)
		{
			EffectState.GetX2Effect().AdjustSuperConcealModifier(UnitState, EffectState, SelectedAbilityState, GameState, BaseModifier, SuperConcealedModifier);
		}
	}

	`LOG(GetFuncName() @ "Effect" @ SuperConcealedModifier,, 'StealthOverhaul');

	if(HasGlobalStealthAttachment(SelectedAbilityState.GetSourceWeapon()))
	{
		SuperConcealedModifier += GetWeaponCategoryModifier(X2WeaponTemplate(SelectedAbilityState.GetSourceWeapon().GetMyTemplate()));
		`LOG(GetFuncName() @ "WeaponCategoryModifier" @ SuperConcealedModifier,, 'StealthOverhaul');
		SuperConcealedModifier += GetGlobalStealthAttachmentConcealmentLoss(SelectedAbilityState.GetSourceWeapon());
		`LOG(GetFuncName() @ "GlobalStealthAttachmentConcealmentLoss" @ SuperConcealedModifier,, 'StealthOverhaul');
	}

	if (SuperConcealedModifier < 0) // modifier shouldn't go below zero from effect contributions
		SuperConcealedModifier = 0;

	//	special handling for objective stuff which should always break concealment
	if (class'Helpers'.static.IsObjectiveTarget(PotentialTarget, GameState))
	{
		SuperConcealedModifier = 100;
	}

	return SuperConcealedModifier;
}

static function ModifyConcealmentChance(out int Chance, XComGameState_Unit UnitState, XComGameState_Ability AbilityState, optional XComGameStateContext_Ability AbilityContext = none)
{
	local XComGameState_Unit TargetUnit;
	local XComGameStateHistory History;
	
	local int Observers;

	History = `XCOMHISTORY;

	if (AbilityContext != none)
	{
		TargetUnit = XComGameState_Unit(History.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));

		if (TargetUnit != None && TargetUnit.IsDead())
		{
			Observers = GetNumAlliedViewersOfTarget(TargetUnit);
	
			if (Observers == 0)
			{
				Chance = 10;
				`LOG("No Observers Chance=" @ Chance,, 'StealthOverhaul');
			}
			else
			{
				Chance = Chance / 2;
				`LOG(Observers @ "Observers Chance=" @ Chance,, 'StealthOverhaul');
			}
		}
	}
}

static function SuperConcealmentRollVisualization(XComGameState VisualizeGameState)
{
	local X2Action_UpdateUI UpdateUIAction;
	local VisualizationActionMetadata ActionMetadata;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local X2Action_CameraLookAt LookAtAction;
	local X2Action_MarkerNamed JoinAction;
	local X2Action_Delay DelayAction;
	local X2Action ParentAction;
	local Array<X2Action> ActionsToJoin;
	local int LocalPlayerID;

	History = `XCOMHISTORY;

	foreach VisualizeGameState.IterateByClassType(class'XComGameState_Unit', UnitState)
	{
		break;
	}

	LocalPlayerID = `TACTICALRULES.GetLocalClientPlayerObjectID();

	`LOG(GetFuncName() @ UnitState @ UnitState.ControllingPlayer.ObjectID @ LocalPlayerID,, 'StealthOverhaul');

	if(UnitState.ControllingPlayer.ObjectID == LocalPlayerID)
	{
		ActionMetadata.StateObject_NewState = UnitState;
		ActionMetadata.StateObject_OldState = History.GetPreviousGameStateForObject(UnitState);
		ActionMetadata.VisualizeActor = History.GetVisualizer(UnitState.ObjectID);

		ParentAction = ActionMetadata.LastActionAdded;

		// Jwats: First get the actor on screen!
		LookAtAction = X2Action_CameraLookAt(class'X2Action_CameraLookAt'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ParentAction));
		LookAtAction.LookAtActor = ActionMetadata.VisualizeActor;
		LookAtAction.BlockUntilActorOnScreen = true;
		LookAtAction.LookAtDuration = class'X2Ability_ReaperAbilitySet'.default.ShadowRollCameraDelay;
		LookAtAction.TargetZoomAfterArrival = -0.2f;

		// Jwats: Then update the UI
		UpdateUIAction = X2Action_UpdateUI(class'X2Action_UpdateUI'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, LookAtAction));
		UpdateUIAction.UpdateType = EUIUT_SuperConcealRoll;
		UpdateUIAction.SpecificID = UnitState.ObjectID;
		ActionsToJoin.AddItem(UpdateUIAction);

		// Jwats: Make sure the visualization waits for the UI to finish
		DelayAction = X2Action_Delay(class'X2Action_Delay'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, LookAtAction));
		DelayAction.Duration = class'X2Ability_ReaperAbilitySet'.default.ShadowRollCameraDelay;
		DelayAction.bIgnoreZipMode = true;
		ActionsToJoin.AddItem(DelayAction);

		//Block ability activation while this sequence is running
		class'X2Action_BlockAbilityActivation'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, ActionMetadata.LastActionAdded);

		// Jwats: Make sure the Delay and update UI is waited for and not just one of them.
		JoinAction = X2Action_MarkerNamed(class'X2Action_MarkerNamed'.static.AddToVisualizationTree(ActionMetadata, VisualizeGameState.GetContext(), false, None, ActionsToJoin));
		JoinAction.SetName("Join");
	}
}

static function XComGameState_Stealth GetStealthGameState()
{
	return XComGameState_Stealth(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_Stealth', true));
}

static function CreateStealthGameState(out XComGameState NewGameState)
{
	local XComGameState_Stealth StealthGameState;
	
	StealthGameState = XComGameState_Stealth(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_Stealth', true));

	if (StealthGameState.ObjectID == 0)
	{
		StealthGameState = XComGameState_Stealth(NewGameState.CreateNewStateObject(class'XComGameState_Stealth'));
		NewGameState.AddStateObject(StealthGameState);
	}
	StealthGameState.SetConcealmentLoss(0);
}

static function bool AlwaysBreaksConcealment(name AbilityName)
{
	local int Index;

	Index = GetStealthAbilityIndex(AbilityName);

	if (Index != INDEX_NONE)
	{
		return default.StealthAbilities[Index].bAlwaysBreakConcealment;
	}

	return false;
}

static function bool AlwaysRetainConcealment(name AbilityName)
{
	local int Index;

	Index = GetStealthAbilityIndex(AbilityName);

	if (Index != INDEX_NONE)
	{
		return default.StealthAbilities[Index].bAlwaysKeepConcealment;
	}

	return false;
}

static function bool GetAbilityAddConcealment(name AbilityName)
{
	local int Index;

	Index = GetStealthAbilityIndex(AbilityName);

	if (Index != INDEX_NONE)
	{
		return default.StealthAbilities[Index].bIncreasesConcealmentLoss;
	}

	return true;
}

static function int GetAbilityConcealmeantLossOverride(name AbilityName)
{
	local int Index;

	Index = GetStealthAbilityIndex(AbilityName);

	if (Index != INDEX_NONE)
	{
		return default.StealthAbilities[Index].ConcealmentLossOverride;
	}

	return -1;
}

static function int GetWeaponCategoryModifier(X2WeaponTemplate WeaponTemplate)
{
	local int Index;
	local string Category;

	if (WeaponTemplate == none)
		return 0;

	Category = string(WeaponTemplate.WeaponCat);

	if (Category == "rifle" && InStr(Locs(WeaponTemplate.DataName), "smg") != INDEX_NONE)
	{
		Category = "smg";
	}

	Index = default.WeaponCategories.Find('Category', Category);

	if (Index != INDEX_NONE)
	{
		`LOG(GetFuncName() @ default.WeaponCategories[Index].ConcealmentLossModifier,, 'StealthOverhaul');
		return default.WeaponCategories[Index].ConcealmentLossModifier;
	}
	return 0;
}

static function int GetStealthAbilityIndex(name AbilityName)
{
	return default.StealthAbilities.Find('AbilityName', AbilityName);
}

static function bool MeetsWeaponAttachementsRequirements(XComGameState_Item SourceWeapon, name AbilityName)
{
	local StealthAbility AbilityConfig;
	local array<name> WeaponAttachements;
	local name WeaponAttachementRequirement;
	local int Index;

	Index = GetStealthAbilityIndex(AbilityName);
	if (Index != INDEX_NONE)
	{
		AbilityConfig = default.StealthAbilities[Index];
		if (AbilityConfig.WeaponAttachementRequirements.Length > 0)
		{
			WeaponAttachements = SourceWeapon.GetMyWeaponUpgradeTemplateNames();
			foreach AbilityConfig.WeaponAttachementRequirements(WeaponAttachementRequirement)
			{
				if (WeaponAttachements.Find(WeaponAttachementRequirement) != INDEX_NONE)
				{
					return true;
				}
			}
		}
		else
		{
			return true;
		}
	}
	return false;
}

static function bool MeetsWeaponCategoryRequirements(XComGameState_Item SourceWeapon, name AbilityName)
{
	local StealthAbility AbilityConfig;
	local int Index;

	Index = GetStealthAbilityIndex(AbilityName);
	if (Index != INDEX_NONE)
	{
		AbilityConfig = default.StealthAbilities[Index];
		if (AbilityConfig.WeaponCategoryRequirements.Length > 0)
		{
			return AbilityConfig.WeaponCategoryRequirements.Find(SourceWeapon.GetWeaponCategory()) != INDEX_NONE;		
		}
		else
		{
			return true;
		}
	}
	return false;
}

static function bool MeetsItemRequirements(XComGameState_Unit SourceUnitState, name AbilityName)
{
	local name ItemRequirement;
	local StealthAbility AbilityConfig;
	local int Index;

	Index = GetStealthAbilityIndex(AbilityName);
	if (Index != INDEX_NONE)
	{
		AbilityConfig = default.StealthAbilities[Index];
		if (AbilityConfig.ItemRequirements.Length > 0)
		{
			foreach AbilityConfig.ItemRequirements(ItemRequirement)
			{
				if (SourceUnitState.HasItemOfTemplateType(ItemRequirement))
				{
					return true;
				}
			}
		}
		else
		{
			return true;
		}
	}
	return false;
}

static function int GetNumAlliedViewersOfTarget(XComGameState_Unit TargetUnitState)
{
	local int Index;
	local XComGameState_Unit UnitState;
	local XComGameStateHistory History;
	local X2GameRulesetVisibilityManager VisibilityMgr;
	local array<StateObjectReference> OutAlliedViewers;

	History = `XCOMHISTORY;
	VisibilityMgr = `TACTICALRULES.VisibilityMgr;

	VisibilityMgr.GetAllVisibleToSource(TargetUnitState.ObjectID, OutAlliedViewers, class'XComGameState_Unit', -1, class'X2TacticalVisibilityHelpers'.default.LivingGameplayVisibleFilter);

	`LOG(GetFuncName() @ OutAlliedViewers.Length,, 'StealthOverhaul');
	for(Index = OutAlliedViewers.Length - 1; Index > -1; --Index)
	{
		UnitState = XComGameState_Unit(History.GetGameStateForObjectID(OutAlliedViewers[Index].ObjectID,, -1));
		`assert(UnitState != none);

		if(!UnitState.IsFriendlyUnit(TargetUnitState))
		{
			OutAlliedViewers.Remove(Index, 1);
		}
	}
	`LOG(GetFuncName() @ OutAlliedViewers.Length,, 'StealthOverhaul');
	return OutAlliedViewers.Length;
}
