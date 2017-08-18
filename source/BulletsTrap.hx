package;

import enums.Direction;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import states.PlayState;
import utils.Tweaking;

class BulletsTrap extends FlxSprite
{
	private var _state 				: PlayState;
	private var _timeSinceLastShot	: Float;
	
	public function new(?X:Float=0, ?Y:Float=0, state:PlayState)
	{
		super(X, Y);
		makeGraphic(8, 8, FlxColor.RED);
		setSize(8, 8);
		offset.set(4, 4);

		_state = state;
		_timeSinceLastShot = 0;
	}

	override public function update(elapsed:Float):Void
	{
		_timeSinceLastShot += elapsed;
		
		if (_timeSinceLastShot >= Tweaking.trapBulletCooldown) {
			_timeSinceLastShot = 0;
			
			var bulletUp:Bullet = new Bullet(x, y, Direction.UP);
			var bulletRight:Bullet = new Bullet(x, y, Direction.RIGHT);
			var bulletDown:Bullet = new Bullet(x, y, Direction.LEFT);
			var bulletLeft:Bullet = new Bullet(x, y, Direction.DOWN);

			_state.add(bulletUp);
			_state.add(bulletRight);
			_state.add(bulletDown);
			_state.add(bulletLeft);
		}

		super.update(elapsed);
	}
}