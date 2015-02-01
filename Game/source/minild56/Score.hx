
package minild56;

import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import minild56.Palette;
import minild56.TextGenerator;

class Score extends DisplayEntity {

	public static inline var DIGITS:Int = 8;

	public var score(default, set):Int = 0;

	private var _rect:Rectangle;
	private var _dirty:Bool = true;

	public function new():Void {
		super();

		_src = TextGenerator.instance.generate("0123456789", 1);
		_rect = new Rectangle(0, 0, Std.int((_src.width - 3 - 1) / 10), _src.height);
		_dst = new BitmapData(Std.int(DIGITS * _rect.width), Std.int(_rect.height), false, Palette.color0);
	}

	override public function draw(canvas:Canvas):Void {
		if(_dirty) {
			_dirty = false;

			_dst.fillRect(_dst.rect, Palette.color0);
			var p:Point = new Point();
			var s:Int = this.score;
			var t:Int = Std.int(Math.pow(10, DIGITS - 1));
			for(i in 0...DIGITS) {
				var n:Int = t != 0 ? Std.int(s / t) : s;
				s = s - n * t;
				t = Std.int(t / 10);
				p.x = i * _rect.width;
				_rect.x = n * _rect.width + 3;
				_dst.copyPixels(_src, _rect, p);
			}
		}
		super.draw(canvas);
	}

	private function set_score(value:Int):Int {
		_dirty = true;
		return this.score = value;
	}
	
}