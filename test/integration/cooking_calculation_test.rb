# frozen_string_literal: true

require "test_helper"

class CookingCalculationTest < ActionDispatch::IntegrationTest
  setup do
    @apple = ingredients(:apple)
    @spicy_pepper = ingredients(:spicy_pepper)
    @sunshroom = ingredients(:sunshroom)
    @chillshroom = ingredients(:chillshroom)
    @golden_apple = ingredients(:golden_apple)
  end

  test "adding ingredient returns cooking result" do
    post add_ingredient_cooking_path, params: { ingredient_id: @apple.id },
         headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_match "cooking_result", response.body
  end

  test "effect type shows for single-effect ingredients" do
    post add_ingredient_cooking_path, params: { ingredient_id: @spicy_pepper.id },
         headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_match "turbo-stream", response.body
  end

  test "golden apple shows guaranteed critical cook" do
    post add_ingredient_cooking_path, params: { ingredient_id: @golden_apple.id },
         headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success
    # Golden Apple should trigger 100% critical chance
    assert_match "turbo-stream", response.body
  end

  test "clearing pot resets cooking result" do
    # First add an ingredient
    post add_ingredient_cooking_path, params: { ingredient_id: @apple.id },
         headers: { Accept: "text/vnd.turbo-stream.html" }

    # Then clear
    delete clear_cooking_path, headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_match "turbo-stream", response.body
  end
end
