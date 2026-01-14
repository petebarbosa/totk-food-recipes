# frozen_string_literal: true

class RecipeMatcher
  attr_reader :ingredients

  def initialize(ingredients_array)
    @ingredients = Array(ingredients_array).compact
  end

  def all_matching_recipes
    return [] if ingredients.empty?

    recipes = Recipe.excluding_special.includes(:recipe_requirements)

    all_matches = recipes.filter_map do |recipe|
      details = match_details(recipe)
      { recipe: recipe, **details } if details[:matched_count] > 0
    end

    return [] if all_matches.empty?

    fully_matched = all_matches.select { |m| m[:fully_matched] }
    partial_matched = all_matches.reject { |m| m[:fully_matched] }

    if fully_matched.empty?
      # No fully matched recipes, show all partial matches
      return sort_matches(all_matches)
    end

    # Find the max ingredients used by any fully matched recipe
    max_fully_matched_count = fully_matched.map { |m| m[:matched_count] }.max

    # Keep fully matched recipes that use the max ingredients
    best_fully_matched = fully_matched.select { |m| m[:matched_count] == max_fully_matched_count }

    # Also keep partial matches where the recipe's total requirements > max_fully_matched_count
    # These are recipes that COULD use more ingredients if completed (discovery suggestions)
    promising_partial = partial_matched.select { |m| m[:total_required] > max_fully_matched_count }

    sort_matches(best_fully_matched + promising_partial)
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

  def sort_matches(matches)
    matches.sort_by do |m|
      specific_matched_count = m[:matched_requirements].count do |mr|
        mr[:requirement].requirement_type == "specific"
      end
      # Sort by: fully matched first, then specific requirements, then total requirements
      [ m[:fully_matched] ? 0 : 1, -specific_matched_count, -m[:total_required], -m[:percentage] ]
    end
  end

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
