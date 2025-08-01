import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="submission-image-preview"
export default class extends Controller {
  static targets = ["input", "preview"]
  
  preview() {
    const file = this.inputTarget.files[0]
    console.log(file)
    if (file) {
      const reader = new FileReader()

      reader.onload = (e) => {
        this.previewTarget.src = e.target.result
      }

      reader.readAsDataURL(file)
    }
  }
}
