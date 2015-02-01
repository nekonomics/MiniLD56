
package minild56;

import flash.geom.Rectangle;

class ColliderEntry {

	public var rect(default, null):Rectangle;
	public var mskBits(default, null):Int;
	public var catBits(default, null):Int;
	public var entity(default, null):Entity;

	public function new(rect:Rectangle, mskBits:Int, catBits:Int, entity:Entity) {
		this.rect = rect;
		this.mskBits = mskBits;
		this.catBits = catBits;
		this.entity = entity;
	}

}