
package minild56;

import flixel.util.FlxRandom;

class Palette 
{
	private static var _COLORS:Array<UInt> = [
		0x3399ff,
		0x7C7C7C,
		0x0000FC,
		0x0000BC,
		0x4428BC,
		0x940084,
		0xA80020,
		0xA81000,
		0x881400,
		0x503000,
		0x007800,
		0x006800,
		0x005800,
		0x004058,
		0x000000,
		//0x000000,
		//0x000000,
		0xBCBCBC, 
		0x0078F8, 
		0x0058F8, 
		0x6844FC, 
		0xD800CC, 
		0xE40058, 
		0xF83800, 
		0xE45C10, 
		0xAC7C00, 
		0x00B800, 
		0x00A800, 
		0x00A844, 
		0x008888, 
		//0x000000, 
		//0x000000, 
		//0x000000, 
		0xF8F8F8, 
		0x3CBCFC, 
		0x6888FC, 
		0x9878F8, 
		0xF878F8, 
		0xF85898, 
		0xF87858, 
		0xFCA044, 
		0xF8B800, 
		0xB8F818, 
		0x58D854, 
		0x58F898, 
		0x00E8D8, 
		0x787878, 
		//0x000000, 
		//0x000000, 
		0xFCFCFC, 
		0xA4E4FC, 
		0xB8B8F8, 
		0xD8B8F8, 
		0xF8B8F8, 
		0xF8A4C0, 
		0xF0D0B0, 
		0xFCE0A8, 
		0xF8D878, 
		0xD8F878, 
		0xB8F8B8, 
		0xB8F8D8, 
		0x00FCFC, 
		0xF8D8F8, 
		//0x000000, 
		//0x000000
	];

	public static var color0(default, null):UInt = _COLORS[0];
	public static var color1(default, null):UInt = _COLORS[6];
	public static var color2(default, null):UInt = _COLORS[37];
	public static var color3(default, null):UInt = _COLORS[48];

	public static function randomize(seed:Int = -1):Void {
		FlxRandom.globalSeed = seed == -1 ? Std.int(Date.now().getTime()) : seed;
		var temp:Array<Int> = [];
		var len:Int = _COLORS.length;
		for(i in 0...len) { temp[i] = i; }
		for(i in 0...len) {
			var r:Int = FlxRandom.intRanged(0, len);
			var t:Int = temp[i];
			temp[i] = temp[r];
			temp[r] = t;
		}
		color0 = _COLORS[temp[0]];
		color1 = _COLORS[temp[1]];
		color2 = _COLORS[temp[2]];
		color3 = _COLORS[temp[3]];
	}

	public static function convertToString(color:UInt):String {
		var s:String = "";
		s += StringTools.hex((color >> 16) & 0xff, 2);
		s += StringTools.hex((color >>  8) & 0xff, 2);
		s += StringTools.hex(color & 0xff, 2);
		return s;
	}
}