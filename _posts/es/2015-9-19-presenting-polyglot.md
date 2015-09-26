---
layout: post
title: Introduciendo Polyglot
lang: es
---

Después de meses de trabajo y el refinamiento, me siento orgulloso de presentar **Polyglot**: un plugin para i18n [Jekyll](http://jekyllrb.com) sitios que *necesidad* para atender su contenido a varios idiomas y audiencias.

### Características

Si bien hay otros plugins multi-idioma para Jekyll, Polyglot es especial. Polyglot se encarga de las tonterías típicas normalmente de izquierda a los desarrolladores para gestionar (como discusiones urls y la garantía de mapas de sitio consistentes) mientras que proporciona herramientas eficaces y sencillas desarrolladores Jekyll puede utilizar en SEO y agregación de contenidos vía rápida.

## Url Relativizado

En el pasado, un sitio estático multilenguaje blog o tenían que mantener un registro de lo delicado lenguaje cada enlace relativa sitio estaba sirviendo. Era demasiado fácil para un desarrollador para tropezar, y los visitantes de lengua extranjera de forma rápida se perdiera en el contenido sin traducir.

Polyglot relativiza automáticamente las direcciones url para cada idioma que desea su sitio a construir para. Esto permite que los visitantes del sitio para quedarse aislado en un idioma mientras navega por su sitio web.

## Soporte de Retorno

Cuando *usted no se han* traducido o contenido multilingüe, Jekyll todavía construir con el contenido que tienen. Cuando *usted ha* traducido o contenido multilingüe, Jekyll construirá usando ese contenido. Simple como eso.

Sitemaps mantenerse coherente en todos los idiomas, y se traducen estancias en el sitio que fue construido para.

## Rich Traducción de Contenidos

Idioma de los contenidos Rich es normalmente difícil de implementar. Cadenas cortas o lenguaje banderas dependientes suelen ser difícil para un sitio web Jekyll para mantener constante.

*Excepto cuando es tan fácil*. En su config.yml, simplemente almacenar sus cadenas como:
{% highlight yaml %}
hello:
  en: Hello!
  es: ¡hola!
  fr: Bonjour!
  de: Guten Tag!
{% endhighlight %}
y en su liquid, simplemente llame a:
{% highlight html %}
{% raw %}
{{ site.hello[site.active_lang]}}
{% endraw %}
{% endhighlight %}
produce:
<p class="message">
{{ site.hello[site.active_lang]}}
</p>

## Rápido, Asíncrono, Cero-Overhead Builds

  Polyglot va a construir su sitio web en varios idiomas tan rápido como se va a construir su sitio web idioma predeterminado. Polyglot se ejecuta con una sobrecarga mínima de *simultáneamente* edificio todos los idiomas de su sitio web como proceso independiente. Esto significa que su sitio web el tiempo de construcción no va a ser una función de la cantidad de idiomas que necesita para apoyar.

### Descargar

  Polyglot está disponible como una ruby gem, o como un plugin Jekyll. Se puede instalar con:
  {% highlight bash %}
  gem install 'jekyll-polyglot'
  {% endhighlight %}
