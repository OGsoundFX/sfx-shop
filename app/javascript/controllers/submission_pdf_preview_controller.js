import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="submission-pdf-preview"
export default class extends Controller {
  static targets = ["filename"]

  preview(event) {
    this.filenameTarget.innerText = event.currentTarget.files[0].name
  }
}
