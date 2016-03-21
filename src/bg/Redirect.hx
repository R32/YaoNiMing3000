package bg;

import chrome.WebRequest;
import chrome.Storage;
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

	static function blHandler(bd:Dynamic):BlockingResponse {
		return {cancel: true};
	}

	static function rlHandler(bd:Dynamic):BlockingResponse {

		var url = new URL(bd.url);

		url.host = Reflect.field(rl, url.host);

		return {
			redirectUrl: url.href
		};
	}

	public static function dealBlock(b:Bool, blockList:Array<String>):Void{
		WebRequest.onBeforeRequest.removeListener(blHandler);
		if (b && blockList != null && blockList.length > 0){
			WebRequest.onBeforeRequest.addListener(blHandler, {
				urls: blockList
			}, [blocking]);
		}
	}

	public static function dealRedirect(b:Bool, rediList:Dynamic<String>):Void{
		WebRequest.onBeforeRequest.removeListener(rlHandler);

		if(b && rediList != null){
			var hosts = [];
			for (h in Reflect.fields(rediList)) hosts.push("*://" + h + "/*");

			if (hosts.length == 0) return;

			WebRequest.onBeforeRequest.addListener(rlHandler, {
				urls: hosts,
				types: [stylesheet, script, image, other]
			}, [blocking]);
		}
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
	];

	public static var spams(default, null):Array<String> = [
		"*://*.sczxy.com/*",		// 广告
		"*://*.qtmojo.com/*",
		"*://*.adinall.com/*",
		"*://*.jtxh.net/*",
		"*://*.songhua88.com/*",
	];

	/**
	重定向列表
	*/
	public static var rl(default, null):Dynamic<String> = {
		"fonts.googleapis.com" : "fonts.lug.ustc.edu.cn",
		"ajax.googleapis.com" : "ajax.lug.ustc.edu.cn",
		"themes.googleusercontent.com" : "google-themes.lug.ustc.edu.cn",
		"fonts.gstatic.com" : "fonts-gstatic.lug.ustc.edu.cn",
	};
}