package;

import flash.display.Sprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.addons.editors.tiled.TiledImageTile;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledTilePropertySet;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.addons.tile.FlxTilemapExt;
import flixel.addons.tile.FlxTileSpecial;
import haxe.io.Path;
import states.PlayState;
import flixel.util.FlxColor;
import haxe.xml.Fast;
import openfl.Assets;
import Map;

typedef Hitbox = { x : Int, y : Int, width : Int, height : Int}

/**
 * @author Samuel Batista
 */
class TiledLevel extends TiledMap
{
	// For each "Tile Layer" in the map, you must define a "tileset" property which contains the name of a tile sheet image 
	// used to draw tiles in that layer (without file extension). The image file must be located in the directory specified bellow.
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/tiled/";
	
	// Array of tilemaps used for collision
	//public var foregroundTiles:FlxGroup;
	public var foregroundSpriteTiles:FlxTypedGroup<FlxSprite>;
	public var collidableSpriteTiles:FlxGroup;
	public var objectsSpriteLayer:FlxTypedGroup<FlxSprite>;
	public var backgroundLayer:FlxGroup;
	private var collidableTileLayers:Array<FlxTilemap>;
	
	// Sprites of images layers
	public var imagesLayer:FlxGroup;
	
	public var hitboxesMap:Map<Int, Array<Hitbox>>;
	
