---
layout: page
title: 关于
permalink: about/
lang: zh-CN
---
<p class="message">
  <b>Polyglot</b> 是一款专属于 <a href="http://jekyllrb.com">Jekyll</a> 博客的国际化插件。Polyglot 易于安装，且适用于任何项目，以及任何你所需要的语言。有了 Polyglot 的对缺失内容的应变支持、URL 自动相对化处理，以及<a href="{{site.baseurl}}/seo/">强大的 SEO 优化</a>，您可以在创作多语言博客时更加专注于内容，而非处理技术上的脏活累活。
</p>

_`jekyll-polyglot` 尚未在 github-actions 中原生支持_

### 安装

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### 管理支持的语言

在 `_config.yml` 中，以下属性管理您网站支持的语言。您可以通过将新语言添加到这些值来提供支持（见下文）。语言通过其官方[区域代码](https://developer.chrome.com/webstore/i18n)来识别。
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` 标识网站支持的语言的区域代码数组。
* `default_lang:` 网站的默认语言。
* `exclude_from_localization:` 属于构建网站但不需要本地化的文件夹和目录。这主要是为了缩短构建时间，由于图片和字体等资源文件是网站的重要部分，这确保它们不会在输出中被不必要地"翻译"或复制。
* `url` 您的生产静态网站的 URL。

### 添加新语言
假设您已经有一个功能正常的单语言网站，添加新语言并不简单。_要真正创建一个多语言网站，您应该预期需要用新语言重新创建所有内容。_ 这可能看起来是一项艰巨的任务，但请分部分考虑翻译。内容为王；新页面和帖子获得更新的翻译更为重要。只有当您要求从一开始就完美翻译时，创建多语言网站才会困难。

首先，您（和您的团队，以及您的经理，如果有的话）应该讨论并选择需要为新网站翻译哪些内容。您必须选择首选的基础内容进行翻译。考虑分析数据、热门页面和博客帖子，以及当前和未来用户访问您网站的流量。如有疑问，优先考虑页面而非旧博客帖子。如果这意味着可以更早推出新语言，旧帖子的翻译可能不值得付出那么多努力。

其次，您必须（或强烈建议）在整个网站提供100%的富内容覆盖。这些是以更复杂方式嵌入的小字符串。有多种方法可以遍历富内容。请记住，您必须在富内容中支持所有语言的所有小字符串。

#### 多语言内容
网站内容分为两种类型：**基础**和**富内容**。

基础内容是博客帖子、页面和非交互式内容的纯文本。想想页面和帖子。基础内容是网站点击的燃料。Polyglot 为基础内容提供回退支持。

富内容是交互式的、华丽的，由较短的字符串组成。想想导航栏和下拉菜单。富内容更具技术性，让访客留在网站上。_缺失的富内容没有回退支持。_

#### Liquid 工具
以下 Liquid 工具可与 jekyll-polyglot 一起使用：

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages` 直接指向 _config.yml 中的 `languages` 数组。可以通过 Liquid 访问。

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang` 直接指向 _config.yml 中的 `default_lang` 字符串。可以通过 Liquid 访问。

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}
`site.active_lang` 是正在构建页面的区域代码。德语版页面是 `"de"`，西班牙语版是 `"es"`，依此类推。可以通过 Liquid 访问。

使用这些工具，您可以指定如何附加正确的富内容。

* **page.rendered_lang**
{% highlight html %}
{% raw %}
{% if page.rendered_lang == site.active_lang %}
  <p>Welcome to our {{ site.active_lang }} webpage!</p>
{% else %}
  <p>webpage available in {{ page.rendered_lang }} only.</p>
{% endif %}
{% endraw %}
{% endhighlight %}

`page.rendered_lang` 变量表示页面内容的实际语言，允许模板检测页面何时作为回退内容提供。

### Github Pages 支持
默认情况下，Github 阻止 [Jekyll 博客使用插件](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides)。这是故意的，以防止恶意代码在 Github 服务器上执行。虽然这使得使用 Polyglot（和其他 Jekyll 插件）更加困难，但仍然可行。

#### 将 `_site/` 构建到 gh-pages
您可以在单独的分支上开发 Jekyll 网站，然后将构建的 `_site/` 内容推送到 `gh-pages` 分支，而不是在 Github 上托管 Jekyll 博客引擎。这允许您使用 Github 管理和源代码控制您的网站开发，*而无需依赖 Github 来构建您的网站！*

您可以通过在单独的分支上维护 Jekyll 内容，只将 `_site/` 文件夹提交到 gh-pages 分支来实现。因为这些只是文件夹中的静态 HTML 页面，Github 会像其他任何 [gh-pages](https://pages.github.com/) 内容一样托管它们。

#### 自动化！

这个过程通过一个简单的脚本大大简化，该脚本将构建您的网站并将 `_site/` 文件夹提交到您的 gh-pages。很多人都有一个。[这里有一个](http://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/)。[这里还有一个](https://gist.github.com/cobyism/4730490)。这是[我的发布脚本](https://github.com/untra/polyglot/blob/main/publi.sh)：
```bash
#! /bin/sh
# 相应地更改分支名称
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
