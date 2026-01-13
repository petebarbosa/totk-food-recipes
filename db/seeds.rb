# frozen_string_literal: true

require "csv"

puts "🌱 Starting Seed..."

puts "   Cleaning old records..."
RecipeRequirement.destroy_all
Recipe.destroy_all
Ingredient.destroy_all

ingredients_file = Rails.root.join("db", "csv", "ingredients.csv")
recipes_file = Rails.root.join("db", "csv", "recipes.csv")

puts "   Cooking up Ingredients..."
CSV.foreach(ingredients_file, headers: true) do |row|
  Ingredient.create!(
    name: row["Name"],
    category: row["Category"],
    hearts_raw: row["Hearts_Raw"].to_f,
    effect_type: row["Effect_Type"] == "None" ? nil : row["Effect_Type"],
    effect_points: row["Effect_Points"].to_i,
    boost_type: row["Boost_Type"] == "None" ? nil : row["Boost_Type"]
  )
end
puts "   ✅ Created #{Ingredient.count} ingredients"

puts "   Writing Recipes..."
CSV.foreach(recipes_file, headers: true) do |row|
  recipe = Recipe.create!(
    name: row["Recipe_Name"],
    base_hearts: row["Base_Hearts"].to_i
  )

  # Parse requirements string like "[Category:Fruit];[Specific:Apple];[Logic:Incompatible Ingredients]"
  requirements_string = row["Required_Ingredients"]
  next if requirements_string.blank?

  requirements_string.split(";").each do |req|
    # Extract type and value from "[Type:Value]" format
    match = req.match(/\[(\w+):(.+?)\]/)
    next unless match

    type = match[1].downcase
    value = match[2]

    # For specific requirements, try to link to the actual ingredient
    ingredient = nil
    if type == "specific"
      ingredient = Ingredient.find_by(name: value)
    end

    RecipeRequirement.create!(
      recipe: recipe,
      requirement_type: type,
      requirement_value: value,
      ingredient: ingredient
    )
  end
end
puts "   ✅ Created #{Recipe.count} recipes"
puts "   ✅ Created #{RecipeRequirement.count} recipe requirements"

puts "🎉 Seeding complete!"
