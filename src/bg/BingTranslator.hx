package bg;

import chrome.Tabs;
import chrome.Extension;
import js.Browser.document;
import js.html.URL;

/**
不可以用于带有 响应头: "Content-Security-Policy" 的网页,比如 github.com
*/
class BingTranslator {
	/**
	暂时不处理 frame,iframe 页面.
	*/
	public static function onContextMenuClick(info, tab:Tab):Void {
		executeScript(new URL(info.pageUrl), tab);
	}

	public static function executeScript(url:URL, tab:Tab) {
		var proto = url.protocol.substring(0, 4);
		if (proto == "file" || proto == "http") {
			Tabs.executeScript(tab.id, {code: CODE} );
		}
	}

	/**
	https://msdn.microsoft.com/en-us/library/dn735968.aspx
	*/
	static inline var CODE = "setTimeout(function(){{var s=document.createElement('script');s.type='text/javascript';s.charset='UTF-8';s.src=((location&&location.href&&location.href.indexOf('https')==0)?'https://ssl.microsofttranslator.com':'http://www.microsofttranslator.com')+'/ajax/v3/WidgetV3.ashx?siteData=ueOIGRSKkd965FeEGM5JtQ**&ctf=True&ui=False&settings=Auto&from=';var p=document.getElementsByTagName('head')[0]||document.documentElement;p.insertBefore(s,p.firstChild);}},0);";
}