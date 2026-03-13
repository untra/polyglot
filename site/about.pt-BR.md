---
layout: page
title: Sobre
permalink: about/
lang: pt-BR
---
<p class="message">
  <b>Polyglot</b> é um plugin de código aberto de internacionalização para blogs <a href="http://jekyllrb.com">Jekyll</a>. Polyglot é fácil de configurar e usar com qualquer projeto e adapta para os idiomas que você deseja dar suporte. Com redirecionamento para a língua principal em caso de conteúdo ausente, relativização automática de url e <a href="{{site.baseurl}}/seo/">receitas poderosas de SEO</a>, Polyglot permite que qualquer blog multilíngue se concentre no conteúdo sem o trabalho braçal.
</p>

_`jekyll-polyglot` ainda não é suportado nativamente no github-actions_

### Instalação

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### Gerenciando idiomas suportados

No `_config.yml`, as seguintes propriedades gerenciam quais idiomas são suportados pelo seu site. Você pode fornecer suporte para um novo idioma adicionando-o a esses valores (veja abaixo). Os idiomas são identificados pelos seus [códigos de localidade](https://developer.chrome.com/webstore/i18n) oficiais.
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` um array de códigos de localidade identificando os idiomas suportados pelo site.
* `default_lang:` idioma padrão do site.
* `exclude_from_localization:` pastas e diretórios que fazem parte do site construído, mas não precisam ser localizados. Isso é principalmente para reduzir os tempos de build, e como arquivos de assets como imagens e fontes são grandes partes do site, garante que eles não sejam desnecessariamente "traduzidos" ou duplicados na saída.
* `url` a url do seu site estático de produção.

### Adicionando um novo idioma
Assumindo que você já tem um site funcional em um único idioma, adicionar um novo idioma não será trivial. _Para realmente criar um site multilíngue, você deve esperar ter que recriar todo o seu conteúdo no novo idioma._ Isso pode parecer uma grande tarefa, mas considere a tradução em partes. Conteúdo é rei; é mais importante que novas páginas e posts recebam traduções atualizadas. Criar um site multilíngue só é difícil se você exigir que ele seja perfeitamente traduzido desde o início.

Primeiro, você (e sua equipe, e seus gerentes também, se você tiver alguns) devem discutir e escolher qual conteúdo você precisa traduzir para o novo site. Você deve escolher seu conteúdo básico preferido para traduzir. Considere análises, páginas e posts populares, e o fluxo de usuários atuais e futuros para o seu site. Em caso de dúvida, priorize páginas sobre posts de blog antigos. Se isso significa lançar um novo idioma mais cedo, posts antigos podem exigir mais esforço do que valem para traduzir.

Segundo, você deve (ou deveria fortemente) fornecer 100% de cobertura de conteúdo rico em todo o seu site. Essas são pequenas strings incorporadas de maneiras mais complexas. Existem várias maneiras de iterar sobre conteúdo rico. Lembre-se, você deve suportar todas as pequenas strings em todos os idiomas no seu conteúdo rico.

#### Conteúdo multilíngue
O conteúdo do site vem em dois sabores: **básico** e **rico**.

Conteúdo básico é o texto simples de posts de blog, páginas e conteúdo não interativo. Pense em páginas e posts. Conteúdo básico é o combustível para os cliques do seu site. Polyglot fornece suporte de fallback para conteúdo básico.

Conteúdo rico é interativo, chamativo e composto de strings mais curtas. Pense em barras de navegação e dropdowns. Conteúdo rico é mais técnico e mantém seus visitantes no site. _Não há suporte de fallback para conteúdo rico ausente._

#### Ferramentas Liquid
As seguintes ferramentas Liquid estão disponíveis para uso com jekyll-polyglot:

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages` aponta diretamente para o array `languages` no _config.yml. Pode ser acessado através do Liquid.

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang` aponta diretamente para a string `default_lang` no _config.yml. Pode ser acessado através do Liquid.

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}
`site.active_lang` é o código de localidade para o qual a página está sendo construída. Isso é `"de"` para a versão alemã de uma página, `"es"` para a versão espanhola, e assim por diante. Pode ser acessado através do Liquid.

Usando essas ferramentas, você pode especificar como anexar o conteúdo rico correto.

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

A variável `page.rendered_lang` indica o idioma real do conteúdo de uma página, permitindo que os templates detectem quando uma página está sendo servida como conteúdo de fallback.

### Suporte ao Github Pages
Por padrão, o Github impede que [blogs Jekyll usem plugins](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides). Isso é feito intencionalmente para evitar que código malicioso seja executado nos servidores do Github. Embora isso torne o uso do Polyglot (e outros plugins Jekyll) mais difícil, ainda é possível.

#### Construindo `_site/` para gh-pages
Em vez de hospedar seu mecanismo de blog Jekyll no Github, você pode desenvolver seu site Jekyll em um branch separado e então fazer push do conteúdo construído `_site/` para seu branch `gh-pages`. Isso permite que você gerencie e controle a versão do desenvolvimento do seu site com o Github *sem ter que depender do Github para construir seu site!*

Você pode fazer isso mantendo seu conteúdo Jekyll em um branch separado, e apenas fazendo commit da pasta `_site/` para seu branch gh-pages. Como essas são apenas páginas HTML estáticas em pastas, o Github as hospedará como qualquer outro conteúdo [gh-pages](https://pages.github.com/).

#### Automatize!

Esse processo é muito ajudado com um script simples que construirá seu site e fará commit da pasta `_site/` para seu gh-pages. Muitas pessoas têm um. [Aqui está um](http://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/). [Aqui está outro](https://gist.github.com/cobyism/4730490). Aqui está [meu script de publicação](https://github.com/untra/polyglot/blob/main/publi.sh):
```bash
#! /bin/sh
# mude os nomes dos branches apropriadamente
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
