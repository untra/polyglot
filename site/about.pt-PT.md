---
layout: page
title: Sobre
permalink: about/
lang: pt-PT
---
<p class="message">
  O <b>Polyglot</b> é um plugin de internacionalização de código aberto para blogues <a href="https://jekyllrb.com">Jekyll</a>. O Polyglot é fácil de configurar e de utilizar em qualquer projeto, adaptando-se às línguas a que pretende dar suporte. Com recurso à língua principal em caso de conteúdo em falta, relativização automática de URLs e <a href="{{site.baseurl}}/seo/">receitas poderosas de SEO</a>, o Polyglot permite que qualquer blogue multilingue se concentre no conteúdo, sem o trabalho penoso.
</p>

_`jekyll-polyglot` ainda não é suportado nativamente no github-actions_

### Instalação

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### Gerir as línguas suportadas

No `_config.yml`, as seguintes propriedades gerem quais as línguas suportadas pelo seu site. Pode dar suporte a uma nova língua adicionando-a a estes valores (ver abaixo). As línguas são identificadas pelos seus [códigos de localidade](https://developer.chrome.com/webstore/i18n) oficiais.
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` um array de códigos de localidade que identifica as línguas suportadas pelo site.
* `default_lang:` a língua predefinida do site.
* `exclude_from_localization:` pastas e diretórios que fazem parte do site construído mas não precisam de ser localizados. Serve sobretudo para reduzir os tempos de build e, como os ficheiros de assets (imagens e tipos de letra) constituem grande parte do site, garante que não são desnecessariamente "traduzidos" nem duplicados no resultado final.
* `url` o URL do seu site estático de produção.

### Adicionar uma nova língua
Assumindo que já tem um site funcional numa única língua, adicionar uma nova língua não será trivial. _Para criar verdadeiramente um site multilingue, deve contar com ter de recriar todo o seu conteúdo na nova língua._ Pode parecer uma tarefa enorme, mas encare a tradução por partes. O conteúdo é rei; é mais importante que as páginas e artigos novos recebam traduções atualizadas. Criar um site multilingue só é difícil se exigir que esteja perfeitamente traduzido desde o início.

Primeiro, deve (juntamente com a sua equipa, e também os seus gestores, se os tiver) discutir e escolher que conteúdo é necessário traduzir para o novo site. Deve escolher o conteúdo básico prioritário a traduzir. Considere as estatísticas, as páginas e artigos mais populares, e o fluxo de utilizadores atuais e futuros no seu site. Em caso de dúvida, dê prioridade às páginas em detrimento de artigos de blogue antigos. Se isso significar lançar uma nova língua mais cedo, os artigos antigos podem exigir mais esforço do que aquele que a sua tradução vale.

Segundo, deve (ou deveria, com veemência) garantir 100% de cobertura do conteúdo rico em todo o site. Trata-se de pequenas strings incorporadas de formas mais complexas. Há várias maneiras de iterar sobre o conteúdo rico. Lembre-se: tem de suportar todas as pequenas strings, em todas as línguas, no seu conteúdo rico.

#### Conteúdo multilingue
O conteúdo do site apresenta-se em dois sabores: **básico** e **rico**.

O conteúdo básico é o texto simples de artigos de blogue, páginas e conteúdo não interativo. Pense em páginas e artigos. O conteúdo básico é o combustível dos cliques do seu site. O Polyglot fornece suporte de fallback para o conteúdo básico.

O conteúdo rico é interativo, apelativo e composto por strings mais curtas. Pense em barras de navegação e menus pendentes. O conteúdo rico é mais técnico e mantém os visitantes no site. _Não há suporte de fallback para conteúdo rico em falta._

#### Ferramentas Liquid
As seguintes ferramentas Liquid estão disponíveis para utilização com o jekyll-polyglot:

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages` aponta diretamente para o array `languages` no _config.yml. Pode ser acedido através do Liquid.

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang` aponta diretamente para a string `default_lang` no _config.yml. Pode ser acedido através do Liquid.

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}
`site.active_lang` é o código de localidade para o qual a página está a ser construída. É `"de"` para a versão alemã de uma página, `"es"` para a versão espanhola, e assim sucessivamente. Pode ser acedido através do Liquid.

Com estas ferramentas, pode especificar como anexar o conteúdo rico correto.

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

A variável `page.rendered_lang` indica a língua real do conteúdo de uma página, permitindo aos templates detetar quando uma página está a ser servida como conteúdo de fallback.

### Suporte ao Github Pages
Por predefinição, o Github impede que [blogues Jekyll utilizem plugins](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides). Isto é intencional, para evitar que código malicioso seja executado nos servidores do Github. Embora torne a utilização do Polyglot (e de outros plugins Jekyll) mais difícil, continua a ser possível.

#### Construir `_site/` para gh-pages
Em vez de alojar o motor do seu blogue Jekyll no Github, pode desenvolver o site Jekyll num branch separado e depois fazer push do conteúdo construído de `_site/` para o branch `gh-pages`. Isto permite-lhe gerir e versionar o desenvolvimento do site com o Github *sem ter de depender do Github para construir o site!*

Pode fazê-lo mantendo o conteúdo Jekyll num branch separado e fazendo commit apenas da pasta `_site/` para o branch gh-pages. Como se trata apenas de páginas HTML estáticas em pastas, o Github alojá-las-á como qualquer outro conteúdo [gh-pages](https://pages.github.com/).

#### Automatize!

Este processo fica muito facilitado com um script simples que constrói o site e faz commit da pasta `_site/` para o gh-pages. Muita gente tem um. [Aqui está um](https://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/). [Aqui está outro](https://gist.github.com/cobyism/4730490). E aqui está o [meu script de publicação](https://github.com/untra/polyglot/blob/main/publi.sh):
```bash
#! /bin/sh
# altere os nomes dos branches conforme apropriado
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
