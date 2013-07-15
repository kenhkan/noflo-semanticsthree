# noflo-semantics3 [![Build Status](https://secure.travis-ci.org/kenhkan/noflo-semantics3.png?branch=master)](http://travis-ci.org/kenhkan/noflo-semantics3)

Wrapper around Semantics3/semantics3-node

## Usage

Take a look at
[Semantics3/semantics3-node](https://github.com/Semantics3/semantics3-node)
first.

### Component *Products* ###

Implements [nested search
query](https://github.com/Semantics3/semantics3-node#nested-search-query)
for products.

#### In-ports

  * IN: a stream of packets, each is an array representing a field in
    the query.  Query is submitted upon disconnect.
  * KEY: the API key to use
  * SECRET: the API secret to use

#### Out-ports

  * OUT: an object parsed from the JSON response from Semantics3
  * ERROR: the error object

#### Examples

Find all "Computers and Accessories" that are on newegg.com.

    '[["cat_id", 4992], ["sitedetails", "name", "newegg.com"]' -> IN JSONify(strings/Jsonify) OUT -> IN Split(objects/SplitArray) OUT -> IN Products(semantics3/Products)
    # Prints out the result object
    Products() OUT -> IN Output(Output)
    # Prints out an error
    Products() ERROR -> IN Error(Output)
