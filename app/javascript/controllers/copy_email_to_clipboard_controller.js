import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="copy-email-to-clipboard"
export default class extends Controller {
  static values = {
    email: String
  }

  static targets = ["copyMessage", "icon"]

  copy(event) {
    event.preventDefault()
    const email = this.emailValue
    navigator.clipboard.writeText(email)
      .then(() => {
        this.iconTarget.classList.remove("fa-copy")
        this.iconTarget.classList.add("fas", "fa-check")
        setTimeout(() => {
          this.iconTarget.classList.remove("fas", "fa-check")
          this.iconTarget.classList.add("fa-copy")
        }, 3000)
      })
      .catch((error) => {
        console.error('Failed to copy email to clipboard:', error)
      })
  }
}
