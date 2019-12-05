class X2Ability_SlagAndMelta extends X2Ability config(SlagAndMelta);

var config WeaponDamageValue SLAG_BONUS_DAMAGE;
var config int SLAG_TRIGGER_CHANCE;
var config int SLAG_BURN_DAMAGE_PER_TICK;
var config int SLAG_BURN_DAMAGE_PER_TICK_SPREAD;

var config array<int> MELTA_BONUS_PIERCE;
var config array<int> MELTA_BONUS_CRIT;

var config bool SLAG_IS_CROSS_CLASS_COMPATIBLE;
var config bool MELTA_IS_CROSS_CLASS_COMPATIBLE;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Create_SlagAbility());
	Templates.AddItem(Create_SlagAbility_Passive());

	Templates.AddItem(Create_MeltaAbility());

	return Templates;
}

static function X2AbilityTemplate Create_SlagAbility_Passive()
{
	local X2AbilityTemplate	Template;
	local X2Effect_Singe	SingeEffect;

	Template = PurePassive('IRI_SlagAbility_Passive', "img:///IRI_SlagAndMelta.perk_Slag", default.SLAG_IS_CROSS_CLASS_COMPATIBLE);

	SingeEffect = new class'X2Effect_Singe';
	SingeEffect.BuildPersistentEffect(1, true);
	Template.AddTargetEffect(SingeEffect);

	Template.AdditionalAbilities.AddItem('IRI_SlagAbility');

	return Template;
}

static function X2AbilityTemplate Create_SlagAbility()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_SlagAbility');

	Template.IconImage = "img:///IRI_SlagAndMelta.perk_Slag";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	//	Singe is triggered by an Event Listener registered in X2Effect_Singe
	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	//	putting the burn effect first so it visualizes correctly
	Template.AddTargetEffect(class'X2StatusEffects'.static.CreateBurningStatusEffect(default.SLAG_BURN_DAMAGE_PER_TICK, default.SLAG_BURN_DAMAGE_PER_TICK_SPREAD));

	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	WeaponDamageEffect.bIgnoreBaseDamage = true;
	WeaponDamageEffect.bAllowFreeKill = false;
	WeaponDamageEffect.bAllowWeaponUpgrade = false;
	WeaponDamageEffect.bAppliesDamage = false;
	WeaponDamageEffect.EffectDamageValue = default.SLAG_BONUS_DAMAGE;
	Template.AddTargetEffect(WeaponDamageEffect);

	Template.FrameAbilityCameraType = eCameraFraming_Never; 
	Template.bSkipExitCoverWhenFiring = true;
	Template.bSkipFireAction = true;	//	this fire action will be merged by Merge Vis function
	Template.bShowActivation = true;
	Template.bUsesFiringCamera = false;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = Singe_MergeVisualization;
	Template.BuildInterruptGameStateFn = none;

	return Template;
}

