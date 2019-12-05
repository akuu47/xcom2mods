///
/// Wraps delegate to provide a standard way to allow multiple function handling the same signal,
/// and resolves the delegate-overwritting issue.
/// 
class xmf_Signal extends Object;

`define ClassName uc_Customizer
`include( UnrestrictedCustomization\Src\UnrestrictedCustomization\macros.uci )

//======================================================================================================================
// FIELDS

var private array< delegate<SignalHandler> > Handlers;


public delegate SignalHandler( Object _source );

//======================================================================================================================
// CTOR

///
/// Instantiates this class.
///
public static function xmf_Signal CreateSignal() {
	return Signal(class'xmf_Signal');
}

///
/// Ctor.
///
protected static function xmf_Signal Signal( class<xmf_Signal> _class ) {
	return new _class;
}

//======================================================================================================================
// METHODS

///
/// Adds given handler if it wasn't already added, does nothing (but logging warning) otherwise.
///
function AddHandler( delegate<SignalHandler> _handler ) {
	if( _handler == none ) return;
	if( Handlers.Find(_handler) != INDEX_NONE ) return;
	Handlers.AddItem(_handler);
}

///
/// Removes given handler if it was previously added, does nothing otherwise.
///
function RemoveHandler( delegate<SignalHandler> _handler ) {
	//`assert( Handlers.Find(_handler) != INDEX_NONE );
	Handlers.RemoveItem(_handler);
}

///
/// Removes all previously added handlers. 
///
function RemoveAllHandlers() {
	Handlers.Length = 0;
}

///
/// Dispatches this signal, the handlers will be called by order of addition.
///
function Dispatch( Object _source ) {
	local array< delegate<SignalHandler> > _handlersCopy;
	local delegate<SignalHandler> _handler;

	switch( Handlers.Length ) {
		case 0:
			break;
		case 1:
			_handler = Handlers[0];
			_handler(_source);
			break;
		default:
			// copy array so we can remove handlers while iterating in addition order
			foreach Handlers(_handler) {
				_handlersCopy.AddItem( _handler );
			}
			foreach _handlersCopy(_handler) {
				_handler(_source);
			}
			break;
	}
}
