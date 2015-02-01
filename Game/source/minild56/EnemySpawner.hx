
package minild56;

import flash.display.BitmapData;
import flash.geom.Point;
import haxe.ds.EnumValueMap;
import flixel.FlxG;
import flixel.util.FlxRandom;

class EnemySpawner extends Entity {

	public var spawnEnabled:Bool = true;

	private var _map:EnumValueMap<Types.EnemyType, String>;
	private var _types:Array<Types.EnemyType>;

	private var _elapsedTime:Float;
	private var _interval:Float;

	private var _bd:BitmapData;
	private var _pixelIndex:Int;

	public function new(interval:Float) {
		super();

		_interval = interval;
		_elapsedTime = 0;

		_types = Types.EnemyType.createAll();
		_map = new EnumValueMap<Types.EnemyType, String>();
		for(i in 0..._types.length) {
			_map.set(_types[i], "enemy" + i + Date.now().getTime());
		}

		var seed:Int = Std.int(Date.now().getTime());
		_bd = new BitmapData(64, 64, false, 0);
		_bd.noise(seed, 0, 255, 0xffff);
		_pixelIndex = 0;
	}

	override public function update():Void {
		if(!this.spawnEnabled) {
			return;
		}

		_elapsedTime += 1.0;
		if(_elapsedTime >= _interval) {
			_elapsedTime = 0;
			this.spawn();
		}
	}

	public function reset():Void {
		this.spawnEnabled = true;
		_elapsedTime = 0;
		_pixelIndex = 0;
	}

	public function spawn():Enemy {
		var canvas:Canvas = Canvas.instance;
		var index:Int = FlxRandom.intRanged(0, _types.length - 1);
		var type:Types.EnemyType = _types[index];
		var w:Int = Consts.FIELD_WIDTH;
		var h:Int = Consts.FIELD_HEIGHT;
		var e:Enemy = new Enemy(type, _map.get(type));
		// e.x = FlxRandom.intRanged(0, w - e.width - 1);
		// e.y = FlxRandom.intRanged(0, h - e.height - 1);
		var p:Int = _bd.getPixel(_pixelIndex % _bd.width, Std.int(_pixelIndex / _bd.width));
		if(++_pixelIndex >= _bd.width * _bd.height) {
			_pixelIndex = 0;
		}
		e.x = Math.ceil((((p >> 16) & 0xff) / 255.0) * (w - e.width - 1));
		e.y = Math.ceil((((p >>  8) & 0xff) / 255.0) * (h - e.height - 1));
			
	
		canvas.addChild(e);
		return e;
	}

}