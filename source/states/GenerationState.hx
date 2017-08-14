package states;

import flixel.FlxState;

/**
 * ...
 * @author ElRyoGrande
 */
class GenerationState extends FlxState 
{
	public var proceduralGen : ProceduralGeneration;
	
	
	override public function create():Void
	{
		
		proceduralGen = new ProceduralGeneration(); 
		
		super.create();
	}
	
	override public function update(elapsed:Float):Void
	{
		
	}
	
}