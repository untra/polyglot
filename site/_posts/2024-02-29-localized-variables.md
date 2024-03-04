---
layout: post
title: Localized variables
lang: en
---

Polyglot allows you to have different pages for different languages in your Jekyll site. For example, one could have a page `about.md` in English and another `about.md` in Spanish with completely different layouts. But if you want to have the same layout for both pages, you can use localized variables. This is a way to have different data for different languages in your Jekyll site, but using the same layout for all languages.

As an example I will use a [template site](https://github.com/george-gca/multi-language-al-folio) created with Polyglot.

## Sharing a layout between pages

In that site they have an about page for every language, in their case english in [\_pages/en-us/about.md](https://github.com/george-gca/multi-language-al-folio/blob/main/_pages/en-us/about.md) and brazilian portuguese in [\_pages/pt-br/about.md](https://github.com/george-gca/multi-language-al-folio/blob/main/_pages/pt-br/about.md). In both pages we can see that they have the same keys in the frontmatter, but some with different values. Both files point to the same [layout](https://jekyllrb.com/docs/layouts/), [about](https://github.com/george-gca/multi-language-al-folio/blob/main/_layouts/about.liquid), and this layout uses the values in the frontmatter to render the page.

For example, the `subtitle` key in the english page has the value `subtitle: <a href='#'>Affiliations</a>. Address. Contacts. Moto. Etc.` and in the brazilian portuguese page it has `subtitle: <a href='#'>Afiliações</a>. Endereço. Contatos. Lema. Etc.`. To use this information in the layout, it is used like this:

{% raw %}
```liquid
{{ page.subtitle }}
```
{% endraw %}

The same goes for the content below the frontmatter in both files, which is simply used in the layout like this:

{% raw %}
```liquid
{{ content }}
```
{% endraw %}

Polyglot will automatically render the page with the correct values for the current language.

## Sharing a layout between pages with localized data

For the `subtitle` of the page they used `key: value` pairs in the frontmatter, but sometimes we want to use these same pairs in different parts of the site. For example, if we want to use the same `subtitle` in the `about.md` and in another page, we would have to repeat the same pair in the frontmatter of both pages. This is not ideal because if we want to change the `subtitle` we would have to change it in two places. This is where localized data comes in. You can create a file like `_data/:lang/strings.yml`, one for each language, and Polyglot will bring those keys under `site.data[:lang].strings`.

For example, in the template site there are two files, [\_data/en-us/strings.yml](https://github.com/george-gca/multi-language-al-folio/blob/main/_data/en-us/strings.yml) and [\_data/pt-br/strings.yml](https://github.com/george-gca/multi-language-al-folio/blob/main/_data/pt-br/strings.yml). In the first file they have:

```yaml
latest_posts: latest posts
```

And in the second file they have:

```yaml
latest_posts: últimas postagens
```

This way, they can use the `latest_posts` key in the layout like this:

{% raw %}
```liquid
{{ site.data[site.active_lang].strings.latest_posts }}
```
{% endraw %}

Which will correctly get the value for the `latest_posts` variable defined in the file `_data/:lang/strings.yml` for the current language.

## Defining which variable to use in the frontmatter

Now if you want to define this variable in the frontmatter of the page, this gets a little bit trickier. One possible solution is to check if the value of the variable has a `.` in it, and if it does use the value in the file `_data/:lang/strings.yml`. This is how you would do it:

{% raw %}
```liquid
{% if frontmatter_var contains '.' %}
  {% assign first_part = frontmatter_var | split: '.' | first %}
  {% assign last_part = frontmatter_var | split: '.' | last %}
  {% capture result %}{{ site.data[site.active_lang].strings[first_part][last_part] }}{% endcapture %}
{% endif %}

{{ result }}
```
{% endraw %}

This will work, for example, if `frontmatter_var = blog.title`.

Now, if you need to check if the localization string (in this case `blog.title`) actually exists in the file `_data/:lang/strings.yml` before using it, you'll have to create a plugin to check if the variable exists in the file `_data/:lang/strings.yml` and if it does, use it, otherwise fallback to any value you want. I will not go into detail on how to do this, but I will show you how to use it. You can see the code for the plugin [here](https://github.com/george-gca/multi-language-al-folio/blob/main/_plugins/localization-exists.rb).

{% raw %}
```liquid
{% if frontmatter_var contains '.' %}
  {% capture contains_localization %}{% localization_exists {{ frontmatter_var }} %}{% endcapture %}
  {% if contains_localization == 'true' %}
    {% assign first_part = frontmatter_var | split: '.' | first %}
    {% assign last_part = frontmatter_var | split: '.' | last %}
    {% capture result %}{{ site.data[site.active_lang].strings[first_part][last_part] }}{% endcapture %}
  {% else %}
    {% capture result %}fallback value{% endcapture %}
  {% endif %}
{% endif %}

{{ result }}
```
{% endraw %}