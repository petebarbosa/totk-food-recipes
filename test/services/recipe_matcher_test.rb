# frozen_string_literal: true

require "test_helper"

class RecipeMatcherTest < ActiveSupport::TestCase
  # Tests for can_accommodate_ingredient? method
  test "can_accommodate_ingredient? returns true when ingredient tag matches category requirement" do
    apple = ingredients(:apple)
    simmered_fruit = recipes(:simmered_fruit)

    matcher = RecipeMatcher.new([apple])
    assert matcher.send(:can_accommodate_ingredient?, simmered_fruit, apple)
  end

  test "can_accommodate_ingredient? returns false when ingredient tags do not match any requirement" do
    apple = ingredients(:apple)
    mushroom_skewer = recipes(:mushroom_skewer)

    matcher = RecipeMatcher.new([apple])
    assert_not matcher.send(:can_accommodate_ingredient?, mushroom_skewer, apple)
  end

  test "can_accommodate_ingredient? returns true when ingredient matches specific requirement" do
    apple = ingredients(:apple)
    apple_pie = recipes(:apple_pie)

    matcher = RecipeMatcher.new([apple])
    assert matcher.send(:can_accommodate_ingredient?, apple_pie, apple)
  end

  # Tests for can_accommodate_all_ingredients? method
  test "can_accommodate_all_ingredients? returns true when all ingredients have matching tags" do
    apple = ingredients(:apple)
    mushroom = ingredients(:hylian_shroom)
    fruit_mushroom_mix = recipes(:fruit_and_mushroom_mix)

    matcher = RecipeMatcher.new([apple, mushroom])
    assert matcher.send(:can_accommodate_all_ingredients?, fruit_mushroom_mix)
  end

  test "can_accommodate_all_ingredients? returns false when one ingredient has no matching tag" do
    apple = ingredients(:apple)
    mushroom = ingredients(:hylian_shroom)
    simmered_fruit = recipes(:simmered_fruit)

    matcher = RecipeMatcher.new([apple, mushroom])
    # Simmered Fruit only has Fruit requirement, Mushroom cannot be accommodated
    assert_not matcher.send(:can_accommodate_all_ingredients?, simmered_fruit)
  end

  test "can_accommodate_all_ingredients? returns true for empty ingredients" do
    simmered_fruit = recipes(:simmered_fruit)

    matcher = RecipeMatcher.new([])
    assert matcher.send(:can_accommodate_all_ingredients?, simmered_fruit)
  end

  # Tests for all_matching_recipes filtering
  test "all_matching_recipes excludes recipes that cannot accommodate all ingredients" do
    apple = ingredients(:apple)
    mushroom = ingredients(:hylian_shroom)

    matcher = RecipeMatcher.new([apple, mushroom])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    assert_includes recipe_names, "Fruit and Mushroom Mix"
    refute_includes recipe_names, "Simmered Fruit"
    refute_includes recipe_names, "Mushroom Skewer"
  end

  test "single ingredient shows all recipes that accept that tag" do
    apple = ingredients(:apple)

    matcher = RecipeMatcher.new([apple])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # Apple has tags ["Fruit", "Apple"], so it matches:
    # - Simmered Fruit (requires Fruit)
    # - Fruit and Mushroom Mix (requires Fruit)
    # - Apple Pie (requires Apple - specific)
    # - Fruit Pie (requires Fruit)
    assert_includes recipe_names, "Simmered Fruit"
    assert_includes recipe_names, "Fruit and Mushroom Mix"
  end

  test "single mushroom ingredient shows mushroom-compatible recipes" do
    mushroom = ingredients(:hylian_shroom)

    matcher = RecipeMatcher.new([mushroom])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    assert_includes recipe_names, "Mushroom Skewer"
    assert_includes recipe_names, "Fruit and Mushroom Mix"
    refute_includes recipe_names, "Simmered Fruit"
  end

  test "multiple same-category ingredients are accommodated by category requirement" do
    apple = ingredients(:apple)
    golden_apple = ingredients(:golden_apple)

    matcher = RecipeMatcher.new([apple, golden_apple])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # Simmered Fruit accepts "Fruit" category, so both apples can be accommodated
    assert_includes recipe_names, "Simmered Fruit"
  end

  test "incompatible ingredients return no matching standard recipes" do
    apple = ingredients(:apple)
    meat = ingredients(:raw_meat)

    matcher = RecipeMatcher.new([apple, meat])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # No recipe in fixtures accepts both Fruit and Meat
    refute_includes recipe_names, "Simmered Fruit"
    refute_includes recipe_names, "Meat Skewer"
  end

  test "specific ingredient requirement is accommodated correctly" do
    apple = ingredients(:apple)
    wheat = ingredients(:tabantha_wheat)
    sugar = ingredients(:cane_sugar)
    butter = ingredients(:goat_butter)

    matcher = RecipeMatcher.new([apple, wheat, sugar, butter])
    recipes = matcher.all_matching_recipes
    recipe_names = recipes.map { |r| r[:recipe].name }

    # Apple Pie requires all these specific ingredients
    assert_includes recipe_names, "Apple Pie"
  end
end
