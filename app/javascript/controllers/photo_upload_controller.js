import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="photo-upload"
export default class extends Controller {
  static targets = ["input", "form", "icon"]

  trigger() {
    this.formTarget.classList.remove("d-none")
    this.iconTarget.classList.add("d-none")
  }

  hide(event) {
    event.stopPropagation()
    this.formTarget.classList.add("d-none")
    this.iconTarget.classList.remove("d-none")
  }
}
