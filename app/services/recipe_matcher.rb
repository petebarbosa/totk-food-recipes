# frozen_string_literal: true

class RecipeMatcher
  attr_reader :ingredients

  def initialize(ingredients_array)
    @ingredients = Array(ingredients_array).compact
  end

  def all_matching_recipes
    return [] if ingredients.empty?

    recipes = Recipe.excluding_special.includes(:recipe_requirements)
    matches = recipes.map do |recipe|
      details = match_details(recipe)
      { recipe: recipe, **details } if details[:matched_count] > 0
    end.compact

    # Sort by percentage descending, then by total requirements ascending (simpler recipes first)
    matches.sort_by { |m| [-m[:percentage], m[:total_required]] }
  end

  def match_details(recipe)
    requirements = recipe.recipe_requirements.reject { |r| r.requirement_type == "logic" }
    return empty_match_details if requirements.empty?

    available_ingredients = ingredients.dup
    matched_requirements = []
    missing_requirements = []

    requirements.each do |requirement|
      matching_index = available_ingredients.find_index { |ing| requirement.matches?(ing) }

      if matching_index
        matched_requirements << {
          requirement: requirement,
          matched_ingredient: available_ingredients[matching_index]
        }
        available_ingredients.delete_at(matching_index)
      else
        missing_requirements << requirement
      end
    end

    total_required = requirements.size
    matched_count = matched_requirements.size
    percentage = (matched_count.to_f / total_required * 100).round

    {
      matched_count: matched_count,
      total_required: total_required,
      matched_requirements: matched_requirements,
      missing_requirements: missing_requirements,
      percentage: percentage,
      fully_matched: matched_count == total_required
    }
  end

  def best_match
    matches = all_matching_recipes
    return dubious_food if matches.empty?

    # Return fully matched recipes, or fall back to partial matches
    fully_matched = matches.select { |m| m[:fully_matched] }
    return fully_matched.first if fully_matched.any?

    matches.first
  end

  def fully_matched_recipes
    all_matching_recipes.select { |m| m[:fully_matched] }
  end

  private

  def empty_match_details
    {
      matched_count: 0,
      total_required: 0,
      matched_requirements: [],
      missing_requirements: [],
      percentage: 0,
      fully_matched: false
    }
  end

  def dubious_food
    recipe = Recipe.find_by(name: "Dubious Food")
    return nil unless recipe

    {
      recipe: recipe,
      matched_count: 0,
      total_required: 1,
      matched_requirements: [],
      missing_requirements: recipe.recipe_requirements,
      percentage: 0,
      fully_matched: true
    }
  end
end
