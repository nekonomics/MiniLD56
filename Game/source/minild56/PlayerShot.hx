
package minild56;

import flash.geom.Point;
import flash.display.BitmapData;

class PlayerShot extends DisplayEntity {

	private var _v:Point;

	public function new(x:Float, y:Float, vx:Float, vy:Float) {
		super();

		_catBits = 0x0004;
		_mskBits = 0x0008;

		_src = new BitmapData(2, 2, false, Palette.color1);
		_dst = _src.clone();

		_p.setTo(x - _src.width / 2, y - _src.height / 2);
		_v = new Point(vx, vy);
	}

	override public function update():Void {
		_p.offset(_v.x, _v.y);
		if(!_isIntersectsField()) {
			_removeFromCanvas();
			return;
		}
		_addToCollider();
	}

	override public function kill():Void {
		if(!this.alive) { return; }
		this.alive = false;
		Canvas.instance.removeChild(this);
	}

}