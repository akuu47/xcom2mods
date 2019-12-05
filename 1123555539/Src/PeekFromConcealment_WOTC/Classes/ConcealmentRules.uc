class ConcealmentRules extends Object config (ConcealmentPeeking);

var config bool HideInHighCover;
var config bool HideWithHeightAdvantage;
var config int NumGraceTiles;
var config int ExtraDetectionRange;
var config int MinEligibleDetectionRange;

// Determines whether (ThisUnit) is, when concealed, visible to (OtherUnit).
static function bool IsVisible(XComGameState_Unit ThisUnitState, XComGameState_Unit OtherUnitState, GameRulesCache_VisibilityInfo VisibilityInfoFromOtherUnit)
{
	local float ConcealmentDetectionDistance;

	// not visible when in high cover relative to the viewer unit
	if (default.HideInHighCover && VisibilityInfoFromOtherUnit.TargetCover == CT_Standing) {
		return false; 
	}
	
	// not visible when in any cover + height advantage to the other unit
	if (default.HideWithHeightAdvantage && ThisUnitState.HasHeightAdvantageOver(OtherUnitState, false) && VisibilityInfoFromOtherUnit.TargetCover != CT_None) {
		return false; 
	}

	// need to be within detection range.
	ConcealmentDetectionDistance = ThisUnitState.GetConcealmentDetectionDistance(OtherUnitState);
	return VisibilityInfoFromOtherUnit.DefaultTargetDist <= Square(ConcealmentDetectionDistance);
}

static function ModifyTemplate(X2CharacterTemplate CharTemplate)
{
	if (CharTemplate.CharacterBaseStats[eStat_DetectionRadius] >= default.MinEligibleDetectionRange) {
		`LOG("Buffing detection range of " @ CharTemplate.DataName);
		CharTemplate.CharacterBaseStats[eStat_DetectionRadius] += default.ExtraDetectionRange;
	}
}