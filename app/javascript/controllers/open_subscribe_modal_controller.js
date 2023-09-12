import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["subscribeForm", "button"]

  open(event) {
    this.subscribeFormTarget.classList.remove("d-none")
    event.currentTarget.classList.add("d-none")
  }

  close() {
    this.subscribeFormTarget.classList.add("d-none")
    this.buttonTarget.classList.remove("d-none")
  }
}
