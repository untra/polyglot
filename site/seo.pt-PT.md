---
layout: page
title: Receitas de SEO
permalink: seo/
lang: pt-PT
description: These additions can help improve the SEO of your multi-language jekyll blog when using Polyglot.
---
# Receitas para Otimização para Motores de Pesquisa usando o Polyglot

Se instalou a gema `jekyll-polyglot`, estas adições ao cabeçalho do seu site podem facilmente dar ao seu blogue jekyll os bónus de SEO oferecidos pelo Google.

## Declaração de Língua HTML

De acordo com o [WHATWG HTML Living Standard](https://html.spec.whatwg.org/multipage/dom.html#the-lang-and-xml:lang-attributes), deve declarar a língua da página usando o atributo `lang` no elemento HTML raiz. Adicione isto ao seu layout:

{% highlight html %}{% raw %}
<html lang="{{ site.active_lang }}">
{% endraw %}
{% endhighlight %}

Isto permite que navegadores, motores de pesquisa e tecnologias de apoio (leitores de ecrã, ferramentas de tradução) processem o seu conteúdo corretamente.

## SEO multilingue usando tags alternate hreflang

Pode facilmente adicionar [tags alternate](https://developers.google.com/search/docs/specialty/international/localized-versions?hl=pt-PT) `hreflang="{{site.active_lang}}"` ao seu site, obtendo SEO nas pesquisas multilingues do Google. Quando o navegador usa uma língua não suportada, o site recorre à versão predefinida com `hreflang="x-default"`.

Certifique-se de que inclui [tags canónicas](https://developers.google.com/search/docs/specialty/international/managing-multi-regional-sites?hl=pt-PT) ao identificar conteúdo em páginas semelhantes da mesma língua.

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

## Tudo o anterior (hreflang e canonical)

Pode obter o link canónico, os links alternate hreflang e o fallback x-default com uma única tag adicionada ao seu `head.html`:
{% highlight html %}
{% raw %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}

Nota: continua a ter de adicionar `<html lang="{{ site.active_lang }}">` ao elemento raiz do seu layout separadamente, conforme descrito acima.

Com este SEO, cada clique numa página de qualquer língua do site contará para o total de cliques de todas as línguas do site.

## Usar o polyglot com o jekyll-seo-tag

O [jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) é outro plugin do Jekyll que emite tags `<title>` e `<meta>` para SEO. O `{% raw %}{% I18n_Headers %}{% endraw %}` do Polyglot foi concebido para conviver com ele: deixe o jekyll-seo-tag tratar de tudo exceto do URL canónico, e deixe o polyglot tratar do canonical e dos alternates hreflang (algo que consegue fazer corretamente entre línguas):

{% highlight liquid %}
{% raw %}
{% seo canonical=false %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}

A opção `canonical=false` requer o jekyll-seo-tag v2.9.0 ou posterior.

### Canonical de fallback para páginas não traduzidas

Por predefinição, uma página sem tradução na língua ativa recebe na mesma um canonical a apontar para o seu URL traduzido. Para melhorar o SEO, pode fazer com que as páginas de fallback apontem o seu URL canónico para a versão na língua predefinida. Adicione ao seu `_config.yml`:

{% highlight yaml %}
fallback_canonical_to_default_lang: true
{% endhighlight %}

Com isto ativado:

- Páginas com tradução real: o canonical aponta para o URL traduzido (por exemplo, `/es/sobre-nosotros/`).
- Páginas de fallback (sem tradução): o canonical aponta para o URL na língua predefinida (por exemplo, `/about/` em vez de `/es/about/`).

Isto consolida a autoridade de SEO no conteúdo original e evita que os motores de pesquisa indexem páginas de fallback duplicadas entre línguas.

## Usar o polyglot com o jekyll-redirect-from

O plugin [jekyll-redirect-from](https://github.com/jekyll/jekyll-redirect-from) permite que as páginas declarem URLs antigos a partir dos quais devem ser redirecionadas. O polyglot integra-se com ele de duas formas:

**Redirecionamentos automáticos entre línguas via `page_id`.** Quando duas páginas partilham um `page_id` mas têm permalinks diferentes, o polyglot adiciona automaticamente os permalinks das outras línguas ao `redirect_from` da página. Não é necessária qualquer configuração manual — basta garantir que ambas as páginas têm o mesmo `page_id` no front matter.

**`redirect_from` com âmbito de língua.** Quando uma página numa língua não predefinida declara o seu próprio `redirect_from`, o polyglot prefixa automaticamente os caminhos com o código de língua da página, de modo que `/old-path` se torna `/fr/old-path` numa página em francês. Os caminhos que já começam pelo código de língua são mantidos como estão.

Inclua um [layout redirect.html personalizado](https://github.com/untra/polyglot/blob/main/site/_layouts/redirect.html) no seu site.

## Localizar os _redirects do Netlify

_Novidade na versão 1.13.0._

Quando faz deploy no [Netlify](https://www.netlify.com/) com um [ficheiro `_redirects`](https://docs.netlify.com/manage/routing/redirects/overview/#syntax-for-the-_redirects-file), o Polyglot pode gerar automaticamente cópias de cada regra com o prefixo da língua, para que funcionem em todos os seus URLs localizados.

Ative-o no `_config.yml`:

{% highlight yaml %}
localize_redirects: true
exclude_from_redirect_localization:
  - /signin
  - /app
{% endhighlight %}

Com isto, uma única regra como:

{% highlight text %}
/github  https://github.com/org/repo  302
{% endhighlight %}

é expandida em cópias com prefixo de língua para cada língua configurada:

{% highlight text %}
/github     https://github.com/org/repo  302
/fr/github  https://github.com/org/repo  302
/de/github  https://github.com/org/repo  302
/sv/github  https://github.com/org/repo  302
{% endhighlight %}

Os URLs de destino externos são preservados tal como estão. Os caminhos listados em `exclude_from_redirect_localization` não são localizados, o que é útil para endpoints de autenticação ou rotas de single-page-app que só devem existir na raiz.
