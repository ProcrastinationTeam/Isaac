package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import utils.Tweaking;

class Player extends FlxSprite
{
	// Polishing
	public var _aaahSound							: FlxSound;
	public var _bulletSprite						: FlxSprite;

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);

		loadGraphic(Tweaking.playerSprite, true, 16, 16);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);

		animation.add("idle", [0], 10, true);
		animation.add("walk", [0, 1, 2, 1], 6, true);
		animation.add("run", [4, 3], 6, true);
		animation.add("text", [5, 6], 6, true);
		animation.add("call", [7, 8], 6, true);

		drag.x = drag.y = 1600;

		setSize(8, 6);
		offset.set(4, 10);

		//_aaahSound = FlxG.sound.load(AssetPaths.aaaah__wav);
	}

	override public function update(elapsed:Float):Void
	{
		movement();

		super.update(elapsed);
	}
	
	// TODO: pas e(encore) utilisé
	public function shoot():FlxSprite
	{
		var shootUp:Bool = FlxG.keys.anyPressed([Tweaking.shootUp]);
		var shootDown:Bool = FlxG.keys.anyPressed([Tweaking.shootDown]);
		var shootLeft:Bool = FlxG.keys.anyPressed([Tweaking.shootLeft]);
		var shootRight:Bool = FlxG.keys.anyPressed([Tweaking.shootRight]);
		
		var bullet : FlxSprite = new FlxSprite(250, 250);
		_bulletSprite = new FlxSprite(this.getPosition().x, this.getPosition().y);
		return _bulletSprite;
	}
	
	/**
	 * Gestion des mouvements
	 */
	private function movement():Void
	{
		var moveUp:Bool = FlxG.keys.anyPressed([Tweaking.moveUp]);
		var moveDown:Bool = FlxG.keys.anyPressed([Tweaking.moveDown]);
		var moveLeft:Bool = FlxG.keys.anyPressed([Tweaking.moveLeft]);
		var moveRight:Bool = FlxG.keys.anyPressed([Tweaking.moveRight]);
		
		if (moveUp && moveDown)
		{
			moveUp = moveDown = false;
		}

		if (moveLeft && moveRight)
		{
			moveLeft = moveRight = false;
		}

		if (moveUp || moveDown || moveLeft || moveRight)
		{
			var _ma:Float = 0;

			if (moveUp)
			{
				_ma = -90;
				if (moveLeft)
				{
					_ma -= 45;
				}
				else if (moveRight)
				{
					_ma += 45;
				}
			}
			else if (moveDown)
			{
				_ma = 90;
				if (moveLeft)
				{
					_ma += 45;
				}
				else if (moveRight)
				{
					_ma -= 45;
				}
			}
			else if (moveLeft)
			{
				_ma = 180;
				facing = FlxObject.LEFT;
			}
			else if (moveRight)
			{
				_ma = 0;
				facing = FlxObject.RIGHT;
			}

			if (moveLeft)
			{
				facing = FlxObject.LEFT;
			}
			else if (moveRight)
			{
				facing = FlxObject.RIGHT;
			}

			velocity.set(Tweaking.playerWalkingSpeed, 0);
			velocity.rotate(FlxPoint.weak(0, 0), _ma);
			if ((velocity.x != 0 || velocity.y != 0))
			{
				animation.play("walk");
			}
		}
		else
		{
			// TODO: le mettre sur son tel !
			animation.play("idle");
		}
	}
}