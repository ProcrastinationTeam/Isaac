package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;

/**
 * ...
 * @author ElRyoGrande
 */
class GraphicTile extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0,init)
	{
		super(X, Y);
		//loadGraphic(Tweaking.playerSprite, true, 16, 16);
		if (init)
		{
			makeGraphic(50, 50, FlxColor.RED, false);
		}
		else
		{
			//makeGraphic(50, 50, FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255)), false);
			makeGraphic(50, 50, FlxColor.BROWN, false);
		}
		//setSize(8, 6);
		//offset.set(4, 10);
	}

}