package;

import chrome.Tabs;
import bg.Redirect;
import bg.BingTranslator;
import Data;

@:keep
@:expose("backpage")
@:native("backpage")
class Background {
	/**
	* 打开指定页面, 如果页面已经存在则将这个页面设为焦点
	* @param href e.g: chrome.Extension.getURL(uri);
	*/
	public static function load2Page(href:String, ?callb:Tab->Void) {
		Tabs.query({url:href}, function(tabs:Array<Tab>){
			if(tabs.length > 0){
				Tabs.update(tabs[0].id, {active:true}, callb);
			}else{
				Tabs.create({url: href}, callb);
			}
		});
	}

	static function main() {
		chrome.Storage.sync.get(localData, function(data:LocalData){
			localData.isBlocked = data.isBlocked;
			localData.isRedirected = data.isRedirected;

			netBlock(localData.isBlocked);
			if(localData.isRedirected) netRedirect(true);
		});
	}

	public static function bingTrans(url:js.html.URL, tab:Tab):Void{
		BingTranslator.executeScript(url, tab);
	}

	public static function netBlock(b:Bool) {
		var list = Redirect.spam_list;
		if (b) list = list.concat(Redirect.block_list);
		Redirect.doBlock(true, list);		// 暂时永久性禁掉广告连接
	}

	public static function netRedirect(b:Bool):Void{
		Redirect.doRedirect(b, Redirect.redirect_list);
	}

	public static function log(val:Dynamic) {
		js.Browser.console.log(val);
	}

	public static var localData: LocalData = {isBlocked:false, isRedirected:true};
}