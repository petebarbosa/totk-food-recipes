class CreateRecipeRequirements < ActiveRecord::Migration[8.1]
  def change
    create_table :recipe_requirements do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :ingredient, foreign_key: true
      t.string :requirement_type, null: false
      t.string :requirement_value, null: false
      t.timestamps
    end

    add_index :recipe_requirements, [:recipe_id, :requirement_type, :requirement_value], name: 'idx_recipe_req_lookup'
  end
end
