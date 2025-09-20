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

Per [W3C Internationalization Best Practices](http://www.w3.org/International/geo/html-tech/tech-lang.html#ri20060630.133615821)
Você pode definir o idioma padrão de cada página com uma meta tag. Basta adicionar o seguinte ao seu cabeçalho:

{% highlight html %}{% raw %}
<meta http-equiv="Content-Language" content="{{site.active_lang}}">
{% endraw %}
{% endhighlight %}

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

## Todas as anteriores

Você pode obter tudo isso acima com uma única tag adicionada ao seu `head.html`:
{% highlight html %}
{% raw %}
{% I18n_Headers %}
{% endraw %}
{% endhighlight %}

Com esse SEO, cada clique em uma página de um idioma do site contará para o total de cliques de todos os idiomas do site.

## Outras práticas recomendadas de SEO para polyglot

* sempre certifique-se de especificar as tags `<meta>` para `keywords` e `description` das páginas. Os mecanismos de pesquisa usarão essas tags para indexar melhor as páginas; para sites multilíngues, você deve fornecer valores diferentes para cada subidioma que seu site da web oferece suporte:

{% highlight html %}
{% raw %}
  <meta name="description" content="{{ page.description | default: site.description[site.active_lang] }}">
  <meta name="keywords" content="{{ page.keywords | default: site.keywords[site.active_lang] }}">
{% endraw %}
{% endhighlight %}