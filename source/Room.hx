package;
import flixel.math.FlxVector;

/**
 * ...
 * @author ElRyoGrande
 */
class Room 
{
	var _id 		:Int;
	var _doorCount : Int;
	var _arrayDoors : Array<FlxVector>;
	var _position 	:FlxVector;

	
	public function new(id,doorCount, arrayDoors, position)
	{	
		_id = id;
		_doorCount = doorCount;
		_arrayDoors = arrayDoors;
		_position = position;
		
		trace("JE SUIS LA ROOM : " + id );
		
	}
	
}