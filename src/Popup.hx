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
import Data;

class Popup {

	static inline var ACTIVE = "active";
	static var localData: LocalData;	// reference from Background

	static var elem_redirect:Element;
	static var elem_block:Element;

	static inline function initBackground() (js.Browser.window:Dynamic).backpage = (Extension.getBackgroundPage():Dynamic).backpage;

	public static function main(){
		initBackground();

		document.querySelector("#main").onclick = onClick;
		localData = Background.localData;
		elem_redirect = document.querySelector("#btn_redirect");
		elem_redirect.classList.toggle(ACTIVE, localData.isRedirected);

		elem_block = document.querySelector("#btn_block");
		elem_block.classList.toggle(ACTIVE, localData.isBlocked);
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
				localData.isRedirected = !localData.isRedirected;
				elem_redirect.classList.toggle(ACTIVE, localData.isRedirected);
				Background.netRedirect(localData.isRedirected);
				Storage.sync.set(localData);

			case "btn_block":
				localData.isBlocked = !localData.isBlocked;
				elem_block.classList.toggle(ACTIVE, localData.isBlocked);
				Background.netBlock(localData.isBlocked);
				Storage.sync.set(localData);
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

