package;


import chrome.WebRequest;
import js.html.URL;

/**
https://servers.ustclug.org/2014/07/ustc-blog-force-google-fonts-proxy/
 - fonts.googleapis.com         fonts.lug.ustc.edu.cn
 - ajax.googleapis.com          ajax.lug.ustc.edu.cn
 - themes.googleusercontent.com google-themes.lug.ustc.edu.cn
 - fonts.gstatic.com            fonts-gstatic.lug.ustc.edu.cn
 
http://libs.useso.com/ 未使用.

chrome extension 权限:	"webRequest", "webRequestBlocking", "<all_urls>"
*/
class Redirect {
	
	inline public static function detach(){
		WebRequest.onBeforeRequest.removeListener(rlHandler);
		WebRequest.onBeforeRequest.removeListener(blHandler);
	}
	
	public static function attach() {
		detach();
		
		var hosts = [];
		for (h in Reflect.fields(rl)) hosts.push("*://" + h + "/*");
		
		WebRequest.onBeforeRequest.addListener(rlHandler, {
			urls: hosts,
			types: [stylesheet, script, image, other]
		}, [blocking]);
		
		WebRequest.onBeforeRequest.addListener(blHandler, {
			urls: bl
		}, [blocking]);
		
	}
	
	/**
	blocking 列表,  可能是由于被墙但又没有找到可用的镜像,暂时blocking防止超时加载, 或者广告
	*/
	public static var bl(default, null):Array<String> = [
		"*://*.google.com/*",
		"*://*.chrome.com/*",
		"*://gstatic.com/*",
		"*://ssl.gstatic.com/*",
		"*://www.gstatic.com/*",
		// 
		"*://*.sczxy.com/*",		// 广告
		"*://*.qtmojo.com/*",
		"*://*.adinall.com/*",
		"*://*.jtxh.net/*",
		"*://*.songhua88.com/*",
	];
	static function blHandler(bd):BlockingResponse {
		return {cancel: true};
	}
		
	/**
	重定向列表 
	*/
	public static var rl(default, null):Dynamic<String> = {
		"fonts.googleapis.com" : "fonts.lug.ustc.edu.cn",
		"ajax.googleapis.com" : "ajax.lug.ustc.edu.cn",
		"themes.googleusercontent.com" : "google-themes.lug.ustc.edu.cn",
		"fonts.gstatic.com" : "fonts-gstatic.lug.ustc.edu.cn",
	};
	
	static function rlHandler(bd):BlockingResponse {
		
		var url = new URL(bd.url);
		
		url.host = Reflect.field(rl, url.host);
		
		return {
			redirectUrl: untyped url.toString()
		};
	}
}