---
layout: about
group: about
current: about
title: About This Site
order: 10
permalink: /about/
---


# <i class="octicon octicon-circuit-board fa-fw"></i> {{ page.title }}

This site aims to piece together University Radio Nottingham's varied history from each studio we've broadcast from.

It's still very early days here and we're still looking to fill in recent years! We're ahppy to take any information you want to give, this is all about keeping a record of everything that happened at the station.

Huge thanks goes to The Nottingham New Theatre and there own [history project](https://history.newtheatre.org.uk) on which ours is heavily inspired by both in spirit and from a technical point of view. The years of work their dedicated team has done allowed us to quickly fast track the development of our own project. This site is a modified version of their own, the code for which can be found over on [GitHub](https://github.com/urn/urn-history-project).

<!-- In particular we are looking for: listings of show_type shows, casts and crew lists, photographs, programmes, flyers, reviews and anything else which could provide an insight into the history of the theatre. -->

See the [contributing](/contributing/) section for details on how to help out.

<div class="grid-row">

<div class="grid-8" markdown="1">

## People

{% for person in site.data.humans %}
- **{{ person.role }}:** [{{ person.name }}](/people/{{ person.bio }}/)
{% endfor %}

</div>
<div class="grid-8" markdown="1">

## Build Details

{% assign shows = site.shows %}
{% assign committees = site.committees %}
{% assign people = site.people %}

- Site last updated at {{site.time | date: "%Y-%m-%d %H:%M" }}
- Build number {% include travis_build_number.txt %}.
- {{shows.size}} shows, {{committees.size}} committees and {{people.size}} people.

## Special Thanks

- Browser testing tools generously provided by [BrowserStack](https://www.browserstack.com/).
- Mapping © <a href='https://www.mapbox.com/about/maps/'>Mapbox</a> © <a href='http://www.openstreetmap.org/copyright'>OpenStreetMap</a>
- Once again the [Nottingham New Theatre](http://newtheatre.org.uk/) whose years of work allowed us to quickly fasttrack the development of our own project.

</div>

</div>

## Open codebase

The entire codebase used to build this website is available on [GitHub](https://github.com/urn/urn-history-project). While the project as a whole isn't particularly helpful for other organizations, rather than building an open source project what we're doing can be described as [*coding in the open*](https://gds.blog.gov.uk/2012/10/12/coding-in-the-open/). That said parts of the project may be of interest or use to others. This repository is a mix of source and content, as such there are two licences that apply.

- All source files (HTML templates, Sass, CoffeeScript, Ruby, shell scripts) are released under the [MIT licence](https://opensource.org/licenses/MIT).
- All content files (HTML files, Markdown, YAML datafiles, images, graphics) are Copyright © University Radio Nottingham {{ site.time | date: "%Y" }}.
