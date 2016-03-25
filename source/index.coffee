fs = require 'fs'
stdin = require "stdin"

Stringifier = require "./stringifier"

convertFile = (file) ->
  if file.path.startsWith("test/")
    return null;
  else
    """
      function(require, global, module, exports, PACKAGE) {
        #{file.content};

        return module.exports;
      }
    """

convertPackage = (pkg) ->
  {dependencies, distribution} = pkg

  result = extend {entryPoint: pkg.entryPoint},
    dependencies:
      Object.keys(dependencies).reduce (processed, key) ->
        processed[key] = convertPackage(dependencies[key])
        processed
      , {}
    distribution:
      Object.keys(distribution).reduce (processed, key) ->
        processed[key] = convertFile distribution[key]
        processed
      , {}

stdin (input) ->
  pkg = JSON.parse(input)

  # Write the `require` preamble and require then export the converted package.
  req = fs.readFileSync "#{__dirname}/require.js", 'utf8'
  process.stdout.write req
  process.stdout.write "\nmodule.exports = module.exports.loadPackage(\n"
  process.stdout.write Stringifier(convertPackage(pkg))
  process.stdout.write ");"

extend = (target, sources...) ->
  for source in sources
    for name of source
      target[name] = source[name]

  return target
