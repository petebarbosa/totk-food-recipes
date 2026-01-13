module ApplicationHelper
  CATEGORY_EMOJIS = {
    "Fruit" => "🍎",
    "Vegetable" => "🥕",
    "Mushroom" => "🍄",
    "Meat" => "🥩",
    "Fish" => "🐟",
    "Herb" => "🌿",
    "Critter" => "🦎",
    "Monster Part" => "👹",
    "Mineral" => "💎",
    "Seasoning" => "🧂",
    "Grain" => "🌾",
    "Flower" => "🌸",
    "Dairy" => "🧈"
  }.freeze

  def ingredient_emoji(ingredient)
    CATEGORY_EMOJIS[ingredient.category] || "🍽️"
  end

  def format_duration(seconds)
    minutes = seconds / 60
    remaining_seconds = seconds % 60

    if remaining_seconds > 0
      "#{minutes}:%02d" % remaining_seconds
    else
      "#{minutes}:00"
    end
  end

  def effect_color_class(effect_type)
    case effect_type
    when "Cold Resistance" then "text-blue-400"
    when "Heat Resistance" then "text-orange-400"
    when "Shock Resistance" then "text-yellow-400"
    when "Attack Up" then "text-red-400"
    when "Defense Up" then "text-cyan-400"
    when "Stealth Up" then "text-purple-400"
    when "Speed Up" then "text-green-400"
    when "Extra Hearts" then "text-pink-400"
    when "Stamina Recovery" then "text-lime-400"
    when "Glow" then "text-amber-400"
    else "text-stone-400"
    end
  end
end
