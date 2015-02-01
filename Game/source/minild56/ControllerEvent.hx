
package minild56;

import flash.events.Event;

class ControllerEvent extends Event {

	public static inline var INPUT:String = "ControllerEventInput";

	public var button:Int;
	public var input:String;

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false):Void {
		super(type, bubbles, cancelable);
	}

}