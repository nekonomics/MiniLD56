
package minild56;

import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.display.BitmapData;
import flixel.FlxSprite;
import retricon.Retricon;
import retricon.Options;

class Player extends minild56.DisplayEntity {

	private static inline var _SHOT_SPEED:Float = 0.3;
	private static inline var _MOVE_SPEED:Int = 8;

	private var _rotation:Float = 0;

	public function new(text:String) {
		super("player");

		_catBits = 0x0002;
		_mskBits = 0x0018;

		var opts:Options = new Options();
		opts.tiles = 8;
		opts.pixelSize = 1;
		opts.pixelColor = Palette.convertToString(Palette.color1);
		opts.bgColor = Palette.convertToString(Palette.color0);

		_src = Retricon.retricon(text, opts);
		_dst = _src.clone();

		_p = new Point();
		_mat = new Matrix();
	}

	override public function update():Void {
		if(!this.alive) {
			return;
		}

		// parse input
		_parseInput(Input.instance);

		if(_p.x < 0) { _p.x = 0; }
		else if(_p.x + this.width >= Consts.FIELD_WIDTH) { _p.x = Consts.FIELD_WIDTH - this.width; }
		if(_p.y < 0) { _p.y = 0; }
		else if(_p.y + this.height >= Consts.FIELD_HEIGHT) { _p.y = Consts.FIELD_HEIGHT - this.height; }

		_addToCollider();
	}

	override public function kill():Void {
		this.alive = false;
	}

	public function reset():Void {
		this.alive = true;
	}

	private function _parseInput(input:Input):Void {
		if(input.hasInputA) {
			var s:String = input.inputA;
			if(input.and(s, Consts.PLAYER_MOVE_LEFT)) { _moveDir(Input.LEFT); }
			if(input.and(s, Consts.PLAYER_MOVE_RIGHT)) { _moveDir(Input.RIGHT); }
			if(input.and(s, Consts.PLAYER_MOVE_UP)) { _moveDir(Input.UP); }
			if(input.and(s, Consts.PLAYER_MOVE_DOWN)) { _moveDir(Input.DOWN); }
		}
		if(input.hasInputB) {
			var s:String = input.inputB;
			if(input.and(s, Consts.PLAYER_FIRE_LEFT)) { _fire(90); }
			if(input.and(s, Consts.PLAYER_FIRE_RIGHT)) { _fire(-90); }
			if(input.and(s, Consts.PLAYER_FIRE_UP)) { _fire(180); }
			if(input.and(s, Consts.PLAYER_FIRE_DOWN)) { _fire(0); }
		}

		// debug
		if(input.pressed(Input.LEFT)) {
			_moveDir(Input.LEFT);
		} else if(input.pressed(Input.RIGHT)) {
			_moveDir(Input.RIGHT);
		} else if(input.pressed(Input.UP)) {
			_moveDir(Input.UP);
		} else if(input.pressed(Input.DOWN)) {
			_moveDir(Input.DOWN);
		} else if(input.pressed(Input.FIRE)) {
			_fire(Std.int(_rotation));
		}
	}

	private function _moveDir(dir:Int):Void {
		switch (dir) {
			case Input.LEFT:
			_rotation = 90;
			_rotate(-90, 0, _src.height);
			_move(-_MOVE_SPEED, 0);

			case Input.RIGHT:
			_rotation = -90;
			_rotate(90, _src.width, 0);
			_move(_MOVE_SPEED, 0);

			case Input.UP:
			_rotation = 180;
			_rotate(0, 0, 0);
			_move(0, -_MOVE_SPEED);

			case Input.DOWN:
			_rotation = 0;
			_rotate(180, _src.width, _src.height);
			_move(0, _MOVE_SPEED);
		}
	}

	private function _fire(degree:Int):Void {
		var x:Float = _p.x + _src.width / 2;
		var y:Float = _p.y + _src.height / 2;

		var a:Float = degree * Math.PI / 180;
		var vx:Float = -Math.sin(a) * _SHOT_SPEED;
		var vy:Float =  Math.cos(a) * _SHOT_SPEED;

		var shot:PlayerShot = new PlayerShot(x, y, vx, vy);
		Canvas.instance.addChild(shot);
	}

}