---
layout: page
title: 關於
permalink: about/
lang: zh-TW
---
<p class="message">
  <b>Polyglot</b> 是一款專為 <a href="https://jekyllrb.com">Jekyll</a> 部落格打造的開放原始碼國際化外掛程式。Polyglot 安裝容易，適用於任何專案，也適用於任何您想要支援的語言。有了 Polyglot 對缺漏內容的遞補支援、URL 自動相對化處理，以及<a href="{{site.baseurl}}/seo/">強大的 SEO 秘訣</a>，您在經營多語言部落格時可以專注於內容本身，而不必處理繁瑣的技術雜務。
</p>

_`jekyll-polyglot` 尚未在 github-actions 中獲得原生支援_

### 安裝

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### 管理支援的語言

在 `_config.yml` 中，以下屬性用來管理您網站支援的語言。您可以將新語言加入這些值來提供支援（見下文）。語言以其官方[地區代碼](https://developer.chrome.com/webstore/i18n)來識別。
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` 標識網站支援語言的地區代碼陣列。
* `default_lang:` 網站的預設語言。
* `exclude_from_localization:` 屬於建置後網站、但不需要在地化的資料夾與目錄。這主要是為了縮短建置時間；由於圖片和字型等資源檔是網站的重要組成，這能確保它們不會在輸出中被不必要地「翻譯」或複製。
* `url` 您正式環境靜態網站的 URL。

### 新增語言
假設您已經有一個運作正常的單語言網站，新增語言並不簡單。_要真正打造一個多語言網站，您應該預期需要以新語言重新建立所有內容。_ 這看起來也許是件浩大的工程，但請將翻譯分階段考量。內容為王；新頁面和新文章優先獲得最新翻譯更為重要。只有當您要求網站從一開始就翻譯得盡善盡美時，打造多語言網站才會變得困難。

首先，您（以及您的團隊，還有您的主管，如果有的話）應該討論並選擇需要為新網站翻譯哪些內容。您必須挑選優先翻譯的基礎內容。請考量分析數據、熱門頁面與文章，以及目前和未來使用者造訪您網站的動線。如有疑慮，請優先處理頁面而非舊的部落格文章。如果這能讓新語言更早上線，舊文章的翻譯也許不值得投入那麼多心力。

其次，您必須（或強烈建議）讓整個網站的富內容達到 100% 覆蓋。這些是以較複雜方式嵌入的小字串。有多種方法可以走訪富內容。請記住，您必須在富內容中支援所有語言的所有小字串。

#### 多語言內容
網站內容分為兩種類型：**基礎**與**富內容**。

基礎內容是部落格文章、頁面和非互動式內容的純文字。想想頁面和文章。基礎內容是網站點閱的燃料。Polyglot 為基礎內容提供遞補支援。

富內容是互動式的、華麗的，由較短的字串組成。想想導覽列和下拉選單。富內容較具技術性，能讓訪客留在網站上。_缺漏的富內容沒有遞補支援。_

#### Liquid 工具
以下 Liquid 工具可與 jekyll-polyglot 搭配使用：

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages` 直接指向 _config.yml 中的 `languages` 陣列。可以透過 Liquid 存取。

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang` 直接指向 _config.yml 中的 `default_lang` 字串。可以透過 Liquid 存取。

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}
`site.active_lang` 是頁面正在建置的地區代碼。德語版頁面是 `"de"`，西班牙語版是 `"es"`，依此類推。可以透過 Liquid 存取。

使用這些工具，您可以指定如何附加正確的富內容。

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

`page.rendered_lang` 變數表示頁面內容的實際語言，讓範本能夠偵測頁面何時是以遞補內容的形式提供。

### Github Pages 支援
預設情況下，Github 會阻止 [Jekyll 部落格使用外掛程式](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides)。這是刻意為之，以防止惡意程式碼在 Github 伺服器上執行。雖然這讓使用 Polyglot（以及其他 Jekyll 外掛程式）變得比較麻煩，但仍然可行。

#### 將 `_site/` 建置到 gh-pages
您可以在獨立的分支上開發 Jekyll 網站，再將建置好的 `_site/` 內容推送到 `gh-pages` 分支，而不必在 Github 上託管 Jekyll 部落格引擎。這讓您可以用 Github 管理與版本控制網站的開發，*而無須依賴 Github 來建置您的網站！*

您可以在獨立的分支維護 Jekyll 內容，只將 `_site/` 資料夾提交到 gh-pages 分支來達成。因為這些只是資料夾中的靜態 HTML 頁面，Github 會像託管其他任何 [gh-pages](https://pages.github.com/) 內容一樣託管它們。

#### 自動化！

這個流程透過一個簡單的指令碼會輕鬆許多：它會建置您的網站並將 `_site/` 資料夾提交到 gh-pages。很多人都有一個。[這裡有一個](https://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/)。[這裡還有一個](https://gist.github.com/cobyism/4730490)。這是[我的發佈指令碼](https://github.com/untra/polyglot/blob/main/publi.sh)：
```bash
#! /bin/sh
# 請視情況更改分支名稱
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
