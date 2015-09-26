---
layout: page
title: SEO Recipes
permalink: seo/
lang: en
---
# Recipes for Search Engine Optimization using Polyglot

If you have installed the `jekyll-polyglot` gem, these additions to your site header can easily provide your jekyll blog with Google-powered SEO bonuses.

## HTML Language Declaration

Per [W3C Internationalization Best Practices](http://www.w3.org/International/geo/html-tech/tech-lang.html#ri20060630.133615821)
you can set the default language of every page with a meta tag. Just add the following to your header:
{% raw %}
{% highlight html %}
<meta http-equiv="Content-Language" content="{{site.active_lang}}">
{% endhighlight %}

## Multi-language SEO using hreflang alternate tags

You can easily add [hreflang alternate tags](https://support.google.com/webmasters/answer/189077?hl=en)
to your site, achieving SEO with google multi-language searches. Add the following to your header:
{% highlight html %}
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
{% endhighlight %}
{% endraw %}

With this SEO, each page click for one sites language will count towards the net clicks of all languages on the website.
