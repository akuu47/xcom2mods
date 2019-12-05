// Courtesy of Xcom2modding reddit
// Load PerkContents via this class PostBeginPlay
class X2Effect_LoadPerks extends X2Effect;

var array<name> AbilitiesToLoad;

protected simulated function OnEffectAdded (const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
    local XComContentManager        Content;
    local XComUnitPawnNativeBase    UnitPawnNativeBase;
    local name n;

    Content = `CONTENT;
    UnitPawnNativeBase = XGUnit(XComGameState_Unit(kNewTargetState).GetVisualizer()).GetPawn();

    Content.BuildPerkPackageCache();
    foreach AbilitiesToLoad(n) {
        Content.CachePerkContent(n);
        Content.AppendAbilityPerks(n, UnitPawnNativeBase);
    }
}