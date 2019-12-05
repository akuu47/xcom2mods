class RM_X2AchievementTracker extends Object;

// Singleton creation / access of XComGameState_DLC_Day90AchievementData.
static function RM_XComGameState_AchievementData GetAchievementData(XComGameState NewGameState)
{
	local RM_XComGameState_AchievementData AchievementData;

	AchievementData = RM_XComGameState_AchievementData(class'XComGameStateHistory'.static.GetGameStateHistory().GetSingleGameStateObjectForClass(class'RM_XComGameState_AchievementData', true));
	if (AchievementData == none)
	{
		AchievementData = RM_XComGameState_AchievementData(NewGameState.CreateStateObject(class'RM_XComGameState_AchievementData'));
	}
	else
	{
		AchievementData = RM_XComGameState_AchievementData(NewGameState.CreateStateObject(class'RM_XComGameState_AchievementData', AchievementData.ObjectID));
	}
	NewGameState.AddStateObject(AchievementData);

	return AchievementData;
}



static function EventListenerReturn OnKillMail(Object EventData, Object EventSource, XComGameState NewGameState, Name EventID)
{
	//local XComGameStateContext_Ability AbilityContext;
	//local XComGameState_Unit SourceUnit, KilledUnit;
	//local X2AbilityTemplate AbilityTemplate;
	//local MAS_API_AchievementName AchievementName;
	//local name CharacterGroupName;
	//local XComGameState_Unit KilledUnitStartOfChain;
	//local int iStartIndex;
//
	//if (NewGameState.GetContext().InterruptionStatus == eInterruptionStatus_Interrupt)
	//{
		//return ELR_NoInterrupt;
	//}
//
	////iStartIndex = `XCOMHISTORY.GetEventChainStartIndex();
//
	//AbilityContext = XComGameStateContext_Ability(NewGameState.GetContext());
	//iStartIndex = AbilityContext.AssociatedState.HistoryIndex - 1;
	//SourceUnit = XComGameState_Unit(EventSource);
	//KilledUnit = XComGameState_Unit(EventData);
	//
	//AbilityTemplate = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager().FindAbilityTemplate(AbilityContext.InputContext.AbilityTemplateName);
	//if (AbilityTemplate != none && AbilityTemplate.IsMelee())
	//{
		//if (SourceUnit != none && KilledUnit != none)	
		//{
			//CharacterGroupName = KilledUnit.GetMyTemplate().CharacterGroupName;
			//if (SourceUnit.GetMyTemplateName() == 'SparkSoldier' && CharacterGroupName == 'Berserker')
			//{
				//AchievementName = new class'MAS_API_AchievementName';
				//AchievementName.AchievementName = 'RM_BerserkerStrike';
				//`XEVENTMGR.TriggerEvent('UnlockAchievement', AchievementName );
			//}
		//}
	//}
//
	//if (AbilityTemplate != none && SourceUnit != none && KilledUnit != none)
	//{
		//if(AbilityTemplate.DataName == 'Suppression')
		//{
			//AchievementName = new class'MAS_API_AchievementName';
			//AchievementName.AchievementName = 'RM_MayhemKill';
			//`XEVENTMGR.TriggerEvent('UnlockAchievement', AchievementName );	
		//}
		//if(AbilityTemplate.DataName == 'RMGrimyCloseCombat')
		//{
			//AchievementName = new class'MAS_API_AchievementName';
			//AchievementName.AchievementName = 'RM_CloseCombat';
			//`XEVENTMGR.TriggerEvent('UnlockAchievement', AchievementName );	
		//}
	//}
//
	return ELR_NoInterrupt;
}


// Catches the end of a mission
static function EventListenerReturn OnTacticalGameEnd(Object EventData, Object EventSource, XComGameState GameState, Name EventID)
{
	//local XComGameState_Unit Unit;
	//local XComGameState_HeadquartersXCom XComHQ;
	//local int i;
	//local bool AllSPARK;
	//local MAS_API_AchievementName AchNameObj;
	//local XComGameState_BattleData BattleData;	
	//local XComGameStateHistory History;
//
	//History = `XCOMHISTORY;
//
//
	//BattleData = XComGameState_BattleData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_BattleData'));
//
	//XComHQ = class'UIUtilities_Strategy'.static.GetXComHQ();
//
	//AllSPARK = true;
//
	//for (i = 0; i < XComHQ.Squad.Length; ++i) 
	//{
	//Unit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectId(XComHQ.Squad[i].ObjectID));
//
		//if(Unit.ObjectID == 0) //and just to double double check, if we get an objectID of 0, we'll tell the game to flat out ignore it
		//{
			//continue;
		//}
//
		//if(!Unit.IsRobotic())
		//{
		//AllSPARK = false;
		//break;
		//}
//
	//}
//
	//if(AllSPARK && BattleData.bLocalPlayerWon)
	//{
		//AchNameObj = new class'MAS_API_AchievementName'; 
		//AchNameObj.AchievementName = 'RM_AllSPARKTeam'; 
		//`XEVENTMGR.TriggerEvent('UnlockAchievement', AchNameObj);
	//}
//
	return ELR_NoInterrupt;
}