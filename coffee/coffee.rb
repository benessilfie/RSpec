# frozen_string_literal: true

# This is a class that represents a coffee
class Coffee
  def ingredients
    @ingredients ||= []
  end

  def add(ingredient)
    ingredients << ingredient
  end

  def price
    1.0 + ingredients.size * 0.25
  end
end
