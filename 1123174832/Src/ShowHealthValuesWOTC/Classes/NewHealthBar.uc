// This is an Unreal Script
class NewHealthBar extends UIUnitFlag
	dependson(XComGameState_Unit) config(TacticalHP);

var config bool SHOW_VALUE;
var config bool SHOW_PIPS;
var config bool SHOW_ALIENS;
var config bool SHOW_XCOM;
var config int PIP_MULTIPLIER;
var config string TXT_COLOR;
var config string SHIELD_COLOR;
var config bool SHOW_SHIELD;

var UIText hpText;
var Array<UIBGBox> hpHighlightChunks;
var UIPanel hpHighlight, makeShiftArmor;
var UIIcon armorPip;
var Array<UIIcon> armorPips;

simulated function SetHitPointsBar( int _currentHP, int _maxHP, int _armor, int _shield, int _maxShield )
{
	local ASValue myValue;
	local Array<ASValue> myArray;
	local int currentHP, maxHP, shield, maxShield, current_armor, iMultiplier;

	local float hp_chunk_size;
	local int hp_chunk_count, index;
	local UIBGBox hpSmall, panel;

	local int currGroupHP, maxGroupHP;
	local bool emptyRest, updateUI;

	local string hp_full;

	iMultiplier = `GAMECORE.HP_PER_TICK;

	//`log("Parameters:" @ _currentHp @ _maxHP @ _armor @ _Shield @ _maxShield,, 'NewHealthBar');

	if ( _currentHP < 1 )
	{
		m_bIsDead = true;
		Remove();
	}
	else
	{
		if( !m_bIsFriendly.GetValue() && !`XPROFILESETTINGS.Data.m_bShowEnemyHealth ) // Profile is set to hide enemy health 
		{			
			m_currentHitPoints.SetValue(0);
			m_maxHitPoints.SetValue(0);
			m_shieldPoints.SetValue(0);
			m_maxShieldPoints.SetValue(0);
			//m_armorPoints.SetValue(0);
		}
		else
		{
			if( iMultiplier > 0 )
			{
				currentHP = FCeil(float(_currentHP) / float(iMultiplier)); 
				maxHP = FCeil(float(_maxHP) / float(iMultiplier)); 
				shield = FCeil(float(_shield) / float(iMultiplier)); 
				maxShield = FCeil(float(_maxShield) / float(iMultiplier)); 
				//current_armor = FCeil(float(_armor) / float(iMultiplier));
			}
			else
			{
				currentHP = _currentHP; 
				maxHP = _maxHP; 
				shield = _shield; 
				maxShield = _maxShield; 
				//current_armor = _armor;
			}

			m_currentHitPoints.SetValue(currentHP);
			m_maxHitPoints.SetValue(maxHP);
			m_shieldPoints.SetValue(shield);
			m_maxShieldPoints.SetValue(maxShield);
			//m_armorPoints.SetValue(current_armor);
		}
		updateUI = false;
		if( m_currentHitPoints.HasChanged() || m_maxHitPoints.HasChanged() )
		{
			myArray.Length = 0;
			myValue.Type = AS_Number;
			myValue.n = currentHP;
			myArray.AddItem( myValue );
			myValue.n = maxHP;
			myArray.AddItem( myValue );
			updateUI = true;

			Invoke("SetHitPoints", myArray);
		}
		if ( m_shieldPoints.HasChanged() || m_maxShieldPoints.HasChanged() )
		{
			myArray.Length = 0;
			myValue.Type = AS_Number;
			myValue.n = m_shieldPoints.GetValue();
			myArray.AddItem(myValue);
			myValue.n = m_maxShieldPoints.GetValue();
			myArray.AddItem(myValue);
			updateUI = true;

			Invoke("SetShieldPoints", myArray);
		}
		if(updateUI || hpText == none)
		{
			//`log("updateUI == true",, 'NewHealthBar');
			if (hpText == none) 
			{
				if (default.SHOW_VALUE) 
				{
					hpText = Spawn(class'UIText', self).InitText();
					hpText.SetX(115);
					hpText.SetY(-25);
					hpText.SetWidth(175);
				}

				if (default.SHOW_PIPS) {
					hpHighlight = Spawn(class'UIPanel', self);
					hpHighlight.InitPanel();
					hpHighlight.SetX(23);
					hpHighlight.SetY(-35);
					hpHighlight.SetSize(270, 4);
				}
				`log("panel created",, 'NewHealthBar');
			}
			if (hpText != none) {
				if (default.SHOW_PIPS && ShowTeam()) {
					//foreach hpHighlightChunks(panel)
					//{
						//panel.Remove();
					//}
					//hpHighlightChunks.Remove(0, hpHighlightChunks.Length);
					hp_chunk_count = FFloor(float(_currentHP) / default.PIP_MULTIPLIER); 
					hp_chunk_size = 270 * default.PIP_MULTIPLIER / float(_maxHP);
					for (index = 0; index < hp_chunk_count; ++index) {
						if (index >= hpHighlightChunks.Length)
						{
							hpSmall = Spawn(class'UIBGBox', hpHighlight);
							hpSmall.InitBG();
							hpSmall.SetBGColor("red");
							hpHighlightChunks.AddItem(hpSmall);
						}
						else
						{
							hpSmall = hpHighlightChunks[index];
						}
						hpSmall.setSize(hp_chunk_size - 4, 4);
						hpSmall.setX(hp_chunk_size * float(index) + 2);
					}
					while (hp_chunk_count < hpHighlightChunks.Length)
					{
						hpHighlightChunks[hp_chunk_count].Remove();
						hpHighlightChunks.Remove(hp_chunk_count, 1);
					}
				}
				
				if (default.SHOW_VALUE && ShowTeam()) {
					hp_full = "<font color='#" $ default.TXT_COLOR $ "'>" $ currentHP @ "/" @ maxHP $ "</font>";
					if (default.SHOW_SHIELD && shield > 0)
					{
						hp_full = "<font color='#" $ default.SHIELD_COLOR $ "'>" $ shield @ "/" @ maxShield @ "</font>+" @ hp_full;
					}
					if ( maxHP == 0 )
					{
						hp_full = "";
					}
					//`log("update text:" @ hp_full,, 'NewHealthBar');
					hpText.SetText(class'UIUtilities_Text'.static.AlignRight(hp_full));
				}
			}
		}
	}
}

