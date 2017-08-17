package;

import enums.Direction;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;

class Exit extends FlxSprite
{
	public var _direction		: Direction;
	
	public function new(X:Int, Y:Int, Width:Int, Height:Int, stringDirection:String)
	{
		super(X, Y);
		makeGraphic(Width, Height, FlxColor.CYAN); // TRANSPARENT sinon
		
		switch (stringDirection)
		{
			case "up":
				_direction = Direction.UP;
			case "right":
				_direction = Direction.RIGHT;
			case "down":
				_direction = Direction.DOWN;
			case "left":
				_direction = Direction.LEFT;
			case "special":
				_direction = Direction.SPECIAL;
			default:
				_direction = Direction.SPECIAL;
		}
	}
}