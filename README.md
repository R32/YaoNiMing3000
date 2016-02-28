要你命3000 [![Build Status](https://travis-ci.org/R32/YaoNiMing3000.svg?branch=master)](https://travis-ci.org/R32/YaoNiMing3000)
--------

**Chrome 浏览器扩展(WIP)** 

我费了一生的精力，集合十种杀人武器于一身的超级武器霸王，每样都能独当一面，现在集中在一起，看你怕不怕？

 - Bing 在线翻译, 通过右键菜单(contextMenu), 但不能处理带 "Content-Security-Policy" 限制的网址如: "github.com"

 - Redirect 自动(目前没有UI页面设置),重定向 google api 到国内镜向, 以及 blocking 一些网址

 - xbot 未完成
 
 - ~~Proxy~~ 目前使用 [lantern](https://github.com/getlantern/lantern), 因此移除了这项
 
 - (未知) 
 
 - (未知)
 
 - (未知)
 
 - (未知)
 
 - (未知)
 
 - (未知)

### Dependencies

 * 相关的 haxelib 参见 `build.hxml` 文件 

 * 外部JS库及CSS 需要自行下载放置于 `build/libs/` 目录下, 类似于下边:
 
```bash
libs/
  ├─ theme           # semantic 的主题目录
  ├─ jQuery.min.js
  ├─ semantic.js
  └─ semantic.css    #注意默认的 css 带有 google 字体
```