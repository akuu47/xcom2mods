class UITacticalHUD_MoreAbilityIcons extends UITacticalHUD_AbilityContainer;

var array<UItacticalHUD_NestedAbilities> AdditionalPanel;

var int LastActiveAbilitities;

simulated function int GetNumberOfAbilityItems()
{
	return MAX_NUM_ABILITIES * (AdditionalPanel.Length + 1);
}

simulated private function SpawnNestedContainer()
{
	local int i, index;
	local UITacticalHUD_Ability kItem;

	index = AdditionalPanel.Length;
	AdditionalPanel.AddItem(ParentPanel.Spawn(class'UItacticalHUD_NestedAbilities', ParentPanel));

	AdditionalPanel[index].ParentPane = self;
	AdditionalPanel[index].ShiftIndex = MAX_NUM_ABILITIES * (index + 1);
	AdditionalPanel[index].MCName = name("AbilityContainerMC" $ (index + 2));
	AdditionalPanel[index].InitPanel();

	for(i = 0; i < MAX_NUM_ABILITIES; ++i)
	{	
		kItem = AdditionalPanel[index].Spawn(class'UITacticalHUD_Ability', AdditionalPanel[index]);
		kItem.InitAbilityItem(name("AbilityItem_" $ i));
		m_arrUIAbilities.AddItem(kItem);
	}

	AdditionalPanel[index].Hide();
}

simulated function UITacticalHUD_AbilityContainer InitAbilityContainer()
{
	local int i;
	local UITacticalHUD_Ability kItem;

	InitPanel();

	// Pre-cache UI data array
	for(i = 0; i < MAX_NUM_ABILITIES; ++i)
	{	
		kItem = Spawn(class'UITacticalHUD_Ability', self);
		kItem.InitAbilityItem(name("AbilityItem_" $ i));
		m_arrUIAbilities.AddItem(kItem);
	}

	SpawnNestedContainer();

	return self;
}

