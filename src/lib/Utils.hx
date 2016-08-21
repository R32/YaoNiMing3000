package lib;


/**
Using Utils;
*/
class Utils {

	// e.g: (1.123).toFixed(2)
	static public inline function toFixed(f:Float, n:Int):String {
	#if (js || flash || as3)
		return untyped f.toFixed(n);
	#else
		throw "TODO";
	#end
	}

	// e.g:  Base.BTC.getName() == Coin.BTC.getName() => "BTC == BTC"
	static public inline function getName(str:String):String return str;

	// e.g: Base.CNY.toLowerCase() => "cny"
	static public inline function toLowerCase(str:String):String return str.toLowerCase();
}