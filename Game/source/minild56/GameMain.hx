
package minild56;

import flixel.FlxG;

class GameMain extends Entity {

	public static var instance(default, null) = new GameMain(GameMainPrivateClass);

	public var player(default, null):Player;

	private var _enemies:Array<Enemy>;
	private var _enemySpawner:EnemySpawner;

	public function new(pvc:Class<GameMainPrivateClass>) {
		super();
	}

	public function init():Void {
		var canvas:Canvas = Canvas.instance;

		this.player = new Player("hello");
		this.player.x = (Consts.FIELD_WIDTH - this.player.width) / 2;
		this.player.y = (Consts.FIELD_HEIGHT - this.player.height) / 2;
		canvas.addChild(this.player);

		_enemies = [];

		_enemySpawner = new EnemySpawner(100.0 * FlxG.updateFramerate);
		canvas.addChild(_enemySpawner);		
	}

	override public function update():Void {

	}
}

class GameMainPrivateClass {}