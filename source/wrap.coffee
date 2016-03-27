fs = require 'fs'
stdin = require "stdin"

stdin (input) ->
  process.stdout.write "var srcText = #{JSON.stringify(input)};"
  process.stdout.write fs.readFileSync "#{__dirname}/wrapper.js", 'utf8'
