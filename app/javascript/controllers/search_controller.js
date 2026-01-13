import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "item"]

  connect() {
    this.selectedIndex = -1
    this.debounceTimer = null

    // Close dropdown when clicking outside
    this.clickOutsideHandler = this.handleClickOutside.bind(this)
    document.addEventListener("click", this.clickOutsideHandler)
  }

  disconnect() {
    document.removeEventListener("click", this.clickOutsideHandler)
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
    }
  }

  query() {
    if (this.debounceTimer) {
      clearTimeout(this.debounceTimer)
    }

    this.debounceTimer = setTimeout(() => {
      this.performSearch()
    }, 300)
  }

  async performSearch() {
    const query = this.inputTarget.value.trim()

    if (query.length === 0) {
      this.clearResults()
      return
    }

    try {
      const response = await fetch(`/ingredients/search?query=${encodeURIComponent(query)}`, {
        headers: {
          Accept: "text/vnd.turbo-stream.html"
        }
      })

      if (response.ok) {
        const html = await response.text()
        Turbo.renderStreamMessage(html)
        this.selectedIndex = -1
      }
    } catch (error) {
      console.error("Search error:", error)
    }
  }

  handleKeydown(event) {
    const items = this.itemTargets

    switch (event.key) {
      case "ArrowDown":
        event.preventDefault()
        this.selectedIndex = Math.min(this.selectedIndex + 1, items.length - 1)
        this.updateSelection()
        break

      case "ArrowUp":
        event.preventDefault()
        this.selectedIndex = Math.max(this.selectedIndex - 1, -1)
        this.updateSelection()
        break

      case "Enter":
        event.preventDefault()
        if (this.selectedIndex >= 0 && items[this.selectedIndex]) {
          const ingredientCard = items[this.selectedIndex].querySelector(".ingredient-card")
          if (ingredientCard) {
            ingredientCard.click()
          }
        }
        break

      case "Escape":
        this.close()
        break
    }
  }

  updateSelection() {
    this.itemTargets.forEach((item, index) => {
      if (index === this.selectedIndex) {
        item.querySelector(".ingredient-card")?.classList.add("ring-2", "ring-amber-500")
      } else {
        item.querySelector(".ingredient-card")?.classList.remove("ring-2", "ring-amber-500")
      }
    })
  }

  close() {
    this.clearResults()
    this.inputTarget.value = ""
    this.selectedIndex = -1
  }

  async addIngredient(event) {
    const ingredientId = event.currentTarget.dataset.ingredientId

    try {
      const response = await fetch("/cooking/add_ingredient", {
        method: "POST",
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: `ingredient_id=${ingredientId}`
      })

      if (response.ok) {
        const html = await response.text()
        Turbo.renderStreamMessage(html)
      }
    } catch (error) {
      console.error("Add ingredient error:", error)
    }

    this.close()
  }

  clearResults() {
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = ""
    }
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.clearResults()
    }
  }
}
