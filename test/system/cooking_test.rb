# frozen_string_literal: true

require "application_system_test_case"

class CookingTest < ApplicationSystemTestCase
  setup do
    # Ensure we have data from seeds or fixtures
  end

  test "visiting the home page" do
    visit root_path

    assert_selector "h1", text: /TotK Recipe Calculator/
    assert_selector "[data-controller='search']"
    assert_selector "#cooking_pot"
    assert_selector "#recipe_results"
    assert_selector "#cooking_result"
  end

  test "search input is present and functional" do
    visit root_path

    assert_selector "input[data-search-target='input']"
    assert_selector "input[placeholder='Type to search...']"
  end

  test "cooking pot displays 5 slots" do
    visit root_path

    within "#cooking_pot" do
      assert_selector ".cooking-slot", count: 5
    end
  end

  test "empty state shows helpful message" do
    visit root_path

    within "#recipe_results" do
      assert_text "Add ingredients to see matching recipes"
    end

    within "#cooking_result" do
      assert_text "Add ingredients to see cooking preview"
    end
  end

  test "clear button is present" do
    visit root_path

    assert_text "Clear"
  end
end
