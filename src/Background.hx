package;

import chrome.Tabs;
import misc.Data;
import bg.Redirect;

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
	public static function load2Page(href:String, ?callb:Tab->Void):Void{
		Tabs.query({url:href}, function(tabs:Array<Tab>){
			if(tabs.length > 0){
				Tabs.update(tabs[0].id, {active:true}, callb);
			}else{
				Tabs.create({url: href}, callb);
			}
		});
	}

#if js_bg
	static public function main():Void {
		chrome.ContextMenus.create( {
			id: "bing_translator",
			title:"Bing 在线翻译",
			documentUrlPatterns: ["*://*/*", "file:///*"],
			onclick: bg.BingTranslator.onContextMenuClick
		});

		ps = {block:false, redirect:true };

		chrome.Storage.sync.get(ps, function(v:Ps){
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
		untyped js.Browser.window.bg = backpage.bg;
	}
#end
	// for popup.hx
	public static function bingTrans(url:js.html.URL, tab:Tab):Void{
		bg.BingTranslator.executeScript(url, tab);
	}

	public static function netBlock(b:Bool):Void{
		var list = Redirect.spams;
		if (b) list = list.concat(Redirect.bl);
		bg.Redirect.dealBlock(true, list);		// 暂时永久性禁掉广告连接
	}

	public static function netRedirect(b:Bool):Void{
		bg.Redirect.dealRedirect(b, Redirect.rl);
	}

	public static function log(val:Dynamic):Void{
		js.Browser.console.log(val);
	}

	public static var ps:Ps;
}