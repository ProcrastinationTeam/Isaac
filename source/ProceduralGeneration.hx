package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxVector;
import flixel.text.FlxText;
import flixel.util.FlxArrayUtil;
import flixel.util.FlxColor;
import utils.Tweaking;

/**
 * ...
 * @author ElRyoGrande
 */

///PENSEZ A FAIRE UNE ENUM POUR LES DIRECTIONS
class ProceduralGeneration
{

	public var testSprite : GraphicTile;
	public var arraySprite : Array<GraphicTile>;
	public var roomSprite : FlxTypedGroup<FlxSprite>;
	
	public var potentionalPositionForRoom 	: Array<FlxPoint>;
	
	
	
	public function new()
	{
		arraySprite = new Array<GraphicTile>();
		roomSprite = new FlxTypedGroup<FlxSprite>();
		
		//var spritou = new FlxSprite(100, 100);
		//spritou.makeGraphic(10, 10, FlxColor.CYAN, false);
		//
		//var sprito = new FlxSprite(150, 150);
		//sprito.makeGraphic(10, 10, FlxColor.CYAN, false);
		//
		
		
		//roomSprite.add(spritou);
		//roomSprite.add(sprito);

		
		potentionalPositionForRoom = new Array<FlxPoint>();
		
		//arraySprite.push(new GraphicTile(0, 0));
		//LevelGeneration();
		Lvl2();
		//testSprite = new GraphicTile(100, 100);

	}
/*
	public function LevelGeneration():Void
	{
		//début de refacto
		var initialRoom					:Room;
		
		
		
		
		
		
		///////////////////////////////////////////
		var roomCount 					: Int;
		var currentDoorCount			: Int;
		var currentRoom					: Room;
		var parentCurrentRoom			: Room;
		
		
		
		
		
		
		//le déplacement doit etre de la taille d'une case
		var northDoor					: FlxPoint = new FlxPoint(0,-Tweaking.roomSize);   //y
		var eastDoor					: FlxPoint = new FlxPoint(Tweaking.roomSize,0); 	//x
		var southDoor					: FlxPoint = new FlxPoint(0,Tweaking.roomSize); 	//y
		var westDoor					: FlxPoint = new FlxPoint(-Tweaking.roomSize,0);   //x
		var currentRoomPostion 			: FlxPoint;
		var parentCurrentRoomPostion 	: FlxPoint;
		var roomList					: Array<FlxPoint>;
		var realRoomList				: Array<Room>;
		var currentDoor 				: FlxPoint;
		var displayRoomCount 			: FlxText;

		var arrayDoor 					: Array<FlxPoint>;
		var fillArrayDoor 				: Array<FlxPoint>;
		//var potentionalPositionForRoom 	: Array<FlxPoint>;

		fillArrayDoor = new Array<FlxPoint>();
		//potentionalPositionForRoom = new Array<FlxPoint>();

		//ARRAY CONSTANT UTILISE POUR LA DESIGNATION DES PORTES
		arrayDoor = new Array<FlxPoint>();
		arrayDoor.push(northDoor);
		arrayDoor.push(eastDoor);
		arrayDoor.push(southDoor);
		arrayDoor.push(westDoor);

		

		trace("Lancement de la generation");

		roomCount = FlxG.random.int(1, 20);
		trace("Room Count : " + roomCount);

		//Init un peu pourri
		currentRoomPostion = new FlxPoint(250,250);
		parentCurrentRoomPostion = new FlxPoint(250,250);

		roomList = new Array<FlxPoint>();
		roomList.push(currentRoomPostion);

		realRoomList = new Array<Room>();
		//Le nombre de porte doit etre liée au nombre de salle, il ne peut pas y avoir plus de possibilité de porte qu'il y a de salle
		//Voir a quel moment calculé les portes

		//determinaison des portes presente dans la salle
		currentDoorCount = FlxG.random.int(1, 4);

		//Il faut créer la premiere room seule au départ en (0,0) // NE PEUX PAS ETRE FAIT LA FINALEMENT //FILL ARRAY DOOR EN DEFAUT ICI
		initialRoom = new Room(0, currentDoorCount, parentCurrentRoomPostion);
		
		//var tempTile = new GraphicTile(parentCurrentRoomPostion.x, parentCurrentRoomPostion.y, true);
		//tempTile.createDoor(fillArrayDoor, parentCurrentRoomPostion);
		//arraySprite.push(tempTile);
		//realRoomList.push(currentRoom);
		//potentionalPositionForRoom.push(currentRoom._position);

		for (r in 0...roomCount)
		{
			if (r != 0)
			{
				parentCurrentRoom = realRoomList[realRoomList.length-1];
			}
			else
			{
				parentCurrentRoom = initialRoom;
			}
			
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
				currentRoomPostion.addPoint(currentDoor);
				var tempRoomPos = new FlxPoint(0, 0);
				currentRoomPostion.copyTo(tempRoomPos);

				if (!hasAlreadySpawn(currentRoomPostion))
				{
					potentionalPositionForRoom.push(tempRoomPos);
					trace("Porte POS ADD : " + tempRoomPos);

					//Enleve la door de la liste du choix des door a ajouter a la salle
					copyArrayDoor.remove(currentDoor);


					//Creation de la room Graphiquement 

					var tempTile = new GraphicTile(currentRoomPostion.x, currentRoomPostion.y, false);
					//tempTile.createDoor(fillArrayDoor, parentCurrentRoomPostion);
					arraySprite.push(tempTile);
					
					//Technique de sioux pour l'id
					//Creation de la room Logiquement 
					currentRoom = new Room(realRoomList.length,currentDoorCount,currentRoomPostion,parentCurrentRoom);
					realRoomList.push(currentRoom);

				}
				else
				{
					trace("Salle deja existante");
				}

			}
			fillArrayDoor.splice(0, currentDoorCount);
		}
		//COULEUR DE LA CASE FINALE
		arraySprite[arraySprite.length - 1].color = FlxColor.GREEN;
		
	}
	*/
	
	
	
	
	////////////////////////
	// TODO : POUR PLUS DE CONTROLE LIMITE LE NOMBRE DE PORTE MAX DE LA ZONE EN FONCTION DU NOMBRE DE SALLE
	//
	
	
	
