---
layout: docs
group: docs
title: Committees
order: 30
redirect_from:
  - /docs/committees/index.html
---

Committee listings are stored as `_committees/YY_YY.md` with YY_YY being the academic year 'span'.

## <i class="fa fa-tags"></i> Attribute Reference

{% include def-doc.html def=site.data.defs.committee %}

## <i class="octicon octicon-code"></i> Example Committee

{% highlight yaml %}
---
title: 2012-13

committee:
  - role: Station Manager
    name: John Smith
  - role: Treasurer
    name: Jack Doe
  - role: Technical Manager
    name: Lucy Call

comment: "Pretty sure there were more members!"
---
{% endhighlight %}
