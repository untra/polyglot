---
layout: post
title: Polyglot 简介
lang: zh-CN
---

在经过数月的打磨后，我很骄傲地为大家介绍 **Polyglot**：为那些*需要*为其受众提供多语言内容的网站所打造的，一款 [Jekyll](http://jekyllrb.com) 的 i18n 插件。

### 特性

尽管市面上存在其他的 Jekyll 多语言插件，Polyglot 却也有其独特之处。多语言插件，Polyglot 在包揽了那些通常留给 Jekyll 开发者去做的脏活累活（比如为了保持不同语言网站下站点地图保持一致而去折腾 url 的写法）的同时，还为他们提供了高效且简单的 SEO 与内容聚合工具。

## 创建相对化链接

在过去，一款静态网站/博客的多语言插件必须费心地跟进维护网站上所提供的每种语言的相对链接。开发者很容易犯错，然后外语访客就会一下子掉进还没翻译的内容之中。

Polyglot 自动化地为每种你希望网站所拥有的语言的 url 进行相对化处理。这可以让网站的访客可以在浏览你的网站时一直使用同一种语言的版本。

## 应变支持

当你*没有*为多语言内容提供翻译版本时，Jekyll 依然会为该语言的子站点根据已有的内容进行构建。而在你*提供*了多语言翻译版本的情况下，Jekyll 会根据该内容对该语言的子站点构建对应内容。就是这么简单。

站点地图对所有语言均保持一致，翻译内容与其所处的子站点一一对应。

## 富文本翻译

一般来讲，富文本内容的多语言翻译很难实现。对一个 Jekyll 网站来说，多语言的短字符串或者某些语言的特定用语很难在显示上保持一致。

*但现在却简单如斯*：只需在你的 `config.yml` 文件中，按照如下方式存储字符串：
{% highlight yaml %}
hello:
  en: Hello!
  es: ¡hola!
  fr: Bonjour!
  de: Guten Tag!
{% endhighlight %}
按照如下方式使用 Liquid 模板内容：
{% highlight html %}
{% raw %}
{{ site.hello[site.active_lang]}}
{% endraw %}
{% endhighlight %}
会生成如下内容：
<p class="message">
{{ site.hello[site.active_lang]}}
</p>

## 快速，异步，零成本构建

  Polyglot 会和构建你的默认语言站点一样构建你的多语言站点。Polyglot 会以最小的成本在各自独立的进程下*同时*构建你的网站的每种语言的子站点。这意味着，你的网站的构建时间不会因为支持语言的数量而增加。

### 下载

  Polyglot 支持 gem 版本，也可以当作 Jekyll 插件使用。可以使用如下代码安装：
  {% highlight bash %}
  gem install 'jekyll-polyglot'
  {% endhighlight %}
