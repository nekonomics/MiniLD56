
package minild56;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.geom.ColorTransform;
import flixel.FlxG;
import flixel.FlxSprite;

class Controller extends DisplayEntity {

	public static inline var _INTERVAL:Float = 1.0;

	public static inline var _WIDTH:Int = 320;
	public static inline var _HEIGHT:Int = 40;
	public static inline var _LABEL_WIDTH:Int = 32;
	public static inline var _BAR_WIDTH:Int = 276;
	public static inline var _BAR_HEIGHT:Int = 18;
	public static inline var _BAR_X:Int = 32;
	public static inline var _BAR_Y:Int = 0;
	public static inline var _BAR_STEP:Int = 22;
	public static inline var _PAD_SIZE:Int = 18;
	public static inline var _PAD_STEP:Int = 68;
	public static inline var _CUR_Y:Int = 18;
	public static inline var _CUR_SIZE:Int = 4;

	public static var instance(default, null):Controller = new Controller(ControllerPrivateClass);
	
	public var time(default, null):Float = 0;
	public var interval(default, null):Float = 0;

	private var _cursor:Bitmap;
	private var _pads:Array<Bitmap>;
	private var _labels:Array<Bitmap>;

	private var _bar:BitmapData;
	private var _padOff:BitmapData;
	private var _padOn:BitmapData;

	private var _temp:Point;
	private var _lastFrame:Int = -1;

	public function new(pvc:Class<ControllerPrivateClass>) {
		super("controller");
	}

	public function init():Controller {
		_src = new BitmapData(_WIDTH, _HEIGHT, false, Palette.color0);
//		_src.fillRect(_src.rect, Palette.color0);
		_dst = _src.clone();
		_temp = new Point();

		_cursor = new Bitmap(new BitmapData(_CUR_SIZE, _CUR_SIZE, false, Palette.color3));
		_cursor.y = _CUR_Y;

		_labels = [];
		// create later

		var rgb:UInt = Palette.color3;
		var ct:ColorTransform = new ColorTransform(0, 0, 0, 1, (rgb >> 16) & 0xff, (rgb >> 8) & 0xff, rgb & 0xff, 0);
		var s:FlxSprite = new FlxSprite();

		s.loadGraphic(AssetPaths.bar__png);
		_bar = s.framePixels.clone();
		_bar.colorTransform(_bar.rect, ct);

		_temp.setTo(_BAR_X, _BAR_Y);
		_src.copyPixels(_bar, _bar.rect, _temp);

		_temp.setTo(_BAR_X, _BAR_Y + _BAR_STEP);
		_src.copyPixels(_bar, _bar.rect, _temp);

		s.loadGraphic(AssetPaths.pad_off__png);
		_padOff = s.framePixels.clone();
		_padOff.colorTransform(_padOff.rect, ct);

		s.loadGraphic(AssetPaths.pad_on__png);
		_padOn = s.framePixels.clone();
		_padOn.colorTransform(_padOn.rect, ct);

		_pads = [];
		for(i in 0...8) {
			_pads[i] = new Bitmap(_padOff);
			var ix:Int = i % 4;
			var iy:Int = Std.int(i / 4);
			_pads[i].x = _BAR_X + ix * _PAD_STEP;
			_pads[i].y = _BAR_Y + iy * _BAR_STEP;
			_pads[i].visible = false;

		}
		
		this.interval = _INTERVAL * FlxG.updateFramerate;
		return this;
	}

	public function createLabels():Void {
		if(_labels.length > 0) {
			return;
		}

		var texts:Array<String> = [Consts.CTRL_A, Consts.CTRL_B];
		for(i in 0...2) {
			var bd:BitmapData = TextGenerator.instance.generate(texts[i], 1);
			var label:Bitmap = new Bitmap(bd);
			label.x = Std.int(_LABEL_WIDTH - label.width) / 2;
			label.y = Std.int(_BAR_Y + i * _BAR_STEP + (_BAR_HEIGHT - label.height) / 2);
			_labels[i] = label;
		}
	}

	override public function update():Void {
		this.time += 1.0;
		if(this.time >= this.interval) {
			this.time = this.time - Std.int(this.time);
		}
		var t:Float = this.time / this.interval;

		var frame:Int = Std.int(t / 0.125);
		if(frame < 0) { frame = 0; }
		if(frame > 7) { frame = 7; }

		if(frame != _lastFrame) {
			if(frame == 0) {
				// input a
				_dispatchInputEvent(Input.A);
				for(i in 0...4) {
					_setPadEnabled(_pads[i], false);
				}
				// input b
				_dispatchInputEvent(Input.B);
				for(i in 4...8) {
					_setPadEnabled(_pads[i], false);
				}
			}
		}

		var input:Input = Input.instance;
		if(input.pressed(Input.A)) {
//			if(frame % 2 == 0) {
				var i:Int = Std.int(frame / 2);
				_setPadEnabled(_pads[i], true);
//			}
		} else if(input.pressed(Input.B)) {
//			if(frame % 2 == 0) {
				var i:Int = Std.int(frame / 2) + 4;
				_setPadEnabled(_pads[i], true);
//			}
		}

		_cursor.x = _LABEL_WIDTH + _BAR_WIDTH * t;

		_lastFrame = frame;
	}

	override public function draw(canvas:Canvas):Void {
		_temp.setTo(0, 0);
		_dst.copyPixels(_src, _src.rect, _temp);

		var bd:BitmapData;

		// draw label
		for(label in _labels) {
			bd = label.bitmapData;
			_pixelize(label.x, label.y, _temp);
			_dst.copyPixels(bd, bd.rect, _temp);
		}

		// draw cursor
		bd = _cursor.bitmapData;
		_temp.setTo(Std.int(_cursor.x), Std.int(_cursor.y));
		_dst.copyPixels(bd, bd.rect, _temp);

		// draw pads
		for(pad in _pads) {
			bd = pad.bitmapData;
			_pixelize(pad.x, pad.y, _temp);
			_dst.copyPixels(bd, bd.rect, _temp);
		}

		canvas.bitblt(_dst, Std.int(_p.x), Std.int(_p.y));
	}

	private function _setPadEnabled(pad:Bitmap, enabled:Bool):Void {
		if(pad.visible == enabled) {
			return;
		}
		pad.visible = enabled;
		pad.bitmapData = enabled ? _padOn : _padOff;
	}

	private function _dispatchInputEvent(button:Int):Void {
		var start:Int = button == Input.A ? 0 : 4;
		var input:String = "";
		for(i in start...(start + 4)) {
			input += _pads[i].visible ? "o" : "-";
		}

		var event:ControllerEvent = new ControllerEvent(ControllerEvent.INPUT);
		event.button = button;
		event.input = input;
		this.dispatchEvent(event);
	}
}

class ControllerPrivateClass {}

