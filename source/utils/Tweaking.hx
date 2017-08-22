package utils;
import flixel.input.keyboard.FlxKey;

class Tweaking
{
	// De la forme
	// public static inline var varName 								: varType = varValue;
	
	/////////////////////////////////////////////////////////////////////////////////////////////// Player
	public static inline var playerWalkingSpeed							: Float = 150;
	public static inline var playerSprite								: String = "assets/images/MisterBelly.png";
	
	/////////////////////////////////////////////////////////////////////////////////////////////// Bullets
	public static inline var bulletSpeed								: Int = 200;
	public static inline var bulletLifeSpan								: Float = 5;

	/////////////////////////////////////////////////////////////////////////////////////////////// Traps
	public static inline var trapBulletCooldown							: Float = 1;
	
	/////////////////////////////////////////////////////////////////////////////////////////////// TWEAKING PROCEDURAL GENERATION
	public static inline var roomSize									: Int  = 25;
	
	/////////////////////////////////////////////////////////////////////////////////////////////// Inputs (ça va bouger de fichier)
	
	// AZERTY
	public static inline var moveUp										: FlxKey = FlxKey.Z;
	public static inline var moveLeft									: FlxKey = FlxKey.Q;
	public static inline var moveDown									: FlxKey = FlxKey.S;
	public static inline var moveRight									: FlxKey = FlxKey.D;	
	
	// QWERTY
	//public static inline var moveUp										: FlxKey = FlxKey.W;
	//public static inline var moveLeft									: FlxKey = FlxKey.A;
	//public static inline var moveDown									: FlxKey = FlxKey.S;
	//public static inline var moveRight									: FlxKey = FlxKey.D;
	
	public static inline var shootUp									: FlxKey = FlxKey.UP;
	public static inline var shootLeft									: FlxKey = FlxKey.LEFT;
	public static inline var shootDown									: FlxKey = FlxKey.DOWN;
	public static inline var shootRight									: FlxKey = FlxKey.RIGHT;	
}