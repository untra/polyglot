---
layout: page
title: SEO 方案
permalink: seo/
lang: zh-CN
description: 这些补充可以帮助提高使用 Polyglot 时多语言 Jekyll 博客的 SEO。
---

# 使用 Polyglot 的搜索引擎优化（SEO）方案

如果你已经安装了 `jekyll-polyglot` 包，把这些内容加入到你的网站的 `head` 标签中，可以让你的 Jekyll 轻松地获取更多的面向 Google 的 SEO 加成。

## HTML 语言声明

根据 [WHATWG HTML 规范](https://html.spec.whatwg.org/multipage/dom.html#the-lang-and-xml:lang-attributes)，你应该在根 HTML 元素上使用 `lang` 属性来声明页面语言。在你的布局中添加如下内容：

{% highlight html %}{% raw %}
<html lang="{{ site.active_lang }}">
{% endraw %}
{% endhighlight %}

这使浏览器、搜索引擎和辅助技术（屏幕阅读器、翻译工具）能够正确处理你的内容。

## 使用 hreflang 替代标签实现多语言 SEO

你可以轻松地为你的网站添加 `hreflang="{{site.active_lang}}"` [alternate 标签](https://developers.google.com/search/docs/specialty/international/localized-versions?hl=zh-CN)，以实现 Google 多语言搜索的 SEO。当浏览器使用了不匹配的语言时，可以通过 `hreflang="x-default"` 回退到站点的默认语言版本。

在为同一语言的相似页面标识内容时，请务必包含 [canonical 标签](https://developers.google.com/search/docs/specialty/international/managing-multi-regional-sites?hl=zh-CN)。

{% highlight html %}
{% raw %}
{% if page.lang == site.default_lang %}
<link rel="canonical"
      href="http://yoursite.com{{page.permalink}}" />
{% else %}
<link rel="canonical"
      href="http://yoursite.com/{{page.lang}}{{page.permalink}}" />
{% endif %}
<link rel="alternate"
      hreflang="{{site.default_lang}}"
      href="http://yoursite.com{{page.permalink}}" />
<link rel="alternate"
      hreflang="x-default"
      href="http://yoursite.com{{page.permalink}}" />
{% for lang in site.languages %}
{% if lang == site.default_lang %}
  {% continue %}
{% endif %}
<link rel="alternate"
    hreflang="{{lang}}"
    href="http://yoursite.com/{{lang}}{{page.permalink}}" />
{% endfor %}
{% endraw %}
{% endhighlight %}

## 一步到位（hreflang 和 canonical）

你可以通过把如下的标签直接添加到你的 `head.html` 文件中，以获取 canonical 链接、alternate hreflang 链接和 x-default 回退：

{% highlight html %}
{% raw %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}

注意：你仍然需要按照上述说明，在布局的根元素上单独添加 `<html lang="{{ site.active_lang }}">`。

若采用如上的 SEO 策略，每次对站点不同子语言内容的点击，都会计入到站点的净点击中。

## 在 polyglot 中使用 jekyll-seo-tag

[jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) 是另一个用于 SEO 的 Jekyll 插件，它会输出 `<title>` 和 `<meta>` 标签。Polyglot 的 `{% raw %}{% I18n_Headers %}{% endraw %}` 在设计上可以与它共存：让 jekyll-seo-tag 处理 canonical URL 之外的所有内容，由 polyglot 来处理 canonical 和 hreflang alternate 链接（polyglot 能正确地跨语言生成它们）：

{% highlight liquid %}
{% raw %}
{% seo canonical=false %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}

`canonical=false` 选项需要 jekyll-seo-tag v2.9.0 或更高版本。

### 未翻译页面的回退 canonical

默认情况下，若某个页面在当前活动语言下没有翻译，其 canonical 仍会指向它在该语言下的 URL。为了获得更好的 SEO，你可以让回退页面的 canonical URL 指向默认语言版本。在 `_config.yml` 中添加：

{% highlight yaml %}
fallback_canonical_to_default_lang: true
{% endhighlight %}

启用后：

- 有真实翻译的页面：canonical 指向翻译后的 URL（例如 `/es/sobre-nosotros/`）。
- 回退页面（没有翻译）：canonical 指向默认语言的 URL（例如 `/about/` 而非 `/es/about/`）。

这能将 SEO 权重集中到原始内容上，并避免搜索引擎为各语言间重复的回退页面建立索引。

## 在 polyglot 中使用 jekyll-redirect-from

[jekyll-redirect-from](https://github.com/jekyll/jekyll-redirect-from) 插件允许页面声明它们应该从哪些旧 URL 重定向过来。Polyglot 以两种方式与它集成：

**通过 `page_id` 实现跨语言自动重定向。** 当两个页面拥有相同的 `page_id` 但具有不同的 permalink 时，polyglot 会自动将其他语言版本的 permalink 添加到该页面的 `redirect_from` 中。无需任何手动配置——只要确保两个页面在 front matter 中拥有相同的 `page_id` 即可。

**按语言作用域的 `redirect_from`。** 当一个非默认语言的页面声明了自己的 `redirect_from` 时，polyglot 会自动为这些路径加上该页面的语言代码前缀，例如在法语页面上 `/old-path` 会变为 `/fr/old-path`。已经以语言代码开头的路径会保持不变。

请在你的站点中包含一个自定义的 [redirect.html 布局](https://github.com/untra/polyglot/blob/main/site/_layouts/redirect.html)。

## 本地化 Netlify _redirects

_自 1.13.0 起新增。_

当你部署到 [Netlify](https://www.netlify.com/) 并使用 [`_redirects` 文件](https://docs.netlify.com/manage/routing/redirects/overview/#syntax-for-the-_redirects-file) 时，Polyglot 可以自动为每条规则生成带语言前缀的副本，使它们在你所有本地化的 URL 上都能生效。

在 `_config.yml` 中启用：

{% highlight yaml %}
localize_redirects: true
exclude_from_redirect_localization:
  - /signin
  - /app
{% endhighlight %}

启用后，像这样一条规则：

{% highlight text %}
/github  https://github.com/org/repo  302
{% endhighlight %}

会针对每种已配置的语言扩展为带语言前缀的副本：

{% highlight text %}
/github     https://github.com/org/repo  302
/fr/github  https://github.com/org/repo  302
/de/github  https://github.com/org/repo  302
/sv/github  https://github.com/org/repo  302
{% endhighlight %}

外部目标 URL 会原样保留。列在 `exclude_from_redirect_localization` 中的路径不会被本地化，这对于只应在根路径下存在的认证端点或单页应用路由非常有用。