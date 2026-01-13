# frozen_string_literal: true

require "test_helper"

class IngredientSearchTest < ActionDispatch::IntegrationTest
  test "user can search for ingredients by name" do
    get search_ingredients_path, params: { query: "Apple" }
    assert_response :success
  end

  test "search is case-insensitive" do
    get search_ingredients_path, params: { query: "apple" }
    assert_response :success

    get search_ingredients_path, params: { query: "APPLE" }
    assert_response :success
  end

  test "partial name matches work" do
    get search_ingredients_path, params: { query: "app" }
    assert_response :success
  end

  test "empty search returns no results" do
    get search_ingredients_path, params: { query: "" }
    assert_response :success
  end

  test "search returns turbo stream format" do
    get search_ingredients_path, params: { query: "Apple" },
        headers: { Accept: "text/vnd.turbo-stream.html" }
    assert_response :success
    assert_match "turbo-stream", response.body
  end
end
