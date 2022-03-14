import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["packsUnwrapped", "packsWrapped"]

  connect() {
  }

  wrap() {
    this.packsUnwrappedTarget.classList.toggle("d-none")
    this.packsWrappedTarget.classList.toggle("d-none")
  }

}