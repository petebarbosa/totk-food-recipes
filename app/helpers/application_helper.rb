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

  def ingredient_image_path(ingredient)
    filename = ingredient.name.downcase.gsub(/[^a-z0-9]+/, "_").gsub(/^_|_$/, "") + ".png"
    "ingredients/#{filename}"
  end

  def ingredient_image_tag(ingredient, size: :medium, **html_options)
    path = ingredient_image_path(ingredient)

    if image_exists?(path)
      size_classes = case size
      when :small then "w-6 h-6"
      when :medium then "w-10 h-10"
      when :large then "w-16 h-16"
      else "w-10 h-10"
      end

      default_options = {
        class: "#{size_classes} object-contain #{html_options[:class]}".strip,
        alt: ingredient.name,
        title: ingredient.name
      }

      image_tag(path, default_options.merge(html_options.except(:class)))
    else
      content_tag(:span, ingredient_emoji(ingredient), class: "text-2xl", title: ingredient.name)
    end
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

  def recipe_image_path(recipe_or_name)
    name = recipe_or_name.is_a?(String) ? recipe_or_name : recipe_or_name.name
    filename = name.downcase.gsub(/[^a-z0-9]+/, "_").gsub(/^_|_$/, "") + ".png"
    "recipes/#{filename}"
  end

  def recipe_image_tag(recipe_or_name, size: :medium, **html_options)
    name = recipe_or_name.is_a?(String) ? recipe_or_name : recipe_or_name.name
    path = recipe_image_path(recipe_or_name)

    if image_exists?(path)
      size_classes = case size
      when :small then "w-8 h-8"
      when :medium then "w-12 h-12"
      when :large then "w-20 h-20"
      else "w-12 h-12"
      end

      default_options = {
        class: "#{size_classes} object-contain #{html_options[:class]}".strip,
        alt: name,
        title: name
      }

      image_tag(path, default_options.merge(html_options.except(:class)))
    else
      content_tag(:span, "🥘", class: "text-2xl", title: name)
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

  private

  def image_exists?(path)
    Rails.application.assets.load_path.find(path).present?
  rescue StandardError
    false
  end
end
