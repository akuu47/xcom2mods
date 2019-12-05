class UIArmory_MainMenu_Replacement extends UIArmory_MainMenu dependson(UIDialogueBox) dependson(UIUtilities_Strategy);

var localized string m_strAdditionalAbilities;
var localized string m_strAdditionalDesc;

simulated function InitArmory(StateObjectReference UnitRef, optional name DispEvent, optional name SoldSpawnEvent, optional name NavBackEvent, optional name HideEvent, optional name RemoveEvent, optional bool bInstant = false, optional XComGameState InitCheckGameState)
{
	local float InterpTime;
	
	bUseNavHelp = class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M2_WelcomeToArmory');	
	IsSoldierEligible = CanCycleTo;
	CheckGameState = InitCheckGameState;
	DisplayEvent = DispEvent;
	SoldierSpawnEvent = SoldSpawnEvent;
	HideMenuEvent = HideEvent;
	RemoveMenuEvent = RemoveEvent;
	NavigationBackEvent = NavBackEvent;

	if (SoldierSpawnEvent != '' || DisplayEvent != ''){
		WorldInfo.RemoteEventListeners.AddItem(self);
	}

	if (DisplayEvent == ''){
		InterpTime = `HQINTERPTIME;

		if(bInstant)
		{
			InterpTime = 0;
		}

		class'UIUtilities'.static.DisplayUI3D(DisplayTag, name(CameraTag), InterpTime);
	}
	else
	{
		if(bIsIn3D) UIMovie_3D(Movie).HideAllDisplays();
	}

	Header = Spawn(class'UISoldierHeader', self).InitSoldierHeader(UnitRef, CheckGameState);

	if( bShowExtendedHeaderData )
		Header.ShowExtendedData();
	else
		Header.HideExtendedData();

	SetUnitReference(UnitRef);

	`XCOMGRI.DoRemoteEvent('CIN_HideArmoryStaff'); //Hide the staff in the armory so that they don't overlap with the soldiers

	if(bUseNavHelp)
	{
		if(XComHQPresentationLayer(Movie.Pres) != none)
			NavHelp = XComHQPresentationLayer(Movie.Pres).m_kAvengerHUD.NavHelp;
		else
			NavHelp = Movie.Pres.GetNavHelp();

		UpdateNavHelp();
	}

	List = Spawn(class'UIList', self).InitList('armoryMenuList');
	List.OnItemClicked = OnItemClicked;
	List.OnSelectionChanged = OnSelectionChanged;

	CreateSoldierPawn();
	PopulateData();
	//CheckForCustomizationPopup();
}

simulated function PopulateData()
{
	local bool bEnableImplantsOption, bEnableWeaponUpgradeOption, bInTutorialPromote;
	local TWeaponUpgradeAvailabilityData WeaponUpgradeAvailabilityData;
	local TPCSAvailabilityData PCSAvailabilityData;
	local string ImplantsTooltip, WeaponUpgradeTooltip, PromoteIcon, ImplantsOption, WeaponsOption;
	local XComGameState_Unit Unit;
	local UIListItemString ListItem;
	local StateObjectReference BondmateRef;
	local SoldierBond BondData;

	//super.PopulateData();

	List.ClearItems();

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID));

	bInTutorialPromote = !class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M2_WelcomeToArmory');

	// -------------------------------------------------------------------------------
	// Customize soldier: 
	Spawn(class'UIListItemString', List.ItemContainer).InitListItem(m_strCustomizeSoldier).SetDisabled(bInTutorialPromote, "");

	// -------------------------------------------------------------------------------
	// Loadout:
	Spawn(class'UIListItemString', List.ItemContainer).InitListItem(m_strLoadout).SetDisabled(bInTutorialPromote, "");


	// -------------------------------------------------------------------------------
	// PCS:
	class'UIUtilities_Strategy'.static.GetPCSAvailability(Unit, PCSAvailabilityData);

	if(!PCSAvailabilityData.bHasAchievedCombatSimsRank)
		ImplantsTooltip = m_strInsufficientRankForImplantsTooltip;
	else if(!PCSAvailabilityData.bCanEquipCombatSims)
		ImplantsTooltip = m_strCantEquiqPCSTooltip;
	else if( !PCSAvailabilityData.bHasCombatSimsSlotsAvailable )
		ImplantsTooltip = m_strCombatSimsSlotsFull;
	else if( !PCSAvailabilityData.bHasNeurochipImplantsInInventory )
		ImplantsTooltip = m_strNoImplantsTooltip;
	else if( !PCSAvailabilityData.bHasGTS )
		ImplantsTooltip = m_strNoGTSTooltip;

	bEnableImplantsOption = PCSAvailabilityData.bCanEquipCombatSims && PCSAvailabilityData.bHasAchievedCombatSimsRank && 
		PCSAvailabilityData.bHasNeurochipImplantsInInventory &&	PCSAvailabilityData.bHasGTS && !bInTutorialPromote;
	ImplantsOption = m_strImplants;
	
	ListItem = Spawn(class'UIListItemString', List.ItemContainer).InitListItem(ImplantsOption).SetDisabled(!bEnableImplantsOption, ImplantsTooltip);
	
	if( bEnableImplantsOption )
	{
		if( PCSAvailabilityData.bHasNeurochipImplantsInInventory && PCSAvailabilityData.bHasCombatSimsSlotsAvailable)
			ListItem.NeedsAttention(true);
		else
			ListItem.NeedsAttention(false);
	} 
	else
	{
		ListItem.NeedsAttention(false);
	}

	// -------------------------------------------------------------------------------
	// Customize Weapons:
	class'UIUtilities_Strategy'.static.GetWeaponUpgradeAvailability(Unit, WeaponUpgradeAvailabilityData);

	if( !WeaponUpgradeAvailabilityData.bHasModularWeapons )
		WeaponUpgradeTooltip = m_strNoModularWeaponsTooltip;
	else if( !WeaponUpgradeAvailabilityData.bCanWeaponBeUpgraded )
		WeaponUpgradeTooltip = m_strCannotUpgradeWeaponTooltip;
	else if( !WeaponUpgradeAvailabilityData.bHasWeaponUpgrades )
		WeaponUpgradeTooltip = m_strNoWeaponUpgradesTooltip;
	
	WeaponsOption = m_strCustomizeWeapon;

	bEnableWeaponUpgradeOption = WeaponUpgradeAvailabilityData.bHasModularWeapons && WeaponUpgradeAvailabilityData.bCanWeaponBeUpgraded && !bInTutorialPromote;
	ListItem = Spawn(class'UIListItemString', List.ItemContainer).InitListItem(WeaponsOption).SetDisabled(!bEnableWeaponUpgradeOption, WeaponUpgradeTooltip);
	
	if( WeaponUpgradeAvailabilityData.bHasWeaponUpgrades && WeaponUpgradeAvailabilityData.bHasWeaponUpgradeSlotsAvailable && WeaponUpgradeAvailabilityData.bHasModularWeapons)
		ListItem.NeedsAttention(true);
	else
		ListItem.NeedsAttention(false);

	// -------------------------------------------------------------------------------
	// Promotion:

	if(Unit.ShowPromoteIcon())
	{
		PromoteIcon = class'UIUtilities_Text'.static.InjectImage(class'UIUtilities_Image'.const.HTML_PromotionIcon, 20, 20, 0) $ " ";
		PromoteItem = Spawn(class'UIListItemString', List.ItemContainer).InitListItem(PromoteIcon $ m_strPromote);
	}
	else
	{
		PromoteItem = Spawn(class'UIListItemString', List.ItemContainer).InitListItem(m_strAbilities);
	}
		
	UpdatePromoteItem();

	// -------------------------------------------------------------------------------
	// Additional Abilities 
	Spawn(class'UIListItemString', List.ItemContainer).InitListItem(m_strAdditionalAbilities).SetDisabled(bInTutorialPromote, "");

	// -------------------------------------------------------------------------------
	// Propaganda
	Spawn(class'UIListItemString', List.ItemContainer).InitListItem(m_strPropaganda).SetDisabled((bInTutorialPromote || class'XComGameState_HeadquartersXCom'.static.AnyTutorialObjectivesInProgress()), "");

	// -------------------------------------------------------------------------------
	// Soldier Bonds:
	ListItem = Spawn(class'UIListItemString', List.ItemContainer).InitListItem(m_strSoldierBonds).SetDisabled((bInTutorialPromote || !Unit.GetSoldierClassTemplate().bCanHaveBonds), "");
	if( Unit.ShowBondAvailableIcon(BondmateRef, BondData) )
		ListItem.NeedsAttention(true);
	else
		ListItem.NeedsAttention(false);

	// -------------------------------------------------------------------------------
	// Dismiss: 

	Spawn(class'UIListItemString', List.ItemContainer).InitListItem(m_strDismiss).SetDisabled((bInTutorialPromote || class'XComGameState_HeadquartersXCom'.static.AnyTutorialObjectivesInProgress() || 
																							   !class'XComGameState_HeadquartersXCom'.static.LostAndAbandonedCompleted()), "");

	RefreshAbilitySummary();
	UpdateNavHelp();

	List.Navigator.SelectFirstAvailable();
}

