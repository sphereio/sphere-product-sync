debug = require('debug')('sphere-product-import:enum-validator')
_ = require 'underscore'
_.mixin require 'underscore-mixins'
Promise = require 'bluebird'
slugify = require 'underscore.string/slugify'
{SphereClient} = require 'sphere-node-sdk'

class EnumValidator

  constructor: (@logger, @client) ->
    @_resetCache()
    if @logger then @logger.info "Enum Validator initialized."

  _resetCache: ->
    @_cache =
      productTypeEnumMap: {}

  validateProduct: (product, productType) =>
    # fetch all enum attributes of all variants of the product.
    # check if the product type exists in the cache
      # if not then extract all enum attributes from product type and put in cache map
    # foreach attribute
      # check if attribute exists in the enum map
        # if not then reject the product
      # check if slugified version of attribute value exists as a key in enum map
        # if not then create an update action
        # add the slugified attribute value as key and orginal value as label
        # if type is of lenum, then add slugified value as key and original value for all languages as label
    # to validate a product enums we need:
      # product type of that product
      # attribute names of type enum or lenum or set of enum or set of lenum
      #
    Promise.resolve()

  _fetchEnumAttributesFromProduct: (product) ->
    enumAttributes = @_fetchEmumAttributesFromVariant(product.masterVariant)
    if product.variants and not _.isEmpty(product.variants)
      for variant in product.variants
        enumAttributes = enumAttributes.concat(@_fetchEmumAttributesFromVariant(variant))
    enumAttributes


  _fetchEmumAttributesFromVariant: (variant) ->
    _.filter(variant.attributes, @_enumFilterPredicate)
      .concat(_.filter(variant.attributes, @_enumSetFilterPredicate))
      .concat(_.filter(variant.attributes, @_lenumSetFilterPredicate))


  _enumFilterPredicate: (attribute) ->
    attribute.type.name is 'enum' or attribute.type.name is 'lenum'

  _enumSetFilterPredicate: (attribute) ->
    attribute.type.name is 'set' and attribute.type.name.elementType is 'enum'

  _lenumSetFilterPredicate: (attribute) ->
    attribute.type.name is 'set' and attribute.type.name.elementType is 'lenum'

module.exports = EnumValidator