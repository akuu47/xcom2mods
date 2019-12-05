//---------------------------------------------------------------------------------------
//  FILE:    UIArmory_AdditionalAbilities.uc
//  AUTHOR:  Joe Weinhoffer
//   
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class UIArmory_AdditionalAbilities extends UIArmory;

const NUM_ABILITIES_PER_COLUMN = 4;

enum UIPromotionButtonState
{
	eUIPromotionState_Locked,
	eUIPromotionState_Normal,
	eUIPromotionState_Equipped
};

var array<UIArmory_AdditionalAbilitiesColumn> Columns;

var localized string m_strPsiOffenseLabel;
var localized string m_strNextSoldierRankLabel;

var localized string m_strBranchesLabel;
var localized string m_strNewRank;
var localized string m_strCostLabel;
var localized string m_strAPLabel;
var localized string m_strSharedAPWarning;
var localized string m_strSharedAPWarningSingular;
var localized string m_strPrereqAbility;

var int m_iCurrentlySelectedColumn;  // bsg-nlong (1.25.17): Used to track which column has focus

var XComGameState PromotionState;
var int PendingRank, PendingBranch;
var localized string m_strSelectAbility;
var localized string m_strAbilityHeader;
var localized string m_strConfirmAbilityTitle;
var localized string m_strConfirmAbilityText;
var localized string m_strAbilityLockedTitle;
var localized string m_strAbilityLockedDescription;
var localized string m_strInfo;
var localized string m_strSelect;
var localized string m_strHotlinkToRecovery; 
var int SelectedAbilityIndex;
var UIList  List;
var protected int previousSelectedIndexOnFocusLost;

//---------------------------------------------------------------------------------------
//  FILE:    UIArmory_AdditionalAbilities.uc
//  AUTHOR:  Joe Weinhoffer
//---------------------------------------------------------------------------------------

