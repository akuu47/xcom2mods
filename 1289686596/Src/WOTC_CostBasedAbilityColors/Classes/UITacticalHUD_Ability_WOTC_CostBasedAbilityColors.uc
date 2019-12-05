
class UITacticalHUD_Ability_WOTC_CostBasedAbilityColors extends UITacticalHUD_Ability config(WOTC_CostBasedAbilityColors);

var config bool			bDEBUG_LOGGING;

var const config string AbilityCostColor_FreeAction;
var const config string AbilityCostColor_WontEndTurn;
var const config string AbilityCostColor_WillEndTurn;
var const config string AbilityCostColor_TwoPlusActions;
var const config string AbilityCostColor_Unavailable;

var config bool			bFULL_COLOR_MODE;
var config bool			bCHANGE_SYMBOL_COLORS;

var const config string AbilityTypeColor_MissionObjective;
var const config string AbilityTypeColor_Commander;
var const config string AbilityTypeColor_Psionic;
var const config string AbilityTypeColor_Perk;
var const config string AbilityTypeColor_Debuff;
var const config string AbilityTypeColor_Item;
var const config string AbilityTypeColor_Standard;


var config bool			bHANDLE_FREE_RELOADS;
var config bool			bAUTO_DETECT_FREE_RELOAD_ANYTIME;


struct AbilityCostColorOverride
{
	var string	AbilityName;
	var string	ModifyingAbilityName;
	var string	ModifyingEffectName;
	var string	OverrideColor;
	var bool	bIsFreeAction;
	var bool	bIsTurnEnding;
	var bool	bNotTurnEnding;

	structdefaultproperties
	{
		ModifyingAbilityName = "";
		ModifyingEffectName = "";
		OverrideColor = "";
		bIsFreeAction = false;
		bIsTurnEnding = false;
		bNotTurnEnding = false;
	}
};

var config array<AbilityCostColorOverride> AbilityCostColorOverrides;


var UIIcon OverlayIcon;


simulated function UIPanel InitAbilityItem(optional name InitName)
{
	InitPanel(InitName);

	// Original Icon Code
	Icon = Spawn(class'UIIcon', self);
	Icon.InitIcon('IconMC', , false, true, 36);
	Icon.SetPosition(-20, -20);
    Icon.SetForegroundColor("000000");

    // New Overlay Icon
    OverlayIcon = Spawn(class'UIIcon', self);
    OverlayIcon.InitIcon(, "img:///CBAC_Resources.IconBorder", false, false, Icon.Width + 4);
    OverlayIcon.setPosition(Icon.X - 2, Icon.Y - 2);

	return self;
}


simulated function UpdateData(int NewIndex, const out AvailableAction AvailableActionInfo)
{
    local XComGameState_Ability AbilityState;
	local string				AbilityCostColor;
	
	// Default function call
	Super.UpdateData(NewIndex, AvailableActionInfo);

    AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AvailableActionInfo.AbilityObjectRef.ObjectID));

    // Set Icon Border color based on ability cost
	AbilityCostColor = GetAbilityBorderColor(AbilityState, AvailableActionInfo);
	OverlayIcon.SetForegroundColor(AbilityCostColor);
	if (bFULL_COLOR_MODE)
	{
		Icon.EnableMouseAutomaticColor(AbilityCostColor);
	}

	// Set Icon Symbol (inner) color based on ability type, if enabled
	if (bCHANGE_SYMBOL_COLORS && !bFULL_COLOR_MODE)
	{
		Icon.EnableMouseAutomaticColor(GetAbilitySymbolColor(AbilityState));
	}
	
    // Charge counter for free reloads
	if (bHANDLE_FREE_RELOADS && AbilityState.GetMyTemplateName() == 'Reload')
	{
		if (bAUTO_DETECT_FREE_RELOAD_ANYTIME && !FreeReloadDetected() && GetFreeReloadsCount(AbilityState) > 0)
		{
			SetCharge(m_strChargePrefix $ string(GetFreeReloadsCount(AbilityState)));
    }	}
}




