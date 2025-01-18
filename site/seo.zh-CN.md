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

对每个 [W3C 国际化示范实例](http://www.w3.org/International/geo/html-tech/tech-lang.html#ri20060630.133615821)
，你可以对每个页面都使用一个元数据标签设置默认语言。只需把如下内容添加到你的 `head` 标签中：

{% highlight html %}{% raw %}
<meta http-equiv="Content-Language" content="{{site.active_lang}}">
{% endraw %}
{% endhighlight %}

## 使用 hreflang 替代标签实现多语言 SEO

你可以为你的站点简单地添加 [hreflang 替代标签](https://support.google.com/webmasters/answer/189077?hl=zh-CN)，达成 Google 对多语言搜索的 SEO。添加下列内容到你的 `head` 标签中：

{% highlight html %}
{% raw %}
<link rel="alternate"
      hreflang="{{site.default_lang}}"
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

## 一步到位

你可以通过把如下的标签直接添加到你的 `head.html` 文件中，以直接达成上述效果：

{% highlight html %}
{% raw %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}

<br>

若采用如上的 SEO 策略，每次对站点不同子语言内容的点击，都会计入到站点的净点击中。

## 其他适用于 polyglot 的 SEO 最佳实践

* 始终确保为页面的 `keywords` 和 `description` 指定 `<meta>` 标签。 搜索引擎将使用这些标签来更好地索引页面；对于多语言网站，您应该为网站支持的每种子语言提供不同的值：

{% highlight html %}
{% raw %}
  <meta name="description" content="{{ page.description | default: site.description[site.active_lang] }}">
  <meta name="keywords" content="{{ page.keywords | default: site.keywords[site.active_lang] }}">
{% endraw %}
{% endhighlight %}