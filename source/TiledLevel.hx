package;

import Exit;
import Map;
import enums.Direction;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.util.FlxColor;
import haxe.EnumFlags;
import haxe.io.Path;
import haxe.xml.Fast;
import openfl.Assets;
import states.PlayState;
import structs.Hitbox;
import utils.Utils;

// TODO: Séparer la gestion de la Room / Jeu
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	// TODO: ça va sortir d'ici
	private inline static var c_PATH_LEVEL_TILESHEETS			: String = "assets/tiled/";

	// Juste le sol quoi
	public var _backgroundLayer									: FlxGroup;

	// Elements de décor, souvent avec de la collision (mais juste ça comme "interaction")
	public var _foregroundSpriteTiles							: FlxTypedGroup<FlxSprite>;

	// Objets du gameplay (sorties, joueur?, ennemis, etc)
	public var _objectsSpriteTiles								: FlxTypedGroup<FlxSprite>;

	// Liste des sorties de la salle
	public var _exits 											: FlxTypedGroup<FlxSprite>;

	// Indique (plus facilement) les sorties possibles de la salle
	public var _exitsAvailable									: EnumFlags<Direction>;
	
	// Indique si cette salle est la salle "active" (celle dans lequel le joueur se trouve)
	// TODO: Mettre en place un mécanisme pour forcer qu'il n'y en ait qu'une à la fois
	public var _isActive										: Bool = false;
	
	public var _x:Int;
	public var _y:Int;
	
	public var _offsetX:Int = 0;
	public var _offsetY:Int = 0;

	// TODO: Faudrait sortir l'init du tileset et des hitbox, même si pour le tileset c'est mort je pense (ça le fait dans le super)
	public function new(pathToTiledLevel:String, state:PlayState, x:Int, y:Int)
	{
		super(pathToTiledLevel, c_PATH_LEVEL_TILESHEETS);
		
		_x = x;
		_y = y;
		
		_offsetX = tileWidth * _x * width;
		_offsetY = tileHeight * _y * height;

		EncapsulateTilesetHitboxes.instance.init(tilesets.get("tileset"));
		//trace(EncapsulateTilesetHitboxes.instance._tileSet.numTiles);

		_backgroundLayer = new FlxGroup();
		_foregroundSpriteTiles = new FlxTypedGroup<FlxSprite>();
		_objectsSpriteTiles = new FlxTypedGroup<FlxSprite>();

		_exits = new FlxTypedGroup<FlxSprite>();

		_exitsAvailable = new EnumFlags<Direction>();

		//FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);
		// //Pour la collision avec les sorties en dehors de la zone de vision
		//FlxG.worldBounds.set(-2 * tileWidth, -2 * tileHeight, fullWidth + (4 * tileWidth), fullHeight + (4 * tileHeight));

		// Load des objets
		loadObjects(state);
		
		// Load des layers
		for (layer in layers)
		{
			//trace(layer.name + " - " + layer.type);
			if (layer.type != TiledLayerType.TILE) continue;

			var tileLayer:TiledTileLayer = cast layer;
			var tileSet:TiledTileSet = EncapsulateTilesetHitboxes.instance._tileSet;

			var imagePath:Path = new Path(tileSet.imageSource);
			var processedPath:String = c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;

			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath, tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);

			if (tileLayer.properties.get("layer") == "background")
			{
				tilemap.setPosition(tilemap.getPosition().x + _offsetX, tilemap.getPosition().y + _offsetY);
				_backgroundLayer.add(tilemap);
			}
			else if (tileLayer.properties.get("layer") == "foreground")
			{
				for (key in EncapsulateTilesetHitboxes.instance._hitboxesMap.keys())
				{
					// + 1 pour le premier tile vide du tileset qui décale ?
					var tilesCoords:Array<FlxPoint> = tilemap.getTileCoords(key + 1);
					// Si on check pas, si y'a pas d'éléments ça bug
					if (tilesCoords != null)
					{
						for (tileCoord in tilesCoords)
						{
							//TODO: génériser
							var newX:Int = Std.int((tileCoord.x - (tileWidth / 2)) / tileWidth);
							var newY:Int = Std.int((tileCoord.y - (tileHeight / 2)) / tileHeight);
							var newSprite:FlxSprite = tilemap.tileToSprite(newX, newY, function(tileProperties:FlxTileProperties):FlxSprite
							{
								//TODO: génériser
								var spriteGroup:FlxSpriteGroup = new FlxSpriteGroup(tileCoord.x - (tileWidth / 2) + _offsetX, tileCoord.y - (tileHeight / 2) + _offsetY);
								var sprite:FlxSprite = new FlxSprite();
								sprite.frame = tileProperties.graphic.frame;
								sprite.immovable = true;
								sprite.allowCollisions = FlxObject.NONE;
								sprite.setSize(tileWidth, tileHeight);
								spriteGroup.add(sprite);
								var hitboxescestchouette:Array<Hitbox> = EncapsulateTilesetHitboxes.instance._hitboxesMap.get(key);
								for (hitbox in hitboxescestchouette)
								{
									var spriteHitbox:FlxSprite = new FlxSprite(hitbox.x, hitbox.y);
									spriteHitbox.setSize(hitbox.width, hitbox.height);
									spriteHitbox.allowCollisions = FlxObject.ANY;
									spriteHitbox.immovable = true;
									// Changer la couleur pour afficher les hitbox
									// TODO: passer en option / debug ?
									spriteHitbox.makeGraphic(hitbox.width, hitbox.height, FlxColor.TRANSPARENT);
									spriteGroup.add(spriteHitbox);
								}
								return spriteGroup;
							});
							_foregroundSpriteTiles.add(newSprite);
						}
					}
				}

				for (y in 0...height)
				{
					for (x in 0...width)
					{
						if (tilemap.getTile(x, y) != 0)
						{
							// pas encore sprité
							var newSprite:FlxSprite = tilemap.tileToSprite(x, y, function(tileProperties:FlxTileProperties):FlxSprite
							{
								//TODO: génériser
								var sprite:FlxSprite = new FlxSprite((x * tileWidth) + _offsetX, (y * tileHeight) + _offsetY);
								sprite.frame = tileProperties.graphic.frame;
								sprite.immovable = true;
								sprite.allowCollisions = FlxObject.NONE;
								sprite.setSize(tileWidth, tileHeight);
								return sprite;
							});
							_foregroundSpriteTiles.add(newSprite);
						}
					}
				}
			}
			else
			{
				trace("layer chelou : " + tileLayer.name);
			}
		}
	}

	public function loadObjects(state:PlayState)
	{
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT)
			{
				continue;
			}

			// TODO: cast ?
			var objectLayer:TiledObjectLayer = cast layer;

			if (layer.name.toLowerCase() == "objects")
			{
				for (object in objectLayer.objects)
				{
					loadObject(state, object, objectLayer, _objectsSpriteTiles);
				}
			}
		}
	}

	private function loadObject(state:PlayState, object:TiledObject, g:TiledObjectLayer, group:FlxTypedGroup<FlxSprite>)
	{
		var x:Int = object.x + _offsetX;
		var y:Int = object.y + _offsetY;

		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (object.gid != -1)
		{
			y -= g.map.getGidOwner(object.gid).tileHeight;
		}

		switch (object.type.toLowerCase())
		{
			case "player_start":
				var player:Player = new Player(x, y);
				FlxG.camera.follow(player);
				state._player = player;
				group.add(player);

			case "exit":
				var direction:Direction = utils.Utils.stringToEnumDirection(object.properties.get("direction"));
				var exit:Exit = new Exit(x, y, object.width, object.height, direction);
				_exitsAvailable.set(direction);
				_exits.add(exit);
				group.add(exit);

			default:
				trace("objet inconnu : " + object.gid);
		}
	}

	// TODO: juste pour les collisions avec le décor (pour le moment)
	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Void
	{
		//TODO: http://forum.haxeflixel.com/topic/512/strange-collision-issue/5
		// Pour réparer le problème de blocage dans les murs quand on monte ?
		FlxG.collide(_foregroundSpriteTiles, obj);
	}

	public function setActive(isActive:Bool):Void
	{
		_isActive = isActive;
		if (isActive) {
			// On active la salle (on rentre dedans quoi)
			// Il faut activer tous les sprites et recentrer la caméra
			for (sprite in _objectsSpriteTiles) {
				// TODO: y'a de la redondance !
				// TODO: ca risque pas de ressuciter des trucs ?
				sprite.exists = true;
				sprite.active = true;
				sprite.alive = true;
			}
			
			// TODO: va falloir commenter je crois pour le dézoom et tout
			//FlxG.camera.setScrollBoundsRect(_offsetX, _offsetY, fullWidth, fullHeight, true);
			// Pour la collision avec les sorties en dehors de la zone de vision
			FlxG.worldBounds.set( (-2 * tileWidth) + _offsetX, (-2 * tileHeight) + _offsetY, fullWidth + (4 * tileWidth), fullHeight + (4 * tileHeight));
		} else {
			// On désactive la salle (on en sort), donc ses sprites 
			for (sprite in _objectsSpriteTiles) {
				// TODO: y'a de la redondance !
				sprite.exists = false;
				sprite.active = false;
				sprite.alive = false;
			}
		}
	}
}