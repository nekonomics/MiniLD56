
package minild56;

import flash.events.EventDispatcher;

class Entity extends EventDispatcher {

	public var tag:String = "";

	public var alive:Bool = true;
	public var exists:Bool = true;

	public function new(tag:String = "") {
		super();
		this.tag = tag;
	}

	public function update():Void {

	}

	public function draw(canvas:Canvas) {

	}

	public function kill():Void {

	}
}