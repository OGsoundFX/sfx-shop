import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="banner-form"
export default class extends Controller {
  static targets = ["form", "icon"]

  displayForm() {
    this.formTarget.classList.remove("d-none")
    this.iconTarget.classList.add("d-none")
  }

  hideForm() {
    this.formTarget.classList.add("d-none")
    this.iconTarget.classList.remove("d-none")
  }
}
