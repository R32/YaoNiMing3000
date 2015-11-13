package site;


import lib.Data;
import lib.Channel;
import js.html.XMLHttpRequest;
import js.Promise;
import haxe.Http;
import js.Cookie;
import js.html.URL;
import js.html.URLSearchParams;

using lib.Utils;

class ShQuery{
	public var base:Base;
	public var coin:Coin;
	public function new(b:Base, c:Coin) {
		base = b;
		coin = c;
	}
	
	public function toString(){
		return 'coinname=$coin&mk_type=$base&n=${Math.random()}';
	}
}

class ShDelOrder {
	public var id:String;	
	public var base:Base;
	public function new(s:String, b:Base) {
		id = s;
		base = b;
	}
	
	public function toString(){
		return 'order_id=$id&mk_type=$base&n=${Math.random()}';
	}
}

@:enum abstract OrderType(Int) to Int{
	var BUY = 1;
	var SELL = 2;
}




/**
 - GET 请求数据时, 不要用 send(formData), 而是应该把值加在 URI 后边

 - btc 没有处理 www.xx.com 和 xx.com 的Cookie, 也就是说 xx.com 收不到 www 的 Cookie, 但登录后都会跳转到 www 网址.
*/
class Btc38 extends Channel {
	
	var xhr:XMLHttpRequest;
	
	public function new(b:Base, c:Coin){
		super("btc38.com", b, c);
		xhr = new XMLHttpRequest();
		xhr.responseType = js.html.XMLHttpRequestResponseType.JSON;
		
		trace(new ShQuery(CNY, LTC).toString());
		trace(new ShDelOrder("129864844", CNY).toString());

		
	}
	
	override public function refresh(done:Void->Void):Void {
		if (!this.available) throw new js.Error("not available");
	}
	

	/**
	用于 btc38.com 主页
	
	url: `http://www.btc38.com/httpAPI.php?n=0.1814802596345544`
	 - n 估计为 Math 的随机数
	
	response: {}
	 
	```json
	{
		"btc2cny": "2561.900000"		// 当前 cny 价格. String, .6位
		"btc2cny_24h": "2555.000000"	// 24小时内成交平均价, String, .6位
		"btc2cny_vol": "5683131.137437900000"	// cny, 24小时成交量
		"ltc2cny": "23.240000"
		"ltc2cny_24h": "24.000000"
		"ltc2cny_vol": "1407697.726814730000"
		...
		
		"ltc2btc" : "0.00916000",		// btc 价格
		"ltc2btc_24h" : "0.00941000",
		"ltc2btc_vol" : "0.85094725701000"
		...
		"updatetime": 1446971169		// Float
	}
	```
	*/
	static inline var URI_HTTPAPI = "http://www.btc38.com/httpAPI.php";
	
	/**
	获得 30 个记录.
	
	url: `http://www.btc38.com/trade/getTradeList30.php?coinname=XRP&mk_type=CNY&n=0.4177240722347051`
	 - coinname: 币名，比如BTC、DOGE、BTS
	 - mk_type: cny为人民币定价，btc为比特币定价，不可为空
	 - n: 
	
	response: RPTradeList
	
	```json
	{
		buyOrder: [{	
			"price" : "0.030400",		// 买单单价 | String, .6位
			"amount" : "144950.518899"	// 数量 | String, .6位
		},{
			"price" : "0.030200",
			"amount" : "260150.756389"
		}...],
		sellOrder: [{					// 卖单
			"price" : "0.030600",
			"amount" : "425.290218"
		}...],
		trade:[{						// 已成交订单
			"price" : "0.030600",
			"volume" : "104575.163398",
			"time" : "2015-11-08 16:38:34",	// 成交时间 Date | String
			"type" : "1"					// 1为买入挂单，2为卖出挂单，不可为空 | String
		}]
	}
	```
	*/
	static inline var URI_TRADELIST30 = "http://www.btc38.com/trade/getTradeList30.php";
	
	
	/**
	
	url: `http://www.btc38.com/trade/getUserOrder.php?coinname=XRP&mk_type=CNY&n=0.6055362722836435`
	 - coinname: Coin
	 - mk_type: Base
	 - n 
	 
	response: RPUserOrder

	```json
	[{
		"id": "129864844"		// 	挂单ID	| String-Int	
		"coinname" : "xrp",		//	交的币种	| String
		"type" : "2",			// 1 为买单, 2 为卖单 | String-Int
		"price" : "0.123456",	// 单价		| String-Float.6
		"amount" : "123456.123456",		// | String-Float.6	
		"time": "2015-11-08 02:46:47"	// 挂单时间 | String-Date
	},{
	...
	}]
	```
	*/
	static inline var URI_USERORDER = "http://www.btc38.com/trade/getUserOrder.php";
	
