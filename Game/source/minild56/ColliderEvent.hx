
package minild56;

import flash.events.Event;

class ColliderEvent extends Event {

	public static inline var COLLIDE:String = "ColliderEventCollide";

	public var entry0:ColliderEntry;
	public var entry1:ColliderEntry;

	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false):Void {
		super(type, bubbles, cancelable);
	}

}