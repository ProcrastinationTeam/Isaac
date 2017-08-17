package;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;

/**
 * ...
 * @author ElRyoGrande
 */
class Room 
{
	public var _id 				: Int;
	public var _doorCount 		: Int;
	public var _arrayDoors 		: Array<FlxPoint>;
	public var _position 		: FlxPoint;
	public var _parentRoom 		: Room;
	public var _adjacentRooms 	: Array<Room>; // MAP<direction,ROOM>

	
	public function new(id,doorCount, ?parentRoom)
	{	
		_id = id;
		_doorCount = doorCount;
		_arrayDoors = new Array<FlxPoint>();
		_position = new FlxPoint();
		
		if (parentRoom == null)
		{
			_parentRoom = this;
		}
		else{
			_parentRoom = parentRoom ;
		}
		
	}
	
	public function setId(id)
	{
		_id = id;
	}
	
	public function setDoorCount(doorCount)
	{
		_doorCount = doorCount;
	}
	
	public function setPosition(position)
	{
		_position = position;
		
	}
	
	public function getPosition()
	{
		return _position;
	}
	
	public function setParentRoom(parentRoom)
	{
		_parentRoom = parentRoom;
		//_parentRoom = new Room(parentRoom._id, parentRoom._doorCount);
		//trace("PARENT POS :" + _parentRoom._position);
	}
	
	public function setDoorsPosition(arrayDoors:Array<FlxPoint>)
	{
		_arrayDoors = arrayDoors;
		
	}
	
	public function putDoorOnGoodPosition()
	{
		for (i in 0..._arrayDoors.length)
		{
			trace("VALUE ACTUAL DOOR : " + _arrayDoors[i]);
			
			_arrayDoors[i].x /= 2;
			_arrayDoors[i].y /= 2;
			_arrayDoors[i].addPoint(_position);
			
			trace("VALUE ACTUAL DOOR AFTER ADD: " + _arrayDoors[i]);
		}
	}
	
	
	public function getStateOfTheRoom()
	{
		trace("ROOM " + _id);
		trace("Position :" + _position);
		trace("Door Count : " + _doorCount);
		trace("Doors array : " + _arrayDoors);
		
		trace("Parent Room : [ROOM " + _parentRoom +"]");
		trace("------------------------------------------");
		
		
	}
	
	
}