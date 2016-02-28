package;


import js.Lib;
import js.Browser.window;
import js.Browser.document;
import js.html.MouseEvent;
import js.html.URL;
import chrome.Extension;
import chrome.Tabs;
import helps.AssetsPath;

typedef Bg = helps.AutoExtern<Background>;

class Popup{

	public static function main(){
		Bg.init(Extension.getBackgroundPage());
		
		document.querySelector("#main").onclick = onClick;
	}
	
	static function onClick(e:MouseEvent):Void{
		switch (untyped e.target.className) {
			case "item xbot":
				Bg.xbotLoad();		
			case "item bing_trans":
				Tabs.query({ active: true, currentWindow: true }, onBingTrans);
			default:
		}
		e.preventDefault();
		e.stopPropagation();
		window.close();
	}
	
	static function onBingTrans(tabs:Array<Tab>):Void{
		var tab = tabs[0];
		var url = new URL(tab.url);
		Bg.bingTrans(url, tab);
	}
}