simulated function InitPromotion(StateObjectReference UnitRef, optional bool bInstantTransition)
{
	local UIArmory_AdditionalAbilitiesColumn Column;
	local XComGameState_Unit Unit; // bsg-nlong (1.25.17): Used to determine which column we should start highlighting

	//3CameraTag = string(default.DisplayTag);
	DisplayTag = default.DisplayTag;
	
	super.InitArmory(UnitRef, , , , , , bInstantTransition);
	
	Column = Spawn(class'UIArmory_AdditionalAbilitiesColumn', self);
	Column.MCName = 'rankColumn0';
	Column.InitPromotionHeroColumn(0);
	Columns.AddItem(Column);

	Column = Spawn(class'UIArmory_AdditionalAbilitiesColumn', self);
	Column.MCName = 'rankColumn1';
	Column.InitPromotionHeroColumn(1);
	Columns.AddItem(Column);

	Column = Spawn(class'UIArmory_AdditionalAbilitiesColumn', self);
	Column.MCName = 'rankColumn2';
	Column.InitPromotionHeroColumn(2);
	Columns.AddItem(Column);

	Column = Spawn(class'UIArmory_AdditionalAbilitiesColumn', self);
	Column.MCName = 'rankColumn3';
	Column.InitPromotionHeroColumn(3);
	Columns.AddItem(Column);

	Column = Spawn(class'UIArmory_AdditionalAbilitiesColumn', self);
	Column.MCName = 'rankColumn4';
	Column.InitPromotionHeroColumn(4);
	Columns.AddItem(Column);

	Column = Spawn(class'UIArmory_AdditionalAbilitiesColumn', self);
	Column.MCName = 'rankColumn5';
	Column.InitPromotionHeroColumn(5);
	Columns.AddItem(Column);

	Column = Spawn(class'UIArmory_AdditionalAbilitiesColumn', self);
	Column.MCName = 'rankColumn6';
	Column.InitPromotionHeroColumn(6);
	Columns.AddItem(Column);

	PopulateData();

	DisableNavigation(); // bsg-nlong (1.25.17): This and the column panel will have to use manual naviation, so we'll disable the navigation here

	MC.FunctionVoid("AnimateIn");

	// bsg-nlong (1.25.17): Focus a column so the screen loads with an ability highlighted
	if( `ISCONTROLLERACTIVE )
	{
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID));
		if( Unit != none )
		{
			m_iCurrentlySelectedColumn = m_iCurrentlySelectedColumn;
		}
		else
		{
			m_iCurrentlySelectedColumn = 0;
		}

		Columns[m_iCurrentlySelectedColumn].OnReceiveFocus();
	}
	// bsg-nlong (1.25.17): end
}


// UPDATED
simulated function PopulateData()
{
	local XComGameState_Unit Unit;
	local XComGameState_Unit_Additional ExtraState;
	local X2SoldierClassTemplate ClassTemplate;
	local bool bIsPsion;

	local UIArmory_AdditionalAbilitiesColumn Column;
	local string HeaderString, rankIcon, classIcon, RankName;
	local int iRank, PsionRank, maxRank;
	local bool bHasColumnAbility, bHighlightColumn;
	local XComGameState_ResistanceFaction FactionState;

	
	Unit = GetUnit();
	bIsPsion = class'MNT_Utility'.static.IsPsion(Unit);
	FactionState = Unit.GetResistanceFaction();
	ClassTemplate = Unit.GetSoldierClassTemplate();

	rankIcon = class'UIUtilities_Image'.static.GetRankIcon(Unit.GetRank(), ClassTemplate.DataName);
	classIcon = ClassTemplate.IconImage;
	rankName = Unit.GetName(eNameType_FullNick);

	HeaderString = m_strAbilityHeader;

	if(bIsPsion){
		ExtraState = class'MNT_Utility'.static.GetExtraComponent(Unit);
		PsionRank = ExtraState.GetPsionRank();

		rankIcon = class'MNT_Utility'.static.GetRankIcon(PsionRank);
		classIcon = class'MNT_Utility'.static.GetClassIcon();
		rankName = class'MNT_Utility'.static.GetRankName(PsionRank) $ " " $ Unit.GetName(eNameType_Last);
	}

	AS_SetRank(rankIcon);
	AS_SetClass(classIcon);
	AS_SetFaction(FactionState.GetFactionIcon());


	if(bIsPsion){
		AS_SetHeaderData(Caps(FactionState.GetFactionTitle()), Caps(rankName), HeaderString, m_strPsiOffenseLabel, m_strNextSoldierRankLabel);
		AS_SetPsiData();
		AS_SetCombatIntelData(Unit.GetCombatIntelligenceLabel());
		AS_SetPathLabels(m_strBranchesLabel, "Specialization", "Bond", "GTS", "Psion");

		for (iRank = 0; iRank < class'MNT_Utility'.static.GetMaxRank(); ++iRank)
		{
			Column = Columns[iRank];
			bHasColumnAbility = UpdateAbilityIcons(Column);
			bHighlightColumn = (!bHasColumnAbility && (iRank) == PsionRank);

			Column.AS_SetData(bHighlightColumn, m_strNewRank, class'MNT_Utility'.static.GetRankIcon(iRank), Caps(class'MNT_Utility'.static.GetRankName(iRank)));
		}
	}
	else
	{
		AS_SetHeaderData(Caps(FactionState.GetFactionTitle()), Caps(rankName), HeaderString, "", "");
		AS_SetPsiData();
		AS_SetCombatIntelData(Unit.GetCombatIntelligenceLabel());
		AS_SetPathLabels(m_strBranchesLabel, "Specialization", "Bond", "GTS", "");

		maxRank = class'X2ExperienceConfig'.static.GetMaxRank();

		for (iRank = 0; iRank < (maxRank - 1); ++iRank)
		{
			Column = Columns[iRank];
			bHasColumnAbility = UpdateAbilityIcons(Column);
			bHighlightColumn = (!bHasColumnAbility && (iRank+1) == Unit.GetRank());

			Column.AS_SetData(bHighlightColumn, m_strNewRank, class'UIUtilities_Image'.static.GetRankIcon(iRank+1, ClassTemplate.DataName), Caps(class'X2ExperienceConfig'.static.GetRankName(iRank+1, ClassTemplate.DataName)));
		}
	}
	
	HidePreview();
}


// UPDATED
function bool UpdateAbilityIcons(out UIArmory_AdditionalAbilitiesColumn Column)
{
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2AbilityTemplate AbilityTemplate;
	local array<name> AbilitiesToDisplay;

	local XComGameState_Unit Unit;
	local XComGameState_Unit_Additional ExtraState;

	local UIPromotionButtonState ButtonState;
	local int iAbility;
	local bool bHasColumnAbility, bConnectToNextAbility;
	local string AbilityName, AbilityIcon, BGColor, FGColor;

	AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	Unit = GetUnit();
	ExtraState = class'MNT_Utility'.static.GetExtraComponent(Unit);

	//grab all the abilities we need to display in this column
	AbilitiesToDisplay = ExtraState.GetPerksForColumn(Column.Rank);

	for(iAbility = 0; iAbility < NUM_ABILITIES_PER_COLUMN; ++iAbility)
	{
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(AbilitiesToDisplay[iAbility]);

		if(AbilityTemplate != none)
		{
			if (Column.AbilityNames.Find(AbilityTemplate.DataName) == INDEX_NONE)
			{
				Column.AbilityNames.AddItem(AbilityTemplate.DataName);

				AbilityName = class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(AbilityTemplate.LocFriendlyName);
				AbilityIcon = AbilityTemplate.IconImage;
				ButtonState = eUIPromotionState_Equipped;
				FGColor = class'UIUtilities_Colors'.const.NORMAL_HTML_COLOR;
				BGColor = class'UIUtilities_Colors'.const.BLACK_HTML_COLOR;
				bHasColumnAbility = true;

				// The unit is not yet at the rank needed for this column
				if (Column.Rank > Unit.GetRank()-1 && iAbility == 0)
				{
					AbilityName = class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedTitle, eUIState_Disabled);
					AbilityIcon = class'UIUtilities_Image'.const.UnknownAbilityIcon;
					ButtonState = eUIPromotionState_Locked;
					FGColor = class'UIUtilities_Colors'.const.BLACK_HTML_COLOR;
					BGColor = class'UIUtilities_Colors'.const.DISABLED_HTML_COLOR;
					bConnectToNextAbility = false; // Do not display prereqs for abilities which aren't available yet
				}
				
				Column.SetAvailable(true);
			}
			Column.AS_SetIconState(iAbility, false, AbilityIcon, AbilityName, ButtonState, FGColor, BGColor, bConnectToNextAbility);
		}
		else
			Column.AbilityNames.AddItem(''); // Make sure we add empty spots to the name array for getting ability info

	}

	// bsg-nlong (1.25.17): Select the first available/visible ability in the column
	while(`ISCONTROLLERACTIVE && !Column.AbilityIcons[Column.m_iPanelIndex].bIsVisible)
	{
		Column.m_iPanelIndex +=1;
		if( Column.m_iPanelIndex >= Column.AbilityIcons.Length )
		{
			Column.m_iPanelIndex = 0;
		}
	}
	// bsg-nlong (1.25.17): end

	return bHasColumnAbility;
}