// Merge the Singe Vis Tree with Triggering Shot Vis Tree
function Singe_MergeVisualization(X2Action BuildTree, out X2Action VisualizationTree)
{
	local XComGameStateVisualizationMgr		VisMgr;
	local array<X2Action>					arrActions;
	local X2Action_MarkerTreeInsertBegin	MarkerStart;
	local X2Action_MarkerTreeInsertEnd		MarkerEnd;
	local X2Action							WaitAction;
	local X2Action_MarkerNamed				MarkerAction;
	local XComGameStateContext_Ability		AbilityContext;
	local VisualizationActionMetadata		ActionMetadata;
	local bool bFoundHistoryIndex;
	local int i;

	/*
	`LOG("BuildTree fn start!",, 'IRISINGE');
	`LOG("_________________________",, 'IRISINGE');

	PrintActionRecursive(BuildTree, 0);

	`LOG("_________________________",, 'IRISINGE');
	`LOG("VisualizationTree start!",, 'IRISINGE');
	`LOG("_________________________",, 'IRISINGE');

	PrintActionRecursive(VisualizationTree, 0);

	`LOG("_________________________",, 'IRISINGE');
	`LOG("Merge vis fn finish!",, 'IRISINGE');*/

	VisMgr = `XCOMVISUALIZATIONMGR;
	
	// Find the start of the Singe's Vis Tree
	MarkerStart = X2Action_MarkerTreeInsertBegin(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertBegin'));
	AbilityContext = XComGameStateContext_Ability(MarkerStart.StateChangeContext);

	//	Find all Fire Actions in the Triggering Shot's Vis Tree
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_Fire', arrActions);

	//	Cycle through all of them to find the Fire Action we need, which will have the same History Index as specified in Singe's Context, which gets set in the Event Listener
	for (i = 0; i < arrActions.Length; i++)
	{
		if (arrActions[i].StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
		{
			bFoundHistoryIndex = true;
			break;
		}
	}
	//	If we didn't find the correct action, we call the failsafe Merge Vis Function, which will make both Singe's Target Effects apply seperately after the ability finishes.
	//	Looks bad, but at least nothing is broken.
	if (!bFoundHistoryIndex)
	{
		AbilityContext.SuperMergeIntoVisualizationTree(BuildTree, VisualizationTree);
		return;
	}

	//`LOG("Num of Fire Actions: " @ arrActions.Length,, 'IRISINGE');

	//	Add a Wait For Effect Action after the Triggering Shot's Fire Action. This will allow Singe's Effects to visualize the moment the Triggering Shot connects with the target.
	AbilityContext = XComGameStateContext_Ability(arrActions[i].StateChangeContext);
	ActionMetaData = arrActions[i].Metadata;
	WaitAction = class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetaData, AbilityContext,, arrActions[i]);

	//	Insert the Singe's Vis Tree right after the Wait For Effect Action
	VisMgr.ConnectAction(MarkerStart, VisualizationTree,, WaitAction);

	//	Main part of Merge Vis is done, now we just tidy up the ending part. As I understood from MrNice, this is necessary to make sure Vis will look fine if Fire Action ends before Singe finishes visualizing
	//	which tbh sounds like a super edge case, but okay
	//	Find all marker actions in the Triggering Shot Vis Tree.
	VisMgr.GetNodesOfType(VisualizationTree, class'X2Action_MarkerNamed', arrActions);

	//	Cycle through them and find the 'Join' Marker that comes after the Triggering Shot's Fire Action.
	for (i = 0; i < arrActions.Length; i++)
	{
		MarkerAction = X2Action_MarkerNamed(arrActions[i]);

		if (MarkerAction.MarkerName == 'Join' && MarkerAction.StateChangeContext.AssociatedState.HistoryIndex == AbilityContext.DesiredVisualizationBlockIndex)
		{
			//	Grab the last Action in the Singe Vis Tree
			MarkerEnd = X2Action_MarkerTreeInsertEnd(VisMgr.GetNodeOfType(BuildTree, class'X2Action_MarkerTreeInsertEnd'));

			//	TBH can't imagine circumstances where MarkerEnd wouldn't exist, but okay
			if (MarkerEnd != none)
			{
				//	"tie the shoelaces". Vis Tree won't move forward until both Singe Vis Tree and Triggering Shot's Fire action are not fully visualized.
				VisMgr.ConnectAction(MarkerEnd, VisualizationTree,,, MarkerAction.ParentActions);
				VisMgr.ConnectAction(MarkerAction, BuildTree,, MarkerEnd);
			}
			else
			{
				//	not sure what this does
				VisMgr.GetAllLeafNodes(BuildTree, arrActions);
				VisMgr.ConnectAction(MarkerAction, BuildTree,,, arrActions);
			}

			//VisMgr.ConnectAction(MarkerAction, VisualizationTree,, MarkerEnd);
			break;
		}
	}
}
/*
static function PrintActionRecursive(X2Action Action, int iLayer)
{
	local X2Action ChildAction;

	`LOG("Action layer: " @ iLayer @ ": " @ Action.Class.Name,, 'IRISINGE'); 
	foreach Action.ChildActions(ChildAction)
	{
		PrintActionRecursive(ChildAction, iLayer + 1);
	}
}*/
/*
static function ReparentActionRecursive(X2Action Action, X2Action NewParentAction, XComGameStateVisualizationMgr VisMgr, out X2Action VisualizationTree)
{
	local X2Action ChildAction;

	foreach Action.ChildActions(ChildAction)
	{
		ReparentActionRecursive(ChildAction, NewParentAction, VisMgr, VisualizationTree);

		VisMgr.DisconnectAction(Action);
		VisMgr.ConnectAction(Action, VisualizationTree,, NewParentAction);
	}
}*/

