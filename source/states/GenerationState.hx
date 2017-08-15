package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.input.FlxInput;

/**
 * ...
 * @author ElRyoGrande
 */
class GenerationState extends FlxState
{
	public var proceduralGen : ProceduralGeneration;

	//POUR LE TEST DES SPRITES
	public var _player 								: Player;
	public var tileGroup 		: FlxTypedGroup<GraphicTile>;

	override public function create():Void
	{
		tileGroup = new FlxTypedGroup<GraphicTile>();

		proceduralGen = new ProceduralGeneration();
		for (i in 0...proceduralGen.arraySprite.length)
		{
			tileGroup.add(proceduralGen.arraySprite[i]);
		}
		add(tileGroup);
		//add(proceduralGen.testSprite);
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.pressed.SHIFT)
		{
			if (FlxG.keys.pressed.R)
			{
				remove(tileGroup);
				tileGroup.clear();
				
				proceduralGen = new ProceduralGeneration();
				for (i in 0...proceduralGen.arraySprite.length)
				{
					tileGroup.add(proceduralGen.arraySprite[i]);
				}
				add(tileGroup);
				
				
			}
		}
		
	}

}