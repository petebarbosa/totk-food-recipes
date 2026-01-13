# frozen_string_literal: true

require "test_helper"

class RecipeRequirementTest < ActiveSupport::TestCase
  test "validates presence of requirement_type" do
    req = RecipeRequirement.new(recipe: recipes(:simmered_fruit), requirement_value: "Fruit")
    assert_not req.valid?
    assert_includes req.errors[:requirement_type], "can't be blank"
  end

  test "validates requirement_type inclusion" do
    req = RecipeRequirement.new(
      recipe: recipes(:simmered_fruit),
      requirement_type: "invalid",
      requirement_value: "Fruit"
    )
    assert_not req.valid?
    assert_includes req.errors[:requirement_type], "is not included in the list"
  end

  test "validates presence of requirement_value" do
    req = RecipeRequirement.new(recipe: recipes(:simmered_fruit), requirement_type: "category")
    assert_not req.valid?
    assert_includes req.errors[:requirement_value], "can't be blank"
  end

  test "matches? returns true for matching category" do
    req = recipe_requirements(:simmered_fruit_req)
    apple = ingredients(:apple)
    assert req.matches?(apple)
  end

  test "matches? returns false for non-matching category" do
    req = recipe_requirements(:simmered_fruit_req)
    raw_meat = ingredients(:raw_meat)
    assert_not req.matches?(raw_meat)
  end

  test "matches? returns true for matching specific ingredient" do
    req = recipe_requirements(:apple_pie_apple)
    apple = ingredients(:apple)
    assert req.matches?(apple)
  end

  test "matches? returns false for logic requirements" do
    req = recipe_requirements(:dubious_food_req)
    apple = ingredients(:apple)
    assert_not req.matches?(apple)
  end

  test "category_requirements scope returns only category type" do
    reqs = RecipeRequirement.category_requirements
    assert reqs.all? { |r| r.requirement_type == "category" }
  end

  test "specific_requirements scope returns only specific type" do
    reqs = RecipeRequirement.specific_requirements
    assert reqs.all? { |r| r.requirement_type == "specific" }
  end
end
