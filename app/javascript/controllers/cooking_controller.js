import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slot", "form"]

  connect() {
    // Cooking controller is mainly for coordinating UI updates
    // Most logic is handled server-side via Turbo Streams
  }

  addIngredient(event) {
    // Handled by Turbo Stream response
  }

  removeIngredient(event) {
    // Handled by Turbo Stream response
  }

  selectRecipe(event) {
    // Handled by Turbo Stream response
  }

  clear() {
    // Handled by Turbo Stream response
  }
}