	public function Lvl2()
	{
		trace("GENERATION");
		var nextRoomsToAdd				: Array<Room>;
		
		var map							: Map<Int,Room>;
		
		var arrayPossibleDoors 			: Array<FlxPoint>;
		
		var northDoor					: FlxPoint = new FlxPoint(0,-Tweaking.roomSize);   //y
		var eastDoor					: FlxPoint = new FlxPoint(Tweaking.roomSize,0); 	//x
		var southDoor					: FlxPoint = new FlxPoint(0,Tweaking.roomSize); 	//y
		var westDoor					: FlxPoint = new FlxPoint(-Tweaking.roomSize,0);   //x
		
		//ARRAY CONSTANT UTILISE POUR LA DESIGNATION DES PORTES
		arrayPossibleDoors = new Array<FlxPoint>();
		arrayPossibleDoors.push(northDoor);
		arrayPossibleDoors.push(eastDoor);
		arrayPossibleDoors.push(southDoor);
		arrayPossibleDoors.push(westDoor);
		
		//Initialisation de la map
		map = new Map<Int,Room>();
		nextRoomsToAdd = new Array<Room>();
		
		var roomCount = FlxG.random.int(1, 8);
		
		
		//Room COUNT TO ADD
		for (id in 0...roomCount)
		{
			var randomDoorCount = FlxG.random.int(1, 4);
			//trace("ACTUAL OK : " + randomDoorCount);
			var currentRoomPosition = new FlxPoint(200, 200);
			
			if (id != 0)
			{
				//Chargement de la position de la salle actuelle
				currentRoomPosition = nextRoomsToAdd[id-1]._position;
			}
			
			//Creation de la room de maniere tres simple
			var currentRoom = new Room(id, randomDoorCount);
			
			//currentRoom.setPosition(currentRoomPosition);
			currentRoom._position = currentRoomPosition;
			
			//Tableau de stockage des portes
			var roomDoors = new Array<FlxPoint>();
			var copyArrayPossibleDoors :Array<FlxPoint> = copyTable(arrayPossibleDoors);
			
			
			//Determine la position des portes
			for (i in 0...randomDoorCount)
			{
				//Attribution des orientation des portes
				var randomizer =  FlxG.random.int(0, copyArrayPossibleDoors.length - 1);
				var doorOffset :FlxPoint = copyArrayPossibleDoors[randomizer];
			
				trace("ACTUAL DOORS : " + doorOffset);
				
				roomDoors.push(doorOffset);
				copyArrayPossibleDoors.remove(doorOffset);
				
				//Il faut créer les possibleRoom avec leur parent attitré
				var nextRoom = new Room(0,0);
				nextRoom.setParentRoom(currentRoom);
				
				//Calcul peut etre foireux
				var calculatedNextRoomPos = new FlxPoint(currentRoomPosition.x + doorOffset.x  ,  currentRoomPosition.y + doorOffset.y);
				nextRoom._position =  calculatedNextRoomPos;
				
				nextRoomsToAdd.push(nextRoom);
			}
			
			currentRoom.setDoorsPosition(roomDoors.copy());
			currentRoom.putDoorOnGoodPosition();
			
			currentRoom.getStateOfTheRoom();
			
			//Ajout de la room à la map
			map.arrayWrite(currentRoom._id, currentRoom);
			
		
	
			
			
			//Rendu graphique
	
			var graphic = new GraphicTile(0, 0, false);
			
			graphic.setPosition(currentRoom._position.x, currentRoom._position.y);
			
			//Juste envoyé la room
			graphic.createDoor(currentRoom._arrayDoors,currentRoom._position);
			
			
			arraySprite.push(graphic);
			
			
			
		}
		trace("FIN DE GENERATION");
		trace(" --------------------- /////////////////////////////////// -----------------------------------");
	}
	

	public function hasAlreadySpawn(yoloBis):Bool
	{
		
		
		for (i in 0...potentionalPositionForRoom.length-1)
		{
			if (potentionalPositionForRoom[i].x == yoloBis.x && potentionalPositionForRoom[i].y == yoloBis.y)
			{
				return true;
			}
		}
		return false;
		//return new Array<FlxPoint>();
	}
	
	public function copyTable(arrayToCopy:Array<FlxPoint>):Array<FlxPoint>
	{
		var newArray : Array<FlxPoint> = new Array<FlxPoint>();
		
		
		for (i in arrayToCopy)
		{
			newArray.push(new FlxPoint(i.x, i.y));
		}
		
		return newArray;
	}
}