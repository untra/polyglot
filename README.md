:abc: Polyglot
---
version 1.1.2

__Polyglot__ is a fast, painless, open-source internationalization plugin for [Jekyll](http://jekyllrb.com) blogs. Polyglot is easy to setup and use with any Jekyll project, and it scales to the languages you want to support. With fallback support for missing content, automatic url relativization, and powerful SEO recipes, Polyglot allows any multi-language blog to focus on content without the cruft.

## Why?
Jekyll doesn't provide native support for multi-language blogs. This plugin was modeled after the [jekyll-multiple-languages-plugin](https://github.com/screeninteraction/jekyll-multiple-languages-plugin), whose implementation I liked, but execution I didn't.

## Installation
*Jekyll 3.0:*
```
gem 'jekyll-polyglot', '~> 1.1.2'
```
You can also just copy the [polyglot.rb](https://github.com/untra/polyglot/blob/master/lib/polyglot.rb) file into your project's `_plugins` folder.

*Jekyll 2.5.3:* add the following to your gemfile:
```
gem 'jekyll-polyglot', '~> 1.0.1'
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

Polyglot works by associating documents with similar permalinks to the `lang` specified in their frontmatter. Files that correspond to similar routes should have identical permalinks. If you don't provide a permalink for a post, ___make sure you are consistent___ with how you place and name corresponding files:
```
_posts/2010-03-01-salad-recipes-en.md
_posts/2010-03-01-salad-recipes-sv.md
_posts/2010-03-01-salad-recipes-fr.md
```

Organized names will generate consistent permalinks when the post is rendered, and polyglot will know to build seperate language versions of
the website using only the files with the correct `lang` variable in the front matter.

In short:
* Be consistent with how you name and place your *posts* files
* Always give your *pages* permalinks in the frontmatter
* Don't overthink it, :wink:


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
This plugin makes modifications to existing Jekyll classes and modules, namely `Jekyll::Convertible`, `Jekyll::StaticFile` and `Jekyll::Site`. These changes are as lightweight and slim as possible. The biggest change is in `Jekyll::Site.process`. Polyglot overwrites this method to instead spawn a seperate thread for each language you intend to process the site for. Each of those threads calls the original `Jekyll::Site.process` method with it's language in mind, ensuring your website scales to support any number of languages, while building all of your site languages simultaneously.

`Jekyll::Site.process` is the entrypoint for the Jekyll build process. Take care whatever other plugins you use do not also attempt to overwrite this method. You will have problems.

## Dependencies

*Jekyll 2.5.3:* This plugin requires gem `'listen', '>= 3.0.0'`. This shouldn't be a problem for most projects.

*Jekyll 3.0:* No dependencies needed, as Jekyll 3.0 already uses `listen (~> 3.0)`.

## Features
This plugin stands out from other I18n Jekyll plugins.
- automatically corrects your relative links, keeping your *french* vistors on your *french* website, even when content has to fallback to the `default_lang`.
- builds all versions of your website *simultaneously*, allowing big websites to scale efficiently.
- provides the liquid tag `{{ site.languages }}` to get an array of your I18n strings.
- provides the liquid tag `{{ site.default_lang }}` to get the default_lang I18n string.
- provides the liquid tag `{{ site.active_lang }}` to get the I18n language string the website was built for.
- A creator that will answer all of your questions and issues.


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
The gem v1.0.1 works just fine with Jekyll version 2.5.3 .

Windows users will need to disable parallel_localization on their machines by setting `parallel_localization: false` in the `_config.yml`

## Copyright
Copyright (c) Samuel Volin 2015. License: MIT
