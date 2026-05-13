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

Per the [WHATWG HTML Living Standard](https://html.spec.whatwg.org/multipage/dom.html#the-lang-and-xml:lang-attributes), you should declare the page language using the `lang` attribute on the root HTML element. Add this to your layout:

{% highlight html %}{% raw %}
<html lang="{{ site.active_lang }}">
{% endraw %}
{% endhighlight %}

This enables browsers, search engines, and assistive technologies (screen readers, translation tools) to correctly process your content.

## Multi-language SEO using hreflang alternate tags

You can easily add `hreflang="{{site.active_lang}}"` [alternate tags](https://developers.google.com/search/docs/specialty/international/localized-versions?hl=en#html) to your site, achieving SEO with google multi-language searches. Fallback to the default language version of your site when the browser uses an unmatched language with `hreflang="x-default"`

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

## All of the above (hreflang and canonical)

You can get the canonical link, alternate hreflang links, and x-default fallback with a single tag added to your `head.html`:
{% highlight html %}
{% raw %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}

Note: You should still add `<html lang="{{ site.active_lang }}">` to your layout's root element separately, as described above.

With this SEO, each page click for one site's language will count towards the net clicks of all languages on the website.

## Using polyglot with jekyll-seo-tag

[jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) is a another jekyll plugin that emits `<title>`, `<meta>` tags for SEO. Polyglot's `{% raw %}{% I18n_Headers %}{% endraw %}` is designed to live alongside it: let jekyll-seo-tag handle everything except the canonical URL, and let polyglot handle the canonical and hreflang alternates (which it can do correctly across languages):

{% highlight liquid %}
{% raw %}
{% seo canonical=false %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}

The `canonical=false` option requires jekyll-seo-tag v2.9.0 or later.

### Fallback canonical for untranslated pages

By default, a page that has no translation in the active language still gets a canonical pointing at its translated URL. For better SEO, you can have fallback pages point their canonical URL at the default language version instead. Add to your `_config.yml`:

{% highlight yaml %}
fallback_canonical_to_default_lang: true
{% endhighlight %}

With this enabled:

- Pages with a real translation: canonical points to the translated URL (e.g. `/es/sobre-nosotros/`).
- Fallback pages (no translation): canonical points to the default language URL (e.g. `/about/` instead of `/es/about/`).

This consolidates SEO authority on the original content and prevents search engines from indexing duplicate fallback pages across languages.

## Using polyglot with jekyll-redirect-from

The [jekyll-redirect-from](https://github.com/jekyll/jekyll-redirect-from) plugin lets pages declare old URLs they should redirect from. Polyglot integrates with it in two ways:

**Automatic cross-language redirects via `page_id`.** When two pages share a `page_id` but have different permalinks, polyglot will automatically add the other-language permalinks to the page's `redirect_from`. No manual configuration needed — just make sure both pages have the same `page_id` in their front matter.

**Language-scoped `redirect_from`.** When a page in a non-default language declares its own `redirect_from`, polyglot automatically prefixes the paths with the page's language code, so `/old-path` becomes `/fr/old-path` on a French page. Paths that already start with the language code are left alone.

Include a customized [redirect.html layout](https://github.com/untra/polyglot/blob/main/site/_layouts/redirect.html) with the site.

## Localizing Netlify _redirects

_New in 1.13.0._

When you deploy to [Netlify](https://www.netlify.com/) with a [`_redirects` file](https://docs.netlify.com/manage/routing/redirects/overview/#syntax-for-the-_redirects-file), Polyglot can automatically generate language-prefixed copies of each rule so they work on all of your localized URLs.

Enable it in `_config.yml`:

{% highlight yaml %}
localize_redirects: true
exclude_from_redirect_localization:
  - /signin
  - /app
{% endhighlight %}

With this, a single rule like:

{% highlight text %}
/github  https://github.com/org/repo  302
{% endhighlight %}

is expanded into language-prefixed copies for each configured language:

{% highlight text %}
/github     https://github.com/org/repo  302
/fr/github  https://github.com/org/repo  302
/de/github  https://github.com/org/repo  302
/sv/github  https://github.com/org/repo  302
{% endhighlight %}

External destination URLs are preserved as-is. Paths listed under `exclude_from_redirect_localization` are not localized, which is useful for authentication endpoints or single-page-app routes that should only exist at the root.