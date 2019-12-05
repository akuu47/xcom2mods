//---------------------------------------------------------------------------------------
//  FILE:    XMBConfig.uc
//  AUTHOR:  xylthixlm
//
//  This file declares config variables for XModBase, as well as data which is needed
//  by various parts.
//
//  INSTALLATION
//
//  Copy all the files in XModBase_Core_2_0_0/Classes/, XModBase_Interfaces/Classes/,
//  and LW_Tuple/Classes/ into similarly named directories under Src/.
//
//  DO NOT EDIT THIS FILE. This class is shared with other mods that use XModBase. If
//  you change this file, your mod will become incompatible with any other mod using
//  XModBase.
//---------------------------------------------------------------------------------------
class XMBConfig extends Object config(GameCore);

///////////////////
// CONFIGURATION //
///////////////////

// These configuration variables go in the [XModBase_Core_2_0_0.XMBConfig] section of
// XComGameCore.ini. Note that if you upgrade your mod to a newer version of XModBase, the name of
// the configuration section will change.

var config array<name> AllSoldierAbilitySet;	// List of names of abilities that will be given to all soldiers.
var config array<name> UniversalAbilitySet;		// List of names of abilities that will be given to ALL units, including enemies.
var config array<name> ExtraUnitConditions;		// List of X2Condition classes that only care about the unit. This is used to
												// distinguish ability target conditions which really are about the unit from
												// conditions which are actually about the ability itself.
var config array<name> GtsUnlocks;				// Extra GTS unlocks


//////////
// DATA //
//////////

var const array<name> UnitConditions;			// List of X2Condition classes that only care about the unit.

var const array<name> m_aCharStatTags;

defaultproperties
{
	// These define the mapping between ability tags in XComGame.int and stats.
	m_aCharStatTags[0]=Invalid
	m_aCharStatTags[1]=UtilityItems
	m_aCharStatTags[2]=HP
	m_aCharStatTags[3]=ToHit				// Offense
	m_aCharStatTags[4]=Defense
	m_aCharStatTags[5]=Mobility
	m_aCharStatTags[6]=Will
	m_aCharStatTags[7]=Hacking
	m_aCharStatTags[8]=SightRadius
	m_aCharStatTags[9]=FlightFuel
	m_aCharStatTags[10]=AlertLevel
	m_aCharStatTags[11]=BackpackSize
	m_aCharStatTags[12]=Dodge
	m_aCharStatTags[13]=ArmorChance
	m_aCharStatTags[14]=ArmorMitigation
	m_aCharStatTags[15]=ArmorPiercing
	m_aCharStatTags[16]=PsiOffense
	m_aCharStatTags[17]=HackDefense
	m_aCharStatTags[18]=DetectionRadius
	m_aCharStatTags[19]=DetectionModifier
	m_aCharStatTags[20]=Crit				// CritChance
	m_aCharStatTags[21]=Strength
	m_aCharStatTags[22]=SeeMovement
	m_aCharStatTags[23]=HearingRadius
	m_aCharStatTags[24]=CombatSims
	m_aCharStatTags[25]=FlankingCritChance
	m_aCharStatTags[26]=ShieldHP
	m_aCharStatTags[27]=Job
	m_aCharStatTags[28]=FlankingAimBonus

	// Do not edit this array! If you think you want to, instead add an element to 
	// ExtraUnitConditions in XComGameCore.ini, section [XModBase_Core_2_0_0.XMBConfig].
	UnitConditions[0]=X2Condition_BattleState
	UnitConditions[1]=X2Condition_GameTime
	UnitConditions[2]=X2Condition_HasGrappleLocation
	UnitConditions[3]=X2Condition_MapProperty
	UnitConditions[4]=X2Condition_OnGroundTile
	UnitConditions[5]=X2Condition_Panic
	UnitConditions[6]=X2Condition_PanicOnPod
	UnitConditions[7]=X2Condition_PlayerTurns
	UnitConditions[8]=X2Condition_Stealth
	UnitConditions[9]=X2Condition_UnblockedNeighborTile
	UnitConditions[10]=X2Condition_UnitActionPoints
	UnitConditions[11]=X2Condition_UnitEffects
	UnitConditions[12]=X2Condition_UnitImmunities
	UnitConditions[13]=X2Condition_UnitInEvacZone
	UnitConditions[14]=X2Condition_UnitInventory
	UnitConditions[15]=X2Condition_UnitType
	UnitConditions[16]=X2Condition_UnitValue
	UnitConditions[17]=X2Condition_ValidUnburrowTile
	UnitConditions[18]=XMBCondition_Dead
}