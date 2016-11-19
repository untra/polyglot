---
layout: post
title: Présentation Polyglot
lang: fr
---

Après des mois de travail et de raffinement, je suis fier de présenter **Polyglot**: un plugin i18n pour [Jekyll](http://jekyllrb.com) sites qui *besoin* pour répondre à leur contenu à de multiples langues et le public.

### Caractéristiques

Bien qu'il existe d'autres plugins multi-langues pour Jekyll, Polyglot est spécial. Polyglot prend soin de l'absurdité typique normalement laissée aux développeurs de gérer (comme querelles urls et assurer sitemaps cohérentes) tout en fournissant des outils simples et efficaces développeurs Jekyll peut utiliser dans le référencement et l'agrégation de contenu accéléré.

## Url Relativisé

Dans le passé, un site ou un blog statique multi-langue devaient garder une trace délicate que soit la langue de chaque lien relatif le site servait. Il était trop facile pour un développeur de trébucher, et les visiteurs de langue étrangère serait rapidement se perdre dans le contenu non traduite.

Polyglot relativise automatiquement les Url pour chaque langue que vous voulez que votre site pour construire. Cela permet les visiteurs du site à rester isolé sur une langue tout en naviguant sur votre site web.

## Soutien de Repli

Lorsque vous *ne ont* traduit ou contenu multilingue, Jekyll aurez toujours construire avec le contenu que vous avez. Lorsque vous *ne avez* traduit ou contenu multilingue, Jekyll se construire en utilisant ce contenu. Aussi simple que cela.

Sitemaps rester cohérente dans toutes les langues, et traduits séjours dans le site, il a été construit pour.

## Contenu Riche Traduction

Un contenu riche de la langue est normalement difficile à mettre en œuvre. Les chaînes courtes ou des bannières dépendant de la langue sont généralement difficile pour un site Jekyll pour garder cohérente.

*Sauf quand il est si facile*. Dans votre config.yml, simplement stocker vos chaînes comme:
{% highlight yaml %}
hello:
  en: Hello!
  es: ¡hola!
  fr: Bonjour!
  de: Guten Tag!
{% endhighlight %}
et dans votre liquid, il suffit d'appeler:
{% highlight html %}
{% raw %}
{{ site.hello[site.active_lang]}}
{% endraw %}
{% endhighlight %}
produit:
<p class="message">
{{ site.hello[site.active_lang]}}
</p>

## Rapide, Asynchrone, Zéro Frais-Généraux Builds

  Polyglot va construire votre site multi-langue aussi vite que il va construire votre site de langue par défaut. Polyglot fonctionne avec un minimum de frais généraux par *simultanément* bâtiment toutes les langues de votre site Web comme un processus distinct. Cela signifie que votre temps site de construction ne sera pas fonction du nombre de langues dont vous avez besoin pour soutenir.

### Télécharger

  Polyglot est disponible comme une ruby gem, ou comme un plugin Jekyll. Il peut être installé avec:
  {% highlight bash %}
  gem install 'jekyll-polyglot'
  {% endhighlight %}
