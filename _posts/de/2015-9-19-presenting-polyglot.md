---
layout: post
title: Ankündigung Polyglot
lang: de
---

Nach monatelanger Arbeit und Raffinesse, ich bin stolz darauf, **Polyglot** präsentieren: eine i18n-Plugin für [Jekyll](http://jekyllrb.com) Websites, die *Notwendigkeit*, ihre Inhalte in mehrere Sprachen und Zielgruppen gerecht zu werden.

### Eigenschaften

Zwar gibt es andere Multi-Language-Plugins für Jekyll ist Polyglot Besonderes. Polyglot kümmert sich um den typischen Unsinn in der Regel an die Entwickler verlassen zu verwalten (wie Gerangel URLs und konsistente Sitemaps) und bietet effiziente und einfache Werkzeuge Jekyll-Entwickler können in SEO und Eilverfahren Content-Aggregation zu nutzen.

## Relativiert URLs

In der Vergangenheit hatte eine mehrsprachige statische Website oder ein Blog, um empfindliche verfolgen, was die Sprache jedes relativen Link wurde die Website dient zu halten. Es war viel zu einfach für einen Entwickler zu stolpern, und Fremdsprachen Besucher würde schnell in nicht übersetzten Inhalte verloren gehen.

Polyglot relativiert automatisch die URLs für jede Sprache, die Sie Ihre Website, um für die bauen wollen. Dies ermöglicht es Website-Besucher zu isoliert auf eine Sprache zu bleiben, während Durchsuchen Ihrer Website.

## Fallback-Unterstützung

Wenn Sie *nicht* haben übersetzt oder mehrsprachige Inhalte, Jekyll wird immer noch mit dem Inhalt zu bauen Sie zu tun haben. Wenn Sie *müssen* haben übersetzt oder mehrsprachigen Inhalten wird Jekyll bauen mit diesem Inhalt. So einfach ist das.

Sitemaps bleiben konsistent über alle Sprachen und übersetzt Aufenthalte in der Website es gebaut wurde.

## Reichen Inhalt Übersetzung

Reiche Sprache Inhalt ist in der Regel schwer zu implementieren. Kurze Strings oder sprachabhängige Banner sind in der Regel schwer für einen Jekyll Website konsistent zu halten.

*Außer, wenn es so einfach*. In Ihrem config.yml, nur die Saiten zu speichern, wie:
{% highlight yaml %}
hello:
  en: Hello!
  es: ¡hola!
  fr: Bonjour!
  de: Guten Tag!
{% endhighlight %}
und in ihre liquid, einfach anrufen:
{% highlight html %}
{% raw %}
{{ site.hello[site.active_lang]}}
{% endraw %}
{% endhighlight %}
produziert:
<p class="message">
{{ site.hello[site.active_lang]}}
</p>

## Schnell, Asynchron, baut Nullarbeit

  Polyglot wird Ihre mehrsprachige Website genauso schnell zu bauen, wie es Ihre Standardsprache Website zu bauen. Polyglot läuft mit einem minimalen Overhead von *gleichzeitig* Gebäude alle Sprachen Ihrer Website als separaten Prozess. Das bedeutet, Ihre Website Build-Zeit wird nicht davon ab, wie viele Sprachen, die unterstützt werden müssen.

### Download

  Polyglot ist als eines ruby gem oder als Jekyll Plugin. Es kann mit installiert werden:
  {% highlight bash %}
  gem install 'jekyll-polyglot'
  {% endhighlight %}
