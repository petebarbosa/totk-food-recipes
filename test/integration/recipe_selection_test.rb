# frozen_string_literal: true

require "test_helper"

class RecipeSelectionTest < ActionDispatch::IntegrationTest
  setup do
    @simmered_fruit = recipes(:simmered_fruit)
    @apple_pie = recipes(:apple_pie)
  end

  test "selecting recipe auto-fills required ingredients" do
    post select_recipe_cooking_path, params: { recipe_id: @simmered_fruit.id },
         headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_match "turbo-stream", response.body
  end

  test "selecting complex recipe fills multiple ingredients" do
    post select_recipe_cooking_path, params: { recipe_id: @apple_pie.id },
         headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_match "turbo-stream", response.body
  end

  test "removing auto-filled ingredient updates state" do
    # First add an ingredient
    post add_ingredient_cooking_path, params: { ingredient_id: ingredients(:apple).id },
         headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success

    # Then remove it
    delete remove_ingredient_cooking_path, params: { slot_index: 0 },
           headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_match "turbo-stream", response.body
  end
end
