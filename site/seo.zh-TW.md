---
layout: page
title: SEO 秘訣
permalink: seo/
lang: zh-TW
description: 這些補充可以幫助提升使用 Polyglot 時多語言 Jekyll 部落格的 SEO。
---

# 使用 Polyglot 的搜尋引擎最佳化（SEO）秘訣

如果您已經安裝了 `jekyll-polyglot` 套件，把這些內容加入您網站的 `head` 標籤中，就能讓您的 Jekyll 部落格輕鬆獲得 Google 提供的 SEO 加分。

## HTML 語言宣告

根據 [WHATWG HTML 規範](https://html.spec.whatwg.org/multipage/dom.html#the-lang-and-xml:lang-attributes)，您應該在根 HTML 元素上使用 `lang` 屬性來宣告頁面語言。在您的版面配置中加入如下內容：

{% highlight html %}{% raw %}
<html lang="{{ site.active_lang }}">
{% endraw %}
{% endhighlight %}

這能讓瀏覽器、搜尋引擎和輔助技術（螢幕閱讀器、翻譯工具）正確處理您的內容。

## 使用 hreflang 替代標籤實現多語言 SEO

您可以輕鬆地為您的網站加入 `hreflang="{{site.active_lang}}"` [alternate 標籤](https://developers.google.com/search/docs/specialty/international/localized-versions?hl=zh-TW)，以在 Google 多語言搜尋中獲得 SEO 效益。當瀏覽器使用不受支援的語言時，網站可以透過 `hreflang="x-default"` 遞補到預設語言版本。

在為同一語言的相似頁面標識內容時，請務必包含 [canonical 標籤](https://developers.google.com/search/docs/specialty/international/managing-multi-regional-sites?hl=zh-TW)。

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

## 一步到位（hreflang 與 canonical）

您可以把如下標籤直接加入您的 `head.html` 檔案，一次取得 canonical 連結、alternate hreflang 連結和 x-default 遞補：

{% highlight html %}
{% raw %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}

注意：您仍然需要依照上述說明，在版面配置的根元素上另外加入 `<html lang="{{ site.active_lang }}">`。

採用上述 SEO 策略後，網站任一語言頁面的每次點擊，都會計入網站所有語言的總點擊數。

## 搭配 jekyll-seo-tag 使用 polyglot

[jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) 是另一個用於 SEO 的 Jekyll 外掛程式，它會輸出 `<title>` 和 `<meta>` 標籤。Polyglot 的 `{% raw %}{% I18n_Headers %}{% endraw %}` 在設計上可以與它共存：讓 jekyll-seo-tag 處理 canonical URL 以外的所有內容，由 polyglot 處理 canonical 和 hreflang alternate 連結（polyglot 能正確地跨語言產生它們）：

{% highlight liquid %}
{% raw %}
{% seo canonical=false %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}

`canonical=false` 選項需要 jekyll-seo-tag v2.9.0 或更高版本。

### 未翻譯頁面的遞補 canonical

預設情況下，若某個頁面在目前使用的語言下沒有翻譯，其 canonical 仍會指向它在該語言下的 URL。為了獲得更好的 SEO，您可以讓遞補頁面的 canonical URL 指向預設語言版本。在 `_config.yml` 中加入：

{% highlight yaml %}
fallback_canonical_to_default_lang: true
{% endhighlight %}

啟用後：

- 有真實翻譯的頁面：canonical 指向翻譯後的 URL（例如 `/es/sobre-nosotros/`）。
- 遞補頁面（沒有翻譯）：canonical 指向預設語言的 URL（例如 `/about/` 而非 `/es/about/`）。

這能將 SEO 權重集中到原始內容上，並避免搜尋引擎為各語言間重複的遞補頁面建立索引。

## 搭配 jekyll-redirect-from 使用 polyglot

[jekyll-redirect-from](https://github.com/jekyll/jekyll-redirect-from) 外掛程式允許頁面宣告它們應該從哪些舊 URL 重新導向過來。Polyglot 以兩種方式與它整合：

**透過 `page_id` 實現跨語言自動重新導向。** 當兩個頁面擁有相同的 `page_id` 但具有不同的 permalink 時，polyglot 會自動將其他語言版本的 permalink 加入該頁面的 `redirect_from` 中。無需任何手動設定——只要確保兩個頁面在 front matter 中擁有相同的 `page_id` 即可。

**依語言限定範圍的 `redirect_from`。** 當一個非預設語言的頁面宣告了自己的 `redirect_from` 時，polyglot 會自動為這些路徑加上該頁面的語言代碼前綴，例如在法語頁面上 `/old-path` 會變成 `/fr/old-path`。已經以語言代碼開頭的路徑則保持不變。

請在您的網站中包含一個自訂的 [redirect.html 版面配置](https://github.com/untra/polyglot/blob/main/site/_layouts/redirect.html)。

## 在地化 Netlify _redirects

_自 1.13.0 起新增。_

當您部署到 [Netlify](https://www.netlify.com/) 並使用 [`_redirects` 檔案](https://docs.netlify.com/manage/routing/redirects/overview/#syntax-for-the-_redirects-file) 時，Polyglot 可以自動為每條規則產生帶語言前綴的副本，使它們在您所有在地化的 URL 上都能生效。

在 `_config.yml` 中啟用：

{% highlight yaml %}
localize_redirects: true
exclude_from_redirect_localization:
  - /signin
  - /app
{% endhighlight %}

啟用後，像這樣的一條規則：

{% highlight text %}
/github  https://github.com/org/repo  302
{% endhighlight %}

會針對每種已設定的語言擴充為帶語言前綴的副本：

{% highlight text %}
/github     https://github.com/org/repo  302
/fr/github  https://github.com/org/repo  302
/de/github  https://github.com/org/repo  302
/sv/github  https://github.com/org/repo  302
{% endhighlight %}

外部目標 URL 會原樣保留。列在 `exclude_from_redirect_localization` 中的路徑不會被在地化，這對於只應存在於根路徑的驗證端點或單頁應用程式路由非常有用。
