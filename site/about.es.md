---
layout: page
title: Sobre
permalink: about/
lang: es
---
<p class="message">
  <b>Polyglot</b> es un plugin de código abierto de internacionalización para blogs <a href="http://jekyllrb.com">Jekyll</a>. Polyglot es fácil de configurar y usar con cualquier proyecto, y escala a los idiomas que deseas soportar. Con soporte de respaldo para contenido faltante, relativización automática de URL, y <a href="{{site.baseurl}}/seo/">potentes recetas SEO</a>, Polyglot permite a cualquier blog multilingüe centrarse en el contenido sin el trabajo tedioso.
</p>

_`jekyll-polyglot` aún no es soportado nativamente en github-actions_

### Instalación

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### Gestión de idiomas soportados

En `_config.yml`, las siguientes propiedades gestionan qué idiomas son soportados por tu sitio web. Puedes proporcionar soporte para un nuevo idioma agregándolo a estos valores (ver abajo). Los idiomas se identifican por sus [códigos de localización](https://developer.chrome.com/webstore/i18n) oficiales.
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` un array de códigos de localización que identifican los idiomas soportados por el sitio web.
* `default_lang:` idioma predeterminado para el sitio web.
* `exclude_from_localization:` carpetas y directorios que son parte del sitio web construido, pero no necesitan ser localizados. Esto es principalmente para reducir los tiempos de construcción, y debido a que archivos de recursos como imágenes y fuentes son grandes partes del sitio web, asegura que no sean innecesariamente "traducidos" o duplicados en la salida.
* `url` la url de tu sitio web estático de producción.

### Agregar un nuevo idioma
Asumiendo que ya tienes un sitio web funcional en un solo idioma, agregar un nuevo idioma no será trivial. _Para realmente crear un sitio web multilingüe, debes esperar tener que recrear todo tu contenido en el nuevo idioma._ Esto puede parecer una gran tarea, pero considera la traducción en partes. El contenido es rey; es más importante que las nuevas páginas y publicaciones obtengan traducciones actualizadas. Crear un sitio web multilingüe solo es difícil si requieres que esté perfectamente traducido desde el principio.

Primero, tú (y tu equipo, y también tus gerentes si tienes algunos) deben discutir y elegir qué contenido necesitan traducir para el nuevo sitio web. Debes elegir tu contenido básico preferido para traducir. Considera análisis, páginas y publicaciones populares, y el flujo de usuarios actuales y futuros a tu sitio web. En caso de duda, prioriza las páginas sobre las publicaciones de blog antiguas. Si significa lanzar un nuevo idioma antes, las publicaciones antiguas pueden requerir más esfuerzo del que valen para traducir.

Segundo, debes (o deberías fuertemente) proporcionar una cobertura del 100% del contenido rico en tu sitio. Estas son pequeñas cadenas incrustadas de maneras más complejas. Hay múltiples formas de iterar sobre el contenido rico. Recuerda, debes soportar todas las pequeñas cadenas en todos los idiomas en tu contenido rico.

#### Contenido multilingüe
El contenido del sitio web viene en dos sabores: **básico** y **rico**.

El contenido básico es el texto plano de publicaciones de blog, páginas y contenido no interactivo. Piensa en páginas y publicaciones. El contenido básico es el combustible para los clics de tu sitio web. Polyglot proporciona soporte de respaldo para el contenido básico.

El contenido rico es interactivo, llamativo y compuesto de cadenas más cortas. Piensa en barras de navegación y menús desplegables. El contenido rico es más técnico y mantiene a tus visitantes en el sitio. _No hay soporte de respaldo para el contenido rico faltante._

#### Herramientas Liquid
Las siguientes herramientas Liquid están disponibles para usar con jekyll-polyglot:

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages` apunta directamente al array `languages` en _config.yml. Se puede acceder a través de Liquid.

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang` apunta directamente a la cadena `default_lang` en _config.yml. Se puede acceder a través de Liquid.

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}
`site.active_lang` es el código de localización para el que se está construyendo la página. Esto es `"de"` para la versión alemana de una página, `"es"` para la versión española, y así sucesivamente. Se puede acceder a través de Liquid.

Usando estas herramientas, puedes especificar cómo adjuntar el contenido rico correcto.

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

La variable `page.rendered_lang` indica el idioma real del contenido de una página, permitiendo que las plantillas detecten cuando una página se está sirviendo como contenido de respaldo.

### Soporte de Github Pages
Por defecto, Github impide que los [blogs Jekyll usen plugins](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides). Esto se hace intencionalmente para evitar que código malicioso se ejecute en los servidores de Github. Aunque esto hace que usar Polyglot (y otros plugins de Jekyll) sea más difícil, todavía es posible.

#### Construir `_site/` a gh-pages
En lugar de alojar tu motor de blog Jekyll en Github, puedes desarrollar tu sitio web Jekyll en una rama separada, y luego empujar el contenido construido `_site/` a tu rama `gh-pages`. Esto te permite gestionar y controlar la versión de tu desarrollo de sitio web con Github *¡sin tener que depender de Github para construir tu sitio web!*

Puedes hacer esto manteniendo tu contenido Jekyll en una rama separada, y solo haciendo commit de la carpeta `_site/` a tu rama gh-pages. Debido a que estas son solo páginas HTML estáticas en carpetas, Github las alojará como cualquier otro contenido [gh-pages](https://pages.github.com/).

#### ¡Automatízalo!

Este proceso se ayuda enormemente con un simple script que construirá tu sitio web y hará commit de la carpeta `_site/` a tu gh-pages. Mucha gente tiene uno. [Aquí hay uno](http://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/). [Aquí hay otro](https://gist.github.com/cobyism/4730490). Aquí está [mi script de publicación](https://github.com/untra/polyglot/blob/main/publi.sh):
```bash
#! /bin/sh
# cambia los nombres de las ramas apropiadamente
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
