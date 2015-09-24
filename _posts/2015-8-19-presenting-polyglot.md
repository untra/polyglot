---
layout: post
title: Presenting Polyglot
---

After months of work and refinement, I am proud to present Polyglot: a i18n plugin for [Jekyll](http://jekyllrb.com) sites that *need* to cater their content to multiple languages and audiences.

### Features

While there are other multi-language plugins for Jekyll, Polyglot is special. Polyglot takes care of the typical cruftwork normally left to developers to manage (such as wrangling urls and ensuring consistent sitemaps) while providing efficient and simple tools Jekyll developers can utilize into SEO and fast-tracked content aggregation.

## Relativized Links

In the past, a multi-language static site or blog had to keep delicate track of what language each relative link the site was serving. It was all too easy for a developer to stumble, and foreign language visitors would quickly get lost in untranslated content.

Polyglot automatically relativizes the urls for each language you want your site to build for. This way your french website stays isolated from your english one (as long your french website stays french)

## Fallback Support

When you *don't* have translated or multilingual content, the site will still build with the content you do have. When you *do* have translated or multilingual content, the site will build using that content. Simple as that.

Sitemaps stay consistent across all languages, and translated stays in the site it was built for.

## Rich Content Translation

Rich language content is normally hard to wrangle. Short strings or language dependent banners are typically hard for a Jekyll website to keep consistent.

Except when it's this easy:
{% raw %}
{% site.active_lang%}
{% endraw %}

## Recipes for SEO

per [W3C Internationalization Best Practices](http://www.w3.org/International/geo/html-tech/tech-lang.html#ri20060630.133615821)
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

## Fast

  Polyglot will build you multi-language website just as fast as it will build your default language website. Polyglot runs with a minimal overhead by *simultaneously* building all languages of your website at the same time. This means your website build time won't be a function of how many languages you need to support.

### Download
