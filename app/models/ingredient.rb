# frozen_string_literal: true

class Ingredient < ApplicationRecord
  CATEGORIES = %w[
    Fruit Vegetable Mushroom Meat Fish Herb Critter
    Monster\ Part Mineral Seasoning Grain Flower Dairy
  ].freeze

  EFFECT_TYPES = %w[
    None Cold\ Resistance Heat\ Resistance Shock\ Resistance
    Stamina\ Recovery Extra\ Hearts Attack\ Up Defense\ Up
    Stealth\ Up Glow Speed\ Up Slip\ Resistance Gloom\ Recovery
    Gloom\ Resistance
  ].freeze

  BOOST_TYPES = %w[None Critical_Cook Duration_Up Duration_Small Duration_Large].freeze

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true

  scope :search_by_name, ->(query) {
    where("LOWER(name) LIKE ?", "#{query.downcase}%") if query.present?
  }

  scope :by_category, ->(category) {
    where(category: category) if category.present?
  }

  scope :with_effect, ->(effect) {
    where(effect_type: effect) if effect.present?
  }

  def has_effect?
    effect_type.present? && effect_type != "None"
  end

  def duration_modifier
    case boost_type
    when "Duration_Up"
      60
    when "Duration_Large"
      190
    when "Duration_Small"
      70
    else
      30
    end
  end

  def critical_cook_guaranteed?
    boost_type == "Critical_Cook"
  end
end
