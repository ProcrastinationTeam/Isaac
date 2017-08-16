package old;

import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledTileSet;
import haxe.xml.Fast;
import openfl.Assets;

// TODO: FAIRE UNE PULL REQUEST ?
class TiledMapExternalTileset extends TiledMap
{
	public function new(data:FlxTiledMapAsset, rootPath:String="")
	{
		super(data, rootPath);
	}

	// TODO: Ajouter aussi les objectsgroup ?
	private override function loadTilesets(source:Fast):Void
	{
		for (node in source.nodes.tileset)
		{
			// TODO; virer la string en dur d'ici
			var tilesetSource = new Fast(Xml.parse(Assets.getText("assets/tiled/" + node.att.source)));

			node = tilesetSource.node.tileset;

			var name = node.has.name ? node.att.name : "";

			if (!noLoadHash.exists(name))
			{
				trace("bonjour lol");
				var ts = new TiledTileSet(node, rootPath);
				tilesets.set(ts.name, ts);
				tilesetArray.push(ts);
			}
		}
	}
}