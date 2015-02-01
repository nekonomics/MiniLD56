
package minild56;

class Consts {

	public static inline var FIELD_WIDTH:Int = 320;
	public static inline var FIELD_HEIGHT:Int = 192;

	public static inline var TITLE:String = "o-o-";
	public static inline var GAMEOVER:String = "-o-o";
	public static inline var BACK:String = "oooo";

	public static inline var MENU_START:String = "oo--";
	public static inline var MENU_OPTIONS:String = "--oo";

	public static inline var PLAYER_MOVE_LEFT:String  = "o---";
	public static inline var PLAYER_MOVE_RIGHT:String = "---o";
	public static inline var PLAYER_MOVE_UP:String    = "-o--";
	public static inline var PLAYER_MOVE_DOWN:String  = "--o-";

	public static inline var PLAYER_FIRE_LEFT:String  = "o---";
	public static inline var PLAYER_FIRE_RIGHT:String = "---o";
	public static inline var PLAYER_FIRE_UP:String    = "-o--";
	public static inline var PLAYER_FIRE_DOWN:String  = "--o-";

	public static inline var PLAYER_TEXT:String = "<let's dance!";

	public static inline var CTRL_A:String = "F";
	public static inline var CTRL_B:String = "J";

	public static var PLAYER_RETRICON(default, null):String = "player";
	public static var ENEMY0_RETRICON(default, null):String = "enemy0";
	public static var ENEMY1_RETRICON(default, null):String = "enemy1";
	public static var ENEMY2_RETRICON(default, null):String = "enemy2";
	public static var ENEMY3_RETRICON(default, null):String = "enemy3";

	public static function init():Void {
		PLAYER_RETRICON = "player" + Date.now().getTime();
		ENEMY0_RETRICON = "enemy0" + Date.now().getTime();
		ENEMY1_RETRICON = "enemy1" + Date.now().getTime();
		ENEMY2_RETRICON = "enemy2" + Date.now().getTime();
		ENEMY3_RETRICON = "enemy3" + Date.now().getTime();
	}
}
