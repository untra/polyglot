:abc: Polyglot
---
__Polyglot__ is a fast, painless, open-source internationalization plugin for [Jekyll](http://jekyllrb.com) blogs. Polyglot is easy to setup and use with any Jekyll project, and it scales to the languages you want to support. With fallback support for missing content, automatic url relativization, and powerful SEO recipes, Polyglot allows any multi-language blog to focus on content without the cruft.

## Why?
Jekyll doesn't provide native support for multi-language blogs. This plugin was modeled after the [jekyll-multiple-languages-plugin](https://github.com/screeninteraction/jekyll-multiple-languages-plugin), whose implementation I liked, but execution I didn't.

## Installation
*Jekyll 3.0:* Copy the [polyglot.rb](https://github.com/untra/polyglot/blob/master/lib/polyglot.rb) file into your project's `_plugins` folder.

*Jekyll 2.5.3:* add the following to your gemfile:
```
gem 'jekyll-polyglot'
```

## Configuration
In your `_config.yml` file, add the following preferences
```
languages: ["en", "sv", "de", "fr"]
default_lang: "en"
exclude_from_localization: ["javascript", "images", "css"]
```
These configuration preferences indicate
- what i18n languages you wish to support
- what is your default "fallback" language for your content
- what root level folders are you excluding from localization

## How To Use It
When adding new posts and pages, add to the YAML front matter:
```
lang: sv
```
or whatever appropriate [I18n language code](https://developer.chrome.com/webstore/i18n)
the page should build for. And you're done. Ideally, when designing your site, you should
organize files by their relative urls.

It doesn't matter where you put the files or what you name them. What matters is
that your *english* about page has
```
lang: en
```
in the front matter. When Jekyll builds the site, it will build seperate language versions of
the website using only the files with the correct `lang` variable in the front matter.


#### Fallback Language Support
Lets say you are building your website. You have an `/about/` page written in *english*, *german* and
*swedish*. You are also supporting a *french* website, but you never designed a *french* version of your `/about/` page!

No worries. Polyglot ensures the sitemap of your *english* site matches your *french* site, matches your *swedish* and *german* sites too. In this case, because you specified a `default_lang` variable in your `_config.yml`, all sites missing their languages counterparts will fallback to your default_language, so content is preserved across different languages of your site.

#### Relativized Local Urls
No need to meticulously manage anchor tags to link to your correct language. Polyglot modifies how pages get written to the site so your *french* links keep vistors on your *french* blog.
```md
---
title: au sujet de notre entreprise
permalink: /about/
lang: fr
---
Nous sommes un restaurant situé à Paris . [Ceci est notre menu.](/menu/)
```
becomes
```html
<header class="post-header">
  <h1 class="post-title">au sujet de notre entreprise</h1>
</header>

<article class="post-content">
  <p>Nous sommes un restaurant situé à Paris . <a href="/fr/menu/">Ceci est notre menu.</a></p>
</article>
```
Voila!

Even if you are falling back to `default_lang` page, relative links built on the *french* site will
still link to *french* pages.

## How It Works
This plugin makes modifications to existing Jekyll classes and modules, namely `Jekyll::Convertible`, `Jekyll:StaticFile` and `Jekyll:Site`. These changes are as lightweight and slim as possible.

## Dependencies

This plugin requires gem `'listen', '>= 3.0.0'`. This shouldn't be a problem for most projects.

Jekyll 3.0 already uses `listen (~> 3.0)`, so polyglot users are encouraged to instead use the polyglot.rb file.


## Features
This plugin stands out from other I18n Jekyll plugins.
- automatically corrects your relative links, keeping your *french* vistors on your *french* website, even when content has to fallback to the `default_lang`.
- builds all versions of your website *simultaneously*, allowing websites to scale efficiently.
- provides the liquid tag `{{ site.languages }}` to get an array of your I18n strings.
- provides the liquid tag `{{ site.default_lang }}` to get the default_lang I18n string.
- provides the liquid tag `{{ site.active_lang }}` to get the I18n language string the website was built for.


## SEO Recipes
Per [W3C Internationalization Best Practices](http://www.w3.org/International/geo/html-tech/tech-lang.html#ri20060630.133615821)
you can set the default language of every page with a meta tag.
Add the following to your header:
```html
  <meta http-equiv="Content-Language" content="{{site.active_lang}}">
```

You can easily add [hreflang alternate tags](https://support.google.com/webmasters/answer/189077?hl=en)
to your site, achieving SEO with google multilanguage searches. Add the following to your header:
```html
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
```

## Examples
Check out the example project website [here](https://untra.github.io/polyglot)
(Jekyll resources are on the project's [site](https://github.com/untra/polyglot/tree/site) branch)

### Other Websites Built with Polyglot

* [LogRhythm Corporate Website](http://logrhythm.com)

## Compatibility
Currently supports Jekyll 3.0 .
The gem works just fine with Jekyll version 2.5.3 .

## License
MIT
