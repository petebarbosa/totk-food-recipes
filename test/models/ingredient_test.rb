# frozen_string_literal: true

require "test_helper"

class IngredientTest < ActiveSupport::TestCase
  test "validates presence of name" do
    ingredient = Ingredient.new(category: "Fruit")
    assert_not ingredient.valid?
    assert_includes ingredient.errors[:name], "can't be blank"
  end

  test "validates presence of category" do
    ingredient = Ingredient.new(name: "Test Ingredient")
    assert_not ingredient.valid?
    assert_includes ingredient.errors[:category], "can't be blank"
  end

  test "validates uniqueness of name" do
    existing = ingredients(:apple)
    duplicate = Ingredient.new(name: existing.name, category: "Fruit")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "has already been taken"
  end

  test "search_by_name finds matching ingredients" do
    results = Ingredient.search_by_name("apple")
    assert results.any?
    assert results.all? { |i| i.name.downcase.start_with?("apple") }
  end

  test "search_by_name is case insensitive" do
    lower_results = Ingredient.search_by_name("apple")
    upper_results = Ingredient.search_by_name("APPLE")
    assert_equal lower_results.pluck(:id).sort, upper_results.pluck(:id).sort
  end

  test "has_effect? returns true for ingredients with effects" do
    spicy_pepper = ingredients(:spicy_pepper)
    assert spicy_pepper.has_effect?
  end

  test "has_effect? returns false for ingredients without effects" do
    apple = ingredients(:apple)
    assert_not apple.has_effect?
  end

  test "duration_modifier returns correct values" do
    apple = ingredients(:apple)
    assert_equal 30, apple.duration_modifier

    cane_sugar = ingredients(:cane_sugar)
    assert_equal 60, cane_sugar.duration_modifier
  end

  test "critical_cook_guaranteed? returns true for Critical_Cook boost type" do
    golden_apple = ingredients(:golden_apple)
    assert golden_apple.critical_cook_guaranteed?
  end

  test "critical_cook_guaranteed? returns false for regular ingredients" do
    apple = ingredients(:apple)
    assert_not apple.critical_cook_guaranteed?
  end
end
