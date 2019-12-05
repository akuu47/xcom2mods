// This is an Unreal Script
class XComPathingPawn_PeekFix extends XComPathingPawn_GA;


function protected UpdatePathMarkers() {
	// validate concealment breaking markers
	// don't bother doing anything if the vanilla game doesn't think we are breaking concealment.
	if (ConcealmentMarkers.Length > 0) {
		ConcealmentMarkers.Length = 0;

		class'PeekFixUtility'.static.MakeConcealmentMarkers(self, ConcealmentMarkers);
	}

	Super.UpdatePathMarkers();
}