package states;

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

	public var _currentLevel						: Levels = TUTO;

	//public function new(level:Levels)
	//{
	//super();
	//_currentLevel = level;
	//}

	override public function create():Void
	{
		_exits = new FlxTypedGroup<FlxSprite>();
		
		switch (_currentLevel)
		{
			case TUTO :
				_level = new TiledLevel("assets/tiled/example.tmx", this);
			case LEVEL_1 :
			//_level = new FlxOgmoLoader(AssetPaths.level_1_new__oel);
			case LEVEL_2 :
			//_level = new FlxOgmoLoader(AssetPaths.level_2_new__oel);
			case LEVEL_3 :
			//_map = new FlxOgmoLoader(AssetPaths.level_3_new__oel);
			case END :
				//_level = new FlxOgmoLoader(AssetPaths.end_new__oel);
		}

		// Add backgrounds
		add(_level.backgroundLayer);
		
		// TODO: chelou que ça marche pas dans l'autre sens
		// Add foreground tiles after adding level objects, so these tiles render on top of player
		add(_level.foregroundTiles);
		
		// Load player objects
		add(_level.objectsLayer);
		
		FlxG.camera.zoom = 3;

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

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
		}
		////////////////////////////////////////////////// FIN SECTION DEBUG
		#end
	}

	/**
	 * Indique que le joueur est arrivé à la sortie du niveau !
	 * @param	player
	 * @param	sprite
	 */
	private function PlayerExit(player:Player, sprite:FlxSprite):Void
	{
		if (player.alive && player.exists)
		{
			// TODO: next screen
		}
	}
}