simulated function string GetAbilityBorderColor(XComGameState_Ability AbilityState, AvailableAction AvailableActionInfo)
{
	local XComGameState_Unit			UnitState;
	local StateObjectReference			FinalizeAbilityRef;
	local XComGameState_Ability			FinalizeAbility;
    local X2AbilityCost_ActionPoints	ActionPointCost;
	local name							AllowedType;
	local bool							bHasActions, NotTurnEnding;
	local int							i, PointCost;
    
	ActionPointCost = GetActionPointCost(AbilityState);
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	PointCost = ActionPointCost.GetPointCost(AbilityState, UnitState);
	if (ActionPointCost != None && PointCost != 0)
	{
		i = 0;
		foreach UnitState.ActionPoints(AllowedType)
		{
			if (ActionPointCost.AllowedTypes.Find(AllowedType) != Index_none)
			{
				i++;
				if (i >= PointCost)
				{
					bHasActions = true;
					break;
		}	}	}

		// If unit does not have enough remaining action points that are valid for the ability, return the Unavailable color
		if (!bHasActions)
			return AbilityCostColor_Unavailable;
	}

	if (UnitState.ActionPoints.Length > 0 || AvailableActionInfo.AvailableCode == 'AA_Success')
	{
		// Process config ability overrides
		if (AbilityCostColorOverrides.Length > 0)
		{
			for (i = 0; i < AbilityCostColorOverrides.Length; i++)
			{
				if (AbilityCostColorOverrides[i].AbilityName ~= string(AbilityState.GetMyTemplateName()))
				{
					// If ability override has conditions, check them, then apply
					if ((AbilityCostColorOverrides[i].ModifyingAbilityName == "" && AbilityCostColorOverrides[i].ModifyingEffectName == "")
					|| UnitState.AppliedEffectNames.Find(name(AbilityCostColorOverrides[i].ModifyingEffectName)) != -1
					|| UnitState.HasSoldierAbility(name(AbilityCostColorOverrides[i].ModifyingAbilityName)))
					{
						if (AbilityCostColorOverrides[i].OverrideColor != "")
							return AbilityCostColorOverrides[i].OverrideColor;

						if (AbilityCostColorOverrides[i].bIsFreeAction)
							return AbilityCostColor_FreeAction;

						if (AbilityCostColorOverrides[i].bIsTurnEnding)
							return AbilityCostColor_WillEndTurn;

						if (AbilityCostColorOverrides[i].bNotTurnEnding)
							NotTurnEnding = true;
		}	}	}	}

		if (NotTurnEnding)
			return AbilityCostColor_WontEndTurn;

    
		// Special handling for free reloads
		if (bHANDLE_FREE_RELOADS && AbilityState.GetMyTemplateName() == 'Reload')
		{
			if (bAUTO_DETECT_FREE_RELOAD_ANYTIME && !FreeReloadDetected() && GetFreeReloadsCount(AbilityState) > 0)
			{
				return AbilityCostColor_FreeAction;
		}	}
    
		// Special handling for action with additional confirmation dialogs
		if (AbilityState.GetMyTemplate().FinalizeAbilityName != '')
		{
			FinalizeAbilityRef = UnitState.FindAbility(AbilityState.GetMyTemplate().FinalizeAbilityName);
			FinalizeAbility = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(FinalizeAbilityRef.ObjectID));
			return GetAbilityBorderColor(FinalizeAbility, AvailableActionInfo);
		}
    
		// If no ActionPointCost is defined, color as free
		if (ActionPointCost == None)
			return AbilityCostColor_FreeAction;

		// If the ability has bFreeCost = true and will not consume all points, color as free
		if (ActionPointCost.bFreeCost && !ActionPointCost.ConsumeAllPoints(AbilityState, UnitState))
			return AbilityCostColor_FreeAction;

		// If the ability has a cost of 0 and will not consume all points, color as free
		if (PointCost == 0 && !ActionPointCost.ConsumeAllPoints(AbilityState, UnitState))
			return AbilityCostColor_FreeAction;

		// If the ability costs more than 1 action, color as a 2+ action ability
		if (PointCost > 1)
			return AbilityCostColor_TwoPlusActions;

		// Check now if using the ability would end the turn. This method often reports wrong answers,
		// especially for free abilities (grapple, serial, etc), so the check for free actions must be done first.
		return AbilityState.WillEndTurn() ? AbilityCostColor_WillEndTurn : AbilityCostColor_WontEndTurn;
	}

	return AbilityCostColor_Unavailable;
}


