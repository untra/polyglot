---
layout: page
title: Hakkında
permalink: about/
lang: tr
---
<p class="message">
  <b>Polyglot</b>, <a href="http://jekyllrb.com">Jekyll</a> blogları için açık kaynaklı bir uluslararasılaştırma eklentisidir. Polyglot'u herhangi bir projeyle kurmak ve kullanmak kolaydır ve desteklemek istediğiniz dillere göre ölçeklenir. Eksik içerik için yedek destek, otomatik URL göreceliştirme ve <a href="{{site.baseurl}}/seo/">güçlü SEO tarifleri</a> ile Polyglot, herhangi bir çok dilli blogun gereksiz işler olmadan içeriğe odaklanmasını sağlar.
</p>

_`jekyll-polyglot` henüz github-actions'da yerel olarak desteklenmiyor_

### Kurulum

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### Desteklenen Dilleri Yönetme

`_config.yml` dosyasında, aşağıdaki özellikler web sitenizin hangi dilleri desteklediğini yönetir. Bu değerlere ekleyerek yeni bir dil için destek sağlayabilirsiniz (aşağıya bakın). Diller, resmi [yerel ayar kodları](https://developer.chrome.com/webstore/i18n) ile tanımlanır.
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` web sitesi tarafından desteklenen dilleri tanımlayan yerel ayar kodları dizisi.
* `default_lang:` web sitesi için varsayılan dil.
* `exclude_from_localization:` oluşturulan web sitesinin parçası olan ancak yerelleştirilmesi gerekmeyen klasörler ve dizinler. Bu öncelikle derleme sürelerini kısaltmak içindir ve resimler ve yazı tipleri gibi varlık dosyaları web sitesinin büyük bölümlerini oluşturduğundan, bunların gereksiz yere "çevrilmemesini" veya çıktıda çoğaltılmamasını sağlar.
* `url` üretim statik web sitenizin url'si.

### Yeni Bir Dil Ekleme
Zaten çalışan tek dilli bir web siteniz olduğunu varsayarsak, yeni bir dil eklemek önemsiz olmayacaktır. _Gerçekten çok dilli bir web sitesi yapmak için tüm içeriğinizi yeni dilde yeniden oluşturmanız gerekecektir._ Bu büyük bir girişim gibi görünebilir, ancak çeviriyi parçalar halinde düşünün. İçerik kraldır; yeni sayfaların ve gönderilerin çeviride güncellenmesi daha önemlidir. Çok dilli bir web sitesi yapmak, yalnızca baştan mükemmel çevrilmesini gerektirirseniz zordur.

İlk olarak, siz (ve ekibiniz ve etrafınızda varsa yöneticileriniz de) yeni web sitesine hangi içeriğin çevrilmesi gerektiğini tartışmalı ve seçmelisiniz. Çevirilecek tercih ettiğiniz temel içeriği seçmelisiniz. Analizleri, popüler sayfaları ve blog gönderilerini ve mevcut ve gelecekteki kullanıcıların web sitenize akışını göz önünde bulundurun. Şüphe durumunda, sayfalara eski blog gönderilerinden öncelik verin. Yeni bir dili daha erken başlatmak anlamına geliyorsa, eski gönderileri çevirmek için harcanan çaba, değerine değmeyebilir.

İkinci olarak, siteniz boyunca zengin içeriğin %100 kapsamını sağlamalısınız (veya güçlü bir şekilde sağlamalısınız). Bunlar daha karmaşık şekillerde gömülü küçük dizelerdir. Zengin içerik üzerinde yinelemenin birden fazla yolu vardır. Unutmayın, zengin içeriğinizdeki tüm dil küçük dizelerini desteklemelisiniz.

#### Çok Dilli İçerik
Web sitesi içeriği iki çeşittir: **temel** ve **zengin**.

Temel içerik, blog gönderilerinin, sayfaların ve etkileşimli olmayan içeriğin düz metnidir. Sayfaları ve gönderileri düşünün. Temel içerik, web sitelerinizin tıklamaları için yakıttır. Polyglot, temel içerik için yedek destek sağlar.

Zengin içerik etkileşimli, gösterişli ve daha kısa dizelerden oluşur. Gezinme çubuklarını ve açılır menüleri düşünün. Zengin içerik daha tekniktir ve ziyaretçilerinizi sitede tutar. _Eksik zengin içerik için yedek destek yoktur._

#### Liquid Araçları
Aşağıdaki liquid araçları jekyll-polyglot ile kullanılabilir:

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages` doğrudan _config.yml'deki `languages` dizisine işaret eder. Liquid aracılığıyla erişilebilir.

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang` doğrudan _config.yml'deki `default_lang` dizesine işaret eder. Liquid aracılığıyla erişilebilir.

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}
`site.active_lang`, sayfanın oluşturulduğu yerel ayar kodudur. Bu, bir sayfanın Almanca sürümü için `"de"`, İspanyolca sürümü için `"es"` vb. şeklindedir. Liquid aracılığıyla erişilebilir.

Bu araçları kullanarak, doğru zengin içeriği nasıl ekleyeceğinizi belirleyebilirsiniz.

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

`page.rendered_lang` değişkeni, bir sayfanın içeriğinin gerçek dilini belirtir ve şablonların bir sayfanın yedek içerik olarak sunulup sunulmadığını algılamasını sağlar.

### GitHub Pages Desteği
Varsayılan olarak GitHub, [Jekyll bloglarının eklenti kullanmasını](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides) engeller. Bu, GitHub sunucularında kötü amaçlı kodun çalıştırılmasını önlemek için kasıtlı olarak yapılır. Bu, Polyglot'u (ve diğer Jekyll eklentilerini) kullanmayı zorlaştırsa da, yine de yapılabilir.

#### `_site/`'ı gh-pages'e Oluşturma
Jekyll blog motorunuzu GitHub'da barındırmak yerine, Jekyll web sitenizi ayrı bir dalda geliştirebilir ve ardından oluşturulan `_site/` içeriklerini `gh-pages` dalınıza itebilirsiniz. Bu, web sitesi geliştirmenizi GitHub ile yönetmenize ve sürüm kontrolü yapmanıza olanak tanır *GitHub'ın web sitenizi oluşturmasına güvenmek zorunda kalmadan!*

Bunu, Jekyll içeriğinizi ayrı bir dalda tutarak ve yalnızca `_site/` klasörünü gh-pages dalınıza işleyerek yapabilirsiniz. Bunlar klasörlerdeki statik HTML sayfaları olduğundan, GitHub bunları diğer [gh-pages](https://pages.github.com/) içerikleri gibi barındıracaktır.

#### Otomatikleştirin!

Bu süreç, web sitenizi oluşturacak ve `_site/` klasörünü gh-pages'inize işleyecek basit bir komut dosyasıyla büyük ölçüde kolaylaştırılır. Birçok kişinin böyle bir komut dosyası var. [İşte biri](http://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/). [İşte başka biri](https://gist.github.com/cobyism/4730490). İşte [benim yayınlama komut dosyam](https://github.com/untra/polyglot/blob/main/publi.sh):
```bash
#! /bin/sh
# dal adlarını uygun şekilde değiştirin
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
