---
layout: page
title: Over
permalink: about/
lang: nl
---
<p class="message">
  <b>Polyglot</b> is een open source plugin-in voor internationalisering van <a href="http://jekyllrb.com">Jekyll</a>-blogs. Polyglot is eenvoudig te installeren en te gebruiken, en het schaalt met de taal die je wil aanbieden. Het biedt fallback voor ontbrekende inhoud, automatische URL-relativering en <a href="{{site.baseurl}}/seo/">krachtige SEO-recepten</a>. Polyglot geeft je de mogelijkheid bij een meertalige blog op de inhoud te richten en niet bezig te zijn met technische details.
</p>

_`jekyll-polyglot` wordt nog niet native ondersteund in github-actions_

### Installatie

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### Ondersteunde talen beheren

In `_config.yml` beheren de volgende eigenschappen welke talen door je website worden ondersteund. Je kunt ondersteuning voor een nieuwe taal toevoegen door deze aan deze waarden toe te voegen (zie hieronder). Talen worden geïdentificeerd door hun officiële [locale codes](https://developer.chrome.com/webstore/i18n).
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` een array van locale codes die de door de website ondersteunde talen identificeren.
* `default_lang:` standaardtaal voor de website.
* `exclude_from_localization:` mappen en directories die deel uitmaken van de gebouwde website, maar niet gelokaliseerd hoeven te worden. Dit is voornamelijk om bouwtijden te verkorten, en omdat asset-bestanden zoals afbeeldingen en lettertypen grote delen van de website zijn, zorgt dit ervoor dat ze niet onnodig worden "vertaald" of gedupliceerd in de output.
* `url` de url van je productie statische website.

### Een nieuwe taal toevoegen
Ervan uitgaande dat je al een functionele eentalige website hebt, zal het toevoegen van een nieuwe taal niet triviaal zijn. _Om echt een meertalige website te maken, moet je verwachten dat je al je content in de nieuwe taal opnieuw moet maken._ Dit lijkt misschien een grote onderneming, maar beschouw de vertaling in delen. Content is koning; het is belangrijker dat nieuwe pagina's en berichten bijgewerkte vertalingen krijgen. Het maken van een meertalige website is alleen moeilijk als je eist dat het vanaf het begin perfect vertaald is.

Ten eerste moeten jij (en je team, en ook je managers als je die hebt) bespreken en kiezen welke content je moet vertalen voor de nieuwe website. Je moet je gewenste basiscontent kiezen om te vertalen. Overweeg analytics, populaire pagina's en blogberichten, en de stroom van huidige en toekomstige gebruikers naar je website. Bij twijfel, geef prioriteit aan pagina's boven oude blogberichten. Als het betekent dat je een nieuwe taal eerder kunt lanceren, zijn oude berichten misschien meer moeite waard dan ze waard zijn om te vertalen.

Ten tweede moet je (of zou je sterk moeten) 100% dekking van rijke content over je site bieden. Dit zijn kleine strings die op complexere manieren zijn ingebed. Er zijn meerdere manieren om door rijke content te itereren. Vergeet niet dat je alle kleine strings in alle talen in je rijke content moet ondersteunen.

#### Meertalige content
Website-content komt in twee smaken: **basis** en **rijk**.

Basiscontent is de platte tekst van blogberichten, pagina's en niet-interactieve content. Denk aan pagina's en berichten. Basiscontent is de brandstof voor de klikken op je website. Polyglot biedt fallback-ondersteuning voor basiscontent.

Rijke content is interactief, flitsend en bestaat uit kortere strings. Denk aan navigatiebalken en dropdown-menu's. Rijke content is meer technisch en houdt je bezoekers op de site. _Er is geen fallback-ondersteuning voor ontbrekende rijke content._

#### Liquid-tools
De volgende Liquid-tools zijn beschikbaar voor gebruik met jekyll-polyglot:

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages` wijst direct naar de `languages` array in _config.yml. Het kan worden benaderd via Liquid.

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang` wijst direct naar de `default_lang` string in _config.yml. Het kan worden benaderd via Liquid.

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}
`site.active_lang` is de locale code waarvoor de pagina wordt gebouwd. Dit is `"de"` voor de Duitse versie van een pagina, `"es"` voor de Spaanse versie, enzovoort. Het kan worden benaderd via Liquid.

Met behulp van deze tools kun je specificeren hoe de juiste rijke content moet worden gekoppeld.

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

De variabele `page.rendered_lang` geeft de werkelijke taal van de pagina-inhoud aan, waardoor templates kunnen detecteren wanneer een pagina als fallback-content wordt weergegeven.

### Github Pages-ondersteuning
Standaard voorkomt Github dat [Jekyll-blogs plugins gebruiken](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides). Dit wordt opzettelijk gedaan om te voorkomen dat kwaadaardige code op Github-servers wordt uitgevoerd. Hoewel dit het gebruik van Polyglot (en andere Jekyll-plugins) moeilijker maakt, is het nog steeds mogelijk.

#### `_site/` bouwen naar gh-pages
In plaats van je Jekyll-blogging-engine op Github te hosten, kun je je Jekyll-website op een aparte branch ontwikkelen en vervolgens de gebouwde `_site/`-inhoud naar je `gh-pages`-branch pushen. Dit stelt je in staat om je websiteontwikkeling te beheren en te versiebeheren met Github *zonder te hoeven vertrouwen op Github om je website te bouwen!*

Je kunt dit doen door je Jekyll-content op een aparte branch te onderhouden en alleen de `_site/`-map naar je gh-pages-branch te committen. Omdat dit gewoon statische HTML-pagina's in mappen zijn, zal Github ze hosten zoals elke andere [gh-pages](https://pages.github.com/)-content.

#### Automatiseer het!

Dit proces wordt enorm geholpen met een eenvoudig script dat je website bouwt en de `_site/`-map naar je gh-pages commit. Veel mensen hebben er een. [Hier is er een](http://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/). [Hier is er nog een](https://gist.github.com/cobyism/4730490). Hier is [mijn publicatiescript](https://github.com/untra/polyglot/blob/main/publi.sh):
```bash
#! /bin/sh
# verander de branch-namen naar behoren
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
