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
import haxe.EnumFlags;
import utils.Utils;

class PlayState extends FlxState
{
	public var _level 								: TiledLevel;

	public var _player 								: Player;

	private var _maxiGroup 							: FlxTypedGroup<FlxSprite>;

	public var _currentLevel						: Levels 	= TUTO;
	public var _previousExitDirection				: Direction = SPECIAL;
	
	public var _rooms 								: Array<Array<TiledLevel>>;

	public function new(previousExitDirection:Direction)
	{
		super();
		_previousExitDirection = previousExitDirection;
	}

	override public function create():Void
	{
		var roomsTypes:Array<Array<String>> = [
			["rd", 	"dl", 		null, 	"d"],
			["ur", 	"example", "rl", 	"udl"],
			[null, 	"ud", 		null, 	"ud"],
			["r", 	"ul", 		null, 	"u"]
		];
		
		_rooms = new Array<Array<TiledLevel>>();
		
		for (y in 0...4) {
			_rooms[y] = new Array<TiledLevel>();
			for (x in 0...4) {
				
				if (roomsTypes[y][x] == null)
					continue;
					
				_rooms[y][x] = new TiledLevel("assets/tiled/" + roomsTypes[y][x] + ".tmx", this, x, y);
				
				if (roomsTypes[y][x] == "example") {
					_rooms[y][x].setActive(true);
				} else {
					_rooms[y][x].setActive(false);
				}
				
				add(_rooms[y][x]._backgroundLayer);
			}
		}
		
		_maxiGroup = new FlxTypedGroup<FlxSprite>();

		switch (_currentLevel)
		{
			case TUTO :
				_level = new TiledLevel("assets/tiled/example.tmx", this, 0, 0);
			case LEVEL_1 :
				_level = new TiledLevel("assets/tiled/urd.tmx", this, 0, 0);
			case LEVEL_2 :
				//
			case LEVEL_3 :
				//
			case END :
				//
		}
		
		_level.setActive(true);
		
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
			case NONE:
				// TODO:
		}

		// Add backgrounds
		add(_level._backgroundLayer);
		
		// TODO: rentre pas dans le maxigroup, fait chier
		//add(_level.foregroundTiles);

		// TODO: chelou que ça marche pas dans l'autre sens
		// Add foreground tiles after adding level objects, so these tiles render on top of player
		//add(_level.foregroundSpriteTiles);
		_level._foregroundSpriteTiles.forEach(function(sprite:FlxSprite)
		{
			_maxiGroup.add(sprite);
		});

		// Add objects layer
		//add(_level.objectsLayer);
		_level._objectsSpriteTiles.forEach(function(sprite:FlxSprite)
		{
			_maxiGroup.add(sprite);
		});

		add(_maxiGroup);

		FlxG.camera.zoom = 3;
		
		FlxG.camera.fade(FlxColor.BLACK, .2, true);
		
		FlxG.camera.follow(_player, LOCKON, 1);

		super.create();
	}



	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_maxiGroup.sort(Utils.sortByYAscending);

		_level.collideWithLevel(_player);

		//FlxG.overlap(_player, _level._exits, PlayerExit);

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
					FlxTween.tween(FlxG.camera, {y: 1000}, 0.3, {onComplete: switchState.bind(_, exit)});
				case RIGHT:
					FlxTween.tween(FlxG.camera, {x: -1000}, 0.3, {onComplete: switchState.bind(_, exit)});
				case DOWN:
					FlxTween.tween(FlxG.camera, {y: -1000}, 0.3, {onComplete: switchState.bind(_, exit)});
				case LEFT:
					FlxTween.tween(FlxG.camera, {x: 1000}, 0.3, {onComplete: switchState.bind(_, exit)});
				case SPECIAL:
					//
				case NONE:
					//
			}
			FlxG.camera.fade(FlxColor.BLACK, 0.3, false, function()
			{
				FlxG.switchState(new PlayState(exit._direction));
			});
			//FlxTween.tween(FlxG.camera, {x:720}, 0.3, {onComplete: switchState});
			//FlxG.switchState(new PlayState(exit._direction));
		}
	}

	private function switchState(tween:FlxTween, exit:Exit):Void
	{
		//Sys.sleep(0.5);
		//FlxG.switchState(new PlayState(exit._direction));
	}
}