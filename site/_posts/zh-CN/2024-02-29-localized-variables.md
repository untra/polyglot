---
layout: post
title: 本地化变量
lang: zh-CN
---

Polyglot 允许您在 Jekyll 站点中为不同语言拥有不同的页面。例如，一个人可以在英语中有一个 `about.md` 页面，在西班牙语中有另一个 `about.md` 页面，它们具有完全不同的布局。但是，如果您希望为这两个页面使用相同的布局，您可以使用本地化变量。这是一种在 Jekyll 站点中为不同语言拥有不同数据的方法，但对所有语言使用相同的布局。

下面我将使用一个使用 Polyglot 创建的[模板站点](https://github.com/george-gca/multi-language-al-folio) 作为示例。

## 在页面之间共享布局

在这个网站中，他们为每种语言的每个页面都有一个关于页面。其中，英语版本在 [\_pages/en-us/about.md](https://github.com/george-gca/multi-language-al-folio/blob/main/_pages/en-us/about.md)，而巴西葡萄牙语版本在 [\_pages/pt-br/about.md](https://github.com/george-gca/multi-language-al-folio/blob/main/_pages/pt-br/about.md) 中。在这两个页面中，我们可以看到它们的前置元数据中有相同的键，但有些值不同。这两个文件都指向相同的[布局](https://jekyllrb.com/docs/layouts/)：[关于](https://github.com/george-gca/multi-language-al-folio/blob/main/_layouts/about.liquid)页面模板，并且此页面模板使用前置元数据中的值来渲染页面。

例如，英语页面的 `subtitle` 键的值为 `subtitle: <a href='#'>Affiliations</a>. Address. Contacts. Moto. Etc.`，而巴西葡萄牙语页面的值为 `subtitle: <a href='#'>Afiliações</a>. Endereço. Contatos. Lema. Etc.`。要在布局中使用此信息，可以这样使用：

{% raw %}
```liquid
{{ page.subtitle }}
```
{% endraw %}

这两个文件中前置元数据下方的内容也是一样的，可以在布局中这样使用：

{% raw %}
```liquid
{{ content }}
```
{% endraw %}

Polyglot 会自动使用当前语言的正确值渲染页面。

## 在页面之间共享布局和本地化数据

对于页面的 `subtitle`，他们在前置元数据中使用了 `key: value` 键值对，但有时我们希望在站点的不同部分中使用这些相同的对。例如，如果我们想在 `about.md` 和另一个页面中使用相同的 `subtitle`，我们将不得不在这两个页面的前置元数据中重复相同的对。这并不是我们想要的，因为如果我们需要更改 `subtitle`，我们将不得不在两个地方更改它。这就是本地化数据的用武之地。您可以创建一个文件，例如 `_data/:lang/strings.yml`，每种语言一个，Polyglot 将这些键带到 `site.data[:lang].strings` 下。

比如说，在模板站点中有两个文件，[\_data/en-us/strings.yml](https://github.com/george-gca/multi-language-al-folio/blob/main/_data/en-us/strings.yml) 和 [\_data/pt-br/strings.yml](https://github.com/george-gca/multi-language-al-folio/blob/main/_data/pt-br/strings.yml)。在第一个文件中，前置元数据内容包括：

```yaml
latest_posts: latest posts
```

而在第二个文件中，前置元数据内容包括：

```yaml
latest_posts: últimas postagens
```

这样，他们可以在布局中使用 `latest_posts` 键，如下所示：

{% raw %}
```liquid
{{ site.data[site.active_lang].strings.latest_posts }}
```
{% endraw %}

这样一来，`latest_posts` 变量的值将正确获取到当前语言的 `_data/:lang/strings.yml` 文件中定义的值。

## 在前置元数据中定义要使用的变量

现在，如果您想在页面的前置元数据中定义这个变量，这就有点棘手了。一个可能的解决方案是检查变量的值中是否有 `.`，如果有，就使用文件 `_data/:lang/strings.yml` 中的值。你可以这么进行操作：

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

如果 `frontmatter_var = blog.title` ，这段代码就会生效。
This will work, for example, if `frontmatter_var = blog.title`.

现在，如果您需要在使用它之前检查本地化字符串（该案例情况下是 `blog.title`）是否实际存在于文件 `_data/:lang/strings.yml` 中，您将不得不创建一个插件来检查变量是否存在于文件 `_data/:lang/strings.yml` 中，如果存在，则使用它，否则回退到任何您想要的值。我不会详细介绍如何做到这一点，但我会向您展示如何使用它。您可以在[这里](https://github.com/george-gca/multi-language-al-folio/blob/main/_plugins/localization-exists.rb)参阅该插件的代码。

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