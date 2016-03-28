Postmaster = require "./postmaster"

# srcText is jsonified bundle.js
html = """
  <html>
  <head>
  </head>
  <body>
    <script>
      #{srcText.replace(/[^\\]\/script/, '\\/script')}
    <\/script>
  </body>
  </html>
"""
srcURL = URL.createObjectURL(new Blob [html], type: "text/html")

module.exports = (parentElement, handlers) ->
  document = parentElement.ownerDocument

  iframe = document.createElement 'iframe'
  iframe.sandbox = "allow-scripts allow-modals"
  iframe.src = srcURL

  parentElement.appendChild iframe

  postmaster = Postmaster(handlers)
  postmaster.remoteTarget = -> iframe.contentWindow

  # Return a proxy for easy Postmastering
  proxy = new Proxy postmaster,
    get: (target, property, receiver) ->
      (args...) ->
        target.invokeRemote property, args...

  return proxy
