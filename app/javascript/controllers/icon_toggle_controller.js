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
}
