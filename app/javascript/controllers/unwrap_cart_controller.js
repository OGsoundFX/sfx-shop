import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["packsUnwrapped", "packsWrapped"]

  connect() {
  }

  wrap(event) {
    console.log(event.target)
    if(event.target.id === "pack-arrow") {
      this.packsUnwrappedTarget.classList.toggle("d-none")
      this.packsWrappedTarget.classList.toggle("d-none")
    }
  }

}