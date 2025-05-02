import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["panel"]
  toggle(event) {
    console.log(this.panelTarget)
    if (event.currentTarget.classList.contains("fa-angle-down")) {
      event.currentTarget.classList.remove("fa-angle-down")
      event.currentTarget.classList.add("fa-angle-up")
      this.panelTarget.classList.remove("d-none")
      this.panelTarget.classList.add("d-flex")
    } else {
      event.currentTarget.classList.remove("fa-angle-up")
      event.currentTarget.classList.add("fa-angle-down")
      this.panelTarget.classList.remove("d-flex")
      this.panelTarget.classList.add("d-none")

    }
  }
}
