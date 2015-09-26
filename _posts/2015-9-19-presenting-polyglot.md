---
layout: post
title: Presenting Polyglot
lang: en
---

After months of work and refinement, I am proud to present **Polyglot**: a i18n plugin for [Jekyll](http://jekyllrb.com) sites that *need* to cater their content to multiple languages and audiences.

### Features

While there are other multi-language plugins for Jekyll, Polyglot is special. Polyglot takes care of the typical cruftwork normally left to developers to manage (such as wrangling urls and ensuring consistent sitemaps) while providing efficient and simple tools Jekyll developers can utilize into SEO and fast-tracked content aggregation.

## Relativized Links

In the past, a multi-language static site or blog had to keep delicate track of what language each relative link the site was serving. It was all too easy for a developer to stumble, and foreign language visitors would quickly get lost in untranslated content.

Polyglot automatically relativizes the urls for each language you want your site to build for. This allows website visitors to stay isolated on one language while browsing your website.

## Fallback Support

When you *don't* have translated or multilingual content, Jekyll will still build with the content you do have. When you *do* have translated or multilingual content, Jekyll will build using that content. Simple as that.

Sitemaps stay consistent across all languages, and translated stays in the site it was built for.

## Rich Content Translation

Rich language content is normally hard to implement. Short strings or language dependent banners are typically hard for a Jekyll website to keep consistent.

*Except when it's this easy*. In your config.yml, just store your strings as:
{% highlight yaml %}
hello:
  en: Hello!
  es: ¡hola!
  fr: Bonjour!
  de: Guten Tag!
{% endhighlight %}
and in your liquid, just call:
{% highlight html %}
{% raw %}
{{ site.hello[site.active_lang]}}
{% endraw %}
{% endhighlight %}
produces:
<p class="message">
{{ site.hello[site.active_lang]}}
</p>

## Fast, Asynchronous, Zero-Overhead Builds

  Polyglot will build your multi-language website just as fast as it will build your default language website. Polyglot runs with a minimal overhead by *simultaneously* building all languages of your website as separate process. This means your website build time won't be a function of how many languages you need to support.

### Download

  Polyglot is available as a gem, or as a Jekyll plugin. It can be installed with:
  {% highlight bash %}
  gem install 'jekyll-polyglot'
  {% endhighlight %}
