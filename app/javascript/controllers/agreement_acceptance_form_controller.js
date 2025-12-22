import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="agreement-acceptance-form"
export default class extends Controller {
  static targets = ["submit"]

  toggle() {
    this.submitTarget.disabled = !this.submitTarget.disabled
  }
}
