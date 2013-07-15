noflo = require 'noflo'

if typeof process is 'object' and process.title is 'node'
  chai = require 'chai' unless chai
  Client = require '../components/Client.coffee'
else
  Client = require 'semanticsThree/components/Client.js'

describe 'Client component', ->
  c = null
  ins = null
  out = null

  unless process.env?
    return console.log '*** NOTE: testing only works in Node.js'

  beforeEach ->
    c = Client.getComponent()
    c.inPorts.key.attach noflo.internalSocket.createSocket()
    c.inPorts.secret.attach noflo.internalSocket.createSocket()
    c.outPorts.out.attach noflo.internalSocket.createSocket()

    unless process.env.SEMANTICS3_KEY
      throw new Error 'Please set your test key to envrionment variable SEMANTICS3_KEY'
    unless process.env.SEMANTICS3_SECRET
      throw new Error 'Please set your test secret to envrionment variable SEMANTICS3_SECRET'

  describe 'when instantiated', ->
    it 'should have input ports', ->
      chai.expect(c.inPorts.key).to.be.an 'object'
      chai.expect(c.inPorts.secret).to.be.an 'object'

    it 'should have an output port', ->
      chai.expect(c.outPorts.out).to.be.an 'object'

  describe 'semantics3 client', ->
    it 'creates a semantics3 client object', (done) ->
      key = c.inPorts.key
      secret = c.inPorts.secret

      c.outPorts.out.on 'data', (client) ->
        chai.expect(client.products).not.to.be.null
      c.outPorts.out.on 'disconnect', ->
        done()

      key.connect()
      key.send process.env.SEMANTICS3_KEY
      key.disconnect()
      secret.connect()
      secret.send process.env.SEMANTICS3_SECRET
      secret.disconnect()
      
