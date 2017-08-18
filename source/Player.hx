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
		// Gestion du mouvement
		movement();

		super.update(elapsed);
	}

	
	public function shoot():FlxSprite
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;

		// AZERTY
		_up = FlxG.keys.anyPressed([Z]);
		_down = FlxG.keys.anyPressed([S]);
		_left = FlxG.keys.anyPressed([Q]);
		_right = FlxG.keys.anyPressed([D]);
		
		
			var bullet : FlxSprite = new FlxSprite(250, 250);
			_bulletSprite = new FlxSprite(this.getPosition().x, this.getPosition().y);
			return _bulletSprite;
	}
	
	
	/**
	 * Gestion des mouvements et sprint
	 */
	private function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;

		// AZERTY
		_up = FlxG.keys.anyPressed([UP]);
		_down = FlxG.keys.anyPressed([DOWN]);
		_left = FlxG.keys.anyPressed([LEFT]);
		_right = FlxG.keys.anyPressed([RIGHT]);
		
		// QWERTY
		//_up = FlxG.keys.anyPressed([UP, W]);
		//_down = FlxG.keys.anyPressed([DOWN, S]);
		//_left = FlxG.keys.anyPressed([LEFT, A]);
		//_right = FlxG.keys.anyPressed([RIGHT, D]);

		if (_up && _down)
		{
			_up = _down = false;
		}

		if (_left && _right)
		{
			_left = _right = false;
		}

		if (_up || _down || _left || _right)
		{
			var _ma:Float = 0;

			if (_up)
			{
				_ma = -90;
				if (_left)
				{
					_ma -= 45;
				}
				else if (_right)
				{
					_ma += 45;
				}
			}
			else if (_down)
			{
				_ma = 90;
				if (_left)
				{
					_ma += 45;
				}
				else if (_right)
				{
					_ma -= 45;
				}
			}
			else if (_left)
			{
				_ma = 180;
				facing = FlxObject.LEFT;
			}
			else if (_right)
			{
				_ma = 0;
				facing = FlxObject.RIGHT;
			}

			if (_left)
			{
				facing = FlxObject.LEFT;
			}
			else if (_right)
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