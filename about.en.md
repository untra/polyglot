---
layout: page
title: About
permalink: about/
lang: en
---
<p class="message">
  <b>Polyglot</b> is an open source internationalization plugin for <a href="http://jekyllrb.com">Jekyll</a> blogs. Polyglot is easy to setup and use with any project, and it scales to the languages you want to support. With fallback support for missing content, automatic url relativization, and powerful SEO recipes, Polyglot allows any multi-language blog to focus on content without the cruftwork.
</p>


## Recipes for SEO

Per [W3C Internationalization Best Practices](http://www.w3.org/International/geo/html-tech/tech-lang.html#ri20060630.133615821)
you can set the default language of every page with a meta tag. Just add the following to your header:
{% highlight html %}
<meta http-equiv="Content-Language" content="!!LANGUAGE!!">
{% endhighlight %}

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

With this SEO, each page click will count towards the net clicks of all languages on the website.
