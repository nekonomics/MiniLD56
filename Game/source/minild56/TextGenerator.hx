
package minild56;

import flash.display.BitmapData;
import flash.geom.Matrix;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxDestroyUtil;

class TextGenerator extends FlxGroup {

	public static var instance(default, null):TextGenerator = new TextGenerator(TextGeneratorPrivateClass);

	public var textField(default, null):FlxText;

	private var _mat:Matrix;

	private function new(pvc:Class<TextGeneratorPrivateClass>):Void {
		super();
		this.visible = false;
	}

	public function init():Void {
		if(this.textField != null) {
			this.textField = FlxDestroyUtil.destroy(this.textField);
		}

		var tf:FlxText = this.textField = new FlxText(0, 0, 100);
		tf.text = "text";
		tf.setFormat("assets/data/emulogic.ttf", 8, Palette.color3, "left");
		tf.wordWrap = false;
		tf.autoSize = true;
		add(tf);

		_mat = new Matrix();
	}

	public function generate(text:String, size:Int = 1):BitmapData {
		if(size <= 0) {
			return null;
		}

		var tf:FlxText = this.textField;
		tf.text = text;
		tf.drawFrame(true);

		if(size == 1) {
			return tf.framePixels.clone();
		}

		var src:BitmapData  = tf.framePixels;
		var dst:BitmapData = new BitmapData(src.width * size, src.height * size, true, 0);
		_mat.identity();
		_mat.scale(size, size);
		dst.draw(src, _mat);

		return dst;
	}
}

class TextGeneratorPrivateClass {}