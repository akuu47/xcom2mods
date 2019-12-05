//---------------------------------------------------------------------------------------
//  CLASS:    X2AbilityTemplate_Lib
//  AUTHOR:  Mr. Nice
//           
//---------------------------------------------------------------------------------------

class X2AbilityTemplate_Lib extends X2AbilityTemplate;

static function RemoveTargetEffect(X2AbilityTemplate Template, int i, optional int j=1)
{
	Template.AbilityTargetEffects.Remove(i, j);
}