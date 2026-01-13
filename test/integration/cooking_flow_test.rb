# frozen_string_literal: true

require "test_helper"

class CookingFlowTest < ActionDispatch::IntegrationTest
  setup do
    @apple = ingredients(:apple)
    @hylian_shroom = ingredients(:hylian_shroom)
    @simmered_fruit = recipes(:simmered_fruit)
  end

  test "complete flow - search add see recipes" do
    # Search for ingredients
    get search_ingredients_path, params: { query: "Apple" },
        headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success

    # Add ingredient to pot
    post add_ingredient_cooking_path, params: { ingredient_id: @apple.id },
         headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_match "cooking_pot", response.body
    assert_match "recipe_results", response.body
    assert_match "cooking_result", response.body
  end

  test "clear pot resets everything" do
    # Add ingredient first
    post add_ingredient_cooking_path, params: { ingredient_id: @apple.id },
         headers: { Accept: "text/vnd.turbo-stream.html" }

    # Clear the pot
    delete clear_cooking_path, headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_match "cooking_pot", response.body
  end

  test "multiple ingredients can be added sequentially" do
    # Add first ingredient
    post add_ingredient_cooking_path, params: { ingredient_id: @apple.id },
         headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success

    # Add second ingredient
    post add_ingredient_cooking_path, params: { ingredient_id: @hylian_shroom.id },
         headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success
  end

  test "cannot add more than 5 ingredients" do
    # Add 5 ingredients
    5.times do
      post add_ingredient_cooking_path, params: { ingredient_id: @apple.id },
           headers: { Accept: "text/vnd.turbo-stream.html" }
    end

    # Try to add a 6th - should still succeed but not add
    post add_ingredient_cooking_path, params: { ingredient_id: @apple.id },
         headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success
  end

  test "home page loads successfully" do
    get root_path
    assert_response :success
    assert_select "h1", /TotK Recipe Calculator/
  end
end
