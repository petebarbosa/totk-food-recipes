# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_13_201214) do
  create_table "ingredients", force: :cascade do |t|
    t.string "boost_type"
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.integer "effect_points", default: 0
    t.string "effect_type"
    t.decimal "hearts_raw", precision: 3, scale: 1, default: "0.0"
    t.string "image_path"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_ingredients_on_name", unique: true
  end

  create_table "recipe_requirements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "ingredient_id"
    t.integer "recipe_id", null: false
    t.string "requirement_type", null: false
    t.string "requirement_value", null: false
    t.datetime "updated_at", null: false
    t.index ["ingredient_id"], name: "index_recipe_requirements_on_ingredient_id"
    t.index ["recipe_id", "requirement_type", "requirement_value"], name: "idx_recipe_req_lookup"
    t.index ["recipe_id"], name: "index_recipe_requirements_on_recipe_id"
  end

  create_table "recipes", force: :cascade do |t|
    t.integer "base_hearts", default: 0
    t.datetime "created_at", null: false
    t.string "image_path"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_recipes_on_name", unique: true
  end

  add_foreign_key "recipe_requirements", "ingredients"
  add_foreign_key "recipe_requirements", "recipes"
end