simulated function RefreshAbilitySummary()
{
	local XComGameState_Unit Unit;
	local bool bHasTraits;

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID));
	if( bListingTraits )
	{
		bHasTraits = class'UIUtilities_Strategy'.static.PopulateAbilitySummary_Traits(self, Unit);

		if( !bHasTraits )
		{
			bHasTraits = class'UIUtilities_Strategy'.static.PopulateAbilitySummary(self, Unit);
		}
	}
	else
	{
		bHasTraits = class'UIUtilities_Strategy'.static.PopulateAbilitySummary(self, Unit);
	}
}

simulated function UpdateNavHelp()
{
	local int i;
	local string PrevKey, NextKey;
	local XGParamTag LocTag;
	local XComGameState_Unit Unit;

	//super.UpdateNavHelp();

	if(!bIsFocused)
		return; //bsg-crobinson (5.30.17): If not focused return

	if(bUseNavHelp)
	{
		NavHelp.ClearButtonHelp();

		if (CanCancel())
		{
			NavHelp.AddBackButton(OnCancel);
		}

		NavHelp.AddSelectNavHelp(); // bsg-jrebar (4/12/17): Moved Select Nav Help
		
		if(XComHQPresentationLayer(Movie.Pres) != none)
		{
			LocTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
			LocTag.StrValue0 = Movie.Pres.m_kKeybindingData.GetKeyStringForAction(PC.PlayerInput, eTBC_PrevUnit);
			PrevKey = `XEXPAND.ExpandString(PrevSoldierKey);
			LocTag.StrValue0 = Movie.Pres.m_kKeybindingData.GetKeyStringForAction(PC.PlayerInput, eTBC_NextUnit);
			NextKey = `XEXPAND.ExpandString(NextSoldierKey);

			// Don't allow jumping to the geoscape from the armory in the tutorial or when coming from squad select
			if (class'XComGameState_HeadquartersXCom'.static.GetObjectiveStatus('T0_M7_WelcomeToGeoscape') != eObjectiveState_InProgress &&
				RemoveMenuEvent == '' && NavigationBackEvent == '' && !`ScreenStack.IsInStack(class'UISquadSelect'))
			{
				NavHelp.AddGeoscapeButton();
			}

			if( Movie.IsMouseActive() && IsAllowedToCycleSoldiers() && class'UIUtilities_Strategy'.static.HasSoldiersToCycleThrough(UnitReference, CanCycleTo) )
			{
				NavHelp.SetButtonType("XComButtonIconPC");
				i = eButtonIconPC_Prev_Soldier;
				NavHelp.AddCenterHelp( string(i), "", PrevSoldier, false, PrevKey);
				i = eButtonIconPC_Next_Soldier; 
				NavHelp.AddCenterHelp( string(i), "", NextSoldier, false, NextKey);
				NavHelp.SetButtonType("");
			}
		}

		if (`ISCONTROLLERACTIVE && 
			XComHQPresentationLayer(Movie.Pres) != none && IsAllowedToCycleSoldiers() && 
			class'UIUtilities_Strategy'.static.HasSoldiersToCycleThrough(UnitReference, CanCycleTo) &&
			//<bsg> 5435, ENABLE_NAVHELP_DURING_TUTORIAL, DCRUZ, 2016/06/23
			//INS:
			class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M2_WelcomeToArmory'))
			//</bsg>
		{
			NavHelp.AddCenterHelp( m_strTabNavHelp, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_LBRB_L1R1);// bsg-jrebar (4/26/17): Armory UI consistency changes, centering buttons, fixing overlaps, removed button inlining
		}
		
		if( `ISCONTROLLERACTIVE )
			NavHelp.AddCenterHelp( m_strRotateNavHelp, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_RSTICK); // bsg-jrebar (4/26/17): Armory UI consistency changes, centering buttons, fixing overlaps, removed button inlining

		NavHelp.Show();
	}

	// If you don't have any traits, then we aren't going to show you toggle option at all. 

	Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID));
	if( Unit.AcquiredTraits.length == 0 ) return;

	if( bUseNavHelp )
	{
		if( XComHQPresentationLayer(Movie.Pres) != none )
		{	
			if( bListingTraits )
			{
				if( `ISCONTROLLERACTIVE )
					NavHelp.AddRightHelp(m_strToggleAbilities, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_X_SQUARE); // bsg-jrebar (05/19/17): Changing to X
				else
					NavHelp.AddRightHelp(m_strToggleAbilities, , ToggleAbilitiesAndTraits);
			}
			else
			{
				if( `ISCONTROLLERACTIVE )
					NavHelp.AddRightHelp(m_strToggleTraits, class'UIUtilities_Input'.static.GetGamepadIconPrefix() $ class'UIUtilities_Input'.const.ICON_X_SQUARE); // bsg-jrebar (05/19/17): Changing to X
				else
					NavHelp.AddRightHelp(m_strToggleTraits, , ToggleAbilitiesAndTraits);
			}
		}
	}
}

simulated function ToggleAbilitiesAndTraits()
{
	if( bUseNavHelp )
	{
		bListingTraits = !bListingTraits; 
		RefreshAbilitySummary();
		UpdateNavHelp();
	}
}

simulated function UpdatePromoteItem()
{
	if(GetUnit().GetRank() < 1 && !GetUnit().CanRankUpSoldier())
	{
		PromoteItem.SetDisabled(true, m_strRookiePromoteTooltip);
	}
}

simulated function CheckForCustomizationPopup()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_Unit UnitState;

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ(true);
	if(XComHQ != none)
	{
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID));
		if (!XComHQ.bHasSeenCustomizationsPopup && UnitState.IsVeteran())
		{
			`HQPRES.UISoldierCustomizationsAvailable();
		}
	}
}

simulated function OnReceiveFocus()
{
	//super.OnReceiveFocus();

	bIsFocused = true;

	if(bHideOnLoseFocus)
		Show();

	if( bShowExtendedHeaderData )
		Header.ShowExtendedData();
	else
		Header.HideExtendedData();

	UpdateNavHelp();
	MoveCosmeticPawnOnscreen();

	PopulateData();
	CreateSoldierPawn();
	UpdatePromoteItem();
	//if(!bIsHotlinking)
		//CheckForCustomizationPopup();
	Header.PopulateData();
}

simulated function OnAccept()
{
	local XComGameState_Unit UnitState;
	local XComGameState_HeadquartersXCom XComHQ;
	local XComHQPresentationLayer HQPres;
	local UIArmory_AdditionalAbilities AdditionalScreen;

	if( UIListItemString(List.GetSelectedItem()).bDisabled )
	{
		`XSTRATEGYSOUNDMGR.PlaySoundEvent("Play_MenuClickNegative");
		return;
	}

	XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
	HQPres = XComHQPresentationLayer(Movie.Pres);

	// Index order matches order that elements get added in 'PopulateData'
	switch( List.selectedIndex )
	{
	case 0: // CUSTOMIZE
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID));
		Movie.Pres.UICustomize_Menu(UnitState, ActorPawn);
		break;
	case 1: // LOADOUT
		if( HQPres != none )    
			HQPres.UIArmory_Loadout(UnitReference);
		break;
	case 2: // NEUROCHIP IMPLANTS
		if( HQPres != none && XComHQ.HasCombatSimsInInventory() )
		{		
			if(HQPres.ScreenStack.IsNotInStack(class'UIInventory_Implants_Replacement'))
				HQPres.ScreenStack.Push( Spawn(class'UIInventory_Implants_Replacement', self), HQPres.Get3DMovie() );
		
			//`HQPRES.UIInventory_Implants();
		}
		break;
	case 3: // WEAPON UPGRADE
		// Release pawn so it can get recreated when the screen receives focus
		ReleasePawn();
		if( HQPres != none && XComHQ.bModularWeapons )
			HQPres.UIArmory_WeaponUpgrade(UnitReference);
		break;
	case 4: // PROMOTE
		if( HQPres != none && GetUnit().GetRank() >= 1 || GetUnit().CanRankUpSoldier() || GetUnit().HasAvailablePerksToAssign() )
			HQPres.UIArmory_Promotion(UnitReference);
		break;
	case 5: // ADDITIONAL ABILITIES
		if( HQPres != none && GetUnit().GetRank() >= 1 )
		{
			AdditionalScreen = UIArmory_AdditionalAbilities(HQPres.ScreenStack.Push(HQPres.Spawn(class'UIArmory_AdditionalAbilities', HQPres), HQPres.Get3DMovie()));
			AdditionalScreen.InitPromotion(UnitReference, false);
		}
		break;
	case 6:
		if (HQPres != none)
			HQPres.UIArmory_Photobooth(UnitReference);
		break;
	case 7: // Soldier bonds 
		if( HQPres != none )
			HQPres.UISoldierBonds(UnitReference);
		break;
	case 8: // DISMISS
		OnDismissUnit();
		break;
	}
	`XSTRATEGYSOUNDMGR.PlaySoundEvent("Play_MenuSelect");
}

simulated function OnItemClicked(UIList ContainerList, int ItemIndex)
{
	OnAccept();
}

simulated function OnSelectionChanged(UIList ContainerList, int ItemIndex)
{
	local XComGameState_Unit UnitState;
	local string Description, CustomizeDesc;
	
	// Index order matches order that elements get added in 'PopulateData'
	switch(ItemIndex)
	{
	case 0: // CUSTOMIZE
		UnitState = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID));
		CustomizeDesc = UnitState.GetMyTemplate().strCustomizeDesc;
		Description = CustomizeDesc != "" ? CustomizeDesc : m_strCustomizeSoldierDesc;
		break;
	case 1: // LOADOUT
		Description = m_strLoadoutDesc;
		break;
	case 2: // NEUROCHIP IMPLANTS
		Description = m_strImplantsDesc;
		break;
	case 3: // WEAPON UPGRADE
		Description = m_strCustomizeWeaponDesc;
		break;
	case 4: // PROMOTE
		Description = m_strPromoteDesc;
		break;
	case 5: // ADDITIONAL ABILITIES
		Description = m_strAdditionalDesc;
		break;
	case 6: // PROPAGANDA
		Description = m_strPropagandaDesc;
		break;
	case 7: // SOLDIER BONDS
		Description = m_strSoldierBondsDesc;
		break;
	case 8: // DISMISS
		Description = m_strDismissDesc;
		break;
	}

	MC.ChildSetString("descriptionText", "htmlText", class'UIUtilities_Text'.static.AddFontInfo(Description, bIsIn3D));
}

simulated function OnDismissUnit()
{
	local XGParamTag        kTag;
	local TDialogueBoxData  DialogData;

	kTag = XGParamTag(`XEXPANDCONTEXT.FindTag("XGParam"));
	kTag.StrValue0 = GetUnit().GetName(eNameType_Full);
	
	DialogData.eType       = eDialog_Warning;
	DialogData.strTitle	= m_strDismissDialogTitle;
	DialogData.strText     = `XEXPAND.ExpandString(m_strDismissDialogDescription); 
	DialogData.fnCallback  = OnDismissUnitCallback;

	DialogData.strAccept = class'UIUtilities_Text'.default.m_strGenericYes;
	DialogData.strCancel = class'UIUtilities_Text'.default.m_strGenericNo;

	Movie.Pres.UIRaiseDialog(DialogData);
}

simulated public function OnDismissUnitCallback(Name eAction)
{
	local XComGameState_HeadquartersXCom XComHQ;

	if( eAction == 'eUIAction_Accept' )
	{
		XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
		XComHQ.FireStaff(UnitReference);
		OnCancel();
	}
}

simulated function XComGameState_Unit GetUnit()
{
	if(CheckGameState != none)
		return XComGameState_Unit(CheckGameState.GetGameStateForObjectID(UnitReference.ObjectID));
	else
		return XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID));
}

//==============================================================================

simulated function OnCancel()
{
	if(class'XComGameState_HeadquartersXCom'.static.IsObjectiveCompleted('T0_M2_WelcomeToArmory'))
	{
		super.OnCancel();
	}
}

simulated function OnRemoved()
{
	super.OnRemoved();
	//`HQPRES.m_kAvengerHUD.NavHelp.ClearButtonHelp();
}

//==============================================================================

simulated function bool OnUnrealCommand(int cmd, int arg)
{
	// bsg-jrebar (5/23/17): Added error handling and replaced ti use X button
	local XComGameState_Unit Unit;
	

	if ( !CheckInputIsReleaseOrDirectionRepeat(cmd, arg) )
		return false;

	switch( cmd )
	{
	case class'UIUtilities_Input'.const.FXS_BUTTON_X :
		// If you don't have any traits, then we aren't going to show you toggle option at all. 
		Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(UnitReference.ObjectID));

		if( Unit.AcquiredTraits.length >= 0 ) 
			ToggleAbilitiesAndTraits(); 
		return true; 
	}

	return super.OnUnrealCommand(cmd, arg);
	// bsg-jrebar (5/23/17): end
}

defaultproperties
{
	LibID = "ArmoryMenuScreenMC";
	DisplayTag = "UIBlueprint_ArmoryMenu";
	CameraTag = "UIBlueprint_ArmoryMenu";

	bShowExtendedHeaderData = true;
	bListingTraits = true; 

	height = 1200;
}