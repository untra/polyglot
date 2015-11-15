---
layout: post
title: Polyglot Version 1.1.0
lang: en
---

Polyglot now fully supports [Jekyll 3.0](https://jekyllrb.com/news/2015/10/26/jekyll-3-0-released/) blogs! Go [give it a try!](https://github.com/untra/polyglot)

#### Support for Polyglot v 1.0 gem has been dropped
The original incarnation of Polyglot had a Gemfile because of conflicting Jekyll 2.5.3 dependencies. Since Jekyll 3.0, those dependencies have been eliminated. Whenever a gemfile is not needed, the use of a Gemfile should be avoided. Because a gem is not needed to support Polyglot with Jekyll 3.0, support for the Polyglot 1.0 gem has been dropped. Instead, Users are encouraged to install the polyglot plugin by dropping the [polyglot.rb](https://github.com/untra/polyglot/blob/master/lib/polyglot.rb) file into their `_plugins` folder.