// UPDATED
function HidePreview()
{
	local string ClassName, ClassDesc;

	if(class'MNT_Utility'.static.isPsion(GetUnit()))
	{
		ClassName = Caps("<font color='#C08EDA'>Psion</font>");
		ClassDesc = class'MNT_Utility'.default.PsionDescription;
	}
	else
	{
		ClassName = "";
		ClassDesc = "";
	}
	// By default when not previewing an ability, display class data
	AS_SetDescriptionData("", ClassName, ClassDesc, "", "", "", "");
}


function PreviewAbility(int Rank, int Branch)
{
	local X2AbilityTemplateManager AbilityTemplateManager;
	local X2AbilityTemplate AbilityTemplate;
	local XComGameState_Unit Unit;
	local XComGameState_Unit_Additional ExtraState;
	local string AbilityIcon, AbilityName, AbilityDesc, AbilityHint, AbilityCost, CostLabel, APLabel;
	local array<name> AbilitiesToDisplay;

	Unit = GetUnit();
	ExtraState = class'MNT_Utility'.static.GetExtraComponent(Unit);
	AbilitiesToDisplay = ExtraState.GetPerksForColumn(Rank);
	AbilityName = string(AbilitiesToDisplay[Branch]);

	// Ability cost is always displayed, even if the rank hasn't been unlocked yet
	CostLabel = m_strCostLabel;
	APLabel = m_strAPLabel;
	//AbilityCost = string(GetAbilityPointCost(Rank, Branch));
	
	if (Rank > Unit.GetRank()-1 && Branch == 0)
	{
		AbilityIcon = class'UIUtilities_Image'.const.LockedAbilityIcon;
		AbilityName = class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedTitle, eUIState_Disabled);
		AbilityDesc = class'UIUtilities_Text'.static.GetColoredText(m_strAbilityLockedDescription, eUIState_Disabled);

		// Don't display cost information for abilities which have not been unlocked yet
		CostLabel = "";
		AbilityCost = "";
		APLabel = "";
	}
	else
	{
		AbilityTemplateManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
		AbilityTemplate = AbilityTemplateManager.FindAbilityTemplate(name(AbilityName));

		if (AbilityTemplate != none)
		{
			AbilityIcon = AbilityTemplate.IconImage;
			AbilityName = AbilityTemplate.LocFriendlyName != "" ? AbilityTemplate.LocFriendlyName : ("Missing 'LocFriendlyName' for " $ AbilityTemplate.DataName);
			AbilityDesc = AbilityTemplate.HasLongDescription() ? AbilityTemplate.GetMyLongDescription(, Unit) : ("Missing 'LocLongDescription' for " $ AbilityTemplate.DataName);
			AbilityHint = "";

			CostLabel = "";
			AbilityCost = "";
			APLabel = "";
			
		}
		else
		{
			AbilityIcon = "";
			AbilityName = "";
			AbilityDesc = "Missing template for ability '" $ ExtraState.GetPerksForColumn(Rank)[Branch] $ "'";
			AbilityHint = "";
		}
	}
	
	AS_SetDescriptionData(AbilityIcon, AbilityName, AbilityDesc, AbilityHint, CostLabel, AbilityCost, APLabel);
}

