
package minild56;

import flash.geom.Point;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.display.BitmapData;

class DisplayEntity extends Entity {

	public var x(get, set):Float;
	public var y(get, set):Float;
	public var width(get, null):Int;
	public var height(get, null):Int;

	private var _src:BitmapData;
	private var _dst:BitmapData;
	private var _p:Point;
	private var _mat:Matrix;

	private var _col:Rectangle;
	private var _mskBits:Int = 0xffff;
	private var _catBits:Int = 0x0001;

	public function new(tag:String = "") {
		super(tag);
		_src = _dst = null;
		_p = new Point();
		_mat = new Matrix();
		_col = new Rectangle();
	}

	override public function draw(canvas:Canvas):Void {
		if(_dst != null) { canvas.bitblt(_dst, Std.int(_p.x), Std.int(_p.y)); }
	}

	public function setBitmapData(bd:BitmapData):Void {
		_src = bd;
		_dst = _src.clone();

	}

	public function center():Point {
		return new Point(_p.x + _src.width / 2, _p.y + _src.height / 2);
	}

	private function _removeFromCanvas():Void {
		Canvas.instance.removeChild(this);
	}

	private function _rotate(degree:Float, dx:Int, dy:Int):Void {
		_dst.fillRect(_dst.rect, Palette.color0);

		_mat.identity();
		_mat.rotate(degree * Math.PI / 180);
		_mat.translate(dx, dy);
		_dst.draw(_src, _mat);
	}

	private function _move(dx:Int, dy:Int):Void {
		_p.offset(dx, dy);
	}

	private function _addToCollider():Void {
		if(!this.alive) { return; }

		_col.size = _dst.rect.size;
		_col.topLeft = _p;
		
		Collider.instance.addEntry(_col, _mskBits, _catBits, this);
	}

	private function _isIntersectsField():Bool {
		return _p.x > -this.width && _p.y > -this.height && _p.x <= Consts.FIELD_WIDTH && _p.y <= Consts.FIELD_HEIGHT;
	}

	private function _pixelize(x:Float, y:Float, dst:Point):Point {
		dst.setTo(Std.int(x), Std.int(y));
		return dst;
	}

	private function get_x():Float { return _p.x; }
	private function set_x(value:Float):Float { return _p.x = value; }

	private function get_y():Float { return _p.y; }
	private function set_y(value:Float):Float { return _p.y = value; }

	private function get_width():Int { return _dst == null ? 0 : _dst.width; }

	private function get_height():Int { return _dst == null ? 0 : _dst.height; }

}
