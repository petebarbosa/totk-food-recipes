import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slot", "form"]

  connect() {
    // Cooking controller coordinates UI updates via Turbo Streams
  }

  async removeIngredient(event) {
    event.preventDefault()
    event.stopPropagation()
    const slotIndex = event.currentTarget.dataset.slotIndex

    try {
      const response = await fetch("/cooking/remove_ingredient", {
        method: "DELETE",
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: `slot_index=${slotIndex}`
      })

      if (response.ok) {
        const html = await response.text()
        Turbo.renderStreamMessage(html)
      }
    } catch (error) {
      console.error("Remove ingredient error:", error)
    }
  }

  async clearPot(event) {
    event.preventDefault()

    try {
      const response = await fetch("/cooking/clear", {
        method: "DELETE",
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        }
      })

      if (response.ok) {
        const html = await response.text()
        Turbo.renderStreamMessage(html)
      }
    } catch (error) {
      console.error("Clear pot error:", error)
    }
  }

  async selectRecipe(event) {
    event.preventDefault()
    const recipeId = event.currentTarget.dataset.recipeId

    try {
      const response = await fetch("/cooking/select_recipe", {
        method: "POST",
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: `recipe_id=${recipeId}`
      })

      if (response.ok) {
        const html = await response.text()
        Turbo.renderStreamMessage(html)
      }
    } catch (error) {
      console.error("Select recipe error:", error)
    }
  }
}
