---
layout: page
title: Über
permalink: about/
lang: de
---
<p class="message">
  <b>Polyglot</b> ist ein Open-Source-Internationalisierungs-Plugin für <a href="http://jekyllrb.com">Jekyll</a>-Blogs. Polyglot ist einfach zu installieren und zu verwenden, und es skaliert mit den Sprachen, die Sie unterstützen möchten. Es bietet Fallbacks für fehlende Inhalte, automatische URL-Relativierung und leistungsfähige <a href="{{site.baseurl}}/seo/">SEO-Rezepte</a>. So können Sie mehrsprachige Blogs erstellen und sich dabei auf den Inhalt konzentrieren anstatt auf nervige technische Details.
</p>

_`jekyll-polyglot` wird noch nicht nativ in github-actions unterstützt_

### Installation

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### Unterstützte Sprachen verwalten

In `_config.yml` verwalten die folgenden Eigenschaften, welche Sprachen von Ihrer Website unterstützt werden. Sie können Unterstützung für eine neue Sprache hinzufügen, indem Sie sie zu diesen Werten hinzufügen (siehe unten). Sprachen werden durch ihre offiziellen [Gebietsschema-Codes](https://developer.chrome.com/webstore/i18n) identifiziert.
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` Ein Array von Gebietsschema-Codes, die die unterstützten Sprachen der Website identifizieren.
* `default_lang:` Standardsprache für die Website.
* `exclude_from_localization:` Ordner und Verzeichnisse, die Teil der erstellten Website sind, aber nicht lokalisiert werden müssen. Dies dient hauptsächlich dazu, die Build-Zeiten zu verkürzen, und da Asset-Dateien wie Bilder und Schriftarten große Teile der Website sind, wird sichergestellt, dass sie nicht unnötig "übersetzt" oder in der Ausgabe dupliziert werden.
* `url` die URL Ihrer statischen Produktions-Website.

### Eine neue Sprache hinzufügen
Vorausgesetzt, Sie haben bereits eine funktionierende einsprachige Website, wird das Hinzufügen einer neuen Sprache nicht trivial sein. _Um wirklich eine mehrsprachige Website zu erstellen, sollten Sie erwarten, dass Sie alle Ihre Inhalte in der neuen Sprache neu erstellen müssen._ Das mag wie ein großes Unterfangen erscheinen, aber betrachten Sie die Übersetzung in Teilen. Inhalt ist König; es ist wichtiger, dass neue Seiten und Beiträge aktualisierte Übersetzungen erhalten. Die Erstellung einer mehrsprachigen Website ist nur schwierig, wenn Sie verlangen, dass sie von Anfang an perfekt übersetzt ist.

Erstens sollten Sie (und Ihr Team, und auch Ihre Manager, falls vorhanden) besprechen und auswählen, welche Inhalte Sie für die neue Website übersetzen müssen. Sie müssen Ihre bevorzugten grundlegenden Inhalte zur Übersetzung auswählen. Berücksichtigen Sie Analysen, beliebte Seiten und Blogbeiträge sowie den Fluss aktueller und zukünftiger Benutzer zu Ihrer Website. Im Zweifelsfall priorisieren Sie Seiten über ältere Blogbeiträge. Wenn es bedeutet, eine neue Sprache früher zu starten, kann die Übersetzung älterer Beiträge mehr Aufwand sein, als sie wert sind.

Zweitens müssen Sie (oder sollten Sie dringend) eine 100%ige Abdeckung von Rich Content auf Ihrer Website bereitstellen. Dies sind kleine Zeichenketten, die auf komplexere Weise eingebettet sind. Es gibt mehrere Möglichkeiten, Rich Content zu durchlaufen. Denken Sie daran, dass Sie alle kleinen Zeichenketten in allen Sprachen in Ihrem Rich Content unterstützen müssen.

#### Mehrsprachige Inhalte
Website-Inhalte gibt es in zwei Varianten: **Basis** und **Rich**.

Basis-Inhalte sind der flache Text von Blogbeiträgen, Seiten und nicht-interaktiven Inhalten. Denken Sie an Seiten und Beiträge. Basis-Inhalte sind der Treibstoff für die Klicks auf Ihrer Website. Polyglot bietet Fallback-Unterstützung für Basis-Inhalte.

Rich Content ist interaktiv, auffällig und besteht aus kürzeren Zeichenketten. Denken Sie an Navigationsleisten und Dropdown-Menüs. Rich Content ist technischer und hält Ihre Besucher auf der Website. _Es gibt keine Fallback-Unterstützung für fehlenden Rich Content._

#### Liquid-Werkzeuge
Die folgenden Liquid-Werkzeuge sind für die Verwendung mit jekyll-polyglot verfügbar:

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages` zeigt direkt auf das `languages`-Array in _config.yml. Es kann über Liquid aufgerufen werden.

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang` zeigt direkt auf die `default_lang`-Zeichenkette in _config.yml. Es kann über Liquid aufgerufen werden.

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}
`site.active_lang` ist der Gebietsschema-Code, für den die Seite erstellt wird. Dies ist `"de"` für die deutsche Version einer Seite, `"es"` für die spanische Version usw. Es kann über Liquid aufgerufen werden.

Mit diesen Werkzeugen können Sie angeben, wie der richtige Rich Content angehängt wird.

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

Die Variable `page.rendered_lang` gibt die tatsächliche Sprache des Seiteninhalts an und ermöglicht es Templates zu erkennen, wenn eine Seite als Fallback-Inhalt bereitgestellt wird.

### Github Pages Unterstützung
Standardmäßig verhindert Github, dass [Jekyll-Blogs Plugins verwenden](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides). Dies geschieht absichtlich, um zu verhindern, dass bösartiger Code auf Github-Servern ausgeführt wird. Obwohl dies die Verwendung von Polyglot (und anderen Jekyll-Plugins) erschwert, ist es dennoch möglich.

#### `_site/` nach gh-pages erstellen
Anstatt Ihre Jekyll-Blogging-Engine auf Github zu hosten, können Sie Ihre Jekyll-Website auf einem separaten Branch entwickeln und dann den erstellten `_site/`-Inhalt in Ihren `gh-pages`-Branch pushen. Dies ermöglicht es Ihnen, Ihre Website-Entwicklung mit Github zu verwalten und zu versionieren, *ohne sich darauf verlassen zu müssen, dass Github Ihre Website erstellt!*

Sie können dies tun, indem Sie Ihren Jekyll-Inhalt auf einem separaten Branch pflegen und nur den `_site/`-Ordner in Ihren gh-pages-Branch committen. Da dies nur statische HTML-Seiten in Ordnern sind, wird Github sie wie jeden anderen [gh-pages](https://pages.github.com/)-Inhalt hosten.

#### Automatisieren Sie es!

Dieser Prozess wird enorm durch ein einfaches Skript unterstützt, das Ihre Website erstellt und den `_site/`-Ordner in Ihre gh-pages pusht. Viele Leute haben eines. [Hier ist eines](http://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/). [Hier ist ein anderes](https://gist.github.com/cobyism/4730490). Hier ist [mein Veröffentlichungsskript](https://github.com/untra/polyglot/blob/main/publi.sh):
```bash
#! /bin/sh
# Ändern Sie die Branch-Namen entsprechend
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
