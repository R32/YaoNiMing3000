package;

import js.JQuery;
import js.JQuery.JQueryHelper.J;
import js.Browser.document;
import js.Promise;
import chrome.Notifications;
import chrome.Tabs;
import site.Btc38;
import lib.Hub;
import lib.Data;

using lib.Utils;

/**
for index.html


*/
class Xbot{
	static function  main() {
		
		eventCfg();
		
		trace("i'm ready!");	
	
		new Btc38(Base.CNY, Coin.LTC);	
	}
	
	static inline function focus(){
		Tabs.getCurrent(function(tab){
			Tabs.update(tab.id, { active:true } );
		});
	}
	
	static inline function eventCfg() {
		// prevent F5
		document.addEventListener("keydown", function(e) { 
			if (e.which == 116 || e.keyCode == 116) e.preventDefault();
		} );
		
		
		untyped {
			
			JQuery(".ui.dropdown").dropdown( {
				action: "hide",		// 当这个为 hide 时, onChange 只有 value, 优先读取 data-value,否则 textContext
				onChange: function(value) {
					trace(value);
				}
			});
		
		}
	}
}

