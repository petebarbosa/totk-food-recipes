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

  test "search_by_name finds ingredients where any word starts with query" do
    results = Ingredient.search_by_name("apple")
    assert results.any?
    assert results.all? { |i|
      i.name.downcase.split.any? { |word| word.start_with?("apple") }
    }
  end

  test "search_by_name is case insensitive" do
    lower_results = Ingredient.search_by_name("apple")
    upper_results = Ingredient.search_by_name("APPLE")
    assert_equal lower_results.pluck(:id).sort, upper_results.pluck(:id).sort
  end

  test "search_by_name matches word starts for single character" do
    # Single char should match words starting with that letter, not mid-word
    # Fixtures: "Apple", "Golden Apple" - both have words starting with 'a'
    results = Ingredient.search_by_name("a")

    assert results.any?
    # All results should have a word starting with 'a'
    assert results.all? { |i|
      i.name.downcase.split.any? { |word| word.start_with?("a") }
    }
  end

  test "search_by_name matches word starts for multiple characters" do
    # Fixtures have both "Apple" and "Golden Apple"
    results = Ingredient.search_by_name("apple")
    result_names = results.pluck(:name)

    assert_includes result_names, "Apple"
    assert_includes result_names, "Golden Apple"
    assert_equal 2, results.count
  end

  test "search_by_name does not match mid-word for any query length" do
    # "Light Dragon's Claw" should NOT match "g" because 'g' is mid-word in "Dragon's"
    results_g = Ingredient.search_by_name("g")
    assert_not_includes results_g.pluck(:name), "Light Dragon's Claw"
    # But should include things like "Golden Apple" where 'g' starts a word
    assert_includes results_g.pluck(:name), "Golden Apple"

    # "Light Dragon's Claw" should NOT match "rag" (mid-word in "Dragon's")
    results_rag = Ingredient.search_by_name("rag")
    assert_not_includes results_rag.pluck(:name), "Light Dragon's Claw"
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
