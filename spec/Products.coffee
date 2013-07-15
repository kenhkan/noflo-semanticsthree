noflo = require "noflo"
semantics3 = require "semantics3-node"

if typeof process is "object" and process.title is "node"
  chai = require "chai" unless chai
  Products = require "../components/Products.coffee"
else
  Products = require "semanticsThree/components/Products.js"

describe "Products component", ->
  c = null
  ins = null
  out = null
  client = null

  unless process.env?
    return console.log "*** NOTE: testing only works in Node.js"

  beforeEach ->
    c = Products.getComponent()
    c.inPorts.client.attach noflo.internalSocket.createSocket()
    c.inPorts.in.attach noflo.internalSocket.createSocket()
    c.outPorts.out.attach noflo.internalSocket.createSocket()

    unless process.env.SEMANTICS3_KEY
      throw new Error "Please set your test account SID to envrionment variable SEMANTICS3_KEY"
    unless process.env.SEMANTICS3_SECRET
      throw new Error "Please set your test auth token to envrionment variable SEMANTICS3_SECRET"

    client = semantics3 process.env.SEMANTICS3_KEY, process.env.SEMANTICS3_SECRET

    cli = c.inPorts.client
    cli.connect()
    cli.send client
    cli.disconnect()

  describe "when instantiated", ->
    it "should have input ports", ->
      chai.expect(c.inPorts.client).to.be.an "object"
      chai.expect(c.inPorts.in).to.be.an "object"

    it "should have an output port", ->
      chai.expect(c.outPorts.out).to.be.an "object"

  describe "semantics3 client", ->
    it "accepts a semantics3 client object", ->
      chai.expect(c.client).to.equal client
      chai.expect(client.products).not.to.be.null

  describe "products", ->
    it "searches with returned results", (done) ->
      ins = c.inPorts.in
      out = c.outPorts.out

      out.on "data", (data) ->
        chai.expect(data.code).to.equal "OK"
        chai.expect(data.results).to.be.an "array"
      out.on "disconnect", ->
        done()

      ins.connect()
      ins.send ["cat_id", 4992]
      ins.send ["sitedetails", "name", "newegg.com"]
      ins.disconnect()

    it "searches with error raised", (done) ->
      ins = c.inPorts.in
      out = c.outPorts.out

      out.on "data", (data) ->
        chai.expect(data.code).to.equal "BadQuery"
        chai.expect(data.results).to.be.undefined
      out.on "disconnect", ->
        done()

      ins.connect()
      ins.send ["blah_id", 4992]
      ins.send ["sitedetails", "name", "newegg.com"]
      ins.disconnect()
