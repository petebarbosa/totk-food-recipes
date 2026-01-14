# frozen_string_literal: true

class RecipeRequirement < ApplicationRecord
  REQUIREMENT_TYPES = %w[category specific logic].freeze

  belongs_to :recipe
  belongs_to :ingredient, optional: true

  validates :requirement_type, presence: true, inclusion: { in: REQUIREMENT_TYPES }
  validates :requirement_value, presence: true

  scope :category_requirements, -> { where(requirement_type: "category") }
  scope :specific_requirements, -> { where(requirement_type: "specific") }
  scope :logic_requirements, -> { where(requirement_type: "logic") }

  def matches?(ingredient)
    case requirement_type
    when "category"
      ingredient.matches_requirement?(requirement_value)
    when "specific"
      ingredient.name == requirement_value
    when "logic"
      false
    else
      false
    end
  end
end
