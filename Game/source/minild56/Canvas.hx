
package minild56;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.util.FlxPoint;

using Lambda;

class Canvas extends FlxBasic {

	public static var instance(default, null) = new Canvas(CanvasPrivateClass);

	private static inline var _USE_DEBUG_DRAW:Bool = false;

	public var bitmap(default, null):Bitmap;
	public var bitmapData(default, null):BitmapData;
	public var scale(default, null):Int = 1;

	public var width(default, null):Int = 0;
	public var height(default, null):Int = 0;

	private var _children:Array<Entity>;
	private var _tempPoint:Point;
	private var _tempRect:Rectangle;

	private var _debugShape:Shape;

	private function new(pvc:Class<CanvasPrivateClass>) {
		super();

		_children = [];
		_tempPoint = new Point();
		_tempRect = new Rectangle();

		_debugShape = new Shape();

	}

	public function init(scale:Int):Canvas {
		this.scale = scale;
		var w:Int = Std.int(FlxG.width / scale);
		var h:Int = Std.int(FlxG.height / scale);
		this.bitmapData = new BitmapData(w, h, false, Palette.color0);
		this.bitmap = new Bitmap(this.bitmapData);
		this.bitmap.scaleX = this.bitmap.scaleY = scale;
		this.width = this.bitmapData.width;
		this.height = this.bitmapData.height;
		_debugShape.scaleX = _debugShape.scaleY = scale;
		return this;
	}

	override public function update() {
		super.update();
		this.bitmapData.fillRect(this.bitmapData.rect, Palette.color0);

		this.debugDrawClear();

		var ctrl:Controller = Controller.instance;
		ctrl.update();

		for(e in _children) {
			e.update();
		}

		Collider.instance.exec();

		var removes:Array<Entity> = _children.filter(_filterRemoves);
		for(e in removes) {
			_children.remove(e);
		}

		for(e in _children) {
			e.draw(this);
		}

		ctrl.draw(this);
	}

	public function bitblt(bd:BitmapData, x:Int, y:Int):Void {
		_tempPoint.setTo(x, y);
		this.bitmapData.copyPixels(bd, bd.rect, _tempPoint);
	}

	public function bitblt2(x:Int, y:Int, width:Int, height:Int, color:UInt):Void {
		_tempRect.setTo(x, y, width, height);
		this.bitmapData.fillRect(_tempRect, color);
	}

	public function addChild(entity:Entity):Void {
		entity.exists = true;
		_children.push(entity);
	}

	public function removeChild(entity:Entity):Void {
		entity.exists = false;
	}

	public function removeAllChildren(needUpdate:Bool = false):Void {
		for(e in _children) {
			this.removeChild(e);
		}
		if(needUpdate) {
			this.update();
		}
	}

	public function findWithTag(tag:String):Entity {
		return _children.find(function(e:Entity):Bool { return e.tag == tag; });
	}

	public function center():Point {
		return new Point(this.width / 2, this.height / 2);
	}

	public function debugDrawClear():Void {
		if(!_USE_DEBUG_DRAW) { return; }
		var shape:Shape = _getDebugDraw();
		var g:Graphics = shape.graphics;
		g.clear();
	}

	public function debugDrawRect(rect:Rectangle):Void {
		if(!_USE_DEBUG_DRAW) { return; }
		var shape:Shape = _getDebugDraw();
		var g:Graphics = shape.graphics;
		g.lineStyle(1.0 / this.scale, 0x00ff00);
		g.drawRect(rect.x, rect.y, rect.width, rect.height);
	}

	private function _getDebugDraw():Shape {
		if(!_USE_DEBUG_DRAW) { return null; }
		if(_debugShape.parent == null && this.bitmap.parent != null) {
			this.bitmap.parent.addChild(_debugShape);
		}
		return _debugShape;
	}

	private function _filterRemoves(entity:Entity):Bool {
		return !entity.exists;
	}

}

class CanvasPrivateClass {}