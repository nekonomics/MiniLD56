package;

import flash.display.BitmapData;
import flash.geom.Matrix;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxDestroyUtil;
import retricon.Retricon;
import retricon.Options;
import minild56.Consts;
import minild56.Palette;
import minild56.Canvas;
import minild56.Input;
import minild56.GameMain;
import minild56.TextEntity;
import minild56.TextGenerator;
import minild56.DisplayEntity;

using flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends BaseState
{
	private var _canvas:Canvas;
	private var _player:DisplayEntity;
	private var _playerTimer:FlxTimer;

	/**ı
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		_setupState();

		var canvas:Canvas = Canvas.instance;

		var title:TextEntity = new TextEntity(Consts.TITLE, 4);
		title.x = (canvas.width - title.width) / 2;
		title.y = 8;
		canvas.addChild(title);

		// var menuStart:TextEntity = new TextEntity(Consts.MENU_START, 1);
		// menuStart.x = (canvas.width - menuStart.width) / 2;
		// menuStart.y = 136;
		// canvas.addChild(menuStart);

		// var menuOptions:TextEntity = new TextEntity(Consts.MENU_OPTIONS, 1);
		// menuOptions.x = (canvas.width - menuOptions.width) / 2;
		// menuOptions.y = 152;
		// canvas.addChild(menuOptions);

		var opts:Options = new Options();
		opts.tiles = 8;
		opts.pixelSize = 1;
		opts.pixelColor = Palette.convertToString(Palette.color1);
		opts.bgColor = Palette.convertToString(Palette.color0);

		var player:DisplayEntity = _player = new DisplayEntity();
		var src:BitmapData = Retricon.retricon(Consts.PLAYER_RETRICON, opts);
		var dst:BitmapData = new BitmapData(src.width * 2, src.height * 2, false, 0);
		dst.draw(src, new Matrix(2, 0, 0, 2, 0, 0));
		player.setBitmapData(dst);
		player.x = (canvas.width - player.width) / 2;
		player.y = 128;
		canvas.addChild(player);

		var playerText:TextEntity = new TextEntity(Consts.PLAYER_TEXT, 1);
		playerText.x = player.x + 24;
		playerText.y = player.y;
		canvas.addChild(playerText);

		_playerTimer = new FlxTimer(1, _onPlayerTimer, 0);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		var input:Input = Input.instance;
		if(input.hasInputA) { _parseInput(input.inputA); }
		if(input.hasInputB) { _parseInput(input.inputB); }

		// if(Input.instance.pressed(Input.FIRE)) {
		// 	Canvas.instance.removeAllChildren(true);
		// 	_teardownState();
		// 	FlxG.switchState(new PlayState());
		// }
	}	

	private function _parseInput(s:String):Void {
		switch(s) {
			case Consts.TITLE:
			Canvas.instance.removeAllChildren(true);
			_teardownState();
			FlxG.switchState(new PlayState());	
		}
	}

	private function _onPlayerTimer(timer:FlxTimer):Void {
		var x:Float = (Consts.FIELD_WIDTH - _player.width) / 2;
		_player.x = x + (_player.x < x ? 4 : -4);
	}
}