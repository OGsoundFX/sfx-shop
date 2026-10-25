import { Controller } from "stimulus"

export default class extends Controller {
  static targets = []

  connect() {
  }

  toggleIcon(event) {
    const icon = event.currentTarget.querySelector("i")
    if (icon.classList.contains("fa-ban")) {
      icon.classList.remove("fa-ban")
      icon.classList.add("fa-layer-group")
      icon.style = "color: #4e4e4e"
    } else if (icon.classList.contains("fa-layer-group")) {
      icon.classList.remove("fa-layer-group")
      icon.classList.add("fa-ban")
      icon.style = "color: #FFA500"
    }
  }

  toggleAddToCartIcon(event) {
    const icon = event.currentTarget.querySelector("i")
    if (icon.classList.contains("fa-trash-alt")) {
      icon.classList.remove("fa-trash-alt")
      icon.classList.add("fa-cart-plus")
      icon.style = "color: #4e4e4e; opacity: 1"
    } else if (icon.classList.contains("fa-cart-plus")) {
      icon.classList.remove("fa-cart-plus")
      icon.classList.add("fa-trash-alt")
      icon.style = "color: #999999"
    }
  }
}
