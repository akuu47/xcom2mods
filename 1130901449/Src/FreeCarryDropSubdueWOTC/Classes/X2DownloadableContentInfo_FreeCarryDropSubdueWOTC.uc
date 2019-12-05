class X2DownloadableContentInfo_FreeCarryDropSubdueWOTC extends X2DownloadableContentInfo config(FreeUnitCarryAndDrop);

var config bool DROP_TOTALLY_FREE;
var config bool PICKUP_TOTALLY_FREE;
var config bool SUBDUE_TOTALLY_FREE;

var config int DROP_ACTION_POINTS;
var config int PICKUP_ACTION_POINTS;
var config int SUBDUE_ACTION_POINTS;

var config bool SUBDUE_BREAKS_CONCEALMENT;

static event OnPostTemplatesCreated() {
   local X2AbilityTemplateManager            AllAbilities;
   local X2AbilityTemplate                   CurrentAbility;
   local X2AbilityCost_ActionPoints          ActionPointCost;

   AllAbilities  = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
   
   ActionPointCost = new class'X2AbilityCost_ActionPoints';

   // Drop Unit free
   CurrentAbility = AllAbilities.FindAbilityTemplate('PutDownUnit');
   CurrentAbility.AbilityCosts.Length = 0;
   ActionPointCost.iNumPoints = default.DROP_ACTION_POINTS;
   ActionPointCost.bConsumeAllPoints = false;
   ActionPointCost.bFreeCost = default.DROP_TOTALLY_FREE;
   CurrentAbility.AbilityCosts.AddItem(ActionPointCost);
   CurrentAbility.ConcealmentRule = eConceal_Always;

   // Carry Unit free
   CurrentAbility = AllAbilities.FindAbilityTemplate('CarryUnit');
   CurrentAbility.AbilityCosts.Length = 0;
   ActionPointCost.iNumPoints = default.PICKUP_ACTION_POINTS;
   ActionPointCost.bConsumeAllPoints = false;
   ActionPointCost.bFreeCost = default.PICKUP_TOTALLY_FREE;
   CurrentAbility.AbilityCosts.AddItem(ActionPointCost);
   CurrentAbility.ConcealmentRule = eConceal_Always;

   // Subdue free
   CurrentAbility = AllAbilities.FindAbilityTemplate('Knockout');
   CurrentAbility.AbilityCosts.Length = 0;
   ActionPointCost = new class'X2AbilityCost_ActionPoints';
   ActionPointCost.iNumPoints = default.SUBDUE_ACTION_POINTS;
   ActionPointCost.bConsumeAllPoints = false;
   ActionPointCost.bFreeCost = default.SUBDUE_TOTALLY_FREE;
   CurrentAbility.AbilityCosts.AddItem(ActionPointCost);
   CurrentAbility.ConcealmentRule = eConceal_Always;
}