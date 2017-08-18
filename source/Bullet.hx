package;

import enums.Direction;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import utils.Tweaking;

class Bullet extends FlxSprite 
{
	var Xspeed						: Int = 0;
	var Yspeed						: Int = 0;
	
	public var _isHorizontal 		: Bool;
	public var _isShot 			: Bool = false;
	
/*	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(5, 5, FlxColor.BLACK, false);
		//_isHorizontal = true;
		
		_isShooted = true;
	
		
	}*/
	
	override public function new(X:Float=0, Y:Float=0, dir:Direction)
	{
		super(X, Y);
		
		defineDirection(dir);
		
		//trace(dir);
		_isShot = true;
		makeGraphic(5, 5, FlxColor.BLACK, false);
	}
	
	public function defineDirection(dir:Direction)
	{
		switch dir {
			case UP:		Yspeed = -Tweaking.bulletSpeed; 
			case RIGHT: 	Xspeed = Tweaking.bulletSpeed;
			case DOWN: 		Yspeed = Tweaking.bulletSpeed;
			case LEFT: 		Xspeed = -Tweaking.bulletSpeed;
			default: 		Yspeed = Xspeed = 0; 
		}
	}
	
	public function shooted()
	{
		
	}
	
	override public function update(elapsed:Float):Void
	{
		if (_isShot)
		{
			this.velocity.set(Xspeed, Yspeed);
		}
		super.update(elapsed);
	}
}