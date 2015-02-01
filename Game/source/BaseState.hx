
package;

import flixel.FlxState;
import minild56.Controller;
import minild56.Input;
import minild56.TextGenerator;
import minild56.Canvas;
import minild56.Palette;

class BaseState extends FlxState {

	private function _setupState():Void {
		add(Input.instance);
		add(TextGenerator.instance);
		TextGenerator.instance.init();
		Controller.instance.createLabels();

		this.bgColor = Palette.color0;

		var canvas:Canvas = Canvas.instance;
		add(canvas);
	}

	private function _teardownState():Void {
		remove(Input.instance);
		remove(TextGenerator.instance);
		remove(Canvas.instance);
	}

}