simulated function PopulateFlash()
{
	local int i, len, lastX;
	local AvailableAction AvailableActionInfo; //Represents an action that a unit can perform. Usually tied to an ability.
	local XComGameState_Ability AbilityState;
	local X2AbilityTemplate AbilityTemplate;
	local UITacticalHUD_AbilityTooltip TooltipAbility;

	if (!bAbilitiesInited)
	{
		bAbilitiesInited = true;
		for (i = 0; i < m_arrUIAbilities.Length; i++)
		{
			if (!m_arrUIAbilities[i].bIsInited)
			{
				bAbilitiesInited = false;
				return;
			}
		}
	}

	if (!bIsInited)
	{
		return;
	}

	if (m_arrAbilities.Length < 0)
	{
		return;
	}

	//Process the number of abilities, verify that it does not violate UI assumptions
	len = m_arrAbilities.Length;

	while (len > GetNumberOfAbilityItems())
	{
		SpawnNestedContainer();
		//`log("NOT ENOUGH ABILITIES, SPAWNING MORE... NEW:" @ GetNumberOfAbilityItems(),, 'Ability30');
	}

	ActiveAbilities = 0;
	for( i = 0; i < len; i++ )
	{
		if (i >= m_arrAbilities.Length)
		{
			m_arrUIAbilities[i].ClearData();
			continue;
		}
		AvailableActionInfo = m_arrAbilities[i];

		AbilityState = XComGameState_Ability( `XCOMHISTORY.GetGameStateForObjectID(AvailableActionInfo.AbilityObjectRef.ObjectID));
		AbilityTemplate = AbilityState.GetMyTemplate();
		
		if (AbilityTemplate.bCommanderAbility)
		{
			m_arrUIAbilities[i].ClearData();

			continue;
		}
		if(!AbilityTemplate.bCommanderAbility)
		{
			m_arrUIAbilities[ActiveAbilities].UpdateData(ActiveAbilities, AvailableActionInfo);
			ActiveAbilities++;
		}
	}

	LastActiveAbilitities = ActiveAbilities;
	
	mc.FunctionNum("SetNumActiveAbilities", min(ActiveAbilities, MAX_NUM_ABILITIES));
	if (ActiveAbilities > MAX_NUM_ABILITIES)
	{
		if (ActiveAbilities % MAX_NUM_ABILITIES >= MAX_NUM_ABILITIES_PER_ROW || ActiveAbilities % MAX_NUM_ABILITIES == 0)
		{
			// move the icon full width
			lastX = 640;
		}
		else
		{
			// move the icon based on remainder
			lastX = 940 - ((ActiveAbilities % MAX_NUM_ABILITIES_PER_ROW) * 20);
		}

		lastX -= (300 * ((ActiveAbilities - 1) / MAX_NUM_ABILITIES));

		SetPosition(lastX, 1010);
		RealizeLocation();
		//`log("Base ability bar moved to " @ lastX,,'Ability30');
		for ( i = 0; i < AdditionalPanel.Length; i++ )
		{
			if (ActiveAbilities - (MAX_NUM_ABILITIES * (i + 1)) > 0)
			{
				AdditionalPanel[i].mc.FunctionNum("SetNumActiveAbilities", min(ActiveAbilities - (MAX_NUM_ABILITIES * (i + 1)), MAX_NUM_ABILITIES));
				//`log("Additionalability[" $ i $ "] is now visible",,'Ability30');
				//`log("has" @ min(ActiveAbilities - (15 * (i + 1)), 15) @ "abilities",,'Ability30');
				lastX = lastX + 660;
				AdditionalPanel[i].SetPosition(lastX, 1010);
				//`log("X=" @ lastX,,'Ability30');
				AdditionalPanel[i].RealizeLocation();
				AdditionalPanel[i].Show();
			}
			else
			{
				AdditionalPanel[i].mc.FunctionNum("SetNumActiveAbilities", 0);
				AdditionalPanel[i].Hide();
			}
		}
	}
	else
	{
		for ( i = 0; i < AdditionalPanel.Length; i++ )
		{
			AdditionalPanel[i].mc.FunctionNum("SetNumActiveAbilities", 0);
			AdditionalPanel[i].Hide();
		}
	}
	
	if (ActiveAbilities > MAX_NUM_ABILITIES_PER_ROW)
	{
		UITacticalHUD(Owner).m_kShotHUD.MC.FunctionVoid("AbilityOverrideAnimateIn");
		UITacticalHUD(Owner).m_kEnemyTargets.MC.FunctionBool("SetMultirowAbilities", true);
		UITacticalHUD(Owner).m_kEnemyPreview.MC.FunctionBool("SetMultirowAbilities", true);
	}
	else
	{
		UITacticalHUD(Owner).m_kShotHUD.MC.FunctionVoid("AbilityOverrideAnimateOut");
		UITacticalHUD(Owner).m_kEnemyTargets.MC.FunctionBool("SetMultirowAbilities", false);
		UITacticalHUD(Owner).m_kEnemyPreview.MC.FunctionBool("SetMultirowAbilities", false);
	}

	//bsg-jneal (3.2.17): set the gamepadIcon where we populate flash
	if(`ISCONTROLLERACTIVE)
	{
		mc.FunctionString("SetHelp", class'UIUtilities_Input'.const.ICON_RT_R2);
	}

	Show();
	// Refresh the ability tooltip if it's open
	TooltipAbility = UITacticalHUD_AbilityTooltip(Movie.Pres.m_kTooltipMgr.GetChildByName('TooltipAbility'));
	if(TooltipAbility != none && TooltipAbility.bIsVisible)
		TooltipAbility.RefreshData();
}

simulated function CycleAbilitySelectionRow(int step)
{
	local int index;
	local int totalStep;

	// Ignore if index was never set (e.g. nothing was populated.)
	if (m_iCurrentIndex == -1)
		return;

	totalStep = step;
	do
	{
		index = m_iCurrentIndex;
		index = (ActiveAbilities + (index + (totalStep * MAX_NUM_ABILITIES_PER_ROW_BAR))) % ActiveAbilities;

		if (index >= ActiveAbilities)
		{
			index = ActiveAbilities - 1;
		}

		while (IsCommmanderAbility(index) && index >= 0)
		{
			index--;
		}

		totalStep += step;
	}
	until(index >= 0 && index < ActiveAbilities);

	if(index != m_iCurrentIndex && index >= 0 && index < ActiveAbilities )
	{
		ResetMouse();
		SelectAbility( index );
	}
}

simulated function RefreshTutorialShine(optional bool bIgnoreMenuStatus = false)
{	
	local int i;
	
	if( !`REPLAY.bInTutorial ) return; 

	for( i = 0; i < m_arrUIAbilities.Length; ++i )
	{
		m_arrUIAbilities[i].RefreshShine(bIgnoreMenuStatus);
	}
}

//simulated function XComGameState_Ability GetCurrentSelectedAbility()
//{ 
	//if( m_iCurrentIndex == -1 )
		//return none;
	//else
		//return super(UITacticalHUD_AbilityContainer).GetAbilityAtIndex(m_iCurrentIndex);
//}
//
//// Override tooltips
//simulated function XComGameState_Ability GetAbilityAtIndex( int AbilityIndex )
//{
	//local AvailableAction       AvailableActionInfo;
	//local XComGameState_Ability AbilityState;
	////local UITacticalHUD_AbilityTooltip Tooltip;
////
	////Tooltip = UITacticalHUD_AbilityTooltip(`SCREENSTACK.GetFirstInstanceOf(class'UITacticalHUD_Tooltips').GetCHildByName('TooltipAbility', false));
	////if (Tooltip != none && InStr(Tooltip.currentPath, 'AbilityContainerMC2') > INDEX_NONE)
	////{
		////AbilityIndex += 15;
	////}
//
	//if( AbilityIndex < 0 || AbilityIndex >= m_arrAbilities.Length )
	//{
		//`warn("Attempt to get ability with illegal index: '" $ AbilityIndex $ "', numAbilities: '" $ m_arrAbilities.Length $ "'.");
		//return none;
	//}
//
	//AvailableActionInfo = m_arrAbilities[AbilityIndex];
	//AbilityState = XComGameState_Ability(`XCOMHISTORY.GetGameStateForObjectID(AvailableActionInfo.AbilityObjectRef.ObjectID));
	//`assert(AbilityState != none);
	//return AbilityState; 
//}


// November 15 - Targeting bug fixed
//simulated function array<AvailableTarget> SortTargets(array<AvailableTarget> AvailableTargets)
//{	
	//// Currently Sorting the enemies list so it doesn't match the order in X2TargetingMethod causes the targeting to bug out, so we are reverting that.
	//return AvailableTargets;
//}

//simulated function Show()
//{
	//local int iconMove;
	//iconMove = (LastActiveAbilitities % 15) * 20;
	//AdditionalPanel.SetPosition(1300 - iconMove, 1025);
	//if (LastActiveAbilitities > 15)
	//{
		//SetPosition(640 - iconMove, 1025);
		//`log("Base ability bar moved to " @ 640 - iconMove,,'Ability30');
	//}
	//super.Show();
//}