	public function new(tiledLevel:Dynamic, state:PlayState)
	{
		super(tiledLevel);
		
		//imagesLayer = new FlxGroup();
		//foregroundTiles = new FlxGroup();
		foregroundSpriteTiles = new FlxTypedGroup<FlxSprite>();
		collidableSpriteTiles = new FlxGroup();
		objectsSpriteLayer = new FlxTypedGroup<FlxSprite>();
		backgroundLayer = new FlxGroup();
		
		FlxG.camera.setScrollBoundsRect(0, 0, fullWidth, fullHeight, true);
		
		// Extraction des collisions du foreground
		hitboxesMap = new Map<Int, Array<Hitbox>>();
		
		var source:Fast = new Fast(Xml.parse(Assets.getText(tiledLevel)));
		var nodes = source.node.map.node.tileset.nodes.tile;
		for (tileNode in nodes) {
			//trace(node.att.id);
			var id:Int = Std.parseInt(tileNode.att.id);
			//trace(tileNode.node.objectgroup.nodes.object);
			var hitboxes = tileNode.node.objectgroup.nodes.object;
			for (hitbox in hitboxes) {
				var x = Std.parseInt(hitbox.att.x);
				var y = Std.parseInt(hitbox.att.y);
				var width = Std.parseInt(hitbox.att.width);
				var height = Std.parseInt(hitbox.att.height);
				//trace("id : " + id + " - x : " + x + " - y : " + y + " - width : " + width + " - height : " + height);
				if (hitboxesMap.get(id) == null) {
					hitboxesMap.set(id, new Array<Hitbox>());
				}
				hitboxesMap.get(id).push({x : x, y : y, width : width, height : height});
			}
		}
		
		//loadImages();
		loadObjects(state);
		
		// Load Tile Maps
		for (layer in layers)
		{
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
				
			var imagePath 		= new Path(tileSet.imageSource);
			var processedPath 	= c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			
			// could be a regular FlxTilemap if there are no animated tiles
			//var tilemap = new FlxTilemapExt();
			var tilemap = new FlxTilemap();
			tilemap.loadMapFromArray(tileLayer.tileArray, width, height, processedPath,
				tileSet.tileWidth, tileSet.tileHeight, OFF, tileSet.firstGID, 1, 1);
			
			//if (tileLayer.properties.contains("animated"))
			//{
				//var tileset = tilesets["level"];
				//var specialTiles:Map<Int, TiledTilePropertySet> = new Map();
				//for (tileProp in tileset.tileProps)
				//{
					//if (tileProp != null && tileProp.animationFrames.length > 0)
					//{
						//specialTiles[tileProp.tileID + tileset.firstGID] = tileProp;
					//}
				//}
				//var tileLayer:TiledTileLayer = cast layer;
				//tilemap.setSpecialTiles([
					//for (tile in tileLayer.tiles)
						//if (tile != null && specialTiles.exists(tile.tileID))
							//getAnimatedTile(specialTiles[tile.tileID], tileset)
						//else null
				//]);
			//}
			
			if (tileLayer.properties.contains("nocollide"))
			{
				backgroundLayer.add(tilemap);
			}
			else
			{
				// TODO: mieux gérer, je me demande si on réajoute pas pour rien
				//foregroundTiles.add(tilemap);
				//collidableTileLayers.push(tilemap);
				
				//if (collidableTileLayers == null) {
					//collidableTileLayers = new Array<FlxTilemap>();
				//}
				
				for (key in hitboxesMap.keys()) {
					//trace(key);
					var tilesCoords = tilemap.getTileCoords(key + 1); // + 1 pour le premier tile vide qui décale ?
					// Si on check pas, si y'a pas d'éléments ça bug
					if (tilesCoords != null) {
						for (tileCoord in tilesCoords) {
							//trace(tileCoord);
							//TODO: génériser
							var newX:Int = Std.int((tileCoord.x - 8) / 16);
							var newY:Int = Std.int((tileCoord.y - 8) / 16);
							//trace(new FlxPoint(newX, newY));
							var newSprite = tilemap.tileToSprite(newX, newY, function(tileProperties:FlxTileProperties):FlxSprite {
								//TODO: génériser
								var spriteGroup = new FlxSpriteGroup(tileCoord.x - 8, tileCoord.y - 8);
								var sprite = new FlxSprite();
								sprite.frame = tileProperties.graphic.frame;
								sprite.immovable = true;
								sprite.allowCollisions = FlxObject.NONE;
								sprite.setSize(16, 16);
								spriteGroup.add(sprite);
								var hitboxescestchouette = hitboxesMap.get(key);
								for (hitbox in hitboxescestchouette) {
									var spriteHitbox = new FlxSprite(hitbox.x, hitbox.y);
									spriteHitbox.setSize(hitbox.width, hitbox.height);
									spriteHitbox.allowCollisions = FlxObject.ANY;
									spriteHitbox.immovable = true;
									spriteHitbox.makeGraphic(hitbox.width, hitbox.height, FlxColor.TRANSPARENT);
									//spriteHitbox.visible = false;
									spriteGroup.add(spriteHitbox);
								}
								return spriteGroup;
							});
							foregroundSpriteTiles.add(newSprite);
							collidableSpriteTiles.add(newSprite);
						}
					}
				}
				
				for (y in 0...15) {
					for (x in 0...15) {
						if (tilemap.getTile(x, y) != 0) {
							// pas encore sprité
							var newSprite = tilemap.tileToSprite(x, y, function(tileProperties:FlxTileProperties):FlxSprite {
								//TODO: génériser
								var sprite = new FlxSprite(x * 16, y * 16);
								sprite.frame = tileProperties.graphic.frame;
								sprite.immovable = true;
								sprite.allowCollisions = FlxObject.NONE;
								sprite.setSize(16, 16);
								return sprite;
							});
							foregroundSpriteTiles.add(newSprite);
							collidableSpriteTiles.add(newSprite);
						}
					}
				}
			}
		}
	}
	
		//public function getTileMaBite(Index:Int):FlxTile
	//{
		//return _tileObjects[_data[Index]];
	//}
	//
	public function fixCollides():Void {
		//setSize(8, 6);
		//offset.set(4, 10);
	}

	//private function getAnimatedTile(props:TiledTilePropertySet, tileset:TiledTileSet):FlxTileSpecial
	//{
		//var special = new FlxTileSpecial(1, false, false, 0);
		//var n:Int = props.animationFrames.length;
		//var offset = Std.random(n);
		//special.addAnimation(
			//[for (i in 0...n) props.animationFrames[(i + offset) % n].tileID + tileset.firstGID],
			//(1000 / props.animationFrames[0].duration)
		//);
		//return special;
	//}
	
