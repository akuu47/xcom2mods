//---------------------------------------------------------------------------------------
//  FILE:    X2DownloadableContentInfo_*.uc
//  AUTHOR:  Ryan McFall
//
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_WotC_Armory_GripFix_BTR extends X2DownloadableContentInfo config(DLC_ArmoryGripFix_BTR);

struct RifleGripStruct
{
	var name TemplateName;
	var string PawnAnimset;
	var string PawnAnimsetFemale;
	var bool IsReaperWeapon;
	var bool IsSkirmisherWeapon;
	var string PawnAnimSetOverrideMale;
	var string PawnAnimSetOverrideFemale;

	structdefaultproperties
	{
		PawnAnimset="";
		PawnAnimsetFemale="";
		PawnAnimSetOverrideMale="";
		PawnAnimSetOverrideFemale="";
		IsReaperWeapon=false;
		IsSkirmisherWeapon=false;
	}

};

var config bool bLog;

var config array<RifleGripStruct> RifleGrips;

static function UpdateAnimations(out array<AnimSet> CustomAnimSets, XComGameState_Unit UnitState, XComUnitPawn Pawn)
{
	local RifleGripStruct Template;
	local int index;

	if (!UnitState.IsSoldier())
		return;

	index = default.RifleGrips.Find('TemplateName', UnitState.GetPrimaryWeapon().GetMyTemplateName());
	if (index != INDEX_NONE)
	{
		Template = default.RifleGrips[index];
		if (UnitState.kAppearance.iGender == eGender_Female)
		{
			if (UnitState.GetMyTemplateName() == 'ReaperSoldier' && Template.IsReaperWeapon)
			{
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("HQArmory_Soldier_Master_ANIM.Anims.AS_Soldier_BattleRifle_M14_Armory_Fem")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_RifleGrip_Master_ANIM.Anims.AS_Soldier")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_RifleGrip_Master_ANIM.Anims.AS_ReaperShadow")));
			}
			else if (UnitState.GetMyTemplateName() == 'SkirmisherSoldier' && Template.IsSkirmisherWeapon)
			{
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("HQArmory_Soldier_Master_ANIM.Anims.AS_Soldier_BattleRifle_M14_Armory_Fem")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_RifleGrip_Master_ANIM.Anims.AS_Soldier")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Skirmisher_RifleGrip_Master_ANIM.Anims.AS_Skirmisher")));
			}
			else
			{
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("HQArmory_Soldier_Master_ANIM.Anims.AS_Soldier_BattleRifle_M14_Armory_Fem")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_RifleGrip_Master_ANIM.Anims.AS_Soldier")));
			}
			//`LOG(default.Class @ GetFuncName() @ "Adding Cannon.Anims.AS_Soldier_Female",, 'WotC_Armory_GripFix_BattleRifles');
		}
		else
		{
			if (UnitState.GetMyTemplateName() == 'ReaperSoldier' && Template.IsReaperWeapon)
			{
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("HQArmory_Soldier_Master_ANIM.Anims.AS_Soldier_BattleRifle_M14_Armory")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_RifleGrip_Master_ANIM.Anims.AS_Soldier")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_RifleGrip_Master_ANIM.Anims.AS_ReaperShadow")));
			}
			else if (UnitState.GetMyTemplateName() == 'SkirmisherSoldier' && Template.IsSkirmisherWeapon)
			{
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("HQArmory_Soldier_Master_ANIM.Anims.AS_Soldier_BattleRifle_M14_Armory")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_RifleGrip_Master_ANIM.Anims.AS_Soldier")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Skirmisher_RifleGrip_ANIM.Anims.AS_Skirmisher")));
			}
			else
			{
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("HQArmory_Soldier_Master_ANIM.Anims.AS_Soldier_BattleRifle_M14_Armory")));
				CustomAnimSets.AddItem(AnimSet(`CONTENT.RequestGameArchetype("Soldier_RifleGrip_Master_ANIM.Anims.AS_Soldier")));
			}

			//`LOG(default.Class @ GetFuncName() @ "Adding Cannon.Anims.AS_Soldier",, 'WotC_Armory_GripFix_BattleRifles');
		}
	}
}

static function WeaponInitialized(XGWeapon WeaponArchetype, XComWeapon Weapon, optional XComGameState_Item ItemState=none)
{
	Local XComGameState_Item InternalWeaponState;
	Local RifleGripStruct Template;
	local int Index;

	InternalWeaponState = ItemState;

	if (InternalWeaponState == none)
	{
		InternalWeaponState = XComGameState_Item(`XCOMHISTORY.GetGameStateForObjectID(WeaponArchetype.ObjectID));
	}


	Index = default.RifleGrips.Find('TemplateName', InternalWeaponState.GetMyTemplateName());
	if (Index != INDEX_NONE)
	{
		Template = default.RifleGrips[Index];

		if (Template.PawnAnimset != "")
		{
			Weapon.CustomUnitPawnAnimsets.Length = 0;
			Weapon.CustomUnitPawnAnimsets.AddItem(AnimSet(`CONTENT.RequestGameArchetype(Template.PawnAnimset)));
			
			if (Template.PawnAnimSetOverrideMale != "")
				Weapon.CustomUnitPawnAnimsets.AddItem(AnimSet(`CONTENT.RequestGameArchetype(Template.PawnAnimSetOverrideMale)));
		}

		if (Template.PawnAnimsetFemale != "")
		{
			Weapon.CustomUnitPawnAnimsetsFemale.Length = 0;
			Weapon.CustomUnitPawnAnimsetsFemale.AddItem(AnimSet(`CONTENT.RequestGameArchetype(Template.PawnAnimsetFemale)));
			
			if (Template.PawnAnimSetOverrideFemale != "")
				Weapon.CustomUnitPawnAnimsetsFemale.AddItem(AnimSet(`CONTENT.RequestGameArchetype(Template.PawnAnimSetOverrideFemale)));
		}

		//SkeletalMeshComponent(Weapon.Mesh).AnimSets[0].TrackBoneNames.RemoveItem('Reargrip');
		//SkeletalMeshComponent(Weapon.Mesh).AnimSets[0].TrackBoneNames.RemoveItem('Foregrip');
	}

}

static function MatineeGetPawnFromSaveData(XComUnitPawn UnitPawn, XComGameState_Unit UnitState, XComGameState SearchState)
{
	class'CAShellMapMatinee'.static.PatchAllLoadedMatinees(UnitPawn, UnitState, SearchState);
}

public static function bool HasWeaponEquipped(XComGameState_Unit UnitState, optional XComGameState CheckGameState)
{
	return (default.RifleGrips.Find('TemplateName', UnitState.GetItemInSlot(eInvSlot_PrimaryWeapon, CheckGameState).GetMyTemplateName()) != INDEX_NONE);
}

