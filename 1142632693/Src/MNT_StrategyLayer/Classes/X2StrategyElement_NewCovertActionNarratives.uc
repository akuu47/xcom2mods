//----------------------------------------------------------------------------------------------------------------
// I know I know, but I couldn't get any of these to show up if I placed them in any localized files...
//-----------------------------------------------------------------------------------------------------------------

class X2StrategyElement_NewCovertActionNarratives extends X2StrategyElement;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	local X2CovertActionNarrativeTemplate Template, Template2, Template3;

	`CREATE_X2TEMPLATE(class'X2CovertActionNarrativeTemplate', Template, 'CAN_LearnWeaponMastery_Skirmishers');
	Template.AssociatedFaction='Faction_Skirmishers';
	Template.ActionImage="img:///UILibrary_XPACK_StrategyImages.CovertOp_findskirmisher";
	Template.ActionName="Trial of the Skirmishers";
	Template.ActionPreNarrative="You wish to learn from us the art of war? You needed not ask - we will gladly work hand in hand to impart our proficiency with our valued allies.";
	Template.ActionPostNarrative="The bravery of your troops is always commendable. We send them back knowing that the full support of the Skirmishers are at their back, should they wish it.";
	Templates.AddItem(Template);
	
	`CREATE_X2TEMPLATE(class'X2CovertActionNarrativeTemplate', Template2, 'CAN_LearnWeaponMastery_Reapers');
	Template2.AssociatedFaction='Faction_Reapers';
	Template2.ActionImage="img:///UILibrary_XPACK_StrategyImages.CovertOp_findreaper";
	Template2.ActionName="Way of the Reaper";
	Template2.ActionPreNarrative="Interested in learning the ways of the Reaper? Ha! Send your guys our way - we'll see if they're up to snuff.";
	Template2.ActionPostNarrative="That should be useful right? Your troops are welcome amongst the Reapers anytime.";
	Templates.AddItem(Template2);

	`CREATE_X2TEMPLATE(class'X2CovertActionNarrativeTemplate', Template3, 'CAN_LearnWeaponMastery_Templars');
	Template3.AssociatedFaction='Faction_Templars';
	Template3.ActionImage="img:///UILibrary_XPACK_StrategyImages.CovertOp_findtemplar";
	Template3.ActionName="Path of the Templar";
	Template3.ActionPreNarrative="The true battle methods of my followers? In light of your continued assistance, our ways of battle are open to your soldiers, should they wish it.";
	Template3.ActionPostNarrative="Our quest proved fruitful - your soldiers are now Templars in all but name.";
	Templates.AddItem(Template3);

	return Templates;
}


//---------------------------------------------------------------------------------------
// NARRATIVES
//---------------------------------------------------------------------------------------

