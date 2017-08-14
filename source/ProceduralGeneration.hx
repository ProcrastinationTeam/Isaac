package;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import flixel.util.FlxArrayUtil;

/**
 * ...
 * @author ElRyoGrande
 */

 
 ///PENSEZ A FAIRE UNE ENUM POUR LES DIRECTIONS
class ProceduralGeneration 
{

	public function new() 
	{
		
		LevelGeneration();
		
	}
	
	public function LevelGeneration():Void
	{
		var roomCount 					: Int;
		var currentDoorCount			: Int;
		var currentRoom					: Room;
		var northDoor					: FlxVector = new FlxVector(0,-1); //y
		var eastDoor					: FlxVector = new FlxVector(1,0); 	//x
		var southDoor					: FlxVector = new FlxVector(0,1); 	//y
		var westDoor					: FlxVector = new FlxVector(-1,0); //x
		var currentRoomPostion 			: FlxVector;
		var roomList					: Array<FlxVector>;
		var realRoomList				: Array<Room>;
		var currentDoor 				: FlxVector;
		var displayRoomCount 			: FlxText;
			
		var arrayDoor 					: Array<FlxVector>;
		var fillArrayDoor 				: Array<FlxVector>;
		var potentionalPositionForRoom 	: Array<FlxVector>;
		
		
		fillArrayDoor = new Array<FlxVector>();
		potentionPositionForRoom = new Array<FlxVector>();
		
		arrayDoor = new Array<FlxVector>();
		arrayDoor.push(northDoor);
		arrayDoor.push(eastDoor);
		arrayDoor.push(southDoor);
		arrayDoor.push(westDoor);
		
		//copyArrayDoor = new Array<FlxVector>();
		
		trace("Lancement de la generation");
		
		roomCount = FlxG.random.int(1, 5);
		trace("Room Count : " + roomCount);
		//displayRoomCount = new FlxText(10, 10, 10, "Room Count : " + roomCount);
		
		
		currentRoomPostion = new FlxVector(0,0);
		
		roomList = new Array<FlxVector>();
		
		roomList.push(currentRoomPostion);
		
		//Le nombre de porte doit etre liée au nombre de salle, il ne peut pas y avoir plus de possibilité de porte qu'il y a de salle
		//Voir a quel moment calculé les portes
		
		
		//determinaison des portes presente dans la salle
		currentDoorCount = FlxG.random.int(1, 4);
		
		
		
		for (r in 0...roomCount)
		{
			trace("ROOM : " + r);
			var copyArrayDoor  = arrayDoor.copy();
			trace("Nb de Porte " + currentDoorCount);
			
			for (i in 0...currentDoorCount)
			{
				
				//trace("Porte " + i);
				//Attribution des orientation des portes
				var randomizer = FlxG.random.int(0, copyArrayDoor.length-1);
				currentDoor = copyArrayDoor[randomizer];
				
				//trace(currentDoor.toString());
				fillArrayDoor.push(currentDoor);
				potentionalPositionForRoom.push(currentRoomPostion + currentDoor);
				copyArrayDoor.remove(currentDoor);
				//trace(copyArrayDoor.length);
			}
			
			
			if (r != 0)
			{
				currentRoomPostion += potentionalPositionForRoom[0]; 
			}

				//Creation de la room (objet)
			currentRoom = new Room(r,currentDoorCount,fillArrayDoor,currentRoomPostion);
			fillArrayDoor.splice(0, currentDoorCount);
			
			
		}
	}
	
}