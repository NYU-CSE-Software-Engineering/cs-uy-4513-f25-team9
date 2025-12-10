import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["row"]

  connect() {
    // Controller connected
  }

  handleRemove(event) {
    // Optional: Add loading state or animation
    const button = event.currentTarget
    const row = button.closest('[data-moderation-target="row"]')
    
    if (row) {
      // Add a subtle fade effect before removal
      row.style.opacity = "0.6"
      row.style.transition = "opacity 0.2s"
    }
  }
}



