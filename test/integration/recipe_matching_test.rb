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

  test "multiple ingredients narrows down recipe list" do
    get recipes_path, params: { ingredient_ids: [@apple.id, @hylian_shroom.id] }
    assert_response :success
  end
end
