# bcapi: simple API for Basecamp, returns data as JSON
# using the super-useful xml2js

# Requires xml2js (npm install xml2js)
# Don't forget to set the HUBOT_BASECAMP_KEY and HUBOT_BASECAMP_URL
# Copy this module into the node_modules directory in hubot

http = require 'scoped-http-client'
xml2js = require 'xml2js'

auth = new Buffer("#{process.env.HUBOT_BASECAMP_KEY}:X").toString('base64')

exports.get = (resource, handler) ->
  basecamp_url = "https://#{process.env.HUBOT_BASECAMP_URL}.basecamphq.com"
  http.create("#{basecamp_url}/#{resource}")
    .headers(Authorization: "Basic: #{auth}", Accept: "application/xml")
    .get() (err, res, body) ->
      if err
        console.log "Error: #{err}"
        return
      new xml2js.Parser().parseString body, (err, result) ->
        if err
          console.log "Parse error: #{err}"
          return
        handler result
  
