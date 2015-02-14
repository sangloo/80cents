"use strict"
Hope        = require("zenserver").Hope
Collection  = require "../common/models/collection"
Product     = require "../common/models/product"
Session     = require "../common/session"
C           = require "../common/constants"

module.exports = (zen) ->

  zen.get "/collection/:id", (request, response) ->
    Hope.join([ ->
      Session request, response, redirect = true
    , ->
      Collection.search _id: request.parameters.id, visibility: true, limit = 1
    ]).then (errors, values) ->
      bindings =
        page        : "home"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        collection  : values[1]
      response.page "base", bindings, ["store.header", "store.collection", "store.footer"]


  zen.get "/product/:id", (request, response) ->
    Hope.join([ ->
      Session request, response, redirect = true
    , ->
      Collection.search visibility: true
    , ->
      filter = _id: request.parameters.id, visibility: true
      Product.search filter, limit = 1, null, populate = "collection_id"
    ]).then (errors, values) ->
      bindings =
        page        : "product"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        collections : values[1]
        product     : values[2]?.parse()
      response.page "base", bindings, ["store.header", "store.product", "store.footer"]


  zen.get "/profile", (request, response) ->
    response.json page: "profile"


  zen.get "/about", (request, response) ->
    response.json page: "about"


  zen.get "/", (request, response) ->
    Hope.join([ ->
      Session request, response, redirect = true
    , ->
      Collection.search visibility: true
    , ->
      Product.search visibility: true, highlight: true
    ]).then (errors, values) ->
      bindings =
        page        : "home"
        asset       : "store"
        host        : C.HOST[global.ZEN.type.toUpperCase()]
        session     : values[0]
        collections : values[1]
        products    : (product.parse() for product in values[2])
      response.page "base", bindings, ["store.header", "store.home", "store.footer"]
