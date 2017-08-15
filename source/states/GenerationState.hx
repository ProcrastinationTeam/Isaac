package states;

import flixel.FlxState;

/**
 * ...
 * @author ElRyoGrande
 */
class GenerationState extends FlxState 
{
	public var proceduralGen : ProceduralGeneration;
	
	//POUR LE TEST DES SPRITES
	public var _player 								: Player;
	
	override public function create():Void
	{
		
		proceduralGen = new ProceduralGeneration(); 
		add(_player);
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		
	}
	
}