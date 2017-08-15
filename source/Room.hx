package;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;

/**
 * ...
 * @author ElRyoGrande
 */
class Room 
{
	public var _id 		:Int;
	var _doorCount : Int;
	var _arrayDoors : Array<FlxPoint>;
	public var _position 	:FlxPoint;
	var _parentRoom :Room;

	
	public function new(id,doorCount, arrayDoors, position, ?parentRoom)
	{	
		_id = id;
		_doorCount = doorCount;
		_arrayDoors = arrayDoors;
		_position = position;
		if (parentRoom == null)
		{
			_parentRoom = this;
		}
		else{
			_parentRoom = parentRoom ;
		}
		
		
		trace("JE SUIS LA [ROOM " + id + "] ET MON PARENT EST LA [ROOM " + _parentRoom._id + "]" );
		
	}
	
}