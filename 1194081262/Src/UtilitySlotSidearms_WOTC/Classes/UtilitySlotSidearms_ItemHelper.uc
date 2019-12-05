class UtilitySlotSidearms_ItemHelper extends X2ItemTemplate;

var localized string sUtility;

static function CopyLocalization(X2ItemTemplate BaseTemplate, X2ItemTemplate NewTemplate) {
	NewTemplate.FriendlyName = default.sUtility $ BaseTemplate.FriendlyName;
	NewTemplate.FriendlyNamePlural = default.sUtility $ BaseTemplate.FriendlyNamePlural;
	NewTemplate.BriefSummary = BaseTemplate.BriefSummary;
	NewTemplate.TacticalText = BaseTemplate.TacticalText;
	NewTemplate.AbilityDescName = BaseTemplate.AbilityDescName;
}

static function string GetFriendlyName(X2ItemTemplate BaseTemplate) {
	return BaseTemplate.FriendlyName;
}