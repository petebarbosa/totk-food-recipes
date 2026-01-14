# frozen_string_literal: true

require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "ingredient_image_path generates correct path from name" do
    ingredient = ingredients(:apple)
    assert_equal "ingredients/apple.png", ingredient_image_path(ingredient)
  end

  test "ingredient_image_path handles multi-word names" do
    ingredient = ingredients(:golden_apple)
    assert_equal "ingredients/golden_apple.png", ingredient_image_path(ingredient)
  end

  test "ingredient_image_path handles special characters" do
    ingredient = Ingredient.new(name: "Fleet-Lotus Seeds", category: "Fruit")
    assert_equal "ingredients/fleet_lotus_seeds.png", ingredient_image_path(ingredient)
  end

  test "ingredient_image_path handles apostrophes" do
    ingredient = ingredients(:light_dragons_claw)
    assert_equal "ingredients/light_dragon_s_claw.png", ingredient_image_path(ingredient)
  end

  test "ingredient_image_tag returns image tag when image exists" do
    ingredient = ingredients(:apple)
    result = ingredient_image_tag(ingredient)
    assert_includes result, "<img"
    assert_includes result, 'alt="Apple"'
    assert_includes result, 'title="Apple"'
  end

  test "ingredient_image_tag returns emoji fallback when image missing" do
    ingredient = Ingredient.new(name: "NonExistent Item", category: "Fruit")
    result = ingredient_image_tag(ingredient)
    assert_includes result, "🍎"
    assert_includes result, "<span"
  end

  test "ingredient_image_tag applies size classes" do
    ingredient = ingredients(:apple)

    small_result = ingredient_image_tag(ingredient, size: :small)
    assert_includes small_result, "w-6 h-6"

    medium_result = ingredient_image_tag(ingredient, size: :medium)
    assert_includes medium_result, "w-10 h-10"

    large_result = ingredient_image_tag(ingredient, size: :large)
    assert_includes large_result, "w-16 h-16"
  end

  # Recipe image helper tests
  test "recipe_image_path generates correct path from recipe" do
    recipe = recipes(:apple_pie)
    assert_equal "recipes/apple_pie.png", recipe_image_path(recipe)
  end

  test "recipe_image_path handles string input" do
    assert_equal "recipes/mushroom_skewer.png", recipe_image_path("Mushroom Skewer")
  end

  test "recipe_image_path handles special characters" do
    assert_equal "recipes/salt_grilled_meat.png", recipe_image_path("Salt-Grilled Meat")
  end

  test "recipe_image_tag returns image tag when image exists" do
    recipe = recipes(:apple_pie)
    result = recipe_image_tag(recipe)
    assert_includes result, "<img"
    assert_includes result, 'alt="Apple Pie"'
  end

  test "recipe_image_tag returns emoji fallback when image missing" do
    result = recipe_image_tag("NonExistent Recipe")
    assert_includes result, "🥘"
    assert_includes result, "<span"
  end

  test "recipe_image_tag applies size classes" do
    recipe = recipes(:apple_pie)

    small_result = recipe_image_tag(recipe, size: :small)
    assert_includes small_result, "w-8 h-8"

    medium_result = recipe_image_tag(recipe, size: :medium)
    assert_includes medium_result, "w-12 h-12"

    large_result = recipe_image_tag(recipe, size: :large)
    assert_includes large_result, "w-20 h-20"
  end
end
