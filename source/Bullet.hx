package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ElRyoGrande
 */
enum Direction{UP; RIGHT; DOWN; LEFT; }
 
class Bullet extends FlxSprite 
{

	
	
	var speed				: Int = 100;
	var Xspeed				:Int = 0;
	var Yspeed				:Int = 0;
	
	public var _isHorizontal 		: Bool;
	public var _isShooted 			: Bool = false;
	
/*	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(5, 5, FlxColor.BLACK, false);
		//_isHorizontal = true;
		
		_isShooted = true;
	
		
	}*/
	
	override public function new(X:Float=0,Y:Float=0,dir:Int)
	{
		super(X, Y);
		
		defineDirection(dir);
		
		trace(dir);
		_isShooted = true;
		makeGraphic(5, 5, FlxColor.BLACK, false);
	}
	
	public function defineDirection(dir:Int)
	{
		switch dir {
			case 0: Yspeed = -speed; 
			case 1: Xspeed = speed;
			case 2: Yspeed = speed;
			case 3: Xspeed = -speed;
			default: Yspeed = Xspeed = 0; 
		}
	}
	
	public function shooted()
	{
		
	}
	
	override public function update(elapsed:Float):Void
	{

		if (_isShooted)
		{
			this.velocity.set(Xspeed, Yspeed);
		}
		super.update(elapsed);
	}
	
}