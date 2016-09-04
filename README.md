要你命3000 [![Build Status](https://travis-ci.org/R32/YaoNiMing3000.svg?branch=master)](https://travis-ci.org/R32/YaoNiMing3000)
--------

**Chrome 浏览器扩展(WIP)**

我费了一生的精力，集合十种杀人武器于一身的超级武器霸王，每样都能独当一面，现在集中在一起，看你怕不怕？

- Bing 在线翻译, 通过右键菜单(contextMenu), 但不能处理带 "Content-Security-Policy" 限制的网址如: "github.com"

- Redirect 重定向 google api 到国内镜向, 以及 blocking 一些网址

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

  > [semantic-ui github](https://github.com/Semantic-Org/Semantic-UI) 由于使用默认 google 字体，因此需要自改参数编译
  >
  > [mithril.js](http://mithril.js.org/)
  >
  > [jquery](http://jquery.com/download/)


* 外部JS库及CSS 需要自行下载放置于 `build/libs/` 目录下, 类似于下边:

  ```bash
  libs/
    ├─ theme           # semantic 的主题目录
    ├─ jQuery.min.js
    ├─ mithril.min.js
    ├─ semantic.js
    └─ semantic.css    # 注意默认的 css 带有 google 字体
  ```

自行编译 semantic-ui，或者如果是线上的话可以使用国内镜像地址代替 google 的网址

1. git clone 一份到本地目录，使用 gulp 编译。可能会下载一堆的 node_modules。

2. see [#1521](https://github.com/Semantic-Org/Semantic-UI/issues/1521), 找到 `src/site/globals/site.variables` 并添加这一行 `@importGoogleFonts: false;`

3. semantic-ui 的最大差异是有些类名必须得按顺序，比如 `right aligned` 它在 CSS 中是以 `[class*="right aligned"]` 的形式写的。

### issues
