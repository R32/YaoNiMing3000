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

class Background {
	
	static var tabId:Null<Int> = null;
	
	inline static var btId = "bing_translator";
	
	static public function main() {
	//	Commands.onCommand.removeListener(_onCommand);
	//	Commands.onCommand.addListener(_onCommand);
		
		ContextMenus.create( {
			id:btId,
			title:"Bing 在线翻译",
			documentUrlPatterns: ["*://*/*", "file:///*"],
			onclick: BingTranslator.onContextMenuClick
		});	
		Redirect.attach();
	}
	
	/*
	static function _onCommand(cmd:String):Void {
		switch(cmd){
			case "xbot":	// see manifest.json
				if (tabId == null) {
					tabId = -1;
					Tabs.create( { url:AssetsPath.HTML_xbot}, function(tab) { tabId = tab.id;} );
					Tabs.onRemoved.addListener(function(id, _) { if (tabId == id) tabId = null;} );
				}else if (tabId != -1) {		
					Tabs.update(tabId, { active:true } );
				}
			default:
		}
	}
	*/
}