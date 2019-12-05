class X2TargetingMethod_NoSnapBlasterLauncher extends X2TargetingMethod_BlasterLauncher;

simulated protected function Vector GetSplashRadiusCenter()
{
	local vector Center;

	Center = NewTargetLocation;

	return Center;
}

function Update(float DeltaTime)
{
	local array<Actor> CurrentlyMarkedTargets;
	local array<TTile> Tiles;

	NewTargetLocation = Cursor.GetCursorFeetLocation();

	if( NewTargetLocation != CachedTargetLocation )
	{		
		GetTargetedActors(NewTargetLocation, CurrentlyMarkedTargets, Tiles);
		CheckForFriendlyUnit(CurrentlyMarkedTargets);	
		MarkTargetedActors(CurrentlyMarkedTargets, (!AbilityIsOffensive) ? FiringUnit.GetTeam() : eTeam_None );
		DrawSplashRadius();
		DrawAOETiles(Tiles);
	}

	super.Update(DeltaTime);
}