//==============================================================================
simulated function AS_SetRank(string RankIcon)
{
	MC.BeginFunctionOp("SetRankIcon");
	MC.QueueString(RankIcon);
	MC.EndOp();
}

simulated function AS_SetClass(string ClassIcon)
{
	MC.BeginFunctionOp("SetClassIcon");
	MC.QueueString(ClassIcon);
	MC.EndOp();
}

simulated function AS_SetFaction(StackedUIIconData IconInfo)
{
	local int i;

	if (IconInfo.Images.Length > 0)
	{
		MC.BeginFunctionOp("SetFactionIcon");
		MC.QueueBoolean(IconInfo.bInvert);
		for (i = 0; i < IconInfo.Images.Length; i++)
		{
			MC.QueueString("img:///" $ IconInfo.Images[i]);
		}

		MC.EndOp();
	}
}

simulated function AS_SetHeaderData(string Faction, string UnitName, string AbilityLabel, string PsiOffenseLabel, string NextSoldierRankLabel)
{
	MC.BeginFunctionOp("SetHeaderData");
	MC.QueueString(Faction); // Faction
	MC.QueueString(UnitName); // Soldier Name
	MC.QueueString(AbilityLabel); // Ability Selection Label
	MC.QueueString(PsiOffenseLabel); // PsiOffense Label
	MC.QueueString(NextSoldierRankLabel); // NextSoldierRank Label
	MC.EndOp();
}

//replace with what
simulated function AS_SetPsiData()
{
	MC.BeginFunctionOp("SetAPData");
	if(class'MNT_Utility'.static.isPsion(GetUnit())){
		MC.QueueString(string(int(GetUnit().GetBaseStat(eStat_PsiOffense))));
		MC.QueueString(GetNextReqRank());
	}
	else{
		MC.QueueString("");
		MC.QueueString("");
	}
	MC.EndOp();
}

//replace with what
simulated function AS_SetCombatIntelData( string Value )
{
	MC.BeginFunctionOp("SetCombatIntelData");
	MC.QueueString("SPECIALIZATION");
	MC.QueueString(GetSpecializationString());
	MC.EndOp();
}

simulated function AS_SetPathLabels(string RankLabel, string Path1Label, string Path2Label, string Path3Label, string Path4Label)
{
	MC.BeginFunctionOp("SetPathLabels");
	MC.QueueString(RankLabel); // Rank Label
	MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(Path1Label));
	MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(Path2Label));
	MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(Path3Label));
	MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(Path4Label));
	MC.EndOp();
}

simulated function AS_SetDescriptionData(string Icon, string AbilityName, string Description, string Hint, string CostLabel, string CostValue, string APLabel)
{
	MC.BeginFunctionOp("SetDescriptionData");
	MC.QueueString(Icon);
	MC.QueueString(AbilityName);
	MC.QueueString(Description);
	MC.QueueString(Hint);
	MC.QueueString(CostLabel); // replace this with what
	MC.QueueString(CostValue); // replace this... with what?
	MC.QueueString(APLabel); // < replace this with what
	MC.EndOp();
}

