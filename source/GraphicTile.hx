package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import utils.Tweaking;

/**
 * ...
 * @author ElRyoGrande
 */
class GraphicTile extends FlxSprite
{

	//public var roomSprites	: FlxTypedGroup<FlxSprite>;
	public var doorSprites  : FlxTypedGroup<FlxSprite>;
	public var tileSprite	: FlxSprite;

	public function new(?X:Float=0, ?Y:Float=0,init)
	{
		super(X, Y);

		//roomSprites = new FlxTypedGroup<FlxSprite>();
		doorSprites = new FlxTypedGroup<FlxSprite>();

		if (init)
		{
			makeGraphic(Tweaking.roomSize, Tweaking.roomSize, FlxColor.RED, false);
		}
		else
		{
			makeGraphic(Tweaking.roomSize, Tweaking.roomSize, FlxColor.BLUE, false);
		}

	}

	//A REFAIRE DEGEU
	public function createDoor(arrayDoor : Array<FlxPoint>, roomPosition : FlxPoint)
	{
		for (i in arrayDoor)
		{

			var x =  i.x;
			var y =  i.y;

			var tempSprite = new FlxSprite(12.5+i.x-2.5,12.5+i.y-2.5);
			tempSprite.makeGraphic(5, 5, FlxColor.WHITE, false);

			doorSprites.add(tempSprite);

		}

	}

}