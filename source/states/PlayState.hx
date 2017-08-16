package states;

import enums.Direction;
import enums.Levels;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.FlxPointer;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public var _level 								: TiledLevel;

	public var _player 								: Player;
	public var _exits 								: FlxTypedGroup<FlxSprite>;

	private var _maxiGroup 							: FlxTypedGroup<FlxSprite>;

	public var _currentLevel						: Levels = TUTO;
	public var _previousExitDirection				: Direction = SPECIAL;

	public function new(previousExitDirection:Direction)
	{
		super();
		_previousExitDirection = previousExitDirection;
	}

	override public function create():Void
	{
		_exits = new FlxTypedGroup<FlxSprite>();

		_maxiGroup = new FlxTypedGroup<FlxSprite>();

		switch (_currentLevel)
		{
			case TUTO :
				_level = new TiledLevel("assets/tiled/example.tmx", this);
			case LEVEL_1 :
				_level = new TiledLevel("assets/tiled/urd.tmx", this);
			case LEVEL_2 :
			//
			case LEVEL_3 :
			//
			case END :
				//
		}

		// TODO: a bien init
		if (_previousExitDirection == null)
		{
			_previousExitDirection = Direction.SPECIAL;
		}

		switch (_previousExitDirection)
		{
			case UP:
				_player.setPosition(120, 230);
			case RIGHT:
				_player.setPosition(10, 120);
			case DOWN:
				_player.setPosition(120, 10);
			case LEFT:
				_player.setPosition(230, 120);
			case SPECIAL:
				_player.setPosition(120, 120);
		}

		// Add backgrounds
		add(_level.backgroundLayer);

		// TODO: rentre pas dans le maxigroup, fait chier
		//add(_level.foregroundTiles);

		// TODO: chelou que ça marche pas dans l'autre sens
		// Add foreground tiles after adding level objects, so these tiles render on top of player
		//add(_level.foregroundSpriteTiles);
		_level.foregroundSpriteTiles.forEach(function(sprite:FlxSprite)
		{
			_maxiGroup.add(sprite);
		});

		// Add objects layer
		//add(_level.objectsLayer);
		_level.objectsSpriteLayer.forEach(function(sprite:FlxSprite)
		{
			_maxiGroup.add(sprite);
		});

		add(_maxiGroup);

		FlxG.camera.zoom = 3;

		super.create();
	}

	/**
	 * Comparateur perso pour trier les sprites par Y croissant (en tenant compte de leur hauteur)
	 * @param	Order
	 * @param	Obj1
	 * @param	Obj2
	 * @return
	 */
	public function byYDown(Order:Int, Obj1:FlxObject, Obj2:FlxObject):Int
	{
		return Obj1.y + Obj1.height < Obj2.y + Obj2.height ? -1 : 1;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_maxiGroup.sort(byYDown);

		_level.collideWithLevel(_player);

		FlxG.overlap(_player, _exits, PlayerExit);

		#if debug
		/////////////////////////////////////////////////////////////////////// SECTION DEBUG
		// Il faut obligatoirement avoir SHIFT d'enfoncer pour utiliser ces fonctions de debug
		if (FlxG.keys.pressed.SHIFT)
		{
			// Aller direct à l'exit
			if (FlxG.keys.justPressed.E)
			{
				switch (_currentLevel)
				{
					case TUTO :
						_player.x = 256;
						_player.y = 432;
					case LEVEL_1 :
						_player.x = 1232;
						_player.y = 432;
					case LEVEL_2 :
						_player.x = 48;
						_player.y = 32;
					case LEVEL_3 :
						_player.x = 576;
						_player.y = 32;
					case END :
						_player.x = 160;
						_player.y = 32;
				}
			}

			FlxG.camera.zoom += FlxG.mouse.wheel / 20;
		}
		////////////////////////////////////////////////// FIN SECTION DEBUG
		#end
	}

	/**
	 * Indique que le joueur est arrivé à la sortie du niveau !
	 * @param	player
	 * @param	sprite
	 */
	private function PlayerExit(player:Player, exit:Exit):Void
	{
		trace(exit._direction);
		exit.exists = false;
		if (player.alive && player.exists)
		{
			// TODO: next screen
			switch (exit._direction)
			{
				case UP:
					FlxTween.tween(FlxG.camera, {y: 720}, 0.3, {onComplete: switchState.bind(_, exit)});
				case RIGHT:
					FlxTween.tween(FlxG.camera, {x: -720}, 0.3, {onComplete: switchState.bind(_, exit)});
				case DOWN:
					FlxTween.tween(FlxG.camera, {y: -720}, 0.3, {onComplete: switchState.bind(_, exit)});
				case LEFT:
					FlxTween.tween(FlxG.camera, {x: 720}, 0.3, {onComplete: switchState.bind(_, exit)});
				case SPECIAL:
					FlxG.switchState(new PlayState(exit._direction));
			}
			//FlxTween.tween(FlxG.camera, {x:720}, 0.3, {onComplete: switchState});
			//FlxG.switchState(new PlayState(exit._direction));
		}
	}

	private function switchState(tween:FlxTween, exit:Exit):Void
	{
		Sys.sleep(0.5);
		FlxG.switchState(new PlayState(exit._direction));
	}
}