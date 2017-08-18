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

class PlayState extends FlxState
{
	public var _player 								: Player;

	// Position du joueur dans la grille du niveau (coordonnées de la salle en cours quoi, (0,0) tout en haut à gauche)
	// TODO: mettre un meilleur par défaut
	public var _playerPositionInTheLevel			: FlxPoint = new FlxPoint(0, 0);

	public var _maxiGroup 							: FlxTypedGroup<FlxSprite>;

	//public var _previousExitDirection				: Direction = SPECIAL;

	public var _rooms 								: Array<Array<TiledLevel>>;
	public var _currentRoom 						: TiledLevel;

	//public function new(previousExitDirection:Direction)
	//{
	//super();
	//_previousExitDirection = previousExitDirection;
	//}

	override public function create():Void
	{
		_maxiGroup = new FlxTypedGroup<FlxSprite>();

		var roomsTypes:Array<Array<String>> = [
			["rd", 	"dl", 		null, 	"d"],
			["ur", 	"_start",	 "rl", 	"udl"],
			[null, 	"ud", 		null, 	"ud"],
			["r", 	"ul", 		null, 	"u"]
		];

		_rooms = new Array<Array<TiledLevel>>();

		for (y in 0...4)
		{
			_rooms[y] = new Array<TiledLevel>();
			for (x in 0...4)
			{

				if (roomsTypes[y][x] == null)
					continue;

				var tempRoom:TiledLevel = new TiledLevel("assets/tiled/" + roomsTypes[y][x] + ".tmx", this, x, y);
				_rooms[y][x] = tempRoom;

				if (roomsTypes[y][x] == "_start")
				{
					tempRoom.setActive(true);
					_currentRoom = tempRoom;
					_playerPositionInTheLevel.set(x, y);
					FlxG.camera.setScrollBoundsRect(_currentRoom._offsetX, _currentRoom._offsetY, _currentRoom.fullWidth, _currentRoom.fullHeight, true);
				}
				else
				{
					tempRoom.setActive(false);
				}

				add(tempRoom._backgroundLayer);

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
		}

		_currentRoom.setActive(true);

		_maxiGroup.add(_player);

		add(_maxiGroup);

		FlxG.camera.zoom = 3;

		FlxG.camera.fade(FlxColor.BLACK, .2, true);
		
		var t:BulletsTrap = new BulletsTrap(_player.x, _player.y, this);
		add(t);

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
			_currentRoom.setActive(false);
			var nextRoom:TiledLevel = getNextRoom(exit._direction);
			_currentRoom = nextRoom;
			_currentRoom.setActive(true);
		}
	}

	private function getNextRoom(exitDirection:Direction):TiledLevel
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