---
layout: page
title: SEO Recipes
permalink: seo/
lang: en
description: These additions can help improve the SEO of your multi-language jekyll blog when using Polyglot.
---
# Recipes for Search Engine Optimization using Polyglot

If you have installed the `jekyll-polyglot` gem, these additions to your site head can easily provide your jekyll blog with Google-powered SEO bonuses.

## HTML Language Declaration

Per [W3C Internationalization Best Practices](http://www.w3.org/International/geo/html-tech/tech-lang.html#ri20060630.133615821)
you can set the default language of every page with a meta tag. Just add the following to your head:

{% highlight html %}{% raw %}
<meta http-equiv="Content-Language" content="{{site.active_lang}}">
{% endraw %}
{% endhighlight %}

## Multi-language SEO using hreflang alternate tags

You can easily add [hreflang alternate tags](https://developers.google.com/search/docs/specialty/international/localized-versions?hl=en#html)
to your site, achieving SEO with google multi-language searches.

Be sure to include [canonical tags](https://developers.google.com/search/docs/specialty/international/managing-multi-regional-sites?hl=en) when identifying content on similar pages of the same language.

Add the following to your head:
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

## All of the above

You can get all of the above with a single tag added to your `head.html`:
{% highlight html %}
{% raw %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}

With this SEO, each page click for one sites language will count towards the net clicks of all languages on the website.

## Other SEO best practices for polyglot

* always be sure to specify `<meta>` tags for `keywords` and `description` of pages. Search Engines will use these tags to better index pages; for multi-language websites you should supply different values for each sub-language your website supports:

{% highlight html %}
{% raw %}
  <meta name="description" content="{{ page.description | default: site.description[site.active_lang] }}">
  <meta name="keywords" content="{{ page.keywords | default: site.keywords[site.active_lang] }}">
{% endraw %}
{% endhighlight %}