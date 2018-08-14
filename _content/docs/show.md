---
layout: docs
group: docs
title: Shows
order: 20
redirect_from:
  - /docs/shows/index.html
---

The show records are stored as `_shows/YY_YY/show_name.md` with YY_YY being the academic year 'span'. The synopsis is the content of the page, i.e. goes after the attribute section.

## <i class="fas fa-tags"></i> Attribute Reference

{% include def-doc.html def=site.data.defs.show %}

## <i class="octicon octicon-code"></i> Example Show

{% highlight yaml %}
---
title: The Game Show
show_type: Daytime
show_type_sort: 70
period: Autumn
venue: Portland A Floor
date_start: 2016-10-12
date_end: 2016-12-15

canonical:
- title: The Pillowman

cast:
  - role: Producer
    name: John Smith
  - role: Presenter
    name: Joe Doe
---

On a Tuesday afternoon be brought into a land of digital wonder as all things gaming are disscused on the show, everything from Mass Effect to F1 to Undertale. Join John and Joe as they regail you with there thoughts of upcoming games and give up to date news of what's going down in the gaming industry.
{% endhighlight %}
