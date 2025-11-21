import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="items-sold"
export default class extends Controller {
  static targets = ["soldItems"]
  modal() {
    this.soldItemsTarget.classList.toggle("d-none")
  }
  close() {
    this.soldItemsTarget.classList.add("d-none")
  }
}
