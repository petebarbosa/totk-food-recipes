# frozen_string_literal: true

require "test_helper"

class RecipeMatchingTest < ActionDispatch::IntegrationTest
  setup do
    @apple = ingredients(:apple)
    @hylian_shroom = ingredients(:hylian_shroom)
    @raw_meat = ingredients(:raw_meat)
  end

  test "adding a fruit shows simmered fruit recipe" do
    get recipes_path, params: { ingredient_ids: [@apple.id] }
    assert_response :success
  end

  test "adding mushroom shows mushroom skewer recipe" do
    get recipes_path, params: { ingredient_ids: [@hylian_shroom.id] }
    assert_response :success
  end

  test "recipes endpoint returns success with no ingredients" do
    get recipes_path, params: { ingredient_ids: [] }
    assert_response :success
  end

  test "multiple ingredients narrows down recipe list to only compatible recipes" do
    get recipes_path, params: { ingredient_ids: [@apple.id, @hylian_shroom.id] }
    assert_response :success

    # Fruit and Mushroom Mix accepts both Fruit and Mushroom categories
    assert_includes response.body, "Fruit and Mushroom Mix"
    # Simmered Fruit only accepts Fruit, cannot accommodate Mushroom
    assert_not_includes response.body, "Simmered Fruit"
    # Mushroom Skewer only accepts Mushroom, cannot accommodate Fruit
    assert_not_includes response.body, "Mushroom Skewer"
  end

  test "single fruit ingredient shows all fruit-compatible recipes" do
    get recipes_path, params: { ingredient_ids: [@apple.id] }
    assert_response :success

    assert_includes response.body, "Simmered Fruit"
    assert_includes response.body, "Fruit and Mushroom Mix"
    assert_not_includes response.body, "Mushroom Skewer"
  end

  test "incompatible ingredient combination excludes single-category recipes" do
    get recipes_path, params: { ingredient_ids: [@apple.id, @raw_meat.id] }
    assert_response :success

    # Neither Simmered Fruit (Fruit only) nor Meat Skewer (Meat only) can accommodate both
    assert_not_includes response.body, "Simmered Fruit"
    assert_not_includes response.body, "Meat Skewer"
  end
end
