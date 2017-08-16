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
import haxe.io.Path;
import haxe.xml.Fast;
import openfl.Assets;
import states.PlayState;
import structs.Hitbox;

// TODO: Séparer la gestion de la Room / Jeu
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	// TODO: ça va sortir d'ici
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/tiled/";

	public var backgroundLayer:FlxGroup;
	public var foregroundSpriteTiles:FlxTypedGroup<FlxSprite>;
	public var objectsSpriteTiles:FlxTypedGroup<FlxSprite>;

	public var hitboxesMap:Map<Int, Array<Hitbox>>;

	// TODO: Faudrait sortir l'init du tileset et des hitbox, même si pour le tileset c'est mort je pense (ça le fait dans le super)
	public function new(tiledLevel:Dynamic, state:PlayState)
	{
		super(tiledLevel, c_PATH_LEVEL_TILESHEETS);
		EncapsulateTilesetHitboxes.instance.init(tilesets.get("tileset"));
		trace(EncapsulateTilesetHitboxes.instance._tileSet.numTiles);
		
		backgroundLayer = new FlxGroup();
		foregroundSpriteTiles = new FlxTypedGroup<FlxSprite>();
		objectsSpriteTiles = new FlxTypedGroup<FlxSprite>();

		hitboxesMap = new Map<Int, Array<Hitbox>>();

		FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);
		// Pour la collision avec les sorties en dehors de la zone de vision
		FlxG.worldBounds.set(-2 * tileWidth, -2 * tileHeight, fullWidth + (4 * tileWidth), fullHeight + (4 * tileHeight));

		// Extraction des collisions du foreground
		extractHitboxes(tiledLevel);

		// Load des objets
		loadObjects(state);

		// Load des layers
		for (layer in layers)
		{
			trace(layer.name + " - " + layer.type);
			if (layer.type != TiledLayerType.TILE) continue;
			var tileLayer:TiledTileLayer = cast layer;

			var tileSheetName:String = tileLayer.properties.get("tileset");

			if (tileSheetName == null)
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";

			var tileSet:TiledTileSet = null;
			for (ts in tilesets)
			{
				if (ts.name == tileSheetName)
				{
					tileSet = ts;
					break;
				}
			}

			if (tileSet == null)
				throw "Tileset '" + tileSheetName + " not found. Did you misspell the 'tilesheet' property in " + tileLayer.name + "' layer?";

			var imagePath:Path 		= new Path(tileSet.imageSource);
			var processedPath:String 	= c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;

			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath, tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);

			if (tileLayer.properties.get("layer") == "background")
			{
				backgroundLayer.add(tilemap);
			}
			else if(tileLayer.properties.get("layer") == "foreground")
			{
				for (key in hitboxesMap.keys())
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
								var spriteGroup:FlxSpriteGroup = new FlxSpriteGroup(tileCoord.x - (tileWidth / 2), tileCoord.y - (tileHeight / 2));
								var sprite:FlxSprite = new FlxSprite();
								sprite.frame = tileProperties.graphic.frame;
								sprite.immovable = true;
								sprite.allowCollisions = FlxObject.NONE;
								sprite.setSize(tileWidth, tileHeight);
								spriteGroup.add(sprite);
								var hitboxescestchouette:Array<Hitbox> = hitboxesMap.get(key);
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
							foregroundSpriteTiles.add(newSprite);
						}
					}
				}

				for (y in 0...15)
				{
					for (x in 0...15)
					{
						if (tilemap.getTile(x, y) != 0)
						{
							// pas encore sprité
							var newSprite:FlxSprite = tilemap.tileToSprite(x, y, function(tileProperties:FlxTileProperties):FlxSprite
							{
								//TODO: génériser
								var sprite:FlxSprite = new FlxSprite(x * 16, y * 16);
								sprite.frame = tileProperties.graphic.frame;
								sprite.immovable = true;
								sprite.allowCollisions = FlxObject.NONE;
								sprite.setSize(16, 16);
								return sprite;
							});
							foregroundSpriteTiles.add(newSprite);
						}
					}
				}
			} else {
				trace("layer chelou : " + tileLayer.name);
			}
		}
	}

	// TODO: pull requester
	function extractHitboxes(tiledLevel:Dynamic):Void
	{
		var source:Fast = new Fast(Xml.parse(Assets.getText(tiledLevel)));
		var tilesetSource:Fast = new Fast(Xml.parse(Assets.getText(c_PATH_LEVEL_TILESHEETS + source.node.map.node.tileset.att.source)));
		var nodes:List<Fast> = tilesetSource.node.tileset.nodes.tile;
		for (tileNode in nodes)
		{
			var id:Int = Std.parseInt(tileNode.att.id);
			var hitboxes:List<Fast> = tileNode.node.objectgroup.nodes.object;
			for (hitbox in hitboxes)
			{
				var x:Int = Std.parseInt(hitbox.att.x);
				var y:Int = Std.parseInt(hitbox.att.y);
				var width:Int = Std.parseInt(hitbox.att.width);
				var height:Int = Std.parseInt(hitbox.att.height);
				if (hitboxesMap.get(id) == null)
				{
					hitboxesMap.set(id, new Array<Hitbox>());
				}
				hitboxesMap.get(id).push({x : x, y : y, width : width, height : height});
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
					loadObject(state, object, objectLayer, objectsSpriteTiles);
				}
			}
		}
	}

	private function loadObject(state:PlayState, object:TiledObject, g:TiledObjectLayer, group:FlxTypedGroup<FlxSprite>)
	{
		var x:Int = object.x;
		var y:Int = object.y;

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
				var exit:Exit = new Exit(x, y, object.width, object.height, object.properties.get("direction"));
				state._exits.add(exit);
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
		FlxG.collide(foregroundSpriteTiles, obj);
	}
}