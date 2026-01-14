# frozen_string_literal: true

class Ingredient < ApplicationRecord
  CATEGORIES = %w[
    Fruit Vegetable Mushroom Meat Fish Herb Critter
    Monster\ Part Mineral Seasoning Grain Flower Dairy
  ].freeze

  EFFECT_TYPES = %w[
    None Cold\ Resistance Heat\ Resistance Shock\ Resistance
    Stamina\ Recovery Extra\ Hearts Extra\ Stamina Attack\ Up Defense\ Up
    Stealth\ Up Glow Speed\ Up Slip\ Resistance Gloom\ Recovery
    Gloom\ Resistance Flame\ Guard Hot\ Weather\ Attack
    Cold\ Weather\ Attack Stormy\ Weather\ Attack Swim\ Speed\ Up
  ].freeze

  BOOST_TYPES = %w[None Critical_Cook Duration_Up Duration_Small Duration_Large].freeze

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true

  scope :search_by_name, ->(query) {
    return none unless query.present?

    sanitized_query = query.downcase

    # Match if any word starts with the query (name starts with it, or a word after a space starts with it)
    where("LOWER(name) LIKE ? OR LOWER(name) LIKE ?", "#{sanitized_query}%", "% #{sanitized_query}%")
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

  def has_cook_tag?(tag)
    cook_tags.include?(tag)
  end

  def matches_requirement?(requirement_value)
    # Check if ingredient name matches exactly (specific requirement)
    return true if name == requirement_value

    # Check if any cook tag matches (category requirement)
    cook_tags.include?(requirement_value)
  end
end
