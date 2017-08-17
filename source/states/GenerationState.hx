package states;

import flixel.FlxG;
import flixel.FlxSprite;
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
	public var doorsGroup 		: FlxTypedGroup<FlxSprite>;
	
	
	override public function create():Void
	{
		LoadMap();
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.pressed.SHIFT)
		{
			if (FlxG.keys.pressed.R)
			{
				remove(tileGroup);
				//tileGroup.clear();
				remove(doorsGroup);
				
				
				LoadMap();
				
				
				
			}
			
			if (FlxG.keys.pressed.E)
			{
				add(proceduralGen.roomSprite);
			}
		}
		
	}
	
	
	
	
	function LoadMap()
	{
		tileGroup = new FlxTypedGroup<GraphicTile>();
		doorsGroup = new FlxTypedGroup<FlxSprite>();
		
		
		proceduralGen = new ProceduralGeneration();
		for (graphicTile in proceduralGen.arraySprite)
		{
			tileGroup.add(graphicTile);
			for (doors in graphicTile.doorSprites)
			{
				doorsGroup.add(doors);
			}
			
		}
		
		add(tileGroup);
		add(doorsGroup);

	}

}