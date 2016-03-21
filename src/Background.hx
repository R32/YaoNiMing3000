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
#if !macro @:build(misc.Mt.build()) #end
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

			if(ps.block) Redirect.dealBlock(true);
			if(ps.redirect) Redirect.dealRedirect(true);
		});
	}

	// for popup.hx
	public static function bingTrans(url:js.html.URL, tab:Tab):Void{
		BingTranslator.executeScript(url, tab);
	}

	public static function netBlock(b:Bool):Void{
		Redirect.dealBlock(b);
	}

	public static function netRedirect(b:Bool):Void{
		Redirect.dealRedirect(b);
	}

	public static var ps:Ps;
}