	/**
	取消挂单
	
	url: `http://www.btc38.com/trade/delOrder.php?order_id=129864844&mk_type=CNY&n=0.7322458131238818`
	 - order_id: 挂单id, 通过 URI_USERORDER 成功提交挂单后将会返回这个
	 - mk_type: Base
	 - n
	 
	response: `succ`
	*/
	static inline var URI_DELORDER = "http://www.btc38.com/trade/delOrder.php";
	
	
	/**
	账户查询
	
	url: `http://www.btc38.com/trade/getMyBalance.php?n=0.24405142199248075`
	
	response: Dynamic<String>
	
	```json
	{
		"cny_balance" : "0.000000", 		// 可用 | String-Float.6
		"cny_balance_lock" : "-0.000001",	// 挂单中(不知道这个负数是怎么算出来的.)
		"cny_balance_imma" : "0.000000",	// 确认中
		
		"btc_balance" : "0.000000",			// 
		"btc_balance_lock" : "1.230000",	// 挂单中, 
		"btc_balance_imma" : "0.000000"
		...
	}
	```
	*/
	static inline var URI_MYBALANCE = "http://www.btc38.com/trade/getMyBalance.php";
}


/**
response, see URI_TRADELIST30
*/
typedef RPTradeList = {
	buyOrder:Array<{
		price: String,	// float.6|Std.parseFloat
		amount: String	// float.6|Std.parseFloat
	}>,
	sellOrder:Array<{
		price: String,	// float.6|Std.parseFloat
		amount: String	// float.6|Std.parseFloat		
	}>,
	
	trade:Array<{
		price: String,	// float.6|Std.parseFloat
		volume: String,	// float.6|Std.parseFloat
		time: String,	// Date|Date.fromString
		type: String	// Base | Base.lowercase
	}>
}

/**
response, see URI_USERORDER 
*/
typedef RPUserOrder = {
	id:String,			// Int|Std.int
	coinname:String,	// Base | Base.lowercase
	type:String,		// OrderType
	price:String,		// float.6|Std.parseFloat
	amount:String,		// float.6|Std.parseFloat
	time:String			// Date|Date.fromString
}


/**
已经登录的情况下,下边 Cookie 全在 
*/
@:enum abstract CookieNames(String) to String {
	
	var BTC38_credentials = "BTC38_credentials";	// 身份证号前 10 位, 未登录为空
	
	var BTC38_figureURL = "BTC38_figureURL";		// QQ 头像像是JPG 格式, 需要用 decodeURIComponent, 未登录为空
	
	var BTC38_id = "BTC38_id";						// 000000, 类似于 QQ号码, 表示为 btc38 的账号, 未登录为空
	
	var BTC38_md5 = "BTC38_md5";					// 未登录为空
	
	var BTC38_nickname = "BTC38_nickname";			// 显示一个 QQ 的呢称, 未登录为空
	
	var BTC38_tel = "BTC38_tel";					// 手机号码前 5 位, 未登录为空
	
	// ==== 当退录登录时, 上边 6 项转为 [Session] 形式的 Cookie,并且值为空, 否则 16 小时后到期
	
	var BTC38_trade_pwd = "BTC38_trade_pwd";		// ?? 1 or 0 有交易密码
	
	var BTC38_trade_pwd_is_need = "BTC38_trade_pwd_is_need";	// ??? 1 or 0, 1 表示需要易密码
	
	// ======================================================
	
	var BTC38_temp_url = "temp_url";				// 当前网址, 估计是用来跳转回来的
	
	var BTC38__jsluid = "__jsluid";					// [Session]
	
	// 下边二个像是 ip 值被 hash 之后, 因为
	// Hm_lpvt_a415e666baee8f21a707412783e345bc: 1447001814	[Session]
	// Hm_lvt_a415e666baee8f21a707412783e345bc: 1446579617,1446609855 [一年后到期]
}

