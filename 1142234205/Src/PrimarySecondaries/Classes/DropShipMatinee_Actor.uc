class DropShipMatinee_Actor extends Actor;

struct native UnitToMatineeGroupMapping
{
	var name GroupName; // matinee group that will control unit
	var XComGameState_Unit Unit; // a unit you want to show up in the matinee
};

var int LatestPatchedStreamingMaps;

var string AnimSequencePrefix;
var string PatchAnimsetPathPrimaryMelee;
var string PatchAnimsetPathPrimaryPistol;
var string PatchAnimsetPathPrimaryAutoPistol;

// approach: every time the number of streaming maps changes, we re-check the Matinees
// since we the character added a new pod reveal action
auto state Waiting
{
	Begin:
		while (true)
		{
			if (LatestPatchedStreamingMaps != `MAPS.NumStreamingMaps() && `MAPS.IsStreamingComplete())
			{
				LatestPatchedStreamingMaps = `MAPS.NumStreamingMaps();
				`log("New number of streaming maps:" @ LatestPatchedStreamingMaps, class'X2DownloadableContentInfo_PrimarySecondaries'.default.bLog, name("PrimarySecondaries" @ default.Class.name));
				PatchAllLoadedMatinees();
			}
			Sleep(0.1f);
		}
}

static function PatchAllLoadedMatinees()
{
	local array<SequenceObject> FoundMatinees;
	local array<string> PackageNames;
	local SequenceObject MatineeObject;
	local Sequence GameSeq;
 
	GameSeq = class'WorldInfo'.static.GetWorldInfo().GetGameSequence();
	GameSeq.FindSeqObjectsByClass(class'SeqAct_Interp', true, FoundMatinees);

	foreach FoundMatinees(MatineeObject)
	{
		ParseStringIntoArray(PathName(MatineeObject), PackageNames, ".", true);

		if (PackageNames[0] == "CIN_SkyrangerIntros")
		{
			`LOG(PackageNames[0] @ MatineeObject.ObjComment, class'X2DownloadableContentInfo_PrimarySecondaries'.default.bLog, name("PrimarySecondaries" @ default.Class.name));
			PatchSingleMatinee(SeqAct_Interp(MatineeObject));
		}
	}
}

static function PatchSingleMatinee(SeqAct_Interp SeqInterp)
{
	local InterpData Data;
	local InterpGroup Group;
	local InterpTrack Track;
	local InterpTrackAnimControl AnimControl;
	local int KeyIndex, UnitMapIndex;
	local array<UnitToMatineeGroupMapping> UnitMapping;
	local array<name> PatchSequenceNames;
	local AnimSet PatchAnimset;
	local AnimSequence Sequence;

	UnitMapping = GetUnitMapping();
	Data = InterpData(SeqInterp.VariableLinks[0].LinkedVariables[0]);
	
	foreach Data.InterpGroups(Group)
	{
		UnitMapIndex = UnitMapping.Find('GroupName', Group.GroupName);
		//`LOG(Group.GroupName, class'X2DownloadableContentInfo_PrimarySecondaries'.default.bLog, Class.name);
		if (UnitMapIndex != INDEX_NONE)
		{
			if(!class'X2DownloadableContentInfo_PrimarySecondaries'.static.HasPrimaryMeleeOrPistolEquipped(UnitMapping[UnitMapIndex].Unit))
			{
				`LOG(UnitMapping[UnitMapIndex].GroupName @ UnitMapping[UnitMapIndex].Unit.GetFullName() @ "!HasPrimaryMeleeOrPistolEquipped, skipping patch", class'X2DownloadableContentInfo_PrimarySecondaries'.default.bLog, name("PrimarySecondaries" @ default.Class.name));
				continue;
			}

			if(class'X2DownloadableContentInfo_PrimarySecondaries'.static.HasPrimaryMeleeEquipped(UnitMapping[UnitMapIndex].Unit))
			{
				`LOG(UnitMapping[UnitMapIndex].GroupName @ UnitMapping[UnitMapIndex].Unit.GetFullName() @ "!HasPrimaryMeleeEquipped", class'X2DownloadableContentInfo_PrimarySecondaries'.default.bLog, name("PrimarySecondaries" @ default.Class.name));
				PatchAnimset = AnimSet(`CONTENT.RequestGameArchetype(default.PatchAnimsetPathPrimaryMelee));
			}

			if(class'X2DownloadableContentInfo_PrimarySecondaries'.static.HasPrimaryPistolEquipped(UnitMapping[UnitMapIndex].Unit))
			{
				if (X2WeaponTemplate(UnitMapping[UnitMapIndex].Unit.GetItemInSlot(eInvSlot_PrimaryWeapon).GetMyTemplate()).WeaponCat == 'pistol')
				{
					`LOG(UnitMapping[UnitMapIndex].GroupName @ UnitMapping[UnitMapIndex].Unit.GetFullName() @ "HasPrimaryPistolEquipped", class'X2DownloadableContentInfo_PrimarySecondaries'.default.bLog, name("PrimarySecondaries" @ default.Class.name));
					PatchAnimset = AnimSet(`CONTENT.RequestGameArchetype(default.PatchAnimsetPathPrimaryPistol));
				}
				else if (X2WeaponTemplate(UnitMapping[UnitMapIndex].Unit.GetItemInSlot(eInvSlot_PrimaryWeapon).GetMyTemplate()).WeaponCat == 'sidearm')
				{
					`LOG(UnitMapping[UnitMapIndex].GroupName @ UnitMapping[UnitMapIndex].Unit.GetFullName() @ "HasPrimaryAutoPistolEquipped", class'X2DownloadableContentInfo_PrimarySecondaries'.default.bLog, name("PrimarySecondaries" @ default.Class.name));
					PatchAnimset = AnimSet(`CONTENT.RequestGameArchetype(default.PatchAnimsetPathPrimaryAutoPistol));
				}
			}

			PatchSequenceNames.Length = 0;

			foreach PatchAnimset.Sequences(Sequence)
			{
				PatchSequenceNames.AddItem(name(Repl(Sequence.SequenceName, default.AnimSequencePrefix, "")));
				`LOG("Adding" @ name(Repl(Sequence.SequenceName, default.AnimSequencePrefix, "")), class'X2DownloadableContentInfo_PrimarySecondaries'.default.bLog, name("PrimarySecondaries" @ default.Class.name));
			}

			Group.GroupAnimSets.AddItem(PatchAnimset);

			foreach Group.InterpTracks(Track)
			{
				AnimControl = InterpTrackAnimControl(Track);
				if (AnimControl != none)
				{
					for (KeyIndex = 0; KeyIndex <= AnimControl.AnimSeqs.Length; KeyIndex++)
					{
						if (PatchSequenceNames.Find(AnimControl.AnimSeqs[KeyIndex].AnimSeqName) != INDEX_NONE)
						{
							AnimControl.AnimSeqs[KeyIndex].AnimSeqName = name(default.AnimSequencePrefix $ AnimControl.AnimSeqs[KeyIndex].AnimSeqName);
							`LOG("Patching" @ Group.GroupName @ UnitMapping[UnitMapIndex].Unit.GetFullName() @ AnimControl.AnimSeqs[KeyIndex].AnimSeqName, class'X2DownloadableContentInfo_PrimarySecondaries'.default.bLog, name("PrimarySecondaries" @ default.Class.name));
						}
						else
						{
							`LOG("Could NOT find" @ Group.GroupName @ AnimControl.AnimSeqs[KeyIndex].AnimSeqName @ "in patch list", class'X2DownloadableContentInfo_PrimarySecondaries'.default.bLog, name("PrimarySecondaries" @ default.Class.name));
						}
					}
				}
			}
		}
	}
}

//***
// Mostly copied from X2Action_DropshipIntro.AddUnitsToMatinee
static function array<UnitToMatineeGroupMapping> GetUnitMapping()
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameStateHistory History;
	local XComGameState_Unit GameStateUnit;
	local StateObjectReference UnitRef;
	local array<UnitToMatineeGroupMapping> UnitMapping;
	local UnitToMatineeGroupMapping NewMapping;
	local int UnitIndex;

	History = `XCOMHISTORY;

	XComHQ = XComGameState_HeadquartersXCom(History.GetSingleGameStateObjectForClass(class'XComGameState_HeadquartersXCom'));
	if(XComHQ != none)
	{
		// normally, we can grab the xcom squad and add just those soldiers. This prevents VIPS and others from being added to the dropship
		UnitIndex = 1;
		foreach XComHQ.Squad(UnitRef)
		{
			if (UnitRef.ObjectID != 0) //Empty slots may be present in the squad as a 0 entry.
			{
				GameStateUnit = XComGameState_Unit(History.GetGameStateForObjectID(UnitRef.ObjectID));
				if (GameStateUnit != none)
				{
					if(!GameStateUnit.bMissionProvided)
					{
						NewMapping.GroupName = name(GameStateUnit.GetMyTemplate().strIntroMatineeSlotPrefix $ UnitIndex);
						NewMapping.Unit = GameStateUnit;
						UnitMapping.AddItem(NewMapping);
						UnitIndex++;
						//`LOG("Adding" @ GameStateUnit.GetFullName() @ "to unit mapping" @ NewMapping.GroupName, class'X2DownloadableContentInfo_PrimarySecondaries'.default.bLog, Class.name);
					}
				}
			}
		}
	}

	return UnitMapping;
}

defaultproperties
{
	AnimSequencePrefix="PS_"
	PatchAnimsetPathPrimaryMelee="PrimarySecondaries_PrimaryMelee.Anims.AS_Skyranger"
	PatchAnimsetPathPrimaryPistol="PrimarySecondaries_Pistol.Anims.AS_Skyranger"
	PatchAnimsetPathPrimaryAutoPistol="PrimarySecondaries_AutoPistol.Anims.AS_Skyranger"
}