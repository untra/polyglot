---
layout: page
title: אודות
permalink: about/
lang: he
---
<p class="message">
  <b>Polyglot</b> הוא תוסף קוד פתוח לבינאום עבור בלוגים של <a href="http://jekyllrb.com">Jekyll</a>. Polyglot קל להתקנה ולשימוש בכל פרויקט, והוא מתרחב לשפות שתרצו לתמוך בהן. עם תמיכה בגיבוי לתוכן חסר, יחסיות אוטומטית של כתובות URL, ו<a href="{{site.baseurl}}/seo/">מתכוני SEO עוצמתיים</a>, Polyglot מאפשר לכל בלוג רב-לשוני להתמקד בתוכן ללא עבודה מייגעת.
</p>

_`jekyll-polyglot` עדיין אינו נתמך באופן מקורי ב-github-actions_

### התקנה

{% highlight bash %}
gem install jekyll-polyglot
{% endhighlight %}

### ניהול שפות נתמכות

בקובץ `_config.yml`, המאפיינים הבאים מנהלים אילו שפות נתמכות באתר שלכם. תוכלו להוסיף תמיכה בשפה חדשה על ידי הוספתה לערכים אלה (ראו למטה). שפות מזוהות לפי [קודי המקום](https://developer.chrome.com/webstore/i18n) הרשמיים שלהן.
```yml
languages: ["en", "es", "fr", "de"]
default_lang: "en"
exclude_from_localization: ["images", "fonts", "sitemap"]
url: https://polyglot.untra.io
```
* `languages:` מערך של קודי מקום המזהים את השפות הנתמכות באתר.
* `default_lang:` שפת ברירת המחדל של האתר.
* `exclude_from_localization:` תיקיות וספריות שהן חלק מהאתר הבנוי, אך אינן צריכות להיות מתורגמות. זה בעיקר כדי לקצר זמני בנייה, ומכיוון שקבצי נכסים כמו תמונות וגופנים הם חלקים גדולים מהאתר, מבטיח שלא "יתורגמו" או ישוכפלו שלא לצורך בפלט.
* `url` כתובת ה-URL של אתר הייצור הסטטי שלך.

### הוספת שפה חדשה
בהנחה שכבר יש לכם אתר פונקציונלי בשפה אחת, הוספת שפה חדשה לא תהיה טריוויאלית. _כדי ליצור באמת אתר רב-לשוני, עליכם לצפות שתצטרכו ליצור מחדש את כל התוכן שלכם בשפה החדשה._ זה אולי נראה כמשימה גדולה, אבל שקלו את התרגום בחלקים. תוכן הוא המלך; חשוב יותר שדפים ופוסטים חדשים יקבלו מילים מתורגמות. יצירת אתר רב-לשוני קשה רק אם אתם דורשים שיהיה מתורגם בצורה מושלמת מההתחלה.

ראשית, אתם (והצוות שלכם, וגם המנהלים שלכם אם יש לכם כמה כאלה) צריכים לדון ולבחור איזה תוכן אתם צריכים לתרגם לאתר החדש. עליכם לבחור את התוכן הבסיסי המועדף לתרגום. שקלו אנליטיקס, דפים ופוסטים פופולריים, וזרימת המשתמשים הנוכחיים והעתידיים לאתר שלכם. כאשר יש ספק, תעדיפו דפים על פני פוסטים ישנים. אם זה אומר להשיק שפה חדשה מוקדם יותר, פוסטים ישנים עשויים לדרוש יותר מאמץ ממה שהם שווים בתרגום.

שנית, עליכם (או מומלץ מאוד) לספק כיסוי של 100% לתוכן עשיר ברחבי האתר. אלה מחרוזות קטנות המוטמעות בדרכים מורכבות יותר. ישנן מספר דרכים לעבור על תוכן עשיר. זכרו, עליכם לתמוך בכל המחרוזות הקטנות בכל השפות בתוכן העשיר שלכם.

#### תוכן רב-לשוני
תוכן האתר מגיע בשני טעמים: **בסיסי** ו**עשיר**.

תוכן בסיסי הוא הטקסט השטוח של פוסטים, דפים ותוכן לא אינטראקטיבי. חשבו על דפים ופוסטים. תוכן בסיסי הוא הדלק ללחיצות באתר שלכם. Polyglot נותן לתוכן בסיסי תמיכה בגיבוי.

תוכן עשיר הוא אינטראקטיבי, מרשים ומורכב ממחרוזות קצרות יותר. חשבו על סרגלי ניווט ותפריטים נפתחים. תוכן עשיר הוא יותר טכני, ושומר את המבקרים שלכם באתר. _אין תמיכה בגיבוי לתוכן עשיר חסר._

#### כלי Liquid
כלי ה-Liquid הבאים זמינים לשימוש עם jekyll-polyglot:

* **site.languages**

{% highlight html %}
{% raw %}
{% for lang in site.languages %}
  {{lang}}
{% endfor %}
{% endraw %}
{% endhighlight %}

`site.languages` מצביע ישירות למערך `languages` ב-_config.yml. ניתן לגשת אליו דרך Liquid.

* **site.default_lang**
{% highlight html %}
{% raw %}
  {{site.default_lang}}
{% endraw %}
{% endhighlight %}

`site.default_lang` מצביע ישירות למחרוזת `default_lang` ב-_config.yml. ניתן לגשת אליו דרך Liquid.

* **site.active_lang**
{% highlight html %}
{% raw %}
{% if site.active_lang == "es" %}
  <h1>Hola! Como estas?</h1>
{% endif %}
{% endraw %}
{% endhighlight %}
`site.active_lang` הוא קוד המקום שהדף נבנה עבורו. זה `"de"` עבור הגרסה הגרמנית של דף, `"es"` עבור הגרסה הספרדית, וכן הלאה. ניתן לגשת אליו דרך Liquid.

באמצעות כלים אלה, תוכלו לציין כיצד לצרף את התוכן העשיר הנכון.

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

המשתנה `page.rendered_lang` מציין את השפה בפועל של תוכן הדף, מה שמאפשר לתבניות לזהות מתי דף מוגש כתוכן גיבוי.

### תמיכה ב-Github Pages
כברירת מחדל, Github מונע מ[בלוגים של Jekyll להשתמש בתוספים](https://help.github.com/articles/using-jekyll-with-pages/#configuration-overrides). זה נעשה בכוונה כדי למנוע מקוד זדוני לרוץ על שרתי Github. למרות שזה מקשה על השימוש ב-Polyglot (ותוספים אחרים של Jekyll), זה עדיין אפשרי.

#### בניית `_site/` ל-gh-pages
במקום לארח את מנוע הבלוג של Jekyll שלכם ב-Github, תוכלו לפתח את אתר Jekyll שלכם בענף נפרד, ואז לדחוף את תוכן `_site/` הבנוי לענף `gh-pages` שלכם. זה מאפשר לכם לנהל ולשלוט במקור בפיתוח האתר שלכם עם Github *מבלי להסתמך על Github לבנות את האתר שלכם!*

תוכלו לעשות זאת על ידי שמירת תוכן Jekyll שלכם בענף נפרד, והעלאת רק תיקיית `_site/` לענף gh-pages שלכם. מכיוון שאלה רק דפי HTML סטטיים בתיקיות, Github יארח אותם כמו כל תוכן [gh-pages](https://pages.github.com/) אחר.

#### אוטומציה!

תהליך זה מתייעל מאוד עם סקריפט פשוט שיבנה את האתר שלכם וידחוף את תיקיית `_site/` ל-gh-pages שלכם. הרבה אנשים יש להם כזה. [הנה אחד](http://www.jokecamp.com/blog/Simple-jekyll-deployment-with-a-shell-script-and-github/). [הנה עוד אחד](https://gist.github.com/cobyism/4730490). הנה [סקריפט הפרסום שלי](https://github.com/untra/polyglot/blob/main/publi.sh):
```bash
#! /bin/sh
# שנו את שמות הענפים בהתאם
rm -rf site/_site/
cd site && bundle exec jekyll build && cd ..
git add site/_site/ && git commit -m "$(date)"
git subtree push --prefix site/_site origin gh-pages
```
