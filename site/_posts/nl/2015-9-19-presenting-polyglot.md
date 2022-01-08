---
layout: post
title: Aankondiging Polyglot
lang: nl
---

Na maanden van werk en verbeteringen kondig ik met trots aan **Polyglot**: een i18n-plug-in voor [Jekyll](http://jekyllrb.com)-websites, die een *noodzaak* hebben hun content in meerdere talen aan hun publike aan te bieden.

### Features

Zowaar er andere meertalige plugin-ins voor Jekyll zijn, Polyglot is anders. Polyglot bekommert zich om de typische zaken die normaal door ontwikkelaars worden beheerd (zoals het vermangelen van URL's en verzekeren van consistente sitemaps) en tegelijkertijd efficiënte en eenvoudige tools aanbieden die Jekyll-ontwikkelaars kunnen gebruiken in SEO en snelle contentaggregatie.

## Gerelativeerde URL's

Een meertalige statische site of blog moest in het verleden delicaat bijhouden welke taal werd aangeboden door elke relatieve link op de website. Hierdoor struikelde een ontwikkelaar snel en buitenlandse bezoekers met een andere taal verloren zichzelf snel in onvertaalde content.

Polyglot relativeert automatisch de URL's voor elke taal waar je je website voor wil bouwen. Dit maakt het mogelijk dat bezoekers geïsoleerd blijven in een taal terwijl ze je website bekijken.

## Fallback-ondersteuning

Als je *geen* vertaalde or meertalige content hebt, zal Jekyll nog steeds de site bouwen met de content die je hebt. Als je *wel* vertaalde of meertalige content hebt, zal Jekyll de site bouwen met die conent. Zo eenvoudig is het.

Sitemaps blijven consistent over alle talen, en de vertaling blijft in de website waarvoor het gebouwd was.

## Rich content vertalen

Vertalen van rich content is normaal moeilijk te implementeren. Korte strings of taalafhankelijke banners zijn typisch lastig voor een Jekyll-website om consistent te houden.

*Behalve, wanneer het makkelijk is*. In je config.yml, sla je string op deze manier op:
{% highlight yaml %}
hello:
  en: Hello!
  es: ¡hola!
  fr: Bonjour!
  de: Guten Tag!
{% endhighlight %}
en in je liquid, roep alleen maar aan
{% highlight html %}
{% raw %}
{{ site.hello[site.active_lang]}}
{% endraw %}
{% endhighlight %}
dat produceert:
<p class="message">
{{ site.hello[site.active_lang]}}
</p>

## Snel, asynchroon en zonder overhead bouwen

  Polyglot bouwt je meertalige website net zo snel als het je website voor je standaardtaal bouwt. Polyglot runt met een minimale overhead door *simultaan* alle talen van je website in een apart proces te bouwen. Dit betekent dat je website wordt gebouwd in een tijd die onafhankelijk is van de hoeveelheid talen die je wil ondersteunen.

### Download

  Polyglot is beschikbaar als een ruby gem of als een Jekyll-plug-in. Het kan worden geïnstalleerd met:
  {% highlight bash %}
  gem install 'jekyll-polyglot'
  {% endhighlight %}
