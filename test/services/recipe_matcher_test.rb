# frozen_string_literal: true

require "test_helper"

class RecipeMatcherTest < ActiveSupport::TestCase
  test "single ingredient shows fully matched and promising partial recipes" do
    apple = ingredients(:apple)

    matcher = RecipeMatcher.new([ apple ])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # Simmered Fruit is fully matched (requires 1 Fruit)
    assert_includes recipe_names, "Simmered Fruit"
    # Fruit and Mushroom Mix is a promising partial (requires 2, could use more ingredients)
    assert_includes recipe_names, "Fruit and Mushroom Mix"
    # Mushroom Skewer doesn't match at all
    refute_includes recipe_names, "Mushroom Skewer"
  end

  test "single mushroom shows fully matched and promising partial recipes" do
    mushroom = ingredients(:hylian_shroom)

    matcher = RecipeMatcher.new([ mushroom ])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # Mushroom Skewer is fully matched
    assert_includes recipe_names, "Mushroom Skewer"
    # Fruit and Mushroom Mix is a promising partial
    assert_includes recipe_names, "Fruit and Mushroom Mix"
    # Simmered Fruit doesn't match mushroom
    refute_includes recipe_names, "Simmered Fruit"
  end

  test "multiple same-category ingredients show matching recipes" do
    apple = ingredients(:apple)
    golden_apple = ingredients(:golden_apple)

    matcher = RecipeMatcher.new([ apple, golden_apple ])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # Simmered Fruit uses 1 fruit (fully matched)
    assert_includes recipe_names, "Simmered Fruit"
  end

  test "specific ingredient requirement is accommodated correctly" do
    apple = ingredients(:apple)
    wheat = ingredients(:tabantha_wheat)
    sugar = ingredients(:cane_sugar)
    butter = ingredients(:goat_butter)

    matcher = RecipeMatcher.new([ apple, wheat, sugar, butter ])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # Apple Pie requires all 4 specific ingredients - fully matched using all
    assert_includes recipe_names, "Apple Pie"
    # Fruit Pie also uses 4 ingredients - fully matched
    assert_includes recipe_names, "Fruit Pie"
  end

  # Tests for the bug fixes

  test "extra ingredients in pot do not prevent recipe matching" do
    meat = ingredients(:raw_meat)
    spicy_pepper = ingredients(:spicy_pepper)
    cool_safflina = ingredients(:cool_safflina)

    matcher = RecipeMatcher.new([ meat, spicy_pepper, cool_safflina ])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # Pepper Steak requires [Meat] + [Specific:Spicy Pepper] = uses 2 ingredients
    # Cool Safflina is extra - should not prevent match
    assert_includes recipe_names, "Pepper Steak"
  end

  test "steamed meat matches with meat and plant ingredient" do
    meat = ingredients(:raw_meat)
    radish = ingredients(:hearty_radish)

    matcher = RecipeMatcher.new([ meat, radish ])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # Steamed Meat uses both ingredients (Meat + Plant) - fully matched
    assert_includes recipe_names, "Steamed Meat"
  end

  test "recipes with specific requirements are prioritized over category-only recipes" do
    meat = ingredients(:raw_meat)
    spicy_pepper = ingredients(:spicy_pepper)
    stamella_shroom = ingredients(:stamella_shroom)

    matcher = RecipeMatcher.new([ meat, spicy_pepper, stamella_shroom ])
    recipes = matcher.all_matching_recipes

    # Both Pepper Steak and Meat and Mushroom Skewer use 2 ingredients
    # But Pepper Steak has a specific requirement (Spicy Pepper) so it should rank first
    assert_equal "Pepper Steak", recipes.first[:recipe].name
  end

  test "best match returns pepper steak over meat and mushroom skewer" do
    meat = ingredients(:raw_meat)
    spicy_pepper = ingredients(:spicy_pepper)
    stamella_shroom = ingredients(:stamella_shroom)

    matcher = RecipeMatcher.new([ meat, spicy_pepper, stamella_shroom ])
    best = matcher.best_match

    # Pepper Steak should win because it has a specific requirement
    assert_equal "Pepper Steak", best[:recipe].name
    assert best[:fully_matched]
  end

  test "when no recipe uses all ingredients show best fully matched and suggestions" do
    apple = ingredients(:apple)
    meat = ingredients(:raw_meat)

    matcher = RecipeMatcher.new([ apple, meat ])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # No recipe uses both Apple and Meat, max fully matched uses 1
    # Both Simmered Fruit and Meat Skewer are fully matched using 1 ingredient
    assert_includes recipe_names, "Meat Skewer"
    assert_includes recipe_names, "Simmered Fruit"
  end

  test "two ingredients matching one recipe only shows that recipe" do
    apple = ingredients(:apple)
    mushroom = ingredients(:hylian_shroom)

    matcher = RecipeMatcher.new([ apple, mushroom ])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # Fruit and Mushroom Mix uses both ingredients (max = 2)
    assert_includes recipe_names, "Fruit and Mushroom Mix"
    # Single-ingredient recipes should NOT show (they use fewer ingredients)
    refute_includes recipe_names, "Simmered Fruit"
    refute_includes recipe_names, "Mushroom Skewer"
  end

  test "best match prioritizes fully matched recipes" do
    meat = ingredients(:raw_meat)
    radish = ingredients(:hearty_radish)

    matcher = RecipeMatcher.new([ meat, radish ])
    best = matcher.best_match

    # Steamed Meat is fully matched (both requirements satisfied)
    assert_equal "Steamed Meat", best[:recipe].name
    assert best[:fully_matched]
  end

  test "raw meat and spicy pepper only shows pepper steak" do
    meat = ingredients(:raw_meat)
    spicy_pepper = ingredients(:spicy_pepper)

    matcher = RecipeMatcher.new([ meat, spicy_pepper ])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # Pepper Steak uses both ingredients (max = 2)
    assert_includes recipe_names, "Pepper Steak"
    # Single-ingredient recipes should NOT show
    refute_includes recipe_names, "Meat Skewer"
    refute_includes recipe_names, "Simmered Fruit"
    refute_includes recipe_names, "Honeyed Fruits"
  end

  test "single raw meat shows meat skewer and promising recipes like pepper steak" do
    meat = ingredients(:raw_meat)

    matcher = RecipeMatcher.new([ meat ])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # Meat Skewer is fully matched (uses 1 ingredient)
    assert_includes recipe_names, "Meat Skewer"
    # Pepper Steak is a promising partial (requires 2, suggests adding Spicy Pepper)
    assert_includes recipe_names, "Pepper Steak"
    # Steamed Meat is also a promising partial (requires 2)
    assert_includes recipe_names, "Steamed Meat"
  end

  test "fully matched recipes appear before partial matches in results" do
    meat = ingredients(:raw_meat)

    matcher = RecipeMatcher.new([ meat ])
    recipes = matcher.all_matching_recipes

    # First recipe should be fully matched
    assert recipes.first[:fully_matched], "First recipe should be fully matched"

    # Find a partial match
    partial = recipes.find { |r| !r[:fully_matched] }
    fully_matched_index = recipes.index { |r| r[:fully_matched] }
    partial_index = recipes.index(partial) if partial

    # All fully matched should come before partial matches
    if partial
      assert fully_matched_index < partial_index, "Fully matched recipes should appear before partial matches"
    end
  end
end
