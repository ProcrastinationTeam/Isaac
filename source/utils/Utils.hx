package utils;

import enums.Direction;
import flixel.FlxObject;

class Utils
{
	public static function stringToEnumDirection(stringDirection:String):Direction
	{
		switch (stringDirection)
		{
			case "up":
				return Direction.UP;
			case "right":
				return Direction.RIGHT;
			case "down":
				return Direction.DOWN;
			case "left":
				return Direction.LEFT;
			case "special":
				return Direction.SPECIAL;
			default:
				// TODO: mieux gérer
				return Direction.NONE;
		}
	}
	
	/**
	* Comparateur perso pour trier les sprites par Y croissant (en tenant compte de leur hauteur)
	* @param	Order
	* @param	Obj1
	* @param	Obj2
	* @return
	*/
	public static function sortByYAscending(Order:Int, Obj1:FlxObject, Obj2:FlxObject):Int
	{
		return Obj1.y + Obj1.height < Obj2.y + Obj2.height ? -1 : 1;
	}
}