---
layout: page
title: 소개
permalink: about/
lang: ko
---
<p class="message">
  <b>Polyglot</b>은 <a href="http://jekyllrb.com">Jekyll</a> 블로그를 위한 오픈소스 현지화 플러그인입니다. Polyglot은 모든 프로젝트에 적용 및 사용하기가 쉬우며, 여러분이 지원하고자 하는 언어 수에 맞춰 확장됩니다. 누락된 컨텐츠에 대한 폴백 지원, 자동 url 상대화, 그리고 <a href="{{site.baseurl}}/seo/">강력한 SEO 레시피</a>로, Polyglot은 그 어떤 다국어 블로그라도 귀찮은 잔작업 대신 컨텐츠에 집중할 수 있도록 도와줍니다.
</p>

_`jekyll-polyglot`은 아직 github-actions에서 기본적으로 지원되지 않습니다_

### 설치

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### 지원 언어 관리

`_config.yml`에서 다음 속성들이 웹사이트에서 지원하는 언어를 관리합니다. 아래 값에 새 언어를 추가하여 지원할 수 있습니다(아래 참조). 언어는 공식 [로케일 코드](https://developer.chrome.com/webstore/i18n)로 식별됩니다.
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` 웹사이트에서 지원하는 언어를 식별하는 로케일 코드 배열입니다.
* `default_lang:` 웹사이트의 기본 언어입니다.
* `exclude_from_localization:` 빌드된 웹사이트의 일부이지만 현지화가 필요 없는 폴더와 디렉토리입니다. 이는 주로 빌드 시간을 단축하기 위한 것이며, 이미지와 폰트 같은 에셋 파일이 웹사이트의 큰 부분을 차지하므로 출력에서 불필요하게 "번역"되거나 복제되지 않도록 합니다.
* `url` 프로덕션 정적 웹사이트의 URL입니다.

### 새 언어 추가
이미 기능하는 단일 언어 웹사이트가 있다고 가정하면, 새 언어를 추가하는 것은 간단하지 않을 것입니다. _진정한 다국어 웹사이트를 만들려면 모든 컨텐츠를 새 언어로 다시 만들어야 할 것으로 예상해야 합니다._ 이것이 큰 작업처럼 보일 수 있지만, 번역을 부분적으로 고려하세요. 컨텐츠가 왕입니다; 새 페이지와 게시물이 번역된 텍스트를 받는 것이 더 중요합니다. 다국어 웹사이트를 만드는 것은 처음부터 완벽하게 번역되기를 요구하는 경우에만 어렵습니다.

첫째, 여러분(그리고 팀, 그리고 매니저가 있다면 매니저도)은 새 웹사이트를 위해 어떤 컨텐츠를 번역해야 하는지 논의하고 선택해야 합니다. 번역할 기본 컨텐츠의 우선순위를 선택해야 합니다. 분석 데이터, 인기 있는 페이지와 블로그 게시물, 그리고 현재와 미래 사용자의 웹사이트 유입 흐름을 고려하세요. 의심스러울 때는 오래된 블로그 게시물보다 페이지를 우선시하세요. 새 언어를 더 빨리 출시한다는 것은 오래된 게시물이 번역할 가치보다 더 많은 노력이 필요할 수 있다는 것을 의미합니다.

둘째, 사이트 전체에서 리치 컨텐츠의 100% 커버리지를 제공해야 합니다(또는 강력히 권장됩니다). 이것들은 더 복잡한 방식으로 임베드된 작은 문자열들입니다. 리치 컨텐츠를 반복하는 여러 가지 방법이 있습니다. 리치 컨텐츠의 모든 작은 문자열을 모든 언어로 지원해야 한다는 것을 기억하세요.

#### 다국어 컨텐츠
웹사이트 컨텐츠는 두 가지 종류가 있습니다: **기본** 과 **리치**.

기본 컨텐츠는 블로그 게시물, 페이지, 비대화형 컨텐츠의 플랫 텍스트입니다. 페이지와 게시물을 생각하세요. 기본 컨텐츠는 웹사이트 클릭의 연료입니다. Polyglot은 기본 컨텐츠에 폴백 지원을 제공합니다.

리치 컨텐츠는 대화형이고, 화려하며, 더 짧은 문자열로 구성됩니다. 내비게이션 바와 드롭다운을 생각하세요. 리치 컨텐츠는 더 기술적이며, 방문자를 사이트에 머물게 합니다. _누락된 리치 컨텐츠에 대한 폴백 지원은 없습니다._

#### Liquid 도구
다음 Liquid 도구들은 jekyll-polyglot과 함께 사용할 수 있습니다:

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages`는 _config.yml의 `languages` 배열을 직접 가리킵니다. Liquid를 통해 접근할 수 있습니다.

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang`은 _config.yml의 `default_lang` 문자열을 직접 가리킵니다. Liquid를 통해 접근할 수 있습니다.

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}
`site.active_lang`은 페이지가 빌드되는 로케일 코드입니다. 페이지의 독일어 버전은 `"de"`, 스페인어 버전은 `"es"` 등입니다. Liquid를 통해 접근할 수 있습니다.

이 도구들을 사용하여 올바른 리치 컨텐츠를 첨부하는 방법을 지정할 수 있습니다.

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

`page.rendered_lang` 변수는 페이지 컨텐츠의 실제 언어를 나타내며, 템플릿이 페이지가 폴백 컨텐츠로 제공되고 있는지 감지할 수 있게 합니다.

### Github Pages 지원
기본적으로 Github은 [Jekyll 블로그가 플러그인을 사용하는 것을 방지](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides)합니다. 이것은 악성 코드가 Github 서버에서 실행되는 것을 방지하기 위해 의도적으로 수행됩니다. 이것이 Polyglot(및 다른 Jekyll 플러그인) 사용을 더 어렵게 만들지만, 여전히 가능합니다.

#### `_site/`를 gh-pages로 빌드하기
Github에서 Jekyll 블로깅 엔진을 호스팅하는 대신, 별도의 브랜치에서 Jekyll 웹사이트를 개발한 다음 빌드된 `_site/` 컨텐츠를 `gh-pages` 브랜치로 푸시할 수 있습니다. 이렇게 하면 *Github에 의존하지 않고도* Github으로 웹사이트 개발을 관리하고 소스 제어할 수 있습니다!

별도의 브랜치에서 Jekyll 컨텐츠를 유지하고 `_site/` 폴더만 gh-pages 브랜치에 커밋하면 됩니다. 이것들은 폴더 안의 정적 HTML 페이지에 불과하므로 Github은 다른 [gh-pages](https://pages.github.com/) 컨텐츠와 마찬가지로 호스팅합니다.

#### 자동화하세요!

이 프로세스는 웹사이트를 빌드하고 `_site/` 폴더를 gh-pages에 커밋하는 간단한 스크립트로 크게 도움이 됩니다. 많은 사람들이 하나씩 가지고 있습니다. [여기 하나 있습니다](http://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/). [여기 또 하나 있습니다](https://gist.github.com/cobyism/4730490). 여기 [제 게시 스크립트](https://github.com/untra/polyglot/blob/main/publi.sh)가 있습니다:
```bash
#! /bin/sh
# 브랜치 이름을 적절하게 변경하세요
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
