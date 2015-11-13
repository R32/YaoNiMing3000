package lib;


@:enum abstract Base(String) to String{
	var CNY = "CNY";
	//var cny = "cny";
	
	var USD = "USD";
	//var usd = "usd";
	
	var EUR = "EUR";
	//var eur = "eur";
	
	var JPY = "JPY";
	//var jpy = "jpy";
	
	var BTC = "BTC";
	//var btc = "btc";
	
}

@:enum abstract Coin(String) to String {
	var BTC = "BTC";
	//var btc = "btc";
	
	var LTC = "LTC";
	//var ltc = "ltc";
	
	var DOGE = "DOGE";
	//var doge = "doge";
	
	var XRP = "XRP";
	//var xrp = "xrp";
}