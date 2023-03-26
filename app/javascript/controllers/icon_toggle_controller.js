import { Controller } from "stimulus"

export default class extends Controller {
  static targets = []

  connect() {
  }

  toggleIcon(event) {
    const icon = event.currentTarget.querySelector("i")
    if (icon.classList.contains("fa-layer-minus")) {
      icon.classList.remove("fa-layer-minus")
      icon.classList.add("fa-layer-plus")
      icon.style = "color: #4e4e4e"
    } else if (icon.classList.contains("fa-layer-plus")) {
      icon.classList.remove("fa-layer-plus")
      icon.classList.add("fa-layer-minus")
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
