
class X2MissionSet_AMT extends X2MissionSet config(GameCore);

static function array<X2DataTemplate> CreateTemplates()
{
    local array<X2MissionTemplate> Templates;

        // Emergency Extraction
            Templates.AddItem(AddMissionTemplate('EmergencyDefense_Reapers'));
            Templates.AddItem(AddMissionTemplate('EmergencyDefense_Templars'));
            Templates.AddItem(AddMissionTemplate('EmergencyDefense_Skirmishers'));

		// Neutralize Avatar Project VIP
			Templates.AddItem(AddMissionTemplate('RM_Sabotage_Neutralize'));

		// Terror Escape
			Templates.AddItem(AddMissionTemplate('TerrorEscape'));

		// Operative Escort
			Templates.AddItem(AddMissionTemplate('RM_OperativeEscort'));

    return Templates;
}