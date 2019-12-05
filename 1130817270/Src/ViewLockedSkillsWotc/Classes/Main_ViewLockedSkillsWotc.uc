
///
/// 
///
class Main_ViewLockedSkillsWotc extends UIScreenListener config(_ViewLockedSkillsWotc);

//======================================================================================================================
// FIELDS

var private localized string ShowAllLabel;
var private localized string ShowAllToolTip;
var private localized string AlwaysShowAllLabel;
var private localized string AlwaysShowAllTooltip;

var config bool AlwaysShowAllAbilities;

// have this non persistent, so players using custom class with 4 regular rows of skills wont get spoiled
// when viewing vanilla classes
var bool ShowAllAbilities;

var UIArmory_PromotionHero Screen;
var XComGameState_Unit Unit;

//======================================================================================================================
// EVENT HANDLERS

///
/// Entry point
///
event OnInit(UIScreen _screen) {
	if( UIArmory_PromotionHero(_screen) != none ) {
		Screen = UIArmory_PromotionHero(_screen);
		Unit = Screen.GetUnit();
		InitUiElements();
		UpdateAbilitiesIcons();
	}
}


event OnRemoved(UIScreen _screen) {
	if( _screen.IsA('UIArmory_PromotionHero') ) {
		Screen.ClearTimer('UpdateAbilitiesIcons', self); // stop timer inited within HandleAbitiltyIconMouseUp
		Screen = none;
		Unit = none;
		ShowAllAbilities = false;
	}
}

//======================================================================================================================
// METHODS

public static function SetTooltipText( UIPanel _panel, string _text ) {
	if( _panel.bHasTooltip ) {
		_panel.RemoveTooltip();
	}

	_panel.bProcessesMouseEvents = true;
	
	if( _text != "" ) {
		_panel.CachedTooltipId = _panel.Movie.Pres.m_kTooltipMgr.AddNewTooltipTextBox(
			_text,
			100,
			100,
			string(_panel.MCPath),
			"",
			class'UITextTooltip'.default.bRelativeLocation,
			class'UITextTooltip'.default.Anchor,
			class'UITextTooltip'.default.bFollowMouse,
			500, // class'UITextTooltip'.default.maxW,
			500, // class'UITextTooltip'.default.maxH,
			class'UITextTooltip'.default.eTTBehavior,
			class'UITextTooltip'.default.eTTColor,
			class'UITextTooltip'.default.tDisplayTime,
			0.0f, //class'UITextTooltip'.default.tDelay
			class'UITextTooltip'.default.tAnimateIn,
			class'UITextTooltip'.default.tAnimateOut
		);

		_panel.bHasTooltip = true;
	}
}

function InitUiElements() {
	local UIBGBox _checkboxBg;
	local UiCheckbox _checkbox;
	local UIButton _btn;
	local int _height;
	local int _y;
	local int _checkboxX, _btnX;

	_height = 35;
	_y = 920;
	_checkboxX = 1000;
	_btnX = 300;

	_checkboxBg = Screen.Spawn(class'UIBGBox', Screen);
	_checkboxBg.bAnimateOnInit = false;
	_checkboxBg.InitBG();
	_checkboxBg.ProcessMouseEvents();
	SetTooltipText(_checkboxBg, AlwaysShowAllTooltip);

	_checkbox = Screen.Spawn(class'UICheckbox', Screen);
	_checkbox.bAnimateOnInit = false;
	_checkbox.InitCheckbox('', AlwaysShowAllLabel, AlwaysShowAllAbilities, HandleAlwaysShowAllCheckboxChanged );
	_checkbox.SetTextStyle( class'UICheckbox'.const.STYLE_TEXT_ON_THE_RIGHT );

	_btn = Screen.Spawn(class'UIButton', Screen);
	_btn.bAnimateOnInit = false;
	_btn.InitButton('', ShowAllLabel, HandleShowAllButtonClicked );
	_btn.SetHeight(_height);
	SetTooltipText(_btn, ShowAllToolTip);

	_btn.SetPosition( _btnX, _y );
	_checkbox.SetPosition( _checkboxX, _y );
	_checkboxBg.SetPosition( _checkboxX, _y );
	_checkboxBg.SetSize( 300, _height );
}
private function HandleAlwaysShowAllCheckboxChanged( UICheckbox _source ) {
	AlwaysShowAllAbilities = _source.bChecked;
	SaveConfig();
	Update();
}
private function HandleShowAllButtonClicked( UIButton _source ) {
	ShowAllAbilities = true;
	Update();
}

