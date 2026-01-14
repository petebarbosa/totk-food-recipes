# frozen_string_literal: true

require "test_helper"

class RecipeMatchingTest < ActionDispatch::IntegrationTest
  setup do
    @apple = ingredients(:apple)
    @hylian_shroom = ingredients(:hylian_shroom)
    @raw_meat = ingredients(:raw_meat)
  end

  test "adding a fruit shows simmered fruit recipe" do
    get recipes_path, params: { ingredient_ids: [ @apple.id ] }
    assert_response :success
    assert_includes response.body, "Simmered Fruit"
  end

  test "adding mushroom shows mushroom skewer recipe" do
    get recipes_path, params: { ingredient_ids: [ @hylian_shroom.id ] }
    assert_response :success
    assert_includes response.body, "Mushroom Skewer"
  end

  test "recipes endpoint returns success with no ingredients" do
    get recipes_path, params: { ingredient_ids: [] }
    assert_response :success
  end

  test "two ingredients matching one recipe only shows that recipe" do
    get recipes_path, params: { ingredient_ids: [ @apple.id, @hylian_shroom.id ] }
    assert_response :success

    # Fruit and Mushroom Mix uses both ingredients - should show
    assert_includes response.body, "Fruit and Mushroom Mix"
    # Single-ingredient recipes should NOT show when a better match exists
    assert_not_includes response.body, "Simmered Fruit"
    assert_not_includes response.body, "Mushroom Skewer"
  end

  test "single ingredient shows fully matched and promising partial recipes" do
    get recipes_path, params: { ingredient_ids: [ @apple.id ] }
    assert_response :success

    # Simmered Fruit is fully matched
    assert_includes response.body, "Simmered Fruit"
    # Fruit and Mushroom Mix is a promising partial (could use more ingredients)
    assert_includes response.body, "Fruit and Mushroom Mix"
    # Mushroom Skewer doesn't match apple
    assert_not_includes response.body, "Mushroom Skewer"
  end

  test "when no recipe uses all ingredients both matches show" do
    get recipes_path, params: { ingredient_ids: [ @apple.id, @raw_meat.id ] }
    assert_response :success

    # No recipe uses both Apple and Raw Meat
    # Both single-ingredient recipes are "best" fully matched (use 1 each)
    assert_includes response.body, "Simmered Fruit"
    assert_includes response.body, "Meat Skewer"
  end
end
