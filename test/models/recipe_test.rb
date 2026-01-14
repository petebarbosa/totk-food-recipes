# frozen_string_literal: true

require "test_helper"

class RecipeTest < ActiveSupport::TestCase
  test "validates presence of name" do
    recipe = Recipe.new
    assert_not recipe.valid?
    assert_includes recipe.errors[:name], "can't be blank"
  end

  test "validates uniqueness of name" do
    existing = recipes(:simmered_fruit)
    duplicate = Recipe.new(name: existing.name)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "required_slots_count returns correct count" do
    simmered_fruit = recipes(:simmered_fruit)
    assert_equal 1, simmered_fruit.required_slots_count

    apple_pie = recipes(:apple_pie)
    assert_equal 4, apple_pie.required_slots_count
  end

  test "requirements_summary returns human-readable string" do
    simmered_fruit = recipes(:simmered_fruit)
    summary = simmered_fruit.requirements_summary
    assert_match /Fruit/, summary
  end

  test "special_recipe? returns true for Dubious Food" do
    dubious_food = recipes(:dubious_food)
    assert dubious_food.special_recipe?
  end

  test "special_recipe? returns false for normal recipes" do
    simmered_fruit = recipes(:simmered_fruit)
    assert_not simmered_fruit.special_recipe?
  end

  test "excluding_special scope excludes Dubious Food" do
    recipes = Recipe.excluding_special
    assert_not recipes.pluck(:name).include?("Dubious Food")
  end

  test "matching_ingredient finds recipes matching by category" do
    apple = ingredients(:apple)
    recipes = Recipe.matching_ingredient(apple)
    assert recipes.any?
  end

  # Tests for cookable? method - fire/cold cooked items
  test "cookable? returns false for baked items" do
    recipe = Recipe.new(name: "Baked Apple")
    assert_not recipe.cookable?
  end

  test "cookable? returns false for roasted items" do
    recipe = Recipe.new(name: "Roasted Bass")
    assert_not recipe.cookable?
  end

  test "cookable? returns false for toasty mushrooms" do
    recipe = Recipe.new(name: "Toasty Hylian Shroom")
    assert_not recipe.cookable?
  end

  test "cookable? returns false for toasted items" do
    recipe = Recipe.new(name: "Toasted Hearty Truffle")
    assert_not recipe.cookable?
  end

  test "cookable? returns false for frozen items" do
    recipe = Recipe.new(name: "Frozen Crab")
    assert_not recipe.cookable?
  end

  test "cookable? returns false for icy meats" do
    recipe = Recipe.new(name: "Icy Prime Meat")
    assert_not recipe.cookable?
  end

  test "cookable? returns false for seared steaks" do
    recipe = Recipe.new(name: "Seared Steak")
    assert_not recipe.cookable?
  end

  test "cookable? returns false for other fire-cooked items" do
    assert_not Recipe.new(name: "Blackened Crab").cookable?
    assert_not Recipe.new(name: "Blueshell Escargot").cookable?
    assert_not Recipe.new(name: "Campfire Egg").cookable?
    assert_not Recipe.new(name: "Charred Pepper").cookable?
    assert_not Recipe.new(name: "Hard-boiled Egg").cookable?
    assert_not Recipe.new(name: "Warm Milk").cookable?
  end

  test "cookable? returns false for specific non-cookable names" do
    assert_not Recipe.new(name: "Sneaky River Escargot").cookable?
    assert_not Recipe.new(name: "Bright Mushroom Skewer").cookable?
  end

  test "cookable? returns true for normal pot recipes" do
    assert Recipe.new(name: "Mushroom Skewer").cookable?
    assert Recipe.new(name: "Apple Pie").cookable?
    assert Recipe.new(name: "Meat Curry").cookable?
    assert Recipe.new(name: "Simmered Fruit").cookable?
    assert Recipe.new(name: "Steamed Fish").cookable?
    assert Recipe.new(name: "Glazed Meat").cookable?
  end

  test "cookable? returns true for elixirs" do
    assert Recipe.new(name: "Energizing Elixir").cookable?
    assert Recipe.new(name: "Hasty Elixir").cookable?
    assert Recipe.new(name: "Fireproof Elixir").cookable?
    assert Recipe.new(name: "Sneaky Elixir").cookable?
  end
end
