
package minild56;

import flash.geom.Point;
import flash.geom.Matrix;
import flash.display.BitmapData;
import flixel.FlxG;
import retricon.Retricon;
import retricon.Options;

class Enemy extends DisplayEntity {

	private static inline var _SHOT_SPEED:Float = 0.1;
	private static inline var _SHOT_INTERVAL:Float = 20.0;
	private static inline var _APPEAR_INTERVAL:Float = 0.1;
	private static inline var _DISAPPEAR_DURATION:Float = 1.0;

	public var enemyType(default, null):Types.EnemyType;

	private var _shotElapsedTime:Float = 0;
	private var _shotInterval:Float = 0;

	private var _elapsedTime:Float = 0;
	private var _interval:Float = 0;
	private var _disolveSeed:Int = 0;

	private var _pixels:Array<Point>;
	private var _offset:Point;

	public function new(type:Types.EnemyType, text:String) {
		super("enemy");

		this.enemyType = type;

		_catBits = 0x0008;
		_mskBits = 0x0006;

		_shotElapsedTime = 0;
		_shotInterval = _SHOT_INTERVAL * FlxG.updateFramerate;

		_elapsedTime = 0;
		_interval = _APPEAR_INTERVAL * FlxG.updateFramerate;
		_disolveSeed = Std.int(Math.random() * 10000);

		_offset = new Point();

		var opts:Options = new Options();
		opts.tiles = 8;
		opts.pixelSize = 1;
		opts.pixelColor = Palette.convertToString(Palette.color2);
		opts.bgColor = Palette.convertToString(Palette.color0);

		_src = Retricon.retricon(text, opts);
		_dst = _src.clone();
		#if flash
		_dst.fillRect(_dst.rect, Palette.color0);
		#end
	}

	override public function update():Void {
		if(_pixels != null) {
			_elapsedTime += 1.0;
			if(_elapsedTime >= _interval) {
				this.alive = false;
				Canvas.instance.removeChild(this);
				return;
			}

			for(p in _pixels) {
				if(p.x < 0) { p.x -= 0.1; }
				else if(p.x > 0) { p.x += 0.1; }
				if(p.y < 0) { p.y -= 0.1; }
				else if(p.y > 0) { p.y += 0.1; }
			}
			return;
		}

		_shotElapsedTime += 1.0;
		if(_shotElapsedTime >= _shotInterval) {
			_shotElapsedTime = 0;
			_fire();
		}

		#if flash
		_elapsedTime += 1.0;
		if(_elapsedTime >= _interval) {
			_elapsedTime = 0;
			_disolveSeed = _dst.pixelDissolve(_src, _src.rect, new Point(0, 0), _disolveSeed, 2);
		}
		#end

		_addToCollider();
	}

	override public function draw(canvas:Canvas):Void {
		if(_pixels != null) {
			for(p in _pixels) {
				canvas.bitblt2(Std.int(p.x + _offset.x), Std.int(p.y + _offset.y), 1, 1, Palette.color2);
			}
			return;
		}
		super.draw(canvas);
	}

	override public function kill():Void {
		if(!this.alive) { return; }
		this.alive = false;

		_pixels = [];
		var w:Int = _dst.width;
		var h:Int = _dst.height;
		var pixels:flash.Vector<UInt> = _dst.getVector(_dst.rect);
		for(i in 0...pixels.length) {
			var pixel:UInt = pixels[i] & 0xffffff;
			if(pixel == Palette.color0) { continue; }
			var ix:Int = i % w;
			var iy:Int = Std.int(i / w);
			if((ix + iy) % 2 == 1) { continue; }
			_pixels.push(new Point(ix - w / 2, iy - h / 2));
		}

		_offset.setTo(_p.x + w / 2, _p.y + h / 2);

		_elapsedTime = 0;
		_interval = _DISAPPEAR_DURATION * FlxG.updateFramerate;
	}

	private function _fire():Void {
		var x:Float = _p.x + _src.width / 2;
		var y:Float = _p.y + _src.height / 2;

		var canvas:Canvas = Canvas.instance;
		var player:Player = cast(canvas.findWithTag("player"), Player);
		var c:Point = player == null ? canvas.center() : player.center();
		var dx:Float = c.x - x;
		var dy:Float = c.y - y;
		var d:Float = Math.sqrt(dx * dx + dy * dy);
		if(d == 0) { d = 0.01; }

		var vx:Float = dx / d * _SHOT_SPEED;
		var vy:Float = dy / d * _SHOT_SPEED;

		var shot:EnemyShot = new EnemyShot(x, y, vx, vy);
		Canvas.instance.addChild(shot);
	}

}