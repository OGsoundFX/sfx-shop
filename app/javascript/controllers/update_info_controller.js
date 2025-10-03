import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="update-info"
export default class extends Controller {
  static targets = ["data", "form"]

  toggleEdit() {
    this.formTarget.classList.toggle("d-none");
    this.dataTarget.classList.toggle("d-none");
  }
}
