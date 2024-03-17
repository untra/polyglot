---
layout: post
title: Variáveis traduzidas
lang: pt-BR
---

Polyglot permite que você tenha diferentes páginas para diferentes idiomas em seu site Jekyll. Por exemplo, você pode ter uma página `about.md` em inglês e outra `about.md` em espanhol com layouts completamente diferentes. Mas se você quiser ter o mesmo layout para todas as páginas, você pode usar variáveis traduzidas. Esta é uma maneira de ter diferentes dados para diferentes idiomas em seu site Jekyll, mas usando o mesmo layout para todos os idiomas.

Como exemplo, usarei um [site modelo](https://github.com/george-gca/multi-language-al-folio) criado com Polyglot.

## Compartilhando um layout entre páginas

Nesse site eles têm uma página `sobre` para cada idioma, no caso deles inglês em [\_pages/en-us/about.md](https://github.com/george-gca/multi-language-al-folio/blob/main/_pages/en-us/about.md) e português brasileiro em [\_pages/pt-br/about.md](https://github.com/george-gca/multi-language-al-folio/blob/main/_pages/pt-br/about.md). Em ambas as páginas podemos ver que elas têm as mesmas chaves no frontmatter, mas algumas com valores diferentes. Ambos os arquivos apontam para o mesmo [layout](https://jekyllrb.com/docs/layouts/), [about](https://github.com/george-gca/multi-language-al-folio/blob/main/_layouts/about.liquid), e este layout usa os valores no frontmatter para renderizar a página.

Por exemplo, a chave `subtitle` na página em inglês tem o valor `subtitle: <a href='#'>Affiliations</a>. Address. Contacts. Moto. Etc.` e na página em português brasileiro tem `subtitle: <a href='#'>Afiliações</a>. Endereço. Contatos. Lema. Etc.`. Essa informação no layout é usada dessa forma:

{% raw %}
```liquid
{{ page.subtitle }}
```
{% endraw %}

O mesmo vale para o conteúdo abaixo do frontmatter em ambos os arquivos, que é simplesmente usado no layout dessa forma:

{% raw %}
```liquid
{{ content }}
```
{% endraw %}

Polyglot renderizará automaticamente a página com os valores corretos para o idioma atual.

## Compartilhando um layout entre páginas com dados traduzidos

Para o `subtitle` da página eles usaram pares `chave: valor` no frontmatter, mas às vezes queremos usar esses mesmos pares em diferentes partes do site. Por exemplo, se quisermos usar o mesmo `subtitle` no `about.md` e em outra página, teríamos que repetir o mesmo par no frontmatter de ambas as páginas. Isso não é ideal porque se quisermos mudar o `subtitle` teríamos que mudá-lo em dois lugares. É aí que entram os dados traduzidos. Você pode criar um arquivo como `_data/:lang/strings.yml`, um para cada idioma, e o Polyglot trará essas chaves sob `site.data[:lang].strings`.

Por exemplo, no site modelo existem dois arquivos, [\_data/en-us/strings.yml](https://github.com/george-gca/multi-language-al-folio/blob/main/_data/en-us/strings.yml) e [\_data/pt-br/strings.yml](https://github.com/george-gca/multi-language-al-folio/blob/main/_data/pt-br/strings.yml). No primeiro arquivo eles têm:

```yaml
latest_posts: latest posts
```

E no segundo arquivo eles têm:

```yaml
latest_posts: últimas postagens
```

Dessa forma, eles podem usar a chave `latest_posts` no layout assim:

{% raw %}
```liquid
{{ site.data[site.active_lang].strings.latest_posts }}
```
{% endraw %}

O que obterá corretamente o valor para a variável `latest_posts` definida no arquivo `_data/:lang/strings.yml` para o idioma atual.

## Definindo qual variável usar no frontmatter

Agora, se você quiser definir essa variável no frontmatter da página, isso fica um pouco mais complicado. Uma possível solução é verificar se o valor da variável tem um `.` nele e, se tiver, usar o valor no arquivo `_data/:lang/strings.yml`. É assim que você faria:

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

Isso funcionará, por exemplo, se `frontmatter_var = blog.title`.

Agora, se você precisar verificar se a string de tradução (neste caso `blog.title`) realmente existe no arquivo `_data/:lang/strings.yml` antes de usá-la, você terá que criar um plugin para verificar se a variável existe no arquivo `_data/:lang/strings.yml` e, se existir, usá-la, caso contrário, retornar para qualquer valor que você quiser. Não entrarei em detalhes sobre como fazer isso, mas mostrarei como usá-lo. Você pode ver o código do plugin [aqui](https://github.com/george-gca/multi-language-al-folio/blob/main/_plugins/localization-exists.rb).

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