class CreateRecipes < ActiveRecord::Migration[8.1]
  def change
    create_table :recipes do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :base_hearts, default: 0
      t.string :image_path
      t.timestamps
    end
  end
end
