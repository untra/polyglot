---
layout: page
title: À propos
permalink: about/
lang: fr
---
<p class="message">
  <b>Polyglot</b> est un plugin open source d'internationalisation pour les blogs construits avec <a href="http://jekyllrb.com">Jekyll.</a> Polyglot est facile à installer et à utiliser pour tout projet, et il évolue avec les langues que vous souhaitez supporter. Avec solution de repli pour le contenu manquant, relativisation automatique d'URL, et de puissantes <a href="{{site.baseurl}}/seo/">recettes de SEO,</a> Polyglot permet un blog multi-langue pour se concentrer sur le contenu uniquement.
</p>

_`jekyll-polyglot` n'est pas encore supporté nativement dans github-actions_

### Installation

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### Gestion des langues supportées

Dans `_config.yml`, les propriétés suivantes gèrent les langues supportées par votre site web. Vous pouvez ajouter le support d'une nouvelle langue en l'ajoutant à ces valeurs (voir ci-dessous). Les langues sont identifiées par leurs [codes de locale](https://developer.chrome.com/webstore/i18n) officiels.
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` un tableau de codes de locale identifiant les langues supportées par le site web.
* `default_lang:` langue par défaut du site web.
* `exclude_from_localization:` dossiers et répertoires qui font partie du site web construit, mais qui n'ont pas besoin d'être localisés. Ceci est principalement pour réduire les temps de construction, et parce que les fichiers d'assets comme les images et les polices sont de grandes parties du site web, cela garantit qu'ils ne sont pas inutilement "traduits" ou dupliqués dans la sortie.
* `url` l'url de votre site web statique de production.

### Ajouter une nouvelle langue
En supposant que vous avez déjà un site web fonctionnel monolingue, ajouter une nouvelle langue ne sera pas trivial. _Pour vraiment créer un site web multilingue, vous devez vous attendre à devoir recréer tout votre contenu dans la nouvelle langue._ Cela peut sembler une grande entreprise, mais considérez la traduction par parties. Le contenu est roi; il est plus important que les nouvelles pages et articles reçoivent des traductions mises à jour. Créer un site web multilingue n'est difficile que si vous exigez qu'il soit parfaitement traduit dès le départ.

Premièrement, vous (et votre équipe, et vos managers aussi si vous en avez quelques-uns) devriez discuter et choisir quel contenu vous devez traduire pour le nouveau site web. Vous devez choisir votre contenu de base préféré à traduire. Considérez les analytics, les pages et articles populaires, et le flux des utilisateurs actuels et futurs vers votre site web. En cas de doute, priorisez les pages plutôt que les anciens articles de blog. Si cela signifie lancer une nouvelle langue plus tôt, les anciens articles peuvent demander plus d'efforts qu'ils n'en valent la peine pour la traduction.

Deuxièmement, vous devez (ou devriez fortement) fournir une couverture à 100% du contenu riche à travers votre site. Ce sont de petites chaînes intégrées de manières plus complexes. Il existe plusieurs façons d'itérer sur le contenu riche. N'oubliez pas que vous devez supporter toutes les petites chaînes dans toutes les langues dans votre contenu riche.

#### Contenu multilingue
Le contenu du site web existe en deux variétés: **basique** et **riche**.

Le contenu basique est le texte plat des articles de blog, des pages et du contenu non interactif. Pensez aux pages et aux articles. Le contenu basique est le carburant pour les clics sur votre site web. Polyglot offre un support de repli pour le contenu basique.

Le contenu riche est interactif, flashy et composé de chaînes plus courtes. Pensez aux barres de navigation et aux menus déroulants. Le contenu riche est plus technique et garde vos visiteurs sur le site. _Il n'y a pas de support de repli pour le contenu riche manquant._

#### Outils Liquid
Les outils Liquid suivants sont disponibles pour utilisation avec jekyll-polyglot:

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages` pointe directement vers le tableau `languages` dans _config.yml. Il peut être accédé via Liquid.

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang` pointe directement vers la chaîne `default_lang` dans _config.yml. Il peut être accédé via Liquid.

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}
`site.active_lang` est le code de locale pour lequel la page est construite. C'est `"de"` pour la version allemande d'une page, `"es"` pour la version espagnole, et ainsi de suite. Il peut être accédé via Liquid.

En utilisant ces outils, vous pouvez spécifier comment attacher le bon contenu riche.

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

La variable `page.rendered_lang` indique la langue réelle du contenu d'une page, permettant aux templates de détecter quand une page est servie comme contenu de repli.

### Support Github Pages
Par défaut, Github empêche les [blogs Jekyll d'utiliser des plugins](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides). Ceci est fait intentionnellement pour empêcher l'exécution de code malveillant sur les serveurs Github. Bien que cela rende l'utilisation de Polyglot (et d'autres plugins Jekyll) plus difficile, c'est toujours faisable.

#### Construire `_site/` vers gh-pages
Au lieu d'héberger votre moteur de blog Jekyll sur Github, vous pouvez développer votre site web Jekyll sur une branche séparée, puis pousser le contenu construit `_site/` vers votre branche `gh-pages`. Cela vous permet de gérer et de contrôler la version de votre développement de site web avec Github *sans avoir à compter sur Github pour construire votre site web!*

Vous pouvez faire cela en maintenant votre contenu Jekyll sur une branche séparée, et en ne committant que le dossier `_site/` vers votre branche gh-pages. Parce que ce sont juste des pages HTML statiques dans des dossiers, Github les hébergera comme tout autre contenu [gh-pages](https://pages.github.com/).

#### Automatisez-le!

Ce processus est grandement facilité par un simple script qui construira votre site web et committera le dossier `_site/` vers votre gh-pages. Beaucoup de gens en ont un. [En voici un](http://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/). [En voici un autre](https://gist.github.com/cobyism/4730490). Voici [mon script de publication](https://github.com/untra/polyglot/blob/main/publi.sh):
```bash
#! /bin/sh
# changez les noms des branches en conséquence
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
