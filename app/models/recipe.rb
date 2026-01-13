# frozen_string_literal: true

class Recipe < ApplicationRecord
  has_many :recipe_requirements, dependent: :destroy
  has_many :specific_ingredients, -> { distinct }, through: :recipe_requirements, source: :ingredient

  validates :name, presence: true, uniqueness: true

  scope :matching_ingredient, ->(ingredient) {
    joins(:recipe_requirements)
      .where(
        "(recipe_requirements.requirement_type = 'category' AND recipe_requirements.requirement_value = ?) OR " \
        "(recipe_requirements.requirement_type = 'specific' AND recipe_requirements.requirement_value = ?)",
        ingredient.category, ingredient.name
      )
      .distinct
  }

  scope :ordered_by_name, -> { order(:name) }

  scope :excluding_special, -> {
    where.not(name: ["Dubious Food", "Rock-Hard Food"])
  }

  def required_slots_count
    recipe_requirements.count
  end

  def requirements_summary
    recipe_requirements.map do |req|
      case req.requirement_type
      when "specific"
        req.requirement_value
      when "category"
        "Any #{req.requirement_value}"
      when "logic"
        req.requirement_value
      end
    end.join(", ")
  end

  def category_requirements
    recipe_requirements.where(requirement_type: "category")
  end

  def specific_requirements
    recipe_requirements.where(requirement_type: "specific")
  end

  def logic_requirements
    recipe_requirements.where(requirement_type: "logic")
  end

  def special_recipe?
    name.in?(["Dubious Food", "Rock-Hard Food"])
  end
end
