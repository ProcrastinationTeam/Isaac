package states;

import enums.Direction;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import states.ProceduralState.Room;
import utils.Tweaking;
import utils.Utils;
import flixel.addons.util.FlxAsyncLoop;
import hud.Hud;
import flixel.FlxCamera;
import flixel.addons.display.shapes.FlxShapeGrid;
import flixel.addons.display.shapes.FlxShapeDoubleCircle;
import flixel.util.FlxSpriteUtil.LineStyle;

class Room {
	
}

class ProceduralState extends FlxState
{
	public var cellsSize 					: Int = 64;
	public var numberOfCellsX				: Int = 8;
	public var numberOfCellsY				: Int = 8;
	public var borderThickness				: Int = 2;
	
	public var roomsSize					: Int = 32;
	
	public var startPosition				: FlxPoint = new FlxPoint(0, 0);
	public var endPosition					: FlxPoint = new FlxPoint(7, 7);
	
	public var rooms						: Array<FlxPoint>;
	
	override public function create():Void
	{
		super.create();
		
		FlxG.camera.bgColor = FlxColor.GRAY;
		
		var grid:FlxShapeGrid = new FlxShapeGrid(0, 0, cellsSize, cellsSize, numberOfCellsX, numberOfCellsY, { thickness:borderThickness, color:FlxColor.BLACK }, FlxColor.BLUE);
		add(grid);
		
		var startSprite = new FlxSprite(coordToCenterInt(startPosition.x) - roomsSize/2, coordToCenterInt(startPosition.y) - roomsSize/2).makeGraphic(roomsSize, roomsSize, FlxColor.YELLOW);
		add(startSprite);
		
		var endSprite = new FlxSprite(coordToCenterInt(endPosition.x) - roomsSize/2, coordToCenterInt(endPosition.y) - roomsSize/2).makeGraphic(roomsSize, roomsSize, FlxColor.RED);
		add(endSprite);
		
		rooms = new Array<FlxPoint>();
		rooms.push(startPosition);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (FlxG.keys.anyJustPressed([N])) {
			addOneRoom();	
		}
	}
	
	public function addOneRoom():Void {
		var lastRoom:FlxPoint = rooms[rooms.length - 1];
		var nextRoom:FlxPoint = new FlxPoint(lastRoom.x, lastRoom.y);
		rooms.push(nextRoom);
		var roomSprite:FlxSprite = new FlxSprite(coordToCenterInt(nextRoom.x) - roomsSize/2, coordToCenterInt(nextRoom.y) - roomsSize/2).makeGraphic(roomsSize, roomsSize, FlxColor.YELLOW);
		add(roomSprite);
		
		var randomNumber:Int = FlxG.random.int(0, 3);
		switch (randomNumber) 
		{
			case 0: 
			case 1:
			case 2:
			case 3:
		}
	}
	
	public function coordToCenterInt(position:Float):Float {
		return (cellsSize / 2) + position * (cellsSize);
	}
	
	public function coordToCenterInts(x:Int, y:Int):FlxPoint {
		return new FlxPoint((cellsSize / 2) + x * cellsSize, (cellsSize / 2) + y * cellsSize);
	}	
	
	public function coordToCenterPoint(point:FlxPoint):FlxPoint {
		return new FlxPoint((cellsSize / 2) + point.x * cellsSize, (cellsSize / 2) + point.y * cellsSize);
	}
}