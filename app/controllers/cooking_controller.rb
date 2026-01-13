# frozen_string_literal: true

class CookingController < ApplicationController
  before_action :load_pot_ingredients

  def update
    respond_to do |format|
      format.turbo_stream { render_cooking_updates }
      format.html { redirect_to root_path }
    end
  end

  def add_ingredient
    ingredient = Ingredient.find_by(id: params[:ingredient_id])

    if ingredient && @pot_ingredients.size < 5
      @pot_ingredients << ingredient
      session[:pot_ingredient_ids] = @pot_ingredients.map(&:id)
    end

    respond_to do |format|
      format.turbo_stream { render_cooking_updates }
      format.html { redirect_to root_path }
    end
  end

  def remove_ingredient
    slot_index = params[:slot_index].to_i
    ingredient_ids = session[:pot_ingredient_ids] || []

    if slot_index >= 0 && slot_index < ingredient_ids.size
      ingredient_ids.delete_at(slot_index)
      session[:pot_ingredient_ids] = ingredient_ids
      @pot_ingredients = Ingredient.where(id: ingredient_ids).index_by(&:id).values_at(*ingredient_ids).compact
    end

    respond_to do |format|
      format.turbo_stream { render_cooking_updates }
      format.html { redirect_to root_path }
    end
  end

  def select_recipe
    recipe = Recipe.includes(:recipe_requirements).find_by(id: params[:recipe_id])

    if recipe
      # Fill pot with required ingredients for this recipe
      required_ingredients = recipe.recipe_requirements.filter_map do |req|
        case req.requirement_type
        when "specific"
          Ingredient.find_by(name: req.requirement_value)
        when "category"
          Ingredient.where(category: req.requirement_value).first
        end
      end

      @pot_ingredients = required_ingredients.take(5)
      session[:pot_ingredient_ids] = @pot_ingredients.map(&:id)
    end

    respond_to do |format|
      format.turbo_stream { render_cooking_updates }
      format.html { redirect_to root_path }
    end
  end

  def clear
    @pot_ingredients = []
    session[:pot_ingredient_ids] = []

    respond_to do |format|
      format.turbo_stream { render_cooking_updates }
      format.html { redirect_to root_path }
    end
  end

  private

  def load_pot_ingredients
    ingredient_ids = session[:pot_ingredient_ids] || []
    @pot_ingredients = Ingredient.where(id: ingredient_ids).index_by(&:id).values_at(*ingredient_ids).compact
  end

  def render_cooking_updates
    matcher = RecipeMatcher.new(@pot_ingredients)
    @matching_recipes = matcher.all_matching_recipes

    @cooking_result = if @pot_ingredients.any?
      calculator = CookingCalculator.new(@pot_ingredients)
      calculator.calculate
    end

    render turbo_stream: [
      turbo_stream.replace("cooking_pot", partial: "cooking/pot", locals: { ingredients: @pot_ingredients }),
      turbo_stream.replace("recipe_results", partial: "recipes/list", locals: { recipes: @matching_recipes, pot_ingredients: @pot_ingredients }),
      turbo_stream.replace("cooking_result", partial: "cooking/result", locals: { result: @cooking_result }),
      turbo_stream.replace("ingredient_suggestions", partial: "ingredients/search_results", locals: { ingredients: [] })
    ]
  end
end