simulated function string GetNextReqRank(){

	local int PsionRank;
	local int ReqRegRank;
	local string NextRank;

	if(!class'MNT_Utility'.static.isPsion(GetUnit()))
		return "---";

	PsionRank = class'MNT_Utility'.static.GetExtraComponent(GetUnit()).GetPsionRank();

	//Already reached max rank
	if(PsionRank == class'MNT_Utility'.static.GetMaxRank())
		return "---";

	ReqRegRank = class'MNT_Utility'.static.GetRequiredRegularRank(PsionRank+1);

	//Ranger is a default class
	NextRank = Caps(class'X2ExperienceConfig'.static.GetShortRankName(ReqRegRank, 'Ranger'));

	//Already reached rank requirement
	if(GetUnit().GetRank() >= ReqRegRank)
		return NextRank;
	else
		return class'UIUtilities_Text'.static.GetColoredText(NextRank, eUIState_Bad);

}

simulated function string GetSpecializationString(){
	
	if(!class'MNT_Utility'.static.isSpecialized(GetUnit()))
		return "---";
	else
		return class'MNT_Utility'.static.GetExtraComponent(GetUnit()).GetSpecializationName();

}

// bsg-nlong (1.25.17): Manually coded navigation: There are some issues with using the Navigation issue. First is that Navigators /within/ the Next() and Prev() functions
// are handled by their children if possible. That means hitting left and right on the dpad with scroll up and down within the column. This is uneffected by bHorizontal flag.
// So if we want left and right to switch columns and up and down to switch abilities, manual navigation is necessary.
// Secondly, the ability icons focus is spread across three Uscript functions and one AS function, so we need to manually code focus for the icons instead of making a HeroAbilityIcon class
simulated function SelectNextColumn()
{
	local int newIndex;

	newIndex = m_iCurrentlySelectedColumn + 1;
	if( newIndex >= Columns.Length )
	{
		newIndex = 0;
	}

	ChangeSelectedColumn(m_iCurrentlySelectedColumn, newIndex);
}

simulated function SelectPrevColumn()
{
	local int newIndex;

	newIndex = m_iCurrentlySelectedColumn - 1;
	if( newIndex < 0 )
	{
		newIndex = Columns.Length -1;
	}
	
	ChangeSelectedColumn(m_iCurrentlySelectedColumn, newIndex);
}

simulated function ChangeSelectedColumn(int oldIndex, int newIndex)
{
	Columns[oldIndex].OnLoseFocus();
	Columns[newIndex].OnReceiveFocus();
	m_iCurrentlySelectedColumn = newIndex;

	Movie.Pres.PlayUISound(eSUISound_MenuSelect); //bsg-crobinson (5.11.17): Add sound
}

simulated static function bool CanCycleTo(XComGameState_Unit Unit)
{
	return false;
	//return Unit.IsSoldier() && class'MNT_Utility'.static.IsPsion(Unit) && !Unit.IsDead() && !Unit.IsOnCovertAction() && (Unit.GetRank() >= 1 || Unit.CanRankUpSoldier());
}

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	local bool bHandled;

	if (!CheckInputIsReleaseOrDirectionRepeat(cmd, arg))
	{
		return false;
	}

	bHandled = true;
	
	bHandled = Columns[m_iCurrentlySelectedColumn].OnUnrealCommand(cmd, arg); // bsg-nlong (1.25.17): Send the input to the column first and see if it can consume it
	if (bHandled) return true;

	switch(cmd)
	{
	case class'UIUtilities_Input'.const.FXS_DPAD_RIGHT:
	case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_RIGHT:
		SelectNextColumn();
		bHandled = true;
		break;
	case class'UIUtilities_Input'.const.FXS_DPAD_LEFT :
	case class'UIUtilities_Input'.const.FXS_VIRTUAL_LSTICK_LEFT :
		SelectPrevColumn();
		bHandled = true;
		break;
	case class'UIUtilities_Input'.const.FXS_R_MOUSE_DOWN:
		OnCancel();
		break;
	default:
		bHandled = false;
		break;
	}

	return bHandled || super.OnUnrealCommand(cmd, arg);
}

