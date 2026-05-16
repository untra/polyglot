---
layout: page
title: Receitas de SEO
permalink: seo/
lang: pt-BR
description: These additions can help improve the SEO of your multi-language jekyll blog when using Polyglot.
---
# Receitas para Otimização de Mecanismos de Busca usando Polyglot

Se você instalou a gema `jekyll-polyglot`, essas adições ao cabeçalho do seu site podem facilmente fornecer ao seu blog jekyll bônus de SEO fornecidos pelo Google.

## Declaração de Idioma HTML

De acordo com o [WHATWG HTML Living Standard](https://html.spec.whatwg.org/multipage/dom.html#the-lang-and-xml:lang-attributes), você deve declarar o idioma da página usando o atributo `lang` no elemento HTML raiz. Adicione isso ao seu layout:

{% highlight html %}{% raw %}
<html lang="{{ site.active_lang }}">
{% endraw %}
{% endhighlight %}

Isso permite que navegadores, mecanismos de busca e tecnologias assistivas (leitores de tela, ferramentas de tradução) processem seu conteúdo corretamente.

## Multi-language SEO usando hreflang alternate tags

Você pode facilmente adicionar [tags alternadas](https://developers.google.com/search/docs/specialty/international/localized-versions?hl=pt-BR) `hreflang="{{site.active_lang}}"` ao seu site, obtendo SEO com pesquisas multilíngues do Google. Quando o navegador usa um idioma não suportado, o site retorna para a versão padrão com `hreflang="x-default"`.

Certifique-se de incluir [tags canônicas](https://developers.google.com/search/docs/specialty/international/managing-multi-regional-sites?hl=pt-BR) ao identificar conteúdo em páginas semelhantes do mesmo idioma.

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

## Todas as anteriores (hreflang e canonical)

Você pode obter o link canonical, links alternate hreflang e fallback x-default com uma única tag adicionada ao seu `head.html`:
{% highlight html %}
{% raw %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}

Nota: Você ainda deve adicionar `<html lang="{{ site.active_lang }}">` ao elemento raiz do seu layout separadamente, conforme descrito acima.

Com esse SEO, cada clique em uma página de um idioma do site contará para o total de cliques de todos os idiomas do site.

## Usando polyglot com jekyll-seo-tag

[jekyll-seo-tag](https://github.com/jekyll/jekyll-seo-tag) é outro plugin do Jekyll que emite tags `<title>` e `<meta>` para SEO. O `{% raw %}{% I18n_Headers %}{% endraw %}` do Polyglot foi projetado para conviver com ele: deixe o jekyll-seo-tag cuidar de tudo, exceto da URL canônica, e deixe o polyglot cuidar do canonical e dos hreflang alternates (algo que ele consegue fazer corretamente entre idiomas):

{% highlight liquid %}
{% raw %}
{% seo canonical=false %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}

A opção `canonical=false` requer jekyll-seo-tag v2.9.0 ou posterior.

### Canonical de fallback para páginas não traduzidas

Por padrão, uma página que não possui tradução no idioma ativo ainda recebe um canonical apontando para sua URL traduzida. Para melhorar o SEO, você pode fazer com que as páginas de fallback apontem sua URL canônica para a versão no idioma padrão. Adicione ao seu `_config.yml`:

{% highlight yaml %}
fallback_canonical_to_default_lang: true
{% endhighlight %}

Com isso habilitado:

- Páginas com tradução real: o canonical aponta para a URL traduzida (por exemplo, `/es/sobre-nosotros/`).
- Páginas de fallback (sem tradução): o canonical aponta para a URL no idioma padrão (por exemplo, `/about/` em vez de `/es/about/`).

Isso consolida a autoridade de SEO no conteúdo original e evita que mecanismos de busca indexem páginas de fallback duplicadas entre idiomas.

## Usando polyglot com jekyll-redirect-from

O plugin [jekyll-redirect-from](https://github.com/jekyll/jekyll-redirect-from) permite que páginas declarem URLs antigas das quais devem ser redirecionadas. O polyglot integra-se a ele de duas formas:

**Redirecionamentos automáticos entre idiomas via `page_id`.** Quando duas páginas compartilham um `page_id` mas possuem permalinks diferentes, o polyglot adicionará automaticamente os permalinks dos outros idiomas ao `redirect_from` da página. Nenhuma configuração manual é necessária — apenas garanta que ambas as páginas tenham o mesmo `page_id` no front matter.

**`redirect_from` com escopo de idioma.** Quando uma página em um idioma não padrão declara seu próprio `redirect_from`, o polyglot automaticamente prefixa os caminhos com o código de idioma da página, de modo que `/old-path` se torna `/fr/old-path` em uma página em francês. Caminhos que já começam com o código de idioma são mantidos como estão.

Inclua um [layout redirect.html personalizado](https://github.com/untra/polyglot/blob/main/site/_layouts/redirect.html) no seu site.

## Localizando os _redirects do Netlify

_Novo na versão 1.13.0._

Quando você faz deploy no [Netlify](https://www.netlify.com/) com um [arquivo `_redirects`](https://docs.netlify.com/manage/routing/redirects/overview/#syntax-for-the-_redirects-file), o Polyglot pode gerar automaticamente cópias prefixadas por idioma de cada regra, para que elas funcionem em todas as suas URLs localizadas.

Habilite no `_config.yml`:

{% highlight yaml %}
localize_redirects: true
exclude_from_redirect_localization:
  - /signin
  - /app
{% endhighlight %}

Com isso, uma única regra como:

{% highlight text %}
/github  https://github.com/org/repo  302
{% endhighlight %}

é expandida em cópias prefixadas por idioma para cada idioma configurado:

{% highlight text %}
/github     https://github.com/org/repo  302
/fr/github  https://github.com/org/repo  302
/de/github  https://github.com/org/repo  302
/sv/github  https://github.com/org/repo  302
{% endhighlight %}

URLs de destino externas são preservadas como estão. Caminhos listados em `exclude_from_redirect_localization` não são localizados, o que é útil para endpoints de autenticação ou rotas de single-page-app que devem existir apenas na raiz.