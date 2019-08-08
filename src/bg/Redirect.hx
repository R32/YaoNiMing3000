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

	static function blockHandler(bd:Dynamic):BlockingResponse {
		return {cancel: true};
	}

	static function redirectHandler(bd:Dynamic):BlockingResponse {

		var url = new URL(bd.url);

		url.host = redirect_list.get(url.host);
		url.protocol = "https:"; // force https, since ustclug.org no longer supports http
		return {
			redirectUrl: url.href
		};
	}

	public static function doBlock(b:Bool, blockList:Array<String>):Void{
		WebRequest.onBeforeRequest.removeListener(blockHandler);
		if (b && blockList != null && blockList.length > 0){
			WebRequest.onBeforeRequest.addListener(blockHandler, {
				urls: blockList
			}, [blocking]);
		}
	}

	public static function doRedirect(b:Bool, redirectList:haxe.DynamicAccess<String>):Void{
		WebRequest.onBeforeRequest.removeListener(redirectHandler);

		if(b && redirectList != null){
			var hosts = [];
			for (key in redirectList.keys()) hosts.push("*://" + key + "/*");
			if (hosts.length == 0) return;

			WebRequest.onBeforeRequest.addListener(redirectHandler, {
				urls: hosts,
				types: [stylesheet, script, image, other]
			}, [blocking]);
		}
	}

	/**
	blocking 列表,  可能是由于被墙但又没有找到可用的镜像,暂时blocking防止超时加载, 或者广告
	*/
	public static var block_list(default, null):Array<String> = [
		"*://*.google.com/*",
		"*://*.chrome.com/*",
		"*://gstatic.com/*",
		"*://ssl.gstatic.com/*",
		"*://www.gstatic.com/*",
	];

	public static var spam_list(default, null):Array<String> = [
		"*://*.sczxy.com/*",		// 广告
		"*://*.qtmojo.com/*",
		"*://*.adinall.com/*",
		"*://*.jtxh.net/*",
		"*://*.songhua88.com/*",
		"*://*.sogou.com/*",
	];

	/**
	重定向列表
	*/
	public static var redirect_list(default, null):haxe.DynamicAccess<String> = {
		"fonts.googleapis.com" : "fonts.lug.ustc.edu.cn",
		"ajax.googleapis.com" : "ajax.lug.ustc.edu.cn",
		"themes.googleusercontent.com" : "google-themes.lug.ustc.edu.cn",
		"fonts.gstatic.com" : "fonts-gstatic.lug.ustc.edu.cn",
	};
}