///
/// 
///
function Update() {
	Screen.PopulateData();
	UpdateAbilitiesIcons();
}

///
/// Returns true if given row contains XCOM abilities.
///
function bool IsXComAbilityRow( int row ) {
	return Unit.IsChampionClass() ? row > 2 : row > 1;
}

///
/// Returns true if given ability should be kept hidden.
///
function bool ShouldSeeAbility(int rank, int row) {
	return AlwaysShowAllAbilities || ShowAllAbilities || ! IsXComAbilityRow(row) || rank < Unit.GetRank();
}

///
/// 
///
function UpdateAbilitiesIcons() {
	local UIArmory_PromotionHeroColumn column;
	local int iCol, iRow;
	local X2AbilityTemplateManager templateMgr;
	local X2AbilityTemplate template, nextTemplate;

	templateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	foreach Screen.Columns(column, iCol) {
		for( iRow=0; iRow<column.AbilityIcons.Length; iRow++ ) {

			if( ! ShouldSeeAbility(column.Rank, iRow) ) continue;

			column.AbilityIcons[iRow].ProcessMouseEvents(HandleAbilityIconMouseEvent);

			if( column.Rank < Unit.GetRank() ) continue; // already visible, maybe activated too...

			template = templateMgr.FindAbilityTemplate( Unit.GetRankAbilities(Column.Rank)[iRow].AbilityName );

			if( template == none ) {
				// Make sure we add empty spots to the name array for getting ability info
				column.AbilityNames.AddItem('');
				continue;
			}

			if( column.Rank < class'X2ExperienceConfig'.static.GetMaxRank()-2 ) {
				// look ahead for dependency
				// BUG: won't work for abilities on current rank...
				nextTemplate = templateMgr.FindAbilityTemplate( Unit.GetRankAbilities(column.Rank+1)[iRow].AbilityName );
			}

			column.AS_SetIconState(
				iRow, false,
				template.IconImage,
				class'UIUtilities_Text'.static.CapsCheckForGermanScharfesS(template.LocFriendlyName),
				eUIPromotionState_Normal,
				class'UIUtilities_Colors'.const.BLACK_HTML_COLOR,
				class'UIUtilities_Colors'.const.DISABLED_HTML_COLOR,
				nextTemplate.PrerequisiteAbilities.Find(template.DataName) != INDEX_NONE
			);
		}
	}
}

///
/// 
///
function ShowAbilitiyDescription( int iCol, int iRow ) {
	local X2AbilityTemplateManager templateMgr;
	local X2AbilityTemplate template, previousAbilityTemplate;
	local string abilityIcon, abilityName, abilityDesc, abilityHint, abilityCost, costLabel, apLabel, prereqAbilityNames;
	local name prereqAbilityName;

	templateMgr = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	template = templateMgr.FindAbilityTemplate( Unit.GetRankAbilities(iCol)[iRow].AbilityName );
	if( template == none ) return;

	abilityIcon = template.IconImage;
	abilityName = template.LocFriendlyName != "" ? template.LocFriendlyName : ("Missing 'LocFriendlyName' for " $ template.DataName);
	abilityDesc = template.HasLongDescription() ? template.GetMyLongDescription(, Unit) : ("Missing 'LocLongDescription' for " $ template.DataName);
	abilityHint = "";
	costLabel = Screen.m_strCostLabel;
	apLabel = Screen.m_strAPLabel;
	abilityCost = string(Screen.GetAbilityPointCost(iCol, iRow));

	if( template.PrerequisiteAbilities.Length > 0 ) {
		// look behind for dependency
		foreach template.PrerequisiteAbilities(prereqAbilityName) {
			previousAbilityTemplate = templateMgr.FindAbilityTemplate(prereqAbilityName);
			if( previousAbilityTemplate != none && !Unit.HasSoldierAbility(prereqAbilityName) ) {
				if( prereqAbilityNames != "" ) {
					prereqAbilityNames $= ", ";
				}
				prereqAbilityNames $= previousAbilityTemplate.LocFriendlyName;
			}
		}
		prereqAbilityNames = class'UIUtilities_Text'.static.FormatCommaSeparatedNouns(prereqAbilityNames);
		if( prereqAbilityNames != "" ) {
			abilityDesc = class'UIUtilities_Text'.static.GetColoredText(Screen.m_strPrereqAbility @ prereqAbilityNames, eUIState_Warning) $ "\n" $ abilityDesc;
		}
	}

	Screen.AS_SetDescriptionData(abilityIcon, abilityName, abilityDesc, abilityHint, costLabel, abilityCost, apLabel);
}

