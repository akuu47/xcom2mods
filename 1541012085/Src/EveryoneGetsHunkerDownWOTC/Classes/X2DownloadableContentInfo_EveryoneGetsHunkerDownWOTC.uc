class X2DownloadableContentInfo_EveryoneGetsHunkerDownWOTC extends X2DownloadableContentInfo config(AllowedUnitsNames);

var config array<name> AllowedUnitsNames;

static event OnPostTemplatesCreated() {
   local int iIndex;

   for ( iIndex = 0; iIndex < default.AllowedUnitsNames.Length; iIndex++ ) {
      AddHunkerDownIfMissing(default.AllowedUnitsNames[iIndex]);
   }
}

static function AddHunkerDownIfMissing( name UnitNameToModify ) {
   local X2CharacterTemplateManager            AllCharacters;
   local X2CharacterTemplate                   CurrentUnit;
   local name                                  TempName;

   AllCharacters = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
   CurrentUnit = AllCharacters.FindCharacterTemplate(UnitNameToModify);
   if ( CurrentUnit == none ) {
       `log("Called with invalid template: " $ UnitNameToModify,,'AddHunkerDown');
      return;
   }

   // Aliens/Advent/Civs only.
   if ( !(CurrentUnit.bIsAdvent == true || CurrentUnit.bIsAlien == true || CurrentUnit.bIsCivilian == true ) ) {
       `log("Not ADVENT/Alien/Civilian, invalid template: " $ UnitNameToModify,,'AddHunkerDown');
      return;
   }

   // Can't take cover, don't waste my time.
   if ( CurrentUnit.bCanTakeCover == false ) {
       `log("Unit cannot take cover, no modification done: " $ UnitNameToModify,,'AddHunkerDown');
	  return;
   }

   foreach CurrentUnit.Abilities ( TempName ) {
   	if ( TempName == 'HunkerDown' || TempName == 'HunkerDownNoAnim' ) {
	      // Already has, don't waste my time.
          `log("Unit already has Hunker Down: " $ UnitNameToModify,,'AddHunkerDown');
		   return;
	   }
   }

   if ( CurrentUnit.bIsAdvent == true ) {
      // Regular Hunker Down
      CurrentUnit.Abilities.RemoveItem('HunkerDown'); // Prevents Duplication if validation failed
      CurrentUnit.Abilities.AddItem('HunkerDown');
      `log("Patched ADVENT: " $ UnitNameToModify,,'AddHunkerDown');
   }

   if ( CurrentUnit.bIsAlien == true ) {
      // Special Hunker Down with no animation
      CurrentUnit.Abilities.RemoveItem('HunkerDown'); // Prevents Duplication if validation failed, also removes normal Hunker
	   CurrentUnit.Abilities.AddItem('HunkerDownNoAnim');
      `log("Patched ALIEN: " $ UnitNameToModify,,'AddHunkerDown');
   }
}