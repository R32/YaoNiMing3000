package lib;

import lib.Data;

using lib.Utils;

/**
交易是通过 挂单/取消挂单 进行的, 因此需要先取消挂单, 再重新挂单. 这里好像有个延时的问题. 

*/
class Channel {
	
	// 已经成功登录, 可以使用 交易 API
	public var available(default, null):Bool;
	
	// 交易的虚拟币
	public var coin(default, null):Coin;
	
	// 交易虚拟币使用的 币种, 通常为 CNY
	public var base(default, null):Base;
	
	// e.g: btc38.com
	public var name(default, null):String;		
	
	// 账户余额,不包括挂单中的钱
	public var balance(default, null):Dynamic<Float>;
	
	public function new(n:String, b:Base, c:Coin) {
		if (b.getName() == c.getName()) throw new js.Error("BTC == BTC");
		name = n;
		base = b;
		coin = c;
	}
	
	/**
	调用后将更新 balance 的值.
	*/
	public function refresh(done:Void->Void):Void {}
	
	/**
	挂单, 分为 buy, 和 sell
	*/
	public function order():Void{ }
	
	/**
	撤单 
	*/
	public function cannel():Void{ }
	
	public function query(done:Dynamic->Void):Void {}
	
	
	public function login(done:Void->Void):Void {	
		// set "available" as true
	}
	
	/**
	如果 name,base,coin 相等那么这二个 channel 即为相等.
	*/
	static public function eq(a:Channel, b:Channel):Bool {
		return a.name == b.name && a.base == b.base && a.coin == b.coin;
	}
}
