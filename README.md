# Pixie2Node

Convert pixie packages into bundle-able node/browserify packages.

Notes
-----

To convert a pixie package to a file usable in npm/browserify we first download
the package.

    wget https://danielx.net/pixel-editor/master.json

    script/prepublish && npm run --silent bundle PixelEditor < master.json > bundle.js

This can then be included in a browser page exposing a `PixelEditor` function
that will append an editor inside the element that you pass in.

Ex:

    <html>
    <body>
    <script src="bundle.js"></script>
    <script>
      editor.addAction({
        name: "Test",
        method: function() {
          editor.getBlob()
          .then(function (blob) {
            console.log(blob)
          })
        }
      })
    </script>
    </body>
    </html>

