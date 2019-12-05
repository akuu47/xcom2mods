class X2Condition_EverVigilant_FogFix_JFB extends X2Condition;

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit SourceUnit, TargetUnit;
	local XComGameState_AIGroup GroupState;
	local XComGameState NewGameState;
   
    // Normally since we only inject it in Overwatch, the source SHOULD be the same as the target.
	SourceUnit = XComGameState_Unit(kSource);
	TargetUnit = XComGameState_Unit(kTarget);

	if (SourceUnit == none || TargetUnit == none) {
		return 'AA_NotAUnit';
	}

	// We don't care about XCOM, always allow them here. Resistance too.
	// Do it explicitly to be extra sure.
	if ( SourceUnit != none ) {
	   if ( SourceUnit.GetTeam() == eTeam_XCOM ) {
	      return 'AA_Success';
	   }
	   if ( SourceUnit.GetTeam() == eTeam_Resistance ) {
	      return 'AA_Success';
	   }
	   if ( SourceUnit.GetMyTemplate().bIsChosen == true ) {
	      return 'AA_Success';
	   }
	}
	if ( TargetUnit != none ) {
	   if (  TargetUnit.GetTeam() == eTeam_XCOM ) {
	      return 'AA_Success';
	   }
	   if ( TargetUnit.GetTeam() == eTeam_Resistance ) {
	      return 'AA_Success';
	   }
	   if ( SourceUnit.GetMyTemplate().bIsChosen == true ) {
	      return 'AA_Success';
	   }
	}

   GroupState = SourceUnit.GetGroupMembership();
   NewGameState = `XCOMHISTORY.GetGameStateFromHistory();

   // Unrevealed AIs will look at Overwatch and think it's not available. I thought the Unit Is Concealed error was the most logical, but you'll never see it.
   if( GroupState != none ) {
      GroupState = XComGameState_AIGroup(NewGameState.CreateStateObject(class'XComGameState_AIGroup', GroupState.ObjectID));
	  if ( GroupState.bProcessedScamper == false ) {
         return 'AA_UnitIsConcealed';
	  }
   }

   // Anyone else is allowed.
   return 'AA_Success';
}