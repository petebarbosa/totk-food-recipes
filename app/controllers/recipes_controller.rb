# frozen_string_literal: true

class RecipesController < ApplicationController
  def index
    @ingredient_ids = params[:ingredient_ids] || []
    @ingredients = Ingredient.where(id: @ingredient_ids)

    if @ingredients.any?
      matcher = RecipeMatcher.new(@ingredients)
      @matching_recipes = matcher.all_matching_recipes
    else
      @matching_recipes = []
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @recipe = Recipe.includes(:recipe_requirements).find(params[:id])
    @match_details = nil

    if params[:ingredient_ids].present?
      ingredients = Ingredient.where(id: params[:ingredient_ids])
      matcher = RecipeMatcher.new(ingredients)
      @match_details = matcher.match_details(@recipe)
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
