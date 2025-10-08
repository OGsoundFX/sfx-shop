import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="photo-upload"
export default class extends Controller {
  static targets = ["input", "form", "icon"]

  trigger() {
    this.formTarget.classList.remove("d-none")
    this.iconTarget.classList.add("d-none")
  }
}
