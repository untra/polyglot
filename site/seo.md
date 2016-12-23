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

{% highlight html %}{% raw %}
<meta http-equiv="Content-Language" content="{{site.active_lang}}">
{% endraw %}
{% endhighlight %}

## Multi-language SEO using hreflang alternate tags

You can easily add [hreflang alternate tags](https://support.google.com/webmasters/answer/189077?hl=en)
to your site, achieving SEO with google multi-language searches. Add the following to your header:
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

## All of the above

You can get all of the above with a single tag added to your `header.html`:
{% highlight html %}
{% raw %}
{% I18n_Headers https://untra.github.com/polyglot %}
{% endraw %}
{% endhighlight %}

Just add the permanent url for your website and all of the above SEO will be added to each page in your website.
In 1.2.4, you can leave it empty, just calling
{% highlight html %}
{% raw %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}
and it will default to your `site.url`



With this SEO, each page click for one sites language will count towards the net clicks of all languages on the website.