simulated function X2AbilityCost_ActionPoints GetActionPointCost(XComGameState_Ability AbilityState)
{
    local X2AbilityCost_ActionPoints ActionPointCost;
    local int i;

    for (i = 0; i < AbilityState.GetMyTemplate().AbilityCosts.Length; i++)
	{
        ActionPointCost = X2AbilityCost_ActionPoints(AbilityState.GetMyTemplate().AbilityCosts[i]);
        if (ActionPointCost != None)
            return ActionPointCost;
    }

    return None;
}


simulated function string GetAbilitySymbolColor(XComGameState_Ability AbilityState)
{
    local XComGameState_BattleData BattleDataState;
    
    BattleDataState = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
	if (BattleDataState != None && BattleDataState.IsAbilityObjectiveHighlighted(AbilityState.GetMyTemplate()))
		return AbilityTypeColor_MissionObjective;

	else if (AbilityState.GetMyTemplate().AbilityIconColor != "")
		return AbilityState.GetMyTemplate().AbilityIconColor;

	else
	{
        switch(AbilityState.GetMyTemplate().AbilitySourceName)
		{
			case 'eAbilitySource_Perk':
				return AbilityTypeColor_Perk;
			case 'eAbilitySource_Debuff':
				return AbilityTypeColor_Debuff;
			case 'eAbilitySource_Psionic':
				return AbilityTypeColor_Psionic;
			case 'eAbilitySource_Commander':
				return AbilityTypeColor_Commander;
			case 'eAbilitySource_Item':
				return AbilityTypeColor_Item;
			default:
				return AbilityTypeColor_Standard;
}	}	}


simulated function int GetFreeReloadsCount(XComGameState_Ability AbilityState)
{
	local XComGameState_Unit UnitState;
	local UnitValue FreeReloads;
	local array<X2WeaponUpgradeTemplate> UpgradeTemplates;
	local int i, UsedFreeReloads, TotalFreeReloads;

	// Get current unit
	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(AbilityState.OwnerStateObject.ObjectID));
	if (UnitState == None)
		return 0; // Error Fallback

	// Read number of already used-up free reloads
	UnitState.GetUnitValue('FreeReload', FreeReloads);
	UsedFreeReloads = FreeReloads.fValue;

	// Look for free reload upgrades
	UpgradeTemplates = AbilityState.GetSourceWeapon().GetMyWeaponUpgradeTemplates();
	for (i = 0; i < UpgradeTemplates.Length; ++i)
	{
		// Check if this upgrade grants Free Reloads
		if (UpgradeTemplates[i].NumFreeReloads > 0)
		{
			// Get total (base + bonus) charges for this weapon upgrade
			if (UpgradeTemplates[i].GetBonusAmountFn != none)
			{
				TotalFreeReloads = TotalFreeReloads + UpgradeTemplates[i].GetBonusAmountFn(UpgradeTemplates[i]);
			}
			else
			{
				TotalFreeReloads = TotalFreeReloads + UpgradeTemplates[i].NumFreeReloads;
	}	}	}


	// Return Total - Used Free Reloads
	if (TotalFreeReloads > 0)
	{
		return Max(0, TotalFreeReloads - UsedFreeReloads);
	}

	return 0;
}


// Test for the presence of Free Reload Anytime
simulated function bool FreeReloadDetected()
{
	local X2AbilityTemplateManager				AbilityTemplateMgr;
	local array<X2AbilityTemplate>				AbilityTemplateArray;

	AbilityTemplateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityTemplateMgr.FindAbilityTemplateAllDifficulties('FreeReload', AbilityTemplateArray);
	if (AbilityTemplateArray.Length > 0)
	{
		return true;
	}
	
	return false;
}	