simulated function OnReceiveFocus()
{
	local int i;
	local XComHQPresentationLayer HQPres;

	super.OnReceiveFocus();

	HQPres = XComHQPresentationLayer(Movie.Pres);

	if(HQPres != none)
		HQPres.CAMLookAtNamedLocation(CameraTag, `HQINTERPTIME);

	for(i = 0; i < List.ItemCount; ++i)
	{
		UIArmory_PromotionItem(List.GetItem(i)).RealizePromoteState();
	}

	if (previousSelectedIndexOnFocusLost >= 0)
	{
		Navigator.SetSelected(List);
		List.SetSelectedIndex(previousSelectedIndexOnFocusLost);
		UIArmory_PromotionItem(List.GetSelectedItem()).SetSelectedAbility(SelectedAbilityIndex);
	}

	UpdateNavHelp();
	Columns[m_iCurrentlySelectedColumn].OnReceiveFocus();
}
// bsg-nlong (1.25.17): end

function bool IsAbilityLocked(int Rank)
{
	local XComGameState_Unit_Additional ExtraState;

	ExtraState = class'MNT_Utility'.static.GetExtraComponent(GetUnit());

	if(Rank > ExtraState.GetPsionRank())
		return true;
	else
		return false;
}

function bool OwnsAbility(name AbilityName)
{
	local XComGameState_Unit_Additional ExtraState;
	
	ExtraState = class'MNT_Utility'.static.GetExtraComponent(GetUnit());

	if(ExtraState.HasExtraAbility(AbilityName) || ExtraState.HasPsionAbility(AbilityName))
		return true;
	else return false;
}

//---------------------------------------------------------------------------------------
//  FILE:    UIArmory_Promotion.uc
//  AUTHOR:  Joe Weinhoffer
//---------------------------------------------------------------------------------------

simulated function UpdateNavHelp() // bsg-jrebar (4/21/17): Changed UI flow and button positions per new additions
{
	//<workshop> SCI 2016/4/12
	//INS:
	local int i;
	local string PrevKey, NextKey;
	local XGParamTag LocTag;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit Unit;
	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID));

	if(!bIsFocused)
	{
		return;
	}

	NavHelp = `HQPRES.m_kAvengerHUD.NavHelp;
	NavHelp.ClearButtonHelp();
	NavHelp.AddBackButton(OnCancel);
		
	if (XComHQPresentationLayer(Movie.Pres) != none)
	{
		LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
		LocTag.StrValue0 = Movie.Pres.m_kKeybindingData.GetKeyStringForAction(PC.PlayerInput, eTBC_PrevUnit);
		PrevKey = `XEXPAND.ExpandString(PrevSoldierKey);
		LocTag.StrValue0 = Movie.Pres.m_kKeybindingData.GetKeyStringForAction(PC.PlayerInput, eTBC_NextUnit);
		NextKey = `XEXPAND.ExpandString(NextSoldierKey);

		if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M7_WelcomeToGeoscape') != eObjectiveState_InProgress &&
			RemoveMenuEvent == '' && NavigationBackEvent == '' && !`ScreenStack.IsInStack(class'UISquadSelect'))
		{
			NavHelp.AddGeoscapeButton();
		}

		if (Movie.IsMouseActive() && IsAllowedToCycleSoldiers() && class'UIUtilities_Strategy'.static.HasSoldiersToCycleThrough(UnitReference, CanCycleTo))
		{
			NavHelp.SetButtonType("XComButtonIconPC");
			i = eButtonIconPC_Prev_Soldier;
			NavHelp.AddCenterHelp( string(i), "", PrevSoldier, false, PrevKey);
			i = eButtonIconPC_Next_Soldier; 
			NavHelp.AddCenterHelp( string(i), "", NextSoldier, false, NextKey);
			NavHelp.SetButtonType("");
		}
	}

	if( `ISCONTROLLERACTIVE )
	{
		if (!UIArmory_PromotionItem(List.GetSelectedItem()).bIsDisabled)
		{
			NavHelp.AddCenterHelp(m_strInfo, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $class'UIUtilities_Input'.const.ICON_LSCLICK_L3);
		}

		if (IsAllowedToCycleSoldiers() && class'UIUtilities_Strategy'.static.HasSoldiersToCycleThrough(UnitReference, CanCycleTo))
		{
			NavHelp.AddCenterHelp(m_strTabNavHelp, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_LBRB_L1R1); // bsg-jrebar (5/23/17): Removing inlined buttons
		}

		NavHelp.AddCenterHelp(m_strRotateNavHelp, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_RSTICK); // bsg-jrebar (5/23/17): Removing inlined buttons
	}


	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
		
	if( XComHQ.HasFacilityByName('RecoveryCenter') && IsAllowedToCycleSoldiers() && !`ScreenStack.IsInStack(class'UIFacility_TrainingCenter')
		&& !`ScreenStack.IsInStack(class'UISquadSelect') && !`ScreenStack.IsInStack(class'UIAfterAction') && Unit.GetSoldierClassTemplate().bAllowAWCAbilities)
	{
		if( `ISCONTROLLERACTIVE ) 
			NavHelp.AddRightHelp(m_strHotlinkToRecovery, class'UIUtilities_Input'.consT.ICON_BACK_SELECT);
		else
			NavHelp.AddRightHelp(m_strHotlinkToRecovery, , JumpToRecoveryFacility);
	}

	NavHelp.Show();
	//</workshop>
	
}
// bsg-jrebar (4/21/17): end