simulated function bool ShowTeam() 
{
	if (m_bIsFriendly.GetValue() && default.SHOW_XCOM)
		return true;
	if (!m_bIsFriendly.GetValue() && default.SHOW_ALIENS)
		return true;
	return false;
}

simulated function RealizeHitPoints(optional XComGameState_Unit NewUnitState = none) 
{		
	local XComGameState_Effect_TemplarFocus FocusState;
	local XComGameState_Unit PreviousUnitState;
	local int PreviousWill;

	if( NewUnitState == none )
	{
		NewUnitState = XComGameState_Unit(History.GetGameStateForObjectID(StoredObjectID));
	}

	if (NewUnitState == none)
		return; // Break if no unitstate

	PreviousUnitState = XComGameState_Unit(NewUnitState.GetPreviousVersion());
	if (PreviousUnitState != none)
	{
		PreviousWill = PreviousUnitState.GetCurrentStat(eStat_Will);
	}

	SetHitPointsBar( NewUnitState.GetCurrentStat(eStat_HP), NewUnitState.GetMaxStat(eStat_HP), NewUnitState.GetArmorMitigationForUnitFlag(),  NewUnitState.GetCurrentStat(eStat_ShieldHP), NewUnitState.GetMaxStat(eStat_ShieldHP) );
	//SetShieldPoints( NewUnitState.GetCurrentStat(eStat_ShieldHP), NewUnitState.GetMaxStat(eStat_ShieldHP) );
	SetArmorPoints( NewUnitState.GetArmorMitigationForUnitFlag() );
	SetWillPoints(NewUnitState.GetCurrentStat(eStat_Will), NewUnitState.GetMaxStat(eStat_Will), PreviousWill);

	FocusState = NewUnitState.GetTemplarFocusEffectState();
	if( FocusState != none )
	{
		SetFocusPoints(FocusState.FocusLevel, FocusState.GetMaxFocus(NewUnitState));
	}
	else
	{
		SetFocusPoints(-1, 0);
	}

	//Needs to be called after changes are made to will or focus level. This should be after all changes are made to minimize calls.
	RealizeMeterPosition();
	if ( m_bIsFriendly.GetValue() && m_bUsesWillSystem )
	{
		if (hpHighlight != none)
		{
			hpHighlight.SetY(-48);
		}
	}
	else
	{
		if (hpHighlight != none)
		{
			hpHighlight.SetY(-35);
		}
	}
}

simulated function SetHitPoints( int _currentHP, int _maxHP )
{
	SetHitPointsBar(  _currentHP, _maxHP, 0, 0, 0 ); // Destructibles have no shields or armor
}

simulated function RealizeObjectiveItemState(optional XComGameState_Unit NewUnitState = none)
{
	local bool bHasObjectiveItem; 

	bHasObjectiveItem = false; 
	if( NewUnitState == none )
	{
		NewUnitState = XComGameState_Unit(History.GetGameStateForObjectID(StoredObjectID));
	}

	if (NewUnitState == none)
		return;

	bHasObjectiveItem = NewUnitState.HasItemOfTemplateClass(class'X2QuestItemTemplate'); 

	if( bHasObjectiveItem )
	{
		SeObjectiveItem( true );
	}
	else
	{
		SeObjectiveItem( false );
	}
}