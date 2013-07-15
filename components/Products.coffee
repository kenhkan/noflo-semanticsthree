noflo = require "noflo"
_ = require "underscore"

class Products extends noflo.Component
  constructor: ->

    @inPorts =
      in: new noflo.Port
      client: new noflo.Port
    @outPorts =
      out: new noflo.Port
      error: new noflo.Port

    @inPorts.client.on "data", (@client) =>

    @inPorts.in.on "data", (fields) =>
      for key, value of fields
        if _.isArray value
          field = value
          field.unshift key
        else
          field = [key]
          field.push value

        @client.products.products_field.apply @client.products, field

      @client.products.get_products (err, products) =>
        if err?
          @outPorts.error.send err
          @outPorts.error.disconnect()
        else
          @outPorts.out.send JSON.parse products
          @outPorts.out.disconnect()

exports.getComponent = -> new Products
