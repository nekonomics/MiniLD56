package;

import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import minild56.Consts;
import minild56.Input;
import minild56.Canvas;
import minild56.Player;
import minild56.PlayerShot;
import minild56.Enemy;
import minild56.EnemyShot;
import minild56.EnemySpawner;
import minild56.Collider;
import minild56.ColliderEvent;
import minild56.ColliderEntry;
import minild56.TextEntity;
import minild56.TextGenerator;
import minild56.Score;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends BaseState
{

	private var _player:Player;
	private var _playerPos:Point;
	private var _enemySpawner:EnemySpawner;
	private var _score:Score;
	private var _gameover:TextEntity;
	private var _back:TextEntity;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		_setupState();

		var canvas:Canvas = Canvas.instance;

		_player = new Player(Consts.PLAYER_RETRICON);

		_enemySpawner = new EnemySpawner(10.0 * FlxG.updateFramerate);

		_score = new Score();
		_score.x = 2;
		_score.y = 2;

		_gameover = new TextEntity(Consts.GAMEOVER, 4);
		_gameover.x = (Consts.FIELD_WIDTH - _gameover.width) / 2;
		_gameover.y = (Consts.FIELD_HEIGHT - _gameover.height) / 2;

		_back = new TextEntity(Consts.BACK, 1);
		_back.x = (Consts.FIELD_WIDTH - _back.width) / 2;
		_back.y = _gameover.y + _gameover.height + 8;

		Collider.instance.addEventListener(ColliderEvent.COLLIDE, _onCollide);

		_start();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();

		Collider.instance.removeEventListener(ColliderEvent.COLLIDE, _onCollide);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		if(!_player.alive) {
			var input:Input = Input.instance;
			if(input.hasInputA) { _parseInput(input.inputA); }
			if(input.hasInputB) { _parseInput(input.inputB); }
		}
	}

	private function _parseInput(s:String):Void {
		switch (s) {
			case Consts.GAMEOVER:
			_start();

			case Consts.BACK:
			Canvas.instance.removeAllChildren(true);
			_teardownState();
			FlxG.switchState(new MenuState());			
		}
	}

	private function _start():Void {
		var canvas:Canvas = Canvas.instance;

		canvas.removeAllChildren(true);

		_player.reset();
		_player.x = (Consts.FIELD_WIDTH - _player.width) / 2;
		_player.y = (Consts.FIELD_HEIGHT - _player.height) / 2;
		canvas.addChild(_player);

		_enemySpawner.reset();
		canvas.addChild(_enemySpawner);

		_score.score = 0;
		canvas.addChild(_score);
	}

	private function _finish():Void {
		var canvas:Canvas = Canvas.instance;
		canvas.addChild(_gameover);
		canvas.addChild(_back);
		_enemySpawner.spawnEnabled = false;
	}

	private function _onCollide(event:ColliderEvent):Void {
		// trace("collide", event.entry0.catBits, event.entry1.catBits);

		var e0:ColliderEntry = event.entry0;
		var e1:ColliderEntry = event.entry1;
		if(e0.catBits > e1.catBits) {
			var t:ColliderEntry = e0; e0 = e1; e1 = t;
		}

		if(Std.is(e0.entity, Player)) {
			if(Std.is(e1.entity, Enemy)) {
				// player vs enemy
				_finish();
				e0.entity.kill();
				return;
			}
			if(Std.is(e1.entity, EnemyShot)) {
				// player vs enemy shot
				_finish();
				e0.entity.kill();
				e1.entity.kill();
				return;
			}
			return;
		}

		if(Std.is(e0.entity, PlayerShot)) {
			if(Std.is(e1.entity, Enemy)) {
				// player shot vs enemy
				_score.score += 10;
				e0.entity.kill();
				e1.entity.kill();
				return;
			}
			return;
		}
	}
}