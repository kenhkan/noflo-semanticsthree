# noflo-semanticsthree [![Build Status](https://secure.travis-ci.org/kenhkan/noflo-semanticsthree.png?branch=master)](http://travis-ci.org/kenhkan/noflo-semanticsthree)

Wrapper around Semantics3/semantics3-node

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

  * IN: a stream of packets, each is an array representing a field in
    the query.  Query is submitted upon disconnect.
  * CLIENT: a Semantics3 client object created by `Client` component

#### Out-ports

  * OUT: an object parsed from the JSON response from Semantics3
  * ERROR: the error object

#### Examples

Find all "Computers and Accessories" that are on newegg.com.

    'key' -> KEY Client(semanticsthree/Client)
    'secret' -> SECRET Client() OUT -> CLIENT Products(semanticsthree/Products)

    '[["cat_id", 4992], ["sitedetails", "name", "newegg.com"]]' -> IN ParseJson(strings/ParseJson)
    ParseJson() OUT -> IN SplitFields(objects/SplitArray) OUT -> IN Products()

    # Prints out the result object
    Products() OUT -> IN Output(Output)
    # Prints out an error
    Products() ERROR -> IN Error(Output)
