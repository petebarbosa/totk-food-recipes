class CreateIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :ingredients do |t|
      t.string :name, null: false, index: { unique: true }
      t.string :category, null: false
      t.decimal :hearts_raw, precision: 3, scale: 1, default: 0
      t.string :effect_type
      t.integer :effect_points, default: 0
      t.string :boost_type
      t.string :image_path
      t.timestamps
    end
  end
end
