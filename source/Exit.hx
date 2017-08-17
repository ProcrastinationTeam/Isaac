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
	
	public function new(X:Int, Y:Int, Width:Int, Height:Int, direction:Direction)
	{
		super(X, Y);
		makeGraphic(Width, Height, FlxColor.CYAN); // TRANSPARENT sinon
		_direction = direction;
	}
}