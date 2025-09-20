🔤 Polyglot
---
[![Gem Version](https://badge.fury.io/rb/jekyll-polyglot.svg)](https://badge.fury.io/rb/jekyll-polyglot)
[![CircleCI](https://circleci.com/gh/untra/polyglot/tree/main.svg?style=svg)](https://circleci.com/gh/untra/polyglot/?branch=main)
[![codecov](https://codecov.io/gh/untra/polyglot/graph/badge.svg?token=AAIYBIxdWr)](https://codecov.io/gh/untra/polyglot)

__Polyglot__ is a fast, painless, open-source internationalization plugin for [Jekyll](http://jekyllrb.com) blogs. Polyglot is easy to set up and use with any Jekyll project, and it scales to the languages you want to support. With fallback support for missing content, automatic url relativization, and powerful SEO tools, Polyglot allows any multi-language jekyll blog to focus on content without the cruft.

## Why?
Jekyll doesn't provide native support for multi-language blogs. This plugin was modeled after the [jekyll-multiple-languages-plugin](https://github.com/screeninteraction/jekyll-multiple-languages-plugin), whose implementation I liked, but execution I didn't.

## Installation
Add jekyll-polyglot to your `Gemfile` if you are using Bundler:
```Ruby
group :jekyll_plugins do
   gem "jekyll-polyglot"
end
```

Or install the gem manually by doing `gem install jekyll-polyglot` and specify the plugin using `_config.yml`:
```YAML
plugins:
  - jekyll-polyglot
```

## Configuration
In your `_config.yml` file, add the following preferences
```YAML
languages: ["en", "sv", "de", "fr"]
default_lang: "en"
exclude_from_localization: ["javascript", "images", "css", "public", "sitemap"]
parallel_localization: true
url: https://polyglot.untra.io
```
These configuration preferences indicate
- what i18n languages you wish to support
- what is your default "fallback" language for your content
- what root level files/folders are excluded from localization, based on if their paths start with any of the excluded regexp substrings. (this is different from the jekyll `exclude: [ .gitignore ]` ; you should `exclude` files and directories in your repo you dont want in your built site at all, and `exclude_from_localization` files and directories you want to see in your built site, but not in your sublanguage sites.)
- whether to run language processing in parallel or serial. Set to `false` if building on Windows hosts, or if Polyglot collides with other Jekyll plugins.
- your jekyll website production url. Make sure this value is set; Polyglot requires this to relative site urls correctly, and to make functioning language switchers.

The optional `lang_from_path: true` option enables getting the page language from a filepath segment seperated by `/` or `.`, e.g `de/first-one.md`, or `_posts/zh_HK/use-second-segment.md` , if the lang frontmatter isn't defined.

## How To Use It
When adding new posts and pages, add to the YAML front matter:
```
lang: sv
```
or whatever appropriate [I18n language code](https://developer.chrome.com/docs/extensions/reference/api/i18n#locales)
the page should build for. And you're done. Ideally, when designing your site, you should
organize files by their relative urls.

You can see how the live Polyglot website [configures and supports multiple languages](https://github.com/untra/polyglot/blob/main/site/_config.yml#L28-L37), and examples of [community](https://github.com/untra/polyglot/pull/155) [language](https://github.com/untra/polyglot/pull/167) [contributions](https://github.com/untra/polyglot/pull/177).

Polyglot works by associating documents with similar permalinks to the `lang` specified in their frontmatter. Files that correspond to similar routes should have identical permalinks. If you don't provide a permalink for a post, ___make sure you are consistent___ with how you place and name corresponding files:
```
_posts/2010-03-01-salad-recipes-en.md
_posts/2010-03-01-salad-recipes-sv.md
_posts/2010-03-01-salad-recipes-fr.md
```

Organized names will generate consistent permalinks when the post is rendered, and Polyglot will know to build separate language versions of
the website using only the files with the correct `lang` variable in the front matter.

In short:
* Be consistent with how you name and place your *posts* files
* Always give your *pages* permalinks in the frontmatter
* Don't overthink it, :wink:


### Translation permalink information in page
_New in 1.8.0_

Whenever `page_id` frontmatter properties are used to identify translations, permalink information for the available languages is available in `permalink_lang`.
This is useful in order to generate language menus and even localization meta information without redirects!

Sample code for meta link generation:
```
{% for lang in site.languages %}
  {% capture lang_href %}{{site.baseurl}}/{% if lang != site.default_lang %}{{ lang }}/{% endif %}{% if page.permalink_lang[lang] != '/' %}{{page.permalink_lang[lang]}}{% endif %}{% endcapture %}
  <link rel="alternate" hreflang="{{ lang }}" {% static_href %}href="{{ lang_href }}"{% endstatic_href %} />
{% endfor %}
```


#### Using different permalinks per language
_New in 1.7.0_

Optionally, for those who may want different URLs on different languages, translations may be identified by specifying a `page_id` in the frontmatter.

If available, Polyglot will use `page_id` to identify the page, and will default to the `permalink` otherwise.

As an example, you may have an about page located in `/about/` while being in `/acerca-de/` in Spanish just by changing the permalink and specifying a `page_id` that will link the files as translations:
```md
---
title: About
permalink: /about
lang: en
page_id: about
---
This is us!
```

```md
---
title: Acerca de
permalink: /acerca-de
lang: es
page_id: about
---
Estos somos nosotros!
```

Additionally, if you are also using the `jekyll-redirect-from` plugin, pages coordinated this way will automatically have redirects created between pages.
So `/es/about` will automatically redirect to `/es/acerca-de` and `/acerca-de` can redirect to `/about`. If you use this approach, be sure to also employ a customized [redirect.html](https://github.com/untra/polyglot/blob/main/site/_layouts/redirect.html).

#### Fallback Language Support
Lets say you are building your website. You have an `/about/` page written in *english*, *german* and
*swedish*. You are also supporting a *french* website, but you never designed a *french* version of your `/about/` page!

No worries. Polyglot ensures the sitemap of your *english* site matches your *french* site, matches your *swedish* and *german* sites too. In this case, because you specified a `default_lang` variable in your `_config.yml`, all sites missing their languages' counterparts will fallback to your `default_lang`, so content is preserved across different languages of your site.

### Relativized Local Urls
No need to meticulously manage anchor tags to link to your correct language. Polyglot modifies how pages get written to the site so your *french* links keep visitors on your *french* blog.
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
Notice the link `<a href="/fr/menu/">...` directs to the french website.

Even if you are falling back to `default_lang` page, relative links built on the *french* site will still link to *french* pages.

### Relativized Absolute Urls
If you defined a site `url` in your `_config.yaml`, Polyglot will automatically relativize absolute links pointing to your website directory:

```md
---
lang: fr
---
Cliquez [ici]({{site.url}}) pour aller à l'entrée du site.
```
becomes
```html
<p>Cliquez <a href="https://mywebsite.com/fr/">ici</a> pour aller à l'entrée du site.
```

### Disabling Url Relativizing
_New in 1.4.0_
If you dont want a href attribute to be relativized (such as for making [a language switcher](https://github.com/untra/polyglot/blob/main/site/_includes/sidebar.html#L40)), you can use the block tag:

```html
{% static_href %}href="..."{% endstatic_href %}
```

```html
<a {% static_href %}href="/about"{% endstatic_href %}>click this static link</a>
```

that will generate `<a href="/about">click this static link</a>` which is what you would normally use to create a url unmangled by invisible language relativization.

Combine with a [html minifier](https://github.com/digitalsparky/jekyll-minifier) for a polished and production ready website.

### Exclusive site language generation
_New in 1.4.0_

If you want to control which languages a document can be generated for, you can specify `lang-exclusive: [ ]` frontmatter. If you include this frontmatter in your post, it will only generate for the specified site languages.

For Example, the following frontmatter will only generate in the `en` and `fr` site language builds:
```
---
lang-exclusive: ['en', 'fr']
---
```

### Localized site.data
There are cases where you may want to have a list of `key: value` pairs of translated content. For example, instead of creating a complete separate file for each language containing the layout structure and localized content, you can create a single file with the layout that will be shared among pages, and then create a language-specific file with the localized content that will be used.

To do this, you can create a file like `_data/:lang/strings.yml`, one for each language, and Polyglot will bring those keys under `site.data[:lang].strings`. For example, suppose you have the following files:

`_data/en/strings.yml`
```yaml
hello: "Hello"
greetings:
  morning: "Good morning"
  evening: "Good evening"
```

`_data/pt-br/strings.yml`
```yaml
hello: "Olá"
greetings:
  morning: "Bom dia"
  evening: "Boa noite"
```

You can use the `site.data` to access the localized content in your layouts and pages:

```liquid
<p>{{ site.data[site.active_lang].strings.hello }}, {{ site.data[site.active_lang].strings.greetings.morning }}</p>
```

For more information on this matter, check out this [post](https://polyglot.untra.io/2024/02/29/localized-variables/).

### Localized collections

To localize collections, you first have to properly define the collection in your `_config.yml` file. For example, if you have a collection of `projects`, you can define it like this:

```yaml
collections:
  projects:
    output: true
    permalink: /:collection/:title/
```

Note that the [permalink](https://jekyllrb.com/docs/permalinks/#collections) definition here is important. Then, you can create a file for each language in the `_projects` directory, and Polyglot will bring those files under `site.projects`. For more information, check the related discussion #188.

## How It Works
This plugin makes modifications to existing Jekyll classes and modules, namely `Jekyll::StaticFile` and `Jekyll::Site`. These changes are as lightweight and slim as possible. The biggest change is in `Jekyll::Site.process`. Polyglot overwrites this method to instead spawn a separate process for each language you intend to process the site for. Each of those processes calls the original `Jekyll::Site.process` method with its language in mind, ensuring your website scales to support any number of languages, while building all of your site languages simultaneously.

`Jekyll::Site.process` is the entry point for the Jekyll build process. Take care whatever other plugins you use do not also attempt to overwrite this method. You may have problems.

### (:polyglot, :post_write) hook
_New in 1.8.0_
Polyglot issues a `:polyglot, :post_write` hook event once all languages have been built for the site. This hook runs exactly once, after all site languages been processed:

```rb
Jekyll::Hooks.register :polyglot, :post_write do |site|
  # do something custom and cool here!
end
```

### Machine-aware site building
_New in 1.5.0_

Polyglot will only start builds after it confirms there is a cpu core ready to accept the build thread. This ensures that jekyll will build large sites efficiently, streamlining build processes instead of overloading machines with process thrash.

### Writing Tests and Debugging
_:wave: I need assistance with modern ruby best practices for test maintenance with rake and rspec. If you got the advice I have the ears._

Tests are run with `test.sh`. Tests are in the `/spec` directory, and test failure output detail can be examined in the `rspec.json` file. Code Coverage details are in the the `coverage` directory.

## Features
This plugin stands out from other I18n Jekyll plugins.
- automatically corrects your relative links, keeping your *french* visitors on your *french* website, even when content has to fallback to the `default_lang`.
- builds all versions of your website *simultaneously*, allowing big websites to scale efficiently.
- provides the liquid tag `{{ site.languages }}` to get an array of your I18n strings.
- provides the liquid tag `{{ site.default_lang }}` to get the default_lang I18n string.
- provides the liquid tag `{{ site.active_lang }}` to get the I18n language string the website was built for. Alternative names for `active_lang` can be configured via `config.lang_vars`.
- provides the liquid tag `{{ I18n_Headers }}` to append SEO bonuses to your website.
- provides the liquid tag `{{ Unrelativized_Link href="/hello" }}` to make urls that do not get influenced by url correction regexes.
- provides `site.data` localization for efficient rich text replacement.
- a creator that will answer all of your questions and issues.

## SEO Recipes
Jekyll-polyglot has a few spectacular [Search Engine Optimization techniques](https://untra.github.io/polyglot/seo) to ensure your Jekyll blog gets the most out of its multilingual audience. Check them out!

### Sitemap generation

See the example [sitemap.xml](/site/sitemap.xml) and [robots.txt](/site/robots.txt) for how to automatically generate a multi-language sitemap for your page and turn it in for the SEO i18n credit.

The [official Sitemap protocol documentation](https://www.sitemaps.org/protocol.html#location) states:
> "The location of a Sitemap file determines the set of URLs that can be included in that Sitemap. A Sitemap file located at http://example.com/catalog/sitemap.xml can include any URLs starting with http://example.com/catalog/ but can not include URLs starting with http://example.com/images/."

> "It is strongly recommended that you place your Sitemap at the root directory of your web server."

To comply with this, 'sitemap.xml' should be added to the 'exclude_from_localization' list to ensure that only one `sitemap.xml` file exists in the root directory, rather than creating separate ones for each language.

## Compatibility
Currently supports Jekyll 3.0 , and Jekyll 4.0
* Windows users will need to disable parallel_localization on their machines by setting `parallel_localization: false` in the `_config.yml`
* In Jekyll 4.0 , SCSS source maps will generate improperly due to how Polyglot operates. The workaround is to disable the CSS sourcemaps. Adding the following to your `config.yml` will disable sourcemap generation:
```yaml
sass:
    sourcemap: never
```

## Contributions
Please! I need all the support I can get! 🙏

But for real I would appreciate any code contributions and support. This started as an open-source side-project and has gotten bigger than I'd ever imagine!
If you have something you'd like to contribute to jekyll-polyglot, please open a PR!

### Contributors
These are talented and considerate software developers across the world that have lent their support to this project.
**Thank You! ¡Gracias! Merci! Danke! 감사합니다! תודה רבה! Спасибо! Dankjewel! 谢谢！Obrigado!**

* [@yunseo-kim](https://github.com/yunseo-kim) [improved i18n sitemaps]((https://polyglot.untra.io/2025/01/18/polyglot-1.9.0/))
* [@blackpill](https://github.com/blackpill) [1.8.1](https://polyglot.untra.io/2024/08/18/polyglot-1.8.1/)
* [@hacketiwack](https://github.com/hacketiwack) [1.8.1](https://polyglot.untra.io/2024/08/18/polyglot-1.8.1/)
* [@jerturowetz](https://github.com/jerturowetz) [sitemap generation](https://polyglot.untra.io/2024/03/17/polyglot-1.8.0/)
* [@antoniovazquezblanco](https://github.com/antoniovazquezblanco) [1.7.0](https://polyglot.untra.io/2023/10/29/polyglot-1.7.0/)
* [@salinatedcoffee](https://github.com/SalinatedCoffee) [ko support](https://polyglot.untra.io/ko/2023/02/27/korean-support/)
* [@aturret](https://github.com/aturret) [zh-CN support](https://polyglot.untra.io/zh-CN/2023/06/08/polyglot-1.6.0-chinese-support/)
* [@dougieh](https://github.com/dougieh) [1.5.1](https://polyglot.untra.io/2022/10/01/polyglot-1.5.1/)
* [@pandermusubi](https://github.com/PanderMusubi) [nl support](https://polyglot.untra.io/nl/2022/01/15/dutch-site-support/)
* [@obfusk](https://github.com/obfusk) [1.5.0](https://polyglot.untra.io/2021/07/17/polyglot-1.5.0/)
* [@eighthave](https://github.com/eighthave) [1.5.0](https://polyglot.untra.io/2021/07/17/polyglot-1.5.0/)
* [@george-gca](https://github.com/george-gca) [pt-BR support](https://polyglot.untra.io/pt-BR/2024/02/29/localized-variables.md)

### Other Websites Built with Polyglot
Feel free to open a PR and list your multilingual blog here you may want to share:

* [**Polyglot project website**](https://polyglot.untra.io)
* [LogRhythm Corporate Website](https://logrhythm.com)
* [All Over Earth](https://allover.earth/)
* [Hanare Cafe in Toshijima, Japan](https://hanarecafe.com)
* [F-Droid](https://f-droid.org)
* [Ubuntu MATE](https://ubuntu-mate.org)
* [Leo3418 blog](https://leo3418.github.io/)
* [Gaphor](https://gaphor.org)
* [Yi Yunseok's personal blog website](https://Yi-Yunseok.GitHub.io)
* [Tarlogic Cybersecurity](https://www.tarlogic.com/)
* [A beautiful, simple, clean, and responsive Jekyll theme for academics](https://github.com/george-gca/multi-language-al-folio)
* [AnotherTurret just another study note blog](https://aturret.space/)
* [Diciotech is a collaborative online tech dictionary](https://diciotech.netlify.app/)
* [Yunseo Kim's Study Notes](https://www.yunseo.kim/)

## 2.0 Roadmap
* [x] - **site language**: portuguese Brazil `pt-BR`
* [x] - **site language**: arabic `ar`
* [x] - **site language**: japanese `ja`
* [x] - **site language**: russian `ru`
* [x] - **site language**: dutch `nl`
* [x] - **site language**: korean `ko`
* [x] - **site language**: hebrew `he`
* [x] - **site language**: chinese China `zh-CN`
* [ ] - **site language**: chinese Taiwan `zh-TW`
* [ ] - **site language**: portuguese Portugal `pt-PT`
* [ ] - get whitelisted as an official github-pages jekyll plugin
* [x] - update CI provider

## Copyright
Copyright (c) Samuel Volin 2025. License: MIT
