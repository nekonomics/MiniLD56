
package minild56;

class TextEntity extends DisplayEntity {

	public function new(text:String, size:Int = 1, tag:String = ""):Void {
		super(tag);
		_src = _dst = TextGenerator.instance.generate(text, size);
	}

}