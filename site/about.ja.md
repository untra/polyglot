---
layout: page
title: Polyglotについて
permalink: about/
lang: ja
---
<p class="message">
  <b>Polyglot</b>は<a href="http://jekyllrb.com">Jekyll</a>ブログ用のオープンソース国際化プラグインです。Polyglotは任意のプロジェクトで簡単にセットアップして使用でき、サポートしたい言語に拡張できます。欠落コンテンツのフォールバックサポート、自動URL相対化、<a href="{{site.baseurl}}/seo/">強力なSEOレシピ</a>により、Polyglotは任意の多言語ブログが複雑な作業なしにコンテンツに集中できるようにします。
</p>

_`jekyll-polyglot`はまだgithub-actionsでネイティブサポートされていません_

### インストール

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### サポート言語の管理

`_config.yml`で、以下のプロパティがウェブサイトでサポートされる言語を管理します。これらの値に新しい言語を追加することでサポートを提供できます（下記参照）。言語は公式の[ロケールコード](https://developer.chrome.com/webstore/i18n)で識別されます。
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` ウェブサイトでサポートされる言語を識別するロケールコードの配列。
* `default_lang:` ウェブサイトのデフォルト言語。
* `exclude_from_localization:` ビルドされたウェブサイトの一部であるが、ローカライズする必要のないフォルダとディレクトリ。これは主にビルド時間を短縮するためであり、画像やフォントなどのアセットファイルはウェブサイトの大きな部分を占めるため、出力で不必要に「翻訳」されたり複製されたりしないことを保証します。
* `url` 本番静的ウェブサイトのURL。

### 新しい言語の追加
すでに機能する単一言語のウェブサイトがあると仮定すると、新しい言語の追加は簡単ではありません。_真の多言語ウェブサイトを作成するには、すべてのコンテンツを新しい言語で再作成する必要があることを予期すべきです。_ これは大きな作業のように思えるかもしれませんが、翻訳を部分的に考えてください。コンテンツは王様です。新しいページと投稿が更新された翻訳を取得することがより重要です。多言語ウェブサイトの作成は、最初から完璧に翻訳されることを要求する場合にのみ困難です。

まず、あなた（とチーム、そしてマネージャーがいれば彼らも）は、新しいウェブサイトのためにどのコンテンツを翻訳する必要があるかを議論して選択する必要があります。翻訳する優先的な基本コンテンツを選択する必要があります。分析、人気のあるページとブログ投稿、そして現在および将来のユーザーのウェブサイトへのフローを考慮してください。疑問がある場合は、古いブログ投稿よりもページを優先してください。新しい言語をより早くローンチすることを意味する場合、古い投稿は翻訳する価値よりも多くの労力を必要とするかもしれません。

次に、サイト全体でリッチコンテンツの100%カバレッジを提供する必要があります（または強くお勧めします）。これらはより複雑な方法で埋め込まれた小さな文字列です。リッチコンテンツを反復処理する方法は複数あります。リッチコンテンツのすべての小さな文字列をすべての言語でサポートする必要があることを忘れないでください。

#### 多言語コンテンツ
ウェブサイトのコンテンツには2種類あります：**基本**と**リッチ**。

基本コンテンツは、ブログ投稿、ページ、非インタラクティブコンテンツのプレーンテキストです。ページと投稿を考えてください。基本コンテンツはウェブサイトのクリックの燃料です。Polyglotは基本コンテンツのフォールバックサポートを提供します。

リッチコンテンツはインタラクティブで派手で、より短い文字列で構成されています。ナビゲーションバーとドロップダウンを考えてください。リッチコンテンツはより技術的で、訪問者をサイトに留めます。_欠落したリッチコンテンツのフォールバックサポートはありません。_

#### Liquidツール
以下のLiquidツールはjekyll-polyglotで使用できます：

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages`は_config.ymlの`languages`配列を直接指します。Liquidを通じてアクセスできます。

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang`は_config.ymlの`default_lang`文字列を直接指します。Liquidを通じてアクセスできます。

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}
`site.active_lang`はページがビルドされているロケールコードです。ページのドイツ語版は`"de"`、スペイン語版は`"es"`などです。Liquidを通じてアクセスできます。

これらのツールを使用して、正しいリッチコンテンツを添付する方法を指定できます。

* **page.rendered_lang**
{% highlight html %}
{% raw %}
{% if page.rendered_lang == site.active_lang %}
  <p>Welcome to our {{ site.active_lang }} webpage!</p>
{% else %}
  <p>webpage available in {{ page.rendered_lang }} only.</p>
{% endif %}
{% endraw %}
{% endhighlight %}

`page.rendered_lang`変数はページコンテンツの実際の言語を示し、テンプレートがページがフォールバックコンテンツとして提供されているかどうかを検出できるようにします。

### Github Pagesサポート
デフォルトでは、Githubは[Jekyllブログがプラグインを使用することを防ぎます](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides)。これは悪意のあるコードがGithubサーバーで実行されることを防ぐために意図的に行われています。これによりPolyglot（および他のJekyllプラグイン）の使用は難しくなりますが、それでも可能です。

#### `_site/`をgh-pagesにビルドする
JekyllブログエンジンをGithubでホストする代わりに、別のブランチでJekyllウェブサイトを開発し、ビルドされた`_site/`コンテンツを`gh-pages`ブランチにプッシュできます。これにより、*Githubにウェブサイトをビルドさせることなく*、Githubでウェブサイト開発を管理およびソース管理できます！

Jekyllコンテンツを別のブランチで管理し、`_site/`フォルダのみをgh-pagesブランチにコミットすることでこれを行えます。これらはフォルダ内の静的HTMLページに過ぎないため、Githubは他の[gh-pages](https://pages.github.com/)コンテンツと同様にホストします。

#### 自動化しましょう！

このプロセスは、ウェブサイトをビルドして`_site/`フォルダをgh-pagesにコミットするシンプルなスクリプトで大幅に支援されます。多くの人がこれを持っています。[こちらに一つ](http://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/)。[こちらにもう一つ](https://gist.github.com/cobyism/4730490)。こちらは[私の公開スクリプト](https://github.com/untra/polyglot/blob/main/publi.sh)です：
```bash
#! /bin/sh
# ブランチ名を適宜変更してください
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