//======================================================================================================================
// HANDLERS

///
/// Called when abilitiy icon receive any mouse event.
///
function HandleAbilityIconMouseEvent(UIPanel panel, int cmd) {
	local UIArmory_PromotionHeroColumn column;
	local UiIcon icon;
	local int iCol, iRow;

	foreach Screen.Columns(column, iCol) {
		foreach column.AbilityIcons(icon, iRow) {
			if( icon == panel ) {

				switch( cmd ) {
					case class'UIUtilities_Input'.const.FXS_L_MOUSE_IN:
						HandleAbitiltyIconMouseOver(icon, column, iRow);
						break;

					case class'UIUtilities_Input'.const.FXS_L_MOUSE_OUT:
					case class'UIUtilities_Input'.const.FXS_L_MOUSE_DRAG_OUT:
						HandleAbitiltyIconMouseOut(icon, column, iRow);
						break;

					case class'UIUtilities_Input'.const.FXS_L_MOUSE_UP:
						HandleAbitiltyIconMouseUp(icon, column, iRow);
						break;
				}
			}
		}
	}
}

///
/// Called when abilitiy icon receive mouse over event.
///
function HandleAbitiltyIconMouseOver( UiIcon icon, UIArmory_PromotionHeroColumn column, int iRow ) {
	column.OnReceiveFocus();
	icon.OnReceiveFocus();
	column.RealizeAvailableState(iRow);

	Screen.ClearTimer(nameof(Update), self); // stop timer inited within HandleAbitiltyIconMouseUp

	if( ShouldSeeAbility(column.Rank, iRow) ) {
		column.InfoButtons[iRow].Show();
		ShowAbilitiyDescription(column.Rank, iRow);
		column.ClearTimer('Hide', column.InfoButtons[iRow]);
	}
}

///
/// Called when abilitiy icon receive mouse out event.
///
function HandleAbitiltyIconMouseOut( UiIcon icon, UIArmory_PromotionHeroColumn column, int iRow ) {
	icon.OnLoseFocus();
	column.RealizeAvailableState(iRow);
	column.HideAbilityPreview();
	column.SetTimer(0.01, false, 'Hide', column.InfoButtons[iRow]);
}

///
/// Called when abilitiy icon receive mouse up event.
///
function HandleAbitiltyIconMouseUp( UiIcon icon, UIArmory_PromotionHeroColumn column, int iRow ) {
	if( Screen.OwnsAbility(column.AbilityNames[iRow]) ) {
		column.OnInfoButtonMouseEvent(column.InfoButtons[iRow], class'UIUtilities_Input'.const.FXS_L_MOUSE_UP);
	}
	else if( column.bEligibleForPurchase && Screen.CanPurchaseAbility(column.Rank, iRow, column.AbilityNames[iRow]) ) {
		Screen.SetTimer(0.1, true, nameof(Update), self); // If player confirms, have to reapply the modifications
		Screen.ConfirmAbilitySelection(column.Rank, iRow);
	}
	else if( ShouldSeeAbility(column.Rank, iRow) ) {
		column.OnInfoButtonMouseEvent(column.InfoButtons[iRow], class'UIUtilities_Input'.const.FXS_L_MOUSE_UP);
	}
	else {
		Screen.Movie.Pres.PlayUISound(eSUISound_MenuClickNegative);
	}
}
