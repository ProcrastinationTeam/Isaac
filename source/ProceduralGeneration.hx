package;
import flixel.FlxG;
import flixel.math.FlxPoint;
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
		var parentCurrentRoom					: Room;
		var northDoor					: FlxPoint = new FlxPoint(0,-1); //y
		var eastDoor					: FlxPoint = new FlxPoint(1,0); 	//x
		var southDoor					: FlxPoint = new FlxPoint(0,1); 	//y
		var westDoor					: FlxPoint = new FlxPoint(-1,0); //x
		var currentRoomPostion 			: FlxPoint;
		var parentCurrentRoomPostion 			: FlxPoint;
		var roomList					: Array<FlxPoint>;
		var realRoomList				: Array<Room>;
		var currentDoor 				: FlxPoint;
		var displayRoomCount 			: FlxText;
			
		var arrayDoor 					: Array<FlxPoint>;
		var fillArrayDoor 				: Array<FlxPoint>;
		var potentionalPositionForRoom 	: Array<FlxPoint>;
		
		
		fillArrayDoor = new Array<FlxPoint>();
		potentionalPositionForRoom = new Array<FlxPoint>();
		
		arrayDoor = new Array<FlxPoint>();
		arrayDoor.push(northDoor);
		arrayDoor.push(eastDoor);
		arrayDoor.push(southDoor);
		arrayDoor.push(westDoor);
		
		//copyArrayDoor = new Array<FlxPoint>();
		
		trace("Lancement de la generation");
		
		roomCount = FlxG.random.int(3, 3);
		trace("Room Count : " + roomCount);
		//displayRoomCount = new FlxText(10, 10, 10, "Room Count : " + roomCount);
		
		
		currentRoomPostion = new FlxPoint(0,0);
		parentCurrentRoomPostion = new FlxPoint(0,0);
		
		roomList = new Array<FlxPoint>();
		roomList.push(currentRoomPostion);
		
		realRoomList = new Array<Room>();
		//Le nombre de porte doit etre liée au nombre de salle, il ne peut pas y avoir plus de possibilité de porte qu'il y a de salle
		//Voir a quel moment calculé les portes
		
		
		//determinaison des portes presente dans la salle
		currentDoorCount = FlxG.random.int(1, 4);
		
		//Il faut créer la premiere room seule au départ en (0,0) // NE PEUX PAS ETRE FAIT LA FINALEMENT //FILL ARRAY DOOR EN DEFAUT ICI
		currentRoom = new Room(0,currentDoorCount,fillArrayDoor,parentCurrentRoomPostion);
		realRoomList.push(currentRoom);
		
		for (r in 0...roomCount)
		{
			parentCurrentRoom = realRoomList[realRoomList.length-1];
			trace("CURRENT ROOM TREATMENT : [" + parentCurrentRoom._position +"]");
			//trace("ROOM PARENT : " + r);
			var copyArrayDoor  = arrayDoor.copy();
			currentDoorCount = FlxG.random.int(1, 4);
			trace("Nb de Porte " + currentDoorCount);
			
			for (i in 0...currentDoorCount)
			{
				parentCurrentRoomPostion = parentCurrentRoom._position;
				trace("Parent POS : " + parentCurrentRoomPostion);
				parentCurrentRoomPostion.copyTo(currentRoomPostion);
				//trace("Porte POS : " + currentRoomPostion);
				//Attribution des orientation des portes
				var randomizer = FlxG.random.int(0, copyArrayDoor.length-1);
				currentDoor = copyArrayDoor[randomizer];
				
				//Technique de sioux pour stocker les portes existantes par salle
				fillArrayDoor.push(currentDoor);
				
				//LE CALCUL EST TRES CERTAINEMENT FAUX ! 
				potentionalPositionForRoom.push(currentRoomPostion.addPoint(currentDoor));
				trace("Porte POS ADD : " + currentRoomPostion);
				//Enleve la door de la liste du choix des door a ajouter a la salle
				copyArrayDoor.remove(currentDoor);
				
				//On pourrais créer les salles ici
				
				//currentRoomPostion = parentCurrentRoomPostion + currentDoor;
				
				//Creation de la room (objet)
				//Technique de sioux pour l'id
				currentRoom = new Room(realRoomList.length,currentDoorCount,fillArrayDoor,currentRoomPostion,parentCurrentRoom);
				realRoomList.push(currentRoom);
			}
			
			//if (r != 0)
			//{
				//currentRoomPostion += potentionalPositionForRoom[0]; 
			//}
//
				////Creation de la room (objet)
			//currentRoom = new Room(r,currentDoorCount,fillArrayDoor,currentRoomPostion);
			fillArrayDoor.splice(0, currentDoorCount);
			
			
			
		}
	}
	
}