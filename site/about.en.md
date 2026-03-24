---
layout: page
title: About
permalink: about/
lang: en
---
<p class="message">
  <b>Polyglot</b> is an open source internationalization plugin for <a href="http://jekyllrb.com">Jekyll</a> blogs. Polyglot is easy to setup and use with any project, and it scales to the languages you want to support. With fallback support for missing content, automatic url relativization, and <a href="{{site.baseurl}}/seo/">powerful SEO recipes</a>, Polyglot allows any multi-language blog to focus on content without the cruftwork.
</p>

_`jekyll-polyglot` is not yet supported natively in github-actions_

### Install

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### Managing Supported Languages

in `_config.yml`, the following properties manage what languages are supported by your website. You can provide support for a new language by adding it these values (see below). Languages are identified by their official [locale codes](https://developer.chrome.com/webstore/i18n). 
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` an array of locale codes identifying the languages supported by the website.
* `default_lang:` default language for the website.
* `exclude_from_localization:` folders and directories that are part of the built website, but don't need to be localized. This is primarily to cut back on build times, and because asset files like images and fonts are big parts of the website, ensures they are not needlessly "translated" or duplicated in the output.
* `url` the url of your production static website.

### Adding a new language
Assuming you already have a functional single-language website, adding a new language won't be trivial. _To truly make a multilingual website, you should expect to have to remake all of your content in the new language._ This may seem like a big undertaking, but consider the translation in parts. Content is king; it's more important new pages and posts get updated words in translation. Making a multi-language website is only hard if you require that it be perfectly translated from the start.

Firstly, you (and your team, and your managers too if you have a few of those lying around) should discuss and choose what content you need translated over into the new website. You must choose your preferred asic content to translate over. Consider analytics, popular pages and blogposts, and the flow of current and future users to your website. When in doubt, prioritize pages over legacy blogposts. If it means getting to launch a new language sooner, legacy posts may be more effort than they are worth translating.

Secondly, you must (or strongly ought to) provide 100% coverage of rich content through your site. These are small strings embeded in more complex ways. There are multiple ways to iterate over rich content. Remember, you must support all language small strings in your rich content.

#### Multilingual Content
Website Content comes in two flavors: **basic** and **rich**. 

Basic content is the flat text of blogposts, pages, and non-interactive content. Think pages and posts. Basic content is the fuel for your websites clicks. Polyglot gives basic content fallback support.

Rich content is interactive, flashy, and composed of shorter strings. Think navbars and dropdowns. Rich content is more technical, and keeps your visitors on the site. _There is no fallback support for missing rich content._

#### Liquid Tools
The following liquid tools are available for use with jekyll-polyglot:

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages` points directly to the `languages` array in _config.yml . It can be accessed through liquid.

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang` points directly to the `default_lang` string in _config.yml . It can be accessed through liquid.

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}

`site.active_lang` is the locale code the page is being built for. This is `"de"` for the german version of a page, `"es"` for the spanish version, and so on. It can be accessed through liquid.

Using these tools, you can specify how to attach the correct rich content.

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

The `page.rendered_lang` variable that indicates the actual language of a page's content, Allowing templates to detect when a page is being served as fallback content.

### Github Pages Support
By default github prevents [jekyll blogs from using plugins](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides). This is done intentionally to prevent malicious code from being executed on github servers. Although this makes using Polyglot (and other jekyll plugins) harder to use, it's still doable.

#### Building `_site/` to gh-pages
Instead of hosting your Jekyll blogging engine on github, you can develop your jekyll website on a separate branch, and then push the built `_site/` contents to your `gh-pages` branch. This allows you to manage and source-control your website development with github *without having to rely on github to build your website!*

You can do this by maintaining your Jekyll content on a separate branch, and only committing the `_site/` folder to your gh-pages branch. Because these are just static html pages in folders, github will host them like any other [gh-pages](https://pages.github.com/) content.

#### Automate it!

This process is helped tremendously with a simple script that will build your website and commit the `_site/` folder to your gh-pages. A lot of people have one. [Here's one](http://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/). [Here's another](https://gist.github.com/cobyism/4730490). Here is [my publish script](https://github.com/untra/polyglot/blob/main/publi.sh):

```bash
#! /bin/sh
# change the branch names appropriately
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
