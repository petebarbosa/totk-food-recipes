# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @pot_ingredients = []
    @matching_recipes = []
    @cooking_result = nil
  end
end
