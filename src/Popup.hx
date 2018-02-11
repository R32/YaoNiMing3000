package;

import haxe.Constraints.Function;
import js.Lib;
import js.Browser;
import js.Browser.window;
import js.Browser.document;
import js.html.MouseEvent;
import js.html.Element;
import js.html.URL;
import chrome.Extension;
import chrome.Tabs;
import chrome.Storage;
import misc.Data;


class Popup {

	static inline var ACTIVE = "active";
	static var ps:Ps;	// reference from Background

	static var redirect:Element;
	static var block:Element;

	public static function main(){
		Background.init(Extension.getBackgroundPage());
		ps = Background.ps;
		document.querySelector("#main").onclick = onClick;
		redirect = document.querySelector("#main button.net-redirect");
		block = document.querySelector("#main button.net-block");
		redirect.classList.toggle(ACTIVE, ps.redirect);
		block.classList.toggle(ACTIVE, ps.block);
	}

	static function onClick(e:MouseEvent):Void{
		var tar:js.html.AnchorElement = cast e.target;
		e.preventDefault();		// prevent A Link
		e.stopPropagation();

		if(tar.tagName == "A"){
			switch (tar.className) {
			case "item bing_trans":
				Tabs.query({ active: true, currentWindow: true }, onBingTrans);
			case "item options":
				Background.load2Page(tar.href);
			default:
			}
			window.close();
		} else {
			switch(tar.id){
			case "btn_redirect":
				ps.redirect = !ps.redirect;
				redirect.classList.toggle(ACTIVE, ps.redirect);
				Background.netRedirect(ps.redirect);
				Storage.sync.set(ps);

			case "btn_block":
				ps.block = !ps.block;
				block.classList.toggle(ACTIVE, ps.block);
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

