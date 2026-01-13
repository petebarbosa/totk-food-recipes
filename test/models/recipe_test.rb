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
end
