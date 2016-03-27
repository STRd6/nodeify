Notes
=====

To convert a pixie package to a file usable in npm/browserify we first download
the package.

    wget https://danielx.net/pixel-editor/master.json

Then run it through our transformer and minify it

    script/prepublish && node dist/convert.js < master.json > out.js
    uglifyjs out.js --mangle --compress > out.min.js

Then browserify it. `--ignore-missing` is required because the minifier doesn't
seem to minify all the calls to `require` that it could.

    browserify out.min.js --ignore-missing > bundle.js

This can then be included in a browser page and do its thing.


Sandboxed runner
----------------

Embed the bundle inside a runner script that will create a sandboxed iframe,
hook up postmaster, and return an object that can dispatch messages back and
forth easily.
