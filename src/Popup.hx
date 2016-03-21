package;

import haxe.Constraints.Function;
import js.Browser;
import js.Lib;
import js.jquery.JQuery;
import js.Browser.window;
import js.Browser.document;
import js.html.MouseEvent;
import js.html.URL;
import chrome.Extension;
import chrome.Tabs;
import chrome.Storage;
import helps.AssetsPath;
import misc.Data;


class Popup{

	static inline var ACTIVE = "active";
	static var ps:Ps;	// reference from Background
	static var redirect:JQuery;
	static var block:JQuery;

	public static function main(){
		Background.init(Extension.getBackgroundPage());
		ps = Background.ps;


		document.querySelector("#main").onclick = onClick;
		redirect = new JQuery("#main button.net-redirect:first");
		block = new JQuery("#main button.net-block:first");
		state(redirect, ps.redirect);
		state(block, ps.block);
	}

	static function state(node:JQuery, b:Bool):Void{
		b ? node.addClass(ACTIVE) : node.removeClass(ACTIVE);
	}

	static function onClick(e:MouseEvent):Void{
		var tar:js.html.DOMElement = cast e.target;
		var tag_a:Bool = tar.tagName == "A";

		e.preventDefault();
		e.stopPropagation();

		if(tag_a){
			switch (tar.className) {
				case "item xbot":
					Background.xbotLoad();
				case "item bing_trans":
					Tabs.query({ active: true, currentWindow: true }, onBingTrans);
				default:
			}
			window.close();
		}else{
			switch(tar.id){
				case "btn_redirect":
					ps.redirect = !ps.redirect;
					state(redirect, ps.redirect);
					Background.netRedirect(ps.redirect);
					Storage.sync.set(ps);

				case "btn_block":
					ps.block = !ps.block;
					state(block, ps.block);
					Background.netBlock(ps.block);
					Storage.sync.set(ps);
				default:
			}
		}
	}

	static function onBingTrans(tabs:Array<Tab>):Void{
		var tab = tabs[0];
		var url = new URL(tab.url);
		Background.bingTrans(url, tab);
	}
}

