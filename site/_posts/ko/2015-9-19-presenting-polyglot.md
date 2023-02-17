---
layout: post
title: Polyglot을 소개합니다
lang: ko
---

수개월에 걸친 노력과 수정 끝에, **Polyglot**을 자랑스럽게 선보입니다: 컨텐츠를 여러가지 언어와 방문자들에 *반드시* 맞춰주어야 하는 [Jekyll](http://jekyllrb.com) 사이트를 위한 i18n 플러그인이죠.

### 기능

Jekyll을 위한 여러가지 다국어 플러그인이 있지만, Polyglot은 그 중에서도 특별합니다. Polyglot은 보통 개발자들의 몫으로 남겨지는 잡일을 (url과 씨름하거나 일관된 사이트맵 유지 등) 해결함과 동시에 Jekyll 개발자들이 SEO나 빠른 컨텐츠 집계에 활용할 수 있는 효율적이고 단순한 툴을 제공합니다.

## 링크 상대화

과거에는 정적 다국어 사이트나 블로그에서 상대적 링크가 어느 언어를 서빙하고 있는지 면밀하게 관리해야만 했습니다. 개발자가 실수하기가 너무나도 쉬웠고, 외국어 방문자들은 미번역된 컨텐츠 사이에서 표류하기가 일쑤였죠.

Polyglot은 여러분이 지원하고자 하는 각 언어의 url을 자동으로 상대화합니다. 이 덕분에 방문자들이 여러분의 사이트를 브라우징 할 때 하나의 언어 안에서만 계속 격리되죠.

## 폴백 지원

번역되거나 다국어 컨텐츠가 *없는* 경우에는, Jekyll은 기존의 컨텐츠로 빌드합니다. 번역되거나 다국어 컨텐츠가 *있는* 경우, Jekyll은 그 컨텐츠로 빌드합니다. 간단하죠.

모든 언어에 걸쳐 사이트맵은 일관성 있게 유지되고, 번역된 내용은 그 언어를 위해 빌드된 사이트 내에서만 머뭅니다.

## 리치 컨텐츠 번역

리치 언어 컨텐츠는 보통 구현하기가 힘듭니다. Jekyll 사이트가 짧은 문자열이나 언어에 의존하는 배너를 일관성 있게 유지하기는 어렵습니다.

*이렇게 쉬울때는 제외하고 말이죠*. config.yml 안에 문자열을 이렇게 보관하면 됩니다:
{% highlight yaml %}
hello:
  en: Hello!
  es: ¡hola!
  fr: Bonjour!
  de: Guten Tag!
  ko: 안녕하세요!
{% endhighlight %}
그리고 liquid에서는 이렇게만 호출하세요:
{% highlight html %}
{% raw %}
{{ site.hello[site.active_lang]}}
{% endraw %}
{% endhighlight %}
그러면:
<p class="message">
{{ site.hello[site.active_lang]}}
</p>

## 빠르고, 비동기화된, 오버헤드 없는 빌드

  Polyglot은 기존 언어 사이트를 빌드하는 것 만큼 다국어 사이트도 빠르게 빌드합니다.
  Polyglot은 여러분의 사이트의 모든 언어를 각각의 프로세스로써 *동시에* 빌드해 오버헤드를 최소화합니다. 즉, 웹사이트 빌드 시간이 지원하는 언어의 갯수에 정비례하지 않아도 된다는 뜻이죠.

### 다운로드

  Polyglot은 gem으로도 배포되고 있고, Jekyll 플러그인으로도 제공되고 있습니다. 설치하시려면:
  {% highlight bash %}
  gem install 'jekyll-polyglot'
  {% endhighlight %}
