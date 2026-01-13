# frozen_string_literal: true

class CookingCalculator
  EFFECT_THRESHOLDS = {
    "Attack Up" => { 1 => 1..4, 2 => 5..6, 3 => 7.. },
    "Defense Up" => { 1 => 1..4, 2 => 5..6, 3 => 7.. },
    "Speed Up" => { 1 => 1..4, 2 => 5..6, 3 => 7.. },
    "Cold Resistance" => { 1 => 1..5, 2 => 6.. },
    "Heat Resistance" => { 1 => 1..5, 2 => 6.. },
    "Shock Resistance" => { 1 => 1..5, 2 => 6.. },
    "Stealth Up" => { 1 => 1..5, 2 => 6..8, 3 => 9.. },
    "Glow" => { 1 => 1..4, 2 => 5..6, 3 => 7.. },
    "Slip Resistance" => { 1 => 1..4, 2 => 5..6, 3 => 7.. }
  }.freeze

  # Effects that don't use levels (raw summation instead)
  RAW_SUMMATION_EFFECTS = ["Extra Hearts", "Stamina Recovery", "Gloom Recovery", "Gloom Resistance"].freeze

  CRITICAL_BONUSES = [
    { type: :hearts, description: "+3 Hearts" },
    { type: :effect_level, description: "+1 Effect Level" },
    { type: :duration, description: "+5:00 Duration" },
    { type: :yellow_hearts, description: "+1 Extra Yellow Heart" },
    { type: :stamina, description: "+2/5 Extra Stamina" }
  ].freeze

  attr_reader :ingredients, :recipe

  def initialize(ingredients_array, recipe = nil)
    @ingredients = Array(ingredients_array).compact
    @recipe = recipe
  end

  def calculate
    return empty_result if ingredients.empty?

    {
      recipe_name: determine_recipe_name,
      hearts_restored: calculate_hearts,
      effect_type: determine_effect_type,
      effect_level: calculate_effect_level,
      effect_points_total: total_effect_points,
      duration_seconds: calculate_duration,
      critical_cook_chance: calculate_critical_chance,
      critical_bonus_preview: preview_critical_bonus,
      ingredients_count: ingredients.size
    }
  end

  private

  def determine_recipe_name
    return recipe.name if recipe

    matcher = RecipeMatcher.new(ingredients)
    best = matcher.best_match
    best ? best[:recipe].name : "Dubious Food"
  end

  def calculate_hearts
    return 1 if dubious_or_rock_hard?

    base = recipe&.base_hearts || 0
    raw_hearts = ingredients.sum(&:hearts_raw)
    (raw_hearts * 2) + base
  end

  def determine_effect_type
    effect_types = ingredients
      .map(&:effect_type)
      .compact
      .reject { |e| e == "None" }
      .uniq

    return nil if effect_types.empty?
    return nil if effect_types.size > 1 # Conflicting effects cancel out

    effect_types.first
  end

  def total_effect_points
    return 0 unless determine_effect_type

    ingredients
      .select { |i| i.effect_type == determine_effect_type }
      .sum(&:effect_points)
  end

  def calculate_effect_level
    effect = determine_effect_type
    return nil unless effect

    points = total_effect_points
    return points if RAW_SUMMATION_EFFECTS.include?(effect)

    thresholds = EFFECT_THRESHOLDS[effect]
    return 1 unless thresholds

    thresholds.each do |level, range|
      return level if range.cover?(points)
    end

    thresholds.keys.max
  end

  def calculate_duration
    return 0 unless determine_effect_type

    base_duration = 30
    ingredients.each do |ingredient|
      base_duration += ingredient.duration_modifier
    end

    base_duration
  end

  def calculate_critical_chance
    return 100 if ingredients.any?(&:critical_cook_guaranteed?)

    10
  end

  def preview_critical_bonus
    effect = determine_effect_type
    applicable_bonuses = CRITICAL_BONUSES.dup

    # Filter bonuses based on current dish type
    applicable_bonuses.reject! { |b| b[:type] == :yellow_hearts } unless effect == "Extra Hearts"
    applicable_bonuses.reject! { |b| b[:type] == :stamina } unless effect == "Stamina Recovery"
    applicable_bonuses.reject! { |b| b[:type] == :effect_level } unless effect && !RAW_SUMMATION_EFFECTS.include?(effect)

    applicable_bonuses.map { |b| b[:description] }
  end

  def dubious_or_rock_hard?
    recipe&.name&.in?(["Dubious Food", "Rock-Hard Food"])
  end

  def empty_result
    {
      recipe_name: nil,
      hearts_restored: 0,
      effect_type: nil,
      effect_level: nil,
      effect_points_total: 0,
      duration_seconds: 0,
      critical_cook_chance: 10,
      critical_bonus_preview: [],
      ingredients_count: 0
    }
  end
end
