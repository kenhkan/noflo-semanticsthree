# Semantics3 Wrapper <br/>[![Build Status](https://secure.travis-ci.org/kenhkan/noflo-semanticsthree.png?branch=master)](http://travis-ci.org/kenhkan/noflo-semanticsthree) [![Dependency Status](https://gemnasium.com/kenhkan/noflo-semanticsthree.png)](https://gemnasium.com/kenhkan/noflo-semanticsthree) [![NPM version](https://badge.fury.io/js/noflo-semanticsthree.png)](http://badge.fury.io/js/noflo-semanticsthree) [![Stories in Ready](https://badge.waffle.io/kenhkan/noflo-semanticsthree.png)](http://waffle.io/kenhkan/noflo-semanticsthree)

Wrapper around Semantics3/semantics3-node

## Testing

This package is not tested automatically because it requires a Semantics3
key/secret pair. Please run `grunt test:all` manually to test.

## Usage

Take a look at
[Semantics3/semantics3-node](https://github.com/Semantics3/semantics3-node)
first.

### Component *Client* ###

Create a Semantics3 client object given the account key and the secret
of your account.

#### In-ports

  * KEY: the account key
  * SECRET: the secret

#### Out-ports

  * OUT: a Semantics3 client object

### Component *Products* ###

Implements [nested search
query](https://github.com/Semantics3/semantics3-node#nested-search-query)
for products.

#### In-ports

  * IN: an object containing the fields. The value can be an array.
    Query is submitted upon for each incoming packet.
  * CLIENT: a Semantics3 client object created by `Client` component

#### Out-ports

  * OUT: an object parsed from the JSON response from Semantics3
  * ERROR: the error object

#### Examples

Find all "Computers and Accessories" that are on newegg.com.

    'key' -> KEY Client(semanticsthree/Client)
    'secret' -> SECRET Client() OUT -> CLIENT Products(semanticsthree/Products)

    '{"cat_id": 4992, "sitedetails": ["name", "newegg.com"]}' -> IN ParseJson(strings/ParseJson) OUT -> IN Products()

    # Prints out the result object
    Products() OUT -> IN Output(Output)
    # Prints out an error
    Products() ERROR -> IN Error(Output)
