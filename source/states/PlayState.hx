package states;

import enums.Direction;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import utils.Tweaking;
import utils.Utils;
import flixel.addons.util.FlxAsyncLoop;
import hud.Hud;
import flixel.FlxCamera;

class PlayState extends FlxState
{
	public var _player 								: Player;

	// Position du joueur dans la grille du niveau (coordonnées de la salle en cours quoi, (0,0) tout en haut à gauche)
	// TODO: mettre un meilleur par défaut
	public var _playerPositionInTheLevel			: FlxPoint = new FlxPoint(0, 0);

	public var _maxiGroup 							: FlxTypedGroup<FlxSprite>;

	//public var _previousExitDirection				: Direction = SPECIAL;

	public var _rooms 								: Array<Array<TiledRoom>>;
	public var _currentRoom 						: TiledRoom;
	
	private var _hud								: Hud;
	private var _hudCam 							: FlxCamera;

	//public function new(previousExitDirection:Direction)
	//{
	//super();
	//_previousExitDirection = previousExitDirection;
	//}

	override public function create():Void
	{
		_maxiGroup = new FlxTypedGroup<FlxSprite>();

		var roomsTypes:Array<Array<String>> = [
			["rd", 		"dl", 		null, 		"d", 		null, 		null, 		null, 		null],
			["ur", 		"_start",	"rl", 		"udl", 		null, 		null, 		null, 		null],
			[null, 		"ud", 		null, 		"ud", 		null, 		null, 		null, 		null],
			["r", 		"ul", 		null, 		"ud", 		null, 		null, 		null, 		null],
			[null,		null,		null,		"ud",		null,		"rd",		"rl",		"l"],
			["r",		"rdl",		"rl",		"ul",		null,		"ud",		null,		null],
			[null,		"ud",		null,		null,		"rd",		"urdl",		"rl",		"dl"],
			[null,		"ur",		"rl",		"rl",		"url",		"ul",		null,		"u"]
		];

		_rooms = new Array<Array<TiledRoom>>();

		for (y in 0...8)
		{
			_rooms[y] = new Array<TiledRoom>();
			for (x in 0...8)
			{

				if (roomsTypes[y][x] == null)
					continue;

				var tempRoom:TiledRoom = new TiledRoom("assets/tiled/" + roomsTypes[y][x] + ".tmx", this, x, y);
				_rooms[y][x] = tempRoom;

				if (roomsTypes[y][x] == "_start")
				{
					tempRoom.setActive(true);
					_currentRoom = tempRoom;
					_playerPositionInTheLevel.set(x, y);
					FlxG.camera.setScrollBoundsRect(_currentRoom._offsetX, _currentRoom._offsetY, _currentRoom.fullWidth, _currentRoom.fullHeight, true);
					
					////////////
					tempRoom._foregroundSpriteTiles.forEach(function(sprite:FlxSprite)
					{
						_maxiGroup.add(sprite);
					});

					// Add objects layer
					tempRoom._objectsSpriteTiles.forEach(function(sprite:FlxSprite)
					{
						_maxiGroup.add(sprite);
					});
					////////////
				}
				else
				{
					tempRoom.setActive(false);
					add(tempRoom._foregroundTiles);
				}

				add(tempRoom._backgroundLayer);
				//add(tempRoom._foregroundTiles);
				//add(tempRoom.spriteGroup);
			}
		}
		
		//var loop:FlxAsyncLoop = new FlxAsyncLoop(
		
		_currentRoom.setActive(true);

		_maxiGroup.add(_player);

		add(_maxiGroup);

		FlxG.camera.zoom = 3;

		FlxG.camera.fade(FlxColor.BLACK, .2, true);
		
		var t:BulletsTrap = new BulletsTrap(_player.x, _player.y, this);
		add(t);
		
		///////////////////////////////////////////////////////////////////////////////////////////////
		_hud = new Hud(_player);
		add(_hud);

		// Caméra pour le HUD du téléphone
		_hudCam = new FlxCamera(0, 0, _hud._width, _hud._height);
		_hudCam.zoom = 1;
		_hudCam.bgColor = FlxColor.TRANSPARENT;
		_hudCam.follow(_hud._testSprite, NO_DEAD_ZONE);
		FlxG.cameras.add(_hudCam);
		///////////////////////////////////////////////////////////////////////////////////////////////

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_maxiGroup.sort(Utils.sortByYAscending);

		_currentRoom.collideWithLevel(_player);

		FlxG.overlap(_player, _currentRoom._exits, PlayerExit);

		if (FlxG.keys.anyPressed([Tweaking.shootUp]))
		{
			add(new Bullet(_player.getPosition().x, _player.getPosition().y, Direction.UP));
		}
		else if (FlxG.keys.anyPressed([Tweaking.shootRight]))
		{
			add(new Bullet(_player.getPosition().x, _player.getPosition().y, Direction.RIGHT));
		}
		else if (FlxG.keys.anyPressed([Tweaking.shootDown]))
		{
			add(new Bullet(_player.getPosition().x, _player.getPosition().y, Direction.DOWN));
		}
		else if (FlxG.keys.anyPressed([Tweaking.shootLeft]))
		{
			add(new Bullet(_player.getPosition().x, _player.getPosition().y, Direction.LEFT));
		}

		#if debug
		/////////////////////////////////////////////////////////////////////// SECTION DEBUG
		// Il faut obligatoirement avoir SHIFT d'enfoncer pour utiliser ces fonctions de debug
		if (FlxG.keys.pressed.SHIFT)
		{
			// Aller direct à l'exit
			if (FlxG.keys.justPressed.D)
			{
				//add(_player.shoot());
				//var newBullet : FlxSprite = _player.shoot();
				//add(newBullet);

				//new Bullet(
				//add(new Bullet(250,250));
				//switch (_currentLevel)
				//{
				//case TUTO :
				//_player.x = 256;
				//_player.y = 432;
				//case LEVEL_1 :
				//_player.x = 1232;
				//_player.y = 432;
				//case LEVEL_2 :
				//_player.x = 48;
				//_player.y = 32;
				//case LEVEL_3 :
				//_player.x = 576;
				//_player.y = 32;
				//case END :
				//_player.x = 160;
				//_player.y = 32;
				//}
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
			//switch (exit._direction)
			//{
			//case UP:
			////FlxTween.tween(FlxG.camera, {y: 1000}, 0.3, {onComplete: switchState.bind(_, exit)});
			//case RIGHT:
			////FlxTween.tween(FlxG.camera, {x: -1000}, 0.3, {onComplete: switchState.bind(_, exit)});
			//case DOWN:
			////FlxTween.tween(FlxG.camera, {y: -360}, 0.3, {onComplete: switchState.bind(_, exit)});
			//case LEFT:
			////FlxTween.tween(FlxG.camera, {x: 1000}, 0.3, {onComplete: switchState.bind(_, exit)});
			//case SPECIAL:
			////
			//case NONE:
			////
			//}
			//FlxG.camera.fade(FlxColor.BLACK, 0.3, false, function()
			//{
			//FlxG.switchState(new PlayState(exit._direction));
			//});
			//FlxTween.tween(FlxG.camera, {x:720}, 0.3, {onComplete: switchState});
			//FlxG.switchState(new PlayState(exit._direction));
			FlxG.camera.fade(FlxColor.BLACK, .2, false, function() {
				FlxG.camera.fade(FlxColor.BLACK, .1, true);
			});
			_currentRoom.setActive(false);
			_maxiGroup.clear();
			var nextRoom:TiledRoom = getNextRoom(exit._direction);
			_currentRoom = nextRoom;
			
			////////////
			_currentRoom._foregroundSpriteTiles.forEach(function(sprite:FlxSprite)
			{
				_maxiGroup.add(sprite);
			});

			// Add objects layer
			_currentRoom._objectsSpriteTiles.forEach(function(sprite:FlxSprite)
			{
				_maxiGroup.add(sprite);
			});
			////////////
			
			_maxiGroup.add(_player);
			
			_currentRoom.setActive(true);
		}
	}

	private function getNextRoom(exitDirection:Direction):TiledRoom
	{

		// TODO: Ajouter des controles
		switch (exitDirection)
		{
			case UP:
				_playerPositionInTheLevel.y--;
			case RIGHT:
				_playerPositionInTheLevel.x++;
			case DOWN:
				_playerPositionInTheLevel.y++;
			case LEFT:
				_playerPositionInTheLevel.x--;
			case SPECIAL:
			//
			case NONE:
				//
		}
		return _rooms[Std.int(_playerPositionInTheLevel.y)]	[Std.int(_playerPositionInTheLevel.x)];
	}

	private function switchState(tween:FlxTween, exit:Exit):Void
	{
		//Sys.sleep(0.5);
		//FlxG.switchState(new PlayState(exit._direction));
	}
}