'use strict';

const {src, dest, series, parallel, watch} = require('gulp');
const gulpif = require('gulp-if');
const concat = require('gulp-concat');
const sass = require('gulp-sass')(require('sass'));
const sourcemaps = require('gulp-sourcemaps');
const postcss = require('gulp-postcss');
const autoprefixer = require('autoprefixer');
const cssnano = require('cssnano');
const coffee = require('gulp-coffee');
const terser = require('gulp-terser');
const jsonlint = require('gulp-jsonlint');
const {spawn} = require('child_process');

console.log("     _   _ ______ _  _ ____   ");
console.log("    / | / /_  __/ / / / __ \\ ");
console.log("   /  |/ / / / / /_/ / /_/ /  ");
console.log("  / /|  / / / / __  / ____/   ");
console.log(" /_/ |_/ /_/ /_/ /_/_/        ");
console.log("");


function run(cmd, args) {
    return function (done) {
        const child = spawn(cmd, args, {stdio: 'inherit', shell: false});
        child.on('close', function (code) {
            done(code ? new Error(cmd + ' exited with code ' + code) : undefined);
        });
    };
}

const bundle = (...cmd) => run('bundle', ['exec', ...cmd]);
const coffeeBin = (script) => run('npx', ['coffee', script]);

// Late files: copied straight into _site, bypassing Jekyll.
// Prevents need for processing lib directory and keeps them off the sitemap.

const LIB_FILES = [
    ['node_modules/@fortawesome/fontawesome-free/webfonts/*', '_site/lib/fontawesome/webfonts'],
    ['node_modules/ionicons/fonts/*', '_site/lib/ionicons/fonts'],
    ['node_modules/octicons/octicons/octicons.{eot,svg,ttf,woff}', '_site/lib/octicons'],
    ['node_modules/mapbox-gl/dist/mapbox-gl.css', '_site/lib'],
    ['node_modules/lunr/lunr.min.js', '_site/lib/lunr.js'],
    ['node_modules/tablesorter/dist/js/jquery.tablesorter.js', '_site/lib/tablesorter/dist/js'],
    ['node_modules/tablesorter/dist/css/theme.default.min.css', '_site/lib/tablesorter/dist/css'],
];

const late_files_lib = parallel(...LIB_FILES.map(([from, to]) =>
    function () { return src(from, {encoding: false}).pipe(dest(to)); }));

function late_files_images() {
    return src('images/**', {encoding: false}).pipe(dest('_site/images'));
}

function late_files_root() {
    return src('manifest.json').pipe(dest('_site'));
}

const late_files = parallel(late_files_lib, late_files_images, late_files_root);

// CSS

function css(opts) {
    const processors = [autoprefixer()];
    if (opts.postprocess) {
        processors.push(cssnano());
    }

    return src('_sass/main.sass')
        .pipe(sourcemaps.init())
        .pipe(sass({
            // Legacy sass (bourbon 4, fgrid) triggers a lot of deprecation noise
            quietDeps: true,
            silenceDeprecations: ['import', 'global-builtin', 'slash-div', 'color-functions',
                'function-units', 'abs-percent', 'if-function']
        }).on('error', sass.logError))
        .pipe(postcss(processors))
        .pipe(sourcemaps.write('.'))
        .pipe(dest('_site/css'));
}

const cssBuild = () => css({postprocess: true});
const cssDev = () => css({postprocess: false});

// JS

function js_app(opts) {
    return src('_coffee/app/*.coffee')
        .pipe(sourcemaps.init())
        .pipe(coffee({bare: true}))
        .pipe(concat('app.js'))
        .pipe(gulpif(opts.postprocess, terser()))
        .pipe(sourcemaps.write('.'))
        .pipe(dest('_site/js'));
}

const jsAppBuild = () => js_app({postprocess: true});
const jsAppDev = () => js_app({postprocess: false});

