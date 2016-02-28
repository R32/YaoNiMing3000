package;


import chrome.Extension;
import chrome.Runtime;
import js.Browser.window;
import chrome.BrowserAction;
import chrome.Tabs;
import chrome.Commands;
import chrome.ContextMenus;
import chrome.Notifications;
import Redirect;

import chrome.Proxy;
import chrome.Privacy;
import helps.AssetsPath;
import chrome.AccessibilityFeatures;

@:expose("bg")
@:keep
class Background {
	
	public static var xbotId:Null<Int> = null;
	public static function xbotLoad(){
		if (xbotId == null) {
			xbotId = -1;
			Tabs.create( { url:AssetsPath.HTML_xbot}, function(tab) { xbotId = tab.id;} );
			Tabs.onRemoved.addListener(function(id, _) { if (xbotId == id) xbotId = null;} );
		}else if (xbotId != -1) {
			Tabs.update(xbotId, { active:true } );
		}
	}
	
	static public function main() {	
		ContextMenus.create( {
			id: "bing_translator",
			title:"Bing 在线翻译",
			documentUrlPatterns: ["*://*/*", "file:///*"],
			onclick: BingTranslator.onContextMenuClick
		});
		Redirect.attach();
	}
	
	// for popup.hx
	public static function bingTrans(url:js.html.URL, tab:Tab){
		BingTranslator.executeScript(url, tab);
	}
}