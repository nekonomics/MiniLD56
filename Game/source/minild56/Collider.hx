
package minild56;

import flash.events.EventDispatcher;
import flash.geom.Rectangle;

class Collider extends EventDispatcher {

	public static var instance(default, null):Collider = new Collider(ColliderPrivateClass);

	private var _entries:Array<ColliderEntry>;

	private function new(pvc:Class<ColliderPrivateClass>) {
		super();
		_entries = new Array<ColliderEntry>();
	}

	public function exec():Void {
		var len:Int = _entries.length;
		for(i in 0...len) {
			var e0:ColliderEntry = _entries[i];
			if(!e0.entity.exists || !e0.entity.alive) { continue; }
			for(j in (i+1)...len) {
				var e1:ColliderEntry = _entries[j];
				if(!e1.entity.exists || !e1.entity.alive) { continue; }
				if((e0.catBits & e1.mskBits) == 0 || (e1.catBits & e0.mskBits) == 0) { continue; }
				var r:Rectangle = e0.rect.intersection(e1.rect);
				if(r.isEmpty()) { continue; }
				// dispatch event
				_onCollide(e0, e1);
			}
		}

		_entries.splice(0, _entries.length);
	}

	public function addEntry(rect:Rectangle, mskBits:Int, catBits:Int, entity:Entity):Void {
		_entries.push(new ColliderEntry(rect, mskBits, catBits, entity));

		//
		Canvas.instance.debugDrawRect(rect);
	}

	private function _onCollide(e0:ColliderEntry, e1:ColliderEntry):Void {
		var e:ColliderEvent = new ColliderEvent(ColliderEvent.COLLIDE);
		e.entry0 = e0;
		e.entry1 = e1;
		this.dispatchEvent(e);
	}

}

class ColliderPrivateClass {}