import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="copy-token-to-clipboard"
export default class extends Controller {
  static values = {
    token: String
  }
  copyToken() {
    navigator.clipboard.writeText(this.tokenValue)
  }
}
