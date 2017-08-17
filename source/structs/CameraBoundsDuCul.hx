package structs;
import flixel.FlxBasic;

//typedef CameraBoundsDuCul =
//{
//minScrollX : Null<Float>,
//maxScrollX : Null<Float>,
//minScrollY : Null<Float>,
//maxScrollY : Null<Float>,
//}

class CameraBoundsDuCul
{
	//public var minScrollX : Null<Float>;
	//public var maxScrollX : Null<Float>;
	//public var minScrollY : Null<Float>;
	//public var maxScrollY : Null<Float>;
	
	public var minScrollXi : Int;
	public var maxScrollXi : Int;
	public var minScrollYi : Int;
	public var maxScrollYi : Int;
	
	public function new(MinScrollX:Null<Float>, MaxScrollX:Null<Float>, MinScrollY:Null<Float>, MaxScrollY:Null<Float>)
	{
		//minScrollX = MinScrollX;
		//maxScrollX = MaxScrollX;
		//minScrollY = MinScrollY;
		//maxScrollY = MaxScrollY;
		
		minScrollXi = MinScrollX == null ? 0 : Std.int(MinScrollX);
		maxScrollXi = MaxScrollX == null ? 0 : Std.int(MaxScrollX);
		minScrollYi = MinScrollY == null ? 0 : Std.int(MinScrollY);
		maxScrollYi = MaxScrollY == null ? 0 : Std.int(MaxScrollY);
	}
}