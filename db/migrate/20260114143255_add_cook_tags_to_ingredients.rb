# frozen_string_literal: true

class AddCookTagsToIngredients < ActiveRecord::Migration[8.1]
  def change
    add_column :ingredients, :cook_tags, :json, default: []
  end
end
