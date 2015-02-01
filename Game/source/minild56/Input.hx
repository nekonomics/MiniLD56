
package minild56;

import flixel.FlxG;
import flixel.FlxBasic;
import flixel.input.keyboard.FlxKeyboard;

class Input extends FlxBasic {

	public static var instance(default, null):Input = new Input(InputPrivateClass);

	public static inline var UP:Int = 0;
	public static inline var DOWN:Int = 1;
	public static inline var LEFT:Int = 2;
	public static inline var RIGHT:Int = 3;
	public static inline var FIRE:Int = 4;
	public static inline var A:Int = 5;
	public static inline var B:Int = 6;
	private static inline var _NUM_KEYS:Int = 7;

	private static var _EMPTY_INPUT:String = "----";

	private static var _USE_ARROW:Bool = true;

	public var inputA(default, null):String = _EMPTY_INPUT;
	public var inputB(default, null):String = _EMPTY_INPUT;
	public var hasInputA(default, null):Bool = false;
	public var hasInputB(default, null):Bool = false;

	private var _nextInputA:String;
	private var _nextInputB:String;
	private var _nextHasInputA:Bool;
	private var _nextHasInputB:Bool;

	private var _upList:Array<String>;
	private var _downList:Array<String>;
	private var _leftList:Array<String>;
	private var _rightList:Array<String>;
	private var _fireList:Array<String>;
	private var _aList:Array<String>;
	private var _bList:Array<String>;

	private var _states:Array<Bool> = [];
	private var _lastStates:Array<Bool> = [];

	public function new(pvc:Class<InputPrivateClass>) {
		if(pvc != InputPrivateClass) {
			throw "Cannot create instance of Input";
		}
		super();

		_upList = ["UP"];
		_downList = ["DOWN"];
		_leftList = ["LEFT"];
		_rightList = ["RIGHT"];
		_fireList = ["SPACE"];
		_aList = ["F"];
		_bList = ["J"];

		for(i in 0..._NUM_KEYS) {
			_states[i] = _lastStates[i] = false;
		}

		_nextInputA = this.inputA;
		_nextInputB = this.inputB;
		_nextHasInputA = this.hasInputA;
		_nextHasInputB = this.hasInputB;

		Controller.instance.addEventListener(ControllerEvent.INPUT, _onControllerInput);
	}

	public function assign(a:String, b:String):Void {
		a = a.toUpperCase();
		b = b.toUpperCase();
		
		// trace("assign keys a:" + a + " b:" + b);

		_aList = [a];
		_bList = [b];
	}

	override public function update():Void {
		super.update();

		for(i in 0..._NUM_KEYS) {
			_lastStates[i] = _states[i];
		}

		var keys:FlxKeyboard = FlxG.keys;

		if(_USE_ARROW) {
			_states[UP] = keys.anyPressed(_upList);
			_states[DOWN] = keys.anyPressed(_downList);
			_states[LEFT] = keys.anyPressed(_leftList);
			_states[RIGHT] = keys.anyPressed(_rightList);
			_states[FIRE] = keys.anyPressed(_fireList);
		}

		_states[A] = keys.anyPressed(_aList);
		_states[B] = keys.anyPressed(_bList);

		this.inputA = _nextInputA;
		this.inputB = _nextInputB;
		this.hasInputA = _nextHasInputA;
		this.hasInputB = _nextHasInputB;
		_nextHasInputA = _nextHasInputB = false;
	}

	public function pressing(i:Int):Bool {
		return _states[i];
	}

	public function pressed(i:Int):Bool {
		return !_lastStates[i] && _states[i];
	}

	public function released(i:Int):Bool {
		return _lastStates[i] && !_states[i];
	}

	public function and(bits:String, mask:String):Bool {
		var len:Int = bits.length < mask.length ? bits.length : mask.length;
		var res = 0;
		for(i in 0...len) {
			if(mask.charAt(i) == "o") {
				if(bits.charAt(i) == "o") {
					res |= (1 << i);
				}
			}
		}
		return res > 0;
	}

	override public function toString():String {
		return "[Input" +
				" up:" + pressing(UP) +
				" down:" + pressing(DOWN) +
				" left:" + pressing(LEFT) +
				" right:" + pressing(RIGHT) + 
				" fire:" + pressing(FIRE) + 
				" a:" + pressing(A) +
				" b:" + pressing(B) + "]";
	}

	private function _onControllerInput(event:ControllerEvent):Void {
		switch (event.button) {
			case A:
			_nextInputA = event.input;
			_nextHasInputA = true;

			case B:
			_nextInputB = event.input;
			_nextHasInputB = true;
		}
	}
}

class InputPrivateClass {}