function js_scripts() {
    return src('_coffee/scripts/*.coffee')
        .pipe(sourcemaps.init())
        .pipe(coffee({bare: true}))
        .pipe(sourcemaps.write('.'))
        .pipe(dest('_site/js'));
}

const JS_LIBS = [
    'node_modules/jquery/dist/jquery.js',
    'node_modules/underscore/underscore-umd.js',
    'node_modules/turbolinks/dist/turbolinks.js',
    'node_modules/letteringjs/jquery.lettering.js',
    'node_modules/mousetrap/mousetrap.min.js',
    'node_modules/lunr/lunr.min.js',
    'node_modules/picturefill/dist/picturefill.js',
    'node_modules/moment/moment.js',
    'node_modules/mapbox-gl/dist/mapbox-gl.js',
    'node_modules/raven-js/dist/raven.js'
];

function js_lib(opts) {
    return src(JS_LIBS)
        .pipe(sourcemaps.init())
        .pipe(concat('lib.js'))
        .pipe(gulpif(opts.postprocess, terser()))
        .pipe(sourcemaps.write('.'))
        .pipe(dest('_site/js'));
}

const jsLibBuild = () => js_lib({postprocess: true});
const jsLibDev = () => js_lib({postprocess: false});

// Frontend tasks

const frontend = parallel(cssBuild, jsAppBuild, js_scripts, jsLibBuild);
const frontend_dev = parallel(cssDev, jsAppDev, js_scripts, jsLibDev);

// Jekyll (frontend + late files must exist first, plugins read _site/css)

const JEKYLL_BUILD = ['jekyll', 'build', '--trace', '--profile'];
const jekyll = series(parallel(late_files, frontend), bundle(...JEKYLL_BUILD));
const jekyll_dev = series(parallel(late_files, frontend_dev), bundle(...JEKYLL_BUILD));
const jekyll_inc = series(parallel(late_files, frontend_dev), bundle(...JEKYLL_BUILD, '--incremental'));

// Search indexes

const CMD_INDEX_SEARCH = '_coffee/index/search_index_generator.coffee';
const CMD_INDEX_PEOPLE = '_coffee/index/people_index_generator.coffee';
const index_search = coffeeBin(CMD_INDEX_SEARCH);
const index_people = coffeeBin(CMD_INDEX_PEOPLE);
const indexes = parallel(index_search, index_people);

// Tests

const htmltest = run('_bin/htmltest', []);
const yamllint = run('_bin/yamllint.sh', []);

function jsonlint_feeds() {
    return src('_site/feeds/*.json')
        .pipe(jsonlint())
        .pipe(jsonlint.reporter())
        .pipe(jsonlint.failAfterError());
}

// Server

const serveOn = (host, port) => run('npx', ['serve', '_site', '-l', 'tcp://' + host + ':' + port]);

function watch_frontend() {
    watch(['_sass', '_coffee'], frontend_dev);
}

// Master tasks

// Build site incrementally (debug only), skip some minification
const build_inc = series(jekyll_inc, indexes);
// Build site, skip some minification
const build_dev = series(jekyll_dev, indexes);
// Build site, do all minification
const build_deploy = series(jekyll, indexes);

Object.assign(exports, {
    css: cssBuild,
    css_dev: cssDev,
    js_app: jsAppBuild,
    js_app_dev: jsAppDev,
    js_scripts,
    js_lib: jsLibBuild,
    js_lib_dev: jsLibDev,
    late_files,
    frontend,
    frontend_dev,
    jekyll,
    jekyll_dev,
    jekyll_inc,
    index_search,
    index_people,
    index: indexes,
    htmltest,
    yamllint,
    jsonlint: jsonlint_feeds,
    server: parallel(watch_frontend, serveOn('localhost', 7000)),
    dockerserver: serveOn('0.0.0.0', 8000),
    watch: watch_frontend,
    build: build_dev,
    build_inc,
    build_dev,
    build_deploy,
    test: series(htmltest, jsonlint_feeds),
    default: build_dev,
});
