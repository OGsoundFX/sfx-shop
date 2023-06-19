import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["leftBorder", "text", "form"]

  connect() {
  }
  
  hover() {
    this.textTarget.classList.remove("d-none")
    this.leftBorderTarget.classList.remove("d-none")
  }
  
  mouseout() {
    this.textTarget.classList.add("d-none")
    this.leftBorderTarget.classList.add("d-none")
  }

  toggleForm() {
    this.formTarget.classList.toggle("d-none")
    this.formTarget.classList.toggle("d-flex")
  }
}
