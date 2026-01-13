# frozen_string_literal: true

class IngredientsController < ApplicationController
  def index
    @ingredients = Ingredient.order(:name)
    @ingredients = @ingredients.by_category(params[:category]) if params[:category].present?

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def search
    @ingredients = if params[:query].present?
      Ingredient.search_by_name(params[:query]).order(:name).limit(10)
    else
      Ingredient.none
    end

    respond_to do |format|
      format.turbo_stream
      format.html { render partial: "ingredients/search_results", locals: { ingredients: @ingredients } }
    end
  end
end