	public function loadObjects(state:PlayState)
	{
		for (layer in layers)
		{
			if (layer.type != TiledLayerType.OBJECT)
				continue;
			var objectLayer:TiledObjectLayer = cast layer;

			//collection of images layer
			//if (layer.name == "images")
			//{
				//for (o in objectLayer.objects)
				//{
					//loadImageObject(o);
				//}
			//}
			
			//objects layer
			if (layer.name.toLowerCase() == "objects")
			{
				for (o in objectLayer.objects)
				{
					loadObject(state, o, objectLayer, objectsSpriteLayer);
				}
			}
		}
	}
	
	//private function loadImageObject(object:TiledObject)
	//{
		//var tilesImageCollection:TiledTileSet = this.getTileSet("imageCollection");
		//var tileImagesSource:TiledImageTile = tilesImageCollection.getImageSourceByGid(object.gid);
		//
		////decorative sprites
		//var levelsDir:String = "assets/tiled/";
		//
		//var decoSprite:FlxSprite = new FlxSprite(0, 0, levelsDir + tileImagesSource.source);
		//if (decoSprite.width != object.width ||
			//decoSprite.height != object.height)
		//{
			//decoSprite.antialiasing = true;
			//decoSprite.setGraphicSize(object.width, object.height);
		//}
		//if (object.flippedHorizontally)
		//{
			//decoSprite.flipX = true;
		//}
		//if (object.flippedVertically)
		//{
			//decoSprite.flipY = true;
		//}
		//decoSprite.setPosition(object.x, object.y - decoSprite.height);
		//decoSprite.origin.set(0, decoSprite.height);
		//if (object.angle != 0)
		//{
			//decoSprite.angle = object.angle;
			//decoSprite.antialiasing = true;
		//}
		//
		////Custom Properties
		//if (object.properties.contains("depth"))
		//{
			//var depth = Std.parseFloat( object.properties.get("depth"));
			//decoSprite.scrollFactor.set(depth,depth);
		//}
//
		//backgroundLayer.add(decoSprite);
	//}
	
	private function loadObject(state:PlayState, o:TiledObject, g:TiledObjectLayer, group:FlxTypedGroup<FlxSprite>)
	{
		var x:Int = o.x;
		var y:Int = o.y;
		
		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;
		
		switch (o.type.toLowerCase())
		{
			case "player_start":
				var player = new Player();
				player.setPosition(x, y);
				
				FlxG.camera.follow(player);
				
				state._player = player;
				group.add(player);
				
			case "floor":
				//var floor = new FlxObject(x, y, o.width, o.height);
				//state.floor = floor;
				
			case "coin":
				//var tileset = g.map.getGidOwner(o.gid);
				//var coin = new FlxSprite(x, y, c_PATH_LEVEL_TILESHEETS + tileset.imageSource);
				//state.coins.add(coin);
				
			case "exit":
				// Create the level exit
				var exit = new FlxSprite(x, y);
				exit.makeGraphic(32, 32, 0xff3f3f3f);
				exit.exists = false;
				state._exits.add(exit);
				group.add(exit);
		}
	}

	//public function loadImages()
	//{
		//for (layer in layers)
		//{
			//if (layer.type != TiledLayerType.IMAGE)
				//continue;
//
			//var image:TiledImageLayer = cast layer;
			//var sprite = new FlxSprite(image.x, image.y, c_PATH_LEVEL_TILESHEETS + image.imagePath);
			//imagesLayer.add(sprite);
		//}
	//}
	
	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		for (sprite in collidableSpriteTiles)
		{
			//TODO: http://forum.haxeflixel.com/topic/512/strange-collision-issue/5
			// Pour réparer le problème de blocage dans les murs quand on monte ?
			FlxG.collide(sprite, obj);
		}
		
		//if (collidableTileLayers == null)
			//return false;

		//for (sprite in collidableTileLayers)
		//{
			//// IMPORTANT: Always collide the map with objects, not the other way around.
			////            This prevents odd collision errors (collision separation code off by 1 px).
			//if (FlxG.overlap(sprite, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate))
			//{
				//return true;
			//}
		//}
		return false;
	}
}