simulated function JumpToRecoveryFacility()
{
	local XComGameStateHistory History;
	local XComGameState_FacilityXCom FacilityState;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_FacilityXCom', FacilityState)
	{
		if( FacilityState.GetMyTemplateName() == 'RecoveryCenter' && !FacilityState.IsUnderConstruction() )
		{
			`HQPRES.m_kAvengerHUD.Shortcuts.SelectFacilityHotlink(FacilityState.GetReference());
			return;
		}
	}
}

simulated function OnLoseFocus()
{
	super.OnLoseFocus();
	//<workshop> FIX_FOR_PROMOTION_LOST_FOCUS_ISSUE kmartinez 2015-10-28
	// only set our variable if we're not trying to set a default value.
	if( List.SelectedIndex != -1)
		previousSelectedIndexOnFocusLost = List.SelectedIndex;
	//List.SetSelectedIndex(-1);
	`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
}

simulated function RequestPawn(optional Rotator DesiredRotation)
{
	local XComGameState_Unit UnitState;
	local name IdleAnimName;

	super.RequestPawn(DesiredRotation);

	UnitState = GetUnit();
	if(!UnitState.IsInjured() || UnitState.bRecoveryBoosted)
	{
		IdleAnimName = UnitState.GetMyTemplate().CustomizationManagerClass.default.StandingStillAnimName;

		// Play the "By The Book" idle to minimize character overlap with UI elements
		XComHumanPawn(ActorPawn).PlayHQIdleAnim(IdleAnimName);

		// Cache desired animation in case the pawn hasn't loaded the customization animation set
		XComHumanPawn(ActorPawn).CustomizationIdleAnim = IdleAnimName;
	}
}

simulated function string GetPromotionBlueprintTag(StateObjectReference UnitRef)
{
	local XComGameState_Unit UnitState;

	UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitRef.ObjectID));
	if(UnitState.IsGravelyInjured())
		return default.DisplayTag $ "Injured";
	return string(default.DisplayTag);
}

simulated function OnRemoved()
{
	if(ActorPawn != none)
	{
		// Restore the character's default idle animation
		XComHumanPawn(ActorPawn).CustomizationIdleAnim = '';
		XComHumanPawn(ActorPawn).PlayHQIdleAnim();
	}
	super.OnRemoved();
}

//==============================================================================

simulated function AS_SetTitle(string Image, string TitleText, string LeftTitle, string RightRitle, string ClassTitle)
{
	MC.BeginFunctionOp("setPromotionTitle");
	MC.QueueString(Image);
	MC.QueueString(TitleText);
	MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(LeftTitle));
	MC.QueueString(class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(RightRitle));
	MC.QueueString(ClassTitle);
	MC.EndOp();
}

//==============================================================================

defaultproperties
{
	Package = "/ package/gfxXPACK_HeroAbilitySelect/XPACK_HeroAbilitySelect";
	LibID = "HeroAbilitySelect";
	bHideOnLoseFocus = false;
	bAutoSelectFirstNavigable = false;
	DisplayTag = "UIBlueprint_Promotion_Hero";
	CameraTag = "UIBlueprint_Promotion_Hero";
	bShowExtendedHeaderData = true;

	previousSelectedIndexOnFocusLost = -1;
	SelectedAbilityIndex = 1;
}