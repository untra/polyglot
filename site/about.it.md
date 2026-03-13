---
layout: page
title: Chi siamo
permalink: about/
lang: it
---
<p class="message">
  <b>Polyglot</b> è un plugin open source per l'internazionalizzazione dei blog <a href="http://jekyllrb.com">Jekyll</a>. Polyglot è facile da configurare e utilizzare con qualsiasi progetto, e si adatta alle lingue che vuoi supportare. Con supporto di fallback per contenuti mancanti, relativizzazione automatica degli URL e <a href="{{site.baseurl}}/seo/">potenti ricette SEO</a>, Polyglot permette a qualsiasi blog multilingue di concentrarsi sui contenuti senza lavoro superfluo.
</p>

_`jekyll-polyglot` non è ancora supportato nativamente in github-actions_

### Installazione

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### Gestione delle Lingue Supportate

In `_config.yml`, le seguenti proprietà gestiscono quali lingue sono supportate dal tuo sito web. Puoi aggiungere il supporto per una nuova lingua aggiungendola a questi valori (vedi sotto). Le lingue sono identificate dai loro [codici locale](https://developer.chrome.com/webstore/i18n) ufficiali.
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` un array di codici locale che identificano le lingue supportate dal sito web.
* `default_lang:` lingua predefinita per il sito web.
* `exclude_from_localization:` cartelle e directory che fanno parte del sito costruito, ma che non necessitano di localizzazione. Questo serve principalmente a ridurre i tempi di build, e poiché i file asset come immagini e font sono parti importanti del sito, assicura che non vengano inutilmente "tradotti" o duplicati nell'output.
* `url` l'url del tuo sito web statico di produzione.

### Aggiungere una nuova lingua
Supponendo che tu abbia già un sito web funzionante in una singola lingua, aggiungere una nuova lingua non sarà banale. _Per creare veramente un sito multilingue, dovresti aspettarti di dover ricreare tutti i tuoi contenuti nella nuova lingua._ Questo può sembrare un grande impegno, ma considera la traduzione in parti. Il contenuto è sovrano; è più importante che le nuove pagine e i post vengano aggiornati con le parole tradotte. Creare un sito multilingue è difficile solo se richiedi che sia perfettamente tradotto dall'inizio.

Prima di tutto, tu (e il tuo team, e anche i tuoi manager se ne hai qualcuno in giro) dovreste discutere e scegliere quali contenuti devono essere tradotti nel nuovo sito. Devi scegliere i tuoi contenuti di base preferiti da tradurre. Considera le analisi, le pagine e i post popolari, e il flusso degli utenti attuali e futuri verso il tuo sito. In caso di dubbio, dai priorità alle pagine rispetto ai vecchi post del blog. Se significa lanciare una nuova lingua prima, i post legacy potrebbero richiedere più sforzo di quanto valga tradurli.

In secondo luogo, devi (o dovresti fortemente) fornire una copertura del 100% dei contenuti ricchi attraverso il tuo sito. Queste sono piccole stringhe incorporate in modi più complessi. Ci sono diversi modi per iterare sui contenuti ricchi. Ricorda, devi supportare tutte le piccole stringhe di lingua nei tuoi contenuti ricchi.

#### Contenuti Multilingue
I contenuti del sito web sono di due tipi: **base** e **ricchi**.

I contenuti base sono il testo semplice di post del blog, pagine e contenuti non interattivi. Pensa a pagine e post. I contenuti base sono il carburante per i click del tuo sito. Polyglot offre supporto di fallback per i contenuti base.

I contenuti ricchi sono interattivi, appariscenti e composti da stringhe più brevi. Pensa a navbar e dropdown. I contenuti ricchi sono più tecnici e mantengono i visitatori sul sito. _Non c'è supporto di fallback per i contenuti ricchi mancanti._

#### Strumenti Liquid
I seguenti strumenti liquid sono disponibili per l'uso con jekyll-polyglot:

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages` punta direttamente all'array `languages` in _config.yml. Può essere accessibile tramite liquid.

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang` punta direttamente alla stringa `default_lang` in _config.yml. Può essere accessibile tramite liquid.

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}
`site.active_lang` è il codice locale per cui la pagina viene costruita. Questo è `"de"` per la versione tedesca di una pagina, `"es"` per la versione spagnola, e così via. Può essere accessibile tramite liquid.

Usando questi strumenti, puoi specificare come allegare i contenuti ricchi corretti.

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

La variabile `page.rendered_lang` indica la lingua effettiva del contenuto di una pagina, permettendo ai template di rilevare quando una pagina viene servita come contenuto di fallback.

### Supporto GitHub Pages
Per impostazione predefinita, GitHub impedisce ai [blog Jekyll di usare plugin](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides). Questo viene fatto intenzionalmente per prevenire l'esecuzione di codice malevolo sui server GitHub. Anche se questo rende l'uso di Polyglot (e altri plugin Jekyll) più difficile, è comunque fattibile.

#### Costruire `_site/` su gh-pages
Invece di ospitare il tuo motore di blogging Jekyll su GitHub, puoi sviluppare il tuo sito Jekyll su un branch separato, e poi pushare i contenuti costruiti di `_site/` sul tuo branch `gh-pages`. Questo ti permette di gestire e controllare la versione dello sviluppo del tuo sito con GitHub *senza dover fare affidamento su GitHub per costruire il tuo sito!*

Puoi farlo mantenendo i tuoi contenuti Jekyll su un branch separato, e committando solo la cartella `_site/` sul tuo branch gh-pages. Poiché queste sono solo pagine HTML statiche in cartelle, GitHub le ospiterà come qualsiasi altro contenuto [gh-pages](https://pages.github.com/).

#### Automatizzalo!

Questo processo è enormemente facilitato con un semplice script che costruirà il tuo sito e committa la cartella `_site/` sul tuo gh-pages. Molte persone ne hanno uno. [Eccone uno](http://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/). [Eccone un altro](https://gist.github.com/cobyism/4730490). Ecco il [mio script di pubblicazione](https://github.com/untra/polyglot/blob/main/publi.sh):
```bash
#! /bin/sh
# cambia i nomi dei branch appropriatamente
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
