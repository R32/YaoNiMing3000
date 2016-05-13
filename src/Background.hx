package;

import chrome.Extension;
import chrome.Runtime;
import js.Browser.window;
import js.Promise;
import chrome.BrowserAction;
import chrome.Tabs;
import chrome.Commands;
import chrome.ContextMenus;
import chrome.Notifications;
import chrome.Storage;
import chrome.Proxy;
import chrome.Privacy;
import chrome.AccessibilityFeatures;
import misc.Data;
import bg.Redirect;
import bg.BingTranslator;

#if js_bg
@:expose("bg") @:keep
#else
@:native("bg") extern
#end
class Background {

	/**
	* 打开指定页面, 如果页面已经存在则将这个页面设为焦点
	* @param href e.g: chrome.Extension.getURL(uri);
	*/
	public static function load2Page(href:String):Void{
		new Promise(function(resolve, reject){
			Tabs.query({url:href}, function(tabs:Array<Tab>){
				if(tabs.length > 0){
					resolve(tabs[0]);
				}else{
					reject(href);
				}
			});
		}).then(loadThen).catchError(loadError);
	}

	static function loadThen(tab:Tab):Tab{ Tabs.update(tab.id, {active:true}); return tab; }

	static function loadError(href:String):Void{ Tabs.create({url: href}, null); }

#if js_bg
	static public function main():Void {
		ContextMenus.create( {
			id: "bing_translator",
			title:"Bing 在线翻译",
			documentUrlPatterns: ["*://*/*", "file:///*"],
			onclick: BingTranslator.onContextMenuClick
		});

		ps = {block:false, redirect:true };

		Storage.sync.get(ps, function(v:Ps){
			ps.block = v.block;
			ps.redirect = v.redirect;

			if(ps.block) netBlock(true);
			if(ps.redirect) netRedirect(true);
		});
	}
#else
	// for extern class, 这里无法同时获得 expose 和 native 的参数, 因为它们在不同的"空间"
	// window[:native] = getBackgroundPage()[:expose];
	static public inline function init(backpage:Dynamic):Void{
		untyped window.bg = backpage.bg;
	}
#end
	// for popup.hx
	public static function bingTrans(url:js.html.URL, tab:Tab):Void{
		BingTranslator.executeScript(url, tab);
	}

	public static function netBlock(b:Bool):Void{
		var list = Redirect.spams;
		if (b) list = list.concat(Redirect.bl);
		Redirect.dealBlock(true, list);		// 暂时永久性禁掉广告连接
	}

	public static function netRedirect(b:Bool):Void{
		Redirect.dealRedirect(b, Redirect.rl);
	}

	public static var ps:Ps;
}