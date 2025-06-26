// app/javascript/controllers/modal_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.hide()
  }

  show(event) {
    event.preventDefault()
    this.containerTarget.classList.remove("hidden")
    this.containerTarget.classList.add("fade-in")
    this.containerTarget.setAttribute("aria-hidden", "false")
  }

  hide() {
    this.containerTarget.classList.remove("fade-in")
    this.containerTarget.classList.add("hidden")
    this.containerTarget.setAttribute("aria-hidden", "true")
  }

  closeOnOutsideClick(event) {
    if (event.target === this.containerTarget) {
      this.hide()
    }
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.hide()
    }
  }
}
