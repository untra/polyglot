🔤 Polyglot
---
[![Gem Version](https://badge.fury.io/rb/jekyll-polyglot.svg)](https://badge.fury.io/rb/jekyll-polyglot)
[![CircleCI](https://circleci.com/gh/untra/polyglot/tree/master.svg?style=svg)](https://circleci.com/gh/untra/polyglot/?branch=master)

__Polyglot__ is a fast, painless, open-source internationalization plugin for [Jekyll](http://jekyllrb.com) blogs. Polyglot is easy to setup and use with any Jekyll project, and it scales to the languages you want to support. With fallback support for missing content, automatic url relativization, and powerful SEO tools, Polyglot allows any multi-language jekyll blog to focus on content without the cruft.

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
exclude_from_localization: ["javascript", "images", "css", "public"]
parallel_localization: true
```
These configuration preferences indicate
- what i18n languages you wish to support
- what is your default "fallback" language for your content
- what root level files/folders are excluded from localization, based
  on if their paths start with any of the excluded regexp substrings. (this is different than the jekyll `exclude: [ .gitignore ]` ; you should `exclude` files and directories in your repo you dont want in your built site at all, and `exclude_from_localization` files and directories you want to see in your built site, but not in your sublanguage sites.)
- whether to run language processing in parallel or serial

The optional `lang_from_path: true` option enables getting page
language from the first or second path segment, e.g `de/first-one.md`, or
`_posts/zh_Hans_HK/use-second-segment.md` , if the lang frontmatter isn't defined.

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

No worries. Polyglot ensures the sitemap of your *english* site matches your *french* site, matches your *swedish* and *german* sites too. In this case, because you specified a `default_lang` variable in your `_config.yml`, all sites missing their languages' counterparts will fallback to your `default_lang`, so content is preserved across different languages of your site.

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
Notice the link `<a href="/fr/menu/">...` directs to the french website.

Even if you are falling back to `default_lang` page, relative links built on the *french* site will still link to *french* pages.

#### Relativized Absolute Urls
If you defined a site `url` in your `_config.yaml`, polyglot will automatically relativize absolute links pointing to your website directory:

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

#### Disabling Url Relativizing
_New in 1.4.0_
If you dont want a href attribute to be relativized (such as for making [a language switcher](https://github.com/untra/polyglot/blob/master/site/_includes/sidebar.html#L40)), you can use the block tag:

```html
{% static_href %}href="..."{% endstatic_href %}
```

```html
<a {% static_href %}href="/about"{% endstatic_href %}>click this static link</a>
```

that will generate `<a href="/about">click this static link</a>` which is what you would normally use to create a url unmangled by invisible language relativization.

Combine with a [html minifier](https://github.com/digitalsparky/jekyll-minifier) for a polished and production ready website.

#### Exclusive site language generation
_New in 1.4.0_

If you want to control which languages a document can be generated for, you can specify `lang-exclusive: [ ]` frontmatter.
If you include this frontmatter in your post, it will only generate for the specified site languages.

For Example, the following frontmatter will only generate in the `en` and `fr` site language builds:
```
---
lang-exclusive: ['en', 'fr']
---
```

#### Machine-aware site building
_New in 1.5.0_

Polyglot will only start builds after it confirms there is a cpu core ready to accept the build thread. This ensures that jekyll will build large sites efficiently streamlining build processes instead of overloading machines with process thrash.

#### Localized site.data

There are cases when `site.data` localization is required.
For instance: you might need to localize `_data/navigation.yml` that holds "navigation menu".
In order to localize it, just place language-specific files in `_data/:lang/...` folder, and Polyglot will bring those keys to the top level.

## How It Works
This plugin makes modifications to existing Jekyll classes and modules, namely `Jekyll::StaticFile` and `Jekyll::Site`. These changes are as lightweight and slim as possible. The biggest change is in `Jekyll::Site.process`. Polyglot overwrites this method to instead spawn a separate process for each language you intend to process the site for. Each of those processes calls the original `Jekyll::Site.process` method with its language in mind, ensuring your website scales to support any number of languages, while building all of your site languages simultaneously.

`Jekyll::Site.process` is the entry point for the Jekyll build process. Take care whatever other plugins you use do not also attempt to overwrite this method. You may have problems.

## Features
This plugin stands out from other I18n Jekyll plugins.
- automatically corrects your relative links, keeping your *french* visitors on your *french* website, even when content has to fallback to the `default_lang`.
- builds all versions of your website *simultaneously*, allowing big websites to scale efficiently.
- provides the liquid tag `{{ site.languages }}` to get an array of your I18n strings.
- provides the liquid tag `{{ site.default_lang }}` to get the default_lang I18n string.
- provides the liquid tag `{{ site.active_lang }}` to get the I18n language string the website was built for. Alternative names for `active_lang` can be configured via `config.lang_vars`.
- provides the liquid tag `{{ I18n_Headers https://yourwebsite.com/ }}` to append SEO bonuses to your website.
- provides the liquid tag `{{ Unrelativized_Link href="/hello" }}` to make urls that do not get influenced by url correction regexes.
- provides `site.data` localization for efficient rich text replacement.
- a creator that will answer all of your questions and issues.

## SEO Recipes
Jekyll-polyglot has a few spectacular [Search Engine Optimization techniques](https://untra.github.io/polyglot/seo) to ensure your Jekyll blog gets the most out of it's multilingual audience. Check them out!

### Other Websites Built with Polyglot
Feel free to open a PR and list your multilingual blog here you may want to share:

* [Polyglot project website](https://polyglot.untra.io)
* [LogRhythm Corporate Website](https://logrhythm.com)
* [All Over Earth](https://allover.earth/)
* [Hanare Cafe in Toshijima, Japan](https://hanarecafe.com)
* [F-Droid](https://f-droid.org)
* [Ubuntu MATE](https://ubuntu-mate.org)
* [Leo3418 blog](https://leo3418.github.io/)

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

But for real I would appreciate any contributions and support. This started as an open-source side-project and has gotten bigger than I'd ever imagine!
If you have something you'd like to contribute to jekyll-polyglot, please open a PR!


## 2.0 Roadmap
* [ ] - **site language**: portuguese `pt_BR` `pt_PT`
* [ ] - **site language**: arabic `ar`
* [ ] - **site language**: japanese `ja`
* [x] - **site language**: russian `ru`
* [x] - **site language**: dutch `nl`
* [ ] - **site language**: korean `ko`
* [x] - **site language**: hebrew `he`
* [ ] - get whitelisted as an official github-pages jekyll plugin
* [x] - update CI provider

## Copyright
Copyright (c) Samuel Volin 2022. License: MIT
