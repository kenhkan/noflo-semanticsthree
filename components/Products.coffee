noflo = require "noflo"

class Products extends noflo.Component
  constructor: ->

    @inPorts =
      in: new noflo.Port
      key: new noflo.Port
      secret: new noflo.Port
    @outPorts =
      out: new noflo.Port
      error: new noflo.Port

    @inPorts.key.on "data", (@key) => @login()
    @inPorts.secret.on "data", (@secret) => @login()

    @inPorts.in.on "data", (field) ->
      throw new Error "No API key and/or secret associated yet" unless @sem3?

      @sem3.products.products_field.apply @sems3.products, field

    @inPorts.in.on "disconnect", ->
      @sem3.products.get_products (err, products) ->
        if err?
          @outPorts.error.send err
          @outPorts.error.disconnect()
        else
          @outPorts.out.send products
          @outPorts.out.disconnect()

  login: ->
    return unless @key? and @secret?

    @sem3 = require("semantics3-node") @key, @secret

exports.getComponent = -> new Products