static function EventListenerReturn AbilityTriggerEventListener_Slag(Object EventData, Object EventSource, XComGameState GameState, Name EventID, Object CallbackData)
{
	local XComGameStateContext_Ability	AbilityContext;
	local XComGameState_Ability			AbilityState, SlagAbilityState;
	local XComGameState_Unit			SourceUnit, TargetUnit;
	local XComGameStateContext			FindContext;
    local int							VisualizeIndex;
	local XComGameStateHistory			History;
	local X2AbilityTemplate				AbilityTemplate;
	local X2Effect						Effect;
	local X2AbilityMultiTarget_BurstFire	BurstFire;
	local bool bDealsDamage;
	local int NumShots;
	local int i;

	History = `XCOMHISTORY;

	AbilityState = XComGameState_Ability(EventData);	// Ability State that triggered this Event Listener
	SourceUnit = XComGameState_Unit(EventSource);
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext());
	TargetUnit = XComGameState_Unit(GameState.GetGameStateForObjectID(AbilityContext.InputContext.PrimaryTarget.ObjectID));
	AbilityTemplate = AbilityState.GetMyTemplate();

	if (AbilityState != none && SourceUnit != none && TargetUnit != none && AbilityTemplate != none && AbilityContext.InputContext.ItemObject.ObjectID != 0)
	{	
		//	try to find Singe ability on the source weapon of the same ability
		SlagAbilityState = XComGameState_Ability(History.GetGameStateForObjectID(SourceUnit.FindAbility('IRI_SlagAbility', AbilityContext.InputContext.ItemObject).ObjectID));

		//	if this is an offensive ability that actually hit the enemy, the same weapon has a Singe ability, and the enemy is still alive
		if (SlagAbilityState != none && AbilityContext.IsResultContextHit() && AbilityState.GetMyTemplate().Hostility == eHostility_Offensive && TargetUnit.IsAlive())
		{
			//	check if the ability deals damage
			foreach AbilityTemplate.AbilityTargetEffects(Effect)
			{
				if (X2Effect_ApplyWeaponDamage(Effect) != none)
				{
					bDealsDamage = true;
					break;
				}
			}
			if (bDealsDamage)
			{
				//	account for abilities like Fan Fire and Cyclic Fire that take multiple shots within one ability activation
				NumShots = 1;
				BurstFire = X2AbilityMultiTarget_BurstFire(AbilityTemplate.AbilityMultiTargetStyle);
				if (BurstFire != none)
				{
					NumShots += BurstFire.NumExtraShots;
				}
				//	
				for (i = 0; i < NumShots; i++)
				{
					// Triggering ability if it passes a chance check
					if (`SYNC_RAND_STATIC(100) < default.SLAG_TRIGGER_CHANCE)
					{
						//	pass the Visualize Index to the Context for later use by Merge Vis Fn
						VisualizeIndex = GameState.HistoryIndex;
						FindContext = AbilityContext;
						while (FindContext.InterruptionHistoryIndex > -1)
						{
							FindContext = History.GetGameStateFromHistory(FindContext.InterruptionHistoryIndex).GetContext();
							VisualizeIndex = FindContext.AssociatedState.HistoryIndex;
						}
						//`LOG("Singe activated by: " @ AbilityState.GetMyTemplateName() @ "from: " @ AbilityState.GetSourceWeapon().GetMyTemplateName() @ "Singe source weapon: " @ SlagAbilityState.GetSourceWeapon().GetMyTemplateName(),, 'IRISINGE');
						SlagAbilityState.AbilityTriggerAgainstSingleTarget(AbilityContext.InputContext.PrimaryTarget, false, VisualizeIndex);
					}
				}
			}
		}
	}
	return ELR_NoInterrupt;
}


/*
struct native AvailableAction
{
	var StateObjectReference AbilityObjectRef;
	var array<AvailableTarget> AvailableTargets;
	var int AvailableTargetCurrIndex;				//  points to which of the target we are targeting at right now.
	var bool bFreeAim;                          //  if this is true, targets will change based on cursor location.
	var name AvailableCode;     //  if this is anything except 'AA_Success', the ability can't be used.
	var EAbilityIconBehavior eAbilityIconBehaviorHUD;   //  store off whether this ability should be shown in the HUD.
	var bool bInputTriggered;                   //  true if this ability is 'active' IE - it is triggered by player input.
	var int ShotHUDPriority;                    // this number is used to sort the icon position in the Ability Container in Tactical HUD.

	structcpptext
	{
		FAvailableAction() 
		{
			appMemzero(this, sizeof(FAvailableAction));
		}

		FAvailableAction(EEventParm)
		{
			appMemzero(this, sizeof(FAvailableAction));
		}
	}
};
*/

static function X2AbilityTemplate Create_MeltaAbility()
{
	local X2AbilityTemplate	Template;
	local X2Effect_Melta	MeltaEffect;
	
	Template = PurePassive('IRI_MeltaAbility', "img:///IRI_SlagAndMelta.perk_Melta", default.MELTA_IS_CROSS_CLASS_COMPATIBLE);

	MeltaEffect = new class'X2Effect_Melta';
	//MeltaEffect.BurnEffect = ;
	MeltaEffect.BuildPersistentEffect(1, true);
	Template.AddTargetEffect(MeltaEffect);

	return Template;
}