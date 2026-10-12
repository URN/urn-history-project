# University Radio Nottingham History Project

[![Build](https://github.com/URN/urn-history-project/actions/workflows/build.yml/badge.svg)](https://github.com/URN/urn-history-project/actions/workflows/build.yml)

The history project collects and publishes information on past shows, committees and outside broadcasts at [University Radio Nottingham](https://urn1350.co.uk).

We use a static site generator ([Jekyll](jekyllrb.com)) among other tools to turn the data and website source hosted here into the website published at [history.urn1350.co.uk](https://history.urn1350.co.uk).

This project is run by [a group](https://history.urn1350.co.uk/humans.txt) from University Radio Nottingham.

## Running locally

Requires Ruby 3.4 (see `.ruby-version`) and Node 22 or newer (see `.nvmrc`).

```sh
bundle install
npm install
npx gulp build     # build the site into _site/
npx gulp server    # serve _site/ on http://localhost:7000, rebuilding CSS/JS on change
```

Re-run `npx gulp build` after changing site content. `npx gulp build_deploy` does the minified production build. CI runs on GitHub Actions (`.github/workflows/build.yml`). A Docker based setup is available via `run_dev.sh`.

## Special Thanks

- [The Nottingham New Theatre History Project](https://github.com/newtheatre/history-project) upon which this is heavily inspired and based.
