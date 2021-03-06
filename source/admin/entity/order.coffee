"use strict"

class __.Entity.Order extends Atoms.Class.Entity

  @fields "id", "user", "lines", "amount", "comment", "shipping", "billing",
          "discount", "discount_amount", "payment_type", "payment_token",
          "tracking_number", "state",
          "lines"
          "updated_at", "created_at"

  # -- Static Methods
  @createOrUpdate: (attributes) =>
    entity = @findBy "id", attributes.id
    if entity?
      entity.updateAttributes attributes
    else
      @create attributes

  # -- Instance Methods
  parse: ->
    text        : @id
    description : "#{@lines.length} products - #{@amount}"
    info        : @created_at
